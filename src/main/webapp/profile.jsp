<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="pt-BR">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Meu Perfil - Mil Páginas</title>
    <link rel="stylesheet" href="css/style.css">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
</head>
<body>
    <jsp:include page="includes/header.jsp" />
    
    <main>
        <div class="container">
            <div class="profile-header">
                <h1><i class="fas fa-user"></i> Meu Perfil</h1>
                <p>Gerencie suas informações pessoais e preferências</p>
            </div>
            
            <!-- Mensagens de sucesso/erro -->
            <c:if test="${not empty success}">
                <div class="alert alert-success">
                    <i class="fas fa-check-circle"></i> ${success}
                </div>
            </c:if>
            
            <c:if test="${not empty error}">
                <div class="alert alert-danger">
                    <i class="fas fa-exclamation-circle"></i> ${error}
                </div>
            </c:if>
            
            <div class="profile-container">
                <!-- Menu lateral -->
                <div class="profile-sidebar">
                    <div class="profile-menu">
                        <a href="#info" class="profile-menu-item active" onclick="showTab('info')">
                            <i class="fas fa-user"></i> Informações Pessoais
                        </a>
                        <a href="#orders" class="profile-menu-item" onclick="showTab('orders')">
                            <i class="fas fa-shopping-bag"></i> Meus Pedidos
                        </a>
                        <a href="#password" class="profile-menu-item" onclick="showTab('password')">
                            <i class="fas fa-lock"></i> Alterar Senha
                        </a>
                    </div>
                </div>
                
                <!-- Conteúdo principal -->
                <div class="profile-content">
                    <!-- Aba Informações Pessoais -->
                    <div id="info-tab" class="profile-tab active">
                        <div class="card">
                            <div class="card-body">
                                <h3><i class="fas fa-user"></i> Informações Pessoais</h3>
                                
                                <form action="profile" method="post" class="profile-form">
                                    <input type="hidden" name="action" value="updateInfo">
                                    
                                    <div class="form-group">
                                        <label for="nome" class="form-label">Nome Completo:</label>
                                        <input type="text" id="nome" name="nome" class="form-control" 
                                               value="${sessionScope.user.nome}" required>
                                    </div>
                                    
                                    <div class="form-group">
                                        <label for="email" class="form-label">E-mail:</label>
                                        <input type="email" id="email" name="email" class="form-control" 
                                               value="${sessionScope.user.email}" required>
                                    </div>
                                    
                                    <div class="form-group">
                                        <label for="telefone" class="form-label">Telefone:</label>
                                        <input type="tel" id="telefone" name="telefone" class="form-control" 
                                               value="${sessionScope.user.telefone}" placeholder="(11) 99999-9999">
                                    </div>
                                    
                                    <div class="form-group">
                                        <label for="endereco" class="form-label">Endereço:</label>
                                        <textarea id="endereco" name="endereco" class="form-control" 
                                                  rows="3" placeholder="Rua, número, bairro, cidade, CEP">${sessionScope.user.endereco}</textarea>
                                    </div>
                                    
                                    <div class="form-group">
                                        <button type="submit" class="btn btn-primary">
                                            <i class="fas fa-save"></i> Salvar Alterações
                                        </button>
                                    </div>
                                </form>
                            </div>
                        </div>
                    </div>
                    
                    <!-- Aba Meus Pedidos -->
                    <div id="orders-tab" class="profile-tab">
                        <div class="card">
                            <div class="card-body">
                                <h3><i class="fas fa-shopping-bag"></i> Meus Pedidos</h3>
                                
                                <c:choose>
                                    <c:when test="${not empty userOrders}">
                                        <div class="orders-list">
                                            <c:forEach var="order" items="${userOrders}">
                                                <div class="order-item">
                                                    <div class="order-header">
                                                        <div class="order-info">
                                                            <h4>Pedido #${order.id}</h4>
                                                            <p class="order-date">
                                                                <fmt:formatDate value="${order.dataPedido}" pattern="dd/MM/yyyy HH:mm" />
                                                            </p>
                                                        </div>
                                                        <div class="order-status">
                                                            <span class="status-badge status-${order.statusPedido.toString().toLowerCase()}">
                                                                ${order.statusPedido}
                                                            </span>
                                                        </div>
                                                        <div class="order-total">
                                                            <fmt:formatNumber value="${order.valorTotal}" type="currency" currencySymbol="R$" />
                                                        </div>
                                                    </div>
                                                    <div class="order-actions">
                                                        <a href="orders?action=view&id=${order.id}" class="btn btn-outline btn-small">
                                                            <i class="fas fa-eye"></i> Ver Detalhes
                                                        </a>
                                                    </div>
                                                </div>
                                            </c:forEach>
                                        </div>
                                    </c:when>
                                    <c:otherwise>
                                        <div class="empty-state">
                                            <i class="fas fa-shopping-bag"></i>
                                            <h4>Nenhum pedido encontrado</h4>
                                            <p>Você ainda não fez nenhum pedido.</p>
                                            <a href="books" class="btn btn-primary">
                                                <i class="fas fa-shopping-cart"></i> Começar a Comprar
                                            </a>
                                        </div>
                                    </c:otherwise>
                                </c:choose>
                            </div>
                        </div>
                    </div>
                    
                    <!-- Aba Alterar Senha -->
                    <div id="password-tab" class="profile-tab">
                        <div class="card">
                            <div class="card-body">
                                <h3><i class="fas fa-lock"></i> Alterar Senha</h3>
                                
                                <form action="profile" method="post" class="profile-form">
                                    <input type="hidden" name="action" value="changePassword">
                                    
                                    <div class="form-group">
                                        <label for="currentPassword" class="form-label">Senha Atual:</label>
                                        <input type="password" id="currentPassword" name="currentPassword" 
                                               class="form-control" required>
                                    </div>
                                    
                                    <div class="form-group">
                                        <label for="newPassword" class="form-label">Nova Senha:</label>
                                        <input type="password" id="newPassword" name="newPassword" 
                                               class="form-control" minlength="6" required>
                                        <small class="form-text">A senha deve ter pelo menos 6 caracteres.</small>
                                    </div>
                                    
                                    <div class="form-group">
                                        <label for="confirmPassword" class="form-label">Confirmar Nova Senha:</label>
                                        <input type="password" id="confirmPassword" name="confirmPassword" 
                                               class="form-control" minlength="6" required>
                                    </div>
                                    
                                    <div class="form-group">
                                        <button type="submit" class="btn btn-primary">
                                            <i class="fas fa-save"></i> Alterar Senha
                                        </button>
                                    </div>
                                </form>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </main>
    
    <jsp:include page="includes/footer.jsp" />
    
    <script>
        function showTab(tabName) {
            // Esconder todas as abas
            const tabs = document.querySelectorAll('.profile-tab');
            tabs.forEach(tab => tab.classList.remove('active'));
            
            // Remover classe active dos itens do menu
            const menuItems = document.querySelectorAll('.profile-menu-item');
            menuItems.forEach(item => item.classList.remove('active'));
            
            // Mostrar aba selecionada
            document.getElementById(tabName + '-tab').classList.add('active');
            
            // Adicionar classe active ao item do menu clicado
            event.target.closest('.profile-menu-item').classList.add('active');
        }
        
        // Validação de confirmação de senha
        document.getElementById('confirmPassword').addEventListener('input', function() {
            const newPassword = document.getElementById('newPassword').value;
            const confirmPassword = this.value;
            
            if (newPassword !== confirmPassword) {
                this.setCustomValidity('As senhas não coincidem');
            } else {
                this.setCustomValidity('');
            }
        });
    </script>
    
    <style>
        .profile-header {
            text-align: center;
            margin: 2rem 0;
        }
        
        .profile-header h1 {
            color: var(--primary-color);
            margin-bottom: 0.5rem;
        }
        
        .profile-container {
            display: grid;
            grid-template-columns: 250px 1fr;
            gap: 2rem;
            margin: 2rem 0;
        }
        
        .profile-sidebar {
            background: white;
            border-radius: 8px;
            box-shadow: 0 2px 8px rgba(0,0,0,0.1);
            height: fit-content;
        }
        
        .profile-menu {
            padding: 1rem 0;
        }
        
        .profile-menu-item {
            display: block;
            padding: 1rem 1.5rem;
            color: var(--text-color);
            text-decoration: none;
            border-left: 3px solid transparent;
            transition: all 0.3s;
        }
        
        .profile-menu-item:hover,
        .profile-menu-item.active {
            background: var(--light-bg);
            border-left-color: var(--secondary-color);
            color: var(--secondary-color);
        }
        
        .profile-menu-item i {
            margin-right: 0.5rem;
            width: 16px;
        }
        
        .profile-content {
            min-height: 500px;
        }
        
        .profile-tab {
            display: none;
        }
        
        .profile-tab.active {
            display: block;
        }
        
        .profile-form .form-group {
            margin-bottom: 1.5rem;
        }
        
        .form-text {
            color: var(--text-color);
            font-size: 0.875rem;
            margin-top: 0.25rem;
        }
        
        .orders-list {
            display: flex;
            flex-direction: column;
            gap: 1rem;
        }
        
        .order-item {
            border: 1px solid var(--border-color);
            border-radius: 8px;
            padding: 1.5rem;
            transition: box-shadow 0.3s;
        }
        
        .order-item:hover {
            box-shadow: 0 4px 12px rgba(0,0,0,0.1);
        }
        
        .order-header {
            display: grid;
            grid-template-columns: 1fr auto auto;
            gap: 1rem;
            align-items: center;
            margin-bottom: 1rem;
        }
        
        .order-info h4 {
            margin: 0 0 0.25rem 0;
            color: var(--primary-color);
        }
        
        .order-date {
            margin: 0;
            color: var(--text-color);
            font-size: 0.875rem;
        }
        
        .status-badge {
            padding: 0.25rem 0.75rem;
            border-radius: 20px;
            font-size: 0.75rem;
            font-weight: 600;
            text-transform: uppercase;
        }
        
        .status-pendente {
            background: #fff3cd;
            color: #856404;
        }
        
        .status-processando {
            background: #cff4fc;
            color: #087990;
        }
        
        .status-enviado {
            background: #d1ecf1;
            color: #0c5460;
        }
        
        .status-entregue {
            background: #d4edda;
            color: #155724;
        }
        
        .status-cancelado {
            background: #f8d7da;
            color: #721c24;
        }
        
        .order-total {
            font-size: 1.25rem;
            font-weight: bold;
            color: var(--success-color);
        }
        
        .empty-state {
            text-align: center;
            padding: 3rem 1rem;
        }
        
        .empty-state i {
            font-size: 4rem;
            color: var(--border-color);
            margin-bottom: 1rem;
        }
        
        .empty-state h4 {
            color: var(--primary-color);
            margin-bottom: 0.5rem;
        }
        
        .empty-state p {
            color: var(--text-color);
            margin-bottom: 1.5rem;
        }
        
        @media (max-width: 768px) {
            .profile-container {
                grid-template-columns: 1fr;
                gap: 1rem;
            }
            
            .order-header {
                grid-template-columns: 1fr;
                gap: 0.5rem;
                text-align: center;
            }
        }
    </style>
</body>
</html>