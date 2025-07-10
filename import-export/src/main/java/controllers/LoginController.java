package controllers;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import models.User;
import operations.RegisterOperations;

import java.io.IOException;

@WebServlet("/Login")
public class LoginController extends HttpServlet {
    private final RegisterOperations crud = new RegisterOperations();

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        try {
            
            String action = request.getParameter("action");

            if ("update".equals(action)) {
                String portId = request.getParameter("port_id");
                String password = request.getParameter("password");
                String location = request.getParameter("location");
                String role = request.getParameter("role");

                User user = new User();
                user.setPortId(portId);
                user.setPassword(password);
                user.setLocation(location);
                user.setRole(role);
                
                RegisterOperations operations = new RegisterOperations();
                operations.update(user);  // Implement updateUser() in User.java
                HttpSession httpSession = request.getSession(false);
                httpSession.setAttribute("user", user);
                response.sendRedirect("test_session_info.jsp");

                
            }
            else if ("login".equals(action)) {
            	handleLogin(request, response);
            }
            else if ("delete".equals(action)) {
                String portId = request.getParameter("port_id");
                String role = request.getParameter("role");

                User user = new User();
                user.setPortId(portId);  
                user.setRole(role);
                RegisterOperations operations = new RegisterOperations();
                operations.delete(user.getPortId(), user.getRole());  // Implement updateUser() in User.java
                HttpSession ses = request.getSession(false);
                if (ses != null) ses.invalidate();
                response.sendRedirect("/import-export/test_register.jsp");

                
            }
        } catch (Exception e) {
            e.printStackTrace();
            forward(request, response, "error", "Login failed: " + e.getMessage(), "test_session_info.jsp");
        }
    }

    private void handleLogin(HttpServletRequest request, HttpServletResponse response) throws Exception {
        String id = request.getParameter("port_id");
        String pw = request.getParameter("password");
        String role = request.getParameter("role");

        if (id == null || id.isBlank() || pw == null || pw.isBlank() || role == null || role.isBlank()) {
            forward(request, response, "error", "All fields are required.", "test_login.jsp");
            return;
        }

        User user = crud.find(id, role);

        if (user == null) {
            forward(request, response, "error", "User not found. Please register.", "test_register.jsp");
        } else if (!user.getPassword().equals(pw)) {
            forward(request, response, "error", "Incorrect password. Please try again.", "test_login.jsp");
        } else {
            // Successful login
            request.getSession(true).setAttribute("user", user);
            System.out.println(user.getPortId() + role);
            response.sendRedirect("ProductController?action=view");        }
    }


    private static void forward(HttpServletRequest r, HttpServletResponse s,
                                String attr, String msg, String page)
            throws ServletException, IOException {
        r.setAttribute(attr, msg);
        r.getRequestDispatcher(page).forward(r, s);
    }
}
