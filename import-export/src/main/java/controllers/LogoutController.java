package controllers;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;

/**
 * Servlet implementation class Logout
 */
@WebServlet("/Logout")
public class LogoutController extends HttpServlet {
	
	private void handleLogout(HttpServletRequest r, HttpServletResponse s) throws IOException {
        HttpSession ses = r.getSession(false);
        if (ses != null) ses.invalidate();
        s.sendRedirect("/import-export/test_register.jsp");
    }
	
	@Override
		protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
			handleLogout(req, resp);
		}
}
