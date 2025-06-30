package dao;

import model.Reservation;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;
import java.util.logging.Level;
import java.util.logging.Logger;

public class ReservationDAO {
    private static final Logger logger = Logger.getLogger(ReservationDAO.class.getName());

    // Database configuration
    private static final String JDBC_URL = "jdbc:mysql://localhost:3306/library_db";
    private static final String DB_USER = "root";
    private static final String DB_PASSWORD = "";
    private static final String JDBC_DRIVER = "com.mysql.cj.jdbc.Driver";

    // Method to establish a database connection
    private Connection getConnection() throws SQLException {
        try {
            Class.forName(JDBC_DRIVER);
            return DriverManager.getConnection(JDBC_URL, DB_USER, DB_PASSWORD);
        } catch (ClassNotFoundException e) {
            logger.log(Level.SEVERE, "MySQL JDBC Driver not found. Please add the driver to your classpath.", e);
            throw new SQLException("Database driver not found", e);
        }
    }

    // Method to get reservations by user ID with pagination support
    public List<Reservation> getReservationsByUser(int userId, int limit, int offset) {
        List<Reservation> reservations = new ArrayList<>();
        String sql = "SELECT r.reservation_id, r.book_id, r.user_id, r.reservation_date, r.expiry_date, " +
                     "r.is_active, r.status, b.title, b.author " +
                     "FROM reservations r JOIN books b ON r.book_id = b.book_id " +
                     "WHERE r.user_id = ? ORDER BY r.reservation_date DESC LIMIT ? OFFSET ?";
        
        try (Connection conn = getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setInt(1, userId);
            stmt.setInt(2, limit);
            stmt.setInt(3, offset);
            
            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    reservations.add(mapResultSetToReservation(rs));
                }
            }
        } catch (SQLException e) {
            logger.log(Level.SEVERE, "Error getting reservations for user ID: " + userId, e);
        }
        return reservations;
    }

    // Overloaded method for backward compatibility
    public List<Reservation> getReservationsByUser(int userId) {
        return getReservationsByUser(userId, Integer.MAX_VALUE, 0);
    }

    // Method to get all reservations with pagination support
    public List<Reservation> getAllReservations(int limit, int offset) {
        List<Reservation> reservations = new ArrayList<>();
        String sql = "SELECT r.reservation_id, r.book_id, r.user_id, r.reservation_date, r.expiry_date, " +
                     "r.is_active, r.status, b.title, b.author, u.full_name as full_name " +
                     "FROM reservations r " +
                     "JOIN books b ON r.book_id = b.book_id " +
                     "JOIN users u ON r.user_id = u.user_id " +
                     "ORDER BY r.reservation_date DESC LIMIT ? OFFSET ?";
        
        try (Connection conn = getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setInt(1, limit);
            stmt.setInt(2, offset);
            
            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    reservations.add(mapResultSetToReservation(rs));
                }
            }
        } catch (SQLException e) {
            logger.log(Level.SEVERE, "Error getting all reservations", e);
        }
        return reservations;
    }

    // Overloaded method for backward compatibility
    public List<Reservation> getAllReservations() {
        return getAllReservations(Integer.MAX_VALUE, 0);
    }

    // Method to create a reservation
    public boolean createReservation(Reservation reservation) {
        String sql = "INSERT INTO reservations (book_id, user_id, reservation_date, expiry_date, is_active, status) " +
                     "VALUES (?, ?, ?, ?, ?, ?)";
        
        try (Connection conn = getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            
            stmt.setInt(1, reservation.getBookId());
            stmt.setInt(2, reservation.getUserId());
            stmt.setTimestamp(3, reservation.getReservationDate());
            stmt.setTimestamp(4, reservation.getExpiryDate());
            stmt.setBoolean(5, reservation.isActive());
            stmt.setString(6, reservation.getStatus().toString());

            int affectedRows = stmt.executeUpdate();
            
            if (affectedRows == 0) {
                throw new SQLException("Creating reservation failed, no rows affected.");
            }

            try (ResultSet generatedKeys = stmt.getGeneratedKeys()) {
                if (generatedKeys.next()) {
                    reservation.setReservationId(generatedKeys.getInt(1));
                } else {
                    throw new SQLException("Creating reservation failed, no ID obtained.");
                }
            }
            
            return true;
        } catch (SQLException e) {
            logger.log(Level.SEVERE, "Error creating reservation", e);
            return false;
        }
    }

    // Method to cancel a reservation
    public boolean cancelReservation(int reservationId) {
        String sql = "UPDATE reservations SET is_active = FALSE, status = 'Cancelled' WHERE reservation_id = ?";
        
        try (Connection conn = getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setInt(1, reservationId);
            int affectedRows = stmt.executeUpdate();
            return affectedRows > 0;
        } catch (SQLException e) {
            logger.log(Level.SEVERE, "Error canceling reservation ID: " + reservationId, e);
            return false;
        }
    }

    // Method to check if a book is already reserved
    public boolean isBookReserved(int bookId) {
        String sql = "SELECT 1 FROM reservations WHERE book_id = ? AND is_active = TRUE";
        
        try (Connection conn = getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setInt(1, bookId);
            try (ResultSet rs = stmt.executeQuery()) {
                return rs.next();
            }
        } catch (SQLException e) {
            logger.log(Level.SEVERE, "Error checking reservation status for book ID: " + bookId, e);
            return false;
        }
    }

    // Method to map result set to reservation
    private Reservation mapResultSetToReservation(ResultSet rs) throws SQLException {
        Reservation reservation = new Reservation();
        reservation.setReservationId(rs.getInt("reservation_id"));
        reservation.setBookId(rs.getInt("book_id"));
        reservation.setUserId(rs.getInt("user_id"));
        reservation.setReservationDate(rs.getTimestamp("reservation_date"));
        reservation.setExpiryDate(rs.getTimestamp("expiry_date"));
        reservation.setActive(rs.getBoolean("is_active"));
        reservation.setStatus(Reservation.Status.valueOf(rs.getString("status")));
        
        // Additional book information
        reservation.setBookTitle(rs.getString("title"));
        if (columnExists(rs, "author")) {
            reservation.setBookAuthor(rs.getString("author"));
        }
        if (columnExists(rs, "full_name")) {
            reservation.setUserName(rs.getString("full_name"));
        }
        
        return reservation;
    }

    // Helper method to check if column exists in result set
    private boolean columnExists(ResultSet rs, String columnName) {
        try {
            rs.findColumn(columnName);
            return true;
        } catch (SQLException e) {
            return false;
        }
    }

    // Method to get reservation count for a user
    public int getReservationCountByUser(int userId) {
        String sql = "SELECT COUNT(*) FROM reservations WHERE user_id = ?";
        
        try (Connection conn = getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setInt(1, userId);
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt(1);
                }
            }
        } catch (SQLException e) {
            logger.log(Level.SEVERE, "Error getting reservation count for user ID: " + userId, e);
        }
        return 0;
    }

    // Method to get active reservation count for a book
    public int getActiveReservationCountForBook(int bookId) {
        String sql = "SELECT COUNT(*) FROM reservations WHERE book_id = ? AND is_active = TRUE";
        
        try (Connection conn = getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setInt(1, bookId);
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt(1);
                }
            }
        } catch (SQLException e) {
            logger.log(Level.SEVERE, "Error getting active reservation count for book ID: " + bookId, e);
        }
        return 0;
    }

    public boolean hasActiveReservations(int bookId) {
        String sql = "SELECT COUNT(*) FROM reservations WHERE book_id = ? AND is_active = TRUE";
        
        try (Connection conn = getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setInt(1, bookId);
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt(1) > 0;
                }
            }
        } catch (SQLException e) {
            logger.log(Level.SEVERE, "Error checking active reservations for book ID: " + bookId, e);
        }
        return false;
    }

    public boolean hasActiveReservation(int userId, int bookId) {
        String sql = "SELECT COUNT(*) FROM reservations WHERE user_id = ? AND book_id = ? AND is_active = TRUE";
        
        try (Connection conn = getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setInt(1, userId);
            stmt.setInt(2, bookId);
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt(1) > 0;
                }
            }
        } catch (SQLException e) {
            logger.log(Level.SEVERE, "Error checking active reservation for user ID: " + userId + " and book ID: " + bookId, e);
        }
        return false;
    }

    public boolean updateReservationStatus(int reservationId, Reservation.Status status, boolean isActive) {
        String sql = "UPDATE reservations SET status = ?, is_active = ? WHERE reservation_id = ?";
        
        try (Connection conn = getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setString(1, status.toString());
            stmt.setBoolean(2, isActive);
            stmt.setInt(3, reservationId);
            
            int affectedRows = stmt.executeUpdate();
            return affectedRows > 0;
        } catch (SQLException e) {
            logger.log(Level.SEVERE, "Error updating reservation status for ID: " + reservationId, e);
            return false;
        }
    }
    
    // Method to update book availability when a reservation is cancelled
    public boolean updateBookAvailability(int bookId, boolean available) {
        String sql = "UPDATE library_db.books SET is_available = ? WHERE book_id = ?";
        
        try (Connection conn = getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setBoolean(1, available);
            stmt.setInt(2, bookId);
            
            int affectedRows = stmt.executeUpdate();
            return affectedRows > 0;
        } catch (SQLException e) {
            logger.log(Level.SEVERE, "Error updating book availability for ID: " + bookId, e);
            return false;
        }
    }
    
    // Method to get a reservation by ID
    public Reservation getReservationById(int reservationId) {
        String sql = "SELECT r.reservation_id, r.book_id, r.user_id, r.reservation_date, r.expiry_date, " +
                     "r.is_active, r.status, b.title, b.author " +
                     "FROM reservations r JOIN books b ON r.book_id = b.book_id " +
                     "WHERE r.reservation_id = ?";
        
        try (Connection conn = getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setInt(1, reservationId);
            
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    return mapResultSetToReservation(rs);
                }
            }
        } catch (SQLException e) {
            logger.log(Level.SEVERE, "Error getting reservation by ID: " + reservationId, e);
        }
        return null;
    }

    public void updateReservation(Reservation reservation) {
        String sql = "UPDATE reservations SET user_id = ?, book_id = ?, reservation_date = ?, expiry_date = ?, is_active = ?, status = ? WHERE reservation_id = ?";
        try (Connection conn = getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, reservation.getUserId());
            stmt.setInt(2, reservation.getBookId());
            stmt.setTimestamp(3, reservation.getReservationDate());
            stmt.setTimestamp(4, reservation.getExpiryDate());
            stmt.setBoolean(5, reservation.isActive());
            stmt.setString(6, reservation.getStatus().toString());
            stmt.setInt(7, reservation.getReservationId());
            stmt.executeUpdate();
        } catch (SQLException e) {
            logger.log(Level.SEVERE, "Error updating reservation with ID: " + reservation.getReservationId(), e);
        }
    }
}


