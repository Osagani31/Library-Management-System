<%@ page import="model.User" %>
<%
    User user = (User) session.getAttribute("user");
    if (user == null) {
        response.sendRedirect("login.jsp");
        return;
    }
%>
<%@ include file="commonAdminHeader.jsp" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="model.Reservation, java.util.List, model.User, model.Book, dao.BookDAO, dao.UserDAO" %>
<%@ page import="model.Reservation.Status" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>My Reservations</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.0/font/bootstrap-icons.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" rel="stylesheet">
    <style>
        body {
            background-color: #f8f9fa;
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            padding-top: 70px;
        }
        
        .navbar {
            background-color: #1b5e20;
            box-shadow: 0 2px 10px rgba(0, 0, 0, 0.1);
            padding: 10px 0;
            position: fixed;
            top: 0;
            width: 100%;
            z-index: 1000;
        }
        
        .navbar-brand {
            font-weight: 600;
            font-size: 1.5rem;
            color: white;
        }
        
        .navbar-brand:hover {
            color: #8bc34a;
        }
        
        .nav-link {
            color: rgba(255, 255, 255, 0.85);
            font-weight: 500;
            margin: 0 8px;
            padding: 8px 12px;
            border-radius: 4px;
            transition: all 0.3s;
        }
        
        .nav-link:hover, .nav-link.active {
            color: white;
            background-color: rgba(255, 255, 255, 0.1);
        }
        
        .nav-link i {
            margin-right: 6px;
        }
        
        .user-dropdown .dropdown-toggle {
            color: white;
            display: flex;
            align-items: center;
        }
        
        .library-header {
            background-color: #1b5e20;
            color: white;
            padding: 30px 0;
            margin-bottom: 40px;
            box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1);
        }
        
        .library-header h1 {
            font-weight: 600;
            letter-spacing: 0.5px;
        }
        .reservation-container {
            background-color: white;
            border-radius: 10px;
            box-shadow: 0 4px 8px rgba(0, 0, 0, 0.1);
            padding: 30px;
            margin-bottom: 40px;
        }
        .btn-primary {
            background-color: #4e73df;
            border-color: #4e73df;
        }
        .btn-primary:hover {
            background-color: #3a5bd9;
            border-color: #3a5bd9;
        }
        .status-pending {
            color: #f0ad4e;
        }
        .status-active {
            color: #5cb85c;
        }
        .status-cancelled {
            color: #d9534f;
        }
        .status-completed {
            color: #0275d8;
        }
        .no-reservations {
            text-align: center;
            padding: 40px 0;
        }
    </style>
