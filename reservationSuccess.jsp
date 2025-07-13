<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page import="model.User" %>
<%@ page import="model.Book" %>
<%@ page import="dao.BookDAO" %>
<%
    // Set cache control headers to prevent browser caching
    response.setHeader("Cache-Control", "no-store, no-cache, must-revalidate, max-age=0");
    response.setHeader("Pragma", "no-cache");
    response.setHeader("Expires", "0");
%>
<!DOCTYPE html>
<html>
<head>
    <title>Reservation Successful - Library System</title>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" rel="stylesheet">
    <style>
        :root {
            --primary-color: #2e7d32;
            --primary-light: #4caf50;
            --primary-dark: #1b5e20;
            --accent-color: #8bc34a;
            --success-color: #28a745;
            --text-light: #f5f5f5;
            --text-dark: #333;
            --bg-light: #f8f9fa;
            --card-shadow: 0 4px 12px rgba(0, 0, 0, 0.08);
        }
        
        body {
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            background-color: var(--bg-light);
            color: var(--text-dark);
            padding-top: 70px;
            min-height: 100vh;
        }
        
        .library-header {
            background-color: var(--success-color);
            color: white;
            padding: 30px 0;
            margin-bottom: 40px;
            box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1);
        }
        
        .library-header h1 {
            font-weight: 600;
            letter-spacing: 0.5px;
        }
        
        .success-container {
            background-color: white;
            border-radius: 10px;
            box-shadow: var(--card-shadow);
            padding: 40px;
            max-width: 600px;
            margin: 0 auto;
            text-align: center;
            border-top: 5px solid var(--success-color);
        }
        
        .success-icon {
            color: var(--success-color);
            font-size: 5rem;
            margin-bottom: 25px;
            animation: bounce 1s;
        }
        
        .book-details {
            background-color: rgba(40, 167, 69, 0.1);
            border-radius: 8px;
            padding: 20px;
            margin: 25px 0;
            text-align: left;
        }
        
        .detail-row {
            display: flex;
            margin-bottom: 10px;
        }
        
        .detail-label {
            font-weight: 600;
            color: var(--primary-dark);
            min-width: 120px;
        }
        
        .action-buttons {
            display: flex;
            justify-content: center;
            gap: 15px;
            margin-top: 30px;
            flex-wrap: wrap;
        }
        
        .btn-success {
            background-color: var(--primary-color);
            border-color: var(--primary-color);
            padding: 10px 25px;
            font-weight: 500;
        }
        
        .btn-success:hover {
            background-color: var(--primary-dark);
            border-color: var(--primary-dark);
            transform: translateY(-2px);
        }
        
        .btn-outline-primary {
            border-color: var(--primary-color);
            color: var(--primary-color);
            padding: 10px 25px;
            font-weight: 500;
        }
        
        .btn-outline-primary:hover {
            background-color: var(--primary-color);
            border-color: var(--primary-color);
            color: white;
        }
        
        @keyframes bounce {
            0%, 20%, 50%, 80%, 100% {transform: translateY(0);}
            40% {transform: translateY(-20px);}
            60% {transform: translateY(-10px);}
        }
        
        @media (max-width: 576px) {
            .success-container {
                padding: 25px;
            }
            
            .action-buttons {
                flex-direction: column;
                gap: 10px;
            }
            
            .btn-success, .btn-outline-primary {
                width: 100%;
            }
        }
    </style>
