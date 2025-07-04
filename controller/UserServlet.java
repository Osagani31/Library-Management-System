package controller;

import dao.UserDAO;
import java.io.IOException;
import java.util.List;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import model.User;

/**
 * Servlet that handles user management operations
 */
@WebServlet(name = "UserServlet", urlPatterns = {"/user"})
public class UserServlet extends HttpServlet {
    
    /**
     * Handles GET requests for user operations
     */
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        String action = request.getParameter("action");
        if (action == null) {
            action = "list"; // Default action
        }
        
        // Check if user is logged in and is an admin
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            // Store the intended URL for after login
            session = request.getSession(true);
            session.setAttribute("redirectURL", "user?action=" + action);
            response.sendRedirect("login");
            return;
        }
        
        User currentUser = (User) session.getAttribute("user");
        if (!currentUser.isAdmin()) {
            // Not an admin, redirect to dashboard
            response.sendRedirect("dashboard.jsp");
            return;
        }
        
        // Process the action
        try {
            switch (action) {
                case "list":
                    listUsers(request, response);
                    break;
                case "view":
                    viewUser(request, response);
                    break;
                case "students":
                    listStudents(request, response);
                    break;
                default:
                    listUsers(request, response);
                    break;
            }
        } catch (Exception ex) {
            request.setAttribute("errorMessage", "Error: " + ex.getMessage());
            request.getRequestDispatcher("/error.jsp").forward(request, response);
        }
    }
    
    /**
     * Lists all users
     */
    private void listUsers(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        UserDAO userDAO = new UserDAO();
        List<User> users = userDAO.getAllUsers();
        
        request.setAttribute("users", users);
        request.setAttribute("pageTitle", "All Users");
        request.getRequestDispatcher("/userList.jsp").forward(request, response);
    }
    
    /**
     * Lists only student users
     */
    private void listStudents(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        UserDAO userDAO = new UserDAO();
        List<User> students = userDAO.getAllStudents();
        
        request.setAttribute("users", students);
        request.setAttribute("pageTitle", "Student Users");
        request.getRequestDispatcher("/userList.jsp").forward(request, response);
    }
    
    /**
     * View a specific user's details
     */
    private void viewUser(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String userId = request.getParameter("id");
        if (userId == null || userId.isEmpty()) {
            request.setAttribute("errorMessage", "User ID is required");
            request.getRequestDispatcher("/error.jsp").forward(request, response);
            return;
        }
        
        try {
            int id = Integer.parseInt(userId);
            UserDAO userDAO = new UserDAO();
            User user = userDAO.getUserById(id);
            
            if (user == null) {
                request.setAttribute("errorMessage", "User not found");
                request.getRequestDispatcher("/error.jsp").forward(request, response);
                return;
            }
            
            request.setAttribute("user", user);
            request.getRequestDispatcher("/userDetails.jsp").forward(request, response);
            
        } catch (NumberFormatException e) {
            request.setAttribute("errorMessage", "Invalid User ID");
            request.getRequestDispatcher("/error.jsp").forward(request, response);
        }
    }
}
