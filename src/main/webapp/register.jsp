<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="pt-BR">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Cadastro - Mil Páginas</title>
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
                        <h2>Criar nova conta</h2>
                        <p>Junte-se à comunidade Mil Páginas</p>
                    </div>
                    
                    <c:if test="${not empty error}">
                        <div class="alert alert-error">
                            <i class="fas fa-exclamation-circle"></i>
                            ${error}
                        </div>
                    </c:if>
                    
                    <form action="register" method="post" class="form" onsubmit="return validateForm()">
                        <div class="form-group">
                            <label for="nome">Nome Completo *</label>
                            <div class="input-group">
                                <i class="fas fa-user"></i>
                                <input type="text" id="nome" name="nome" required 
                                       placeholder="Seu nome completo" value="${param.nome}">
                            </div>
                        </div>
                        
                        <div class="form-group">
                            <label for="email">Email *</label>
                            <div class="input-group">
                                <i class="fas fa-envelope"></i>
                                <input type="email" id="email" name="email" required 
                                       placeholder="seu@email.com" value="${param.email}">
                            </div>
                        </div>
                        
                        <div class="form-row">
                            <div class="form-group">
                                <label for="senha">Senha *</label>
                                <div class="input-group">
                                    <i class="fas fa-lock"></i>
                                    <input type="password" id="senha" name="senha" required 
                                           placeholder="Mínimo 6 caracteres" minlength="6">
                                    <button type="button" class="password-toggle" onclick="togglePassword('senha')">
                                        <i class="fas fa-eye"></i>
                                    </button>
                                </div>
                            </div>
                            
                            <div class="form-group">
                                <label for="confirmarSenha">Confirmar Senha *</label>
                                <div class="input-group">
                                    <i class="fas fa-lock"></i>
                                    <input type="password" id="confirmarSenha" name="confirmarSenha" required 
                                           placeholder="Confirme sua senha" minlength="6">
                                    <button type="button" class="password-toggle" onclick="togglePassword('confirmarSenha')">
                                        <i class="fas fa-eye"></i>
                                    </button>
                                </div>
                                <div id="password-match-message" class="field-message"></div>
                            </div>
                        </div>
                        
                        <div class="form-group">
                            <label for="telefone">Telefone</label>
                            <div class="input-group">
                                <i class="fas fa-phone"></i>
                                <input type="tel" id="telefone" name="telefone" 
                                       placeholder="(11) 99999-9999" value="${param.telefone}">
                            </div>
                        </div>
                        
                        <div class="form-group">
                            <label for="endereco">Endereço</label>
                            <div class="input-group">
                                <i class="fas fa-map-marker-alt"></i>
                                <textarea id="endereco" name="endereco" rows="3" 
                                          placeholder="Seu endereço completo">${param.endereco}</textarea>
                            </div>
                        </div>
                        
                        <div class="form-group">
                            <label class="checkbox-container">
                                <input type="checkbox" id="terms" required>
                                <span class="checkmark"></span>
                                Concordo com os <a href="terms.jsp" target="_blank">Termos de Uso</a> 
                                e <a href="privacy.jsp" target="_blank">Política de Privacidade</a>
                            </label>
                        </div>
                        
                        <div class="form-group">
                            <label class="checkbox-container">
                                <input type="checkbox" id="newsletter">
                                <span class="checkmark"></span>
                                Quero receber novidades e ofertas por email
                            </label>
                        </div>
                        
                        <button type="submit" class="btn btn-primary btn-full">
                            <i class="fas fa-user-plus"></i>
                            Criar Conta
                        </button>
                    </form>
                    
                    <div class="auth-footer">
                        <p>Já tem uma conta? <a href="login">Entre aqui</a></p>
                    </div>
                </div>
                
                <div class="auth-sidebar">
                    <div class="auth-sidebar-content">
                        <i class="fas fa-users"></i>
                        <h3>Junte-se à nossa comunidade</h3>
                        <p>Crie sua conta e tenha acesso a benefícios exclusivos, acompanhe seus pedidos e descubra novos livros personalizados para você.</p>
                        
                        <div class="benefits-list">
                            <div class="benefit-item">
                                <i class="fas fa-gift"></i>
                                <div>
                                    <strong>Ofertas exclusivas</strong>
                                    <span>Descontos especiais para membros</span>
                                </div>
                            </div>
                            <div class="benefit-item">
                                <i class="fas fa-heart"></i>
                                <div>
                                    <strong>Lista de desejos</strong>
                                    <span>Salve seus livros favoritos</span>
                                </div>
                            </div>
                            <div class="benefit-item">
                                <i class="fas fa-truck"></i>
                                <div>
                                    <strong>Acompanhamento</strong>
                                    <span>Rastreie seus pedidos</span>
                                </div>
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
        
        function validateForm() {
            const senha = document.getElementById('senha').value;
            const confirmarSenha = document.getElementById('confirmarSenha').value;
            
            if (senha !== confirmarSenha) {
                alert('As senhas não coincidem!');
                return false;
            }
            
            if (senha.length < 6) {
                alert('A senha deve ter pelo menos 6 caracteres!');
                return false;
            }
            
            return true;
        }
        
        // Validação em tempo real das senhas
        document.addEventListener('DOMContentLoaded', function() {
            const senha = document.getElementById('senha');
            const confirmarSenha = document.getElementById('confirmarSenha');
            const message = document.getElementById('password-match-message');
            
            function checkPasswordMatch() {
                if (confirmarSenha.value === '') {
                    message.textContent = '';
                    message.className = 'field-message';
                } else if (senha.value === confirmarSenha.value) {
                    message.textContent = 'Senhas coincidem ✓';
                    message.className = 'field-message success';
                } else {
                    message.textContent = 'Senhas não coincidem';
                    message.className = 'field-message error';
                }
            }
            
            senha.addEventListener('input', checkPasswordMatch);
            confirmarSenha.addEventListener('input', checkPasswordMatch);
            
            // Formatação do telefone
            const telefone = document.getElementById('telefone');
            telefone.addEventListener('input', function() {
                let value = this.value.replace(/\D/g, '');
                value = value.replace(/^(\d{2})(\d)/g, '($1) $2');
                value = value.replace(/(\d)(\d{4})$/, '$1-$2');
                this.value = value;
            });
        });
    </script>
</body>
</html>