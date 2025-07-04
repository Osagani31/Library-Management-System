package controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;

/**
 * Servlet that handles session keep-alive requests.
 * This servlet responds to periodic requests from the client to keep the session alive.
 */
@WebServlet(name = "SessionKeepAliveServlet", urlPatterns = {"/sessionKeepAlive"})
public class SessionKeepAliveServlet extends HttpServlet {

    /**
     * Handles GET requests for session keep-alive.
     * Simply returns a 200 OK response, which is enough to keep the session alive.
     */
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Get the current session, don't create a new one if none exists
        HttpSession session = request.getSession(false);
        
        // If there's a valid session, touch it to keep it alive
        if (session != null) {
            // Access a session attribute to update last access time
            session.getAttribute("user");
            
            // Send a simple OK response
            response.setStatus(HttpServletResponse.SC_OK);
            response.setContentType("application/json");
            response.getWriter().write("{\"status\":\"success\",\"message\":\"Session refreshed\"}");
        } else {
            // No active session, send a session expired status
            response.setStatus(HttpServletResponse.SC_OK);
            response.setContentType("application/json");
            response.getWriter().write("{\"status\":\"expired\",\"message\":\"No active session\"}");
        }
    }
}


