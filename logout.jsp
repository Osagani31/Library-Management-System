<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    session.invalidate(); // Clear session on logout
%>
<!DOCTYPE html>
<html>
<head>
    <title>Logged Out - Library System</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css">
    <style>
        :root {
            --primary-color: #2e7d32;
            --primary-light: #60ad5e;
            --primary-dark: #005005;
            --secondary-color: #f5f5f5;
            --text-color: #333;
        }

        body {
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            background: url('images/BG.png') no-repeat center center fixed;
            background-size: cover;
            margin: 0;
            padding: 0;
            display: flex;
            justify-content: center;
            align-items: center;
            height: 100vh;
            color: var(--text-color);
        }

        .logout-box {
            background-color: rgba(255, 255, 255, 0.95);
            padding: 2.5rem 3rem;
            border-radius: 10px;
            box-shadow: 0 6px 20px rgba(0, 0, 0, 0.1);
            text-align: center;
        }

        .logout-box h1 {
            color: var(--primary-color);
            font-size: 1.8rem;
            margin-bottom: 1rem;
        }

        .logout-box p {
            font-size: 1rem;
            color: #555;
            margin-bottom: 1.5rem;
        }

        .btn-back {
            display: inline-block;
            background-color: var(--primary-color);
            color: white;
            padding: 0.8rem 1.5rem;
            font-weight: bold;
            border-radius: 6px;
            text-decoration: none;
            font-size: 1rem;
            transition: background-color 0.3s ease;
        }

        .btn-back:hover {
            background-color: var(--primary-dark);
        }
    </style>
</head>
<body>
    <div class="logout-box">
        <h1><i class="fas fa-sign-out-alt"></i> You’ve Been Logged Out</h1>
        <p>Thank you for using the Library Management System.</p>
        <a href="login.jsp" class="btn-back"><i class="fas fa-sign-in-alt"></i> Login Again</a>
    </div>
</body>
</html>
