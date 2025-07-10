<%@ page import="java.util.List" %>
<%@ page import="models.Product" %>
<%@ page session="true" %>
<!DOCTYPE html>
<html>
<head>
    <title>Your Cart</title>
    <meta charset="UTF-8">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet" />
    <style>
        body {
            background-color: #f8f9fa;
            padding: 40px 20px;
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
            margin-bottom: 30px;
            font-weight: 700;
            color: #343a40;
            border-bottom: 3px solid #ffc107;
            display: inline-block;
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
            cursor: default;
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
        .btn-success:hover {
            background-color: #218838;
            border-color: #1e7e34;
            box-shadow: 0 8px 25px rgba(33, 136, 56, 0.4);
            transform: translateY(-2px);
        }
        .btn-secondary:hover {
            background-color: #5a6268;
            border-color: #545b62;
            box-shadow: 0 8px 25px rgba(90, 98, 104, 0.4);
            transform: translateY(-2px);
        }
        .btn-danger {
            margin-left: 15px;
        }
        .btn-danger:hover {
            background-color: #c82333;
            border-color: #bd2130;
            box-shadow: 0 8px 25px rgba(200, 35, 51, 0.4);
            transform: translateY(-2px);
        }
        .button-group {
            margin-top: 25px;
            display: flex;
            justify-content: flex-end;
            gap: 15px;
        }
        .empty-cart-actions {
            margin-top: 20px;
            text-align: center;
        }
    </style>
</head>
<body>

<div class="container">
    <h2 class="text-center">Your Cart</h2>

    <%
        List<Product> cart = (List<Product>) session.getAttribute("cart");
        if (cart == null || cart.isEmpty()) {
    %>
        <div class="alert alert-info text-center fs-5">Your cart is empty.</div>
        <div class="empty-cart-actions">
            <a href="ProductController?action=view" class="btn btn-secondary">Back to Products</a>
        </div>
    <%
        } else {
    %>
        <table class="table table-bordered table-hover text-center align-middle">
            <thead class="table-dark">
                <tr>
                    <th>Product Name</th>
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
            <% } %>
            <tr class="table-success fw-bold">
                <td colspan="3">Grand Total</td>
                <td><%= String.format("%.2f", grandTotal) %></td>
            </tr>
            </tbody>
        </table>

        <div class="button-group">
            <a href="checkout.jsp" class="btn btn-success">Proceed to Checkout</a>
            <a href="ProductController?action=view" class="btn btn-secondary">Back to Products</a>
            <a href="CartController?action=cancel" class="btn btn-danger">Cancel Order</a>
        </div>
    <%
        }
    %>
</div>

<!-- Bootstrap JS Bundle -->
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>

</body>
</html>
