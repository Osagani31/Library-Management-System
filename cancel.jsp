
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Reservation Cancelled</title>
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
        <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.0/font/bootstrap-icons.css" rel="stylesheet">
        <style>
            body {
                background-color: #f8f9fa;
                font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            }
            .library-header {
                background-color: #1b5e20;
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
                border-top: 5px solid #dc3545;
            }
            .success-icon {
                color: #dc3545;
                font-size: 5rem;
                margin-bottom: 20px;
                animation: fadeInDown 1s;
            }
            .action-buttons {
                display: flex;
                justify-content: center;
                gap: 15px;
                margin-top: 30px;
            }
            .btn-primary {
                background-color: #4e73df;
                border-color: #4e73df;
            }
            .btn-primary:hover {
                background-color: #3a5bd9;
                border-color: #3a5bd9;
            }
            @keyframes fadeInDown {
                0% {
                    opacity: 0;
                    transform: translateY(-20px);
                }
                100% {
                    opacity: 1;
                    transform: translateY(0);
                }
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
                    <i class="bi bi-x-circle-fill"></i>
                </div>
                <h2 class="mb-3">Reservation Cancelled!</h2>
                <p class="lead mb-4">Your book reservation has been cancelled successfully and the book is now available for others.</p>
                <div class="action-buttons">
                    <a href="searchBook.jsp" class="btn btn-primary">
                        <i class="fas fa-book me-2"></i>Return to Book List
                    </a>
                    <a href="dashboard.jsp" class="btn btn-outline-secondary">
                        <i class="bi bi-speedometer2"></i> Back to Dashboard
                    </a>
                </div>
            </div>
        </div>

        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
        <script src="js/reservationUtils.js"></script>
        <script>
            // Update dashboard counts after a reservation is cancelled
            document.addEventListener('DOMContentLoaded', function() {
                // Update dashboard counts
                updateDashboardCounts();
                
                // Notify other tabs/windows about cancellation
                notifyCancellation();
                
                // Show alert that cancellation was successful
                setTimeout(() => {
                    alert('Reservation cancelled successfully! The book is now available for others.');
                }, 500);
            });
        </script>
    </body>
</html>

