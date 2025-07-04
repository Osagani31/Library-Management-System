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

/**
 * Filter to handle session timeouts across the application
 */
@WebFilter(filterName = "SessionTimeoutFilter", urlPatterns = {"/*"})
public class SessionTimeoutFilter implements Filter {
    
    // Pages that don't require authentication
    private static final String[] PUBLIC_PAGES = {
        "/login", "/login.jsp", "/error.jsp", "/css/", "/js/", "/images/"
    };
    
    // Session timeout in minutes
    private static final int SESSION_TIMEOUT = 30;
    
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
        
        // Get the requested URL path
        String requestPath = httpRequest.getRequestURI().substring(httpRequest.getContextPath().length());
        
        // Check if the requested page is public
        if (isPublicPage(requestPath)) {
            chain.doFilter(request, response);
            return;
        }
        
        // Check for active session
        if (session == null || session.getAttribute("user") == null) {
            // No active session - store the requested URL and redirect to login
            String redirectURL = httpRequest.getRequestURI();
            if (httpRequest.getQueryString() != null) {
                redirectURL += "?" + httpRequest.getQueryString();
            }
            
            // Store the URL for redirection after login
            HttpSession newSession = httpRequest.getSession(true);
            newSession.setAttribute("redirectURL", redirectURL);
            
            // Redirect to login page
            httpResponse.sendRedirect(httpRequest.getContextPath() + "/login");
            return;
        }
        
        // Set session timeout
        session.setMaxInactiveInterval(SESSION_TIMEOUT * 60);
        
        // Continue with the request
        chain.doFilter(request, response);
    }
    
    @Override
    public void destroy() {
        // Cleanup code if needed
    }
    
    /**
     * Check if the requested page is in the list of public pages
     * @param requestPath The requested URL path
     * @return true if the page is public, false otherwise
     */
    private boolean isPublicPage(String requestPath) {
        for (String publicPage : PUBLIC_PAGES) {
            if (requestPath.equals(publicPage) || requestPath.startsWith(publicPage)) {
                return true;
            }
        }
        return false;
    }
}
