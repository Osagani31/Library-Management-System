package controller;

import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import dao.ReservationDAO;
import model.Reservation;

@WebServlet("/cancelReservation")
public class CancelReservationServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private ReservationDAO reservationDAO;

    public void init() {
        reservationDAO = new ReservationDAO();
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        try {
            int reservationId = Integer.parseInt(request.getParameter("reservationId"));
            
            // Get the reservation
            Reservation reservation = reservationDAO.getReservationById(reservationId);
            if (reservation == null) {
                throw new ServletException("Reservation not found");
            }

            // Cancel the reservation
            reservation.setStatus(Reservation.Status.Cancelled);
            reservation.setActive(false);
            reservationDAO.updateReservation(reservation);

            // Redirect back to reservations list
            response.sendRedirect("viewReservations");
        } catch (Exception e) {
            request.setAttribute("error", "Error canceling reservation: " + e.getMessage());
            request.getRequestDispatcher("error.jsp").forward(request, response);
        }
    }
} 