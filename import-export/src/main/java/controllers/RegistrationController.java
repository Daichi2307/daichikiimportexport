package controllers;

import jakarta.servlet.RequestDispatcher;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import models.User;
import operations.RegisterOperations;

import java.io.IOException;

/**
 * Servlet implementation class Registeration
 */
@WebServlet("/Registration")
public class RegistrationController extends HttpServlet {
	private final RegisterOperations crud = new RegisterOperations();

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
    	try {
			handleRegister(req, resp);
		} catch (Exception e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
    	
//        String path = req.getServletPath();
//
//        // Update/Delete require login
//        if (("/update".equals(path) || "/delete".equals(path))
//                && req.getSession(false) == null) {
//            forward(req, resp, "error",
//                    "Please log in first.", "login.jsp");
//            return;
//        }
//
//        try {
//            switch (path) {
//                case "/register": handleRegister(req, resp); break;
//                case "/login":    handleLogin(req, resp);    break;
//                case "/update":   handleUpdate(req, resp);   break;
//                case "/delete":   handleDelete(req, resp);   break;
//                case "/logout":   handleLogout(req, resp);   break;
//                default: resp.sendError(HttpServletResponse.SC_NOT_FOUND);
//            }
//        } catch (IllegalArgumentException ex) {
//            // Decide page by action
//            String page = path.contains("register") ? "register.jsp"
//                        : path.contains("update")   ? "update.jsp"
//                        : path.contains("delete")   ? "delete.jsp"
//                        : "login.jsp";
//            forward(req, resp, "error", ex.getMessage(), page);
//        } catch (Exception ex) {
//            throw new ServletException(ex);
//        }
    }

    /* ---------- register ---------- */
    private void handleRegister(HttpServletRequest r, HttpServletResponse s) throws Exception {
        String id = r.getParameter("port_id");
        String pw  = r.getParameter("password");
        String cpw = r.getParameter("confirm_password");
        String location = r.getParameter("location");
        String role= r.getParameter("role");
        
        System.out.println(id+pw+cpw+role);
        validatePasswords(pw, cpw);
        validateRole(role);

        try {
            if (crud.insert(new User(id, pw, cpw, location, role))) {
                forward(r, s, "success", "Registered successfully. Please log in.", "test_login.jsp");
            } else {
                forward(r, s, "error", "Unknown error occurred.", "test_register.jsp");
            }
        } catch (Exception e) {
            forward(r, s, "error", e.getMessage(), "test_register.jsp");
        }

//        RequestDispatcher rd = r.getRequestDispatcher("test_login.jsp");
//        rd.forward(r, s);
    }

    /* ---------- login ---------- */
    private void handleLogin(HttpServletRequest r, HttpServletResponse s) throws Exception {
        String id = r.getParameter("port_id");
        String pw  = r.getParameter("password");
        String role= r.getParameter("role");

        validateRole(role);
        if (pw == null || pw.isBlank())
            throw new IllegalArgumentException("Password is required.");

        User u = crud.find(id, role);
        if (u == null || !u.getPassword().equals(pw)) {
            forward(r, s, "error", "Invalid credentials.", "login.jsp");
            return;
        }

        r.getSession(true).setAttribute("user", u);
        forward(r, s, "success",
                "Login successful. Welcome " + u.getPortId(), "login.jsp");
    }

    /* ---------- update ---------- */
    private void handleUpdate(HttpServletRequest r, HttpServletResponse s) throws Exception {
        String id = r.getParameter("port_id");
        String pw  = r.getParameter("new_password");
        String cpw = r.getParameter("confirm_password");
        String location = r.getParameter("location");
        String role= r.getParameter("role");

        validatePasswords(pw, cpw);
        validateRole(role);

        if (crud.update(new User(id, pw, cpw, location, role))) {
            // Refresh session user if same ID
            HttpSession ses = r.getSession(false);
            if (ses != null) {
                User u = crud.find(id, role);
                if (u != null) ses.setAttribute("user", u);
            }
            forward(r, s, "success", "Update successful.", "update.jsp");
        } else {
            forward(r, s, "error", "User not found.", "update.jsp");
        }
    }

    /* ---------- delete ---------- */

    /* ---------- logout ---------- */
    private void handleLogout(HttpServletRequest r, HttpServletResponse s) throws IOException {
        HttpSession ses = r.getSession(false);
        if (ses != null) ses.invalidate();
        s.sendRedirect(r.getContextPath() + "/register.jsp");
    }

    /* ---------- helper methods ---------- */
    private static int parseId(String idStr) {
        if (idStr == null || idStr.isBlank())
            throw new IllegalArgumentException("Port ID is required.");
        try {
            return Integer.parseInt(idStr);
        } catch (NumberFormatException e) {
            throw new IllegalArgumentException("Port ID must be an integer.");
        }
    }

    private static void validatePasswords(String pw, String cpw) {
        if (pw == null || cpw == null || pw.isBlank() || cpw.isBlank())
            throw new IllegalArgumentException("Password fields are required.");
        if (!pw.equals(cpw))
            throw new IllegalArgumentException("Passwords do not match.");
    }

    private static void validateRole(String role) {
        if (role == null || role.isBlank())
            throw new IllegalArgumentException("Role is required.");
    }

    private static void forward(HttpServletRequest r, HttpServletResponse s,
                                String attr, String msg, String page)
            throws ServletException, IOException {
        r.setAttribute(attr, msg);
        r.getRequestDispatcher(page).forward(r, s);
    }

}
