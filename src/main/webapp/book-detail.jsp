<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="pt-BR">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>${book.titulo} - Mil Páginas</title>
    <link rel="stylesheet" href="css/style.css">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
</head>
<body>
    <jsp:include page="includes/header.jsp" />
    
    <main>
        <div class="container">
            <nav class="breadcrumb">
                <a href="index.jsp">Início</a> / 
                <a href="books">Livros</a> / 
                <span>${book.titulo}</span>
            </nav>
            
            <c:choose>
                <c:when test="${empty book}">
                    <div class="no-results">
                        <i class="fas fa-book"></i>
                        <h2>Livro não encontrado</h2>
                        <p>O livro que você está procurando não foi encontrado.</p>
                        <a href="books" class="btn btn-primary">Ver Catálogo</a>
                    </div>
                </c:when>
                <c:otherwise>
                    <div class="book-detail">
                        <div class="book-detail-container">
                            <div class="book-detail-image">
                                <c:choose>
                                    <c:when test="${not empty book.urlCapa}">
                                        <img src="${book.urlCapa}" alt="${book.titulo}" 
                                             onerror="this.src='images/book-placeholder.jpg'">
                                    </c:when>
                                    <c:otherwise>
                                        <div class="book-placeholder-large">
                                            <i class="fas fa-book"></i>
                                        </div>
                                    </c:otherwise>
                                </c:choose>
                                
                                <c:if test="${book.quantidadeEstoque == 0}">
                                    <div class="out-of-stock-badge-large">Esgotado</div>
                                </c:if>
                            </div>
                            
                            <div class="book-detail-info">
                                <h1 class="book-detail-title">${book.titulo}</h1>
                                <p class="book-detail-author">por <strong>${book.autor}</strong></p>
                                
                                <div class="book-detail-meta">
                                    <c:if test="${not empty book.editora}">
                                        <div class="meta-item">
                                            <strong>Editora:</strong> ${book.editora}
                                        </div>
                                    </c:if>
                                    
                                    <c:if test="${not empty book.anoPublicacao}">
                                        <div class="meta-item">
                                            <strong>Ano:</strong> ${book.anoPublicacao}
                                        </div>
                                    </c:if>
                                    
                                    <c:if test="${not empty book.isbn}">
                                        <div class="meta-item">
                                            <strong>ISBN:</strong> ${book.isbn}
                                        </div>
                                    </c:if>
                                    
                                    <div class="meta-item">
                                        <strong>Estoque:</strong> 
                                        <span class="${book.quantidadeEstoque > 0 ? 'in-stock' : 'out-of-stock'}">
                                            <c:choose>
                                                <c:when test="${book.quantidadeEstoque > 0}">
                                                    ${book.quantidadeEstoque} unidades
                                                </c:when>
                                                <c:otherwise>
                                                    Esgotado
                                                </c:otherwise>
                                            </c:choose>
                                        </span>
                                    </div>
                                </div>
                                
                                <div class="book-detail-price">
                                    <fmt:formatNumber value="${book.preco}" type="currency" currencySymbol="R$" />
                                </div>
                                
                                <c:if test="${not empty book.descricao}">
                                    <div class="book-detail-description">
                                        <h3>Descrição</h3>
                                        <p>${book.descricao}</p>
                                    </div>
                                </c:if>
                                
                                <div class="book-detail-actions">
                                    <c:choose>
                                        <c:when test="${not empty sessionScope.user}">
                                            <c:choose>
                                                <c:when test="${book.quantidadeEstoque > 0}">
                                                    <div class="quantity-selector">
                                                        <label for="quantity">Quantidade:</label>
                                                        <div class="quantity-controls">
                                                            <button type="button" class="qty-btn minus" onclick="changeQuantity(-1)">
                                                                <i class="fas fa-minus"></i>
                                                            </button>
                                                            <input type="number" id="quantity" value="1" min="1" max="${book.quantidadeEstoque}">
                                                            <button type="button" class="qty-btn plus" onclick="changeQuantity(1)">
                                                                <i class="fas fa-plus"></i>
                                                            </button>
                                                        </div>
                                                    </div>
                                                    
                                                    <button class="btn btn-primary btn-large add-to-cart-btn" 
                                                            data-book-id="${book.id}">
                                                        <i class="fas fa-cart-plus"></i>
                                                        Adicionar ao Carrinho
                                                    </button>
                                                </c:when>
                                                <c:otherwise>
                                                    <button class="btn btn-danger btn-large" disabled>
                                                        <i class="fas fa-times"></i>
                                                        Produto Esgotado
                                                    </button>
                                                </c:otherwise>
                                            </c:choose>
                                        </c:when>
                                        <c:otherwise>
                                            <a href="login?redirect=${pageContext.request.requestURI}" 
                                               class="btn btn-primary btn-large">
                                                <i class="fas fa-sign-in-alt"></i>
                                                Faça login para comprar
                                            </a>
                                        </c:otherwise>
                                    </c:choose>
                                    
                                    <div class="secondary-actions">
                                        <button class="btn btn-outline wishlist-btn" data-book-id="${book.id}">
                                            <i class="fas fa-heart"></i>
                                            Lista de Desejos
                                        </button>
                                        
                                        <button class="btn btn-outline share-btn" onclick="shareBook()">
                                            <i class="fas fa-share"></i>
                                            Compartilhar
                                        </button>
                                    </div>
                                </div>
                                
                                <c:if test="${sessionScope.isAdmin}">
                                    <div class="admin-actions-detail">
                                        <h4><i class="fas fa-cog"></i> Ações do Administrador</h4>
                                        <div class="admin-buttons">
                                            <a href="books?action=edit&id=${book.id}" class="btn btn-warning">
                                                <i class="fas fa-edit"></i> Editar
                                            </a>
                                            <button class="btn btn-danger delete-book-btn" 
                                                    data-book-id="${book.id}"
                                                    data-book-title="${book.titulo}">
                                                <i class="fas fa-trash"></i> Excluir
                                            </button>
                                        </div>
                                    </div>
                                </c:if>
                            </div>
                        </div>
                        
                        <!-- Informações adicionais -->
                        <div class="book-additional-info">
                            <div class="info-section">
                                <h3><i class="fas fa-truck"></i> Entrega</h3>
                                <ul>
                                    <li><i class="fas fa-check"></i> Frete grátis para todo o Brasil</li>
                                    <li><i class="fas fa-check"></i> Entrega em 3-7 dias úteis</li>
                                    <li><i class="fas fa-check"></i> Embalagem cuidadosa</li>
                                </ul>
                            </div>
                            
                            <div class="info-section">
                                <h3><i class="fas fa-shield-alt"></i> Garantia</h3>
                                <ul>
                                    <li><i class="fas fa-check"></i> Produto original</li>
                                    <li><i class="fas fa-check"></i> Garantia de qualidade</li>
                                    <li><i class="fas fa-check"></i> Política de troca</li>
                                </ul>
                            </div>
                            
                            <div class="info-section">
                                <h3><i class="fas fa-credit-card"></i> Pagamento</h3>
                                <ul>
                                    <li><i class="fas fa-check"></i> Pagamento seguro</li>
                                    <li><i class="fas fa-check"></i> Diversas formas de pagamento</li>
                                    <li><i class="fas fa-check"></i> Proteção de dados</li>
                                </ul>
                            </div>
                        </div>
                    </div>
                </c:otherwise>
            </c:choose>
        </div>
    </main>
    
    <jsp:include page="includes/footer.jsp" />
    
    <script src="js/script.js"></script>
    <script>
        document.addEventListener('DOMContentLoaded', function() {
            const addToCartBtn = document.querySelector('.add-to-cart-btn');
            const deleteBtn = document.querySelector('.delete-book-btn');
            
            if (addToCartBtn) {
                addToCartBtn.addEventListener('click', function() {
                    const bookId = this.getAttribute('data-book-id');
                    const quantity = document.getElementById('quantity').value;
                    addToCart(bookId, quantity, event);
                });
            }
            
            if (deleteBtn) {
                deleteBtn.addEventListener('click', function() {
                    const bookId = this.getAttribute('data-book-id');
                    const bookTitle = this.getAttribute('data-book-title');
                    
                    if (confirm('Tem certeza que deseja excluir o livro "' + bookTitle + '"?')) {
                        window.location.href = 'books?action=delete&id=' + bookId;
                    }
                });
            }
        });
        
        function changeQuantity(delta) {
            const quantityInput = document.getElementById('quantity');
            const currentValue = parseInt(quantityInput.value);
            const newValue = currentValue + delta;
            const max = parseInt(quantityInput.getAttribute('max'));
            
            if (newValue >= 1 && newValue <= max) {
                quantityInput.value = newValue;
            }
        }
        
        function addToCart(bookId, quantity, event) {
            if (typeof addToCartGlobal === 'function') {
                addToCartGlobal(bookId, quantity, event);
            } else {
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
                    showNotification('Livro adicionado ao carrinho!', 'success');
                    if (typeof updateCartCount === 'function') {
                        updateCartCount();
                    }
                } else {
                    showNotification(data.message || 'Erro ao adicionar ao carrinho', 'error');
                }
            })
            .catch(error => {
                console.error('Erro:', error);
                showMessage('Erro ao adicionar ao carrinho', 'error');
            });
        }
        
        function shareBook() {
            if (navigator.share) {
                navigator.share({
                    title: '${book.titulo}',
                    text: 'Confira este livro na Mil Páginas!',
                    url: window.location.href
                });
            } else {
                // Fallback para browsers sem suporte ao Web Share API
                const url = window.location.href;
                navigator.clipboard.writeText(url).then(() => {
                    showMessage('Link copiado para a área de transferência!', 'success');
                });
            }
        }
    </script>
    
    <style>
        .book-detail {
            padding: 2rem 0;
        }
        
        .book-detail-container {
            display: grid;
            grid-template-columns: 400px 1fr;
            gap: 3rem;
            margin-bottom: 3rem;
        }
        
        .book-detail-image {
            position: relative;
        }
        
        .book-detail-image img {
            width: 100%;
            border-radius: var(--border-radius);
            box-shadow: var(--box-shadow);
        }
        
        .book-placeholder-large {
            width: 100%;
            height: 500px;
            background: var(--gray-200);
            display: flex;
            align-items: center;
            justify-content: center;
            border-radius: var(--border-radius);
        }
        
        .book-placeholder-large i {
            font-size: 4rem;
            color: var(--gray-500);
        }
        
        .out-of-stock-badge-large {
            position: absolute;
            top: 20px;
            right: 20px;
            background: var(--accent-color);
            color: white;
            padding: 0.5rem 1rem;
            border-radius: var(--border-radius);
            font-weight: bold;
        }
        
        .book-detail-title {
            font-size: 2.5rem;
            color: var(--primary-color);
            margin-bottom: 1rem;
        }
        
        .book-detail-author {
            font-size: 1.2rem;
            color: var(--gray-600);
            margin-bottom: 2rem;
        }
        
        .book-detail-meta {
            background: var(--gray-100);
            padding: 1.5rem;
            border-radius: var(--border-radius);
            margin-bottom: 2rem;
        }
        
        .meta-item {
            margin-bottom: 0.5rem;
            display: flex;
            justify-content: space-between;
        }
        
        .meta-item:last-child {
            margin-bottom: 0;
        }
        
        .in-stock {
            color: var(--success-color);
            font-weight: bold;
        }
        
        .out-of-stock {
            color: var(--danger-color);
            font-weight: bold;
        }
        
        .book-detail-price {
            font-size: 2rem;
            font-weight: bold;
            color: var(--accent-color);
            margin-bottom: 2rem;
        }
        
        .book-detail-description {
            margin-bottom: 2rem;
        }
        
        .book-detail-description h3 {
            margin-bottom: 1rem;
            color: var(--primary-color);
        }
        
        .quantity-selector {
            margin-bottom: 1rem;
        }
        
        .quantity-selector label {
            display: block;
            margin-bottom: 0.5rem;
            font-weight: bold;
        }
        
        .btn-large {
            padding: 1rem 2rem;
            font-size: 1.1rem;
            width: 100%;
            margin-bottom: 1rem;
        }
        
        .secondary-actions {
            display: flex;
            gap: 1rem;
        }
        
        .secondary-actions .btn {
            flex: 1;
        }
        
        .admin-actions-detail {
            background: #fff3cd;
            padding: 1.5rem;
            border-radius: var(--border-radius);
            margin-top: 2rem;
        }
        
        .admin-actions-detail h4 {
            margin-bottom: 1rem;
            color: var(--warning-color);
        }
        
        .admin-buttons {
            display: flex;
            gap: 1rem;
        }
        
        .book-additional-info {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(300px, 1fr));
            gap: 2rem;
            margin-top: 3rem;
            padding-top: 3rem;
            border-top: 1px solid var(--gray-200);
        }
        
        .info-section h3 {
            color: var(--primary-color);
            margin-bottom: 1rem;
            display: flex;
            align-items: center;
        }
        
        .info-section h3 i {
            margin-right: 0.5rem;
        }
        
        .info-section ul {
            list-style: none;
        }
        
        .info-section li {
            padding: 0.5rem 0;
            display: flex;
            align-items: center;
        }
        
        .info-section li i {
            color: var(--success-color);
            margin-right: 0.5rem;
        }
        
        @media (max-width: 768px) {
            .book-detail-container {
                grid-template-columns: 1fr;
                gap: 2rem;
            }
            
            .book-detail-title {
                font-size: 2rem;
            }
            
            .secondary-actions {
                flex-direction: column;
            }
            
            .admin-buttons {
                flex-direction: column;
            }
        }
    </style>
</body>
</html>