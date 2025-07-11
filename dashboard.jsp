
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page import="model.User" %>
<%@ page import="model.Book" %>
<%@ page import="dao.BookDAO" %>
<%@ page import="dao.ReservationDAO" %>
<%@ page import="dao.UserDAO" %>
<%@ page import="java.util.List" %>
<!DOCTYPE html>
<html>
<head>
    <title>Dashboard - Library System</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" rel="stylesheet">
    <style>
        :root {
            --primary-color: #2e7d32;
            --primary-light: #4caf50;
            --primary-dark: #1b5e20;
            --accent-color: #8bc34a;
            --text-light: #f5f5f5;
            --text-dark: #333;
            --bg-light: #f8f9fa;
            --card-shadow: 0 4px 12px rgba(0, 0, 0, 0.08);
            --transition: all 0.3s ease;
        }
        
        body {
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            background-color: var(--bg-light);
            color: var(--text-dark);
            padding-top: 70px;
        }
        
        .navbar {
            background-color: var(--primary-dark);
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
            transition: var(--transition);
        }
        
        .navbar-brand:hover {
            color: var(--accent-color);
        }
        
        .nav-link {
            color: rgba(255, 255, 255, 0.85);
            font-weight: 500;
            margin: 0 8px;
            padding: 8px 12px;
            border-radius: 4px;
            transition: var(--transition);
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
        
        .user-dropdown .dropdown-menu {
            border: none;
            box-shadow: var(--card-shadow);
            margin-top: 8px;
        }
        
        .user-dropdown .dropdown-item {
            padding: 8px 16px;
            transition: var(--transition);
        }
        
        .user-dropdown .dropdown-item:hover {
            background-color: var(--bg-light);
        }
        
        .library-header {
            background-color: var(--primary-color);
            color: white;
            padding: 30px 0;
            margin-bottom: 30px;
            border-radius: 0 0 10px 10px;
            box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1);
            text-align: center;
        }
        
        .library-header h1 {
            font-weight: 600;
            margin-bottom: 10px;
        }
        
        .library-header .lead {
            opacity: 0.9;
        }
        
        .page-title {
            font-weight: 600;
            color: var(--primary-dark);
            margin-bottom: 30px;
            position: relative;
            padding-bottom: 10px;
        }
        
        .page-title:after {
            content: '';
            position: absolute;
            bottom: 0;
            left: 0;
            width: 60px;
            height: 3px;
            background-color: var(--accent-color);
        }
        
        .dashboard-cards {
            display: grid;
            grid-template-columns: repeat(auto-fill, minmax(280px, 1fr));
            gap: 25px;
            margin-bottom: 40px;
        }
        
        .card {
            background-color: white;
            border: none;
            border-radius: 8px;
            box-shadow: var(--card-shadow);
            transition: var(--transition);
            overflow: hidden;
            height: 100%;
        }
        
        .card:hover {
            transform: translateY(-5px);
            box-shadow: 0 10px 20px rgba(0, 0, 0, 0.1);
        }
        
        .card-header {
            background-color: var(--primary-color);
            color: white;
            padding: 15px 20px;
            border-bottom: none;
            display: flex;
            justify-content: space-between;
            align-items: center;
        }
        
        .card-title {
            font-weight: 500;
            margin: 0;
            font-size: 1.1rem;
        }
        
        .card-icon {
            width: 40px;
            height: 40px;
            border-radius: 50%;
            background-color: rgba(255, 255, 255, 0.2);
            display: flex;
            align-items: center;
            justify-content: center;
        }
        
        .card-body {
            padding: 20px;
        }
        
        .card-value {
            font-size: 2rem;
            font-weight: 600;
            color: var(--primary-dark);
            margin-bottom: 5px;
        }
        
        .card-footer {
            font-size: 0.9rem;
            color: #666;
            padding: 0 20px 20px;
        }
        
        .quick-actions {
            background-color: white;
            border-radius: 8px;
            padding: 25px;
            box-shadow: var(--card-shadow);
            margin-bottom: 30px;
        }
        
        .section-title {
            color: var(--primary-dark);
            font-weight: 600;
            margin-bottom: 20px;
            position: relative;
            padding-bottom: 10px;
        }
        
        .section-title:after {
            content: '';
            position: absolute;
            bottom: 0;
            left: 0;
            width: 40px;
            height: 2px;
            background-color: var(--accent-color);
        }
        
        .action-buttons {
            display: flex;
            flex-wrap: wrap;
            gap: 15px;
        }
        
        .action-btn {
            background-color: var(--primary-color);
            color: white;
            border: none;
            padding: 10px 20px;
            border-radius: 6px;
            font-weight: 500;
            transition: var(--transition);
            text-decoration: none;
            display: inline-flex;
            align-items: center;
        }
        
        .action-btn i {
            margin-right: 8px;
        }
        
        .action-btn:hover {
            background-color: var(--primary-dark);
            color: white;
            transform: translateY(-2px);
        }
        
        .empty-state {
            text-align: center;
            padding: 40px 0;
            color: #757575;
        }
        
        .empty-state i {
            font-size: 3rem;
            color: #e0e0e0;
            margin-bottom: 15px;
        }
        
        @media (max-width: 768px) {
            .dashboard-cards {
                grid-template-columns: 1fr;
            }
            
            .action-buttons {
                flex-direction: column;
            }
            
            .action-btn {
                width: 100%;
                justify-content: center;
            }
        }
        
        @keyframes highlight {
            0% { box-shadow: 0 0 0 0 rgba(76, 175, 80, 0.4); }
            70% { box-shadow: 0 0 0 10px rgba(76, 175, 80, 0); }
            100% { box-shadow: 0 0 0 0 rgba(76, 175, 80, 0); }
        }
        
        .highlight-update {
            animation: highlight 1.5s ease-out;
        }
        
        .card-value {
            transition: all 0.3s ease;
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
        
        BookDAO bookDAO = new BookDAO();
        List<Book> allBooks = bookDAO.getAllBooks();
        int bookCount = allBooks.size();
        
        int availableBookCount = bookDAO.countAvailableBooks();
        
        ReservationDAO reservationDAO = new ReservationDAO();
        int reservationCount = 0;
        int totalReservationCount = reservationDAO.getAllReservations().size();
        
        UserDAO userDAO = new UserDAO();
        int userCount = 0;
        if (user.getRole() == User.Role.Admin) {
            reservationCount = totalReservationCount;
            userCount = userDAO.getAllUsers().size();
        } else {
            reservationCount = reservationDAO.getReservationsByUser(user.getUserId()).size();
        }
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
                        <a class="nav-link active" href="dashboard.jsp">
                            <i class="fas fa-tachometer-alt"></i>Dashboard
                        </a>
                    </li>
                    
                    <c:choose>
                        <c:when test="${user.role == 'Student'}">
                            <li class="nav-item">
                                <a class="nav-link" href="searchBook.jsp">
                                    <i class="fas fa-book"></i>Search Books
                                </a>
                            </li>
                            <li class="nav-item">
                                <a class="nav-link" href="reservation?action=user&userId=${user.userId}">
                                    <i class="fas fa-list"></i>My Reservations
                                </a>
                            </li>
                        </c:when>
                        <c:otherwise>
                            <li class="nav-item">
                                <a class="nav-link" href="searchBook.jsp">
                                    <i class="fas fa-book"></i>Manage Books
                                </a>
                            </li>
                            <li class="nav-item">
                                <a class="nav-link" href="bookForm.jsp">
                                    <i class="fas fa-add"></i>Add New Book
                                </a>
                            </li>
                            <li class="nav-item">
                                <a class="nav-link" href="viewReservations">
                                    <i class="fas fa-list-alt"></i>View Reservations
                                </a>
                            </li>
                            <li class="nav-item">
                                <a class="nav-link" href="reservation?action=user&userId=${user.userId}">
                                    <i class="fas fa-list"></i>My Reservations
                                </a>
                            </li>
                            <li class="nav-item">
                                <a class="nav-link" href="manageUsers">
                                    <i class="fas fa-users"></i>Manage Users
                                </a>
                            </li>
                        </c:otherwise>
                    </c:choose>
                </ul>
                
                <div class="dropdown user-dropdown">
                    <a class="dropdown-toggle d-flex align-items-center text-decoration-none" href="#" role="button" data-bs-toggle="dropdown">
                        <i class="fas fa-user-circle me-2"></i>
                        <span>${user.username} (${user.role})</span>
                    </a>
                    <ul class="dropdown-menu dropdown-menu-end">
                        <li><a class="dropdown-item" href="#"><i class="fas fa-user me-2"></i>Profile</a></li>
                        <c:if test="${user.role == 'Admin'}">
                            <li><a class="dropdown-item" href="manageUsers"><i class="fas fa-users me-2"></i>Manage Users</a></li>
                        </c:if>
                        <li><hr class="dropdown-divider"></li>
                        <li><a class="dropdown-item text-danger" href="logout.jsp"><i class="fas fa-sign-out-alt me-2"></i>Logout</a></li>
                    </ul>
                </div>
            </div>
        </div>
    </nav>
    
    <!-- Page Header -->
    <header class="library-header">
        <div class="container">
            <h1><i class="fas fa-tachometer-alt me-2"></i> Dashboard</h1>
            <p class="lead mb-0">Welcome back, ${user.fullName}!</p>
        </div>
    </header>
    
    <!-- Main Content -->
    <main class="container">
        <h2 class="page-title">Library Overview</h2>
        
        <div class="dashboard-cards">
            <!-- Total Books Card -->
            <a href="AllBooks.jsp" class="card text-decoration-none">
                <div class="card-header">
                    <h3 class="card-title">Total Books</h3>
                    <div class="card-icon">
                        <i class="fas fa-list"></i>
                    </div>
                </div>
                <div class="card-body">
                    <div class="card-value"><%= bookCount %></div>
                </div>
                <div class="card-footer">Available in library</div>
            </a>
            
            <!-- Available Books Card -->
            <a href="AvailableBooks.jsp" class="card text-decoration-none">
                <div class="card-header">
                    <h3 class="card-title">Available Books</h3>
                    <div class="card-icon">
                        <i class="fas fa-check-circle"></i>
                    </div>
                </div>
                <div class="card-body">
                    <div class="card-value"><%= availableBookCount %></div>
                </div>
                <div class="card-footer">Ready for reservation</div>
            </a>
            
            <!-- Role-specific Card -->
            <c:choose>
                <c:when test="${user.role == 'Student'}">
                    <a href="reservation?action=user&userId=${user.userId}" class="card text-decoration-none">
                        <div class="card-header">
                            <h3 class="card-title">My Reservations</h3>
                            <div class="card-icon">
                                <i class="fas fa-bookmark"></i>
                            </div>
                        </div>
                        <div class="card-body">
                            <div class="card-value"><%= reservationCount %></div>
                        </div>
                        <div class="card-footer">My active reservations</div>
                    </a>
                </c:when>
                <c:otherwise>
                    <a href="reservation?action=list" class="card text-decoration-none">
                        <div class="card-header">
                            <h3 class="card-title">Total Reservations up to now</h3>
                            <div class="card-icon">
                                <i class="fas fa-list-alt"></i>
                            </div>
                        </div>
                        <div class="card-body">
                            <div class="card-value"><%= reservationCount %></div>
                        </div>
                        <div class="card-footer">All reservations</div>
                    </a>
                    
                    <a href="manageUsers" class="card text-decoration-none">
                        <div class="card-header">
                            <h3 class="card-title">Total Users</h3>
                            <div class="card-icon">
                                <i class="fas fa-users"></i>
                            </div>
                        </div>
                        <div class="card-body">
                            <div class="card-value"><%= userCount %></div>
                        </div>
                        <div class="card-footer">Registered users</div>
                    </a>
                </c:otherwise>
            </c:choose>
            
            <!-- Total Reservations Card for Students -->
            <c:if test="${user.role == 'Student'}">
                <a href="reservation?action=list" class="card text-decoration-none">
                    <div class="card-header">
                        <h3 class="card-title">Total Reservations up to now</h3>
                        <div class="card-icon">
                            <i class="fas fa-list-alt"></i>
                        </div>
                    </div>
                    <div class="card-body">
                        <div class="card-value"><%= totalReservationCount %></div>
                    </div>
                    <div class="card-footer">All library reservations</div>
                </a>
            </c:if>
        </div>
        
        <div class="quick-actions">
            <h3 class="section-title">Quick Actions</h3>
            <div class="action-buttons">
                <c:choose>
                    <c:when test="${user.role == 'Student'}">
                        <a href="searchBook.jsp" class="action-btn">
                            <i class="fas fa-book"></i> Search Books
                        </a>
                        <a href="reservation?action=user&userId=${user.userId}" class="action-btn">
                            <i class="fas fa-eye"></i> View My Reservations
                        </a>
                        <a href="reservation?action=list" class="action-btn">
                            <i class="fas fa-list"></i> View All Reservations
                        </a>
                    </c:when>
                    <c:otherwise>
                        <% if (user != null && !user.isAdmin()) { %>
                            <a href="studentSearch.jsp" class="action-btn">
                                <i class="fas fa-search"></i> Search Books
                            </a>
                        <% } else if (user != null && user.isAdmin()) { %>
                            <a href="searchBook.jsp" class="action-btn">
                                <i class="fas fa-search"></i> Manage Books
                            </a>
                        <% } %>
                        <a href="bookForm.jsp" class="action-btn">
                            <i class="fas fa-add"></i> Add New Book
                        </a>
                        <a href="reservation?action=list" class="action-btn">
                            <i class="fas fa-list"></i> View All Reservations
                        </a>
                        <a href="reservation?action=user&userId=${user.userId}" class="action-btn">
                            <i class="fas fa-eye"></i> My Reservations
                        </a>
                        <a href="manageUsers" class="action-btn">
                            <i class="fas fa-users"></i> Manage Users
                        </a>
                    </c:otherwise>
                </c:choose>
            </div>
        </div>
    </main>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    <script src="js/reservationUtils.js"></script>
    <script>
        // Enable Bootstrap tooltips
        document.addEventListener('DOMContentLoaded', function() {
            var tooltipTriggerList = [].slice.call(document.querySelectorAll('[data-bs-toggle="tooltip"]'));
            var tooltipList = tooltipTriggerList.map(function (tooltipTriggerEl) {
                return new bootstrap.Tooltip(tooltipTriggerEl);
            });
            
            // Check if book availability has changed (from reservations or cancellations)
            const availabilityChanged = localStorage.getItem('bookAvailabilityChanged') === 'true';
            const changeTime = localStorage.getItem('availabilityChangeTime');
            
            if (availabilityChanged && changeTime && (Date.now() - parseInt(changeTime)) < 30000) {
                console.log('Book availability changes detected, updating dashboard...');
                
                // Clear flags so we don't refresh again
                localStorage.setItem('bookAvailabilityChanged', 'false');
                
                // Update the dashboard cards without a full page refresh
                updateDashboardCounts();
            }
            
            // Always check for updated counts when the dashboard loads
            // This ensures fresh data even when returning from other pages
            updateDashboardCounts();
        });
    </script>
</body>
</html>
