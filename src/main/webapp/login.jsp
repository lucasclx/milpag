<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="pt-BR">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Login - Mil Páginas</title>
    <link rel="stylesheet" href="css/style.css">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
</head>
<body>
    <jsp:include page="includes/header.jsp" />
    
    <main class="auth-main">
        <div class="container">
            <div class="auth-container">
                <div class="auth-form">
                    <div class="auth-header">
                        <h2>Entrar na sua conta</h2>
                        <p>Bem-vindo de volta à Mil Páginas</p>
                    </div>
                    
                    <c:if test="${not empty error}">
                        <div class="alert alert-error">
                            <i class="fas fa-exclamation-circle"></i>
                            ${error}
                        </div>
                    </c:if>
                    
                    <c:if test="${not empty success}">
                        <div class="alert alert-success">
                            <i class="fas fa-check-circle"></i>
                            ${success}
                        </div>
                    </c:if>
                    
                    <form action="login" method="post" class="form">
                        <input type="hidden" name="redirect" value="${param.redirect}">
                        
                        <div class="form-group">
                            <label for="email">Email</label>
                            <div class="input-group">
                                <i class="fas fa-envelope"></i>
                                <input type="email" id="email" name="email" required 
                                       placeholder="seu@email.com" value="${param.email}">
                            </div>
                        </div>
                        
                        <div class="form-group">
                            <label for="senha">Senha</label>
                            <div class="input-group">
                                <i class="fas fa-lock"></i>
                                <input type="password" id="senha" name="senha" required 
                                       placeholder="Digite sua senha">
                                <button type="button" class="password-toggle" onclick="togglePassword('senha')">
                                    <i class="fas fa-eye"></i>
                                </button>
                            </div>
                        </div>
                        
                        <div class="form-options">
                            <label class="checkbox-container">
                                <input type="checkbox" name="remember">
                                <span class="checkmark"></span>
                                Lembrar de mim
                            </label>
                            <a href="forgot-password.jsp" class="forgot-link">Esqueceu a senha?</a>
                        </div>
                        
                        <button type="submit" class="btn btn-primary btn-full">
                            <i class="fas fa-sign-in-alt"></i>
                            Entrar
                        </button>
                    </form>
                    
                    <div class="auth-footer">
                        <p>Não tem uma conta? <a href="register">Cadastre-se aqui</a></p>
                    </div>
                </div>
                
                <div class="auth-sidebar">
                    <div class="auth-sidebar-content">
                        <i class="fas fa-book-reader"></i>
                        <h3>Descubra um mundo de livros</h3>
                        <p>Acesse sua conta e explore nossa vasta coleção de livros. Acompanhe seus pedidos, gerencie sua lista de desejos e muito mais.</p>
                        
                        <div class="features-list">
                            <div class="feature-item">
                                <i class="fas fa-shipping-fast"></i>
                                <span>Entrega rápida</span>
                            </div>
                            <div class="feature-item">
                                <i class="fas fa-shield-alt"></i>
                                <span>Compra segura</span>
                            </div>
                            <div class="feature-item">
                                <i class="fas fa-star"></i>
                                <span>Livros selecionados</span>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </main>
    
    <jsp:include page="includes/footer.jsp" />
    
    <script src="js/script.js"></script>
    <script>
        function togglePassword(inputId) {
            const input = document.getElementById(inputId);
            const toggle = input.nextElementSibling;
            const icon = toggle.querySelector('i');
            
            if (input.type === 'password') {
                input.type = 'text';
                icon.classList.remove('fa-eye');
                icon.classList.add('fa-eye-slash');
            } else {
                input.type = 'password';
                icon.classList.remove('fa-eye-slash');
                icon.classList.add('fa-eye');
            }
        }
        
        // Focar no primeiro campo quando a página carrega
        document.addEventListener('DOMContentLoaded', function() {
            document.getElementById('email').focus();
        });
    </script>
</body>
</html>