</head>
<body>
    <%
        User user = (User) session.getAttribute("user");
        if (user == null) {
            response.sendRedirect("login.jsp");
            return;
        }
        
        // Get book details from request attributes or session
        Book book = (Book) request.getAttribute("book");
        if (book == null) {
            // Try to get it from session if not in request
            book = (Book) session.getAttribute("reservedBook");
            // If still null, try to get bookId from session and fetch book
            if (book == null && session.getAttribute("bookId") != null) {
                int bookId = (int) session.getAttribute("bookId");
                // Import and use BookDAO
                BookDAO bookDAO = new BookDAO();
                book = bookDAO.getBookById(bookId);
                // Store in session for future use
                session.setAttribute("reservedBook", book);
            }
            
            // If still null after all attempts, redirect to book list
            if (book == null) {
                response.sendRedirect("searchBook.jsp");
                return;
            }
        }
    %>
    
    <!-- Top Navigation Bar -->
    <nav class="navbar navbar-expand-lg navbar-dark bg-dark fixed-top">
        <div class="container">
            <a class="navbar-brand" href="dashboard.jsp">
                <i class="fas fa-book-open me-2"></i>Library System
            </a>
            <div class="collapse navbar-collapse" id="navbarNav">
                <ul class="navbar-nav ms-auto">
                    <li class="nav-item">
                        <a class="nav-link" href="dashboard.jsp">
                            <i class="fas fa-tachometer-alt me-1"></i>Dashboard
                        </a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link" href="searchBook.jsp">
                            <i class="fas fa-book"></i>Browse Books
                        </a>
                    </li>
                </ul>
            </div>
        </div>
    </nav>
    
    <!-- Page Header -->
    <header class="library-header text-center">
        <div class="container">
            <h1><i class="fas fa-bookmark me-2"></i> Reservation Successful</h1>
        </div>
    </header>
    
    <!-- Main Content -->
    <main class="container">
        <div class="success-container">
            <div class="success-icon">
                <i class="fas fa-check-circle"></i>
            </div>
            <h2 class="mb-3">Book Reserved Successfully!</h2>
            <p class="lead mb-4">You have successfully reserved the book.</p>
            
            <!-- Book Details Section -->
            <div class="book-details">
                <h5 class="mb-3"><i class="fas fa-info-circle me-2"></i>Book Details</h5>
                <div class="detail-row">
                    <span class="detail-label">Title:</span>
                    <span>${book.title}</span>
                </div>
                <div class="detail-row">
                    <span class="detail-label">Author:</span>
                    <span>${book.author}</span>
                </div>
                <c:if test="${not empty book.isbn}">
                    <div class="detail-row">
                        <span class="detail-label">ISBN:</span>
                        <span>${book.isbn}</span>
                    </div>
                </c:if>
                <c:if test="${book.publicationYear > 0}">
                    <div class="detail-row">
                        <span class="detail-label">Year:</span>
                        <span>${book.publicationYear}</span>
                    </div>
                </c:if>
                <div class="detail-row">
                    <span class="detail-label">Status:</span>
                    <span class="badge bg-success">Reserved</span>
                </div>
            </div>
            
            <!-- Action Buttons -->
            <div class="action-buttons">
                <div class="btn-group">
                    <a href="searchBook.jsp" class="btn btn-success">
                        <i class="fas fa-book me-2"></i>Browse More Books
                    </a>
                </div>
                <a href="reservation?action=user&userId=${user.userId}" class="btn btn-outline-primary">
                    <i class="fas fa-list me-2"></i>My Reservations
                </a>
                <a href="dashboard.jsp" class="btn btn-outline-primary">
                    <i class="fas fa-tachometer-alt me-2"></i>Return to Dashboard
                </a>
            </div>
        </div>
    </main>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    <script src="js/reservationUtils.js"></script>
    <script>
        // Add animation to the success icon
        document.addEventListener('DOMContentLoaded', function() {
            const icon = document.querySelector('.success-icon');
            setTimeout(() => {
                icon.style.animation = 'none';
                setTimeout(() => icon.style.animation = 'bounce 1s', 10);
            }, 1000);
            
            // Notify other tabs about the reservation and update dashboard counts
            if (typeof notifyReservationMade === 'function') {
                notifyReservationMade();
            } else {
                // Fallback if the function isn't available
                localStorage.setItem('bookReserved', 'true');
                localStorage.setItem('bookReservationTime', Date.now().toString());
                localStorage.setItem('bookAvailabilityChanged', 'true');
                localStorage.setItem('availabilityChangeTime', Date.now().toString());
            }
            
            // Update dashboard immediately
            fetch('dashboardCount')
                .then(response => response.json())
                .then(data => {
                    console.log('Dashboard data updated successfully:', data);
                    // Make sure the dashboard will update when the user returns to it
                    localStorage.setItem('bookAvailabilityChanged', 'true');
                    localStorage.setItem('availabilityChangeTime', Date.now().toString());
                })
                .catch(error => console.error('Error updating dashboard counts:', error));
        });
    </script>
</body>
</html> 
