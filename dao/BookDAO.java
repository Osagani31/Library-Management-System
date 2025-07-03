package dao;

import model.Book;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;
import java.util.logging.Level;
import java.util.logging.Logger;

public class BookDAO {
    private static final Logger logger = Logger.getLogger(BookDAO.class.getName());
    private static final String DATABASE_NAME = "library_db";

    public List<Book> getAllBooks() {
        List<Book> books = new ArrayList<>();
        String sql = "SELECT book_id, title, author, isbn, publisher, publication_year, is_available FROM " + DATABASE_NAME + ".books";

        try (Connection conn = DBConnection.getConnection();
             Statement stmt = conn.createStatement();
             ResultSet rs = stmt.executeQuery(sql)) {

            while (rs.next()) {
                books.add(mapResultSetToBook(rs));
            }
        } catch (SQLException e) {
            logger.log(Level.SEVERE, "Error getting all books", e);
        }
        return books;
    }

    public List<Book> getAvailableBooks() {
        List<Book> books = new ArrayList<>();
        String sql = "SELECT book_id, title, author, isbn, publisher, publication_year, is_available FROM " + DATABASE_NAME + ".books WHERE is_available = true";

        try (Connection conn = DBConnection.getConnection();
             Statement stmt = conn.createStatement();
             ResultSet rs = stmt.executeQuery(sql)) {

            while (rs.next()) {
                books.add(mapResultSetToBook(rs));
            }
        } catch (SQLException e) {
            logger.log(Level.SEVERE, "Error getting available books", e);
        }
        return books;
    }

    public int countAvailableBooks() {
        String sql = "SELECT COUNT(*) FROM " + DATABASE_NAME + ".books WHERE is_available = true";
        try (Connection conn = DBConnection.getConnection();
             Statement stmt = conn.createStatement();
             ResultSet rs = stmt.executeQuery(sql)) {

            if (rs.next()) {
                return rs.getInt(1);
            }
        } catch (SQLException e) {
            logger.log(Level.SEVERE, "Error counting available books", e);
        }
        return 0;
    }

