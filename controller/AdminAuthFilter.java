package controller;

import java.io.IOException;
import jakarta.servlet.Filter;
import jakarta.servlet.FilterChain;
import jakarta.servlet.FilterConfig;
import jakarta.servlet.ServletException;
import jakarta.servlet.ServletRequest;
import jakarta.servlet.ServletResponse;
import jakarta.servlet.annotation.WebFilter;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import model.User;

/**
 * Filter to restrict access to admin pages
 */
@WebFilter(filterName = "AdminAuthFilter", urlPatterns = {"/admin/*", "/book", "/bookForm.jsp"})
public class AdminAuthFilter implements Filter {
    
    @Override
    public void init(FilterConfig filterConfig) throws ServletException {
        // Initialization code if needed
    }
    
    @Override
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain) 
            throws IOException, ServletException {
        
        HttpServletRequest httpRequest = (HttpServletRequest) request;
        HttpServletResponse httpResponse = (HttpServletResponse) response;
        HttpSession session = httpRequest.getSession(false);
        
        // Check if user is logged in and is an admin
        boolean isAdmin = false;
        if (session != null && session.getAttribute("user") != null) {
            User user = (User) session.getAttribute("user");
            isAdmin = user.getRole() == User.Role.Admin;
        }
        
        // Get the requested page path
        String requestPath = httpRequest.getRequestURI().substring(httpRequest.getContextPath().length());
        
        // For book servlet, check if the action is admin-specific
        if (requestPath.equals("/book")) {
            String action = httpRequest.getParameter("action");
            if (action != null && (action.equals("list") || action.equals("details"))) {
                // These actions are available to all users
                chain.doFilter(request, response);
                return;
            }
        }
        
        if (isAdmin) {
            // Admin user - allow access
            chain.doFilter(request, response);
        } else {
            // Not admin - store the requested URL and redirect to login
            String redirectURL = httpRequest.getContextPath() + "/login";
            httpResponse.sendRedirect(redirectURL);
        }
    }
    
    @Override
    public void destroy() {
        // Cleanup code if needed
    }
}

