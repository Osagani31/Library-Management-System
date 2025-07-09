<%@ page import="model.User" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
    <title>Add Book - Library System</title>
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
            --text-light: #f5f5f5;
            --text-dark: #333;
            --bg-light: #f8f9fa;
            --card-shadow: 0 4px 12px rgba(0, 0, 0, 0.08);
            --error-color: #d32f2f;
            --warning-color: #ff9800;
        }
        
        body {
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            background-color: var(--bg-light);
            color: var(--text-dark);
            padding-top: 70px;
            min-height: 100vh;
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
        }
        
        .user-dropdown .dropdown-menu {
            border: none;
            box-shadow: var(--card-shadow);
        }
        
        .library-header {
            background-color: var(--primary-color);
            color: white;
            padding: 30px 0;
            margin-bottom: 30px;
            border-radius: 0 0 10px 10px;
            box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1);
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
        
        .content-card {
            background-color: white;
            border-radius: 8px;
            padding: 30px;
            box-shadow: var(--card-shadow);
            max-width: 800px;
            margin: 0 auto;
            border-top: 4px solid var(--accent-color);
        }
        
        .card-title {
            font-size: 1.3rem;
            font-weight: 600;
            color: var(--primary-dark);
            margin-bottom: 20px;
            text-align: center;
        }
        
        .form-group {
            margin-bottom: 1.5rem;
        }
        
        .form-label {
            font-weight: 500;
            color: var(--primary-dark);
            margin-bottom: 0.5rem;
            display: block;
        }
        
        .form-control {
            width: 100%;
            padding: 12px 15px;
            border: 1px solid #ddd;
            border-radius: 6px;
            font-size: 1rem;
            transition: all 0.3s;
        }
        
        .form-control:focus {
            border-color: var(--accent-color);
            box-shadow: 0 0 0 0.25rem rgba(139, 195, 74, 0.25);
            outline: none;
        }
        
        .form-select {
            padding: 12px 15px;
        }
        
        .submit-btn {
            background-color: var(--primary-color);
            color: white;
            border: none;
            padding: 12px 25px;
            border-radius: 6px;
            font-weight: 500;
            font-size: 1rem;
            cursor: pointer;
            transition: all 0.3s;
            width: 100%;
            margin-top: 10px;
        }
        
        .submit-btn:hover {
            background-color: var(--primary-dark);
            transform: translateY(-2px);
        }
        
        .submit-btn:active {
            transform: translateY(0);
        }
        
        .error-message {
            color: var(--error-color);
            margin-top: 1rem;
            text-align: center;
            font-weight: 500;
        }
        
        .success-message {
            color: var(--primary-color);
            margin-top: 1rem;
            text-align: center;
            font-weight: 500;
        }
        
        .back-btn {
            display: inline-flex;
            align-items: center;
            margin-top: 25px;
            color: var(--primary-color);
            font-weight: 500;
            text-decoration: none;
            transition: all 0.3s;
        }
        
        .back-btn i {
            margin-right: 8px;
            transition: transform 0.3s;
        }
        
        .back-btn:hover {
            color: var(--primary-dark);
        }
        
        .back-btn:hover i {
            transform: translateX(-5px);
        }
        
        .form-footer {
            text-align: center;
            margin-top: 20px;
        }
        
        .is-invalid {
            border-color: var(--error-color) !important;
        }
        
        .invalid-feedback {
            color: var(--error-color);
            font-size: 0.875rem;
            margin-top: 0.25rem;
        }
        
        .form-row {
            display: flex;
            flex-wrap: wrap;
            margin-right: -5px;
            margin-left: -5px;
        }
        
        .form-col {
            padding-right: 5px;
            padding-left: 5px;
            flex: 1 0 0%;
        }
        
        @media (max-width: 768px) {
            .content-card {
                padding: 20px;
            }
            
            body {
                padding-top: 60px;
            }
        }
    </style>
