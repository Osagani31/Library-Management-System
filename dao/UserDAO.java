package dao;

import model.User;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;
import java.util.logging.Level;
import java.util.logging.Logger;
import controller.PasswordHasher;

public class UserDAO {
    private static final Logger logger = Logger.getLogger(UserDAO.class.getName());

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

    // Method to get all users from the database
    public List<User> getAllUsers() {
        List<User> users = new ArrayList<>();
        String sql = "SELECT user_id, username, role, full_name, email, created_at FROM users ORDER BY username";
        
        try (Connection conn = getConnection();
             Statement stmt = conn.createStatement();
             ResultSet rs = stmt.executeQuery(sql)) {
            
            while (rs.next()) {
                User user = new User();
                user.setUserId(rs.getInt("user_id"));
                user.setUsername(rs.getString("username"));
                user.setRole(User.Role.valueOf(rs.getString("role")));
                user.setFullName(rs.getString("full_name"));
                user.setEmail(rs.getString("email"));
                user.setCreatedAt(rs.getTimestamp("created_at"));
                users.add(user);
            }
        } catch (SQLException e) {
            logger.log(Level.SEVERE, "Error getting all users", e);
        }
        return users;
    }
    
    // Method to get all students (users with Student role)
    public List<User> getAllStudents() {
        List<User> students = new ArrayList<>();
        String sql = "SELECT user_id, username, role, full_name, email, created_at FROM users WHERE role = 'Student' ORDER BY username";
        
        try (Connection conn = getConnection();
             Statement stmt = conn.createStatement();
             ResultSet rs = stmt.executeQuery(sql)) {
            
            while (rs.next()) {
                User user = new User();
                user.setUserId(rs.getInt("user_id"));
                user.setUsername(rs.getString("username"));
                user.setRole(User.Role.valueOf(rs.getString("role")));
                user.setFullName(rs.getString("full_name"));
                user.setEmail(rs.getString("email"));
                user.setCreatedAt(rs.getTimestamp("created_at"));
                students.add(user);
            }
        } catch (SQLException e) {
            logger.log(Level.SEVERE, "Error getting all students", e);
        }
        return students;
    }

    // Method to validate user credentials
    public User validateUser(String username, String password) {
        String sql = "SELECT user_id, username, password_hash, role, full_name, email FROM users WHERE username = ?";
        try (Connection conn = getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, username);
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    String hash = rs.getString("password_hash");
                    if (PasswordHasher.checkPassword(password, hash)) {
                        User user = new User();
                        user.setUserId(rs.getInt("user_id"));
                        user.setUsername(rs.getString("username"));
                        user.setRole(User.Role.valueOf(rs.getString("role")));
                        user.setFullName(rs.getString("full_name"));
                        user.setEmail(rs.getString("email"));
                        return user;
                    }
                }
            }
        } catch (SQLException e) {
            logger.log(Level.SEVERE, "Error validating user", e);
        }
        return null;
    }

    // Method to get user by credentials (alias for validateUser)
    public User getUserByCredentials(String username, String password) {
        return validateUser(username, password);
    }

    // Method to get user by ID
    public User getUserById(int userId) {
        String sql = "SELECT user_id, username, role, full_name, email, created_at " +
                     "FROM users WHERE user_id = ?";
        
        try (Connection conn = getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setInt(1, userId);
            
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    User user = new User();
                    user.setUserId(rs.getInt("user_id"));
                    user.setUsername(rs.getString("username"));
                    user.setRole(User.Role.valueOf(rs.getString("role")));
                    user.setFullName(rs.getString("full_name"));
                    user.setEmail(rs.getString("email"));
                    user.setCreatedAt(rs.getTimestamp("created_at"));
                    return user;
                }
            }
        } catch (SQLException e) {
            logger.log(Level.SEVERE, "Error getting user by ID: " + userId, e);
        }
        return null;
    }

    // Method to create a new user
    public boolean createUser(User user) {
        String sql = "INSERT INTO users (username, password_hash, role, full_name, email) " +
                     "VALUES (?, ?, ?, ?, ?)";
        
        try (Connection conn = getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            
            stmt.setString(1, user.getUsername());
            stmt.setString(2, user.getPasswordHash());
            stmt.setString(3, user.getRole().toString());
            stmt.setString(4, user.getFullName());
            stmt.setString(5, user.getEmail());

            int affectedRows = stmt.executeUpdate();
            
            if (affectedRows == 0) {
                throw new SQLException("Creating user failed, no rows affected.");
            }

            try (ResultSet generatedKeys = stmt.getGeneratedKeys()) {
                if (generatedKeys.next()) {
                    user.setUserId(generatedKeys.getInt(1));
                }
            }
            return true;
        } catch (SQLException e) {
            logger.log(Level.SEVERE, "Error creating user", e);
            return false;
        }
    }

    // Method to check if username exists
    public boolean usernameExists(String username) {
        String sql = "SELECT 1 FROM users WHERE username = ?";
        
        try (Connection conn = getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setString(1, username);
            try (ResultSet rs = stmt.executeQuery()) {
                return rs.next();
            }
        } catch (SQLException e) {
            logger.log(Level.SEVERE, "Error checking username existence: " + username, e);
            return false;
        }
    }

    // Method to check if email exists
    public boolean emailExists(String email) {
        String sql = "SELECT 1 FROM users WHERE email = ?";
        
        try (Connection conn = getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setString(1, email);
            try (ResultSet rs = stmt.executeQuery()) {
                return rs.next();
            }
        } catch (SQLException e) {
            logger.log(Level.SEVERE, "Error checking email existence: " + email, e);
            return false;
        }
    }

    // Method to update user information
    public boolean updateUser(User user) {
        String sql = "UPDATE users SET full_name = ?, email = ? WHERE user_id = ?";
        
        try (Connection conn = getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setString(1, user.getFullName());
            stmt.setString(2, user.getEmail());
            stmt.setInt(3, user.getUserId());

            int affectedRows = stmt.executeUpdate();
            return affectedRows > 0;
        } catch (SQLException e) {
            logger.log(Level.SEVERE, "Error updating user ID: " + user.getUserId(), e);
            return false;
        }
    }

    public void deleteUser(int userId) {
        String sql = "DELETE FROM users WHERE user_id = ?";
        try (Connection conn = getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, userId);
            stmt.executeUpdate();
        } catch (SQLException e) {
            logger.log(Level.SEVERE, "Error deleting user with ID: " + userId, e);
        }
    }

    public void addUser(User user) {
        createUser(user);
    }

   
}
