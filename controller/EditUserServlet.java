package controller;

import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import model.User;
import dao.UserDAO;


@WebServlet("/editUser")
public class EditUserServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private UserDAO userDAO;

    public void init() {
        userDAO = new UserDAO();
    }

    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        try {
            int userId = Integer.parseInt(request.getParameter("id"));
            User user = userDAO.getUserById(userId);
            request.setAttribute("user", user);
            request.getRequestDispatcher("editUser.jsp").forward(request, response);
        } catch (Exception e) {
            request.setAttribute("error", "Error loading user: " + e.getMessage());
            request.getRequestDispatcher("error.jsp").forward(request, response);
        }
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        try {
            int userId = Integer.parseInt(request.getParameter("userId"));
            String username = request.getParameter("username");
            String fullName = request.getParameter("fullName");
            String email = request.getParameter("email");
            String roleStr = request.getParameter("role");
            String password = request.getParameter("password");

            // Get existing user
            User user = userDAO.getUserById(userId);
            if (user == null) {
                throw new ServletException("User not found");
            }

            // Update user fields
            user.setUsername(username);
            user.setFullName(fullName);
            user.setEmail(email);
            user.setRole(User.Role.valueOf(roleStr));

            // Update password only if provided
            if (password != null && !password.trim().isEmpty()) {
                user.setPasswordHash(PasswordHasher.hashPassword(password));
            }

            // Save changes
            userDAO.updateUser(user);

            // Redirect to user list
            response.sendRedirect("manageUsers");
        } catch (Exception e) {
            request.setAttribute("error", "Error updating user: " + e.getMessage());
            request.getRequestDispatcher("error.jsp").forward(request, response);
        }
    }
} 