    public Book getBookById(int id) {
        String sql = "SELECT book_id, title, author, isbn, publisher, publication_year, is_available FROM " + DATABASE_NAME + ".books WHERE book_id = ?";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, id);
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    return mapResultSetToBook(rs);
                }
            }
        } catch (SQLException e) {
            logger.log(Level.SEVERE, "Error getting book by ID: " + id, e);
        }
        return null;
    }

    public boolean addBook(Book book) {
        String sql = "INSERT INTO " + DATABASE_NAME + ".books (title, author, isbn, publisher, publication_year, is_available) VALUES (?, ?, ?, ?, ?, ?)";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            stmt.setString(1, book.getTitle());
            stmt.setString(2, book.getAuthor());
            stmt.setString(3, book.getIsbn());
            stmt.setString(4, book.getPublisher());
            stmt.setInt(5, book.getPublicationYear());
            stmt.setBoolean(6, book.isAvailable());
            int affectedRows = stmt.executeUpdate();
            if (affectedRows == 0) {
                logger.log(Level.WARNING, "No rows affected when adding book");
                return false;
            }
            try (ResultSet generatedKeys = stmt.getGeneratedKeys()) {
                if (generatedKeys.next()) {
                    book.setBookId(generatedKeys.getInt(1));
                    logger.log(Level.INFO, "Book added with ID: " + book.getBookId());
                }
            }
            return true;
        } catch (SQLException e) {
            logger.log(Level.SEVERE, "Error adding book: " + e.getMessage(), e);
            return false;
        }
    }

    public boolean updateBook(Book book) {
        String sql = "UPDATE " + DATABASE_NAME + ".books SET title = ?, author = ?, isbn = ?, publisher = ?, publication_year = ?, is_available = ? WHERE book_id = ?";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setString(1, book.getTitle());
            stmt.setString(2, book.getAuthor());
            stmt.setString(3, book.getIsbn());
            stmt.setString(4, book.getPublisher());
            stmt.setInt(5, book.getPublicationYear());
            stmt.setBoolean(6, book.isAvailable());
            stmt.setInt(7, book.getBookId());

            return stmt.executeUpdate() > 0;
        } catch (SQLException e) {
            logger.log(Level.SEVERE, "Error updating book", e);
            return false;
        }
    }

    public boolean deleteBook(int id) {
        String sql = "DELETE FROM " + DATABASE_NAME + ".books WHERE book_id = ?";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, id);
            return stmt.executeUpdate() > 0;
        } catch (SQLException e) {
            logger.log(Level.SEVERE, "Error deleting book with ID: " + id, e);
            return false;
        }
    }

    public boolean reserveBook(int bookId, int userId) {
        Connection conn = null;
        try {
            // Prevent duplicate reservation by the same user for the same book
            dao.ReservationDAO reservationDAO = new dao.ReservationDAO();
            if (reservationDAO.hasActiveReservation(userId, bookId)) {
                return false;
            }
            conn = DBConnection.getConnection();
            conn.setAutoCommit(false);

            if (!isBookAvailable(bookId)) {
                return false;
            }

            if (!updateBookAvailability(bookId, false)) {
                conn.rollback();
                return false;
            }

            if (!createReservation(conn, bookId, userId)) {
                conn.rollback();
                return false;
            }

            conn.commit();
            return true;
        } catch (SQLException e) {
            logger.log(Level.SEVERE, "Error reserving book", e);
            if (conn != null) {
                try {
                    conn.rollback();
                } catch (SQLException ex) {
                    logger.log(Level.SEVERE, "Error during rollback", ex);
                }
            }
            return false;
        } finally {
            if (conn != null) {
                try {
                    conn.setAutoCommit(true);
                    DBConnection.closeConnection(conn);
                } catch (SQLException e) {
                    logger.log(Level.SEVERE, "Error closing connection", e);
                }
            }
        }
    }

    public boolean isBookAvailable(int bookId) {
        String sql = "SELECT is_available FROM " + DATABASE_NAME + ".books WHERE book_id = ? AND is_available = true";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, bookId);
            try (ResultSet rs = stmt.executeQuery()) {
                return rs.next();
            }
        } catch (SQLException e) {
            logger.log(Level.SEVERE, "Error checking book availability", e);
            return false;
        }
    }

    public boolean updateBookAvailability(int bookId, boolean available) {
        String sql = "UPDATE " + DATABASE_NAME + ".books SET is_available = ? WHERE book_id = ?";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setBoolean(1, available);
            stmt.setInt(2, bookId);
            return stmt.executeUpdate() > 0;
        } catch (SQLException e) {
            logger.log(Level.SEVERE, "Error updating book availability", e);
            return false;
        }
    }

    private boolean createReservation(Connection conn, int bookId, int userId) throws SQLException {
        String sql = "INSERT INTO " + DATABASE_NAME + ".reservations (book_id, user_id, reservation_date, status) VALUES (?, ?, CURRENT_TIMESTAMP, 'Active')";

        try (PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, bookId);
            stmt.setInt(2, userId);
            return stmt.executeUpdate() > 0;
        }
    }

    public List<Book> searchBooks(String searchTerm) {
        List<Book> books = new ArrayList<>();
        String sql = "SELECT book_id, title, author, isbn, publisher, publication_year, is_available FROM " + DATABASE_NAME + ".books WHERE title LIKE ? OR author LIKE ? OR isbn LIKE ?";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            String term = "%" + searchTerm + "%";
            stmt.setString(1, term);
            stmt.setString(2, term);
            stmt.setString(3, term);
            
            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    books.add(mapResultSetToBook(rs));
                }
            }
        } catch (SQLException e) {
            logger.log(Level.SEVERE, "Error searching books with term: " + searchTerm, e);
        }
        return books;
    }

    private Book mapResultSetToBook(ResultSet rs) throws SQLException {
        Book book = new Book();
        book.setBookId(rs.getInt("book_id"));
        book.setTitle(rs.getString("title"));
        book.setAuthor(rs.getString("author"));
        book.setIsbn(rs.getString("isbn"));
        book.setPublisher(rs.getString("publisher"));
        book.setPublicationYear(rs.getInt("publication_year"));
        book.setAvailable(rs.getBoolean("is_available"));
        return book;
    }

    public List<Book> searchBooksByTitle(String searchTerm) {
        List<Book> books = new ArrayList<>();
        String sql = "SELECT book_id, title, author, isbn, publisher, publication_year, is_available FROM " + DATABASE_NAME + ".books WHERE title LIKE ?";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setString(1, "%" + searchTerm + "%");
            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    books.add(mapResultSetToBook(rs));
                }
            }
        } catch (SQLException e) {
            logger.log(Level.SEVERE, "Error searching books with title: " + searchTerm, e);
        }
        return books;
    }

    public List<Book> searchBooksByISBN(String searchTerm) {
        List<Book> books = new ArrayList<>();
        String sql = "SELECT book_id, title, author, isbn, publisher, publication_year, is_available FROM " + DATABASE_NAME + ".books WHERE isbn LIKE ?";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setString(1, "%" + searchTerm + "%");
            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    books.add(mapResultSetToBook(rs));
                }
            }
        } catch (SQLException e) {
            logger.log(Level.SEVERE, "Error searching books with ISBN: " + searchTerm, e);
        }
        return books;
    }

    public List<Book> searchBooksByAuthor(String searchTerm) {
        List<Book> books = new ArrayList<>();
        String sql = "SELECT book_id, title, author, isbn, publisher, publication_year, is_available FROM " + DATABASE_NAME + ".books WHERE author LIKE ?";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setString(1, "%" + searchTerm + "%");
            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    books.add(mapResultSetToBook(rs));
                }
            }
        } catch (SQLException e) {
            logger.log(Level.SEVERE, "Error searching books with author: " + searchTerm, e);
        }
        return books;
    }
}
