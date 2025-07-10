package controllers;

import db_config.DbConnection;
import models.ReportedProducts;
import models.User;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.sql.*;
import java.sql.Date;
import java.util.*;

@WebServlet("/ReportedProductsController")
public class ReportedProductsController extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        HttpSession session = req.getSession(false);
        User user = (User) (session != null ? session.getAttribute("user") : null);
        if (user == null) {
            resp.sendRedirect("test_login.jsp");
            return;
        }

        String role = user.getRole();

        try (Connection conn = DbConnection.getConnection()) {
            if ("consumer".equalsIgnoreCase(role)) {
                handleConsumerView(req, conn, user.getPortId());
                req.getRequestDispatcher("track_orders.jsp").forward(req, resp);
            } else if ("seller".equalsIgnoreCase(role)) {
                handleSellerView(req, conn, user.getPortId());
                req.getRequestDispatcher("test_report.jsp").forward(req, resp);
            } else {
                resp.sendRedirect("error.jsp");
            }
        } catch (Exception e) {
            e.printStackTrace();
            req.setAttribute("error", "Error loading data: " + e.getMessage());
            req.getRequestDispatcher("error.jsp").forward(req, resp);
        }
    }

    private void handleConsumerView(HttpServletRequest req, Connection conn, String consumerId) throws SQLException {
        CallableStatement cs = conn.prepareCall("{CALL view_consumer_orders(?)}");
        cs.setString(1, consumerId);
        ResultSet rs = cs.executeQuery();

        List<models.Order> orderList = new ArrayList<>();
        while (rs.next()) {
            models.Order order = new models.Order();
            order.setOrderId(rs.getInt("order_id"));
            order.setProductId(rs.getInt("product_id"));
            order.setProductName(rs.getString("product_name"));
            order.setQuantity(rs.getInt("quantity"));
            order.setPrice(rs.getDouble("price"));
            order.setOrderDate(rs.getDate("order_date"));
            order.setShipped(rs.getBoolean("shipped"));
            order.setOutForDelivery(rs.getBoolean("out_for_delivery"));
            order.setDelivered(rs.getBoolean("delivered"));
            orderList.add(order);
        }
        rs.close();
        cs.close();
        req.setAttribute("orderList", orderList);

        // Fetch reported products for this consumer
        String reportQuery = "SELECT product_id FROM reported_products WHERE consumer_port_id = ? AND status = 'Pending'";
        PreparedStatement ps = conn.prepareStatement(reportQuery);
        ps.setString(1, consumerId);
        ResultSet rrs = ps.executeQuery();
        Map<Integer, Boolean> reportedStatusMap = new HashMap<>();
        while (rrs.next()) {
            reportedStatusMap.put(rrs.getInt("product_id"), true);
        }
        req.setAttribute("reportedStatusMap", reportedStatusMap);
        rrs.close();
        ps.close();
    }

    private void handleSellerView(HttpServletRequest req, Connection conn, String sellerId) throws SQLException {
        List<ReportedProducts> reportedList = new ArrayList<>();

        String sql = "SELECT report_id, consumer_port_id, product_id, issue_type, status, action_taken, report_date FROM reported_products WHERE seller_port_id = ?";
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, sellerId);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                ReportedProducts rp = new ReportedProducts();
                rp.setReport_id(rs.getInt("report_id"));
                rp.setConsumer_port_id(rs.getString("consumer_port_id"));
                rp.setProduct_id(rs.getInt("product_id"));
                rp.setIssue_type(rs.getString("issue_type"));
                rp.setStatus(rs.getString("status"));
                rp.setAction_taken(rs.getString("action_taken"));
                rp.setReport_date(rs.getDate("report_date"));
                reportedList.add(rp);
            }
            rs.close();
        }

        req.setAttribute("reportedList", reportedList);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String action = req.getParameter("action");

        if ("addReport".equals(action)) {
            handleAddReport(req, resp);
        } else if ("updateStatus".equals(action)) {
            handleUpdateStatus(req, resp);
        } else {
            resp.sendError(400, "Invalid action parameter");
        }
    }

    private void handleAddReport(HttpServletRequest req, HttpServletResponse resp) throws IOException, ServletException {
        try {
            String consumerId = req.getParameter("consumer_port_id");
            String issueType = req.getParameter("issue_type");
            String productIdStr = req.getParameter("product_id");

            if (productIdStr == null || consumerId == null || issueType == null) {
                req.setAttribute("error", "Missing required fields.");
                doGet(req, resp);
                return;
            }

            int productId = Integer.parseInt(productIdStr);
            try (Connection conn = DbConnection.getConnection()) {
                String sellerQuery = "SELECT seller_port_id FROM products WHERE product_id = ?";
                String sellerId;

                try (PreparedStatement ps = conn.prepareStatement(sellerQuery)) {
                    ps.setInt(1, productId);
                    ResultSet rs = ps.executeQuery();
                    if (!rs.next()) {
                        req.setAttribute("error", "Seller not found for product.");
                        doGet(req, resp);
                        return;
                    }
                    sellerId = rs.getString("seller_port_id");
                }

                CallableStatement stmt = conn.prepareCall("{CALL add_report(?, ?, ?, ?, ?)}");
                stmt.setString(1, consumerId);
                stmt.setString(2, sellerId);
                stmt.setInt(3, productId);
                stmt.setString(4, issueType);
                stmt.setDate(5, Date.valueOf(java.time.LocalDate.now()));
                stmt.execute();
                stmt.close();

                req.setAttribute("success", "Product issue reported successfully.");
                doGet(req, resp);
            }

        } catch (Exception e) {
            e.printStackTrace();
            req.setAttribute("error", "Error: " + e.getMessage());
            doGet(req, resp);
        }
    }

    private void handleUpdateStatus(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        try {
            int id = Integer.parseInt(req.getParameter("report_id"));
            String actionTaken = req.getParameter("action_taken");

            if (actionTaken == null || actionTaken.trim().isEmpty()) {
                resp.sendError(400, "Action taken is required.");
                return;
            }

            try (Connection conn = DbConnection.getConnection()) {
                String sql = "UPDATE reported_products SET status = 'Resolved', action_taken = ? WHERE report_id = ?";
                try (PreparedStatement ps = conn.prepareStatement(sql)) {
                    ps.setString(1, actionTaken);
                    ps.setInt(2, id);
                    ps.executeUpdate();
                }
            }

            resp.sendRedirect("ReportedProductsController");
        } catch (Exception e) {
            e.printStackTrace();
            resp.sendError(500, "Error updating report status: " + e.getMessage());
        }
    }


}
