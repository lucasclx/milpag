<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<c:set var="contextPath" value="${pageContext.request.contextPath}" />

<!DOCTYPE html>
<html lang="pt-BR">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Catálogo de Livros - Mil Páginas</title>
    <link rel="stylesheet" href="${contextPath}/css/style.css">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
</head>
<body>
    <jsp:include page="includes/header.jsp" />
    
    <main>
        <div class="container">
            <!-- Cabeçalho da página -->
            <div class="page-header">
                <h1><i class="fas fa-book"></i> Catálogo de Livros</h1>
                <c:if test="${not empty searchTerm}">
                    <p class="search-results">
                        Resultados para: "<strong>${searchTerm}</strong>"
                        <c:if test="${not empty searchType}">
                            em <strong>
                                <c:choose>
                                    <c:when test="${searchType == 'title'}">Título</c:when>
                                    <c:when test="${searchType == 'author'}">Autor</c:when>
                                    <c:when test="${searchType == 'publisher'}">Editora</c:when>
                                    <c:otherwise>Todos os campos</c:otherwise>
                                </c:choose>
                            </strong>
                        </c:if>
                    </p>
                </c:if>
            </div>
            
            <!-- Filtros e busca -->
            <div class="catalog-filters">
                <form action="${contextPath}/books" method="get" class="filter-form">
                    <input type="hidden" name="action" value="search">
                    <div class="filter-row">
                        <select name="type" class="form-control">
                            <option value="">Buscar em todos</option>
                            <option value="title" ${searchType == 'title' ? 'selected' : ''}>Título</option>
                            <option value="author" ${searchType == 'author' ? 'selected' : ''}>Autor</option>
                            <option value="publisher" ${searchType == 'publisher' ? 'selected' : ''}>Editora</option>
                        </select>
                        <input type="text" name="q" placeholder="Digite sua busca..." 
                               class="form-control" value="${searchTerm}">
                        <button type="submit" class="btn btn-primary">
                            <i class="fas fa-search"></i> Buscar
                        </button>
                        <c:if test="${not empty searchTerm}">
                            <a href="${contextPath}/books" class="btn btn-outline">
                                <i class="fas fa-times"></i> Limpar
                            </a>
                        </c:if>
                    </div>
                </form>
            </div>
            
            <!-- Informações do catálogo -->
            <div class="catalog-info">
                <span class="results-count">
                    <c:choose>
                        <c:when test="${not empty totalBooks}">
                            ${totalBooks} livros encontrados
                        </c:when>
                        <c:otherwise>
                            ${not empty books ? books.size() : 0} livros encontrados
                        </c:otherwise>
                    </c:choose>
                </span>
                
                <c:if test="${sessionScope.isAdmin}">
                    <a href="${contextPath}/books?action=add" class="btn btn-success">
                        <i class="fas fa-plus"></i> Adicionar Livro
                    </a>
                </c:if>
            </div>
            
            <!-- Lista de livros -->
            <c:choose>
                <c:when test="${empty books}">
                    <div class="empty-state">
                        <i class="fas fa-search"></i>
                        <h3>Nenhum livro encontrado</h3>
                        <p>Tente ajustar sua busca ou navegue por nossa seleção completa.</p>
                        <a href="${contextPath}/books" class="btn btn-primary">Ver Todos os Livros</a>
                    </div>
                </c:when>
                <c:otherwise>
                    <div class="books-grid">
                        <c:forEach var="book" items="${books}">
                            <div class="book-card" data-book-id="${book.id}">
                                <div class="book-image">
                                    <c:choose>
                                        <c:when test="${not empty book.urlCapa}">
                                            <img src="${book.urlCapa}" alt="${book.titulo}" 
                                                 onerror="this.src='${contextPath}/images/book-placeholder.jpg'">
                                        </c:when>
                                        <c:otherwise>
                                            <div class="book-placeholder">
                                                <i class="fas fa-book"></i>
                                            </div>
                                        </c:otherwise>
                                    </c:choose>
                                    <c:if test="${book.quantidadeEstoque == 0}">
                                        <div class="out-of-stock-badge">Esgotado</div>
                                    </c:if>
                                </div>
                                
                                <div class="book-info">
                                    <h3 class="book-title">
                                        <a href="${contextPath}/books?action=view&id=${book.id}">${book.titulo}</a>
                                    </h3>
                                    <p class="book-author">por ${book.autor}</p>
                                    <c:if test="${not empty book.editora}">
                                        <p class="book-publisher">${book.editora}</p>
                                    </c:if>
                                    
                                    <div class="book-price">
                                        <fmt:formatNumber value="${book.preco}" type="currency" currencySymbol="R$" />
                                    </div>
                                    
                                    <div class="book-stock">
                                        <c:choose>
                                            <c:when test="${book.quantidadeEstoque > 0}">
                                                <span class="in-stock">
                                                    <i class="fas fa-check-circle"></i>
                                                    ${book.quantidadeEstoque} em estoque
                                                </span>
                                            </c:when>
                                            <c:otherwise>
                                                <span class="out-of-stock">
                                                    <i class="fas fa-times-circle"></i>
                                                    Esgotado
                                                </span>
                                            </c:otherwise>
                                        </c:choose>
                                    </div>
                                    
                                    <div class="book-actions">
                                        <!-- Botão Ver Detalhes -->
                                        <a href="${contextPath}/books?action=view&id=${book.id}" 
                                           class="btn btn-outline btn-sm">
                                            <i class="fas fa-eye"></i> Ver Detalhes
                                        </a>
                                        
                                        <!-- Botão Adicionar ao Carrinho -->
                                        <c:if test="${book.quantidadeEstoque > 0}">
                                            <button type="button" 
                                                    class="btn btn-primary btn-sm add-to-cart-btn" 
                                                    data-book-id="${book.id}"
                                                    title="Adicionar ao carrinho">
                                                <i class="fas fa-cart-plus"></i> Adicionar
                                            </button>
                                        </c:if>
                                        
                                        <!-- Botões Admin -->
                                        <c:if test="${sessionScope.isAdmin}">
                                            <a href="${contextPath}/books?action=edit&id=${book.id}" 
                                               class="btn btn-warning btn-sm"
                                               title="Editar livro">
                                                <i class="fas fa-edit"></i> Editar
                                            </a>
                                            <button type="button" 
                                                    class="btn btn-danger btn-sm delete-book-btn" 
                                                    data-book-id="${book.id}"
                                                    data-book-title="${book.titulo}"
                                                    title="Excluir livro">
                                                <i class="fas fa-trash-alt"></i> Excluir
                                            </button>
                                        </c:if>
                                    </div>
                                </div>
                            </div>
                        </c:forEach>
                    </div>
                    
                    <!-- Paginação -->
                    <c:if test="${not empty totalPages && totalPages > 1}">
                        <div class="pagination">
                            <c:if test="${currentPage > 1}">
                                <a href="${contextPath}/books?page=${currentPage - 1}" class="page-btn">
                                    <i class="fas fa-chevron-left"></i> Anterior
                                </a>
                            </c:if>
                            
                            <span class="page-info">
                                Página ${currentPage} de ${totalPages}
                            </span>
                            
                            <c:if test="${currentPage < totalPages}">
                                <a href="${contextPath}/books?page=${currentPage + 1}" class="page-btn">
                                    Próxima <i class="fas fa-chevron-right"></i>
                                </a>
                            </c:if>
                        </div>
                    </c:if>
                </c:otherwise>
            </c:choose>
        </div>
    </main>
    
    <jsp:include page="includes/footer.jsp" />
    
    <script src="${contextPath}/js/script.js"></script>
    <script>
        // Script específico para a página de livros
        document.addEventListener('DOMContentLoaded', function() {
            console.log('Página de livros carregada');
            
            // Verificar se os botões foram encontrados
            const addToCartButtons = document.querySelectorAll('.add-to-cart-btn');
            const deleteButtons = document.querySelectorAll('.delete-book-btn');
            
            console.log(`Encontrados ${addToCartButtons.length} botões de carrinho`);
            console.log(`Encontrados ${deleteButtons.length} botões de exclusão`);
            
            // Adicionar event listeners adicionais se necessário
            addToCartButtons.forEach(button => {
                button.addEventListener('click', function() {
                    console.log('Botão clicado diretamente');
                    this.style.opacity = '0.7';
                    setTimeout(() => {
                        this.style.opacity = '1';
                    }, 1000);
                });
            });
            
            // Teste de conectividade
            testServerConnection();
        });
        
        // Testar conexão com servidor
        function testServerConnection() {
            fetch('${contextPath}/books?action=count')
                .then(response => {
                    if (response.ok) {
                        console.log('✓ Servidor respondendo normalmente');
                    } else {
                        console.warn('⚠ Servidor respondeu com status:', response.status);
                    }
                })
                .catch(error => {
                    console.error('✗ Erro de conectividade:', error);
                });
        }
    </script>
    
    <style>
        /* Estilos específicos para garantir funcionamento */
        .catalog-filters {
            background: white;
            padding: 1.5rem;
            border-radius: 8px;
            box-shadow: 0 2px 8px rgba(0,0,0,0.1);
            margin: 2rem 0;
        }
        
        .filter-row {
            display: grid;
            grid-template-columns: 150px 1fr auto auto;
            gap: 1rem;
            align-items: center;
        }
        
        .catalog-info {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin: 1rem 0;
            padding: 1rem;
            background: var(--light-bg, #f8f9fa);
            border-radius: 8px;
        }
        
        .results-count {
            font-weight: 500;
            color: var(--text-color, #495057);
        }
        
        .books-grid {
            display: grid;
            grid-template-columns: repeat(auto-fill, minmax(280px, 1fr));
            gap: 1.5rem;
            margin: 2rem 0;
        }
        
        .book-card {
            background: white;
            border-radius: 8px;
            box-shadow: 0 2px 8px rgba(0,0,0,0.1);
            overflow: hidden;
            transition: transform 0.3s, box-shadow 0.3s;
        }
        
        .book-card:hover {
            transform: translateY(-4px);
            box-shadow: 0 6px 20px rgba(0,0,0,0.15);
        }
        
        .book-image {
            height: 200px;
            background: #f8f9fa;
            display: flex;
            align-items: center;
            justify-content: center;
            position: relative;
            overflow: hidden;
        }
        
        .book-image img {
            width: 100%;
            height: 100%;
            object-fit: cover;
        }
        
        .book-placeholder {
            color: #dee2e6;
            font-size: 3rem;
        }
        
        .out-of-stock-badge {
            position: absolute;
            top: 10px;
            right: 10px;
            background: #e74c3c;
            color: white;
            padding: 0.25rem 0.5rem;
            border-radius: 4px;
            font-size: 0.75rem;
            font-weight: bold;
        }
        
        .book-info {
            padding: 1rem;
        }
        
        .book-title {
            margin: 0 0 0.5rem 0;
            font-size: 1.1rem;
            line-height: 1.3;
        }
        
        .book-title a {
            text-decoration: none;
            color: var(--primary-color, #2c3e50);
            font-weight: 600;
        }
        
        .book-title a:hover {
            color: var(--secondary-color, #3498db);
        }
        
        .book-author {
            margin: 0 0 0.25rem 0;
            color: var(--text-color, #495057);
            font-size: 0.9rem;
        }
        
        .book-publisher {
            margin: 0 0 0.5rem 0;
            color: var(--gray-500, #6c757d);
            font-size: 0.85rem;
        }
        
        .book-price {
            font-size: 1.25rem;
            font-weight: bold;
            color: var(--success-color, #27ae60);
            margin: 0.5rem 0;
        }
        
        .book-stock {
            margin: 0.5rem 0;
            font-size: 0.85rem;
        }
        
        .in-stock {
            color: var(--success-color, #27ae60);
        }
        
        .out-of-stock {
            color: var(--danger-color, #e74c3c);
        }
        
        .book-actions {
            display: flex;
            gap: 0.5rem;
            flex-wrap: wrap;
            margin-top: 1rem;
        }
        
        .book-actions .btn {
            flex: 1;
            min-width: 80px;
            text-align: center;
            font-size: 0.85rem;
            padding: 0.5rem 0.75rem;
        }
        
        .pagination {
            display: flex;
            justify-content: space-between;
            align-items: center;
            padding: 2rem 0;
        }
        
        .page-btn {
            display: inline-flex;
            align-items: center;
            gap: 0.5rem;
            padding: 0.75rem 1rem;
            background: var(--secondary-color, #3498db);
            color: white;
            text-decoration: none;
            border-radius: 6px;
            transition: background-color 0.3s;
        }
        
        .page-btn:hover {
            background: #2980b9;
            color: white;
        }
        
        .page-info {
            font-weight: 500;
            color: var(--text-color, #495057);
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
            color: #dee2e6;
            margin-bottom: 1rem;
        }
        
        .empty-state h3 {
            color: var(--primary-color, #2c3e50);
            margin-bottom: 0.5rem;
        }
        
        .empty-state p {
            color: var(--text-color, #495057);
            margin-bottom: 1.5rem;
        }
        
        /* Responsivo */
        @media (max-width: 768px) {
            .filter-row {
                grid-template-columns: 1fr;
                gap: 0.75rem;
            }
            
            .catalog-info {
                flex-direction: column;
                gap: 1rem;
                text-align: center;
            }
            
            .books-grid {
                grid-template-columns: 1fr;
                gap: 1rem;
            }
            
            .book-actions {
                flex-direction: column;
            }
            
            .pagination {
                flex-direction: column;
                gap: 1rem;
            }
        }
        
        /* Garantir que botões funcionem */
        .btn {
            cursor: pointer !important;
            user-select: none;
            border: none;
            text-decoration: none;
            display: inline-flex;
            align-items: center;
            justify-content: center;
            gap: 0.5rem;
            padding: 0.5rem 1rem;
            border-radius: 6px;
            font-weight: 500;
            transition: all 0.3s ease;
        }
        
        .btn-primary {
            background: var(--secondary-color, #3498db) !important;
            color: white !important;
        }
        
        .btn-primary:hover {
            background: #2980b9 !important;
            transform: translateY(-1px);
        }
        
        .btn-outline {
            background: transparent !important;
            color: var(--secondary-color, #3498db) !important;
            border: 2px solid var(--secondary-color, #3498db) !important;
        }
        
        .btn-outline:hover {
            background: var(--secondary-color, #3498db) !important;
            color: white !important;
        }
        
        .btn-success {
            background: var(--success-color, #27ae60) !important;
            color: white !important;
        }
        
        .btn-warning {
            background: var(--warning-color, #f39c12) !important;
            color: white !important;
        }
        
        .btn-danger {
            background: var(--danger-color, #e74c3c) !important;
            color: white !important;
        }
        
        .btn-sm {
            padding: 0.375rem 0.75rem;
            font-size: 0.875rem;
        }
        
        /* Loading state para botões */
        .btn.loading {
            opacity: 0.7;
            pointer-events: none;
        }
        
        .btn.loading::after {
            content: '';
            width: 16px;
            height: 16px;
            border: 2px solid transparent;
            border-top: 2px solid currentColor;
            border-radius: 50%;
            animation: spin 1s linear infinite;
            margin-left: 0.5rem;
        }
        
        @keyframes spin {
            to { transform: rotate(360deg); }
        }
    </style>
</body>
</html>