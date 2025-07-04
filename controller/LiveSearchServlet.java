package controller;

import dao.BookDAO;
import java.io.IOException;
import java.io.PrintWriter;
import java.sql.SQLException;
import java.util.List;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import model.Book;

/**
 * Servlet to handle AJAX live search requests
 */
@WebServlet(name = "LiveSearchServlet", urlPatterns = {"/liveSearch"})
public class LiveSearchServlet extends HttpServlet {

    /**
     * Handles the HTTP GET method - used for AJAX search requests
     */
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        // Set response type to JSON
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        
        PrintWriter out = response.getWriter();
        
        try {
            // Get search parameters
            String query = request.getParameter("query");
            String type = request.getParameter("type"); // title, author, or both
            
            // Validate inputs
            if (query == null || query.trim().isEmpty()) {
                out.print("[]"); // Empty result if no query
                return;
            }
            
            if (type == null || type.trim().isEmpty()) {
                type = "both"; // Default search type
            }
            
            // Initialize BookDAO
            BookDAO bookDAO = new BookDAO();
            List<Book> books = null;
            
            // Perform search based on type
            switch (type) {
                case "title":
                    books = bookDAO.searchBooksByTitle(query);
                    break;
                case "author":
                    books = bookDAO.searchBooksByAuthor(query);
                    break;
                case "both":
                default:
                    books = bookDAO.searchBooks(query);
                    break;
            }
            
            // Convert search results to JSON manually
            String jsonResponse = convertBooksToJson(books);
            out.print(jsonResponse);
        } catch (Exception e) {
            // Log the error and return empty result
            System.err.println("Error in LiveSearchServlet: " + e.getMessage());
            out.print("[]");
        } finally {
            out.close();
        }
    }
    
    /**
     * Convert a list of Book objects to JSON string manually
     * @param books List of books to convert
     * @return JSON string representation of the book list
     */
    private String convertBooksToJson(List<Book> books) {
        if (books == null) {
            return "[]";
        }
        
        StringBuilder json = new StringBuilder("[");
        boolean first = true;
        
        for (Book book : books) {
            if (!first) {
                json.append(",");
            } else {
                first = false;
            }
            
            json.append("{");
            json.append("\"id\":").append(book.getBookId()).append(",");
            json.append("\"title\":\"").append(escapeJson(book.getTitle())).append("\",");
            json.append("\"author\":\"").append(escapeJson(book.getAuthor())).append("\",");
            json.append("\"isbn\":\"").append(escapeJson(book.getIsbn())).append("\",");
            json.append("\"publisher\":\"").append(escapeJson(book.getPublisher())).append("\",");
            json.append("\"publicationYear\":").append(book.getPublicationYear()).append(",");
            json.append("\"available\":").append(book.isAvailable());
            json.append("}");
        }
        
        json.append("]");
        return json.toString();
    }
    
    /**
     * Escape special characters for JSON string
     * @param input The string to escape
     * @return Escaped string safe for JSON
     */
    private String escapeJson(String input) {
        if (input == null) {
            return "";
        }
        
        StringBuilder result = new StringBuilder();
        for (int i = 0; i < input.length(); i++) {
            char ch = input.charAt(i);
            switch (ch) {
                case '"':
                    result.append("\\\"");
                    break;
                case '\\':
                    result.append("\\\\");
                    break;
                case '\b':
                    result.append("\\b");
                    break;
                case '\f':
                    result.append("\\f");
                    break;
                case '\n':
                    result.append("\\n");
                    break;
                case '\r':
                    result.append("\\r");
                    break;
                case '\t':
                    result.append("\\t");
                    break;
                default:
                    if (ch < ' ') {
                        String hex = Integer.toHexString(ch);
                        result.append("\\u");
                        for (int j = 0; j < 4 - hex.length(); j++) {
                            result.append('0');
                        }
                        result.append(hex);
                    } else {
                        result.append(ch);
                    }
            }
        }
        return result.toString();
    }
}