</head>
<body>
    <%
        User user = (User) session.getAttribute("user");
        if (user == null || !user.isAdmin()) {
            response.sendRedirect("login.jsp");
            return;
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
                        <a class="nav-link" href="dashboard.jsp">
                            <i class="fas fa-tachometer-alt"></i>Dashboard
                        </a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link" href="searchBook.jsp">
                            <i class="fas fa-book"></i>Manage Books
                        </a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link active" href="book?action=new">
                            <i class="fas fa-plus-circle"></i>Add New Book
                        </a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link" href="reservation?action=list">
                            <i class="fas fa-list-alt"></i>View Reservations
                        </a>
                    </li>
                </ul>
                
                <div class="dropdown user-dropdown">
                    <a class="dropdown-toggle d-flex align-items-center text-decoration-none" href="#" role="button" data-bs-toggle="dropdown">
                        <i class="fas fa-user-circle me-2"></i>
                        <span>${user.username}</span>
                    </a>
                    <ul class="dropdown-menu dropdown-menu-end">
                        <li><a class="dropdown-item" href="#"><i class="fas fa-user me-2"></i>Profile</a></li>
                        <li><hr class="dropdown-divider"></li>
                        <li><a class="dropdown-item text-danger" href="logout"><i class="fas fa-sign-out-alt me-2"></i>Logout</a></li>
                    </ul>
                </div>
            </div>
        </div>
    </nav>
    
    <!-- Page Header -->
    <header class="library-header">
        <div class="container text-center">
            <h1><i class="fas fa-plus-circle me-2"></i> Add New Book</h1>
            <p class="lead mb-0">Fill in the details below to add a new book to the library</p>
        </div>
    </header>
    
    <!-- Main Content -->
    <main class="container">
        <div class="content-card">
            <h2 class="card-title">Book Information</h2>
            
            <form id="addBookForm" action="book" method="post">
                <input type="hidden" name="action" value="add">
                
                <div class="form-group">
                    <label for="title" class="form-label">Title *</label>
                    <input type="text" id="title" name="title" class="form-control" required
                           maxlength="255" placeholder="Enter book title">
                    <div class="invalid-feedback">Please provide a valid title.</div>
                </div>
                
                <div class="form-group">
                    <label for="author" class="form-label">Author *</label>
                    <input type="text" id="author" name="author" class="form-control" required
                           maxlength="255" placeholder="Enter author name">
                    <div class="invalid-feedback">Please provide a valid author.</div>
                </div>
                
                <div class="form-row">
                    <div class="form-col">
                        <div class="form-group">
                            <label for="isbn" class="form-label">ISBN</label>
                            <input type="text" id="isbn" name="isbn" class="form-control"
                                   maxlength="20" placeholder="Enter ISBN (optional)">
                            <div class="invalid-feedback">Please provide a valid ISBN.</div>
                        </div>
                    </div>
                    <div class="form-col">
                        <div class="form-group">
                            <label for="publicationYear" class="form-label">Publication Year</label>
                            <input type="number" id="publicationYear" name="publicationYear" 
                                   class="form-control" min="1000" max="<%= java.time.Year.now().getValue() %>"
                                   placeholder="YYYY">
                            <div class="invalid-feedback">Please provide a valid year (1000-<%= java.time.Year.now().getValue() %>).</div>
                        </div>
                    </div>
                </div>
                
                <div class="form-group">
                    <label for="publisher" class="form-label">Publisher</label>
                    <input type="text" id="publisher" name="publisher" class="form-control"
                           maxlength="100" placeholder="Enter publisher name (optional)">
                </div>
                
                <div class="form-group form-check">
                    <input type="checkbox" class="form-check-input" id="isAvailable" name="isAvailable" checked>
                    <label class="form-check-label" for="isAvailable">Available for reservation</label>
                </div>
                
                <button type="submit" class="submit-btn">
                    <i class="fas fa-plus-circle me-2"></i> Add Book
                </button>
                
                <c:if test="${not empty errorMessage}">
                    <div class="error-message">
                        <i class="fas fa-exclamation-circle me-2"></i>${errorMessage}
                    </div>
                </c:if>
                
                <c:if test="${not empty successMessage}">
                    <div class="success-message">
                        <i class="fas fa-check-circle me-2"></i>${successMessage}
                    </div>
                </c:if>
            </form>
            
            <div class="form-footer">
                <a href="searchBook.jsp" class="back-btn">
                    <i class="fas fa-arrow-left"></i> Back to Book List
                </a>
            </div>
        </div>
    </main>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    <script>
        document.addEventListener('DOMContentLoaded', function() {
            const form = document.getElementById('addBookForm');
            
            form.addEventListener('submit', function(e) {
                // Reset validation
                const invalidElements = form.querySelectorAll('.is-invalid');
                invalidElements.forEach(el => el.classList.remove('is-invalid'));
                
                // Validate required fields
                let isValid = true;
                
                const title = document.getElementById('title');
                if (title.value.trim() === '') {
                    title.classList.add('is-invalid');
                    isValid = false;
                }
                
                const author = document.getElementById('author');
                if (author.value.trim() === '') {
                    author.classList.add('is-invalid');
                    isValid = false;
                }
                
                // Validate publication year if provided
                const pubYear = document.getElementById('publicationYear');
                const currentYear = <%= java.time.Year.now().getValue() %>;
                if (pubYear.value && (parseInt(pubYear.value) < 1000 || parseInt(pubYear.value) > currentYear)) {
                    pubYear.classList.add('is-invalid');
                    isValid = false;
                }
                
                if (!isValid) {
                    e.preventDefault();
                    // Scroll to first error
                    const firstInvalid = form.querySelector('.is-invalid');
                    if (firstInvalid) {
                        firstInvalid.scrollIntoView({ behavior: 'smooth', block: 'center' });
                    }
                }
            });
            
            // Remove invalid class when user starts typing
            const inputs = form.querySelectorAll('.form-control');
            inputs.forEach(input => {
                input.addEventListener('input', function() {
                    this.classList.remove('is-invalid');
                });
            });
        });
    </script>
</body>
</html>
