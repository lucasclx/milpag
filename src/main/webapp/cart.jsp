<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="pt-BR">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Carrinho de Compras - Mil Páginas</title>
    <link rel="stylesheet" href="css/style.css">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
</head>
<body>
    <jsp:include page="includes/header.jsp" />
    
    <main>
        <div class="container">
            <div class="page-header">
                <h1><i class="fas fa-shopping-cart"></i> Meu Carrinho</h1>
                <nav class="breadcrumb">
                    <a href="index.jsp">Início</a> / 
                    <a href="books">Livros</a> / 
                    <span>Carrinho</span>
                </nav>
            </div>
            
            <c:choose>
                <c:when test="${empty cartItems}">
                    <div class="empty-cart">
                        <div class="empty-cart-icon">
                            <i class="fas fa-shopping-cart"></i>
                        </div>
                        <h2>Seu carrinho está vazio</h2>
                        <p>Adicione alguns livros ao seu carrinho para continuar suas compras.</p>
                        <a href="books" class="btn btn-primary">
                            <i class="fas fa-book"></i>
                            Explorar Livros
                        </a>
                    </div>
                </c:when>
                <c:otherwise>
                    <div class="cart-container">
                        <div class="cart-items">
                            <div class="cart-header">
                                <h2>Itens do Carrinho (${totalItems})</h2>
                                <button class="btn btn-outline btn-small clear-cart-btn">
                                    <i class="fas fa-trash"></i> Limpar Carrinho
                                </button>
                            </div>
                            
                            <div class="cart-list">
                                <c:forEach var="item" items="${cartItems}">
                                    <div class="cart-item" data-item-id="${item.id}">
                                        <div class="item-image">
                                            <c:choose>
                                                <c:when test="${not empty item.livro.urlCapa}">
                                                    <img src="${item.livro.urlCapa}" alt="${item.livro.titulo}"
                                                         onerror="this.src='images/book-placeholder.jpg'">
                                                </c:when>
                                                <c:otherwise>
                                                    <div class="book-placeholder-small">
                                                        <i class="fas fa-book"></i>
                                                    </div>
                                                </c:otherwise>
                                            </c:choose>
                                        </div>
                                        
                                        <div class="item-details">
                                            <h3 class="item-title">
                                                <a href="books?action=view&id=${item.livro.id}">${item.livro.titulo}</a>
                                            </h3>
                                            <p class="item-author">por ${item.livro.autor}</p>
                                            <p class="item-price">
                                                <fmt:formatNumber value="${item.livro.preco}" type="currency" currencySymbol="R$" />
                                            </p>
                                        </div>
                                        
                                        <div class="item-quantity">
                                            <label for="qty-${item.id}">Quantidade:</label>
                                            <div class="quantity-controls">
                                                <button class="qty-btn minus" data-item-id="${item.id}">
                                                    <i class="fas fa-minus"></i>
                                                </button>
                                                <input type="number" id="qty-${item.id}" class="qty-input" 
                                                       value="${item.quantidade}" min="1" max="10" 
                                                       data-item-id="${item.id}">
                                                <button class="qty-btn plus" data-item-id="${item.id}">
                                                    <i class="fas fa-plus"></i>
                                                </button>
                                            </div>
                                        </div>
                                        
                                        <div class="item-subtotal">
                                            <span class="subtotal-label">Subtotal:</span>
                                            <span class="subtotal-value" data-item-id="${item.id}">
                                                <fmt:formatNumber value="${item.subtotal}" type="currency" currencySymbol="R$" />
                                            </span>
                                        </div>
                                        
                                        <div class="item-actions">
                                            <button class="btn btn-danger btn-small remove-item-btn" 
                                                    data-item-id="${item.id}"
                                                    title="Remover item">
                                                <i class="fas fa-trash"></i>
                                            </button>
                                        </div>
                                    </div>
                                </c:forEach>
                            </div>
                        </div>
                        
                        <div class="cart-summary">
                            <div class="summary-card">
                                <h3>Resumo do Pedido</h3>
                                
                                <div class="summary-line">
                                    <span>Itens (${totalItems}):</span>
                                    <span id="items-total">
                                        <fmt:formatNumber value="${cartTotal}" type="currency" currencySymbol="R$" />
                                    </span>
                                </div>
                                
                                <div class="summary-line">
                                    <span>Frete:</span>
                                    <span class="free-shipping">Grátis</span>
                                </div>
                                
                                <hr>
                                
                                <div class="summary-total">
                                    <span>Total:</span>
                                    <span id="cart-total">
                                        <fmt:formatNumber value="${cartTotal}" type="currency" currencySymbol="R$" />
                                    </span>
                                </div>
                                
                                <div class="summary-actions">
                                    <a href="orders?action=checkout" class="btn btn-primary btn-full">
                                        <i class="fas fa-credit-card"></i>
                                        Finalizar Compra
                                    </a>
                                    <a href="books" class="btn btn-outline btn-full">
                                        <i class="fas fa-arrow-left"></i>
                                        Continuar Comprando
                                    </a>
                                </div>
                                
                                <div class="shipping-info">
                                    <h4><i class="fas fa-truck"></i> Informações de Entrega</h4>
                                    <ul>
                                        <li><i class="fas fa-check"></i> Frete grátis para todo o Brasil</li>
                                        <li><i class="fas fa-check"></i> Entrega em 3-7 dias úteis</li>
                                        <li><i class="fas fa-check"></i> Rastreamento incluído</li>
                                    </ul>
                                </div>
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
            // Quantity controls
            const quantityInputs = document.querySelectorAll('.qty-input');
            const plusButtons = document.querySelectorAll('.qty-btn.plus');
            const minusButtons = document.querySelectorAll('.qty-btn.minus');
            const removeButtons = document.querySelectorAll('.remove-item-btn');
            const clearCartBtn = document.querySelector('.clear-cart-btn');
            
            // Handle quantity input changes
            quantityInputs.forEach(input => {
                let timeout;
                input.addEventListener('input', function() {
                    clearTimeout(timeout);
                    timeout = setTimeout(() => {
                        const itemId = this.getAttribute('data-item-id');
                        const quantity = parseInt(this.value);
                        if (quantity > 0) {
                            updateCartItem(itemId, quantity);
                        }
                    }, 500);
                });
            });
            
            // Handle plus buttons
            plusButtons.forEach(btn => {
                btn.addEventListener('click', function() {
                    const itemId = this.getAttribute('data-item-id');
                    const input = document.getElementById('qty-' + itemId);
                    const currentQty = parseInt(input.value);
                    const newQty = currentQty + 1;
                    
                    if (newQty <= 10) {
                        input.value = newQty;
                        updateCartItem(itemId, newQty);
                    }
                });
            });
            
            // Handle minus buttons
            minusButtons.forEach(btn => {
                btn.addEventListener('click', function() {
                    const itemId = this.getAttribute('data-item-id');
                    const input = document.getElementById('qty-' + itemId);
                    const currentQty = parseInt(input.value);
                    const newQty = currentQty - 1;
                    
                    if (newQty > 0) {
                        input.value = newQty;
                        updateCartItem(itemId, newQty);
                    } else {
                        removeCartItem(itemId);
                    }
                });
            });
            
            // Handle remove buttons
            removeButtons.forEach(btn => {
                btn.addEventListener('click', function() {
                    const itemId = this.getAttribute('data-item-id');
                    if (confirm('Tem certeza que deseja remover este item do carrinho?')) {
                        removeCartItem(itemId);
                    }
                });
            });
            
            // Handle clear cart
            if (clearCartBtn) {
                clearCartBtn.addEventListener('click', function() {
                    if (confirm('Tem certeza que deseja limpar todo o carrinho?')) {
                        clearCart();
                    }
                });
            }
        });
        
        function updateCartItem(itemId, quantity) {
            const formData = new FormData();
            formData.append('action', 'update');
            formData.append('cartItemId', itemId);
            formData.append('quantity', quantity);
            
            fetch('cart', {
                method: 'POST',
                body: formData
            })
            .then(response => response.json())
            .then(data => {
                if (data.success) {
                    location.reload(); // Recarrega para atualizar os totais
                } else {
                    showMessage(data.message || 'Erro ao atualizar carrinho', 'error');
                }
            })
            .catch(error => {
                console.error('Erro:', error);
                showMessage('Erro ao atualizar carrinho', 'error');
            });
        }
        
        function removeCartItem(itemId) {
            const formData = new FormData();
            formData.append('action', 'remove');
            formData.append('cartItemId', itemId);
            
            fetch('cart', {
                method: 'POST',
                body: formData
            })
            .then(response => response.json())
            .then(data => {
                if (data.success) {
                    location.reload();
                } else {
                    showMessage(data.message || 'Erro ao remover item', 'error');
                }
            })
            .catch(error => {
                console.error('Erro:', error);
                showMessage('Erro ao remover item', 'error');
            });
        }
        
        function clearCart() {
            const formData = new FormData();
            formData.append('action', 'clear');
            
            fetch('cart', {
                method: 'POST',
                body: formData
            })
            .then(response => response.json())
            .then(data => {
                if (data.success) {
                    location.reload();
                } else {
                    showMessage(data.message || 'Erro ao limpar carrinho', 'error');
                }
            })
            .catch(error => {
                console.error('Erro:', error);
                showMessage('Erro ao limpar carrinho', 'error');
            });
        }
    </script>
</body>
</html>