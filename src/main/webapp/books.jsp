<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="pt-BR">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Catálogo de Livros - Mil Páginas</title>
    <link rel="stylesheet" href="css/style.css">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
</head>
<body>
    <jsp:include page="includes/header.jsp" />
    
    <main>
        <div class="container">
            <div class="page-header">
                <h1>Catálogo de Livros</h1>
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
            
            <div class="catalog-container">
                <aside class="catalog-sidebar">
                    <div class="filter-section">
                        <h3>Buscar</h3>
                        <form action="books" method="get" class="filter-form">
                            <input type="hidden" name="action" value="search">
                            <div class="form-group">
                                <select name="type" class="form-control">
                                    <option value="">Buscar em todos</option>
                                    <option value="title" ${searchType == 'title' ? 'selected' : ''}>Título</option>
                                    <option value="author" ${searchType == 'author' ? 'selected' : ''}>Autor</option>
                                    <option value="publisher" ${searchType == 'publisher' ? 'selected' : ''}>Editora</option>
                                </select>
                            </div>
                            <div class="form-group">
                                <input type="text" name="q" placeholder="Digite sua busca..." 
                                       class="form-control" value="${searchTerm}">
                            </div>
                            <button type="submit" class="btn btn-primary btn-full">
                                <i class="fas fa-search"></i> Buscar
                            </button>
                        </form>
                    </div>
                    
                    <div class="filter-section">
                        <h3>Navegação Rápida</h3>
                        <ul class="quick-nav">
                            <li><a href="books">Todos os Livros</a></li>
                            <li><a href="books?action=search&type=author&q=Machado">Clássicos Brasileiros</a></li>
                            <li><a href="books?action=search&type=title&q=Harry">Literatura Fantástica</a></li>
                            <li><a href="books?action=search&type=publisher&q=Companhia">Ficção Contemporânea</a></li>
                        </ul>
                    </div>
                    
                    <c:if test="${sessionScope.isAdmin}">
                        <div class="filter-section admin-section">
                            <h3>Administração</h3>
                            <a href="books?action=add" class="btn btn-success btn-full">
                                <i class="fas fa-plus"></i> Adicionar Livro
                            </a>
                        </div>
                    </c:if>
                </aside>
                
                <div class="catalog-content">
                    <div class="catalog-header">
                        <div class="catalog-info">
                            <c:choose>
                                <c:when test="${not empty totalBooks}">
                                    <span>${totalBooks} livros encontrados</span>
                                </c:when>
                                <c:otherwise>
                                    <span>${not empty books ? books.size() : 0} livros encontrados</span>
                                </c:otherwise>
                            </c:choose>
                        </div>
                        
                        <div class="view-options">
                            <button class="view-btn active" data-view="grid">
                                <i class="fas fa-th"></i>
                            </button>
                            <button class="view-btn" data-view="list">
                                <i class="fas fa-list"></i>
                            </button>
                        </div>
                    </div>
                    
                    <c:choose>
                        <c:when test="${empty books}">
                            <div class="no-results">
                                <i class="fas fa-search"></i>
                                <h3>Nenhum livro encontrado</h3>
                                <p>Tente ajustar sua busca ou navegue por nossa seleção completa.</p>
                                <a href="books" class="btn btn-primary">Ver Todos os Livros</a>
                            </div>
                        </c:when>
                        <c:otherwise>
                            <div class="books-grid" id="books-container">
                                <c:forEach var="book" items="${books}">
                                    <div class="book-card">
                                        <div class="book-image">
                                            <c:choose>
                                                <c:when test="${not empty book.urlCapa}">
                                                    <img src="${book.urlCapa}" alt="${book.titulo}" 
                                                         onerror="this.src='images/book-placeholder.jpg'">
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
                                                <a href="books?action=view&id=${book.id}">${book.titulo}</a>
                                            </h3>
                                            <p class="book-author">por ${book.autor}</p>
                                            <c:if test="${not empty book.editora}">
                                                <p class="book-publisher">${book.editora}</p>
                                            </c:if>
                                            
                                            <div class="book-price">
                                                <fmt:formatNumber value="${book.preco}" type="currency" currencySymbol="R$" />
                                            </div>
                                            
                                            <div class="book-actions">
                                                <a href="books?action=view&id=${book.id}" class="btn btn-outline btn-small">
                                                    Ver Detalhes
                                                </a>
                                                
                                                <c:if test="${not empty sessionScope.user && book.quantidadeEstoque > 0}">
                                                    <button class="btn btn-primary btn-small add-to-cart-btn" 
                                                            data-book-id="${book.id}">
                                                        <i class="fas fa-cart-plus"></i>
                                                        Adicionar
                                                    </button>
                                                </c:if>
                                                
                                                <c:if test="${sessionScope.isAdmin}">
                                                    <div class="admin-actions">
                                                        <a href="books?action=edit&id=${book.id}" 
                                                           class="btn btn-warning btn-small">
                                                            <i class="fas fa-edit"></i>
                                                        </a>
                                                        <button class="btn btn-danger btn-small delete-book-btn" 
                                                                data-book-id="${book.id}"
                                                                data-book-title="${book.titulo}">
                                                            <i class="fas fa-trash"></i>
                                                        </button>
                                                    </div>
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
                                        <a href="books?page=${currentPage - 1}" class="page-btn">
                                            <i class="fas fa-chevron-left"></i>
                                        </a>
                                    </c:if>
                                    
                                    <c:forEach begin="1" end="${totalPages}" var="page">
                                        <c:choose>
                                            <c:when test="${page == currentPage}">
                                                <span class="page-btn active">${page}</span>
                                            </c:when>
                                            <c:otherwise>
                                                <a href="books?page=${page}" class="page-btn">${page}</a>
                                            </c:otherwise>
                                        </c:choose>
                                    </c:forEach>
                                    
                                    <c:if test="${currentPage < totalPages}">
                                        <a href="books?page=${currentPage + 1}" class="page-btn">
                                            <i class="fas fa-chevron-right"></i>
                                        </a>
                                    </c:if>
                                </div>
                            </c:if>
                        </c:otherwise>
                    </c:choose>
                </div>
            </div>
        </div>
    </main>
    
    <jsp:include page="includes/footer.jsp" />
    
    <script src="js/script.js"></script>
    <script>
        document.addEventListener('DOMContentLoaded', function() {
            // View switcher
            const viewButtons = document.querySelectorAll('.view-btn');
            const booksContainer = document.getElementById('books-container');
            
            viewButtons.forEach(btn => {
                btn.addEventListener('click', function() {
                    viewButtons.forEach(b => b.classList.remove('active'));
                    this.classList.add('active');
                    
                    const view = this.getAttribute('data-view');
                    booksContainer.className = view === 'list' ? 'books-list' : 'books-grid';
                });
            });
            
            // Add to cart functionality
            const addToCartButtons = document.querySelectorAll('.add-to-cart-btn');
            addToCartButtons.forEach(btn => {
                btn.addEventListener('click', function() {
                    const bookId = this.getAttribute('data-book-id');
                    addToCart(bookId, 1);
                });
            });
            
            // Delete book functionality (admin only)
            const deleteButtons = document.querySelectorAll('.delete-book-btn');
            deleteButtons.forEach(btn => {
                btn.addEventListener('click', function() {
                    const bookId = this.getAttribute('data-book-id');
                    const bookTitle = this.getAttribute('data-book-title');
                    
                    if (confirm('Tem certeza que deseja excluir o livro "' + bookTitle + '"?')) {
                        window.location.href = 'books?action=delete&id=' + bookId;
                    }
                });
            });
        });
        
        function addToCart(bookId, quantity) {
            if (typeof addToCartGlobal === 'function') {
                addToCartGlobal(bookId, quantity);
            } else {
                // Fallback para usuários logados
                const formData = new FormData();
                formData.append('action', 'add');
                formData.append('bookId', bookId);
                formData.append('quantity', quantity);
                
                fetch('cart', {
                    method: 'POST',
                    body: formData
                })
                .then(response => response.json())
                .then(data => {
                    if (data.success) {
                        if (typeof MilPaginas !== 'undefined' && MilPaginas.showToast) {
                            MilPaginas.showToast('Livro adicionado ao carrinho!', 'success');
                        } else {
                            showMessage('Livro adicionado ao carrinho!', 'success');
                        }
                        if (typeof updateCartCount === 'function') {
                            updateCartCount();
                        }
                    } else {
                        if (typeof MilPaginas !== 'undefined' && MilPaginas.showToast) {
                            MilPaginas.showToast(data.message || 'Erro ao adicionar ao carrinho', 'error');
                        } else {
                            showMessage(data.message || 'Erro ao adicionar ao carrinho', 'error');
                        }
                    }
                })
                .catch(error => {
                    console.error('Erro:', error);
                    if (typeof MilPaginas !== 'undefined' && MilPaginas.showToast) {
                        MilPaginas.showToast('Erro ao adicionar ao carrinho', 'error');
                    } else {
                        showMessage('Erro ao adicionar ao carrinho', 'error');
                    }
                });
            }
        }
    </script>
</body>
</html>