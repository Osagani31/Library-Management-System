<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="model.User" %>
<% if (user == null || !user.isAdmin()) { response.sendRedirect("login.jsp"); return; } %>
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
    .navbar {
        background-color: var(--primary-dark) !important;
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
        color: white !important;
        transition: var(--transition);
    }
    .navbar-brand:hover {
        color: var(--accent-color) !important;
    }
    .nav-link {
        color: rgba(255, 255, 255, 0.85) !important;
        font-weight: 500;
        margin: 0 8px;
        padding: 8px 12px;
        border-radius: 4px;
        transition: var(--transition);
    }
    .nav-link:hover, .nav-link.active {
        color: white !important;
        background-color: rgba(255, 255, 255, 0.1) !important;
    }
    .nav-link i {
        margin-right: 6px;
    }
    .user-dropdown .dropdown-toggle {
        color: white !important;
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
</style>
<nav class="navbar navbar-expand-lg navbar-dark bg-success">
    <div class="container-fluid">
        <a class="navbar-brand" href="dashboard.jsp"><i class="fas fa-book"></i> Library System</a>
        <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#navbarNav">
            <span class="navbar-toggler-icon"></span>
        </button>
        <div class="collapse navbar-collapse" id="navbarNav">
            <ul class="navbar-nav me-auto mb-2 mb-lg-0">
                <li class="nav-item"><a class="nav-link" href="dashboard.jsp">Dashboard</a></li>
                <li class="nav-item"><a class="nav-link" href="searchBook.jsp">Manage Books</a></li>
                <li class="nav-item"><a class="nav-link" href="bookForm.jsp">Add New Book</a></li>
                <li class="nav-item"><a class="nav-link" href="viewReservations">View Reservations</a></li>
                <li class="nav-item"><a class="nav-link" href="user?action=list">Manage Users</a></li>
            </ul>
            <ul class="navbar-nav ms-auto">
                <li class="nav-item dropdown">
                    <a class="nav-link dropdown-toggle" href="#" id="userDropdown" role="button" data-bs-toggle="dropdown">
                        <i class="fas fa-user-circle"></i> <%= user.getUsername() %> (Admin)
                    </a>
                    <ul class="dropdown-menu dropdown-menu-end">
                        <li><a class="dropdown-item" href="#">Profile</a></li>
                        <li><hr class="dropdown-divider"></li>
                        <li><a class="dropdown-item text-danger" href="logout.jsp">Logout</a></li>
                    </ul>
                </li>
            </ul>
        </div>
    </div>
</nav> 