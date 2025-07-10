<%@page import="models.User"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <title>Update Product</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <style>
        body {
            background: linear-gradient(135deg, #f5f7fa 0%, #c3cfe2 100%);
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            overflow-x: hidden;
            margin: 0;
            min-height: 100vh;
            display: flex;
            justify-content: center;
            align-items: center;
            padding: 40px 15px;
        }

        .form-container {
            max-width: 600px;
            width: 100%;
            background-color: #ffffff;
            padding: 30px 40px;
            border-radius: 10px;
            box-shadow: 0px 0px 15px rgba(0,0,0,0.1);
            border: 1px solid #ddd;
        }

        h2 {
            font-weight: 700;
            color: #343a40;
            text-align: center;
            margin-bottom: 30px;
            user-select: none;
        }

        label.form-label {
            font-weight: 600;
            color: #212529;
        }

        input.form-control {
            border-radius: 8px;
            border: 1.8px solid #ced4da;
            box-shadow: inset 0 1px 3px rgba(0,0,0,0.1);
            transition: border-color 0.3s ease, box-shadow 0.3s ease;
        }

        input.form-control:focus {
            border-color: #ffc107;
            box-shadow: 0 0 5px #ffc107;
            outline: none;
        }

        .text-end {
            display: flex;
            justify-content: flex-end;
            gap: 15px;
            margin-top: 25px;
        }

        .btn-primary {
            background: linear-gradient(45deg, #ffc107, #e0a800);
            border: none;
            color: #212529;
            font-weight: 700;
            padding: 10px 22px;
            border-radius: 8px;
            box-shadow: 0 5px 12px rgb(224 168 0 / 0.6);
            transition: background 0.3s ease, box-shadow 0.3s ease, transform 0.2s ease;
            user-select: none;
        }

        .btn-primary:hover {
            background: linear-gradient(45deg, #e0a800, #ffc107);
            box-shadow: 0 8px 20px rgb(224 168 0 / 0.9);
            transform: scale(1.05);
            color: #212529;
        }

        .btn-secondary {
            background-color: #6c757d;
            border: none;
            color: white;
            font-weight: 600;
            padding: 10px 22px;
            border-radius: 8px;
            box-shadow: 0 4px 12px rgba(108, 117, 125, 0.6);
            transition: background-color 0.3s ease, box-shadow 0.3s ease, transform 0.2s ease;
            user-select: none;
            text-decoration: none;
            display: inline-flex;
            align-items: center;
            justify-content: center;
        }

        .btn-secondary:hover {
            background-color: #5a6268;
            box-shadow: 0 6px 18px rgba(90, 98, 104, 0.8);
            transform: scale(1.05);
            color: white;
            text-decoration: none;
        }
    </style>
</head>
<body>

<%
    String productId = request.getParameter("product_id");
    String name = request.getParameter("name");
    String price = request.getParameter("price");
    String quantity = request.getParameter("quantity");
    String error = (String) request.getAttribute("error");
%>

<div class="form-container">
    <h2 class="mb-4">✏️ Update Product</h2>

    <% if (error != null) { %>
        <div class="alert alert-danger text-center"><%= error %></div>
    <% } %>

    <form action="ProductController" method="POST">
        <input type="hidden" name="action" value="update">
        <input type="hidden" name="product_id" value="<%= productId != null ? productId : "" %>">

        <div class="mb-3">
            <label for="product_name" class="form-label">Product Name</label>
            <input type="text" id="product_name" name="product_name" class="form-control"
                   value="<%= name != null ? name : "" %>" required>
        </div>

        <div class="mb-3">
            <label for="quantity" class="form-label">Quantity</label>
            <input type="number" id="quantity" name="quantity" class="form-control"
                   value="<%= quantity != null ? quantity : "" %>" required min="1">
        </div>

        <div class="mb-3">
            <label for="price" class="form-label">Price (₹)</label>
            <input type="number" id="price" name="price" class="form-control"
                   value="<%= price != null ? price : "" %>" step="0.01" required>
        </div>

        <div class="text-end">
            <button type="submit" class="btn btn-primary">✅ Update Product</button>
            <a href="ProductController?action=view" class="btn btn-secondary">⬅ Back</a>
        </div>
    </form>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
