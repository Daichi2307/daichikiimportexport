<%@page import="db_config.DbConnection"%>
<%@ page import="java.sql.*, java.util.*, models.User" %>
<%@ page session="true" %>
<!DOCTYPE html>
<html>
<head>
    <title>Track My Orders</title>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css">
    <style>
        body {
    padding: 30px;
    background: linear-gradient(135deg, #e0f7fa, #e3f2fd);
    font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
}

/* Main Container Card */
.container {
    max-width: 1100px;
    background: #ffffff;
    padding: 30px;
    border-radius: 16px;
    box-shadow: 0 10px 30px rgba(0,0,0,0.1);
    animation: fadeIn 0.6s ease-in-out forwards;
    transition: all 0.3s ease;
}

/* Heading */
h2 {
    font-weight: 800;
    margin-bottom: 30px;
    color: #212529;
    text-align: center;
    text-transform: uppercase;
    letter-spacing: 1px;
}

/* Enhanced Table Design */
.table {
    border-radius: 12px;
    overflow: hidden;
    box-shadow: 0 6px 20px rgba(0,0,0,0.05);
    background: #ffffff;
    margin-top: 20px;
}

.table thead {
    background-color: #000000;
    color: #ffffff;
    font-size: 1rem;
    text-transform: uppercase;
    letter-spacing: 0.5px;
}

/* Force black header background on Track Orders table */
.custom-dark-header thead {
    background-color: #000 !important;
    color: #fff !important;
}

.custom-dark-header thead th {
    color: #fff !important;
    background-color: #000 !important;
    border-color: #dee2e6;
}


.table tbody tr {
    transition: all 0.3s ease;
    cursor: pointer;
}

.table tbody tr:hover {
    background-color: #f1f9ff;
    transform: scale(1.005);
    box-shadow: 0 4px 10px rgba(0, 123, 255, 0.1);
}

/* Stylish Buttons */
.btn-report, .btn-outline-primary {
    border-radius: 25px;
    padding: 6px 15px;
    transition: all 0.2s ease;
}

.btn-report:hover, .btn-outline-primary:hover {
    transform: scale(1.1);
}

.btn-back {
    margin-bottom: 20px;
    font-weight: bold;
    border-radius: 20px;
    box-shadow: 0 4px 10px rgba(0, 0, 0, 0.15);
    background: linear-gradient(45deg, #007bff, #0056b3);
    color: white;
    transition: transform 0.3s ease;
}

.btn-back:hover {
    transform: scale(1.05);
}

/* Text Muted */
.text-muted {
    font-style: italic;
    font-size: 0.9rem;
    color: #888;
}

/* Timeline Styles */
.timeline {
    position: relative;
    margin: 20px 0;
    padding-left: 40px;
    border-left: 3px solid #007bff;
}

.timeline-step {
    position: relative;
    margin-bottom: 25px;
    padding-left: 20px;
    color: #6c757d;
    font-weight: 600;
    font-size: 1rem;
}

.timeline-step::before {
    content: "";
    position: absolute;
    left: -31px;
    top: 4px;
    width: 18px;
    height: 18px;
    border-radius: 50%;
    background-color: #dee2e6;
    border: 3px solid #dee2e6;
    transition: background-color 0.3s, border-color 0.3s;
}

.timeline-step.active {
    color: #007bff;
}

.timeline-step.active::before {
    background-color: #007bff;
    border-color: #0056b3;
    box-shadow: 0 0 10px rgba(0, 123, 255, 0.4);
}

.timestamp {
    font-size: 0.85rem;
    color: #666;
    margin-left: 25px;
    font-style: italic;
}

/* Modal Styling */
.modal-content {
    border-radius: 12px;
    box-shadow: 0 6px 20px rgba(0, 0, 0, 0.2);
}

.modal-header.bg-danger {
    background: linear-gradient(45deg, #dc3545, #b02a37);
    color: white;
}

.modal-header.bg-primary {
    background: linear-gradient(45deg, #007bff, #0056b3);
    color: white;
}

.modal {
    z-index: 1100 !important;
}

.modal-backdrop.show {
    z-index: 1090 !important;
}

/* Fade In Animation */
@keyframes fadeIn {
    0% {
        opacity: 0;
        transform: translateY(20px);
    }
    100% {
        opacity: 1;
        transform: translateY(0);
    }
}

/* Status Badges */
.badge {
    font-size: 0.9rem;
    padding: 8px 12px;
    border-radius: 20px;
    letter-spacing: 0.5px;
    font-weight: 600;
}

/* Responsive Enhancements */
@media (max-width: 768px) {
    .table thead {
        display: none;
    }
    .table tbody td {
        display: block;
        text-align: right;
        padding-left: 50%;
        position: relative;
    }
    .table tbody td::before {
        content: attr(data-label);
        position: absolute;
        left: 10px;
        top: 8px;
        font-weight: bold;
        text-align: left;
    }
}

    </style>
</head>
<body>

<%
    User user = (User) session.getAttribute("user");
    if (user == null) {
        response.sendRedirect("test_login.jsp");
        return;
    }

    String consumerId = user.getPortId();
    List<Map<String, Object>> orderList = new ArrayList<>();

    try {
        Connection conn = DbConnection.getConnection();
        CallableStatement stmt = conn.prepareCall("{CALL view_consumer_orders(?)}");
        stmt.setString(1, consumerId);
        ResultSet rs = stmt.executeQuery();

        while (rs.next()) {
            Map<String, Object> order = new HashMap<>();
            order.put("order_id", rs.getInt("order_id"));
            order.put("product_id", rs.getInt("product_id"));
            order.put("product_name", rs.getString("product_name"));
            order.put("quantity", rs.getInt("quantity"));
            order.put("price", rs.getDouble("price"));
            order.put("order_date", rs.getDate("order_date"));
            order.put("shipped", rs.getBoolean("shipped"));
            order.put("out_for_delivery", rs.getBoolean("out_for_delivery"));
            order.put("delivered", rs.getBoolean("delivered"));
            // Added timestamp fields
            order.put("order_placed_time", rs.getTimestamp("order_placed_time"));
            order.put("shipped_time", rs.getTimestamp("shipped_time"));
            order.put("out_for_delivery_time", rs.getTimestamp("out_for_delivery_time"));
            order.put("delivered_time", rs.getTimestamp("delivered_time"));
            orderList.add(order);
        }

        rs.close();
        stmt.close();
        conn.close();
    } catch (Exception e) {
%>
    <div class='alert alert-danger container mt-5'>Error fetching orders: <%= e.getMessage() %></div>
<%
    }

    Map<Integer, Boolean> reportedStatusMap = (Map<Integer, Boolean>) request.getAttribute("reportedStatusMap");
    if (reportedStatusMap == null) {
        reportedStatusMap = new HashMap<>();
    }
%>

<div class="container">
    <button class="btn btn-primary btn-back" onclick="location.href='ProductController?action=view'">
        &larr; Back to Products
    </button>

    <h2 class="text-center">My Orders</h2>

    <% if (orderList.isEmpty()) { %>
        <div class="alert alert-info text-center">No orders found.</div>
    <% } else { %>
        <table class="table table-bordered table-hover text-center align-middle custom-dark-header">

            <thead>
                <tr>
                    <th>Order ID</th>
                    <th>Product</th>
                    <th>Quantity</th>
                    <th>Price</th>
                    <th>Date</th>
                    <th>Status</th>
                    <th>Report</th>
                    <th>Track</th>
                </tr>
            </thead>
            <tbody>
                <% for (Map<String, Object> order : orderList) {
                    boolean shipped = (boolean) order.get("shipped");
                    boolean outForDelivery = (boolean) order.get("out_for_delivery");
                    boolean delivered = (boolean) order.get("delivered");
                    String status = delivered ? "Delivered" :
                                    outForDelivery ? "Out for Delivery" :
                                    shipped ? "Shipped" : "Order Placed";

                    int productId = (int) order.get("product_id");
                    int orderId = (int) order.get("order_id");

                    boolean hasUnresolvedReport = false;
                    if (reportedStatusMap.containsKey(productId)) {
                        hasUnresolvedReport = reportedStatusMap.get(productId);
                    }
                %>
                    <tr>
                        <td><%= orderId %></td>
                        <td class="fw-semibold text-primary"><%= order.get("product_name") %></td>
                        <td><%= order.get("quantity") %></td>
                        <td> <%= String.format("%.2f", order.get("price")) %></td>
                        <td><%= order.get("order_date") %></td>
                        <td>
                            <% if (delivered) { %>
                                <span class="badge bg-success"><%= status %></span>
                            <% } else if (outForDelivery) { %>
                                <span class="badge bg-info text-dark"><%= status %></span>
                            <% } else if (shipped) { %>
                                <span class="badge bg-warning text-dark"><%= status %></span>
                            <% } else { %>
                                <span class="badge bg-secondary"><%= status %></span>
                            <% } %>
                        </td>
                        <td>
                            <% if (!delivered) { %>
                                <span class="text-muted">Report after delivery</span>
                            <% } else if (hasUnresolvedReport) { %>
                                <button class="btn btn-secondary btn-sm" disabled>Reported</button>
                            <% } else { %>
                                <button 
                                    class="btn btn-danger btn-sm btn-report" 
                                    data-bs-toggle="modal" 
                                    data-bs-target="#reportModal<%= orderId %>">
                                    Report
                                </button>
                            <% } %>
                        </td>
                        <td>
                            <button 
                                class="btn btn-outline-primary btn-sm" 
                                data-bs-toggle="modal" 
                                data-bs-target="#trackModal<%= orderId %>">
                                Track
                            </button>
                        </td>
                    </tr>
                <% } %>
            </tbody>
        </table>
    <% } %>
</div>

<% for (Map<String, Object> order : orderList) { 
    boolean shipped = (boolean) order.get("shipped");
    boolean outForDelivery = (boolean) order.get("out_for_delivery");
    boolean delivered = (boolean) order.get("delivered");
    int orderId = (int) order.get("order_id");
    int productId = (int) order.get("product_id");
    Timestamp orderPlacedTime = (Timestamp) order.get("order_placed_time");
    Timestamp shippedTime = (Timestamp) order.get("shipped_time");
    Timestamp outForDeliveryTime = (Timestamp) order.get("out_for_delivery_time");
    Timestamp deliveredTime = (Timestamp) order.get("delivered_time");
%>

<!-- TRACK MODAL -->
<div class="modal fade" id="trackModal<%= orderId %>" tabindex="-1" role="dialog" aria-labelledby="trackModalLabel<%= orderId %>" aria-hidden="true">
  <div class="modal-dialog modal-dialog-centered" role="document">
    <div class="modal-content">
      <div class="modal-header bg-primary text-white">
        <h5 class="modal-title" id="trackModalLabel<%= orderId %>">Tracking - Order #<%= orderId %></h5>
        <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
      </div>
      <div class="modal-body">
        <div class="timeline">
          <div class="timeline-step active">
            Order Placed
            <% if(orderPlacedTime != null) { %>
                <div class="timestamp"><%= orderPlacedTime.toString() %></div>
            <% } %>
          </div>
          <div class="timeline-step <%= shipped ? "active" : "" %>">
            Shipped
            <% if(shipped && shippedTime != null) { %>
                <div class="timestamp"><%= shippedTime.toString() %></div>
            <% } %>
          </div>
          <div class="timeline-step <%= outForDelivery ? "active" : "" %>">
            Out for Delivery
            <% if(outForDelivery && outForDeliveryTime != null) { %>
                <div class="timestamp"><%= outForDeliveryTime.toString() %></div>
            <% } %>
          </div>
          <div class="timeline-step <%= delivered ? "active" : "" %>">
            Delivered
            <% if(delivered && deliveredTime != null) { %>
                <div class="timestamp"><%= deliveredTime.toString() %></div>
            <% } %>
          </div>
        </div>
      </div>
    </div>
  </div>
</div>

<!-- REPORT MODAL -->
<div class="modal fade" id="reportModal<%= orderId %>" tabindex="-1" role="dialog" aria-labelledby="reportLabel<%= orderId %>" aria-hidden="true">
  <div class="modal-dialog" role="document">
    <form action="ReportedProductsController" method="post">
      <div class="modal-content">
        <div class="modal-header bg-danger text-white">
          <h5 class="modal-title" id="reportLabel<%= orderId %>">Report Issue - Order #<%= orderId %></h5>
          <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
        </div>
        <div class="modal-body">
          <input type="hidden" name="action" value="addReport">
          <input type="hidden" name="product_id" value="<%= productId %>">
          <input type="hidden" name="consumer_port_id" value="<%= consumerId %>">
          <input type="hidden" name="order_id" value="<%= orderId %>">
          <label class="form-label">Select Issue Type:</label>
          <select name="issue_type" class="form-select" required>
            <option value="" selected disabled>-- Select Issue --</option>
            <option value="Damage">Damage</option>
            <option value="Wrong Product">Wrong Product</option>
            <option value="Delayed">Delayed</option>
            <option value="Still Not Received">Still Not Received</option>
            <option value="Missing">Missing</option>
          </select>
        </div>
        <div class="modal-footer">
          <button type="submit" class="btn btn-danger">Submit Report</button>
        </div>
      </div>
    </form>
  </div>
</div>

<% } %>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>

</body>
</html>
