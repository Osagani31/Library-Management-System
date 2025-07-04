package controller;

import dao.ReservationDAO;
import dao.BookDAO;
import model.Reservation;
import model.User;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.util.List;

@WebServlet("/reservationList")
public class ReservationListServlet extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        User user = (session != null) ? (User) session.getAttribute("user") : null;
        if (user == null) {
            response.setStatus(HttpServletResponse.SC_UNAUTHORIZED);
            return;
        }
        ReservationDAO reservationDAO = new ReservationDAO();
        List<Reservation> reservations = reservationDAO.getReservationsByUser(user.getUserId());
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        response.getWriter().write(convertReservationsToJson(reservations));
    }

    private String convertReservationsToJson(List<Reservation> reservations) {
        StringBuilder json = new StringBuilder("[");
        boolean first = true;
        BookDAO bookDAO = new BookDAO();
        for (Reservation r : reservations) {
            if (!first) json.append(",");
            first = false;
            String bookTitle = "N/A";
            try {
                model.Book book = bookDAO.getBookById(r.getBookId());
                if (book != null) bookTitle = book.getTitle();
            } catch (Exception e) { /* ignore */ }
            json.append("{")
                .append("\"reservationId\":").append(r.getReservationId()).append(",")
                .append("\"bookId\":").append(r.getBookId()).append(",")
                .append("\"bookTitle\":\"").append(bookTitle.replace("\"", "\\\"")).append("\",")
                .append("\"userId\":").append(r.getUserId()).append(",")
                .append("\"reservationDate\":\"").append(r.getReservationDate()).append("\",")
                .append("\"status\":\"").append(r.getStatus()).append("\",")
                .append("\"isActive\":").append(r.isActive())
                .append("}");
        }
        json.append("]");
        return json.toString();
    }
} 