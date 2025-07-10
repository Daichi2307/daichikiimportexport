<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page session="true" %>
<html>
<head>
    <title>Register</title>
    <style>
        @import url('https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;600&display=swap');

        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }

        body {
            font-family: 'Poppins', sans-serif;
            height: 100vh;
            background: linear-gradient(120deg, #89f7fe, #66a6ff, #ff758c);
            background-size: 600% 600%;
            animation: gradientBG 10s ease infinite, fadeInBody 1s ease-in-out;
            display: flex;
            justify-content: center;
            align-items: center;
        }

        @keyframes gradientBG {
            0% {background-position: 0% 50%;}
            50% {background-position: 100% 50%;}
            100% {background-position: 0% 50%;}
        }

        @keyframes fadeInBody {
            from {opacity: 0;}
            to {opacity: 1;}
        }

        .wrapper {
            width: 900px;
            height: 560px;
            display: flex;
            background: #fff;
            box-shadow: 0 20px 40px rgba(0, 0, 0, 0.25);
            border-radius: 16px;
            overflow: hidden;
            animation: slideInWrapper 1.2s ease;
        }

        @keyframes slideInWrapper {
            0% {
                transform: scale(0.9) translateY(40px);
                opacity: 0;
            }
            100% {
                transform: scale(1) translateY(0);
                opacity: 1;
            }
        }

        .left-side {
            flex: 1;
            background: url('https://thumbs.dreamstime.com/b/cargo-ship-high-seas-containers-import-export-ai-generated-photo-k-hd-image-background-369516583.jpg') no-repeat center center;
            background-size: cover;
        }

        .right-side {
            flex: 1;
            background: #fff;
            padding: 40px 35px;
            display: flex;
            flex-direction: column;
            justify-content: center;
        }

        .right-side h2 {
            text-align: center;
            margin-bottom: 25px;
            font-weight: 600;
            color: #333;
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
        }

        .form-group input:focus + label,
        .form-group input:not(:placeholder-shown) + label,
        .form-group select:focus + label,
        .form-group select:not([value=""]) + label {
            top: -8px;
            left: 16px;
            background: #fff;
            padding: 0 6px;
            font-size: 12px;
            color: #1a73e8;
        }

        button {
            padding: 12px;
            background: linear-gradient(to right, #1a73e8, #5c6bc0);
            border: none;
            border-radius: 50px;
            color: white;
            font-weight: 500;
            font-size: 16px;
            cursor: pointer;
            transition: transform 0.3s ease, box-shadow 0.3s ease;
        }

        button:hover {
            transform: scale(1.05);
            box-shadow: 0 10px 20px rgba(26, 115, 232, 0.3);
        }

        .actions a {
            margin-top: 15px;
            text-align: center;
            display: block;
            text-decoration: none;
            color: #555;
            font-size: 14px;
        }

        .actions a:hover {
            color: #1a73e8;
            text-decoration: underline;
        }

        .success, .error {
            text-align: center;
            padding: 10px;
            border-radius: 6px;
            margin-bottom: 15px;
            font-weight: 500;
            animation: fadeIn 0.5s ease-in-out;
        }

        .success {
            background-color: #e0f7e9;
            color: #2e7d32;
            border: 1px solid #a5d6a7;
        }

        .error {
            background-color: #fdecea;
            color: #c62828;
            border: 1px solid #ef9a9a;
        }

        @media (max-width: 768px) {
            .wrapper {
                flex-direction: column;
                height: auto;
                width: 90%;
            }

            .left-side {
                display: none;
            }

            .right-side {
                padding: 30px 25px;
            }
        }
    </style>
</head>
<body>
<div class="wrapper">
    <div class="left-side"></div>
    <div class="right-side">
        <h2>Register</h2>

        <% 
           String error = (String) request.getAttribute("error");
           String success = (String) request.getAttribute("success");
           models.User user = (models.User) session.getAttribute("user");
        %>

        <% if (success != null) { %>
            <div class="success"><%= success %></div>
        <% } else if (error != null) { %>
            <div class="error"><%= error %></div>
        <% } %>

        <form action="Registration" method="post">
            <div class="form-group">
                <input type="text" name="port_id" placeholder=" " required>
                <label>Port ID</label>
            </div>

            <div class="form-group">
                <input type="password" name="password" placeholder=" " required>
                <label>Password</label>
            </div>

            <div class="form-group">
                <input type="password" name="confirm_password" placeholder=" " required>
                <label>Confirm Password</label>
            </div>

            <div class="form-group">
                <input type="text" name="location" placeholder=" " required>
                <label>Location</label>
            </div>

            <div class="form-group">
                <select name="role" required>
                    <option value="" selected disabled>-- Select Role --</option>
                    <option value="Consumer">Consumer</option>
                    <option value="Seller">Seller</option>
                </select>
                <label>Select Role</label>
            </div>

            <button type="submit">Register</button>
        </form>

        <div class="actions">
            <a href="test_login.jsp">Already have an account? Login</a>
        </div>
    </div>
</div>
</body>
</html>
