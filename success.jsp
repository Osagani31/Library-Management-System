<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Reservation Successful</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <style>
        body {
            background-color: #f8f9fa;
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
        }
         .library-header {
            background-color: var(--primary-dark);
            color: white;
            padding: 30px 0;
            margin-bottom: 40px;
            box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1);
        }
        
        .library-header h1 {
            font-weight: 600;
            letter-spacing: 0.5px;
        }
        .success-container {
            background-color: white;
            border-radius: 10px;
            box-shadow: 0 4px 8px rgba(0, 0, 0, 0.1);
            padding: 30px;
            max-width: 600px;
            margin: 0 auto;
            text-align: center;
        }
        .success-icon {
            color: #28a745;
            font-size: 5rem;
            margin-bottom: 20px;
        }
        .btn-primary {
            background-color: #4e73df;
            border-color: #4e73df;
        }
        .btn-primary:hover {
            background-color: #3a5bd9;
            border-color: #3a5bd9;
        }
    </style>
</head>
<body>
    <div class="library-header text-center">
        <h1><i class="bi bi-book"></i> Library Book Reservation System</h1>
    </div>

    <div class="container">
        <div class="success-container">
            <div class="success-icon">
                <i class="bi bi-check-circle-fill"></i>
            </div>
            <h2 class="mb-3">Reservation Successful!</h2>
            <p class="lead mb-4">Your book has been reserved successfully.</p>
            <a href="searchBook.jsp" class="btn btn-primary btn-lg">
                <i class="bi bi-search"></i> Search Another Book
            </a>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.0/font/bootstrap-icons.css">
    <script src="js/reservationUtils.js"></script>
    <script>
        // Notify other tabs that a reservation has been made
        document.addEventListener('DOMContentLoaded', function() {
            // Call functions from reservationUtils.js
            notifyReservationMade();
            
            // Set flags for dashboard updates
            localStorage.setItem('bookAvailabilityChanged', 'true');
            localStorage.setItem('availabilityChangeTime', Date.now().toString());
        });
    </script>
</body>
</html>
