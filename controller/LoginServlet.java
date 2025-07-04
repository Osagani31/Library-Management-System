package controller;

import dao.UserDAO;
import model.User;
import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.*;
import java.io.IOException;
import java.util.logging.Level;
import java.util.logging.Logger;

@WebServlet(name = "LoginServlet", value = "/login")
public class LoginServlet extends HttpServlet {
    private static final Logger logger = Logger.getLogger(LoginServlet.class.getName());
    private UserDAO userDAO;

    @Override
    public void init() throws ServletException {
        try {
            userDAO = new UserDAO();
        } catch (Exception e) {
            logger.log(Level.SEVERE, "Failed to initialize UserDAO", e);
            throw new ServletException("Failed to initialize UserDAO", e);
        }
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        // Check if there's a redirect parameter
        String redirectURL = request.getParameter("redirect");
        if (redirectURL != null && !redirectURL.isEmpty()) {
            // Store it in the session for post-login redirect
            HttpSession session = request.getSession();
            session.setAttribute("redirectURL", redirectURL);
        }
        
        // Redirect GET requests to login page
        request.getRequestDispatcher("login.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        String username = request.getParameter("username");
        String password = request.getParameter("password");
        
        // Basic input validation
        if (username == null || username.trim().isEmpty() || 
            password == null || password.trim().isEmpty()) {
            request.setAttribute("error", "Username and password are required");
            request.getRequestDispatcher("login.jsp").forward(request, response);
            return;
        }

        try {
            User user = userDAO.validateUser(username, password);
            
            if (user != null) {
                // Successful login
                HttpSession session = request.getSession();
                session.setAttribute("user", user);
                session.setMaxInactiveInterval(30 * 60); // 30 minute session timeout
                
                // Log the login activity
                logger.log(Level.INFO, "User logged in: {0}, role: {1}", new Object[]{username, user.getRole()});
                
                // If admin, always redirect to dashboard.jsp
                if (user.getRole() == User.Role.Admin) {
                    logger.log(Level.INFO, "Redirecting admin to dashboard.jsp");
                    response.sendRedirect("dashboard.jsp");
                    return;
                }
                // For non-admins, check if there's a redirectURL in the session and use it
                String redirectURL = (String) session.getAttribute("redirectURL");
                logger.log(Level.INFO, "User role: {0}, redirectURL: {1}", new Object[]{user.getRole(), redirectURL});
                if (redirectURL != null && !redirectURL.isEmpty()) {
                    // Remove it from the session to prevent future unwanted redirects
                    session.removeAttribute("redirectURL");
                    response.sendRedirect(redirectURL);
                } else {
                    // Default redirect to dashboard
                    logger.log(Level.INFO, "Redirecting user to dashboard.jsp");
                    response.sendRedirect("dashboard.jsp");
                }
            } else {
                // Failed login
                logger.log(Level.WARNING, "Failed login attempt for username: {0}", username);
                request.setAttribute("error", "Invalid username or password");
                request.getRequestDispatcher("login.jsp").forward(request, response);
            }
        } catch (Exception e) {
            logger.log(Level.SEVERE, "Login error for username: " + username, e);
            request.setAttribute("error", "System error occurred. Please try again later.");
            request.getRequestDispatcher("error.jsp").forward(request, response);
        }
    }
}


