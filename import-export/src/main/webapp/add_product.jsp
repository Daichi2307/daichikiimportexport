<%@ page contentType="text/html;charset=UTF-8" language="java"%>
<%@ page import="models.User"%>
<%@ page session="true"%>
<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8" />
<title>Add Product</title>
<meta name="viewport" content="width=device-width, initial-scale=1" />

<!-- Bootstrap CSS -->
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet" />

<style>
  /* Body and container */
  body {
    background: linear-gradient(135deg, #f5f7fa 0%, #c3cfe2 100%);
    font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
    min-height: 100vh;
    display: flex;
    align-items: center;
    justify-content: center;
    padding: 40px 15px;
    margin: 0;
    user-select: none;
  }

  .container {
    max-width: 480px;
    width: 100%;
  }

  /* Card style */
  .card {
    background: #ffffffcc;
    backdrop-filter: blur(10px);
    border-radius: 16px;
    padding: 2.5rem 2rem;
    box-shadow:
      0 8px 30px rgba(0, 0, 0, 0.12),
      0 6px 15px rgba(0, 0, 0, 0.08);
    transition: box-shadow 0.3s ease;
  }
  .card:hover {
    box-shadow:
      0 12px 40px rgba(0, 0, 0, 0.18),
      0 10px 25px rgba(0, 0, 0, 0.12);
  }

  /* Heading */
  h4 {
    font-weight: 700;
    color: #222;
    margin-bottom: 2rem;
    text-align: center;
    letter-spacing: 0.03em;
  }

  /* Form labels */
  label.form-label {
    font-weight: 600;
    color: #444;
    transition: color 0.3s ease;
  }

  /* Form inputs */
  input.form-control {
    border-radius: 10px;
    border: 2px solid #ddd;
    padding: 0.625rem 1rem;
    font-size: 1rem;
    transition: border-color 0.3s ease, box-shadow 0.3s ease;
    box-shadow: inset 0 1px 4px rgb(0 0 0 / 0.06);
  }
  input.form-control:focus {
    border-color: #fbbf24;
    box-shadow: 0 0 8px #fbbf24;
    outline: none;
  }

  /* Buttons container */
  .d-flex.justify-content-between {
    margin-top: 1.8rem;
  }

  /* Buttons styling */
  .btn-primary, .btn-secondary {
    border-radius: 10px;
    font-weight: 600;
    padding: 0.65rem 2rem;
    font-size: 1.05rem;
    transition: all 0.25s ease;
    box-shadow: 0 6px 18px rgb(251 191 36 / 0.3);
    user-select: none;
  }

  /* Primary button */
  .btn-primary {
    background: linear-gradient(45deg, #fbbf24, #f59e0b);
    border: none;
    color: #212529;
    box-shadow: 0 6px 20px rgb(251 191 36 / 0.5);
  }
  .btn-primary:hover, .btn-primary:focus {
    background: linear-gradient(45deg, #f59e0b, #d97706);
    box-shadow: 0 10px 25px rgb(251 191 36 / 0.8);
    transform: translateY(-3px) scale(1.03);
    color: #212529;
  }
  .btn-primary:active {
    transform: translateY(-1px) scale(1.02);
  }

  /* Secondary button */
  .btn-secondary {
    background-color: #6c757d;
    border: none;
    color: #fff;
    box-shadow: 0 6px 15px rgb(108 117 125 / 0.4);
  }
  .btn-secondary:hover, .btn-secondary:focus {
    background-color: #5a6268;
    box-shadow: 0 10px 25px rgb(90 98 104 / 0.7);
    transform: translateY(-3px) scale(1.03);
    color: #fff;
  }
  .btn-secondary:active {
    transform: translateY(-1px) scale(1.02);
  }

  /* Responsive */
  @media (max-width: 575.98px) {
    .card {
      padding: 2rem 1.5rem;
    }
    .btn-primary, .btn-secondary {
      width: 100%;
      margin-top: 10px;
    }
    .d-flex.justify-content-between {
      flex-direction: column;
      gap: 10px;
      margin-top: 1.5rem;
    }
  }
</style>
</head>
<body>

<%
User user = (User) session.getAttribute("user");
if (user == null) {
%>
<div class="container mt-5">
  <div class="alert alert-danger text-center">
    You must be logged in to add a product. <a href="login.jsp" class="alert-link">Login here</a>.
  </div>
</div>
<%
} else {
%>

<div class="container">
  <div class="card">
    <h4>Add New Product</h4>
    <form action="ProductController" method="POST">
      <input type="hidden" name="action" value="add" />
      <input type="hidden" name="seller_port_id" value="<%=user.getPortId()%>" />

      <div class="mb-3">
        <label for="product_name" class="form-label">Product Name</label>
        <input
          type="text"
          class="form-control"
          id="product_name"
          name="product_name"
          maxlength="50"
          required
          autocomplete="off"
          />
      </div>

      <div class="mb-3">
        <label for="quantity" class="form-label">Quantity</label>
        <input
          type="number"
          class="form-control"
          id="quantity"
          name="quantity"
          required
          min="1"
          />
      </div>

      <div class="mb-3">
        <label for="price" class="form-label">Price (₹)</label>
        <input
          type="number"
          class="form-control"
          id="price"
          name="price"
          step="0.01"
          required
          min="0"
          />
      </div>

      <div class="d-flex justify-content-between">
        <a href="ProductController?action=view" class="btn btn-secondary">Cancel</a>
        <button type="submit" class="btn btn-primary">Add Product</button>
      </div>
    </form>
  </div>
</div>

<%
}
%>

<!-- Bootstrap JS -->
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>

</body>
</html>
