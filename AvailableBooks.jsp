<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List" %>
<%@ page import="model.Book" %>
<%@ page import="dao.BookDAO" %>
<%@ page import="model.User" %>
<%
    User user = (User) session.getAttribute("user");
    if (user == null) {
        response.sendRedirect("login.jsp");
        return;
    }
    boolean isAdmin = user.isAdmin();
%>
<% if (isAdmin) { %>
    <%@ include file="commonAdminHeader.jsp" %>
<% } else { %>
    <%@ include file="commonStudentHeader.jsp" %>
<% } %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Available Books - Library System</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <style>
        body {
            background-color: #f8f9fa;
            padding: 60px 0;
        }
        .container {
            background-color: #fff;
            border-radius: 8px;
            padding: 30px;
            box-shadow: 0 4px 12px rgba(0,0,0,0.1);
        }
        .table th {
            background-color: #2e7d32;
            color: white;
        }
        h2 {
            color: #2e7d32;
            font-weight: bold;
            margin-bottom: 30px;
        }
    </style>
</head>
<body>
    <div class="container">
        <h2>📗 Available Books for Borrowing</h2>

        <%
            BookDAO bookDAO = new BookDAO();
            List<Book> availableBooks = bookDAO.getAvailableBooks();
        %>

        <table class="table table-bordered table-hover">
            <thead>
                <tr>
                    <th>ID</th>
                    <th>Title</th>
                    <th>Author</th>
                    <th>ISBN</th>
                    <th>Publisher</th>
                    <th>Year</th>
                    <th>Status</th>
                </tr>
            </thead>
            <tbody>
                <%
                    for (Book book : availableBooks) {
                %>
                <tr>
                    <td><%= book.getBookId() %></td>
                    <td><%= book.getTitle() %></td>
                    <td><%= book.getAuthor() %></td>
                    <td><%= book.getIsbn() %></td>
                    <td><%= book.getPublisher() %></td>
                    <td><%= book.getPublicationYear() %></td>
                    <td>
                        <span class="badge bg-success">Available</span>
                        <a href="reserveForm.jsp?bookId=<%= book.getBookId() %>" class="btn btn-primary btn-sm ms-2">Reserve</a>
                    </td>
                </tr>
                <%
                    }
                %>
            </tbody>
        </table>
    </div>
</body>
</html>
