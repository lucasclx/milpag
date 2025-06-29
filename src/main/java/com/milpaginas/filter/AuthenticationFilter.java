package com.milpaginas.filter;

import com.milpaginas.model.User;

import javax.servlet.*;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;

public class AuthenticationFilter implements Filter {
    
    @Override
    public void init(FilterConfig filterConfig) throws ServletException {
        // Initialization if needed
    }
    
    @Override
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain)
            throws IOException, ServletException {
        
        HttpServletRequest httpRequest = (HttpServletRequest) request;
        HttpServletResponse httpResponse = (HttpServletResponse) response;
        HttpSession session = httpRequest.getSession(false);
        
        String requestURI = httpRequest.getRequestURI();
        String contextPath = httpRequest.getContextPath();
        String path = requestURI.substring(contextPath.length());
        
        boolean isLoggedIn = (session != null && session.getAttribute("user") != null);
        boolean isAdminPath = path.startsWith("/admin/");
        boolean isProtectedPath = path.equals("/orders") || path.equals("/cart") || path.equals("/profile.jsp");
        
        if (!isLoggedIn && (isAdminPath || isProtectedPath)) {
            String loginURL = contextPath + "/login";
            if (isProtectedPath) {
                loginURL += "?redirect=" + requestURI;
            }
            httpResponse.sendRedirect(loginURL);
            return;
        }
        
        if (isAdminPath && isLoggedIn) {
            User user = (User) session.getAttribute("user");
            if (user == null || !user.isAdmin()) {
                httpResponse.sendError(HttpServletResponse.SC_FORBIDDEN, "Acesso negado");
                return;
            }
        }
        
        chain.doFilter(request, response);
    }
    
    @Override
    public void destroy() {
        // Cleanup if needed
    }
}