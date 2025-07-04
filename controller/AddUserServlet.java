package controller;

import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import model.User;
import dao.UserDAO;


@WebServlet("/addUser")
public class AddUserServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private UserDAO userDAO;

    public void init() {
        userDAO = new UserDAO();
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        try {
            // Get form data
            String username = request.getParameter("username");
            String password = request.getParameter("password");
            String fullName = request.getParameter("fullName");
            String email = request.getParameter("email");
            String roleStr = request.getParameter("role");

            // Validate input
            if (username == null || password == null || fullName == null || email == null || roleStr == null) {
                throw new ServletException("All fields are required");
            }

            // Create new user
            User user = new User();
            user.setUsername(username);
            user.setPasswordHash(PasswordHasher.hashPassword(password));
            user.setFullName(fullName);
            user.setEmail(email);
            user.setRole(User.Role.valueOf(roleStr));

            // Save user
            userDAO.addUser(user);

            // Redirect to user list
            response.sendRedirect("manageUsers");
        } catch (Exception e) {
            request.setAttribute("error", "Error adding user: " + e.getMessage());
            request.getRequestDispatcher("error.jsp").forward(request, response);
        }
    }
} 