</head>
<body>
    <%
        // Initialize DAOs for additional information
        BookDAO bookDAO = new BookDAO();
        UserDAO userDAO = new UserDAO();
        // Get the list of reservations from request attribute (may be null for search results)
        List<Reservation> reservations = (List<Reservation>) request.getAttribute("reservations");
        List<Book> bookList = (List<Book>) request.getAttribute("bookList");
        boolean isAdmin = user.isAdmin();
    %>
    
    <!-- Top Navigation Bar -->
    <nav class="navbar navbar-expand-lg">
        <div class="container">
            <a class="navbar-brand" href="dashboard.jsp">
                <i class="fas fa-book-open me-2"></i>Library System
            </a>
            <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#navbarNav">
                <span class="navbar-toggler-icon"></span>
            </button>
            <div class="collapse navbar-collapse" id="navbarNav">
                <ul class="navbar-nav me-auto">
                    <li class="nav-item">
                        <a class="nav-link" href="dashboard.jsp">
                            <i class="fas fa-tachometer-alt"></i>Dashboard
                        </a>
                    </li>
                    
                    <% if (user.isAdmin()) { %>
                        <li class="nav-item">
                            <a class="nav-link" href="searchBook.jsp">
                                <i class="fas fa-book"></i>Manage Books
                            </a>
                        </li>
                        <li class="nav-item">
                            <a class="nav-link active" href="reservation?action=list">
                                <i class="fas fa-list-alt"></i>View Reservations
                            </a>
                        </li>
                        <li class="nav-item">
                            <a class="nav-link" href="user?action=list">
                                <i class="fas fa-users"></i>Manage Users
                            </a>
                        </li>
                    <% } else { %>
                        <li class="nav-item">
                            <a class="nav-link" href="searchBook.jsp">
                                <i class="fas fa-book"></i>Search Books
                            </a>
                        </li>
                        <li class="nav-item">
                            <a class="nav-link active" href="reservation?action=user&userId=<%= user.getUserId() %>">
                                <i class="fas fa-list"></i>My Reservations
                            </a>
                        </li>
                    <% } %>
                </ul>
                
                <div class="dropdown user-dropdown">
                    <a class="dropdown-toggle d-flex align-items-center text-decoration-none" href="#" role="button" data-bs-toggle="dropdown">
                        <i class="fas fa-user-circle me-2"></i>
                        <span><%= user.getUsername() %> (<%= user.getRole() %>)</span>
                    </a>
                    <ul class="dropdown-menu dropdown-menu-end">
                        <li><a class="dropdown-item" href="#"><i class="fas fa-user me-2"></i>Profile</a></li>
                        <% if (user.isAdmin()) { %>
                            <li><a class="dropdown-item" href="user?action=list"><i class="fas fa-users me-2"></i>Manage Users</a></li>
                        <% } %>
                        <li><hr class="dropdown-divider"></li>
                        <li><a class="dropdown-item text-danger" href="logout.jsp"><i class="fas fa-sign-out-alt me-2"></i>Logout</a></li>
                    </ul>
                </div>
            </div>
        </div>
    </nav>

    <div class="library-header text-center">
        <h1><i class="bi bi-book"></i> Library Book Reservation System</h1>
    </div>

    <div class="container">
        <div class="reservation-container">
            <div class="d-flex justify-content-between align-items-center mb-4">
                <h2><i class="bi bi-bookmark"></i> <%= isAdmin ? "All Reservations" : "My Reservations" %></h2>
                <a href="dashboard.jsp" class="btn btn-outline-secondary">
                    <i class="bi bi-arrow-left"></i> Back to Dashboard
                </a>
            </div>
            
            <% if (bookList != null) { %>
                <div class="table-responsive">
                    <table class="table table-hover">
                        <thead class="table-light">
                            <tr>
                                <th>ID</th>
                                <th>Book Title</th>
                                <th>Author</th>
                                <th>ISBN</th>
                                <th>Status</th>
                            </tr>
                        </thead>
                        <tbody>
                            <% for (Book book : bookList) { %>
                            <tr>
                                <td><%= book.getBookId() %></td>
                                <td><%= book.getTitle() %></td>
                                <td><%= book.getAuthor() %></td>
                                <td><%= book.getIsbn() %></td>
                                <td><span class="badge <%= book.isAvailable() ? "bg-success" : "bg-danger" %>"><%= book.isAvailable() ? "Available" : "Reserved" %></span></td>
                            </tr>
                            <% } %>
                        </tbody>
                    </table>
                </div>
            <% } else if (reservations == null || reservations.isEmpty()) { %>
                <div class="no-reservations">
                    <i class="bi bi-inbox-fill fs-1 text-muted"></i>
                    <h3 class="mt-3">No Reservations Found</h3>
                    <p class="text-muted">You don't have any active reservations at the moment.</p>
                    <a href="searchBook.jsp" class="btn btn-primary mt-3">Browse Books</a>
                </div>
            <% } else { %>
                <div class="table-responsive">
                    <table class="table table-hover">
                        <thead class="table-light">
                            <tr>
                                <th>ID</th>
                                <th>Book Title</th>
                                <% if (isAdmin) { %><th>User</th><% } %>
                                <th>Reservation Date</th>
                                <th>Expiry Date</th>
                                <th>Status</th>
                                <th>Actions</th>
                            </tr>
                        </thead>
                        <tbody>
                            <% for (Reservation reservation : reservations) { 
                                // Get book details
                                Book book = bookDAO.getBookById(reservation.getBookId());
                                
                                // Get user details if admin view
                                user = null;
                                if (isAdmin) {
                                    user = userDAO.getUserById(reservation.getUserId());
                                }
                                
                                // Determine status CSS class
                                String statusClass = "";
                                switch(reservation.getStatus()) {
                                    case Pending: statusClass = "status-pending"; break;
                                    case Active: statusClass = "status-active"; break;
                                    case Cancelled: statusClass = "status-cancelled"; break;
                                    case Completed: statusClass = "status-completed"; break;
                                }
                            %>
                            <tr>
                                <td><%= reservation.getReservationId() %></td>
                                <td><%= book != null ? book.getTitle() : "Unknown Book" %></td>
                                <% if (isAdmin) { %>
                                    <td><%= user != null ? user.getUsername() : (reservation.getUserName() != null ? reservation.getUserName() : "Unknown User") %></td>
                                <% } %>
                                <td><%= reservation.getReservationDate() %></td>
                                <td><%= reservation.getExpiryDate() %></td>
                                <td>
                                    <span class="<%= statusClass %>">
                                        <i class="bi bi-circle-fill me-1"></i>
                                        <%= reservation.getStatus() %>
                                    </span>
                                </td>
                                <td>
                                    <% if (reservation.isActive() && reservation.getStatus() != Status.Cancelled) { %>
                                        <a href="reservation?action=cancel&reservationId=<%= reservation.getReservationId() %>&bookId=<%= reservation.getBookId() %>" 
                                           class="btn btn-sm btn-danger">
                                            <i class="bi bi-x-circle"></i> Cancel
                                        </a>
                                    <% } %>
                                    
                                    <% if (isAdmin && reservation.getStatus() == Status.Pending) { %>
                                        <a href="reservation?action=approve&reservationId=<%= reservation.getReservationId() %>" 
                                           class="btn btn-sm btn-success ms-1">
                                            <i class="bi bi-check-circle"></i> Approve
                                        </a>
                                    <% } %>
                                </td>
                            </tr>
                            <% } %>
                        </tbody>
                    </table>
                </div>
            <% } %>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
