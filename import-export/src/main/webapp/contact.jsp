<%@page import="models.User"%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!doctype html>
<html lang="en">
<head>
    <title>Contact Us - Import & Export Pvt. Ltd.</title>
    <meta charset="utf-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1" />
    <!-- Bootstrap & Font Awesome -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet" />
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" rel="stylesheet" />
    
    <style>
        html, body {
            height: 100%;
            margin: 0;
        }

        body {
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            background: linear-gradient(to right, #f3f4f6, #e0e0e0);
            overflow-x: hidden;
            transition: all 0.3s ease-in-out;
            user-select: none;
            display: flex;
            flex-direction: column;
        }

        .page-wrapper {
            flex: 1;
        }

        .main-content {
            padding-top: 1.5rem;
            padding-bottom: 2rem;
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

        .navbar {
            background: rgba(33, 37, 41, 0.95);
            backdrop-filter: blur(8px);
            box-shadow: 0 2px 10px rgba(0, 0, 0, 0.15);
        }

        .navbar-brand {
            font-weight: 600;
            font-size: 1.25rem;
            color: white !important;
            display: flex;
            align-items: center;
            gap: 10px;
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

        /* Contact Form Styling */
        .contact-info {
            background-color: #f8f9fa;
            border-radius: 12px;
            padding: 30px 25px;
            box-shadow: 0 6px 15px rgba(0, 0, 0, 0.07);
        }

        .btn-primary:hover {
            background-color: #e0a800;
        }

        h2 {
            font-weight: 700;
            color: #343a40;
            border-bottom: 3px solid #ffc107;
            display: inline-block;
            padding-bottom: 6px;
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
        }
    </style>
</head>

<body>
<%
    HttpSession httpSession = request.getSession(false);
    User user = (User) httpSession.getAttribute("user");
    String logoURL = "https://i.pinimg.com/736x/6e/7a/d2/6e7ad228bb4ca7a98e7616362f2cf659.jpg";
    boolean isConsumer = user != null && "Consumer".equals(user.getRole());
%>

<!-- Sidebar -->
<div class="sidebar" id="mySidebar">
    <div class="logo">
        <img src="<%= logoURL %>" alt="Logo" />
        <h5>Import & Export Pvt. Ltd.</h5>
    </div>
    <a href="javascript:void(0)" class="close-btn" onclick="toggleSidebar()">✖ Close</a>
    <% if (isConsumer) { %>
        <a href="ProductController?action=view">Products</a>
        <a href="track_orders.jsp">Orders</a>
        <a href="view_consumer_reports.jsp">Reports</a>
    <% } else { %>
        <a href="ProductController?action=view">My Products</a>
        <a href="OrderController">Orders</a>
        <a href="ReportedProductsController">Reports</a>
        <a href="#">Sales</a>
    <% } %>
</div>

<!-- Page Content -->
<div class="page-wrapper">
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
                    <li class="nav-item"><a class="nav-link" href="ProductController?action=view">Home</a></li>
                    <li class="nav-item"><a class="nav-link" href="about.jsp">About</a></li>
                    <li class="nav-item"><a class="nav-link active" href="contact.jsp">Contact</a></li>
                    <li class="nav-item"><a class="nav-link" href="test_session_info.jsp">Profile</a></li>
                </ul>
            </div>
        </div>
    </nav>

    <!-- Main -->
    <div class="main-content container mt-4">
        <h2 class="mb-4 text-center">Contact Us</h2>
        <div class="row g-4">
            <div class="col-md-6">
                <form>
                    <div class="mb-3">
                        <label for="name" class="form-label">Your Name</label>
                        <input type="text" class="form-control" id="name" placeholder="John Doe" required />
                    </div>
                    <div class="mb-3">
                        <label for="email" class="form-label">Your Email</label>
                        <input type="email" class="form-control" id="email" placeholder="example@email.com" required />
                    </div>
                    <div class="mb-3">
                        <label for="subject" class="form-label">Subject</label>
                        <input type="text" class="form-control" id="subject" placeholder="Query regarding..." required />
                    </div>
                    <div class="mb-3">
                        <label for="message" class="form-label">Message</label>
                        <textarea class="form-control" id="message" rows="5" placeholder="Your message here..." required></textarea>
                    </div>
                    <button type="submit" class="btn btn-primary w-100">Send Message</button>
                </form>
            </div>
            <div class="col-md-6">
                <div class="contact-info h-100">
                    <h5>Get in Touch</h5>
                    <p><strong>Address:</strong> 123, SDAC Lane, Tech City, India</p>
                    <p><strong>Email:</strong> support@sdac.in</p>
                    <p><strong>Phone:</strong> +91 98765 43210</p>
                    <p><strong>Hours:</strong> Mon - Fri: 9:00 AM - 6:00 PM</p>
                </div>
            </div>
        </div>
        <div class="row mt-5">
            <div class="col-12">
                <h4 class="text-center mb-3">Locate Us</h4>
                <div class="ratio ratio-16x9 shadow rounded-4 overflow-hidden">
                    <iframe
                        src="https://www.google.com/maps/embed?pb=!1m18..."
                        allowfullscreen="" loading="lazy" referrerpolicy="no-referrer-when-downgrade"></iframe>
                </div>
            </div>
        </div>
    </div>
</div>

<!-- Footer -->
<footer class="footer">
    <div class="footer-content text-center">
        <h6>&copy; 2025 Import & Export Pvt. Ltd.</h6>
        <div class="social-icons mt-3">
            <a href="https://facebook.com" target="_blank"><i class="fab fa-facebook-f"></i></a>
            <a href="https://twitter.com" target="_blank"><i class="fab fa-twitter"></i></a>
            <a href="https://instagram.com" target="_blank"><i class="fab fa-instagram"></i></a>
            <a href="https://linkedin.com" target="_blank"><i class="fab fa-linkedin-in"></i></a>
            <a href="https://youtube.com" target="_blank"><i class="fab fa-youtube"></i></a>
            <a href="https://github.com" target="_blank"><i class="fab fa-github"></i></a>
        </div>
    </div>
</footer>

<!-- Scripts -->
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
<script>
    function toggleSidebar() {
        document.body.classList.toggle("sidebar-open");
    }
</script>
</body>
</html>
