<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.*" %>

<html>
<head>
    <title>Seller Sales Analytics</title>
    <meta charset="UTF-8"/>
    <meta name="viewport" content="width=device-width, initial-scale=1"/>

    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet"/>
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" rel="stylesheet"/>
    <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>

    <style>
        body {
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            background: linear-gradient(to right, #f3f4f6, #e0e0e0);
            margin: 0;
            padding: 40px 20px;
        }
        .container-box {
            max-width: 1100px;
            margin: 0 auto;
            background: #fff;
            padding: 25px 35px;
            border-radius: 12px;
            box-shadow: 0 10px 30px rgb(0 0 0 / 0.1);
            position: relative;
        }
        .back-btn {
            position: absolute;
            top: 20px;
            right: 25px;
        }
        h2 {
            margin-bottom: 25px;
            color: #212529;
            font-weight: 700;
        }
        .chart-container {
            display: flex;
            flex-wrap: wrap;
            gap: 40px;
            justify-content: center;
        }
        .chart-box {
            flex: 1 1 300px;
            max-width: 350px;
            background: #f8f9fa;
            border-radius: 12px;
            padding: 20px;
            box-shadow: 0 6px 20px rgb(0 0 0 / 0.05);
        }
        .no-data {
            color: #6c757d;
            font-style: italic;
            text-align: center;
            padding: 60px 0;
        }
    </style>
</head>
<body>

<div class="container-box">
    <a href="ProductController?action=view" class="btn btn-outline-primary back-btn">
        <i class="fa fa-arrow-left"></i> Back to Products
    </a>

    <h2>Seller Sales Analytics Dashboard</h2>

    <div class="chart-container">
        <!-- Pie Chart: Sales by Product -->
        <div class="chart-box">
            <h4>Sales Distribution by Product</h4>
            <%
                List<Map<String, Object>> salesByProduct = (List<Map<String, Object>>) request.getAttribute("salesByProduct");
                if (salesByProduct == null) salesByProduct = new ArrayList<>();
                boolean hasSalesData = !salesByProduct.isEmpty();
            %>
            <%
                if (!hasSalesData) {
            %>
                <div class="no-data">No sales data available.</div>
            <%
                } else {
            %>
                <canvas id="pieChart"></canvas>
            <%
                }
            %>
        </div>

        <!-- Line Chart: Monthly Revenue -->
        <div class="chart-box">
            <h4>Monthly Revenue (₹)</h4>
            <%
                Map<String, Double> revenueByMonth = (Map<String, Double>) request.getAttribute("revenueByMonth");
                if (revenueByMonth == null) revenueByMonth = new LinkedHashMap<>();
                boolean hasRevenueData = !revenueByMonth.isEmpty() && revenueByMonth.values().stream().anyMatch(r -> r > 0);
            %>
            <%
                if (!hasRevenueData) {
            %>
                <div class="no-data">No revenue data available.</div>
            <%
                } else {
            %>
                <canvas id="lineChart"></canvas>
            <%
                }
            %>
        </div>

        <!-- Pie Chart: Reported Product Issues -->
        <div class="chart-box">
            <h4>Reported Product Issues</h4>
            <%
                Map<String, Integer> reportedIssuesCount = (Map<String, Integer>) request.getAttribute("reportedIssuesCount");
                if (reportedIssuesCount == null) reportedIssuesCount = new LinkedHashMap<>();
                boolean hasIssueData = !reportedIssuesCount.isEmpty() && reportedIssuesCount.values().stream().anyMatch(c -> c > 0);
            %>
            <%
                if (!hasIssueData) {
            %>
                <div class="no-data">No reported issues.</div>
            <%
                } else {
            %>
                <canvas id="issuesChart"></canvas>
            <%
                }
            %>
        </div>
    </div>
</div>

<script>
    <% if (hasSalesData) { %>
    const pieLabels = [
        <% for (int i = 0; i < salesByProduct.size(); i++) {
            Map<String, Object> item = salesByProduct.get(i);
            String productName = (String) item.get("productName");
        %>
        "<%= productName.replace("\"", "\\\"") %>"<%= (i < salesByProduct.size() - 1) ? "," : "" %>
        <% } %>
    ];
    const pieData = [
        <% for (int i = 0; i < salesByProduct.size(); i++) {
            Map<String, Object> item = salesByProduct.get(i);
            Number salesCount = (Number) item.get("salesCount");
        %>
        <%= salesCount %><%= (i < salesByProduct.size() - 1) ? "," : "" %>
        <% } %>
    ];
    const pieColors = [
        '#007bff', '#28a745', '#ffc107', '#dc3545', '#6f42c1', '#fd7e14', '#20c997', '#6610f2'
    ];
    const pieCtx = document.getElementById('pieChart').getContext('2d');
    new Chart(pieCtx, {
        type: 'pie',
        data: {
            labels: pieLabels,
            datasets: [{
                label: 'Sales Count',
                data: pieData,
                backgroundColor: pieColors,
                borderColor: '#fff',
                borderWidth: 2
            }]
        },
        options: {
            responsive: true,
            plugins: {
                legend: { position: 'bottom' },
                tooltip: {
                    callbacks: {
                        label: ctx => `${ctx.label}: ${ctx.parsed}`
                    }
                }
            }
        }
    });
    <% } %>

    <% if (hasRevenueData) { %>
    const lineLabels = [
        <%
        int count = 0, size = revenueByMonth.size();
        for (Map.Entry<String, Double> entry : revenueByMonth.entrySet()) {
            String month = entry.getKey();
        %>
        "<%= month %>"<%= (count < size - 1) ? "," : "" %>
        <% count++; } %>
    ];
    const lineData = [
        <%
        count = 0;
        for (Map.Entry<String, Double> entry : revenueByMonth.entrySet()) {
            Double revenue = entry.getValue();
        %>
        <%= revenue %><%= (count < size - 1) ? "," : "" %>
        <% count++; } %>
    ];
    const lineCtx = document.getElementById('lineChart').getContext('2d');
    new Chart(lineCtx, {
        type: 'line',
        data: {
            labels: lineLabels,
            datasets: [{
                label: 'Revenue (₹)',
                data: lineData,
                fill: true,
                backgroundColor: 'rgba(0, 123, 255, 0.2)',
                borderColor: '#007bff',
                borderWidth: 3,
                tension: 0.3,
                pointRadius: 5,
                pointBackgroundColor: '#007bff'
            }]
        },
        options: {
            responsive: true,
            scales: {
                y: {
                    beginAtZero: true,
                    ticks: {
                        callback: value => '₹' + value
                    }
                }
            },
            plugins: {
                legend: { position: 'top' },
                tooltip: {
                    callbacks: {
                        label: ctx => '₹' + ctx.parsed.y.toFixed(2)
                    }
                }
            }
        }
    });
    <% } %>

    <% if (hasIssueData) { %>
    const issuesLabels = [
        <% int i = 0, n = reportedIssuesCount.size();
           for (Map.Entry<String, Integer> entry : reportedIssuesCount.entrySet()) {
               String issue = entry.getKey();
        %>
        "<%= issue %>"<%= (i < n - 1) ? "," : "" %>
        <% i++; } %>
    ];
    const issuesData = [
        <% i = 0;
           for (Map.Entry<String, Integer> entry : reportedIssuesCount.entrySet()) {
               int countIssue = entry.getValue();
        %>
        <%= countIssue %><%= (i < n - 1) ? "," : "" %>
        <% i++; } %>
    ];
    const issuesColors = [
        '#dc3545', '#fd7e14', '#ffc107', '#6c757d', '#17a2b8'
    ];
    const issuesCtx = document.getElementById('issuesChart').getContext('2d');
    new Chart(issuesCtx, {
        type: 'pie',
        data: {
            labels: issuesLabels,
            datasets: [{
                label: 'Reported Issues',
                data: issuesData,
                backgroundColor: issuesColors,
                borderColor: '#fff',
                borderWidth: 2
            }]
        },
        options: {
            responsive: true,
            plugins: {
                legend: { position: 'bottom' },
                tooltip: {
                    callbacks: {
                        label: ctx => `${ctx.label}: ${ctx.parsed}`
                    }
                }
            }
        }
    });
    <% } %>
</script>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
