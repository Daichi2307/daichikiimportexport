package controllers;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import models.Product;

import java.io.IOException;
import java.util.ArrayList;
import java.util.List;

/**
 * Servlet implementation class CartController
 */
@WebServlet("/CartController")
public class CartController extends HttpServlet {

    // Add to cart logic
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        try {
            int productId = Integer.parseInt(request.getParameter("product_id"));
            String productName = request.getParameter("product_name");
            double price = Double.parseDouble(request.getParameter("price"));
            int quantity = Integer.parseInt(request.getParameter("quantity"));
            String sellerId = request.getParameter("seller_port_id");

            HttpSession session = request.getSession();
            List<Product> cart = (List<Product>) session.getAttribute("cart");

            if (cart == null) {
                cart = new ArrayList<>();
            }

            boolean found = false;
            for (Product item : cart) {
                if (item.getProduct_id() == productId) {
                    item.setQuantity(item.getQuantity() + quantity);
                    found = true;
                    break;
                }
            }

            if (!found) {
                Product p = new Product();
                p.setProduct_id(productId);
                p.setProduct_name(productName);
                p.setPrice(price);
                p.setQuantity(quantity);
                p.setSeller_port_id(sellerId);
                cart.add(p);
            }

            session.setAttribute("cart", cart);
            response.sendRedirect("ProductController?action=view");

        } catch (Exception e) {
            e.printStackTrace();
            
        }
    }

    // Cancel order logic (clear cart)
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        String action = request.getParameter("action");

        if ("cancel".equalsIgnoreCase(action)) {
            HttpSession session = request.getSession(false);
            if (session != null) {
                session.removeAttribute("cart");
            }
            response.sendRedirect("ProductController?action=view");
        } else {
            response.sendRedirect("ProductController?action=view"); 
        }
    }

}
