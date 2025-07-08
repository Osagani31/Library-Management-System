<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html>
<head>
    <title>Access Denied</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css">
    <style>
        body {
            font-family: 'Segoe UI', sans-serif;
            background-color: #f5f5f5;
            text-align: center;
            padding-top: 100px;
        }
        .message-box {
            background: white;
            display: inline-block;
            padding: 40px 60px;
            border-radius: 10px;
            box-shadow: 0 6px 20px rgba(0,0,0,0.15);
        }
        h1 {
            color: #dc3545;
            margin-bottom: 20px;
        }
        .btn-back {
            margin-top: 20px;
            display: inline-block;
            background-color: #1e7e34;
            color: white;
            padding: 10px 18px;
            text-decoration: none;
            font-weight: bold;
            border-radius: 6px;
        }
        .btn-back:hover {
            background-color: #155d27;
        }
    </style>
</head>
<body>
    <div class="message-box">
        <h1><i class="fas fa-ban"></i> Access Denied</h1>
        <p>Only admin can access this page.</p>
        <a href="login.jsp" class="btn-back"><i class="fas fa-sign-in-alt"></i> Back to Login</a>
    </div>
</body>
</html>
