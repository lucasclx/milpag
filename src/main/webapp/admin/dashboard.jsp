<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="pt-BR">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Dashboard - Administração Mil Páginas</title>
    <link rel="stylesheet" href="../css/style.css">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
</head>
<body>
    <jsp:include page="../includes/header.jsp" />
    
    <main>
        <div class="container">
            <div class="admin-header">
                <h1><i class="fas fa-tachometer-alt"></i> Dashboard Administrativo</h1>
                <p>Painel de controle da livraria Mil Páginas</p>
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
            
            <!-- Cards de Estatísticas -->
            <div class="dashboard-stats">
                <div class="stat-card">
                    <div class="stat-icon">
                        <i class="fas fa-book"></i>
                    </div>
                    <div class="stat-content">
                        <h3>${totalBooks != null ? totalBooks : 0}</h3>
                        <p>Total de Livros</p>
                    </div>
                </div>
                
                <div class="stat-card">
                    <div class="stat-icon">
                        <i class="fas fa-users"></i>
                    </div>
                    <div class="stat-content">
                        <h3>${totalUsers != null ? totalUsers : 0}</h3>
                        <p>Usuários Cadastrados</p>
                    </div>
                </div>
                
                <div class="stat-card">
                    <div class="stat-icon">
                        <i class="fas fa-shopping-bag"></i>
                    </div>
                    <div class="stat-content">
                        <h3>${totalOrders != null ? totalOrders : 0}</h3>
                        <p>Pedidos Realizados</p>
                    </div>
                </div>
                
                <div class="stat-card">
                    <div class="stat-icon">
                        <i class="fas fa-dollar-sign"></i>
                    </div>
                    <div class="stat-content">
                        <h3>
                            <fmt:formatNumber value="${totalRevenue != null ? totalRevenue : 0}" 
                                            type="currency" currencySymbol="R$" />
                        </h3>
                        <p>Receita Total</p>
                    </div>
                </div>
            </div>
            
            <!-- Ações Rápidas -->
            <div class="quick-actions">
                <h2>Ações Rápidas</h2>
                <div class="actions-grid">
                    <a href="../books?action=admin" class="action-card">
                        <i class="fas fa-book"></i>
                        <h3>Gerenciar Livros</h3>
                        <p>Adicionar, editar ou remover livros do catálogo</p>
                    </a>
                    
                    <a href="../orders?action=admin" class="action-card">
                        <i class="fas fa-shopping-bag"></i>
                        <h3>Gerenciar Pedidos</h3>
                        <p>Visualizar e atualizar status dos pedidos</p>
                    </a>
                    
                    <a href="../books?action=add" class="action-card">
                        <i class="fas fa-plus"></i>
                        <h3>Adicionar Livro</h3>
                        <p>Cadastrar novo livro no sistema</p>
                    </a>
                    
                    <a href="../admin/reports" class="action-card">
                        <i class="fas fa-chart-bar"></i>
                        <h3>Relatórios</h3>
                        <p>Visualizar relatórios de vendas e estatísticas</p>
                    </a>
                </div>
            </div>
            
            <!-- Pedidos Recentes -->
            <div class="recent-orders">
                <div class="section-header">
                    <h2>Pedidos Recentes</h2>
                    <a href="../orders?action=admin" class="btn btn-outline btn-small">
                        Ver Todos <i class="fas fa-arrow-right"></i>
                    </a>
                </div>
                
                <c:choose>
                    <c:when test="${not empty recentOrders}">
                        <div class="table-responsive">
                            <table class="table">
                                <thead>
                                    <tr>
                                        <th>Pedido</th>
                                        <th>Cliente</th>
                                        <th>Data</th>
                                        <th>Status</th>
                                        <th>Valor</th>
                                        <th>Ações</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <c:forEach var="order" items="${recentOrders}">
                                        <tr>
                                            <td>#${order.id}</td>
                                            <td>${order.nomeUsuario}</td>
                                            <td>
                                                <fmt:formatDate value="${order.dataPedido}" pattern="dd/MM/yyyy" />
                                            </td>
                                            <td>
                                                <span class="status-badge status-${order.statusPedido.toString().toLowerCase()}">
                                                    ${order.statusPedido}
                                                </span>
                                            </td>
                                            <td>
                                                <fmt:formatNumber value="${order.valorTotal}" type="currency" currencySymbol="R$" />
                                            </td>
                                            <td>
                                                <a href="../orders?action=view&id=${order.id}" class="btn btn-outline btn-small">
                                                    <i class="fas fa-eye"></i>
                                                </a>
                                            </td>
                                        </tr>
                                    </c:forEach>
                                </tbody>
                            </table>
                        </div>
                    </c:when>
                    <c:otherwise>
                        <div class="empty-state">
                            <i class="fas fa-shopping-bag"></i>
                            <h4>Nenhum pedido encontrado</h4>
                            <p>Não há pedidos recentes para exibir.</p>
                        </div>
                    </c:otherwise>
                </c:choose>
            </div>
            
            <!-- Livros com Baixo Estoque -->
            <div class="low-stock">
                <div class="section-header">
                    <h2>Livros com Baixo Estoque</h2>
                    <a href="../books?action=admin" class="btn btn-outline btn-small">
                        Ver Todos <i class="fas fa-arrow-right"></i>
                    </a>
                </div>
                
                <c:choose>
                    <c:when test="${not empty lowStockBooks}">
                        <div class="table-responsive">
                            <table class="table">
                                <thead>
                                    <tr>
                                        <th>Livro</th>
                                        <th>Autor</th>
                                        <th>Estoque</th>
                                        <th>Preço</th>
                                        <th>Ações</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <c:forEach var="book" items="${lowStockBooks}">
                                        <tr>
                                            <td>
                                                <strong>${book.titulo}</strong>
                                            </td>
                                            <td>${book.autor}</td>
                                            <td>
                                                <span class="stock-warning">${book.quantidadeEstoque} unidades</span>
                                            </td>
                                            <td>
                                                <fmt:formatNumber value="${book.preco}" type="currency" currencySymbol="R$" />
                                            </td>
                                            <td>
                                                <a href="../books?action=edit&id=${book.id}" class="btn btn-outline btn-small">
                                                    <i class="fas fa-edit"></i>
                                                </a>
                                            </td>
                                        </tr>
                                    </c:forEach>
                                </tbody>
                            </table>
                        </div>
                    </c:when>
                    <c:otherwise>
                        <div class="empty-state">
                            <i class="fas fa-check-circle"></i>
                            <h4>Estoque em dia</h4>
                            <p>Todos os livros estão com estoque adequado.</p>
                        </div>
                    </c:otherwise>
                </c:choose>
            </div>
        </div>
    </main>
    
    <jsp:include page="../includes/footer.jsp" />
    
    <style>
        .admin-header {
            text-align: center;
            margin: 2rem 0;
        }
        
        .admin-header h1 {
            color: var(--primary-color);
            margin-bottom: 0.5rem;
        }
        
        .dashboard-stats {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(250px, 1fr));
            gap: 1.5rem;
            margin: 2rem 0;
        }
        
        .stat-card {
            background: white;
            border-radius: 8px;
            padding: 1.5rem;
            box-shadow: 0 2px 8px rgba(0,0,0,0.1);
            display: flex;
            align-items: center;
            gap: 1rem;
            transition: transform 0.3s;
        }
        
        .stat-card:hover {
            transform: translateY(-2px);
        }
        
        .stat-icon {
            width: 60px;
            height: 60px;
            border-radius: 50%;
            background: var(--secondary-color);
            display: flex;
            align-items: center;
            justify-content: center;
            color: white;
            font-size: 1.5rem;
        }
        
        .stat-content h3 {
            margin: 0 0 0.25rem 0;
            font-size: 2rem;
            color: var(--primary-color);
        }
        
        .stat-content p {
            margin: 0;
            color: var(--text-color);
            font-size: 0.875rem;
        }
        
        .quick-actions,
        .recent-orders,
        .low-stock {
            margin: 3rem 0;
        }
        
        .quick-actions h2,
        .recent-orders h2,
        .low-stock h2 {
            color: var(--primary-color);
            margin-bottom: 1.5rem;
        }
        
        .actions-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(250px, 1fr));
            gap: 1.5rem;
        }
        
        .action-card {
            background: white;
            border-radius: 8px;
            padding: 2rem;
            text-decoration: none;
            color: inherit;
            box-shadow: 0 2px 8px rgba(0,0,0,0.1);
            transition: all 0.3s;
            text-align: center;
        }
        
        .action-card:hover {
            transform: translateY(-4px);
            box-shadow: 0 4px 16px rgba(0,0,0,0.15);
            color: inherit;
        }
        
        .action-card i {
            font-size: 2.5rem;
            color: var(--secondary-color);
            margin-bottom: 1rem;
        }
        
        .action-card h3 {
            margin: 0 0 0.5rem 0;
            color: var(--primary-color);
        }
        
        .action-card p {
            margin: 0;
            color: var(--text-color);
            font-size: 0.875rem;
        }
        
        .section-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 1.5rem;
        }
        
        .section-header h2 {
            margin: 0;
        }
        
        .table-responsive {
            background: white;
            border-radius: 8px;
            overflow: hidden;
            box-shadow: 0 2px 8px rgba(0,0,0,0.1);
        }
        
        .stock-warning {
            color: var(--warning-color);
            font-weight: 600;
        }
        
        .empty-state {
            text-align: center;
            padding: 3rem 1rem;
            background: white;
            border-radius: 8px;
            box-shadow: 0 2px 8px rgba(0,0,0,0.1);
        }
        
        .empty-state i {
            font-size: 3rem;
            color: var(--border-color);
            margin-bottom: 1rem;
        }
        
        .empty-state h4 {
            color: var(--primary-color);
            margin-bottom: 0.5rem;
        }
        
        .empty-state p {
            color: var(--text-color);
        }
        
        @media (max-width: 768px) {
            .dashboard-stats {
                grid-template-columns: 1fr;
            }
            
            .actions-grid {
                grid-template-columns: 1fr;
            }
            
            .section-header {
                flex-direction: column;
                gap: 1rem;
                align-items: flex-start;
            }
        }
    </style>
</body>
</html>