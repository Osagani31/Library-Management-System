<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Error - Library System</title>
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.15.4/css/all.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">

    <style>
        body {
            background-color: #f0f4f3;
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            margin: 0;
            padding: 0;
            color: #333;
        }

        .error-container {
            max-width: 600px;
            margin: 100px auto;
            padding: 40px;
            background-color: #ffffff;
            border-radius: 12px;
            box-shadow: 0 6px 20px rgba(0, 0, 0, 0.1);
            text-align: center;
        }

        .error-header {
            color: #28a745;
            margin-bottom: 20px;
        }

        .error-header i {
            font-size: 48px;
            margin-bottom: 10px;
        }

        .error-header h1 {
            font-size: 32px;
            font-weight: bold;
        }

        .error-message p {
            font-size: 18px;
            color: #555;
            margin: 20px 0;
        }

        .home-btn {
            display: inline-block;
            margin-top: 20px;
            padding: 12px 25px;
            background-color: #28a745;
            color: #ffffff;
            text-decoration: none;
            border-radius: 8px;
            font-weight: 600;
            transition: background-color 0.3s ease;
        }

        .home-btn:hover {
            background-color: #218838;
            text-decoration: none;
        }

        .footer {
            margin-top: 40px;
            font-size: 14px;
            color: #aaa;
        }
    </style>
</head>
<body>
    <div class="error-container">
        <div class="error-header">
            <i class="fas fa-exclamation-circle"></i>
            <h1>Error Occurred</h1>
        </div>
        
        <div class="error-message">
            <p>${not empty errorMessage ? errorMessage : 'An unexpected error occurred. Please try again later.'}</p>
        </div>
        
        <a href="login.jsp" class="home-btn">Return to Login</a>
        
        <div class="footer">
            &copy; 2025 Library Management System
        </div>
    </div>
</body>
</html>
