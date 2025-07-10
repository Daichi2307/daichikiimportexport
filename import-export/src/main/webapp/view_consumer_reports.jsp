<%@ page import="db_config.DbConnection, java.sql.*, java.util.*, models.User" %>
<%@ page session="true" %>
<!DOCTYPE html>
<html>
<head>
    <title>My Product Reports</title>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css">
    <style>
        body {
    background: linear-gradient(135deg, #e3f2fd, #f1f8ff);
    padding: 30px;
    font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
}

/* Main Card Container */
.container {
    max-width: 960px;
    background: #ffffff;
    padding: 35px 45px;
    border-radius: 18px;
    box-shadow: 0 12px 35px rgba(0, 0, 0, 0.1);
    animation: fadeInSlide 0.8s ease-in-out forwards;
}

/* Header */
h2 {
    font-weight: 800;
    color: #1f1f1f;
    margin-bottom: 35px;
    text-align: center;
    text-transform: uppercase;
    letter-spacing: 1px;
    text-shadow: 1px 2px 2px rgba(0,0,0,0.05);
}

/* Back Button */
.btn-back {
    margin-bottom: 25px;
    font-weight: 600;
    border-radius: 25px;
    padding: 10px 20px;
    background: linear-gradient(to right, #007bff, #0056b3);
    color: white;
    border: none;
    transition: transform 0.3s ease, box-shadow 0.3s ease;
}

.btn-back:hover {
    transform: scale(1.05);
    box-shadow: 0 6px 15px rgba(0, 91, 187, 0.4);
}

/* Table Enhancements */
table {
    width: 100%;
    border-collapse: separate !important;
    border-spacing: 0;
    border-radius: 12px;
    overflow: hidden;
    background: #ffffff;
    box-shadow: 0 10px 25px rgba(0,0,0,0.05);
}

thead.table-dark {
    background: linear-gradient(45deg, #007bff, #0056b3);
    color: white;
    font-size: 1rem;
    text-transform: uppercase;
    letter-spacing: 0.5px;
}

th, td {
    padding: 14px 16px;
    vertical-align: middle !important;
    text-align: center;
}

/* Table Row Hover */
tbody tr {
    transition: all 0.3s ease;
}

tbody tr:hover {
    background-color: #eaf6ff;
    transform: scale(1.01);
    box-shadow: 0 4px 10px rgba(0, 123, 255, 0.1);
}

/* Badge Styling */
.badge {
    font-size: 0.9rem;
    padding: 7px 14px;
    border-radius: 20px;
    font-weight: 600;
    text-transform: capitalize;
    letter-spacing: 0.5px;
    box-shadow: 0 3px 6px rgba(0,0,0,0.1);
}

.bg-success {
    background-color: #28a745 !important;
    color: #fff;
}

.bg-warning {
    background-color: #ffc107 !important;
    color: #212529 !important;
}

.bg-info {
    background-color: #17a2b8 !important;
    color: #fff !important;
}

.bg-secondary {
    background-color: #6c757d !important;
    color: #fff;
}

/* Muted Text */
.text-muted {
    font-style: italic;
    font-size: 0.9rem;
    color: #888 !important;
}

/* Empty State */
.alert-info {
    font-size: 1.1rem;
    font-weight: 500;
    padding: 20px;
    border-radius: 12px;
    box-shadow: 0 4px 15px rgba(0,0,0,0.05);
    background: #d9ecff;
    color: #004085;
}

/* Fade In Animation */
@keyframes fadeInSlide {
    0% {
        opacity: 0;
        transform: translateY(40px);
    }
    100% {
        opacity: 1;
        transform: translateY(0);
    }
}

/* Responsive Table (Optional Mobile Support) */
@media (max-width: 768px) {
    table thead {
        display: none;
    }

    table tbody tr {
        display: block;
        margin-bottom: 15px;
        border-radius: 12px;
        border: 1px solid #dee2e6;
        box-shadow: 0 2px 10px rgba(0,0,0,0.05);
        overflow: hidden;
    }

    table tbody td {
        display: flex;
        justify-content: space-between;
        padding: 10px 15px;
        text-align: left;
        border-bottom: 1px solid #dee2e6;
    }

    table tbody td:last-child {
        border-bottom: none;
    }

    table tbody td::before {
        content: attr(data-label);
        font-weight: bold;
        color: #333;
    }
}

    </style>
</head>
<body>

<%
    User user = (User) session.getAttribute("user");
    if (user == null) {
        response.sendRedirect("test_login.jsp");
        return;
    }

    List<Map<String, Object>> reports = new ArrayList<>();

    try (Connection conn = DbConnection.getConnection();
         PreparedStatement ps = conn.prepareStatement(
            "SELECT rp.*, p.product_name FROM reported_products rp JOIN products p ON rp.product_id = p.product_id WHERE rp.consumer_port_id = ?"
         )) {
        ps.setString(1, user.getPortId());
        ResultSet rs = ps.executeQuery();

        while (rs.next()) {
            Map<String, Object> r = new HashMap<>();
            r.put("report_id", rs.getInt("report_id"));
            r.put("product_name", rs.getString("product_name"));
            r.put("issue_type", rs.getString("issue_type"));
            r.put("status", rs.getString("status"));
            r.put("action_taken", rs.getString("action_taken"));
            r.put("report_date", rs.getDate("report_date"));
            reports.add(r);
        }

        rs.close();
    } catch (Exception e) {
%>
        <div class='alert alert-danger container mt-5'>Failed to fetch reports: <%= e.getMessage() %></div>
<%
    }
%>

<div class="container">
    <button class="btn btn-outline-primary btn-back" onclick="location.href='ProductController?action=view'">
        &larr; Back to Products
    </button>

    <h2>My Reported Products</h2>

    <% if (reports.isEmpty()) { %>
        <div class="alert alert-info text-center">You haven't reported any products yet.</div>
    <% } else { %>
        <table class="table table-bordered text-center">
            <thead class="table-dark">
                <tr>
                    <th>Report ID</th>
                    <th>Product</th>
                    <th>Issue</th>
                    <th>Date</th>
                    <th>Status</th>
                    <th>Action Taken</th>
                </tr>
            </thead>
            <tbody>
            <% for (Map<String, Object> r : reports) {
                   String status = (String) r.get("status");
                   String actionTaken = (r.get("action_taken") != null) ? r.get("action_taken").toString().trim() : "";
                   String badgeClass = "bg-secondary";
                   if ("Resolved".equalsIgnoreCase(status)) badgeClass = "bg-success";
                   else if ("In Progress".equalsIgnoreCase(status)) badgeClass = "bg-warning text-dark";
                   else if ("Pending".equalsIgnoreCase(status)) badgeClass = "bg-info text-dark";
            %>
                <tr>
                    <td><%= r.get("report_id") %></td>
                    <td class="fw-semibold text-primary"><%= r.get("product_name") %></td>
                    <td><%= r.get("issue_type") %></td>
                    <td><%= r.get("report_date") %></td>
                    <td><span class="badge <%= badgeClass %>"><%= status %></span></td>
                    <td>
                        <% if ("Resolved".equalsIgnoreCase(status) && actionTaken != null && !actionTaken.isEmpty() && !"null".equalsIgnoreCase(actionTaken)) { %>
                            <%= actionTaken %>
                        <% } else { %>
                            <span class="text-muted">Not Yet Taken</span>
                        <% } %>
                    </td>
                </tr>
            <% } %>
            </tbody>
        </table>
    <% } %>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>

</body>
</html>
