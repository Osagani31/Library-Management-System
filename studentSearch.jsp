<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="model.User, java.util.List, model.Book" %>
<%
    User user = (User) session.getAttribute("user");
    if (user == null || user.isAdmin()) {
        response.sendRedirect("login.jsp");
        return;
    }
%>
<%@ include file="commonStudentHeader.jsp" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Student Book Search</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
</head>
<body>
<%
    // Removed duplicate declaration of user and isAdmin; already in commonStudentHeader.jsp
%>
<div class="container mt-5">
    <h2>Search for Books</h2>
    <form action="studentBookSearch" method="get" class="mb-4">
        <div class="mb-3">
            <label for="searchTerm" class="form-label">Book Search</label>
            <input type="text" class="form-control" id="searchTerm" name="searchTerm" placeholder="Enter book title, author, or keywords" required>
        </div>
        <div class="mb-3">
            <label for="searchType" class="form-label">Search By</label>
            <select id="searchType" class="form-select" name="searchType">
                <option value="both">All</option>
                <option value="title">Title Only</option>
                <option value="author">Author Only</option>
            </select>
        </div>
        <button type="submit" class="btn btn-success w-100">Search</button>
    </form>
    <% List<Book> bookList = (List<Book>) request.getAttribute("bookList");
       if (bookList != null) { %>
    <div class="table-responsive">
        <table class="table table-bordered">
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
            <% for (Book book : bookList) { %>
                <tr>
                    <td><%= book.getBookId() %></td>
                    <td><%= book.getTitle() %></td>
                    <td><%= book.getAuthor() %></td>
                    <td><%= book.getIsbn() %></td>
                    <td><%= book.getPublisher() %></td>
                    <td><%= book.getPublicationYear() %></td>
                    <td><span class="badge <%= book.isAvailable() ? "bg-success" : "bg-danger" %>"><%= book.isAvailable() ? "Available" : "Reserved" %></span></td>
                </tr>
            <% } %>
            </tbody>
        </table>
    </div>
    <% } %>
</div>
<script>
function fetchReservations() {
    fetch('reservationList')
        .then(response => response.json())
        .then(data => {
            // Update the reservation table dynamically
            updateReservationTables(data);
        });
}

// Call fetchReservations every 5 seconds
setInterval(fetchReservations, 5000);

function updateReservationTables(reservations) {
    const activeTbody = document.querySelector('#active tbody');
    const historyTbody = document.querySelector('#history tbody');
    activeTbody.innerHTML = '';
    historyTbody.innerHTML = '';

    let hasActive = false, hasHistory = false;
    reservations.forEach(r => {
        if (!r || typeof r !== 'object') return; // skip invalid entries
        const row = document.createElement('tr');
        if (r.isActive) {
            hasActive = true;
            row.innerHTML = `
                <td>${r.bookTitle || 'N/A'}</td>
                <td>${r.userId}</td>
                <td>${r.reservationDate.replace('T', ' ').substring(0, 16)}</td>
                <td><span class="badge bg-success">Reserved</span></td>
            `;
            activeTbody.appendChild(row);
        } else {
            hasHistory = true;
            row.innerHTML = `
                <td>${r.bookTitle || 'N/A'}</td>
                <td>${r.userId}</td>
                <td>${r.reservationDate.replace('T', ' ').substring(0, 16)}</td>
                <td><span class="badge bg-secondary">${r.status}</span></td>
            `;
            historyTbody.appendChild(row);
        }
    });

    if (!hasActive) {
        activeTbody.innerHTML = '<tr><td colspan="4" class="text-center text-muted">No active reservations found.</td></tr>';
    }
    if (!hasHistory) {
        historyTbody.innerHTML = '<tr><td colspan="4" class="text-center text-muted">No reservation history found.</td></tr>';
    }
}

localStorage.setItem('bookReserved', 'true');
localStorage.setItem('bookReservedTime', Date.now().toString());

window.addEventListener('storage', function(event) {
    if (event.key === 'bookReserved' && event.newValue === 'true') {
        // Fetch and update the book list/dashboard
        location.reload(); // or call your AJAX update function
    }
});

setInterval(function() {
    // Fetch and update the book list/dashboard
}, 5000);

function updateDashboardTimestamp() {
    var now = new Date();
    var formatted = now.getFullYear() + '-' +
        String(now.getMonth()+1).padStart(2, '0') + '-' +
        String(now.getDate()).padStart(2, '0') + ' ' +
        String(now.getHours()).padStart(2, '0') + ':' +
        String(now.getMinutes()).padStart(2, '0') + ':' +
        String(now.getSeconds()).padStart(2, '0');
    document.getElementById('dashboardTimestamp').textContent = formatted;
}
setInterval(updateDashboardTimestamp, 1000);
updateDashboardTimestamp();
</script>
</body>
</html> 