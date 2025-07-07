<%@ page contentType="text/html;charset=UTF-8" language="java" %> 
<!DOCTYPE html> 
<html> 
<head> 
    <title>Library System - Login</title> 
    <style> 
        :root { 
            --primary-color: #2e7d32; 
            --primary-light: #60ad5e; 
            --primary-dark: #005005; 
            --secondary-color: #f5f5f5; 
            --text-color: #333; 
            --error-color: #d32f2f; 
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
         
        .login-container { 
            background-color: white; 
            border-radius: 8px; 
            box-shadow: 0 4px 12px rgba(0, 0, 0, 0.1); 
            padding: 2rem; 
            width: 350px; 
            text-align: center; 
        } 
         
        .login-header { 
            margin-bottom: 2rem; 
        } 
         
        .login-header h1 { 
            color: var(--primary-color); 
            margin: 0; 
            font-size: 1.8rem; 
        } 
         
        .login-header p { 
            color: #666; 
            margin: 0.5rem 0 0; 
            font-size: 0.9rem; 
        } 
         
        .login-form { 
            display: flex; 
            flex-direction: column; 
            gap: 1.5rem; 
        } 
         
        .form-group { 
            display: flex; 
            flex-direction: column; 
            text-align: left; 
        } 
         
        .form-group label { 
            margin-bottom: 0.5rem; 
            font-weight: 500; 
            color: var(--text-color); 
        } 
         
        .form-group input { 
            padding: 0.8rem; 
            border: 1px solid #ddd; 
            border-radius: 4px; 
            font-size: 1rem; 
            transition: border-color 0.3s; 
        } 
         
        .form-group input:focus { 
            outline: none; 
            border-color: var(--primary-light); 
        } 
         
        .login-button { 
            background-color: var(--primary-color); 
            color: white; 
            border: none; 
            padding: 0.8rem; 
            border-radius: 4px; 
            font-size: 1rem; 
            font-weight: 500; 
            cursor: pointer; 
            transition: background-color 0.3s; 
        } 
         
        .login-button:hover { 
            background-color: var(--primary-dark); 
        } 
         
        .error-message { 
            color: var(--error-color); 
            margin-top: 1rem; 
            font-size: 0.9rem; 
        } 
         
        .footer { 
            margin-top: 1.5rem; 
            font-size: 0.8rem; 
            color: #666; 
        } 
    </style> 
</head> 
<body> 
    <div class="login-container"> 
        <div class="login-header"> 
            <h1>Library System</h1> 
            <p>Please sign in to continue</p> 
        </div> 
         
        <form class="login-form" action="login" method="post"> 
            <div class="form-group"> 
                <label for="username">Username</label> 
                <input type="text" id="username" name="username" required> 
            </div> 
             
            <div class="form-group"> 
                <label for="password">Password</label> 
                <input type="password" id="password" name="password" required> 
            </div> 
             
            <button type="submit" class="login-button">Sign In</button> 
             
            <c:if test="${not empty errorMessage}"> 
                <div class="error-message">${errorMessage}</div> 
            </c:if> 
        </form> 
         
        <div class="footer"> 
            &copy; 2023 Library Management System 
        </div> 
    </div> 
    
    <script src="js/sessionUtils.js"></script>
</body> 
</html>

