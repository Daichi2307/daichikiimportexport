<%@page import="models.User"%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!doctype html>
<html lang="en">

<head>
    <title>About Us - Import & Export Pvt. Ltd.</title>
    <meta charset="utf-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1" />
    <!-- Bootstrap CSS -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet" />
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" rel="stylesheet" />

    <style>
        html, body {
            height: 100%;
            margin: 0;
            padding: 0;
        }

        body {
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            background: linear-gradient(to right, #f3f4f6, #e0e0e0);
            overflow-x: hidden;
            transition: all 0.3s ease-in-out;
        }

        /* Wrapper for sticky footer */
        .page-wrapper {
            min-height: 100vh; /* full viewport height */
            display: flex;
            flex-direction: column;
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

        /* Sidebar logo area */
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
            padding: 0 15px;
            box-shadow: 0 2px 10px rgba(0,0,0,0.2);
            z-index: 1060;
        }

        .sidebar .logo img {
            width: 35px;
            height: 35px;
            border-radius: 50%;
            object-fit: cover;
        }

        .sidebar .logo h5 {
            margin: 0;
            font-size: 16px;
            font-weight: 600;
            color: white;
            user-select: none;
        }

        /* Sidebar show */
        .sidebar-open .sidebar {
            left: 0;
        }

        /* Content margin when sidebar open */
        .sidebar-open .main-content {
            margin-left: 250px;
        }

        .main-content {
            flex: 1; /* take all available vertical space */
            transition: margin-left 0.4s ease;
            padding-top: 1.5rem;
            padding-bottom: 2rem;
            min-height: auto;
        }

        /* Sidebar links */
        .sidebar a {
            padding: 15px 25px;
            display: block;
            color: white;
            text-decoration: none;
            font-size: 16px;
            font-weight: 500;
            transition: all 0.3s ease-in-out;
            user-select: none;
        }

        .sidebar a:hover {
            background-color: #495057;
            padding-left: 35px;
            color: #ffc107;
        }

        /* Sidebar close button */
        .sidebar a.close-btn {
            font-size: 20px;
            font-weight: 700;
            text-align: right;
            padding-right: 25px;
            cursor: pointer;
            user-select: none;
        }

        /* Navbar */
        .navbar {
            background: rgba(33, 37, 41, 0.95);
            backdrop-filter: blur(8px);
            box-shadow: 0 2px 10px rgba(0, 0, 0, 0.15);
            padding: 0.5rem 1rem;
        }

        /* Navbar brand container */
        .navbar-brand {
            font-weight: 600;
            font-size: 1.25rem;
            color: white !important; /* WHITE text */
            display: flex;
            align-items: center;
            gap: 10px;
            user-select: none;
        }

        .navbar-brand:hover {
            color: #e0a800 !important; /* subtle gold on hover */
            text-decoration: none;
        }

        /* Logo image in navbar */
        .navbar-brand img {
            width: 40px;
            height: 40px;
            border-radius: 50%;
            object-fit: cover;
            user-select: none;
        }

        /* Navbar nav links */
        .navbar-nav .nav-link {
            color: white !important; /* WHITE text */
            font-weight: 500;
            margin-left: 12px;
            transition: all 0.3s ease-in-out;
            user-select: none;
        }

        .navbar-nav .nav-link:hover,
        .navbar-nav .nav-link.active {
            color: #ffc107 !important;
            transform: scale(1.05);
        }

        /* Hamburger icon */
        .navbar-brand.toggle-sidebar {
            font-size: 1.6rem;
            cursor: pointer;
            user-select: none;
            margin-right: 1rem;
            color: #ffc107;
            transition: color 0.3s ease;
        }

        .navbar-brand.toggle-sidebar:hover {
            color: #ffca2c;
        }

        /* Hero images */
        .hero-img {
            border-radius: 15px;
            box-shadow: 0 10px 25px rgba(0, 0, 0, 0.12);
            transition: transform 0.3s ease;
            max-width: 100%;
        }

        .hero-img:hover {
            transform: scale(1.03);
        }

        /* Section headings */
        h3 {
            font-weight: 700;
            color: #343a40;
            margin-bottom: 1rem;
            border-bottom: 3px solid #ffc107;
            display: inline-block;
            padding-bottom: 6px;
        }

        /* Paragraphs */
        p {
            color: #5a5a5a;
            font-size: 1.05rem;
            line-height: 1.6;
        }

        /* Video container */
        .ratio {
            box-shadow: 0 8px 30px rgba(0, 0, 0, 0.12);
            border-radius: 12px;
            overflow: hidden;
        }

        /* Animated fade-in */
        @keyframes fadeInUp {
            0% {
                transform: translateY(25px);
                opacity: 0;
            }

            100% {
                transform: translateY(0);
                opacity: 1;
            }
        }

        .animated-fadein {
            animation: fadeInUp 0.7s ease forwards;
        }

        /* Footer Styling (non-fixed) */
        footer.footer {
            position: relative; /* changed from fixed */
            width: 100%;
            height: 130px;
            background: linear-gradient(90deg, #343a40, #1d1f21);
            color: white;
            z-index: 999;
            box-shadow: 0 -2px 12px rgba(0,0,0,0.3);
            display: flex;
            align-items: center;
            justify-content: center;
            flex-direction: column;
            padding: 10px 20px;
            text-align: center;
            margin-top: 40px; /* space above footer */
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
    models.User user = (models.User) httpSession.getAttribute("user");
    boolean isConsumer = user != null && "Consumer".equals(user.getRole());
    String logoURL = "https://i.pinimg.com/736x/6e/7a/d2/6e7ad228bb4ca7a98e7616362f2cf659.jpg";
%>

<div class="page-wrapper">
    <!-- Sidebar -->
    <div class="sidebar bg-dark" id="mySidebar">
        <div class="logo">
            <img src="<%=logoURL%>" alt="Logo" />
            <h5>Import & Export Pvt. Ltd.</h5>
        </div>
        <a class="close-btn text-white" onclick="toggleSidebar()">✖ Close</a>
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

    <!-- Navbar -->
    <nav class="navbar navbar-expand-lg navbar-dark">
        <div class="container-fluid">
            <span class="navbar-brand toggle-sidebar" onclick="toggleSidebar()">☰</span>
            <a class="navbar-brand" href="#">
                <img src="<%=logoURL%>" alt="Logo" />
                Import & Export Pvt. Ltd.
            </a>
            <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#navbarContent"
                aria-controls="navbarContent" aria-expanded="false" aria-label="Toggle navigation">
                <span class="navbar-toggler-icon"></span>
            </button>

            <div class="collapse navbar-collapse" id="navbarContent">
                <ul class="navbar-nav ms-auto">
                    <li class="nav-item"><a class="nav-link" href="ProductController?action=view">Home</a></li>
                    <li class="nav-item"><a class="nav-link active" href="about.jsp">About</a></li>
                    <li class="nav-item"><a class="nav-link" href="contact.jsp">Contact</a></li>
                    <li class="nav-item"><a class="nav-link" href="test_session_info.jsp">Profile</a></li>
                </ul>
            </div>
        </div>
    </nav>

    <!-- Main Content -->
    <div class="main-content p-4 animated-fadein">
        <div class="container mt-5">
            <div class="row align-items-center mb-5">
                <div class="col-md-6 mb-4">
                    <img src="https://media.istockphoto.com/id/1416040835/photo/aerial-view-of-a-large-loaded-container-cargo-ship-in-motion.jpg?s=612x612&w=0&k=20&c=ZP5DjN5ctgeefdvOBTHhx0h39gSsr2POQ4iw5ZuZRIU=" alt="About Image" class="hero-img" />
                </div>
                <div class="col-md-6">
                    <h3>Who We Are</h3>
                    <p>
                        Mission and Values:
                        Clearly state the company's purpose and guiding principles. For example, is it focused on speed, reliability, cost-effectiveness, or sustainability? 
                        History and Experience:
                        Briefly describe how long the company has been in business and its experience in the shipping and logistics sector. 
                        Unique Selling Proposition (USP):
                        Highlight what makes the company stand out from competitors. This could be specialized services, technology, or a particular area of expertise. 
                    </p>
                </div>
            </div>

            <div class="row align-items-center mb-5 flex-md-row-reverse">
                <div class="col-md-6 mb-4">
                    <img src="https://www.shutterstock.com/image-photo/container-vessel-during-discharging-industrial-600nw-739896253.jpg"
                        alt="Vision" class="hero-img" />
                </div>
                <div class="col-md-6">
                    <h3>Our Vision</h3>
                    <p>
                        Key Personnel:
                        Introduce the leadership team and key personnel, mentioning their experience and qualifications in the shipping and logistics field.
                        Expertise and Specialization:
                        Highlight the team's expertise in various aspects of shipping, such as customs clearance, different modes of transport (sea, air, land), and specific industry knowledge.
                        Customer-Focused Approach:
                        Emphasize the team's dedication to providing excellent customer service and building strong client relationships. 
                    </p>
                </div>
            </div>

            <div class="row text-center mb-5">
                <div class="col">
                    <h4 class="mb-4">Watch Our Introduction</h4>
                    <div class="ratio ratio-16x9 shadow rounded-4 overflow-hidden">
                        <iframe width="560" height="315" src="https://www.youtube.com/embed/AXqm_r5apls?si=a8ffVD_JblJMPGuf" title="YouTube video player" frameborder="0" allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture; web-share" referrerpolicy="strict-origin-when-cross-origin" allowfullscreen></iframe>
                    </div>
                </div>
            </div>
        </div>
    </div>

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
</div>

<!-- Bootstrap JS + Popper -->
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>

<script>
    function toggleSidebar() {
        document.body.classList.toggle("sidebar-open");
    }
</script>

</body>

</html>
