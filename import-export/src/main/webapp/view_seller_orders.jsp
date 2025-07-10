<%@ page contentType="text/html;charset=UTF-8" language="java"%>
<%@ page import="java.util.List"%>
<%@ page import="models.Order"%>
<html>
<head>
    <title>Seller Orders - Import & Export Pvt. Ltd.</title>
    <meta charset="utf-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1" />
    <!-- Bootstrap & FontAwesome -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet" />
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" rel="stylesheet" />

    <style>
        /* General */
        body {
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            background: linear-gradient(to right, #f3f4f6, #e0e0e0);
            overflow-x: hidden;
            transition: all 0.3s ease-in-out;
            user-select: none;
            margin: 0;
            padding-top: 60px; /* space for fixed navbar */
            display: flex;
            flex-direction: column;
            min-height: 100vh;
        }

        /* Sidebar */
        .sidebar {
            height: 100vh;
            width: 250px;
            position: fixed;
            top: 0;
            left: -250px;
            background: linear-gradient(145deg, #343a40, #1d1f21);
            transition: left 0.4s ease;
            padding-top: 60px;
            z-index: 1050;
            box-shadow: 3px 0 15px rgba(0, 0, 0, 0.3);
            color: white;
            overflow-y: auto;
        }

        .sidebar-open .sidebar {
            left: 0;
        }

        .sidebar-open .main-content {
            margin-left: 250px;
        }

        .sidebar .logo {
            position: fixed;
            top: 0;
            width: 250px;
            height: 60px;
            background: linear-gradient(145deg, #212529, #1a1c1f);
            display: flex;
            align-items: center;
            justify-content: center;
            gap: 10px;
            z-index: 1060;
        }

        .sidebar .logo img {
            width: 40px;
            height: 40px;
            border-radius: 50%;
            object-fit: cover;
        }

        .sidebar .logo h5 {
            margin: 0;
            font-size: 18px;
            font-weight: 600;
            color: #ffc107;
        }

        .sidebar a {
            padding: 15px 25px;
            display: block;
            color: white;
            font-size: 16px;
            text-decoration: none;
            transition: 0.3s ease-in-out;
        }

        .sidebar a:hover {
            background-color: #495057;
            padding-left: 35px;
            color: #ffc107;
        }

        .sidebar a.close-btn {
            font-size: 20px;
            font-weight: 700;
            text-align: right;
            padding-right: 25px;
            cursor: pointer;
        }

        /* Navbar */
        nav.navbar {
            position: fixed;
            top: 0;
            left: 0;
            right: 0;
            background: rgba(33, 37, 41, 0.95);
            backdrop-filter: blur(8px);
            box-shadow: 0 2px 10px rgba(0, 0, 0, 0.15);
            padding: 0.5rem 1rem;
            display: flex;
            align-items: center;
            gap: 15px;
            z-index: 1100;
        }

        .navbar-brand {
            font-weight: 600;
            font-size: 1.25rem;
            color: white !important;
            display: flex;
            align-items: center;
            gap: 10px;
            user-select: none;
        }

        .navbar-brand img {
            width: 40px;
            height: 40px;
            border-radius: 50%;
            object-fit: cover;
        }

        .navbar-nav .nav-link {
            color: white !important;
            font-weight: 500;
            margin-left: 12px;
        }

        .navbar-nav .nav-link:hover,
        .navbar-nav .nav-link.active {
            color: #ffc107 !important;
        }

        .toggle-sidebar {
            font-size: 1.6rem;
            cursor: pointer;
            margin-right: 1rem;
            color: #ffc107;
        }

        .title-back-container {
            display: flex;
            align-items: center;
            gap: 20px;
            margin-bottom: 25px;
            padding: 15px 25px;
            background: white;
            border-radius: 12px;
            box-shadow: 0 8px 20px rgba(0, 0, 0, 0.1);
            border-bottom: 4px solid #ffc107;
            max-width: 600px;
        }

        .page-title {
            font-weight: 700;
            font-size: 1.8rem;
            color: #212529;
            margin: 0;
        }

        .back-button {
            padding: 8px 18px;
            font-size: 1rem;
            font-weight: 600;
            border-radius: 8px;
            white-space: nowrap;
            box-shadow: 0 3px 8px rgb(224 168 0 / 0.6);
            color: #212529;
            border: 2px solid #ffc107;
            background: #fff;
            transition: all 0.3s ease;
            display: flex;
            align-items: center;
            gap: 8px;
            text-decoration: none;
        }

        .back-button:hover {
            background: #ffc107;
            color: #212529;
            box-shadow: 0 5px 14px rgb(224 168 0 / 0.8);
            text-decoration: none;
        }

        /* Box container for main content */
        .main-content {
            background: white;
            max-width: 1200px;
            margin: 20px auto 40px auto;
            padding: 30px 40px;
            border-radius: 16px;
            box-shadow: 0 12px 25px rgba(0,0,0,0.1);
            min-height: 70vh;
        }

        /* Table styling */
        table.table {
            width: 100%;
            border-collapse: separate;
            border-spacing: 0;
            border-radius: 12px;
            overflow: hidden;
            box-shadow: 0 8px 20px rgba(0,0,0,0.1);
        }

        table.table thead {
            background: linear-gradient(45deg, #ffc107, #e0a800);
            color: #212529;
        }

        table.table thead th {
            font-weight: 700;
            padding: 12px 15px;
        }

        table.table tbody tr {
            transition: background-color 0.25s ease;
        }

        table.table tbody tr:hover {
            background-color: #fff3cd;
        }

        table.table tbody td {
            padding: 12px 15px;
            vertical-align: middle;
            border-bottom: 1px solid #dee2e6;
        }

        /* Buttons */
        button.btn-primary {
            background: linear-gradient(45deg, #ffc107, #e0a800);
            border: none;
            box-shadow: 0 3px 8px rgb(224 168 0 / 0.6);
            transition: transform 0.25s ease, box-shadow 0.25s ease;
            color: #212529;
            font-weight: 600;
        }

        button.btn-primary:hover {
            transform: scale(1.05);
            box-shadow: 0 5px 14px rgb(224 168 0 / 0.8);
            color: #212529;
        }

        /* Responsive */
        @media (max-width: 767px) {
            .sidebar {
                width: 200px;
                left: -200px;
            }

            .sidebar-open .sidebar {
                left: 0;
            }

            .sidebar-open .main-content {
                margin-left: 200px;
            }

            .main-content {
                padding: 20px 20px;
                margin: 10px 15px 30px 15px;
            }

            .title-back-container {
                flex-direction: column;
                gap: 10px;
                max-width: 100%;
                padding: 15px 20px;
            }
        }

        /* Scrollbar for sidebar */
        .sidebar::-webkit-scrollbar {
            width: 6px;
        }
        .sidebar::-webkit-scrollbar-thumb {
            background-color: #ffc107;
            border-radius: 3px;
        }

        /* Footer */
        footer.footer {
            background: linear-gradient(90deg, #343a40, #1d1f21);
            color: white;
            padding: 30px 20px;
            text-align: center;
        }

        .footer-content h6 {
            margin-bottom: 15px;
            font-size: 1rem;
        }

        .social-icons {
            display: flex;
            justify-content: center;
            gap: 20px;
        }

        .social-icons a {
            color: white;
            font-size: 1.4rem;
            transition: 0.3s;
        }

        .social-icons a:hover {
            color: #ffc107;
            transform: scale(1.3);
            text-shadow: 0 0 10px #ffc107;
        }
    </style>
</head>
<body>

<%
    String logoURL = "https://i.pinimg.com/736x/6e/7a/d2/6e7ad228bb4ca7a98e7616362f2cf659.jpg";
%>

<!-- Sidebar -->
<div class="sidebar" id="mySidebar">
    <div class="logo">
        <img src="<%= logoURL %>" alt="Logo" />
        <h5>Import & Export Pvt. Ltd.</h5>
    </div>
    <a href="javascript:void(0)" class="close-btn" onclick="toggleSidebar()">✖ Close</a>
    <a href="ProductController?action=view">My Products</a>
    <a href="OrderController">Orders</a>
    <a href="ReportedProductsController">Reports</a>
    <a href="seller_sales.jsp">Sales</a>
</div>

<!-- Navbar -->
<nav class="navbar navbar-expand-lg navbar-dark">
    <div class="container-fluid">
        <span class="navbar-brand toggle-sidebar" onclick="toggleSidebar()">☰</span>
        <a class="navbar-brand" href="#">
            <img src="<%= logoURL %>" alt="Logo" />
            Import & Export Pvt. Ltd.
        </a>
        <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#navbarContent">
            <span class="navbar-toggler-icon"></span>
        </button>
        <div class="collapse navbar-collapse" id="navbarContent">
            <ul class="navbar-nav ms-auto">
                <li class="nav-item"><a class="nav-link active" href="ProductController?action=view">Home</a></li>
                <li class="nav-item"><a class="nav-link" href="about.jsp">About</a></li>
                <li class="nav-item"><a class="nav-link" href="contact.jsp">Contact</a></li>
                <li class="nav-item"><a class="nav-link" href="test_session_info.jsp">Profile</a></li>
            </ul>
        </div>
    </div>
</nav>

<!-- Main Content -->
<div class="main-content">

    <div class="title-back-container">
        <a href="ProductController?action=view" class="back-button">
            <i class="fas fa-arrow-left"></i> Back
        </a>
        <h3 class="page-title">Seller Orders</h3>
    </div>

    <%
        String msg = (String) request.getAttribute("message");
        if (msg != null) {
    %>
    <div class="alert alert-success"><%=msg%></div>
    <%
        }
    %>

    <table class="table table-bordered table-hover">
        <thead>
        <tr>
            <th>Order ID</th>
            <th>Product</th>
            <th>Price</th>
            <th>Consumer ID</th>
            <th>Quantity</th>
            <th>Date</th>
            <th>Delivery Status</th>
            <th>Action</th>
        </tr>
        </thead>
        <tbody>
        <%
            List<Order> orders = (List<Order>) request.getAttribute("orderList");
            if (orders != null) {
                for (Order o : orders) {
                    String currentStatus = "--Select Status--";
                    if (o.isDelivered()) {
                        currentStatus = "Delivered";
                    } else if (o.isOutForDelivery()) {
                        currentStatus = "Out for Delivery";
                    } else if (o.isShipped()) {
                        currentStatus = "Shipped";
                    }
        %>
        <form action="OrderController" method="post">
            <tr>
                <td><%= o.getOrderId() %></td>
                <td><%= o.getProductName() %></td>
                <td>₹<%= String.format("%.2f", o.getPrice()) %></td>
                <td><%= o.getConsumerPortId() %></td>
                <td><%= o.getQuantity() %></td>
                <td><%= o.getOrderDate() %></td>
                <td>
                    <select class="form-select form-select-sm" name="delivery_status" required>
                        <option value="">-- Select Status --</option>
                        <option value="Shipped" <%= "Shipped".equals(currentStatus) ? "selected" : "" %>>Shipped</option>
                        <option value="Out for Delivery" <%= "Out for Delivery".equals(currentStatus) ? "selected" : "" %>>Out for Delivery</option>
                        <option value="Delivered" <%= "Delivered".equals(currentStatus) ? "selected" : "" %>>Delivered</option>
                    </select>
                </td>
                <td>
                    <input type="hidden" name="action" value="changeStatus" />
                    <input type="hidden" name="order_id" value="<%= o.getOrderId() %>" />
                    <button type="submit" class="btn btn-primary btn-sm">Update</button>
                </td>
            </tr>
        </form>
        <%
                }
            }
        %>
        </tbody>
    </table>
</div>

<!-- Footer -->
<footer class="footer mt-auto" >
    <div class="footer-content">
        <h6>&copy; 2025 Import & Export Pvt. Ltd.</h6>
        <div class="social-icons mt-3">
            <a href="https://facebook.com" target="_blank" rel="noopener"><i class="fab fa-facebook-f"></i></a>
            <a href="https://twitter.com" target="_blank" rel="noopener"><i class="fab fa-twitter"></i></a>
            <a href="https://instagram.com" target="_blank" rel="noopener"><i class="fab fa-instagram"></i></a>
            <a href="https://linkedin.com" target="_blank" rel="noopener"><i class="fab fa-linkedin-in"></i></a>
            <a href="https://youtube.com" target="_blank" rel="noopener"><i class="fab fa-youtube"></i></a>
            <a href="https://github.com" target="_blank" rel="noopener"><i class="fab fa-github"></i></a>
        </div>
    </div>
</footer>

<!-- Bootstrap JS Bundle -->
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>

<script>
    function toggleSidebar() {
        document.body.classList.toggle("sidebar-open");
    }
</script>
</body>
</html>
