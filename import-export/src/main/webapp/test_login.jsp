<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8" />
    <title>Login</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet" />
    <style>
        @import url('https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;600&display=swap');

        html, body {
            height: 100%;
            margin: 0;
            font-family: 'Poppins', sans-serif;
        }

        body {
            background: linear-gradient(120deg, #89f7fe, #66a6ff, #ff758c);
            background-size: 600% 600%;
            animation: gradientFlow 10s ease infinite;
            display: flex;
            justify-content: center;
            align-items: center;
        }

        @keyframes gradientFlow {
            0% { background-position: 0% 50%; }
            50% { background-position: 100% 50%; }
            100% { background-position: 0% 50%; }
        }

        .wrapper {
            display: flex;
            width: 900px;
            height: 540px;
            background: #ffffff;
            border-radius: 15px;
            box-shadow: 0 20px 40px rgba(0, 0, 0, 0.25);
            overflow: hidden;
            animation: slideIn 1s ease;
        }

        @keyframes slideIn {
            from {
                transform: scale(0.9) translateY(40px);
                opacity: 0;
            }
            to {
                transform: scale(1) translateY(0);
                opacity: 1;
            }
        }

        .left-side {
            flex: 1;
            padding: 40px 30px;
            display: flex;
            flex-direction: column;
            justify-content: center;
            background: #fff;
        }

        .right-side {
            flex: 1;
            background: url('https://www.globalshiplease.com/system/files-encrypted/styles/nir_asset_small/encrypt/nasdaq_kms/assets/2020/07/06/17-24-04/5900.jpg?itok=deef74ez') no-repeat center center;
            background-size: cover;
        }

        h3 {
            text-align: center;
            margin-bottom: 1.5rem;
            color: #2c3e50;
            font-weight: 700;
        }

        form {
            display: flex;
            flex-direction: column;
        }

        .form-group {
            position: relative;
            margin-bottom: 20px;
        }

        .form-group input,
        .form-group select {
            width: 100%;
            padding: 14px 14px;
            border: 1px solid #ccc;
            border-radius: 50px;
            background-color: #f7f7f7;
            font-size: 15px;
            transition: all 0.3s ease;
        }

        .form-group select {
            appearance: none;
            background-image: url('data:image/svg+xml;utf8,<svg fill="gray" height="24" viewBox="0 0 24 24" width="24" xmlns="http://www.w3.org/2000/svg"><path d="M7 10l5 5 5-5z"/></svg>');
            background-repeat: no-repeat;
            background-position: right 16px center;
            background-size: 16px 16px;
        }

        .form-group label {
            position: absolute;
            top: 14px;
            left: 20px;
            font-size: 14px;
            color: #999;
            pointer-events: none;
            transition: 0.3s ease all;
            background: white;
            padding: 0 6px;
        }

        .form-group input:focus + label,
        .form-group input:not(:placeholder-shown) + label,
        .form-group select:focus + label,
        .form-group select:not([value=""]) + label {
            top: -8px;
            left: 16px;
            font-size: 12px;
            color: #1a73e8;
        }

        .form-control:focus,
        .form-select:focus {
            box-shadow: 0 0 8px #4285f4aa;
            border-color: #4285f4;
            transition: 0.3s ease;
            background-color: #fff;
        }

        .btn-primary {
            background: linear-gradient(to right, #4285f4, #5c6bc0);
            border: none;
            font-weight: 600;
            font-size: 1.1rem;
            padding: 12px;
            border-radius: 50px;
            transition: background 0.3s ease, transform 0.3s ease;
        }

        .btn-primary:hover {
            background: linear-gradient(to right, #357ae8, #3f51b5);
            transform: scale(1.05);
        }

        .alert {
            font-size: 14px;
            border-radius: 8px;
            user-select: none;
            margin-bottom: 1rem;
            padding: 10px 15px;
        }

        .alert-danger {
            background-color: #fdecea;
            color: #a94442;
            border: 1px solid #f5c6cb;
        }

        .alert-success {
            background-color: #e6f4ea;
            color: #2f8132;
            border: 1px solid #c3e6cb;
        }

        .text-center a {
            color: #4285f4;
            font-weight: 600;
            text-decoration: none;
            user-select: none;
            transition: color 0.3s ease;
        }

        .text-center a:hover {
            color: #357ae8;
            text-decoration: underline;
        }

        @media (max-width: 768px) {
            .wrapper {
                flex-direction: column-reverse;
                height: auto;
                width: 95%;
                margin: 20px;
            }

            .right-side {
                height: 200px;
            }

            .left-side {
                padding: 30px 20px;
            }
        }
    </style>
</head>
<body>

<div class="wrapper">
    <div class="left-side">
        <h3>🔐 Login</h3>

        <%
            String error = (String) request.getAttribute("error");
            String success = (String) request.getAttribute("success");
        %>

        <% if (success != null) { %>
            <div class="alert alert-success text-center"><%= success %></div>
        <% } else if (error != null) { %>
            <div class="alert alert-danger text-center"><%= error %></div>
        <% } %>

        <form action="/import-export/Login" method="post" novalidate>
            <input type="hidden" name="action" value="login" />

            <div class="form-group">
                <input type="text" name="port_id" placeholder=" " required autocomplete="off" />
                <label for="port_id">Port ID</label>
            </div>

            <div class="form-group">
                <input type="password" name="password" placeholder=" " required autocomplete="current-password" />
                <label for="password">Password</label>
            </div>

            <div class="form-group">
                <select name="role" required>
                    <option value="" selected disabled>-- Select Role --</option>
                    <option value="consumer">Consumer</option>
                    <option value="seller">Seller</option>
                </select>
                <label for="role">Role</label>
            </div>

            <button type="submit" class="btn btn-primary w-100">Login</button>
        </form>

        <div class="text-center mt-3">
            <a href="test_register.jsp">Don't have an account? Register</a>
        </div>
    </div>
    <div class="right-side"></div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
