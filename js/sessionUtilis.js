/* 
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/JavaScript.js to edit this template
 */

// Keep the session alive with periodic pings to the server
function keepSessionAlive() {
    // Ping the server every 10 minutes to prevent session timeout
    setInterval(function() {
        fetch('sessionKeepAlive', {
            method: 'GET',
            credentials: 'same-origin' // Send cookies for session tracking
        }).catch(function(error) {
            console.error('Session keep-alive request failed:', error);
        });
    }, 10 * 60 * 1000); // 10 minutes in milliseconds
}

// Store the last accessed page in local storage
function storeCurrentPage() {
    const currentPath = window.location.pathname;
    const queryString = window.location.search;
    localStorage.setItem('lastAccessedPage', currentPath + queryString);
}

// Function to redirect to stored page after login if available
function redirectAfterLogin() {
    const storedPage = localStorage.getItem('lastAccessedPage');
    if (storedPage && storedPage !== '/login.jsp' && storedPage !== '/login') {
        // Clear the stored page
        localStorage.removeItem('lastAccessedPage');
        // Redirect to the stored page
        window.location.href = storedPage;
        return true;
    }
    return false;
}

// Initialize session management
document.addEventListener('DOMContentLoaded', function() {
    // Start session keep-alive pings
    keepSessionAlive();
    
    // Store current page unless it's the login page
    if (!window.location.pathname.includes('login')) {
        storeCurrentPage();
    }
    
    // If on the dashboard page after login, check for redirect
    if (window.location.pathname.includes('dashboard.jsp')) {
        const fromLogin = sessionStorage.getItem('fromLogin');
        if (fromLogin === 'true') {
            sessionStorage.removeItem('fromLogin');
            redirectAfterLogin();
        }
    }
    
    // If on login page, set flag for after login
    if (window.location.pathname.includes('login')) {
        sessionStorage.setItem('fromLogin', 'true');
    }
});


