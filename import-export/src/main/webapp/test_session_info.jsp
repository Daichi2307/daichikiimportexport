<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="models.User"%>
<%@ page session="true"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <title>Session Info - Import & Export Pvt. Ltd.</title>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1" />
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet" />

    <style>
        /* Base Reset & Font */
html, body {
    height: 100%;
    margin: 0;
    padding: 0;
    font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
    background: linear-gradient(120deg, #d9e2ec, #f3f4f6);
    overflow-x: hidden;
}

/* Layout Flex Structure */
body {
    display: flex;
    flex-direction: column;
    min-height: 100vh;
}

/* Main Content */
.main-content {
    flex: 1 0 auto;
    padding: 2rem 1rem 0 1rem;
    transition: margin-left 0.4s ease;
}

/* Sidebar Open Shift */
.sidebar-open .main-content {
    margin-left: 250px;
}

/* Sidebar */
.sidebar {
    height: 100%;
    width: 250px;
    position: fixed;
    top: 0;
    left: -250px;
    background: linear-gradient(145deg, #343a40, #1d1f21);
    transition: left 0.4s ease;
    padding-top: 20px;
    z-index: 1050;
    box-shadow: 3px 0 15px rgba(0, 0, 0, 0.3);
    color: white;
    overflow-y: auto;
}
.sidebar-open .sidebar {
    left: 0;
}

/* Sidebar Logo */
.sidebar .logo {
    text-align: center;
    margin-bottom: 20px;
}
.sidebar .logo img {
    width: 80px;
    border-radius: 50%;
    margin-top: 10px;
}
.sidebar .logo h5 {
    margin-top: 10px;
    font-size: 16px;
    font-weight: 600;
    color: #ffc107;
}

/* Sidebar Links */
.sidebar a {
    padding: 14px 22px;
    text-decoration: none;
    font-size: 16px;
    color: #ffffff;
    display: block;
    transition: all 0.3s ease-in-out;
}
.sidebar a:hover {
    background-color: #495057;
    padding-left: 30px;
}

/* Navbar */
.navbar {
    background: rgba(33, 37, 41, 0.9);
    backdrop-filter: blur(8px);
    box-shadow: 0 2px 10px rgba(0, 0, 0, 0.15);
}
.navbar-brand {
    font-weight: bold;
    font-size: 1.3rem;
    display: flex;
    align-items: center;
    gap: 10px;
    color: #ffffff !important;
}
.navbar-brand img {
    width: 40px;
    height: 40px;
    border-radius: 50%;
}
.navbar-nav .nav-link {
    color: #e9ecef !important;
    font-weight: 500;
    margin-left: 10px;
    transition: all 0.3s ease-in-out;
}
.navbar-nav .nav-link:hover,
.navbar-nav .nav-link.active {
    color: #ffc107 !important;
    transform: scale(1.05);
}

/* Card Styling */
.card {
    border-radius: 18px;
    background: rgba(255, 255, 255, 0.95);
    backdrop-filter: blur(12px);
    box-shadow: 0 20px 40px rgba(0, 0, 0, 0.1);
    border: none;
    transition: transform 0.3s ease;
}
.card:hover {
    transform: translateY(-6px);
}
.card-body p {
    font-size: 16px;
    margin-bottom: 0.5rem;
}

/* Buttons */
.btn {
    transition: transform 0.3s ease, background-color 0.3s ease;
    border-radius: 12px;
    font-weight: 600;
}
.btn:hover {
    transform: scale(1.05);
}
.btn-warning {
    background-color: #ffc107;
    color: #000;
    border: none;
}
.btn-warning:hover {
    background-color: #e0a800;
    color: #fff;
}

/* Alerts */
.alert {
    border-radius: 10px;
    padding: 1rem;
}

/* Heading */
h2 {
    font-weight: bold;
    color: #343a40;
    border-bottom: 2px solid #0000FF;
    display: inline-block;
    padding-bottom: 6px;
    margin-bottom: 1.5rem;
}

/* Animation */
@keyframes fadeInUp {
    0% { transform: translateY(20px); opacity: 0; }
    100% { transform: translateY(0); opacity: 1; }
}
.animated-card {
    animation: fadeInUp 0.6s ease forwards;
}

/* Footer Styling */
footer.footer {
    flex-shrink: 0;
    height: 130px;
    background: linear-gradient(90deg, #343a40, #1d1f21);
    color: white;
    box-shadow: 0 -2px 12px rgba(0, 0, 0, 0.3);
    display: flex;
    align-items: center;
    justify-content: center;
    flex-direction: column;
    padding: 10px 20px;
    text-align: center;
}
.footer .social-icons {
    display: flex;
    justify-content: center;
    gap: 20px;
}
.footer .social-icons a {
    color: #ffffff;
    font-size: 1.4rem;
    transition: all 0.3s ease-in-out;
}
.footer .social-icons a:hover {
    color: #ffc107;
    transform: scale(1.3);
    text-shadow: 0 0 10px #ffc107;
}

    </style>
</head>

<body>

<%
    HttpSession httpSession = request.getSession(false);
    User user = (User) httpSession.getAttribute("user");
    String logoURL = "https://i.pinimg.com/736x/6e/7a/d2/6e7ad228bb4ca7a98e7616362f2cf659.jpg";
    if(user.getRole().equals("Consumer")) {
%>
    <div class="sidebar" id="mySidebar">
        <div class="logo">
            <img src="<%=logoURL%>" alt="Logo" />
            <h5>Import & Export Pvt. Ltd.</h5>
        </div>
        <a href="javascript:void(0)" onclick="toggleSidebar()">✖ Close</a>
        <a href="ProductController?action=view">Products</a>
        <a href="track_orders.jsp">Orders</a>
        <a href="view_consumer_reports.jsp">Reports</a>
    </div>
<% } else { %>
    <div class="sidebar" id="mySidebar">
        <div class="logo">
            <img src="<%=logoURL%>" alt="Logo" />
            <h5>Import & Export Pvt. Ltd.</h5>
        </div>
        <a href="javascript:void(0)" onclick="toggleSidebar()">✖ Close</a>
        <a href="ProductController?action=view">My Products</a>
        <a href="OrderController">Orders</a>
        <a href="ReportedProductsController">Reports</a>
        <a href="#">Sales</a>
    </div>
<% } %>

    <!-- Modern Navbar -->
    <nav class="navbar navbar-expand-lg navbar-dark">
        <div class="container-fluid">
            <span class="navbar-brand me-3" onclick="toggleSidebar()" style="cursor: pointer;">☰</span>
            <a class="navbar-brand" href="#">
                <img src="<%=logoURL%>" alt="Logo">
                Import & Export Pvt. Ltd.
            </a>
            <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#navbarContent">
                <span class="navbar-toggler-icon"></span>
            </button>

            <div class="collapse navbar-collapse" id="navbarContent">
                <ul class="navbar-nav ms-auto">
                    <li class="nav-item"><a class="nav-link" href="ProductController?action=view">Home</a></li>
                    <li class="nav-item"><a class="nav-link" href="about.jsp">About</a></li>
                    <li class="nav-item"><a class="nav-link" href="contact.jsp">Contact</a></li>
                    <li class="nav-item"><a class="nav-link active" href="test_session_info.jsp">Profile</a></li>
                </ul>
            </div>
        </div>
    </nav>

    <!-- Main Content -->
    <div class="main-content p-4">
        <div class="container mt-4">
            <h2 class="mb-4">Session Information</h2>

            <%
                if (user != null) {
            %>
            <div class="card shadow-sm border-0 mb-3 animated-card">
    <div class="card-body">
        <div class="mb-3">
            <p><strong>Port ID:</strong> <%=user.getPortId()%></p>
            <p><strong>Location:</strong> <%=user.getLocation()%></p>
            <p><strong>Role:</strong> <%=user.getRole()%></p>
        </div>
        <div class="d-flex flex-wrap gap-3">
            <a href="Logout" class="btn btn-danger">Logout</a>
            <a href="update_profile.jsp" class="btn btn-warning">Update</a>
            <form action="Login" method="post" style="display: inline-flex; margin-bottom: 0;">
                <input type="hidden" name="action" value="delete" />
                <input type="hidden" name="port_id" value="<%=user.getPortId()%>" />
                <input type="hidden" name="role" value="<%= user.getRole() %>" />
                <button type="submit" class="btn btn-danger">Delete</button>
            </form>
        </div>
    </div>
</div>

            <% } else { %>
            <div class="alert alert-warning">No user is currently logged in.</div>
            <a href="login.jsp" class="btn btn-primary">Login Here</a>
            <% } %>
        </div>
    </div>

    <!-- Footer -->
    <footer class="footer">
        <div class="footer-content text-center">
            <h6 class="mb-3">&copy; 2025 Import & Export Pvt. Ltd.</h6>
            <div class="social-icons">
                <a href="https://facebook.com" target="_blank"><i class="fab fa-facebook-f"></i></a>
                <a href="https://twitter.com" target="_blank"><i class="fab fa-twitter"></i></a>
                <a href="https://instagram.com" target="_blank"><i class="fab fa-instagram"></i></a>
                <a href="https://linkedin.com" target="_blank"><i class="fab fa-linkedin-in"></i></a>
                <a href="https://youtube.com" target="_blank"><i class="fab fa-youtube"></i></a>
                <a href="https://github.com" target="_blank"><i class="fab fa-github"></i></a>
            </div>
        </div>
    </footer>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/js/all.min.js"></script>

    <script>
        function toggleSidebar() {
            document.body.classList.toggle("sidebar-open");
        }
    </script>
</body>
</html>
