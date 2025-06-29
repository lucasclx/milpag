<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="pt-BR">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Gerenciar Pedidos - Administração Mil Páginas</title>
    <link rel="stylesheet" href="../css/style.css">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
</head>
<body>
    <jsp:include page="../includes/header.jsp" />
    
    <main>
        <div class="container">
            <div class="admin-header">
                <h1><i class="fas fa-shopping-bag"></i> Gerenciar Pedidos</h1>
                <p>Visualize e gerencie todos os pedidos da loja</p>
            </div>
            
            <!-- Mensagens -->
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
            
            <!-- Filtros -->
            <div class="orders-filters">
                <div class="filters-card">
                    <h3><i class="fas fa-filter"></i> Filtros</h3>
                    
                    <form action="../orders" method="get" class="filters-form">
                        <input type="hidden" name="action" value="admin">
                        
                        <div class="filter-row">
                            <div class="filter-group">
                                <label for="status" class="form-label">Status do Pedido:</label>
                                <select id="status" name="status" class="form-control">
                                    <option value="">Todos os Status</option>
                                    <option value="PENDENTE" ${selectedStatus == 'PENDENTE' ? 'selected' : ''}>Pendente</option>
                                    <option value="PROCESSANDO" ${selectedStatus == 'PROCESSANDO' ? 'selected' : ''}>Processando</option>
                                    <option value="ENVIADO" ${selectedStatus == 'ENVIADO' ? 'selected' : ''}>Enviado</option>
                                    <option value="ENTREGUE" ${selectedStatus == 'ENTREGUE' ? 'selected' : ''}>Entregue</option>
                                    <option value="CANCELADO" ${selectedStatus == 'CANCELADO' ? 'selected' : ''}>Cancelado</option>
                                </select>
                            </div>
                            
                            <div class="filter-group">
                                <label for="dateFrom" class="form-label">Data Inicial:</label>
                                <input type="date" id="dateFrom" name="dateFrom" class="form-control" value="${dateFrom}">
                            </div>
                            
                            <div class="filter-group">
                                <label for="dateTo" class="form-label">Data Final:</label>
                                <input type="date" id="dateTo" name="dateTo" class="form-control" value="${dateTo}">
                            </div>
                            
                            <div class="filter-actions">
                                <button type="submit" class="btn btn-primary">
                                    <i class="fas fa-search"></i> Filtrar
                                </button>
                                <a href="../orders?action=admin" class="btn btn-outline">
                                    <i class="fas fa-times"></i> Limpar
                                </a>
                            </div>
                        </div>
                    </form>
                </div>
            </div>
            
            <!-- Estatísticas Rápidas -->
            <div class="orders-stats">
                <div class="stat-item">
                    <i class="fas fa-clock"></i>
                    <div class="stat-content">
                        <span class="stat-number">${pendingCount != null ? pendingCount : 0}</span>
                        <span class="stat-label">Pendentes</span>
                    </div>
                </div>
                <div class="stat-item">
                    <i class="fas fa-cog"></i>
                    <div class="stat-content">
                        <span class="stat-number">${processingCount != null ? processingCount : 0}</span>
                        <span class="stat-label">Processando</span>
                    </div>
                </div>
                <div class="stat-item">
                    <i class="fas fa-shipping-fast"></i>
                    <div class="stat-content">
                        <span class="stat-number">${shippedCount != null ? shippedCount : 0}</span>
                        <span class="stat-label">Enviados</span>
                    </div>
                </div>
                <div class="stat-item">
                    <i class="fas fa-check-circle"></i>
                    <div class="stat-content">
                        <span class="stat-number">${deliveredCount != null ? deliveredCount : 0}</span>
                        <span class="stat-label">Entregues</span>
                    </div>
                </div>
            </div>
            
            <!-- Lista de Pedidos -->
            <div class="orders-list">
                <c:choose>
                    <c:when test="${not empty orders}">
                        <div class="table-responsive">
                            <table class="table">
                                <thead>
                                    <tr>
                                        <th>Pedido</th>
                                        <th>Cliente</th>
                                        <th>Data</th>
                                        <th>Status</th>
                                        <th>Valor Total</th>
                                        <th>Ações</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <c:forEach var="order" items="${orders}">
                                        <tr>
                                            <td>
                                                <strong>#${order.id}</strong>
                                            </td>
                                            <td>
                                                <div class="customer-info">
                                                    <strong>${order.nomeUsuario}</strong>
                                                    <small>${order.emailUsuario}</small>
                                                </div>
                                            </td>
                                            <td>
                                                <div class="order-date">
                                                    <strong>
                                                        <fmt:formatDate value="${order.dataPedido}" pattern="dd/MM/yyyy" />
                                                    </strong>
                                                    <small>
                                                        <fmt:formatDate value="${order.dataPedido}" pattern="HH:mm" />
                                                    </small>
                                                </div>
                                            </td>
                                            <td>
                                                <div class="status-container">
                                                    <span class="status-badge status-${order.statusPedido.toString().toLowerCase()}">
                                                        ${order.statusPedido}
                                                    </span>
                                                    <div class="status-actions">
                                                        <select class="status-select" data-order-id="${order.id}">
                                                            <option value="PENDENTE" ${order.statusPedido == 'PENDENTE' ? 'selected' : ''}>Pendente</option>
                                                            <option value="PROCESSANDO" ${order.statusPedido == 'PROCESSANDO' ? 'selected' : ''}>Processando</option>
                                                            <option value="ENVIADO" ${order.statusPedido == 'ENVIADO' ? 'selected' : ''}>Enviado</option>
                                                            <option value="ENTREGUE" ${order.statusPedido == 'ENTREGUE' ? 'selected' : ''}>Entregue</option>
                                                            <option value="CANCELADO" ${order.statusPedido == 'CANCELADO' ? 'selected' : ''}>Cancelado</option>
                                                        </select>
                                                        <button type="button" class="btn-update-status" 
                                                                onclick="updateOrderStatus(${order.id})" 
                                                                style="display: none;">
                                                            <i class="fas fa-save"></i>
                                                        </button>
                                                    </div>
                                                </div>
                                            </td>
                                            <td>
                                                <strong class="order-total">
                                                    <fmt:formatNumber value="${order.valorTotal}" type="currency" currencySymbol="R$" />
                                                </strong>
                                            </td>
                                            <td>
                                                <div class="order-actions">
                                                    <a href="../orders?action=view&id=${order.id}" 
                                                       class="btn btn-outline btn-small" title="Ver Detalhes">
                                                        <i class="fas fa-eye"></i>
                                                    </a>
                                                    <button type="button" class="btn btn-outline btn-small" 
                                                            onclick="printOrder(${order.id})" title="Imprimir">
                                                        <i class="fas fa-print"></i>
                                                    </button>
                                                </div>
                                            </td>
                                        </tr>
                                    </c:forEach>
                                </tbody>
                            </table>
                        </div>
                        
                        <!-- Paginação -->
                        <c:if test="${totalPages > 1}">
                            <div class="pagination">
                                <c:if test="${currentPage > 1}">
                                    <a href="../orders?action=admin&page=${currentPage - 1}&status=${selectedStatus}" 
                                       class="btn btn-outline btn-small">
                                        <i class="fas fa-chevron-left"></i> Anterior
                                    </a>
                                </c:if>
                                
                                <span class="pagination-info">
                                    Página ${currentPage} de ${totalPages}
                                </span>
                                
                                <c:if test="${currentPage < totalPages}">
                                    <a href="../orders?action=admin&page=${currentPage + 1}&status=${selectedStatus}" 
                                       class="btn btn-outline btn-small">
                                        Próxima <i class="fas fa-chevron-right"></i>
                                    </a>
                                </c:if>
                            </div>
                        </c:if>
                    </c:when>
                    <c:otherwise>
                        <div class="empty-state">
                            <i class="fas fa-shopping-bag"></i>
                            <h4>Nenhum pedido encontrado</h4>
                            <p>Não há pedidos que correspondam aos filtros selecionados.</p>
                            <a href="../orders?action=admin" class="btn btn-primary">
                                <i class="fas fa-refresh"></i> Ver Todos os Pedidos
                            </a>
                        </div>
                    </c:otherwise>
                </c:choose>
            </div>
        </div>
    </main>
    
    <jsp:include page="../includes/footer.jsp" />
    
    <script>
        // Controle de mudança de status
        document.addEventListener('DOMContentLoaded', function() {
            const statusSelects = document.querySelectorAll('.status-select');
            
            statusSelects.forEach(select => {
                const originalValue = select.value;
                const updateBtn = select.parentNode.querySelector('.btn-update-status');
                
                select.addEventListener('change', function() {
                    if (this.value !== originalValue) {
                        updateBtn.style.display = 'inline-block';
                    } else {
                        updateBtn.style.display = 'none';
                    }
                });
            });
        });
        
        // Atualizar status do pedido
        function updateOrderStatus(orderId) {
            const select = document.querySelector(`[data-order-id="${orderId}"]`);
            const newStatus = select.value;
            
            if (confirm(`Confirma a alteração do status para "${newStatus}"?`)) {
                const form = document.createElement('form');
                form.method = 'POST';
                form.action = '../orders';
                
                const actionInput = document.createElement('input');
                actionInput.type = 'hidden';
                actionInput.name = 'action';
                actionInput.value = 'updateStatus';
                
                const orderIdInput = document.createElement('input');
                orderIdInput.type = 'hidden';
                orderIdInput.name = 'orderId';
                orderIdInput.value = orderId;
                
                const statusInput = document.createElement('input');
                statusInput.type = 'hidden';
                statusInput.name = 'newStatus';
                statusInput.value = newStatus;
                
                form.appendChild(actionInput);
                form.appendChild(orderIdInput);
                form.appendChild(statusInput);
                document.body.appendChild(form);
                form.submit();
            }
        }
        
        // Imprimir pedido (placeholder)
        function printOrder(orderId) {
            alert('Funcionalidade de impressão será implementada em breve.');
        }
    </script>
    
    <style>
        .admin-header {
            text-align: center;
            margin: 2rem 0;
        }
        
        .admin-header h1 {
            color: var(--primary-color);
            margin-bottom: 0.5rem;
        }
        
        .orders-filters {
            margin: 2rem 0;
        }
        
        .filters-card {
            background: white;
            border-radius: 8px;
            padding: 1.5rem;
            box-shadow: 0 2px 8px rgba(0,0,0,0.1);
        }
        
        .filters-card h3 {
            margin: 0 0 1.5rem 0;
            color: var(--primary-color);
        }
        
        .filter-row {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
            gap: 1rem;
            align-items: end;
        }
        
        .filter-group {
            display: flex;
            flex-direction: column;
        }
        
        .filter-actions {
            display: flex;
            gap: 0.5rem;
        }
        
        .orders-stats {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
            gap: 1rem;
            margin: 2rem 0;
        }
        
        .stat-item {
            background: white;
            border-radius: 8px;
            padding: 1.5rem;
            box-shadow: 0 2px 8px rgba(0,0,0,0.1);
            display: flex;
            align-items: center;
            gap: 1rem;
        }
        
        .stat-item i {
            font-size: 2rem;
            color: var(--secondary-color);
        }
        
        .stat-content {
            display: flex;
            flex-direction: column;
        }
        
        .stat-number {
            font-size: 1.5rem;
            font-weight: bold;
            color: var(--primary-color);
        }
        
        .stat-label {
            font-size: 0.875rem;
            color: var(--text-color);
        }
        
        .orders-list {
            margin: 2rem 0;
        }
        
        .table-responsive {
            background: white;
            border-radius: 8px;
            overflow: hidden;
            box-shadow: 0 2px 8px rgba(0,0,0,0.1);
        }
        
        .customer-info {
            display: flex;
            flex-direction: column;
        }
        
        .customer-info small {
            color: var(--text-color);
            font-size: 0.8rem;
        }
        
        .order-date {
            display: flex;
            flex-direction: column;
        }
        
        .order-date small {
            color: var(--text-color);
            font-size: 0.8rem;
        }
        
        .status-container {
            display: flex;
            flex-direction: column;
            gap: 0.5rem;
        }
        
        .status-actions {
            display: flex;
            align-items: center;
            gap: 0.5rem;
        }
        
        .status-select {
            font-size: 0.8rem;
            padding: 0.25rem 0.5rem;
            border: 1px solid var(--border-color);
            border-radius: 4px;
            background: white;
        }
        
        .btn-update-status {
            background: var(--success-color);
            color: white;
            border: none;
            padding: 0.25rem 0.5rem;
            border-radius: 4px;
            cursor: pointer;
            font-size: 0.8rem;
        }
        
        .btn-update-status:hover {
            background: #229954;
        }
        
        .order-total {
            color: var(--success-color);
        }
        
        .order-actions {
            display: flex;
            gap: 0.5rem;
        }
        
        .pagination {
            display: flex;
            justify-content: space-between;
            align-items: center;
            padding: 1rem;
            background: white;
            border-radius: 8px;
            box-shadow: 0 2px 8px rgba(0,0,0,0.1);
            margin-top: 1rem;
        }
        
        .pagination-info {
            color: var(--text-color);
            font-weight: 500;
        }
        
        .empty-state {
            text-align: center;
            padding: 4rem 2rem;
            background: white;
            border-radius: 8px;
            box-shadow: 0 2px 8px rgba(0,0,0,0.1);
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
            .filter-row {
                grid-template-columns: 1fr;
            }
            
            .filter-actions {
                flex-direction: column;
            }
            
            .orders-stats {
                grid-template-columns: 1fr;
            }
            
            .pagination {
                flex-direction: column;
                gap: 1rem;
            }
            
            .order-actions {
                flex-direction: column;
            }
        }
    </style>
</body>
</html>