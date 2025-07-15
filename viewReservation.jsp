<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.*, model.*, dao.ReservationDAO, dao.BookDAO, dao.UserDAO" %>
<%@ page import="java.text.SimpleDateFormat" %>
<!DOCTYPE html>
<html>
<head>
    <title>Reserved Books</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <style>
        body {
            background-color: #f8f9fa;
            padding: 50px 0;
        }
        .container {
            background-color: #fff;
            border-radius: 8px;
            padding: 30px;
            box-shadow: 0 4px 12px rgba(0,0,0,0.1);
        }
        h2 {
            color: #2e7d32;
            font-weight: bold;
            margin-bottom: 25px;
        }
        .table th {
            background-color: #2e7d32;
            color: white;
        }
    </style>
</head>
<body>
    <div class="container">
        <h2>📚 Reserved Books Summary</h2>

        <%-- Declare variables at the top for use in all scriptlets --%>
        <%
            BookDAO bookDAO = new BookDAO();
            List<Reservation> reservations = (List<Reservation>) request.getAttribute("reservations");
            java.text.SimpleDateFormat sdf = new java.text.SimpleDateFormat("yyyy-MM-dd HH:mm");
        %>

        <ul class="nav nav-tabs mb-3" id="reservationTabs" role="tablist">
            <li class="nav-item" role="presentation">
                <button class="nav-link active" id="active-tab" data-bs-toggle="tab" data-bs-target="#active" type="button" role="tab">Active</button>
            </li>
            <li class="nav-item" role="presentation">
                <button class="nav-link" id="history-tab" data-bs-toggle="tab" data-bs-target="#history" type="button" role="tab">History</button>
            </li>
        </ul>
        <div class="tab-content" id="reservationTabsContent">
            <div class="tab-pane fade show active" id="active" role="tabpanel">
        <table class="table table-bordered table-striped table-hover">
            <thead>
                <tr>
                    <th>Book Title</th>
                    <th>User ID</th>
                    <th>Reservation Date</th>
                    <th>Status</th>
                </tr>
            </thead>
            <tbody>
                        <% if (reservations != null && !reservations.isEmpty()) { 
                       for (Reservation r : reservations) {
                                if (r.isActive()) {
                           Book book = bookDAO.getBookById(r.getBookId());
                    %>
                    <tr>
                        <td><%= (book != null) ? book.getTitle() : "N/A" %></td>
                        <td><%= r.getUserId() %></td>
                        <td><%= sdf.format(r.getReservationDate()) %></td>
                            <td><span class="badge bg-success">Reserved</span></td>
                    </tr>
                        <%       }
                            }
                        } else { %>
                        <tr><td colspan="100%" class="text-center text-muted">No active reservations found.</td></tr>
                    <% } %>
                    </tbody>
                </table>
            </div>
            <div class="tab-pane fade" id="history" role="tabpanel">
                <table class="table table-bordered table-striped table-hover">
                    <thead>
                        <tr>
                            <th>Book Title</th>
                            <th>User ID</th>
                            <th>Reservation Date</th>
                            <th>Status</th>
                        </tr>
                    </thead>
                    <tbody>
                        <% if (reservations != null && !reservations.isEmpty()) { 
                            for (Reservation r : reservations) {
                                if (!r.isActive()) {
                                    Book book = bookDAO.getBookById(r.getBookId());
                        %>
                        <tr>
                            <td><%= (book != null) ? book.getTitle() : "N/A" %></td>
                            <td><%= r.getUserId() %></td>
                            <td><%= sdf.format(r.getReservationDate()) %></td>
                            <td><span class="badge bg-secondary"><%= r.getStatus() %></span></td>
                        </tr>
                        <%       }
                            }
                        } else { %>
                        <tr><td colspan="100%" class="text-center text-muted">No reservation history found.</td></tr>
                <% } %>
            </tbody>
        </table>
            </div>
        </div>
        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    </div>
</body>
</html>
