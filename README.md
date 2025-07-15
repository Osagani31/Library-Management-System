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
## 📄 Screenshots

Here are some snapshots showcasing the key features of the Library Management System:

| 🔹 **Feature**                     | 🔍 **Screenshot(s)** |
|----------------------------------|-----------------------|
| 🔐 **Login Page**                | ![Login Page](https://github.com/user-attachments/assets/15ad0fe0-a022-4c1e-869b-5a58325151ad) |
| 🧑‍💼 **Admin Dashboard**         | ![Admin Dashboard](https://github.com/user-attachments/assets/a61163f4-1185-4b55-9fb1-e047afa15826) |
| 📚 **Book Management (Admin)**   | ![Book Management](https://github.com/user-attachments/assets/fc126d0f-47e8-446a-9811-bcb97a5ba0e5) |
| 🔍 **Live Search (AJAX + JSON)** | ![Live Search](https://github.com/user-attachments/assets/ab84f06a-c56e-4865-9f47-0d7db2ae2b73) |
| 🧾 **Reservation History**       | Reserved Books History : ![Reserved](https://github.com/user-attachments/assets/0de080b9-9af9-4d74-aa32-e130737549a1)<br>Active Reservations: ![Active](https://github.com/user-attachments/assets/ed8b2a85-a5b4-49d1-b792-f539091437e3) |
| ⚠️ **Access Denied/Error Page** | ![Access Denied](https://github.com/user-attachments/assets/c2c60c4e-ef37-4af1-9111-dbefbf8b8e00) |
| ➕ **Add Book (Admin)**          | ![Add Book 1](https://github.com/user-attachments/assets/25a679b0-0650-4f26-98b4-79398cde9625)<br>![Add Book 2](https://github.com/user-attachments/assets/7eaad84d-a11a-40f2-8ed2-0a3085dbdc03) |
|🧑‍💼 **Manage Users**  |![image](https://github.com/user-attachments/assets/c0456031-5545-48b8-871f-d29f8b67f9f5)|



## 🗄️ Database Schema

- MySQL schema includes:
  - `users`, `books`, `reservations` tables
  - Sample data and views
  - **Triggers & Procedures** to maintain data consistency

---
## 🎥 Demo Video

[![Watch the demo](https://img.youtube.com/vi/cAVdCHcvxuA/maxresdefault.jpg)](https://www.youtube.com/watch?v=cAVdCHcvxuA)

## 🛠️ Setup & Installation

### 🔧 Prerequisites
- Apache NetBeans or Eclipse
- Apache Tomcat or GlassFish
- MySQL with PHPMyAdmin

### ⚙️ Setup Steps

1. **Clone the repository**
   ```bash
   git clone https://github.com/Osagani31/library-management-system.git

