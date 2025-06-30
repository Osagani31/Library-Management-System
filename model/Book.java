package model;

public class Book {
    private int bookId;
    private String title;
    private String author;
    private String isbn;
    private String publisher;
    private int publicationYear;
    private boolean isAvailable;
    
    // New fields for reservation info
    private Integer reservedById;
    private String reservedByUsername;
    private String reservedByFullName;

    // Constructors
    public Book() {}
    
    public Book(int bookId, String title, String author, String isbn, 
                String publisher, int publicationYear, boolean isAvailable) {
        this.bookId = bookId;
        this.title = title;
        this.author = author;
        this.isbn = isbn;
        this.publisher = publisher;
        this.publicationYear = publicationYear;
        this.isAvailable = isAvailable;
    }

    // Getters and Setters
    public int getBookId() {
        return bookId;
    }

    public void setBookId(int bookId) {
        this.bookId = bookId;
    }

    public String getTitle() {
        return title;
    }

    public void setTitle(String title) {
        this.title = title;
    }

    public String getAuthor() {
        return author;
    }

    public void setAuthor(String author) {
        this.author = author;
    }

    public String getIsbn() {
        return isbn;
    }

    public void setIsbn(String isbn) {
        this.isbn = isbn;
    }

    public String getPublisher() {
        return publisher;
    }

    public void setPublisher(String publisher) {
        this.publisher = publisher;
    }

    public int getPublicationYear() {
        return publicationYear;
    }

    public void setPublicationYear(int publicationYear) {
        this.publicationYear = publicationYear;
    }

    public boolean isAvailable() {
        return isAvailable;
    }

    public void setAvailable(boolean isAvailable) {
        this.isAvailable = isAvailable;
    }

    public int getId() {
        return this.bookId;
    }

    public void setId(int id) {
        this.bookId = id;
    }
    
    // New getters and setters for reservation info
    public Integer getReservedById() {
        return reservedById;
    }
    
    public void setReservedById(Integer reservedById) {
        this.reservedById = reservedById;
    }
    
    public String getReservedByUsername() {
        return reservedByUsername;
    }
    
    public void setReservedByUsername(String reservedByUsername) {
        this.reservedByUsername = reservedByUsername;
    }
    
    public String getReservedByFullName() {
        return reservedByFullName;
    }
    
    public void setReservedByFullName(String reservedByFullName) {
        this.reservedByFullName = reservedByFullName;
    }
    
    public boolean isReserved() {
        return !isAvailable && reservedById != null;
    }
}
