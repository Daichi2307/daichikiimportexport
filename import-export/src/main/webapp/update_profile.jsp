<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="models.User" %>
<%@ page session="true" %>
<!DOCTYPE html>
<html lang="en">

<head>
    <title>Update Profile - Import & Export Pvt. Ltd.</title>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1" />

    <!-- Bootstrap CSS -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet" />

    <!-- FontAwesome -->
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" rel="stylesheet" />

    <style>
        @import url('https://fonts.googleapis.com/css2?family=Inter:wght@400;600;700&display=swap');

        html, body {
            height: 100%;
            margin: 0;
            font-family: 'Inter', sans-serif;
            background: linear-gradient(120deg, #dbeafe, #e0f2fe, #fce7f3);
            background-size: 300% 300%;
            animation: gradientFlow 12s ease infinite;
            display: flex;
            justify-content: center;
            align-items: center;
            padding: 1rem;
        }

        @keyframes gradientFlow {
            0% { background-position: 0% 50%; }
            50% { background-position: 100% 50%; }
            100% { background-position: 0% 50%; }
        }

        .update-wrapper {
            background: rgba(255, 255, 255, 0.85);
            backdrop-filter: blur(12px);
            border-radius: 20px;
            box-shadow: 0 20px 40px rgba(0, 0, 0, 0.2);
            padding: 3rem 2.5rem;
            width: 500px;
            max-width: 500px;
            position: relative;
            animation: fadeIn 0.8s ease-in-out;
        }

        @keyframes fadeIn {
            0% { transform: translateY(30px); opacity: 0; }
            100% { transform: translateY(0); opacity: 1; }
        }

        h3 {
            font-weight: 700;
            color: #1f2937;
            text-align: center;
            margin-bottom: 2.5rem;
            user-select: none;
        }

        label {
            font-weight: 600;
            color: #374151;
        }

        input.form-control,
        select.form-select {
            border-radius: 12px;
            padding: 14px 18px;
            font-size: 16px;
            border: 1.5px solid #d1d5db;
            transition: all 0.3s ease;
        }

        input.form-control:focus,
        select.form-select:focus {
            border-color: #3b82f6;
            box-shadow: 0 0 12px #3b82f677;
            outline: none;
        }

        button.btn-primary {
            background: linear-gradient(to right, #3b82f6, #6366f1);
            color: #ffffff;
            border: none;
            font-weight: 700;
            font-size: 17px;
            border-radius: 14px;
            padding: 14px;
            width: 100%;
            margin-top: 2rem;
            transition: transform 0.3s ease, box-shadow 0.3s ease;
        }

        button.btn-primary:hover {
            transform: scale(1.05);
            box-shadow: 0 8px 18px rgba(99, 102, 241, 0.4);
        }

        .back-btn {
            position: absolute;
            top: 20px;
            left: 20px;
            background: transparent;
            border: none;
            color: #334155;
            font-weight: 600;
            font-size: 1rem;
            display: flex;
            align-items: center;
            gap: 6px;
            cursor: pointer;
            transition: color 0.3s ease, transform 0.3s ease;
        }

        .back-btn:hover {
            color: #6366f1;
        }

        .back-btn i {
            font-size: 1.2rem;
            transition: transform 0.3s ease;
        }

        .back-btn:hover i {
            transform: translateX(-4px);
        }

        @media (max-width: 640px) {
            .update-wrapper {
                padding: 2rem 1.2rem;
            }
        }
    </style>
</head>

<body>
    <%
        HttpSession httpSession = request.getSession(false);
        User user = (User) httpSession.getAttribute("user");
        if (user == null) {
            response.sendRedirect("test_login.jsp");
            return;
        }
    %>

    <div class="update-wrapper">
        <!-- Back button -->
        <form action="test_session_info.jsp" method="get" style="display:inline;">
            <button type="submit" class="back-btn" title="Go back">
                <i class="fas fa-arrow-left"></i> Back
            </button>
        </form>

        <h3>Update Profile</h3>

        <form action="Login" method="post" novalidate>
            <input type="hidden" name="action" value="update" />
            <input type="hidden" name="port_id" value="<%= user.getPortId() %>" />

            <div class="mb-4">
                <label for="location" class="form-label">Location</label>
                <input type="text" class="form-control" id="location" name="location" value="<%= user.getLocation() %>"
                    required placeholder="Enter your location" />
            </div>

            <div class="mb-4">
                <label for="password" class="form-label">New Password</label>
                <input type="password" class="form-control" id="password" name="password" value="<%= user.getPassword() %>" placeholder="Enter new password" />
            </div>

            <div class="mb-4">
                <label for="role" class="form-label">Role</label>
                <select class="form-select" id="role" name="role" required>
                    <option value="Consumer" <%= "Consumer".equals(user.getRole()) ? "selected" : "" %>>Consumer</option>
                    <option value="Seller" <%= "Seller".equals(user.getRole()) ? "selected" : "" %>>Seller</option>
                </select>
            </div>

            <button type="submit" class="btn btn-primary">Update Profile</button>
        </form>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/js/all.min.js"></script>
</body>

</html>
