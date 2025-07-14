<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="model.User" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Library Book Search</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
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
            background-color: var(--primary-dark);
            color: white;
            padding: 30px 0;
            margin-bottom: 40px;
            box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1);
            position: relative;
        }
        
        .library-header h1 {
            font-weight: 600;
            letter-spacing: 0.5px;
        }
        
        .search-container {
            background-color: white;
            border-radius: 10px;
            box-shadow: var(--card-shadow);
            padding: 40px;
            max-width: 600px;
            margin: 0 auto;
            border-top: 4px solid var(--accent-color);
            position: relative;
        }
        
        .search-title {
            color: var(--primary-dark);
            font-weight: 600;
            margin-bottom: 30px;
            position: relative;
            padding-bottom: 10px;
        }
        
        .search-title:after {
            content: '';
            position: absolute;
            bottom: 0;
            left: 50%;
            transform: translateX(-50%);
            width: 80px;
            height: 3px;
            background-color: var(--accent-color);
        }
        
        .form-label {
            font-weight: 500;
            color: var(--primary-dark);
        }
        
        .form-control {
            padding: 12px 15px;
            border-radius: 6px;
            border: 1px solid #ddd;
            transition: all 0.3s;
        }
        
        .form-control:focus {
            border-color: var(--accent-color);
            box-shadow: 0 0 0 0.25rem rgba(139, 195, 74, 0.25);
        }
        
        .btn-primary {
            background-color: var(--primary-color);
            border-color: var(--primary-color);
            padding: 12px 24px;
            font-weight: 500;
            letter-spacing: 0.5px;
            border-radius: 6px;
            transition: all 0.3s;
        }
        
        .btn-primary:hover {
            background-color: var(--primary-dark);
            border-color: var(--primary-dark);
            transform: translateY(-2px);
        }
        
        .btn-primary:active {
            transform: translateY(0);
        }
        
        .search-icon {
            margin-right: 8px;
        }
        
        .feature-highlights {
            margin-top: 50px;
            text-align: center;
        }
        
        .feature-card {
            background: white;
            border-radius: 8px;
            padding: 20px;
            margin-bottom: 20px;
            box-shadow: var(--card-shadow);
            transition: all 0.3s;
            border-top: 3px solid var(--accent-color);
        }
        
        .feature-card:hover {
            transform: translateY(-5px);
            box-shadow: 0 10px 20px rgba(0, 0, 0, 0.1);
        }
        
        .feature-icon {
            font-size: 2rem;
            color: var(--primary-color);
            margin-bottom: 15px;
        }
        
        .feature-title {
            color: var(--primary-dark);
            font-weight: 600;
        }
        
        footer {
            background-color: var(--primary-dark);
            color: white;
            padding: 20px 0;
            margin-top: 50px;
            text-align: center;
        }
        
        /* Live search results styling */
        .search-results-container {
            margin-top: 30px;
            background-color: white;
            border-radius: 10px;
            box-shadow: var(--card-shadow);
            padding: 20px;
        }
        
        .search-results-table {
            margin-top: 15px;
        }
        
        .no-results {
            text-align: center;
            padding: 20px;
            color: #666;
            font-style: italic;
        }
        
        .search-options {
            display: flex;
            gap: 15px;
            margin-bottom: 20px;
        }
        
        .search-options .form-select {
            max-width: 150px;
        }
        
        .spinner-border {
            width: 3rem;
            height: 3rem;
        }
        
        /* Live search dropdown styles */
        .live-search-results {
            position: absolute;
            width: 100%;
            max-height: 350px;
            overflow-y: auto;
            background: white;
            border-radius: 0 0 10px 10px;
            box-shadow: 0 5px 15px rgba(0,0,0,0.2);
            z-index: 1000;
            left: 0;
            right: 0;
        }
        
        .list-group-item-action {
            transition: all 0.2s;
        }
        
        .list-group-item-action:hover {
            background-color: #f1f9ee;
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
        boolean isAdmin = user.isAdmin();
        if (!isAdmin) {
            response.sendRedirect("studentSearch.jsp");
            return;
        }
    %>
    <input type="hidden" id="userId" value="${user.userId}">
    
    <!-- Navigation Bar -->
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
                    
                    <% if (isAdmin) { %>
                        <li class="nav-item">
                            <a class="nav-link active" href="searchBook.jsp">
                                <i class="fas fa-book"></i>Manage Books
                            </a>
                        </li>
                        <li class="nav-item">
                            <a class="nav-link" href="reservation?action=list">
                                <i class="fas fa-list-alt"></i>View Reservations
                            </a>
                        </li>
                        <li class="nav-item">
                            <a class="nav-link" href="manageUsers">
                                <i class="fas fa-users"></i>Manage Users
                            </a>
                        </li>
                    <% } else { %>
                        <li class="nav-item">
                            <a class="nav-link active" href="searchBook.jsp">
                                <i class="fas fa-book"></i>Search Books
                            </a>
                        </li>
                        <li class="nav-item">
                            <a class="nav-link" href="reservation?action=user&userId=${user.userId}">
                                <i class="fas fa-list"></i>My Reservations
                            </a>
                        </li>
                    <% } %>
                </ul>
                
                <div class="dropdown user-dropdown">
                    <a class="dropdown-toggle d-flex align-items-center text-decoration-none" href="#" role="button" data-bs-toggle="dropdown">
                        <i class="fas fa-user-circle me-2"></i>
                        <span>${user.username} (${user.role})</span>
                    </a>
                    <ul class="dropdown-menu dropdown-menu-end">
                        <li><a class="dropdown-item" href="#"><i class="fas fa-user me-2"></i>Profile</a></li>
                        <c:if test="${user.role == 'Admin'}">
                            <li><a class="dropdown-item" href="user?action=list"><i class="fas fa-users me-2"></i>Manage Users</a></li>
                        </c:if>
                        <li><hr class="dropdown-divider"></li>
                        <li><a class="dropdown-item text-danger" href="logout.jsp"><i class="fas fa-sign-out-alt me-2"></i>Logout</a></li>
                    </ul>
                </div>
            </div>
        </div>
    </nav>
    
    <header class="library-header text-center">
        <div class="container">
            <h1><i class="fas fa-book-open me-2"></i> Library Book Reservation System</h1>
            <p class="lead mt-2">Find and reserve your favorite books with ease</p>
        </div>
    </header>
   
    <div class="container">
        <div class="search-container">
            <h2 class="text-center search-title">Search for Books</h2>
            <% if (isAdmin) { %>
            <div class="search-options">
                <div class="flex-grow-1 position-relative">
                    <label for="liveSearchInput" class="form-label">Book Search</label>
                    <input type="text" class="form-control" id="liveSearchInput" 
                           placeholder="Enter book title, author, or keywords" 
                           autocomplete="off">
                    <div class="form-text">Start typing to see live search results</div>
                    <div id="liveSearchResults" class="live-search-results" style="display: none;"></div>
                </div>
                <div>
                    <label for="searchType" class="form-label">Search By</label>
                    <select id="searchType" class="form-select">
                        <option value="both">All</option>
                        <option value="title">Title Only</option>
                        <option value="author">Author Only</option>
                    </select>
                </div>
            </div>
            <% } else { %>
            <form action="book" method="get">
                <input type="hidden" name="action" value="search">
                <div class="mb-3">
                    <label for="studentSearchInput" class="form-label">Book Search</label>
                    <input type="text" class="form-control" id="studentSearchInput" name="searchTerm" placeholder="Enter book title, author, or keywords" required>
                </div>
                <div class="mb-3">
                    <label for="studentSearchType" class="form-label">Search By</label>
                    <select id="studentSearchType" class="form-select" name="searchType">
                        <option value="both">All</option>
                        <option value="title">Title Only</option>
                        <option value="author">Author Only</option>
                    </select>
                </div>
                <button type="submit" class="btn btn-primary w-100"><i class="fas fa-search"></i> Search</button>
            </form>
            <% } %>
        </div>
        
        <!-- Search Results Container -->
        <div class="search-results-container">
            <h3>Search Results</h3>
            <div id="searchResults">
                <div class="text-center text-muted py-5">
                    <i class="fas fa-search fa-3x mb-3"></i>
                    <p>Start typing in the search box above to see results</p>
                </div>
            </div>
        </div>
        
        <div class="feature-highlights">
            <div class="row">
                <div class="col-md-4">
                    <div class="feature-card">
                        <div class="feature-icon">
                            <i class="fas fa-book"></i>
                        </div>
                        <h4 class="feature-title">Extensive Collection</h4>
                        <p>Access thousands of books across various genres and subjects</p>
                    </div>
                </div>
                <div class="col-md-4">
                    <div class="feature-card">
                        <div class="feature-icon">
                            <i class="fas fa-clock"></i>
                        </div>
                        <h4 class="feature-title">Easy Reservations</h4>
                        <p>Quickly reserve books online and pick them up at your convenience</p>
                    </div>
                </div>
                <div class="col-md-4">
                    <div class="feature-card">
                        <div class="feature-icon">
                            <i class="fas fa-user-shield"></i>
                        </div>
                        <h4 class="feature-title">Personal Dashboard</h4>
                        <p>Track your reservations and borrowing history in one place</p>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <footer>
        <div class="container">
            <p class="mb-0">&copy; 2025 Library System. All rights reserved.</p>
        </div>
    </footer>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    <script src="js/reservationUtils.js"></script>
    <script src="js/searchPage.js"></script>
</body>
</html>
