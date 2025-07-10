package controllers;

import jakarta.servlet.RequestDispatcher;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import models.Product;
import models.SellerPort;
import models.User;

import java.io.IOException;
import java.io.PrintWriter;
import java.util.List;

import implementors.ProductImplementor;

/**
 * Servlet implementation class ProductController
 */
@WebServlet("/ProductController")
public class ProductController extends HttpServlet {
	protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
    	

        response.setContentType("text/html");
        PrintWriter out = response.getWriter();

        String action = request.getParameter("action");
        System.out.println("Action: " + action);  

        if ("add".equals(action)) {
            Product p = new Product();
            p.setSeller_port_id(request.getParameter("seller_port_id"));
            p.setProduct_name(request.getParameter("product_name"));
            p.setQuantity(Integer.parseInt(request.getParameter("quantity")));
            p.setPrice(Double.parseDouble(request.getParameter("price")));

            ProductImplementor impl = new ProductImplementor();
            String result = impl.addProduct(p);
            request.getRequestDispatcher("ProductController?action=view").forward(request, response);

            

        } else if ("update".equals(action)) {
            try {
                Product p = new Product();
                p.setProduct_id(Integer.parseInt(request.getParameter("product_id")));
                p.setProduct_name(request.getParameter("product_name"));
                p.setQuantity(Integer.parseInt(request.getParameter("quantity")));
                p.setPrice(Double.parseDouble(request.getParameter("price")));

                ProductImplementor impl = new ProductImplementor();
                String result = impl.updateProduct(p);

                if (result.toLowerCase().contains("success")) {
                    // Refresh product list for the seller
                    HttpSession session = request.getSession(false);
                    if (session != null && session.getAttribute("user") != null) {
                        User user = (User) session.getAttribute("user");
                        List<Product> list = impl.viewSellerProducts(user.getPortId());

                        request.setAttribute("productList", list);
                        request.setAttribute("sellerId", user.getPortId());
                        request.setAttribute("success", "Product updated successfully.");
                        request.getRequestDispatcher("ProductController?action=view").forward(request, response);
                    } else {
                        request.setAttribute("error", "Session expired. Please login again.");
                        request.getRequestDispatcher("test_login.jsp").forward(request, response);
                    }
                } else {
                    request.setAttribute("error", result); // Show update failure reason
                    request.getRequestDispatcher("update_product.jsp").forward(request, response);
                }
            } catch (Exception e) {
                request.setAttribute("error", "Error updating product: " + e.getMessage());
                request.getRequestDispatcher("update_product.jsp").forward(request, response);
            }
        }
 else if ("delete".equals(action)) {
            int productId = Integer.parseInt(request.getParameter("product_id"));

            Product p = new Product();
            p.setProduct_id(productId);

            ProductImplementor impl = new ProductImplementor();
            String result = impl.deleteProduct(p);

            request.getRequestDispatcher("ProductController?action=view").forward(request, response);

        } else if ("view".equals(action)) {
        	HttpSession session = request.getSession(false);
        	if (session == null || session.getAttribute("user") == null) {
        	    request.setAttribute("error", "Please login first.");
        	    request.getRequestDispatcher("test_login.jsp").forward(request, response);
        	    return;
        	}
        	 User user = (User) session.getAttribute("user");
            if(user.getRole().equals("Seller")) {
            	ProductImplementor impl = new ProductImplementor();
                List<Product> list = impl.viewSellerProducts((String) user.getPortId());
                request.setAttribute("productList", list);
                request.setAttribute("sellerId", user.getPortId());
                request.getRequestDispatcher("view_seller_products.jsp").forward(request, response);

            }else {
            	ProductImplementor impl = new ProductImplementor();
                List<Product> list = impl.viewAllProducts();
                request.setAttribute("productList", list);
                request.setAttribute("conumerId", user.getPortId());
                request.getRequestDispatcher("view_seller_products.jsp").forward(request, response);

            }
            }
	}
    

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doPost(request, response);
    }

}
