<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Thank You</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet" />
    <style>
        body {
            background-color: #f8f9fa;
            height: 100vh;
            display: flex;
            justify-content: center;
            align-items: center;
            text-align: center;
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
        }

        .thank-container {
            background: white;
            padding: 40px 60px;
            border-radius: 12px;
            box-shadow: 0 8px 30px rgba(0, 0, 0, 0.1);
            animation: fadeInScale 0.8s ease-in-out;
        }

        h2 {
            color: #28a745;
            font-weight: 700;
            margin-bottom: 15px;
        }

        p {
            color: #6c757d;
            font-size: 1.1rem;
        }

        @keyframes fadeInScale {
            0% {
                opacity: 0;
                transform: scale(0.95);
            }
            100% {
                opacity: 1;
                transform: scale(1);
            }
        }
    </style>

    <!-- Auto Redirect Script -->
    <script>
        setTimeout(function () {
            window.location.href = 'ProductController?action=view';
        }, 3000);
    </script>
</head>
<body>

<div class="thank-container">
    <h2><%= request.getAttribute("thankyou") != null ? request.getAttribute("thankyou") : "Thank you!" %></h2>
    <p>You will be redirected to the product page shortly...</p>
</div>

</body>
</html>
