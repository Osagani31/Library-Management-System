# 📚 Library Management System

A robust, full-stack web application for managing library operations, built using **Java Servlets**, **JSP**, and **MySQL**. The system supports **Admin** and **Student** roles, offering seamless functionality for book management, reservations, and user administration.

---

## 🚀 Features & Highlights

### 🔒 Role-Based Access Control
- **Admin & Student Roles**: Secure login with session management.
- **Dynamic Navigation**: Role-aware dashboards and menu items.
- **Access Restrictions**: Only authorized users can access sensitive pages.

### 📚 Book Management
- **Add / Edit / Delete Books**: Admins manage the book collection.
- **Status Tracking**: Real-time availability status.
- **View Details**: Users can see book information before reserving.

### 🗂️ Reservation System
- **Reserve Books**: Students can reserve available titles.
- **Return Books**: Automatically updates status upon return.
- **Reservation History**: Track all active and past reservations.

### 🔍 Live Search & Real-Time Updates
- **Live Book Search**: AJAX-powered search by title, author, or category.
- **Live Status Updates**: Book/reservation changes update without refresh.
- **Quick Filters**: Efficient user and book lookup.

### 👤 User Management
- **Admin Panel**: Create/edit/delete student accounts.
- **Session Timeout**: Automatic logout on inactivity.

### 🖥️ Modern UI & UX
- **Responsive Design**: Clean interface using Bootstrap 5.
- **Font Awesome Icons**: For visual enhancement.
- **Consistent Navigation**: Unified design across all pages.
- **Error Handling**: Friendly messages for access denied, 404, etc.

### 🔄 AJAX & JSON Integration
- **Asynchronous Requests**: Used JSON with AJAX for live search and dashboard updates.
- **Dynamic Feedback**: Improves responsiveness without page reloads.

### 🛡️ Security
- **Password Hashing**: Credentials stored securely.
- **Session Validation**: Prevents unauthorized access and session hijacking.

---

## 🗄️ Database Schema

- MySQL schema includes:
  - `users`, `books`, `reservations` tables
  - Sample data and views
  - **Triggers & Procedures** to maintain data consistency

---
## 🛠️ Setup & Installation

### 🔧 Prerequisites
- Apache NetBeans or Eclipse
- Apache Tomcat or GlassFish
- MySQL with PHPMyAdmin

### ⚙️ Setup Steps

1. **Clone the repository**
   ```bash
   git clone https://github.com/Osagani31/library-management-system.git

