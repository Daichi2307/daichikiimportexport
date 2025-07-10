package controllers;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import models.User;

import java.io.IOException;
import java.sql.*;
import java.time.Month;
import java.time.format.TextStyle;
import java.util.*;

@WebServlet("/salesAnalytics")
public class SalesAnalyticsServlet extends HttpServlet {

    private static final String DB_URL = "jdbc:mysql://localhost:3306/sdac"; // your DB url
    private static final String DB_USER = "root";  // your DB username
    private static final String DB_PASSWORD = "";  // your DB password

    @Override
    public void init() throws ServletException {
        try {
            Class.forName("com.mysql.cj.jdbc.Driver"); // updated driver class name
        } catch (ClassNotFoundException e) {
            throw new ServletException("MySQL JDBC driver not found", e);
        }
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if(session == null || session.getAttribute("user") == null) {
            response.sendRedirect("test_login.jsp");
            return;
        }

        String sellerPortId = ((User)session.getAttribute("user")).getPortId();

        List<Map<String, Object>> salesByProduct = new ArrayList<>();
        LinkedHashMap<String, Double> revenueByMonth = new LinkedHashMap<>();
        Map<String, Integer> reportedIssuesCount = new LinkedHashMap<>();

        // Initialize months with zero revenue
        for(int m = 1; m <= 12; m++) {
            Month monthEnum = Month.of(m);
            String monthName = monthEnum.getDisplayName(TextStyle.SHORT, Locale.ENGLISH);
            revenueByMonth.put(monthName, 0.0);
        }

        // Initialize known issue types
        List<String> issueTypes = Arrays.asList("Damage", "Wrong Product", "Delayed", "Still Not Received", "Missing");
        for(String issue : issueTypes) {
            reportedIssuesCount.put(issue, 0);
        }

        try (Connection con = DriverManager.getConnection(DB_URL, DB_USER, DB_PASSWORD)) {

            // 1. Sales count per product for seller
            String salesQuery = "SELECT p.product_name, COALESCE(SUM(o.quantity), 0) AS total_sales " +
                    "FROM products p LEFT JOIN orders o ON p.product_id = o.product_id " +
                    "WHERE p.seller_port_id = ? " +
                    "GROUP BY p.product_name";
            try (PreparedStatement ps = con.prepareStatement(salesQuery)) {
                ps.setString(1, sellerPortId);
                try (ResultSet rs = ps.executeQuery()) {
                    while(rs.next()) {
                        Map<String, Object> map = new HashMap<>();
                        map.put("productName", rs.getString("product_name"));
                        map.put("salesCount", rs.getInt("total_sales"));
                        salesByProduct.add(map);
                    }
                }
            }

            // 2. Monthly revenue for current year
            String revenueQuery = "SELECT MONTH(o.order_date) AS month_num, COALESCE(SUM(p.price * o.quantity), 0) AS revenue " +
                    "FROM orders o JOIN products p ON o.product_id = p.product_id " +
                    "WHERE p.seller_port_id = ? AND YEAR(o.order_date) = YEAR(CURDATE()) " +
                    "GROUP BY MONTH(o.order_date)";
            try (PreparedStatement ps = con.prepareStatement(revenueQuery)) {
                ps.setString(1, sellerPortId);
                try (ResultSet rs = ps.executeQuery()) {
                    while(rs.next()) {
                        int monthNum = rs.getInt("month_num");
                        double revenue = rs.getDouble("revenue");
                        Month monthEnum = Month.of(monthNum);
                        String monthName = monthEnum.getDisplayName(TextStyle.SHORT, Locale.ENGLISH);
                        revenueByMonth.put(monthName, revenue);
                    }
                }
            }

            // 3. Reported issues count by type
            String issuesQuery = "SELECT issue_type, COUNT(*) AS issue_count " +
                    "FROM reported_products WHERE seller_port_id = ? GROUP BY issue_type";
            try (PreparedStatement ps = con.prepareStatement(issuesQuery)) {
                ps.setString(1, sellerPortId);
                try (ResultSet rs = ps.executeQuery()) {
                    while(rs.next()) {
                        String issueType = rs.getString("issue_type");
                        int count = rs.getInt("issue_count");
                        reportedIssuesCount.put(issueType, count);
                    }
                }
            }

        } catch (SQLException e) {
            e.printStackTrace();
            request.setAttribute("error", "Database error: " + e.getMessage());
        }

        request.setAttribute("salesByProduct", salesByProduct);
        request.setAttribute("revenueByMonth", revenueByMonth);
        request.setAttribute("reportedIssuesCount", reportedIssuesCount);

        request.getRequestDispatcher("seller_sales.jsp").forward(request, response);
    }
}
