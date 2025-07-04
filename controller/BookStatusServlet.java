package controller;

import java.io.IOException;
import java.sql.*;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import model.User;

@WebServlet("/BookStatusServlet")
public class BookStatusServlet extends HttpServlet {
    private static final String DB_URL = "jdbc:mysql://localhost:3306/library_db";
    private static final String DB_USER = "root";
    private static final String DB_PASSWORD = "";

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            response.sendRedirect("login.jsp");
            return;
        }
        User user = (User) session.getAttribute("user");
        if (!user.isAdmin()) {
            response.sendRedirect("access-denied.jsp");
            return;
        }
        String bookIdParam = request.getParameter("bookId");
        String status = request.getParameter("status");
        if (bookIdParam == null || status == null) {
            response.sendRedirect("AllBooks.jsp");
            return;
        }
        int bookId = Integer.parseInt(bookIdParam);
        try (Connection conn = DriverManager.getConnection(DB_URL, DB_USER, DB_PASSWORD)) {
            String sql;
            if ("available".equals(status)) {
                sql = "UPDATE books SET is_available = TRUE, status = NULL WHERE book_id = ?";
                // After updating the book, mark all active reservations as completed/returned
                try (PreparedStatement updateResStmt = conn.prepareStatement(
                        "UPDATE reservations SET is_active = FALSE, status = 'Completed' WHERE book_id = ? AND is_active = TRUE")) {
                    updateResStmt.setInt(1, bookId);
                    updateResStmt.executeUpdate();
                }
            } else if ("pending".equals(status)) {
                sql = "UPDATE books SET is_available = FALSE, status = 'pending' WHERE book_id = ?";
            } else if ("reserved".equals(status)) {
                sql = "UPDATE books SET is_available = FALSE, status = 'reserved' WHERE book_id = ?";
            } else {
                response.sendRedirect("AllBooks.jsp");
                return;
            }
            try (PreparedStatement stmt = conn.prepareStatement(sql)) {
                stmt.setInt(1, bookId);
                stmt.executeUpdate();
            }
        } catch (SQLException e) {
            request.setAttribute("errorMessage", "Database error: " + e.getMessage());
            request.getRequestDispatcher("error.jsp").forward(request, response);
            return;
        }
        response.sendRedirect("AllBooks.jsp");
    }
} 