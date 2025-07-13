<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ page import="model.User" %>
<%@ page import="dao.BookDAO" %>
<%@ page import="model.Book" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Reserve Book | Library System</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.0/font/bootstrap-icons.css">
    <style>
        :root {
            --primary-color: #2e7d32;
            --primary-light: #4caf50;
            --primary-dark: #1b5e20;
            --secondary-color: #f8f9fa;
            --success-color: #28a745;
            --danger-color: #dc3545;
            --warning-color: #ffc107;
            --card-shadow: 0 4px 12px rgba(0, 0, 0, 0.1);
            --transition: all 0.3s ease;
        }
        
        body {
            background-color: var(--secondary-color);
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            padding-top: 20px;
        }
        
        .library-header {
            background-color: var(--primary-dark);
            color: white;
            padding: 2rem 0;
            margin-bottom: 2rem;
            box-shadow: 0 2px 4px rgba(0,0,0,0.1);
            border-radius: 0 0 10px 10px;
        }
        
        .reserve-container {
            max-width: 800px;
            margin: 0 auto;
        }
        
        .reserve-card {
            background: white;
            border-radius: 10px;
            box-shadow: var(--card-shadow);
            padding: 2rem;
            border-top: 5px solid var(--primary-color);
            transition: var(--transition);
        }
        
        .reserve-card:hover {
            box-shadow: 0 6px 16px rgba(0, 0, 0, 0.15);
        }
        
        .book-info {
            background-color: #f8f9fa;
            border-radius: 8px;
            padding: 1.5rem;
            margin-bottom: 1.5rem;
            border-left: 4px solid var(--primary-color);
        }
        
        .book-meta {
            display: flex;
            flex-wrap: wrap;
            gap: 1rem;
            margin-top: 1rem;
        }
        
        .book-meta-item {
            display: flex;
            align-items: center;
            gap: 0.5rem;
            font-size: 0.9rem;
            color: #6c757d;
        }
        
        .required-field::after {
            content: " *";
            color: var(--danger-color);
        }
        
        .form-control:focus {
            border-color: var(--primary-color);
            box-shadow: 0 0 0 0.25rem rgba(46, 125, 50, 0.25);
        }
        
        .btn-primary {
            background-color: var(--primary-color);
            border-color: var(--primary-color);
        }
        
        .btn-primary:hover {
            background-color: var(--primary-dark);
            border-color: var(--primary-dark);
        }
        
        .btn-outline-secondary:hover {
            color: white;
            background-color: var(--primary-color);
            border-color: var(--primary-color);
        }
        
        @media (max-width: 768px) {
            .reserve-card {
                padding: 1.5rem;
            }
            
            .library-header {
                padding: 1.5rem 0;
            }
        }
    </style>
</head>
<body>
    <%
        User currentUser = (User) session.getAttribute("user");
        if (currentUser == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        String bookIdParam = request.getParameter("bookId");
        Book book = null;
        if (bookIdParam != null) {
            try {
                int bookId = Integer.parseInt(bookIdParam);
                BookDAO bookDAO = new BookDAO();
                book = bookDAO.getBookById(bookId);
                request.setAttribute("book", book);
            } catch (Exception e) {
                request.setAttribute("errorMessage", "Invalid book ID");
            }
        }
    %>
    
    <div class="library-header text-center">
        <div class="container">
            <h1 class="display-5"><i class="bi bi-bookmark-plus-fill"></i> Reserve Book</h1>
            <p class="lead mb-0">Complete the form to reserve this book</p>
        </div>
    </div>

    <div class="container reserve-container">
        <div class="reserve-card">
            <c:if test="${not empty errorMessage}">
                <div class="alert alert-danger alert-dismissible fade show" role="alert">
                    <i class="bi bi-exclamation-triangle-fill me-2"></i> ${errorMessage}
                    <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
                </div>
            </c:if>
            
            <div class="book-info">
                <h5 class="mb-3"><i class="bi bi-book me-2"></i>Book Details</h5>
                <c:if test="${not empty book}">
                    <div class="row">
                        <div class="col-md-6">
                            <p class="mb-2"><strong>Title:</strong> ${book.title}</p>
                            <p class="mb-2"><strong>Author:</strong> ${book.author}</p>
                        </div>
                        <div class="col-md-6">
                            <p class="mb-2"><strong>ISBN:</strong> ${book.isbn}</p>
                            <p class="mb-2"><strong>Publisher:</strong> ${book.publisher}</p>
                        </div>
                    </div>
                    
                    <div class="book-meta">
                        <span class="book-meta-item">
                            <i class="bi bi-calendar"></i>
                            <span>Year: ${book.publicationYear}</span>
                        </span>
                        <span class="book-meta-item">
                            <i class="bi ${book.available ? 'bi-check-circle-fill text-success' : 'bi-x-circle-fill text-danger'}"></i>
                            <span>Status: ${book.available ? 'Available' : 'Not Available'}</span>
                        </span>
                    </div>
                </c:if>
            </div>
            
            <form id="reservationForm" action="reservation" method="post" class="needs-validation" novalidate>
                <input type="hidden" name="action" value="create" />
                <input type="hidden" name="bookId" value="${book.bookId}" />
                
                <div class="mb-4">
                    <h5 class="mb-3"><i class="bi bi-person-fill me-2"></i>Reservation Details</h5>
                    
                    <div class="mb-3">
                        <label for="userId" class="form-label required-field">User ID</label>
                        <input type="text" class="form-control" id="userId" name="userId" 
                               value="<%= currentUser.getUserId() %>" readonly required>
                        <div class="invalid-feedback">Please provide a valid user ID</div>
                    </div>
                    
                    <div class="mb-3">
                        <label for="fullName" class="form-label required-field">Full Name</label>
                        <input type="text" class="form-control" id="fullName" name="fullName" 
                               value="<%= currentUser.getFullName() %>" readonly required>
                        <div class="invalid-feedback">Please provide your full name</div>
                    </div>
                    
                    <div class="mb-3">
                        <label for="email" class="form-label">Email Address</label>
                        <input type="email" class="form-control" id="email" name="email" 
                               value="<%= currentUser.getEmail() != null ? currentUser.getEmail() : "" %>" readonly>
                    </div>
                </div>
                
                <div class="d-grid gap-2 d-md-flex justify-content-md-end mt-4">
                    <a href="searchBook.jsp" class="btn btn-outline-secondary me-md-2">
                        <i class="fas fa-arrow-left me-2"></i>Cancel
                    </a>
                    <button type="submit" class="btn btn-primary" ${book.available ? '' : 'disabled'}>
                        <i class="bi bi-check-circle me-1"></i> Confirm Reservation
                    </button>
                </div>
            </form>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    <script>
        // Form validation
        (function() {
            'use strict';
            
            // Fetch the form we want to apply validation to
            const form = document.getElementById('reservationForm');
            
            form.addEventListener('submit', function(event) {
                if (!form.checkValidity()) {
                    event.preventDefault();
                    event.stopPropagation();
                }
                
                form.classList.add('was-validated');
            }, false);
            
            // Auto-fill current date for reservation
            document.addEventListener('DOMContentLoaded', function() {
                const today = new Date().toISOString().split('T')[0];
                document.getElementById('reservationDate').value = today;
                
                // Calculate expiry date (7 days from now)
                const expiryDate = new Date();
                expiryDate.setDate(expiryDate.getDate() + 7);
                document.getElementById('expiryDate').value = expiryDate.toISOString().split('T')[0];
            });
        })();
    </script>
</body>
</html>
