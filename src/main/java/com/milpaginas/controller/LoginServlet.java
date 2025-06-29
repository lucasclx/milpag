package com.milpaginas.controller;

import com.milpaginas.dao.UserDAO;
import com.milpaginas.model.User;
import com.milpaginas.util.PasswordUtil;
import com.milpaginas.util.ValidationUtil;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.sql.SQLException;

public class LoginServlet extends HttpServlet {
    
    private UserDAO userDAO = new UserDAO();
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        request.getRequestDispatcher("/login.jsp").forward(request, response);
    }
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        String email = request.getParameter("email");
        String senha = request.getParameter("senha");
        
        try {
            if (!ValidationUtil.isValidEmail(email)) {
                request.setAttribute("error", "Email inválido");
                request.getRequestDispatcher("/login.jsp").forward(request, response);
                return;
            }
            
            if (!ValidationUtil.isNotEmpty(senha)) {
                request.setAttribute("error", "Senha é obrigatória");
                request.getRequestDispatcher("/login.jsp").forward(request, response);
                return;
            }
            
            User user = userDAO.findByEmail(email);
            
            // Debug logs
            System.out.println("=== LOGIN DEBUG ===");
            System.out.println("Email: " + email);
            System.out.println("User found: " + (user != null));
            if (user != null) {
                System.out.println("User ID: " + user.getId());
                System.out.println("User Name: " + user.getNome());
                System.out.println("User Type: " + user.getTipoUsuario());
                System.out.println("Stored hash: " + user.getSenha());
                System.out.println("Password verification: " + PasswordUtil.verifyPassword(senha, user.getSenha()));
            }
            System.out.println("==================");
            
            if (user != null && PasswordUtil.verifyPassword(senha, user.getSenha())) {
                HttpSession session = request.getSession();
                session.setAttribute("user", user);
                session.setAttribute("userId", user.getId());
                session.setAttribute("userName", user.getNome());
                session.setAttribute("isAdmin", user.isAdmin());
                
                String redirectTo = request.getParameter("redirect");
                if (ValidationUtil.isNotEmpty(redirectTo)) {
                    response.sendRedirect(redirectTo);
                } else if (user.isAdmin()) {
                    response.sendRedirect("admin/dashboard.jsp");
                } else {
                    response.sendRedirect("index.jsp");
                }
            } else {
                request.setAttribute("error", "Email ou senha incorretos");
                request.getRequestDispatcher("/login.jsp").forward(request, response);
            }
            
        } catch (SQLException e) {
            e.printStackTrace();
            request.setAttribute("error", "Erro interno do servidor");
            request.getRequestDispatcher("/login.jsp").forward(request, response);
        }
    }
}