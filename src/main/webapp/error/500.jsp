<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page isErrorPage="true" %>
<!DOCTYPE html>
<html lang="pt-BR">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Erro Interno do Servidor - Mil Páginas</title>
    <link rel="stylesheet" href="../css/style.css">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
</head>
<body>
    <jsp:include page="../includes/header.jsp" />
    
    <main>
        <div class="container">
            <div class="error-container">
                <div class="error-content">
                    <div class="error-illustration">
                        <i class="fas fa-tools"></i>
                        <div class="error-code">500</div>
                    </div>
                    
                    <div class="error-message">
                        <h1>Oops! Algo deu errado</h1>
                        <p class="error-subtitle">
                            Encontramos um problema interno no servidor. Nossa equipe foi notificada e está trabalhando para resolver isso.
                        </p>
                        <p class="error-description">
                            Tente novamente em alguns minutos ou entre em contato conosco se o problema persistir.
                        </p>
                    </div>
                    
                    <div class="error-actions">
                        <a href="${pageContext.request.contextPath}/" class="btn btn-primary">
                            <i class="fas fa-home"></i> Página Inicial
                        </a>
                        <button onclick="refreshPage()" class="btn btn-outline">
                            <i class="fas fa-sync-alt"></i> Tentar Novamente
                        </button>
                        <button onclick="goBack()" class="btn btn-outline">
                            <i class="fas fa-arrow-left"></i> Voltar
                        </button>
                    </div>
                    
                    <div class="error-suggestions">
                        <h3>O que você pode fazer:</h3>
                        <ul>
                            <li><i class="fas fa-check"></i> Aguardar alguns minutos e tentar novamente</li>
                            <li><i class="fas fa-check"></i> Verificar sua conexão com a internet</li>
                            <li><i class="fas fa-check"></i> Limpar o cache do navegador</li>
                            <li><i class="fas fa-check"></i> Entrar em contato com nosso suporte</li>
                        </ul>
                    </div>
                </div>
                
                <!-- Informações de contato -->
                <div class="contact-info">
                    <h3>Precisa de Ajuda?</h3>
                    <div class="contact-grid">
                        <div class="contact-item">
                            <i class="fas fa-envelope"></i>
                            <div class="contact-content">
                                <strong>E-mail</strong>
                                <span>suporte@milpaginas.com</span>
                            </div>
                        </div>
                        
                        <div class="contact-item">
                            <i class="fas fa-phone"></i>
                            <div class="contact-content">
                                <strong>Telefone</strong>
                                <span>(11) 9999-9999</span>
                            </div>
                        </div>
                        
                        <div class="contact-item">
                            <i class="fas fa-clock"></i>
                            <div class="contact-content">
                                <strong>Horário</strong>
                                <span>Seg-Sex: 8h às 18h</span>
                            </div>
                        </div>
                    </div>
                </div>
                
                <!-- Detalhes técnicos (apenas para desenvolvimento) -->
                <c:if test="${pageContext.request.contextPath eq '/milpaginas' and param.debug eq 'true'}">
                    <div class="error-details">
                        <h3>Detalhes Técnicos (Desenvolvimento)</h3>
                        <div class="technical-info">
                            <div class="info-group">
                                <strong>Timestamp:</strong>
                                <span><%= new java.util.Date() %></span>
                            </div>
                            
                            <c:if test="${not empty pageContext.exception}">
                                <div class="info-group">
                                    <strong>Exceção:</strong>
                                    <span>${pageContext.exception.class.name}</span>
                                </div>
                                
                                <div class="info-group">
                                    <strong>Mensagem:</strong>
                                    <span>${pageContext.exception.message}</span>
                                </div>
                            </c:if>
                            
                            <div class="info-group">
                                <strong>Request URI:</strong>
                                <span>${pageContext.request.requestURI}</span>
                            </div>
                            
                            <div class="info-group">
                                <strong>Query String:</strong>
                                <span>${pageContext.request.queryString}</span>
                            </div>
                            
                            <div class="info-group">
                                <strong>User Agent:</strong>
                                <span>${pageContext.request.getHeader('User-Agent')}</span>
                            </div>
                        </div>
                    </div>
                </c:if>
                
                <!-- Status do sistema -->
                <div class="system-status">
                    <h3>Status dos Serviços</h3>
                    <div class="status-grid">
                        <div class="status-item">
                            <div class="status-indicator status-operational"></div>
                            <span>Website</span>
                        </div>
                        <div class="status-item">
                            <div class="status-indicator status-issue"></div>
                            <span>Servidor de Aplicação</span>
                        </div>
                        <div class="status-item">
                            <div class="status-indicator status-operational"></div>
                            <span>Banco de Dados</span>
                        </div>
                        <div class="status-item">
                            <div class="status-indicator status-operational"></div>
                            <span>Sistema de Pagamentos</span>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </main>
    
    <jsp:include page="../includes/footer.jsp" />
    
    <script>
        function refreshPage() {
            window.location.reload();
        }
        
        function goBack() {
            if (window.history.length > 1) {
                window.history.back();
            } else {
                window.location.href = '${pageContext.request.contextPath}/';
            }
        }
        
        // Adicionar animação aos elementos
        document.addEventListener('DOMContentLoaded', function() {
            const elements = document.querySelectorAll('.error-content > div, .contact-info, .system-status');
            elements.forEach((element, index) => {
                element.style.opacity = '0';
                element.style.transform = 'translateY(20px)';
                
                setTimeout(() => {
                    element.style.transition = 'all 0.6s ease';
                    element.style.opacity = '1';
                    element.style.transform = 'translateY(0)';
                }, index * 200);
            });
        });
        
        // Auto-refresh após 30 segundos (opcional)
        let autoRefreshEnabled = false;
        
        function enableAutoRefresh() {
            if (!autoRefreshEnabled) {
                autoRefreshEnabled = true;
                setTimeout(() => {
                    if (confirm('Tentar recarregar a página automaticamente?')) {
                        refreshPage();
                    }
                }, 30000);
            }
        }
        
        // Habilitar auto-refresh se desejado
        // enableAutoRefresh();
    </script>
    
    <style>
        .error-container {
            max-width: 800px;
            margin: 2rem auto;
            padding: 2rem;
        }
        
        .error-content {
            text-align: center;
            margin-bottom: 3rem;
        }
        
        .error-illustration {
            position: relative;
            margin-bottom: 2rem;
        }
        
        .error-illustration i {
            font-size: 8rem;
            color: var(--warning-color);
            opacity: 0.7;
        }
        
        .error-code {
            position: absolute;
            top: 50%;
            left: 50%;
            transform: translate(-50%, -50%);
            font-size: 4rem;
            font-weight: bold;
            color: white;
            text-shadow: 2px 2px 4px rgba(0,0,0,0.3);
        }
        
        .error-message h1 {
            color: var(--primary-color);
            margin-bottom: 1rem;
            font-size: 2.5rem;
        }
        
        .error-subtitle {
            font-size: 1.2rem;
            color: var(--text-color);
            margin-bottom: 1rem;
        }
        
        .error-description {
            color: var(--text-color);
            margin-bottom: 2rem;
        }
        
        .error-actions {
            display: flex;
            justify-content: center;
            gap: 1rem;
            margin-bottom: 3rem;
            flex-wrap: wrap;
        }
        
        .error-suggestions {
            background: var(--light-bg);
            border-radius: 8px;
            padding: 2rem;
            margin-bottom: 3rem;
            text-align: left;
        }
        
        .error-suggestions h3 {
            color: var(--primary-color);
            margin-bottom: 1rem;
            text-align: center;
        }
        
        .error-suggestions ul {
            list-style: none;
            max-width: 400px;
            margin: 0 auto;
        }
        
        .error-suggestions li {
            margin: 0.5rem 0;
            display: flex;
            align-items: center;
            gap: 0.5rem;
        }
        
        .error-suggestions li i {
            color: var(--success-color);
            font-size: 0.875rem;
        }
        
        .contact-info {
            background: white;
            border-radius: 8px;
            padding: 2rem;
            box-shadow: 0 2px 8px rgba(0,0,0,0.1);
            margin-bottom: 3rem;
        }
        
        .contact-info h3 {
            color: var(--primary-color);
            margin-bottom: 1.5rem;
            text-align: center;
        }
        
        .contact-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
            gap: 1.5rem;
        }
        
        .contact-item {
            display: flex;
            align-items: center;
            gap: 1rem;
            padding: 1rem;
            background: var(--light-bg);
            border-radius: 8px;
        }
        
        .contact-item i {
            font-size: 1.5rem;
            color: var(--secondary-color);
        }
        
        .contact-content {
            display: flex;
            flex-direction: column;
        }
        
        .contact-content strong {
            color: var(--primary-color);
            margin-bottom: 0.25rem;
        }
        
        .contact-content span {
            color: var(--text-color);
            font-size: 0.9rem;
        }
        
        .error-details {
            background: #f8f9fa;
            border: 1px solid #dee2e6;
            border-radius: 8px;
            padding: 2rem;
            margin-bottom: 3rem;
            font-family: monospace;
        }
        
        .error-details h3 {
            color: var(--primary-color);
            margin-bottom: 1.5rem;
            text-align: center;
            font-family: var(--font-family);
        }
        
        .technical-info {
            display: flex;
            flex-direction: column;
            gap: 1rem;
        }
        
        .info-group {
            display: flex;
            gap: 1rem;
        }
        
        .info-group strong {
            min-width: 120px;
            color: var(--primary-color);
        }
        
        .info-group span {
            color: var(--text-color);
            word-break: break-all;
        }
        
        .system-status {
            background: white;
            border-radius: 8px;
            padding: 2rem;
            box-shadow: 0 2px 8px rgba(0,0,0,0.1);
        }
        
        .system-status h3 {
            color: var(--primary-color);
            margin-bottom: 1.5rem;
            text-align: center;
        }
        
        .status-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(150px, 1fr));
            gap: 1rem;
        }
        
        .status-item {
            display: flex;
            align-items: center;
            gap: 0.5rem;
            padding: 0.75rem;
            background: var(--light-bg);
            border-radius: 8px;
        }
        
        .status-indicator {
            width: 12px;
            height: 12px;
            border-radius: 50%;
        }
        
        .status-operational {
            background: var(--success-color);
        }
        
        .status-issue {
            background: var(--warning-color);
        }
        
        .status-down {
            background: var(--danger-color);
        }
        
        @media (max-width: 768px) {
            .error-container {
                padding: 1rem;
            }
            
            .error-illustration i {
                font-size: 6rem;
            }
            
            .error-code {
                font-size: 3rem;
            }
            
            .error-message h1 {
                font-size: 2rem;
            }
            
            .error-actions {
                flex-direction: column;
                align-items: center;
            }
            
            .error-actions .btn {
                width: 200px;
            }
            
            .contact-grid {
                grid-template-columns: 1fr;
            }
            
            .status-grid {
                grid-template-columns: 1fr;
            }
        }
    </style>
</body>
</html>