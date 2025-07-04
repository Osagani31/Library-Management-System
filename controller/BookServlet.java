package controller;

import java.io.IOException;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;
import java.util.Iterator;
import java.util.HashMap;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import model.Book;
import dao.BookDAO;
import model.User;

@WebServlet("/book")
public class BookServlet extends HttpServlet {
    private static final String DB_URL = "jdbc:mysql://localhost:3306/library_db";
    private static final String DB_USER = "root";
    private static final String DB_PASSWORD = "";

    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        String action = request.getParameter("action");
        
        try {
            switch (action) {
                case "search":
                    searchBooks(request, response);
                    break;
                case "list":
                    listAllBooks(request, response);
                    break;
                case "reserve":
                    reserveBook(request, response);
                    break;
                case "new":
                    showNewForm(request, response);
                    break;
                case "livesearch":
                    liveSearchBooks(request, response);
                    break;
                default:
                    listAllBooks(request, response);
                    break;
            }
        } catch (SQLException ex) {
            throw new ServletException(ex);
        }
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        String action = request.getParameter("action");
        
        try {
            switch (action) {
                case "add":
                    addBook(request, response);
                    break;
                default:
                    response.sendRedirect("book?action=list");
                    break;
            }
        } catch (SQLException ex) {
            request.setAttribute("errorMessage", "Database error: " + ex.getMessage());
            request.getRequestDispatcher("/error.jsp").forward(request, response);
        } catch (Exception ex) {
            request.setAttribute("errorMessage", "Error: " + ex.getMessage());
            request.getRequestDispatcher("/error.jsp").forward(request, response);
        }
    }

    private void searchBooks(HttpServletRequest request, HttpServletResponse response)
            throws SQLException, ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            response.sendRedirect("login.jsp");
            return;
        }
        
        String searchTerm = request.getParameter("searchTerm");
        String searchType = request.getParameter("searchType");
        String title = request.getParameter("title");
        String author = request.getParameter("author");
        String isbn = request.getParameter("isbn");
        String publisher = request.getParameter("publisher");
        String yearFrom = request.getParameter("yearFrom");
        String yearTo = request.getParameter("yearTo");
        String available = request.getParameter("available");
        
        List<Book> bookList = new ArrayList<>();
        StringBuilder sql = new StringBuilder("SELECT b.*, r.reservation_id, r.user_id, u.username, u.full_name " +
                                         "FROM books b " +
                                         "LEFT JOIN reservations r ON b.book_id = r.book_id AND r.is_active = true " +
                                         "LEFT JOIN users u ON r.user_id = u.user_id " +
                                         "WHERE 1=1");
        List<Object> params = new ArrayList<>();

        // General search term (searches title, author, and ISBN)
        if (searchTerm != null && !searchTerm.isEmpty()) {
            // If searchType is specified, we'll search only in that field
            if (searchType != null) {
                if (searchType.equals("title")) {
                    sql.append(" AND b.title LIKE ?");
                    params.add("%" + searchTerm + "%");
                } else if (searchType.equals("author")) {
                    sql.append(" AND b.author LIKE ?");
                    params.add("%" + searchTerm + "%");
                } else {
                    // Default: search in all fields
                    sql.append(" AND (b.title LIKE ? OR b.author LIKE ? OR b.isbn LIKE ?)");
                    String likeTerm = "%" + searchTerm + "%";
                    params.add(likeTerm);
                    params.add(likeTerm);
                    params.add(likeTerm);
                }
            } else {
                // No search type specified, search in all fields
                sql.append(" AND (b.title LIKE ? OR b.author LIKE ? OR b.isbn LIKE ?)");
                String likeTerm = "%" + searchTerm + "%";
                params.add(likeTerm);
                params.add(likeTerm);
                params.add(likeTerm);
            }
        }

        // Advanced search fields - kept for backward compatibility
        if (title != null && !title.isEmpty()) {
            sql.append(" AND b.title LIKE ?");
            params.add("%" + title + "%");
        }
        
        if (author != null && !author.isEmpty()) {
            sql.append(" AND b.author LIKE ?");
            params.add("%" + author + "%");
        }
        
        if (isbn != null && !isbn.isEmpty()) {
            sql.append(" AND b.isbn LIKE ?");
            params.add("%" + isbn + "%");
        }
        
        if (publisher != null && !publisher.isEmpty()) {
            sql.append(" AND b.publisher LIKE ?");
            params.add("%" + publisher + "%");
        }
        
        if (yearFrom != null && !yearFrom.isEmpty()) {
            sql.append(" AND b.publication_year >= ?");
            params.add(Integer.parseInt(yearFrom));
        }
        
        if (yearTo != null && !yearTo.isEmpty()) {
            sql.append(" AND b.publication_year <= ?");
            params.add(Integer.parseInt(yearTo));
        }
        
        if (available != null && !available.isEmpty()) {
            sql.append(" AND b.is_available = ?");
            params.add(Boolean.parseBoolean(available));
        }

        try (Connection conn = DriverManager.getConnection(DB_URL, DB_USER, DB_PASSWORD);
             PreparedStatement stmt = conn.prepareStatement(sql.toString())) {
            
            // Set all parameters
            for (int i = 0; i < params.size(); i++) {
                stmt.setObject(i + 1, params.get(i));
            }
            
            ResultSet rs = stmt.executeQuery();
            
            while (rs.next()) {
                Book book = new Book();
                book.setBookId(rs.getInt("book_id"));
                book.setTitle(rs.getString("title"));
                book.setAuthor(rs.getString("author"));
                book.setIsbn(rs.getString("isbn"));
                book.setPublisher(rs.getString("publisher"));
                book.setPublicationYear(rs.getInt("publication_year"));
                book.setAvailable(rs.getBoolean("is_available"));
                
                // Add reserved user information if available
                try {
                    int userId = rs.getInt("user_id");
                    if (!rs.wasNull()) {
                        book.setReservedById(userId);
                        book.setReservedByUsername(rs.getString("username"));
                        book.setReservedByFullName(rs.getString("full_name"));
                    }
                } catch (SQLException e) {
                    // Ignore if these columns don't exist
                }
                
                bookList.add(book);
            }
        }
        
        request.setAttribute("bookList", bookList);
        if (request.getSession(false) != null) {
            User user = (User) request.getSession(false).getAttribute("user");
            if (user != null && !user.isAdmin()) {
                request.getRequestDispatcher("/bookList.jsp").forward(request, response);
                return;
            }
        }
        request.getRequestDispatcher("/searchBook.jsp").forward(request, response);
    }

    private void listAllBooks(HttpServletRequest request, HttpServletResponse response)
            throws SQLException, ServletException, IOException {
        
        List<Book> bookList = new ArrayList<>();
        
        String sql = "SELECT b.*, r.reservation_id, r.user_id, u.username, u.full_name " +
                    "FROM books b " +
                    "LEFT JOIN reservations r ON b.book_id = r.book_id AND r.is_active = true " +
                    "LEFT JOIN users u ON r.user_id = u.user_id";
        
        try (Connection conn = DriverManager.getConnection(DB_URL, DB_USER, DB_PASSWORD);
             Statement stmt = conn.createStatement();
             ResultSet rs = stmt.executeQuery(sql)) {
            
            while (rs.next()) {
                Book book = new Book();
                book.setBookId(rs.getInt("book_id"));
                book.setTitle(rs.getString("title"));
                book.setAuthor(rs.getString("author"));
                book.setIsbn(rs.getString("isbn"));
                book.setPublisher(rs.getString("publisher"));
                book.setPublicationYear(rs.getInt("publication_year"));
                book.setAvailable(rs.getBoolean("is_available"));
                
                // Add reserved user information if available
                try {
                    int userId = rs.getInt("user_id");
                    if (!rs.wasNull()) {
                        book.setReservedById(userId);
                        book.setReservedByUsername(rs.getString("username"));
                        book.setReservedByFullName(rs.getString("full_name"));
                    }
                } catch (SQLException e) {
                    // Ignore if these columns don't exist
                }
                
                bookList.add(book);
            }
        }
        
        request.setAttribute("bookList", bookList);
        request.getRequestDispatcher("/bookList.jsp").forward(request, response);
    }

    private void reserveBook(HttpServletRequest request, HttpServletResponse response)
            throws SQLException, ServletException, IOException {
        
        int bookId = Integer.parseInt(request.getParameter("bookId"));
        
        // Get the user from session
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");
        if (user == null) {
            session.setAttribute("redirectURL", "book?action=list");
            response.sendRedirect("login");
            return;
        }
        int userId = user.getUserId();
        
        // First, use BookDAO to update book availability
        BookDAO bookDAO = new BookDAO();
        boolean bookUpdated = bookDAO.updateBookAvailability(bookId, false);
        
        if (!bookUpdated) {
            request.setAttribute("errorMessage", "Failed to update book availability.");
            request.getRequestDispatcher("/error.jsp").forward(request, response);
            return;
        }
        
        // Now create the reservation
        try {
            // Use a direct SQL connection for the reservation
            String reserveSql = "INSERT INTO reservations (user_id, book_id, reservation_date, status) VALUES (?, ?, NOW(), 'Active')";
            
            try (Connection conn = DriverManager.getConnection(DB_URL, DB_USER, DB_PASSWORD);
                 PreparedStatement stmt = conn.prepareStatement(reserveSql)) {
                
                stmt.setInt(1, userId);
                stmt.setInt(2, bookId);
                int rowsAffected = stmt.executeUpdate();
                
                if (rowsAffected > 0) {
                    // Get the book details to show on success page
                    Book reservedBook = new Book();
                    String bookSql = "SELECT * FROM books WHERE book_id = ?";
                    try (PreparedStatement bookStmt = conn.prepareStatement(bookSql)) {
                        bookStmt.setInt(1, bookId);
                        try (ResultSet rs = bookStmt.executeQuery()) {
                            if (rs.next()) {
                                reservedBook.setBookId(rs.getInt("book_id"));
                                reservedBook.setTitle(rs.getString("title"));
                                reservedBook.setAuthor(rs.getString("author"));
                                reservedBook.setIsbn(rs.getString("isbn"));
                                reservedBook.setPublisher(rs.getString("publisher"));
                                reservedBook.setPublicationYear(rs.getInt("publication_year"));
                                reservedBook.setAvailable(false);
                            }
                        }
                    }
                    
                    // Set book as an attribute and forward to success page
                    request.setAttribute("book", reservedBook);
                    request.getRequestDispatcher("/reservationSuccess.jsp").forward(request, response);
                } else {
                    // Something went wrong
                    request.setAttribute("errorMessage", "Failed to reserve the book.");
                    request.getRequestDispatcher("/error.jsp").forward(request, response);
                }
            }
        } catch (SQLException e) {
            // If reservation fails, try to revert the book availability
            bookDAO.updateBookAvailability(bookId, true);
            request.setAttribute("errorMessage", "Database error: " + e.getMessage());
            request.getRequestDispatcher("/error.jsp").forward(request, response);
        }
    }

    private void showNewForm(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Check if user is logged in and is an admin
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            // Store the intended URL for after login
            session = request.getSession(true);
            session.setAttribute("redirectURL", "book?action=new");
            response.sendRedirect("login");
            return;
        }
        
        // Get the user object from the session
        try {
            Object userObj = session.getAttribute("user");
            // Use reflection to safely check the role
            String role = userObj.getClass().getMethod("getRole").invoke(userObj).toString();
            
            if (!"Admin".equals(role)) {
                // Not an admin, redirect to dashboard
                response.sendRedirect("dashboard.jsp");
                return;
            }
            
            // If we get here, the user is an admin, show the form
            request.getRequestDispatcher("/bookForm.jsp").forward(request, response);
            
        } catch (Exception e) {
            // Error accessing user object, redirect to login
            response.sendRedirect("login");
        }
    }

    private void addBook(HttpServletRequest request, HttpServletResponse response)
            throws SQLException, ServletException, IOException {
        // Session and admin check
        HttpSession session = request.getSession(false);
        User user = (session != null) ? (User) session.getAttribute("user") : null;
        if (user == null || !user.isAdmin()) {
            request.setAttribute("errorMessage", "You must be logged in as an admin to add books.");
            request.getRequestDispatcher("/login.jsp").forward(request, response);
            return;
        }
        
        String title = request.getParameter("title");
        String author = request.getParameter("author");
        String isbn = request.getParameter("isbn");
        String publisher = request.getParameter("publisher");
        String publicationYearStr = request.getParameter("publicationYear");
        boolean isAvailable = request.getParameter("isAvailable") != null;
        
        // Initialize validation error list
        List<String> validationErrors = new ArrayList<>();
        
        // Validate title (required, max length)
        if (title == null || title.trim().isEmpty()) {
            validationErrors.add("Title is required");
        } else if (title.length() > 255) {
            validationErrors.add("Title cannot exceed 255 characters");
        }
        
        // Validate author (required, max length)
        if (author == null || author.trim().isEmpty()) {
            validationErrors.add("Author is required");
        } else if (author.length() > 255) {
            validationErrors.add("Author cannot exceed 255 characters");
        }
        
        // Validate ISBN (format if provided)
        if (isbn != null && !isbn.trim().isEmpty()) {
            if (isbn.length() > 20) {
                validationErrors.add("ISBN cannot exceed 20 characters");
            }
            // Additional ISBN format validation could be added here
        }
        
        // Validate publisher (max length if provided)
        if (publisher != null && publisher.length() > 100) {
            validationErrors.add("Publisher cannot exceed 100 characters");
        }
        
        // Validate publication year (range check if provided)
        int publicationYear = 0;
        if (publicationYearStr != null && !publicationYearStr.trim().isEmpty()) {
            try {
                publicationYear = Integer.parseInt(publicationYearStr);
                int currentYear = java.time.Year.now().getValue();
                if (publicationYear < 1000 || publicationYear > currentYear) {
                    validationErrors.add("Publication year must be between 1000 and " + currentYear);
                }
            } catch (NumberFormatException e) {
                validationErrors.add("Invalid publication year format");
            }
        }
        
        // If validation errors found, return to form with errors
        if (!validationErrors.isEmpty()) {
            request.setAttribute("errorMessage", String.join("<br>", validationErrors));
            // Preserve form data for re-display
            request.setAttribute("book", createBookFromParameters(title, author, isbn, publisher, publicationYear, isAvailable));
            request.getRequestDispatcher("/addBook.jsp").forward(request, response);
            return;
        }
        
        // Create a Book object
        Book book = createBookFromParameters(title, author, isbn, publisher, publicationYear, isAvailable);
        
        // Use BookDAO to add the book
        BookDAO bookDAO = new BookDAO();
        boolean success = bookDAO.addBook(book);
        
        if (success) {
            // Book added successfully
            System.out.println("Book added successfully with ID: " + book.getBookId());
            // Set book details as request attributes for addSuccess.jsp
            request.setAttribute("title", book.getTitle());
            request.setAttribute("author", book.getAuthor());
            request.setAttribute("isbn", book.getIsbn());
            request.setAttribute("publicationYear", book.getPublicationYear());
            request.setAttribute("publisher", book.getPublisher());
            request.setAttribute("isAvailable", book.isAvailable());
            request.getRequestDispatcher("/addSuccess.jsp").forward(request, response);
            return;
        } else {
            request.setAttribute("errorMessage", "Failed to add the book to the database");
            request.setAttribute("book", book); // Preserve form data
            request.getRequestDispatcher("/addBook.jsp").forward(request, response);
        }
    }
    
    /**
     * Helper method to create a Book object from request parameters
     */
    private Book createBookFromParameters(String title, String author, String isbn, 
                                         String publisher, int publicationYear, boolean isAvailable) {
        Book book = new Book();
        book.setTitle(title != null ? title : "");
        book.setAuthor(author != null ? author : "");
        book.setIsbn(isbn != null ? isbn : "");
        book.setPublisher(publisher != null ? publisher : "");
        book.setPublicationYear(publicationYear);
        book.setAvailable(isAvailable);
        return book;
    }

    /**
     * Handles live search requests via AJAX
     */
    private void liveSearchBooks(HttpServletRequest request, HttpServletResponse response)
            throws SQLException, ServletException, IOException {
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        try {
            String searchTerm = request.getParameter("term");
            String searchType = request.getParameter("type");
            if (searchType == null || (!searchType.equals("title") && !searchType.equals("author"))) {
                searchType = "both"; // Default search type
            }
            List<Book> bookList = new ArrayList<>();
            if (searchTerm != null && !searchTerm.trim().isEmpty()) {
                StringBuilder sqlBuilder = new StringBuilder(
                    "SELECT b.*, r.reservation_id, r.user_id, u.username, u.full_name " +
                    "FROM books b " +
                    "LEFT JOIN reservations r ON b.book_id = r.book_id AND r.is_active = true " +
                    "LEFT JOIN users u ON r.user_id = u.user_id " +
                    "WHERE ");
                // Add WHERE clause based on search type
                if (searchType.equals("title")) {
                    sqlBuilder.append("b.title LIKE ?");
                } else if (searchType.equals("author")) {
                    sqlBuilder.append("b.author LIKE ?");
                } else {
                    sqlBuilder.append("(b.title LIKE ? OR b.author LIKE ? OR b.isbn LIKE ?)");
                }
                sqlBuilder.append(" LIMIT 10"); // Limit for performance reasons
                try (Connection conn = DriverManager.getConnection(DB_URL, DB_USER, DB_PASSWORD);
                     PreparedStatement stmt = conn.prepareStatement(sqlBuilder.toString())) {
                    String likeTerm = "%" + searchTerm + "%";
                    if (searchType.equals("title") || searchType.equals("author")) {
                        stmt.setString(1, likeTerm);
                    } else {
                        stmt.setString(1, likeTerm);
                        stmt.setString(2, likeTerm);
                        stmt.setString(3, likeTerm);
                    }
                    ResultSet rs = stmt.executeQuery();
                    while (rs.next()) {
                        Book book = new Book();
                        book.setBookId(rs.getInt("book_id"));
                        book.setTitle(rs.getString("title"));
                        book.setAuthor(rs.getString("author"));
                        book.setIsbn(rs.getString("isbn"));
                        book.setPublisher(rs.getString("publisher"));
                        book.setPublicationYear(rs.getInt("publication_year"));
                        book.setAvailable(rs.getBoolean("is_available"));
                        // Add reserved user information if available
                        try {
                            int userId = rs.getInt("user_id");
                            if (!rs.wasNull()) {
                                book.setReservedById(userId);
                                book.setReservedByUsername(rs.getString("username"));
                                book.setReservedByFullName(rs.getString("full_name"));
                            }
                        } catch (SQLException e) {
                            // Ignore if these columns don't exist
                        }
                        bookList.add(book);
                    }
                }
            }
            // Convert to JSON and send response
            List<Map<String, Object>> simplifiedBooks = new ArrayList<>();
            for (Book book : bookList) {
                Map<String, Object> simplifiedBook = new HashMap<>();
                simplifiedBook.put("bookId", book.getBookId());
                simplifiedBook.put("title", book.getTitle());
                simplifiedBook.put("author", book.getAuthor());
                simplifiedBook.put("isbn", book.getIsbn());
                simplifiedBook.put("available", book.isAvailable());
                // Optionally add reservedBy if reserved
                if (book.isReserved()) {
                    simplifiedBook.put("reservedBy", book.getReservedByFullName());
                }
                simplifiedBooks.add(simplifiedBook);
            }
            response.getWriter().write(convertToJsonArray(simplifiedBooks));
        } catch (Exception e) {
            // Log the error and return an empty array to avoid breaking JSON.parse
            e.printStackTrace();
            response.getWriter().write("[]");
        }
    }

    /**
     * Simple method to convert a list of maps to a JSON array
     */
    private String convertToJsonArray(List<Map<String, Object>> list) {
        StringBuilder json = new StringBuilder("[");
        for (int i = 0; i < list.size(); i++) {
            json.append(convertToJsonObject(list.get(i)));
            if (i < list.size() - 1) {
                json.append(",");
            }
        }
        json.append("]");
        return json.toString();
    }

    /**
     * Simple method to convert a map to a JSON object
     */
    private String convertToJsonObject(Map<String, Object> map) {
        StringBuilder json = new StringBuilder("{");
        Iterator<Map.Entry<String, Object>> it = map.entrySet().iterator();
        while (it.hasNext()) {
            Map.Entry<String, Object> entry = it.next();
            json.append("\"").append(entry.getKey()).append("\":");
            if (entry.getValue() instanceof String) {
                json.append("\"").append(escapeJson(entry.getValue().toString())).append("\"");
            } else {
                json.append(entry.getValue());
            }
            if (it.hasNext()) {
                json.append(",");
            }
        }
        json.append("}");
        return json.toString();
    }

    /**
     * Escape quotes in strings for JSON
     */
    private String escapeJson(String input) {
        return input.replace("\\", "\\\\")
                   .replace("\"", "\\\"")
                   .replace("\n", "\\n")
                   .replace("\r", "\\r")
                   .replace("\t", "\\t");
    }
}

