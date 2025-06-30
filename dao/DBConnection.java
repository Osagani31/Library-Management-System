package dao;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;
import java.util.logging.Level;
import java.util.logging.Logger;

public class DBConnection {
    private static final Logger logger = Logger.getLogger(DBConnection.class.getName());
    private static final String URL = "jdbc:mysql://localhost:3306/library_db";  // Updated to match your database name
    private static final String USER = "root";
    private static final String PASSWORD = "";
    
    static {
        try {
            // Load MySQL JDBC Driver with explicit timezone setting to avoid warnings
            Class.forName("com.mysql.cj.jdbc.Driver");
        } catch (ClassNotFoundException e) {
            logger.log(Level.SEVERE, "MySQL JDBC Driver not found", e);
            throw new RuntimeException("Failed to load MySQL JDBC driver", e);
        }
    }
    
    /**
     * Establishes a connection to the library_db database
     * @return Connection object
     * @throws SQLException if connection fails
     */
    public static Connection getConnection() throws SQLException {
        try {
            // Added serverTimezone parameter to avoid timezone issues
            String connectionUrl = URL + "?useSSL=false&serverTimezone=UTC";
            Connection conn = DriverManager.getConnection(connectionUrl, USER, PASSWORD);
            logger.log(Level.INFO, "Database connection established successfully");
            return conn;
        } catch (SQLException e) {
            logger.log(Level.SEVERE, "Failed to create database connection to library_db", e);
            throw new SQLException("Failed to connect to library_db database", e);
        }
    }
    
    /**
     * Closes the database connection safely
     * @param conn Connection object to close
     */
    public static void closeConnection(Connection conn) {
        if (conn != null) {
            try {
                if (!conn.isClosed()) {
                    conn.close();
                    logger.log(Level.INFO, "Database connection closed successfully");
                }
            } catch (SQLException e) {
                logger.log(Level.WARNING, "Error closing database connection", e);
            }
        }
    }
    
    /**
     * Tests the database connection
     * @return true if connection is successful, false otherwise
     */
    public static boolean testConnection() {
        Connection conn = null;
        try {
            conn = getConnection();
            return conn != null && !conn.isClosed();
        } catch (SQLException e) {
            logger.log(Level.SEVERE, "Database connection test failed", e);
            return false;
        } finally {
            closeConnection(conn);
        }
    }
}

