<%@ page import="java.util.*, java.sql.*, models.Product, models.User" %>
<%@ page session="true" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Checkout - Confirm Your Order</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet" />
    <style>
        body {
            background-color: #f8f9fa;
            padding: 50px 20px 80px;
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
        }
        .container {
            max-width: 850px;
            background: white;
            padding: 30px 40px;
            border-radius: 12px;
            box-shadow: 0 8px 24px rgba(0,0,0,0.1);
        }
        h2 {
            font-weight: 700;
            color: #343a40;
            border-bottom: 3px solid #ffc107;
            display: inline-block;
            margin-bottom: 30px;
            padding-bottom: 6px;
        }
        table {
            border-radius: 10px;
            overflow: hidden;
            box-shadow: 0 4px 15px rgba(0,0,0,0.07);
        }
        thead.table-dark {
            background: linear-gradient(90deg, #343a40, #495057);
            color: #ffc107;
            font-weight: 600;
            letter-spacing: 0.05em;
        }
        tbody tr:hover {
            background-color: #fff3cd;
            transition: background-color 0.3s ease;
        }
        .table-success {
            background-color: #d4edda !important;
            color: #155724 !important;
            font-size: 1.1rem;
        }
        .btn {
            min-width: 160px;
            font-weight: 600;
            border-radius: 8px;
            padding: 10px 20px;
            transition: all 0.3s ease;
            box-shadow: 0 5px 15px rgba(0,0,0,0.1);
        }
        .btn-success {
            background-color: #28a745;
            border-color: #28a745;
        }
        .btn-success:hover {
            background-color: #218838;
            border-color: #1e7e34;
            box-shadow: 0 8px 25px rgba(33, 136, 56, 0.4);
            transform: translateY(-2px);
        }
        .btn-secondary {
            background-color: #6c757d;
            border-color: #6c757d;
            margin-left: 15px;
        }
        .btn-secondary:hover {
            background-color: #5a6268;
            border-color: #545b62;
            box-shadow: 0 8px 25px rgba(90, 98, 104, 0.4);
            transform: translateY(-2px);
        }
        .form-actions {
            margin-top: 30px;
            display: flex;
            justify-content: flex-end;
        }
    </style>
</head>
<body>
<%
    List<Product> cart = (List<Product>) session.getAttribute("cart");
    User user = (User) session.getAttribute("user");
    if (user == null || cart == null || cart.isEmpty()) {
        response.sendRedirect("cart.jsp");
        return;
    }
%>

<div class="container">
    <h2>Confirm Your Order</h2>

    <form action="OrderController" method="post">
        <input type="hidden" name="action" value="placeOrder">

        <table class="table table-bordered table-hover text-center align-middle">
            <thead class="table-dark">
                <tr>
                    <th>Product</th>
                    <th>Quantity</th>
                    <th>Price</th>
                    <th>Total</th>
                </tr>
            </thead>
            <tbody>
                <%
                    double grandTotal = 0;
                    for (Product p : cart) {
                        double total = p.getPrice() * p.getQuantity();
                        grandTotal += total;
                %>
                <tr>
                    <td><%= p.getProduct_name() %></td>
                    <td><%= p.getQuantity() %></td>
                    <td><%= String.format("%.2f", p.getPrice()) %></td>
                    <td><%= String.format("%.2f", total) %></td>
                </tr>

                <!-- Hidden Fields to Send Order Details -->
                <input type="hidden" name="product_id" value="<%= p.getProduct_id() %>">
                <input type="hidden" name="quantity" value="<%= p.getQuantity() %>">
                <input type="hidden" name="seller_port_id" value="<%= p.getSeller_port_id() %>">
                <% } %>
                <tr class="table-success fw-bold">
                    <td colspan="3">Grand Total</td>
                    <td><%= String.format("%.2f", grandTotal) %></td>
                </tr>
            </tbody>
        </table>

        <input type="hidden" name="consumer_port_id" value="<%= user.getPortId() %>">

        <div class="form-actions">
            <button type="submit" class="btn btn-success">Place Order</button>
            <a href="cart.jsp" class="btn btn-secondary">Back to Cart</a>
        </div>
    </form>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
