package controller;

import java.io.IOException;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import model.Book;
import dao.BookDAO;
import model.User;

@WebServlet("/studentBookSearch")
public class StudentBookSearchServlet extends HttpServlet {
    private static final String DB_URL = "jdbc:mysql://localhost:3306/library_db";
    private static final String DB_USER = "root";
    private static final String DB_PASSWORD = "";

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            response.sendRedirect("login.jsp");
            return;
        }
        User user = (User) session.getAttribute("user");
        if (user.isAdmin()) {
            response.sendRedirect("searchBook.jsp");
            return;
        }

        String searchTerm = request.getParameter("searchTerm");
        String searchType = request.getParameter("searchType");
        List<Book> bookList = new ArrayList<>();

        if (searchTerm != null && !searchTerm.trim().isEmpty()) {
            StringBuilder sql = new StringBuilder("SELECT * FROM books WHERE 1=1");
            List<Object> params = new ArrayList<>();
            if (searchType != null) {
                if (searchType.equals("title")) {
                    sql.append(" AND title LIKE ?");
                    params.add("%" + searchTerm + "%");
                } else if (searchType.equals("author")) {
                    sql.append(" AND author LIKE ?");
                    params.add("%" + searchTerm + "%");
                } else {
                    sql.append(" AND (title LIKE ? OR author LIKE ? OR isbn LIKE ?)");
                    String likeTerm = "%" + searchTerm + "%";
                    params.add(likeTerm);
                    params.add(likeTerm);
                    params.add(likeTerm);
                }
            } else {
                sql.append(" AND (title LIKE ? OR author LIKE ? OR isbn LIKE ?)");
                String likeTerm = "%" + searchTerm + "%";
                params.add(likeTerm);
                params.add(likeTerm);
                params.add(likeTerm);
            }
            try (Connection conn = DriverManager.getConnection(DB_URL, DB_USER, DB_PASSWORD);
                 PreparedStatement stmt = conn.prepareStatement(sql.toString())) {
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
                    bookList.add(book);
                }
            } catch (SQLException e) {
                request.setAttribute("errorMessage", "Database error: " + e.getMessage());
            }
        }
        request.setAttribute("bookList", bookList);
        request.getRequestDispatcher("studentSearch.jsp").forward(request, response);
    }
} 