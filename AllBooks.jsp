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
    <title>All Books - Library System</title>
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
        <h2>📚 All Books in Library</h2>

        <%
            BookDAO bookDAO = new BookDAO();
            List<Book> books = bookDAO.getAllBooks();
        %>

        <% if ("returned".equals(request.getParameter("success"))) { %>
        <div class="alert alert-success">Book successfully marked as returned and available!</div>
        <% } %>

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
                    for (Book book : books) {
                %>
                <tr>
                    <td><%= book.getBookId() %></td>
                    <td><%= book.getTitle() %></td>
                    <td><%= book.getAuthor() %></td>
                    <td><%= book.getIsbn() %></td>
                    <td><%= book.getPublisher() %></td>
                    <td><%= book.getPublicationYear() %></td>
                    <td>
                        <% if (book.isAvailable()) { %>
                            <span class="badge bg-success">Available</span>
                        <% } else { %>
                            <span class="badge bg-danger">Reserved</span>
                        <% } %>
                    </td>
                    <% if (isAdmin) { %>
                        <td>
                            <form action="BookStatusServlet" method="post" style="display:inline;" onsubmit="return confirmReturnBook(this);">
                                <input type="hidden" name="bookId" value="<%= book.getBookId() %>" />
                                <button type="submit" name="status" value="available" class="btn btn-success btn-sm" <%= book.isAvailable() ? "disabled" : "" %>>Available</button>
                                <button type="submit" name="status" value="pending" class="btn btn-warning btn-sm">Pending</button>
                                <button type="submit" name="status" value="reserved" class="btn btn-danger btn-sm" <%= !book.isAvailable() ? "disabled" : "" %>>Reserved</button>
                            </form>
                        </td>
                    <% } %>
                </tr>
                <%
                    }
                %>
            </tbody>
        </table>
    </div>
    <script>
    // Notify dashboard to update after status change
    if (window.location.search.includes('BookStatusServlet')) {
        // Book status was just changed, notify dashboard
        localStorage.setItem('bookStatusChanged', 'true');
        localStorage.setItem('bookStatusChangedTime', Date.now().toString());
        // Optionally, trigger dashboardCount fetch here if needed
    }

    function confirmReturnBook(form) {
        // Only ask if the book is currently reserved
        var statusCell = form.closest('tr').querySelector('.badge.bg-danger');
        if (statusCell) {
            var confirmed = confirm('Did the book return to the library?');
            if (confirmed) {
                // Notify dashboard and reservation list to update
                localStorage.setItem('bookReturned', 'true');
                localStorage.setItem('bookReturnedTime', Date.now().toString());
            }
            return confirmed;
        }
        return true; // If not reserved, allow as normal
    }

    // Listen for bookReturned event to update dashboard and reservation list
    window.addEventListener('storage', function(event) {
        if (event.key === 'bookReturned' && event.newValue === 'true') {
            // Optionally, reload or fetch updates for dashboard and reservation list
            location.reload();
        }
    });
    </script>
</body>
</html>
