<%@ page contentType="text/html;charset=UTF-8" language="java"%>
<%@ page import="java.util.List"%>
<%@ page import="models.Product"%>
<%@ page import="models.User"%>
<%@ page session="true"%>
<!DOCTYPE html>
<html lang="en">
<head>
<title>Products</title>
<!-- Bootstrap CSS -->
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet" />
<link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.5/font/bootstrap-icons.css" rel="stylesheet" />
<link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" rel="stylesheet" />

<style>
    @import url('https://fonts.googleapis.com/css2?family=Inter:wght@400;600;700&display=swap');

    html, body {
        height: 100%;
        margin: 0;
        padding: 0;
        font-family: 'Inter', sans-serif;
        background: linear-gradient(to right, #dbeafe, #e0f2fe);
    }

    .page-wrapper {
        min-height: 100vh;
        display: flex;
        flex-direction: column;
    }

    .main-content {
        flex: 1;
        transition: margin-left 0.4s ease;
        padding-top: 2rem;
        padding-bottom: 2rem;
    }

    .sidebar {
        height: 100vh;
        width: 250px;
        position: fixed;
        top: 0;
        left: -250px;
        background: linear-gradient(145deg, #1f2937, #111827);
        transition: left 0.4s ease;
        padding-top: 60px;
        z-index: 1050;
        box-shadow: 3px 0 15px rgba(0,0,0,0.3);
        color: white;
        overflow-y: auto;
    }

    .sidebar-open .sidebar {
        left: 0;
    }

    .sidebar-open .main-content {
        margin-left: 250px;
    }

    .sidebar a {
        padding: 15px 20px;
        display: block;
        color: #f3f4f6;
        text-decoration: none;
        font-size: 16px;
        transition: all 0.3s ease-in-out;
    }

    .sidebar a:hover {
        background-color: #374151;
        padding-left: 28px;
    }

    .sidebar .logo {
        text-align: center;
        margin-bottom: 20px;
        padding: 10px 0;
    }

    .sidebar .logo img {
        width: 60px;
        height: 60px;
        border-radius: 50%;
        object-fit: cover;
        border: 2px solid #fff;
    }

    .sidebar .logo h5 {
        margin-top: 10px;
        font-size: 14px;
        font-weight: 600;
        color: #facc15;
    }

    .navbar {
        background: rgba(17, 24, 39, 0.85);
        backdrop-filter: blur(6px);
        box-shadow: 0 4px 12px rgba(0, 0, 0, 0.15);
    }

    .navbar-brand {
        font-weight: bold;
        font-size: 1.3rem;
        color: #f9fafb !important;
        display: flex;
        align-items: center;
        gap: 10px;
    }

    .navbar-brand img {
        width: 40px;
        height: 40px;
        border-radius: 50%;
    }

    .navbar-nav .nav-link {
        color: #f9fafb !important;
        font-weight: 500;
        margin-left: 15px;
        transition: 0.3s ease;
    }

    .navbar-nav .nav-link:hover,
    .navbar-nav .nav-link.active {
        color: #facc15 !important;
        transform: scale(1.05);
    }

    .card {
        border-radius: 20px;
        background: rgba(255, 255, 255, 0.75);
        box-shadow: 0 15px 30px rgba(0,0,0,0.12);
        backdrop-filter: blur(10px);
        transition: transform 0.3s ease, box-shadow 0.3s ease;
        min-height: 280px;
        padding: 20px;
    }

    .card:hover {
        transform: translateY(-8px);
        box-shadow: 0 20px 40px rgba(0, 0, 0, 0.15);
    }

    h2 {
        font-weight: bold;
        color: #111827;
        border-bottom: 3px solid #3b82f6;
        display: inline-block;
        padding-bottom: 6px;
        margin-bottom: 1.5rem;
        text-shadow: 1px 1px 0 #f3f4f6;
    }

    .btn {
        transition: 0.3s ease;
        border-radius: 12px;
    }

    .btn:hover {
        transform: scale(1.05);
    }

    .animated-card {
        animation: fadeInUp 0.6s ease forwards;
    }

    @keyframes fadeInUp {
        0% {
            transform: translateY(20px);
            opacity: 0;
        }
        100% {
            transform: translateY(0);
            opacity: 1;
        }
    }

    .footer {
        width: 100%;
        height: 140px;
        background: linear-gradient(to right, #1f2937, #111827);
        color: white;
        z-index: 999;
        box-shadow: 0 -2px 10px rgba(0, 0, 0, 0.25);
        display: flex;
        align-items: center;
        justify-content: center;
        flex-direction: column;
        text-align: center;
        margin-top: 50px;
        padding: 10px;
    }

    .footer .social-icons {
        display: flex;
        justify-content: center;
        gap: 18px;
        margin-top: 8px;
    }

    .footer .social-icons a {
        color: #e5e7eb;
        font-size: 1.3rem;
        transition: 0.3s ease;
    }

    .footer .social-icons a:hover {
        color: #facc15;
        transform: scale(1.3);
        text-shadow: 0 0 10px #facc15;
    }

    .btn-warning {
        background: linear-gradient(to right, #facc15, #fbbf24);
        color: #1f2937;
        font-weight: 600;
        border: none;
    }

    .btn-success {
        background: linear-gradient(to right, #22c55e, #16a34a);
        border: none;
    }

    .alert {
        border-radius: 12px;
        padding: 12px 16px;
        font-weight: 500;
    }

    .form-control {
        border-radius: 12px;
        padding: 8px 12px;
    }
</style>

</head>
<body>
<%
    HttpSession httpSession = request.getSession(false);
    User user = (User) httpSession.getAttribute("user");
    String logoURL = "https://i.pinimg.com/736x/6e/7a/d2/6e7ad228bb4ca7a98e7616362f2cf659.jpg";
%>

<div class="page-wrapper">

<% if(user != null && user.getRole().equals("Seller")) { %>
    <!-- Sidebar -->
    <div class="sidebar" id="mySidebar">
        <div class="logo">
            <img src="<%=logoURL%>" alt="Logo" />
            <h5>Import & Export Pvt. Ltd.</h5>
        </div>
        <a href="javascript:void(0)" onclick="toggleSidebar()">✖ Close</a>
        <a href="ProductController?action=view">My Products</a>
        <a href="OrderController">Orders</a>
        <a href="ReportedProductsController">Reports</a>
        <a href="seller_sales.jsp">Sales</a>
    </div>

    <!-- Navbar -->
    <nav class="navbar navbar-expand-lg navbar-dark">
        <div class="container-fluid">
            <span class="navbar-brand me-3" onclick="toggleSidebar()" style="cursor:pointer;">☰</span>
            <a class="navbar-brand" href="#">
                <img src="<%=logoURL%>" alt="Logo" />
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
    <div class="main-content container mt-4">
        <div class="mb-4 text-end">
            <a href="add_product.jsp" class="btn btn-success animated-card">➕ Add New Product</a>
        </div>

        <h2>Products for Seller ID: <%=request.getAttribute("sellerId")%></h2>

        <%
            String success = (String) request.getAttribute("success");
            String error = (String) request.getAttribute("error");
            if (success != null) {
        %>
            <div class="alert alert-success animated-card"><%=success%></div>
        <%
            } else if (error != null) {
        %>
            <div class="alert alert-danger animated-card"><%=error%></div>
        <%
            }
        %>

        <div class="row">
            <%
                List<Product> products = (List<Product>) request.getAttribute("productList");

                if (products == null || products.isEmpty()) {
            %>
                <div class="col-12">
                    <p>No products found!</p>
                </div>
            <%
                } else if (products.size() == 1 && products.get(0).getProduct_id() == 0 && products.get(0).getQuantity() == 0
                        && products.get(0).getPrice() == 0.0) {
            %>
                <div class="col-12">
                    <p><%=products.get(0).getProduct_name()%></p>
                </div>
            <%
                } else {
                    for (Product p : products) {
            %>
                <div class="col-md-4 mb-4">
                    <div class="card shadow-sm animated-card">
                        <div class="card-body">
                            <h5 class="card-title"><%=p.getProduct_name()%></h5>
                            <p class="card-text"><strong>Product ID:</strong> <%=p.getProduct_id()%></p>
                            <p class="card-text"><strong>Quantity:</strong> <%=p.getQuantity()%></p>
                            <p class="card-text"><strong>Price:</strong> ₹<%=p.getPrice()%></p>

                            <a href="update_product.jsp?product_id=<%=p.getProduct_id()%>&name=<%=p.getProduct_name()%>&price=<%=p.getPrice() %>&quantity=<%=p.getQuantity()%>"
                               class="btn btn-primary btn-sm me-2">Update</a>

                            <form action="ProductController" method="post" class="d-inline">
                                <input type="hidden" name="action" value="delete" />
                                <input type="hidden" name="product_id" value="<%=p.getProduct_id()%>" />
                                <button type="submit" class="btn btn-danger"
                                        onclick="return confirm('Are you sure you want to delete this product?');"
                                        title="Delete Product">
                                    <i class="bi bi-trash"></i>
                                </button>
                            </form>
                        </div>
                    </div>
                </div>
            <%
                    }
                }
            %>
        </div>
    </div>

<% } else { %>
    <!-- Sidebar -->
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

    <!-- Navbar -->
    <nav class="navbar navbar-expand-lg navbar-dark">
        <div class="container-fluid">
            <span class="navbar-brand me-3" onclick="toggleSidebar()" style="cursor:pointer;">☰</span>
            <a class="navbar-brand" href="#">
                <img src="<%=logoURL%>" alt="Logo" />
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
    <div class="main-content container mt-4">
        <div class="mb-4 text-end">
            <a href="cart.jsp" class="btn btn-success animated-card">🛒 Cart</a>
        </div>

        <h2>All Products:</h2>

        <%
            String success = (String) request.getAttribute("success");
            String error = (String) request.getAttribute("error");
            if (success != null) {
        %>
            <div class="alert alert-success animated-card"><%=success%></div>
        <%
            } else if (error != null) {
        %>
            <div class="alert alert-danger animated-card"><%=error%></div>
        <%
            }
        %>

        <div class="row">
            <%
                List<Product> products = (List<Product>) request.getAttribute("productList");

                if (products == null || products.isEmpty()) {
            %>
                <div class="col-12">
                    <p>No products found!</p>
                </div>
            <%
                } else if (products.size() == 1 && products.get(0).getProduct_id() == 0 && products.get(0).getQuantity() == 0
                        && products.get(0).getPrice() == 0.0) {
            %>
                <div class="col-12">
                    <p><%=products.get(0).getProduct_name()%></p>
                </div>
            <%
                } else {
                    for (Product p : products) {
            %>
                <div class="col-md-4 mb-4">
                    <div class="card shadow-sm animated-card">
                        <div class="card-body">
                            <h5 class="card-title"><%=p.getProduct_name()%></h5>
                            <p class="card-text"><strong>Product ID:</strong> <%=p.getProduct_id()%></p>
                            <p class="card-text"><strong>Quantity:</strong> <%=p.getQuantity()%></p>
                            <p class="card-text"><strong>Price:</strong> ₹<%=p.getPrice()%></p>

                            <form action="CartController" method="post" class="mt-2">
                                <input type="hidden" name="seller_port_id" value="<%= p.getSeller_port_id() %>">
                                <input type="hidden" name="product_id" value="<%=p.getProduct_id()%>">
                                <input type="hidden" name="product_name" value="<%=p.getProduct_name()%>">
                                <input type="hidden" name="price" value="<%=p.getPrice()%>">
                                <input type="number" name="quantity" value="1" min="1" class="form-control mb-2" required>
                                <button type="submit" class="btn btn-warning w-100">Add to Cart 🛒</button>
                            </form>
                        </div>
                    </div>
                </div>
            <%
                    }
                }
            %>
        </div>
    </div>
<% } %>

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

</div> <!-- End page-wrapper -->

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>

<script>
    function toggleSidebar() {
        document.body.classList.toggle("sidebar-open");
    }
</script>

</body>
</html>
