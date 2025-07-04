package controller;

import java.io.IOException;
import java.util.List;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import model.User;
import dao.UserDAO;

@WebServlet("/manageUsers")
public class ManageUsersServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private UserDAO userDAO;

    public void init() {
        userDAO = new UserDAO();
    }

    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        try {
            List<User> users = userDAO.getAllUsers();
            request.setAttribute("users", users);
            request.getRequestDispatcher("manageUsers.jsp").forward(request, response);
        } catch (Exception e) {
            request.setAttribute("error", "Error loading users: " + e.getMessage());
            request.getRequestDispatcher("error.jsp").forward(request, response);
        }
    }
} 