package controller;

import dao.BookDAO;
import dao.ReservationDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import model.User;
import java.io.IOException;
import java.io.PrintWriter;

/**
 * Servlet to provide real-time dashboard metrics for AJAX updates
 */
@WebServlet(name = "DashboardCountServlet", urlPatterns = {"/dashboardCount"})
public class DashboardCountServlet extends HttpServlet {

    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        response.setContentType("application/json;charset=UTF-8");
        
        try (PrintWriter out = response.getWriter()) {
            try {
                // Get current user from session
                HttpSession session = request.getSession(false);
                if (session == null) {
                    out.print("{\"error\":\"No active session\"}");
                    return;
                }
                
                User user = (User) session.getAttribute("user");
                if (user == null) {
                    out.print("{\"error\":\"User not logged in\"}");
                    return;
                }
                
                // Get counts from DAOs
                BookDAO bookDAO = new BookDAO();
                ReservationDAO reservationDAO = new ReservationDAO();
                
                int totalBooks = bookDAO.getAllBooks().size();
                int availableBooks = bookDAO.countAvailableBooks();
                int reservedBooks = totalBooks - availableBooks;
                int reservations;
                
                // Get reservation count based on user role
                if (user.getRole() == User.Role.Admin) {
                    reservations = (int) reservationDAO.getAllReservations().stream().filter(r -> r.isActive()).count();
                } else {
                    reservations = reservationDAO.getReservationsByUser(user.getUserId()).size();
                }
                
                // Build JSON response
                out.print("{");
                out.print("\"totalBooks\":" + totalBooks + ",");
                out.print("\"availableBooks\":" + availableBooks + ",");
                out.print("\"reservedBooks\":" + reservedBooks + ",");
                out.print("\"reservations\":" + reservations);
                out.print("}");
                
            } catch (Exception e) {
                // Return error JSON
                out.print("{\"error\":\"" + e.getMessage() + "\"}");
            }
        }
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processRequest(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processRequest(request, response);
    }
}


