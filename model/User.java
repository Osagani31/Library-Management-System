package model;

import java.sql.Timestamp;

public class User {
    private int userId;          
    private String username;     
    private String passwordHash; 
    private Role role;           
    private String fullName;     
    private String email;        
    private Timestamp createdAt; 
    private Timestamp updatedAt; 

    // Role enum to match database ENUM values
    public enum Role {
        Admin, Student
    }

    // Constructors
    public User() {}

    public User(int userId, String username, String passwordHash, Role role, 
               String fullName, String email) {
        this.userId = userId;
        this.username = username;
        this.passwordHash = passwordHash;
        this.role = role;
        this.fullName = fullName;
        this.email = email;
    }

    // Full constructor
    public User(int userId, String username, String passwordHash, Role role,
               String fullName, String email, Timestamp createdAt, Timestamp updatedAt) {
        this(userId, username, passwordHash, role, fullName, email);
        this.createdAt = createdAt;
        this.updatedAt = updatedAt;
    }

    // Getters and Setters
    public int getUserId() {
        return userId;
    }

    public void setUserId(int userId) {
        this.userId = userId;
    }

    public String getUsername() {
        return username;
    }

    public void setUsername(String username) {
        this.username = username;
    }

    public String getPasswordHash() {
        return passwordHash;
    }

    public void setPasswordHash(String passwordHash) {
        this.passwordHash = passwordHash;
    }

    public Role getRole() {
        return role;
    }

    public void setRole(Role role) {
        this.role = role;
    }

    public String getFullName() {
        return fullName;
    }

    public void setFullName(String fullName) {
        this.fullName = fullName;
    }

    public String getEmail() {
        return email;
    }

    public void setEmail(String email) {
        this.email = email;
    }

    public Timestamp getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(Timestamp createdAt) {
        this.createdAt = createdAt;
    }

    public Timestamp getUpdatedAt() {
        return updatedAt;
    }

    public void setUpdatedAt(Timestamp updatedAt) {
        this.updatedAt = updatedAt;
    }

    @Override
    public String toString() {
        return "User{" +
                "userId=" + userId +
                ", username='" + username + '\'' +
                ", role=" + role +
                ", fullName='" + fullName + '\'' +
                ", email='" + email + '\'' +
                ", createdAt=" + createdAt +
                ", updatedAt=" + updatedAt +
                '}';
    }

    // Helper method to check if user is admin
    public boolean isAdmin() {
        return role == Role.Admin;
    }

    // Helper method to check if user is student
    public boolean isStudent() {
        return role == Role.Student;
    }
}
