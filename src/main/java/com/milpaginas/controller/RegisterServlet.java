package com.milpaginas.controller;

import com.milpaginas.dao.UserDAO;
import com.milpaginas.model.User;
import com.milpaginas.util.PasswordUtil;
import com.milpaginas.util.ValidationUtil;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.sql.SQLException;

public class RegisterServlet extends HttpServlet {
    
    private UserDAO userDAO = new UserDAO();
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        request.getRequestDispatcher("/register.jsp").forward(request, response);
    }
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        String nome = request.getParameter("nome");
        String email = request.getParameter("email");
        String senha = request.getParameter("senha");
        String confirmarSenha = request.getParameter("confirmarSenha");
        String endereco = request.getParameter("endereco");
        String telefone = request.getParameter("telefone");
        
        try {
            if (!ValidationUtil.isNotEmpty(nome)) {
                request.setAttribute("error", "Nome é obrigatório");
                request.getRequestDispatcher("/register.jsp").forward(request, response);
                return;
            }
            
            if (!ValidationUtil.isValidEmail(email)) {
                request.setAttribute("error", "Email inválido");
                request.getRequestDispatcher("/register.jsp").forward(request, response);
                return;
            }
            
            if (!ValidationUtil.isValidPassword(senha)) {
                request.setAttribute("error", "Senha deve ter pelo menos 6 caracteres");
                request.getRequestDispatcher("/register.jsp").forward(request, response);
                return;
            }
            
            if (!senha.equals(confirmarSenha)) {
                request.setAttribute("error", "Senhas não coincidem");
                request.getRequestDispatcher("/register.jsp").forward(request, response);
                return;
            }
            
            if (userDAO.emailExists(email)) {
                request.setAttribute("error", "Email já está em uso");
                request.getRequestDispatcher("/register.jsp").forward(request, response);
                return;
            }
            
            if (ValidationUtil.isNotEmpty(telefone) && !ValidationUtil.isValidPhone(telefone)) {
                request.setAttribute("error", "Telefone inválido");
                request.getRequestDispatcher("/register.jsp").forward(request, response);
                return;
            }
            
            User user = new User();
            user.setNome(ValidationUtil.sanitizeString(nome));
            user.setEmail(ValidationUtil.sanitizeString(email));
            user.setSenha(PasswordUtil.hashPassword(senha));
            user.setEndereco(ValidationUtil.sanitizeString(endereco));
            user.setTelefone(ValidationUtil.sanitizeString(telefone));
            user.setTipoUsuario(User.UserType.CLIENTE);
            
            userDAO.save(user);
            
            request.setAttribute("success", "Conta criada com sucesso! Faça login para continuar.");
            request.getRequestDispatcher("/login.jsp").forward(request, response);
            
        } catch (SQLException e) {
            e.printStackTrace();
            request.setAttribute("error", "Erro interno do servidor");
            request.getRequestDispatcher("/register.jsp").forward(request, response);
        }
    }
}