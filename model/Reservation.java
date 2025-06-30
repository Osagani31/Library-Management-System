package model;

import java.sql.Timestamp;

public class Reservation {
    private int reservationId;  
    private int userId;         
    private int bookId;         
    private Timestamp reservationDate;  
    private Timestamp expiryDate;       
    private boolean isActive;          
    private Status status;             
    
    // Additional fields for display purposes (not in database)
    private String bookTitle;
    private String bookAuthor;
    private String userName;

    // Status enum to match database ENUM values
    public enum Status {
        Pending, Active, Completed, Cancelled
    }

    // Constructors
    public Reservation() {}

    public Reservation(int userId, int bookId) {
        this.userId = userId;
        this.bookId = bookId;
        this.reservationDate = new Timestamp(System.currentTimeMillis());
        this.isActive = true;
        this.status = Status.Active;
    }

    // Full constructor
    public Reservation(int reservationId, int userId, int bookId, 
                     Timestamp reservationDate, Timestamp expiryDate,
                     boolean isActive, Status status) {
        this.reservationId = reservationId;
        this.userId = userId;
        this.bookId = bookId;
        this.reservationDate = reservationDate;
        this.expiryDate = expiryDate;
        this.isActive = isActive;
        this.status = status;
    }

    // Getters and Setters
    public int getReservationId() {
        return reservationId;
    }

    public void setReservationId(int reservationId) {
        this.reservationId = reservationId;
    }

    public int getUserId() {
        return userId;
    }

    public void setUserId(int userId) {
        this.userId = userId;
    }

    public int getBookId() {
        return bookId;
    }

    public void setBookId(int bookId) {
        this.bookId = bookId;
    }

    public Timestamp getReservationDate() {
        return reservationDate;
    }

    public void setReservationDate(Timestamp reservationDate) {
        this.reservationDate = reservationDate;
    }

    public Timestamp getExpiryDate() {
        return expiryDate;
    }

    public void setExpiryDate(Timestamp expiryDate) {
        this.expiryDate = expiryDate;
    }

    public boolean isActive() {
        return isActive;
    }

    public void setActive(boolean active) {
        isActive = active;
    }

    public Status getStatus() {
        return status;
    }

    public void setStatus(Status status) {
        this.status = status;
    }

    // Additional display fields (not in database)
    public String getBookTitle() {
        return bookTitle;
    }

    public void setBookTitle(String bookTitle) {
        this.bookTitle = bookTitle;
    }

    public String getBookAuthor() {
        return bookAuthor;
    }

    public void setBookAuthor(String bookAuthor) {
        this.bookAuthor = bookAuthor;
    }

    public String getUserName() {
        return userName;
    }

    public void setUserName(String userName) {
        this.userName = userName;
    }

    @Override
    public String toString() {
        return "Reservation{" +
                "reservationId=" + reservationId +
                ", userId=" + userId +
                ", bookId=" + bookId +
                ", reservationDate=" + reservationDate +
                ", expiryDate=" + expiryDate +
                ", isActive=" + isActive +
                ", status=" + status +
                ", bookTitle='" + bookTitle + '\'' +
                ", bookAuthor='" + bookAuthor + '\'' +
                ", userName='" + userName + '\'' +
                '}';
    }

    // Helper method to check if reservation is expired
    public boolean isExpired() {
        if (expiryDate == null) return false;
        return expiryDate.before(new Timestamp(System.currentTimeMillis()));
    }
}
