package controller;

import java.io.IOException;
import java.util.List;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import model.Reservation;
import dao.ReservationDAO;
import model.User;
import dao.UserDAO;

@WebServlet("/viewReservations")
public class ViewReservationsServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private ReservationDAO reservationDAO;

    public void init() {
        reservationDAO = new ReservationDAO();
    }

    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        try {
            HttpSession session = request.getSession(false);
            if (session == null || session.getAttribute("user") == null) {
                request.setAttribute("error", "User not logged in.");
                request.getRequestDispatcher("error.jsp").forward(request, response);
                return;
            }
            User user = (User) session.getAttribute("user");
            UserDAO userDAO = new UserDAO();
            List<Reservation> reservations;
            if (user.isAdmin()) {
                List<Reservation> allReservations = reservationDAO.getAllReservations();
                reservations = new java.util.ArrayList<>();
                for (Reservation r : allReservations) {
                    if (r.isActive() && (r.getStatus() == Reservation.Status.Active || r.getStatus().name().equalsIgnoreCase("Reserved"))) {
                        if (r.getUserName() == null || r.getUserName().isEmpty()) {
                            model.User resUser = userDAO.getUserById(r.getUserId());
                            if (resUser != null) r.setUserName(resUser.getFullName());
                        }
                        reservations.add(r);
                    }
                }
            } else {
                reservations = reservationDAO.getReservationsByUser(user.getUserId());
            }
            request.setAttribute("reservations", reservations);
            request.getRequestDispatcher("viewReservation.jsp").forward(request, response);
        } catch (Exception e) {
            request.setAttribute("error", "Error loading reservations: " + e.getMessage());
            request.getRequestDispatcher("error.jsp").forward(request, response);
        }
    }
} 