package controllers;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import models.Order;
import models.User;
import db_config.DbConnection;
import implementors.OrderImplementor;

import java.io.IOException;
import java.sql.CallableStatement;
import java.sql.Connection;
import java.sql.Timestamp;
import java.time.LocalDate;
import java.time.LocalDateTime;
import java.util.List;

@WebServlet("/OrderController")
public class OrderController extends HttpServlet {
    private final Order orderDAO = new Order();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            HttpSession session = request.getSession(false);
            if (session == null || session.getAttribute("user") == null) {
                response.sendRedirect("test_login.jsp");
                return;
            }

            User user = (User) session.getAttribute("user");
            List<Order> orders = orderDAO.showOrders(user.getPortId());
            request.setAttribute("orderList", orders);
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "Failed to fetch orders.");
        }

        request.getRequestDispatcher("view_seller_orders.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String action = request.getParameter("action");

        try {
            if ("placeOrder".equals(action)) {
                String consumerId = request.getParameter("consumer_port_id");
                String[] productIds = request.getParameterValues("product_id");
                String[] quantities = request.getParameterValues("quantity");
                String[] sellerIds = request.getParameterValues("seller_port_id");

                if (consumerId == null || productIds == null || quantities == null || sellerIds == null
                        || productIds.length != quantities.length || productIds.length != sellerIds.length) {
                    request.setAttribute("error", "Invalid cart data.");
                    request.getRequestDispatcher("cart.jsp").forward(request, response);
                    return;
                }

                try (Connection conn = DbConnection.getConnection()) {
                    LocalDate today = LocalDate.now();

                    for (int i = 0; i < productIds.length; i++) {
                        try (CallableStatement stmt = conn.prepareCall("{CALL add_order(?, ?, ?, ?, ?)}")) {
                            stmt.setInt(1, Integer.parseInt(productIds[i]));
                            stmt.setString(2, consumerId);
                            stmt.setString(3, sellerIds[i]);
                            stmt.setInt(4, Integer.parseInt(quantities[i]));
                            stmt.setDate(5, java.sql.Date.valueOf(today));
                            stmt.execute();
                        }
                    }
                }

                HttpSession session = request.getSession(false);
                if (session != null) {
                    session.removeAttribute("cart");
                }

                request.setAttribute("thankyou", "Thank you! Your order has been placed successfully.");
                request.getRequestDispatcher("thank_you.jsp").forward(request, response);
                return;
            }

            // ✅ Updated logic for dropdown status
            else if ("changeStatus".equals(action)) {
                int orderId = Integer.parseInt(request.getParameter("order_id"));
                String deliveryStatus = request.getParameter("delivery_status");

                boolean shipped = false;
                boolean outForDelivery = false;
                boolean delivered = false;

                Timestamp shippedTime = null;
                Timestamp outForDeliveryTime = null;
                Timestamp deliveredTime = null;

                LocalDateTime now = LocalDateTime.now();

                // Set appropriate flag and timestamp based on selected status
                switch (deliveryStatus) {
                    case "Shipped":
                        shipped = true;
                        shippedTime = Timestamp.valueOf(now);
                        break;
                    case "Out for Delivery":
                        shipped = true;
                        outForDelivery = true;
                        shippedTime = Timestamp.valueOf(now);
                        outForDeliveryTime = Timestamp.valueOf(now);
                        break;
                    case "Delivered":
                        shipped = true;
                        outForDelivery = true;
                        delivered = true;
                        shippedTime = Timestamp.valueOf(now);
                        outForDeliveryTime = Timestamp.valueOf(now);
                        deliveredTime = Timestamp.valueOf(now);
                        break;
                    default:
                        // No update if status is invalid or not selected
                        request.setAttribute("error", "Invalid delivery status.");
                        doGet(request, response);
                        return;
                }

                OrderImplementor orderImpl = new OrderImplementor();

                String status = orderImpl.updateOrderStatusWithTimestamps(
                        orderId, shipped, shippedTime,
                        outForDelivery, outForDeliveryTime,
                        delivered, deliveredTime
                );

                request.setAttribute("message", status);
            }

        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "Failed to process order: " + e.getMessage());
        }

        // Refresh view
        doGet(request, response);
    }
}
