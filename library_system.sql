-- Library Management System Database Schema
-- Database: library_db
-- Created for Java Servlet/JSP Library Management System

-- Create the database
CREATE DATABASE  library_db;
USE library_db;

-- Users table to store user information
CREATE TABLE IF NOT EXISTS users (
    user_id INT AUTO_INCREMENT PRIMARY KEY,
    username VARCHAR(50) UNIQUE NOT NULL,
    password_hash VARCHAR(255) NOT NULL,
    role ENUM('Admin', 'Student') NOT NULL DEFAULT 'Student',
    full_name VARCHAR(100) NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    INDEX idx_username (username),
    INDEX idx_email (email),
    INDEX idx_role (role)
);

-- Books table to store book information
CREATE TABLE IF NOT EXISTS books (
    book_id INT AUTO_INCREMENT PRIMARY KEY,
    title VARCHAR(255) NOT NULL,
    author VARCHAR(255) NOT NULL,
    isbn VARCHAR(20) UNIQUE NOT NULL,
    publisher VARCHAR(255),
    publication_year INT,
    is_available BOOLEAN DEFAULT TRUE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    INDEX idx_title (title),
    INDEX idx_author (author),
    INDEX idx_isbn (isbn),
    INDEX idx_available (is_available),
    INDEX idx_publisher (publisher)
);

-- Reservations table to store book reservations
CREATE TABLE IF NOT EXISTS reservations (
    reservation_id INT AUTO_INCREMENT PRIMARY KEY,
    book_id INT NOT NULL,
    user_id INT NOT NULL,
    reservation_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    expiry_date TIMESTAMP,
    is_active BOOLEAN DEFAULT TRUE,
    status ENUM('Active', 'Completed', 'Cancelled', 'Expired') DEFAULT 'Active',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (book_id) REFERENCES books(book_id) ON DELETE CASCADE,
    FOREIGN KEY (user_id) REFERENCES users(user_id) ON DELETE CASCADE,
    INDEX idx_book_id (book_id),
    INDEX idx_user_id (user_id),
    INDEX idx_status (status),
    INDEX idx_active (is_active),
    INDEX idx_reservation_date (reservation_date),
    UNIQUE KEY unique_active_reservation (book_id, user_id, status)
);

-- Insert sample admin user (password: admin123)
INSERT INTO users (username, password_hash, role, full_name, email) VALUES 
('admin', '$2a$10$N.zmdr9k7uOCQb376NoUnuTJ8iAt6Z5EHsM8lE9lBOsl7iKTVEFDa', 'Admin', 'System Administrator', 'admin@library.com');

-- Insert sample student users (password: student123)
INSERT INTO users (username, password_hash, role, full_name, email) VALUES 
('student1', '$2a$10$8K1p/a0dL1LXMIgoEDFrwOfgqwAGm0C8C9V3T3H3H3H3H3H3H3H3H', 'Student', 'John Doe', 'john.doe@student.com'),
('student2', '$2a$10$8K1p/a0dL1LXMIgoEDFrwOfgqwAGm0C8C9V3T3H3H3H3H3H3H3H3H', 'Student', 'Jane Smith', 'jane.smith@student.com');

-- Insert sample books
INSERT INTO books (title, author, isbn, publisher, publication_year, is_available) VALUES 
('The Great Gatsby', 'F. Scott Fitzgerald', '978-0743273565', 'Scribner', 1925, TRUE),
('To Kill a Mockingbird', 'Harper Lee', '978-0446310789', 'Grand Central Publishing', 1960, TRUE),
('1984', 'George Orwell', '978-0451524935', 'Signet Classic', 1949, TRUE),
('Pride and Prejudice', 'Jane Austen', '978-0141439518', 'Penguin Classics', 1813, TRUE),
('The Catcher in the Rye', 'J.D. Salinger', '978-0316769488', 'Little, Brown and Company', 1951, TRUE),
('Lord of the Flies', 'William Golding', '978-0399501487', 'Penguin Books', 1954, TRUE),
('Animal Farm', 'George Orwell', '978-0451526342', 'Signet', 1945, TRUE),
('The Hobbit', 'J.R.R. Tolkien', '978-0547928241', 'Houghton Mifflin Harcourt', 1937, TRUE),
('Brave New World', 'Aldous Huxley', '978-0060850524', 'Harper Perennial', 1932, TRUE),
('Fahrenheit 451', 'Ray Bradbury', '978-1451673319', 'Simon & Schuster', 1953, TRUE);

-- Insert sample reservations
INSERT INTO reservations (book_id, user_id, reservation_date, expiry_date, is_active, status) VALUES 
(1, 2, NOW(), DATE_ADD(NOW(), INTERVAL 14 DAY), TRUE, 'Active'),
(3, 3, NOW(), DATE_ADD(NOW(), INTERVAL 14 DAY), TRUE, 'Active');


  
    



