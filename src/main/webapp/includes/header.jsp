<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<header class="header">
    <nav class="navbar">
        <div class="container">
            <div class="navbar-brand">
                <a href="index.jsp">
                    <i class="fas fa-book"></i>
                    <span>Mil Páginas</span>
                </a>
            </div>
            
            <div class="navbar-search">
                <form action="books" method="get" class="search-form">
                    <input type="hidden" name="action" value="search">
                    <select name="type" class="search-type">
                        <option value="">Todos</option>
                        <option value="title">Título</option>
                        <option value="author">Autor</option>
                        <option value="publisher">Editora</option>
                    </select>
                    <input type="text" name="q" placeholder="Buscar livros..." class="search-input" value="${param.q}">
                    <button type="submit" class="search-btn">
                        <i class="fas fa-search"></i>
                    </button>
                </form>
            </div>
            
            <div class="navbar-menu">
                <ul class="navbar-nav">
                    <li><a href="index.jsp">Início</a></li>
                    <li><a href="books">Livros</a></li>
                    
                    <c:choose>
                        <c:when test="${not empty sessionScope.user}">
                            <li class="dropdown">
                                <a href="#" class="dropdown-toggle">
                                    <i class="fas fa-user"></i>
                                    ${sessionScope.userName}
                                </a>
                                <ul class="dropdown-menu">
                                    <li><a href="profile.jsp">Meu Perfil</a></li>
                                    <li><a href="orders">Meus Pedidos</a></li>
                                    <c:if test="${sessionScope.isAdmin}">
                                        <li class="divider"></li>
                                        <li><a href="admin/dashboard.jsp">Painel Admin</a></li>
                                        <li><a href="books?action=add">Adicionar Livro</a></li>
                                        <li><a href="orders?action=admin">Gerenciar Pedidos</a></li>
                                    </c:if>
                                    <li class="divider"></li>
                                    <li><a href="logout">Sair</a></li>
                                </ul>
                            </li>
                            <li class="cart-dropdown">
                                <a href="#" class="cart-link" onclick="toggleMiniCart(event)">
                                    <i class="fas fa-shopping-cart"></i>
                                    <span class="cart-count" id="cart-count">0</span>
                                </a>
                                <!-- Mini Carrinho -->
                                <div class="mini-cart" id="mini-cart">
                                    <div class="mini-cart-header">
                                        <h3>Meu Carrinho</h3>
                                        <button class="close-mini-cart" onclick="closeMiniCart()">
                                            <i class="fas fa-times"></i>
                                        </button>
                                    </div>
                                    <div class="mini-cart-content">
                                        <div class="mini-cart-items" id="mini-cart-items">
                                            <!-- Itens serão carregados via JavaScript -->
                                        </div>
                                        <div class="mini-cart-footer">
                                            <div class="mini-cart-total">
                                                <strong>Total: <span id="mini-cart-total">R$ 0,00</span></strong>
                                            </div>
                                            <div class="mini-cart-actions">
                                                <a href="cart" class="btn btn-outline btn-sm">Ver Carrinho</a>
                                                <a href="orders?action=checkout" class="btn btn-primary btn-sm">Finalizar</a>
                                            </div>
                                        </div>
                                    </div>
                                    <div class="mini-cart-empty" id="mini-cart-empty" style="display: none;">
                                        <i class="fas fa-shopping-cart"></i>
                                        <p>Seu carrinho está vazio</p>
                                        <a href="books" class="btn btn-primary btn-sm">Continuar Comprando</a>
                                    </div>
                                </div>
                            </li>
                        </c:when>
                        <c:otherwise>
                            <li><a href="login">Entrar</a></li>
                            <li><a href="register" class="btn btn-primary btn-sm">Cadastrar</a></li>
                        </c:otherwise>
                    </c:choose>
                </ul>
            </div>
            
            <div class="mobile-menu-toggle">
                <i class="fas fa-bars"></i>
            </div>
        </div>
    </nav>
</header>

<script>
    document.addEventListener('DOMContentLoaded', function() {
        // Sempre atualizar o contador - a função detecta automaticamente o estado
        updateCartCount();
        
        // Mobile menu toggle
        const mobileToggle = document.querySelector('.mobile-menu-toggle');
        const navbarMenu = document.querySelector('.navbar-menu');
        
        if (mobileToggle && navbarMenu) {
            mobileToggle.addEventListener('click', function() {
                navbarMenu.classList.toggle('active');
            });
        }
        
        // Dropdown menu
        const dropdownToggle = document.querySelector('.dropdown-toggle');
        const dropdownMenu = document.querySelector('.dropdown-menu');
        
        if (dropdownToggle && dropdownMenu) {
            dropdownToggle.addEventListener('click', function(e) {
                e.preventDefault();
                dropdownMenu.classList.toggle('active');
            });
            
            document.addEventListener('click', function(e) {
                if (!dropdownToggle.contains(e.target) && !dropdownMenu.contains(e.target)) {
                    dropdownMenu.classList.remove('active');
                }
            });
        }
    });
    
    function updateCartCount() {
        MilPaginas.makeRequest('cart?action=count')
            .then(data => {
                if (data.success && data.data) {
                    const cartCountElement = document.getElementById('cart-count');
                    if (cartCountElement) {
                        cartCountElement.textContent = data.data.cartCount || 0;
                    }
                }
            })
            .catch(error => {
                console.error('Erro ao atualizar contador do carrinho:', error);
            });
    }
    
    // Funções do Mini Carrinho
    function toggleMiniCart(event) {
        event.preventDefault();
        const miniCart = document.getElementById('mini-cart');
        const isVisible = miniCart.classList.contains('active');
        
        if (isVisible) {
            closeMiniCart();
        } else {
            showMiniCart();
        }
    }
    
    function showMiniCart() {
        const miniCart = document.getElementById('mini-cart');
        miniCart.classList.add('active');
        loadMiniCartItems();
        
        // Fechar ao clicar fora
        setTimeout(() => {
            document.addEventListener('click', closeMiniCartOnOutsideClick);
        }, 100);
    }
    
    function closeMiniCart() {
        const miniCart = document.getElementById('mini-cart');
        miniCart.classList.remove('active');
        document.removeEventListener('click', closeMiniCartOnOutsideClick);
    }
    
    function closeMiniCartOnOutsideClick(event) {
        const miniCart = document.getElementById('mini-cart');
        const cartLink = document.querySelector('.cart-link');
        
        if (!miniCart.contains(event.target) && !cartLink.contains(event.target)) {
            closeMiniCart();
        }
    }
    
    function loadMiniCartItems() {
        MilPaginas.makeRequest('cart?action=json')
            .then(data => {
                if (data.success && data.data && data.data.items) {
                    displayMiniCartItems(data.data.items);
                } else {
                    showEmptyMiniCart();
                }
            })
            .catch(error => {
                console.error('Erro ao carregar itens do carrinho:', error);
                showEmptyMiniCart();
            });
    }
    
    function displayMiniCartItems(items) {
        const itemsContainer = document.getElementById('mini-cart-items');
        const emptyContainer = document.getElementById('mini-cart-empty');
        const contentContainer = document.querySelector('.mini-cart-content');
        
        if (items.length === 0) {
            showEmptyMiniCart();
            return;
        }
        
        emptyContainer.style.display = 'none';
        contentContainer.style.display = 'block';
        
        let total = 0;
        const itemsHTML = items.map(item => {
            const subtotal = item.price * item.quantity;
            total += subtotal;
            
            return `
                <div class="mini-cart-item" data-item-id="${item.id}">
                    <div class="mini-cart-item-image">
                        <img src="${item.image}" alt="${item.title}" onerror="this.src='images/book-placeholder.jpg'">
                    </div>
                    <div class="mini-cart-item-info">
                        <h4>${item.title}</h4>
                        <p>${item.author}</p>
                        <div class="item-details">
                            <span class="quantity">${item.quantity}x</span>
                            <span class="price">R$ ${item.price.toFixed(2)}</span>
                        </div>
                    </div>
                    <button class="remove-item" onclick="removeFromMiniCart(${item.id})">
                        <i class="fas fa-trash"></i>
                    </button>
                </div>
            `;
        }).join('');
        
        itemsContainer.innerHTML = itemsHTML;
        document.getElementById('mini-cart-total').textContent = `R$ ${total.toFixed(2)}`;
    }
    
    function showEmptyMiniCart() {
        const emptyContainer = document.getElementById('mini-cart-empty');
        const contentContainer = document.querySelector('.mini-cart-content');
        
        emptyContainer.style.display = 'block';
        contentContainer.style.display = 'none';
    }
    
    function removeFromMiniCart(itemId) {
        MilPaginas.makeRequest('cart', {
            method: 'POST',
            headers: {
                'Content-Type': 'application/x-www-form-urlencoded',
            },
            body: `action=remove&cartItemId=${itemId}`
        })
        .then(data => {
            if (data.success) {
                loadMiniCartItems();
                updateCartCount();
                showNotification('Item removido do carrinho', 'success');
            } else {
                showNotification('Erro ao remover item', 'error');
            }
        })
        .catch(error => {
            console.error('Erro ao remover item:', error);
            showNotification('Erro ao remover item', 'error');
        });
    }
    
    function showNotification(message, type) {
        if (typeof MilPaginas !== 'undefined' && MilPaginas.showToast) {
            MilPaginas.showToast(message, type);
        } else {
            console.log(`${type.toUpperCase()}: ${message}`);
        }
    }
    
    // Função global para adicionar ao carrinho (usada em outras páginas)
    window.addToCartGlobal = function(bookId, quantity = 1, event) {
        const button = event ? event.currentTarget : null;
        console.log('addToCartGlobal chamada - BookID:', bookId, 'Quantity:', quantity);
        
        // Enviar para servidor
        if (button) button.classList.add('loading');
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
                updateCartCount();
                // Animar contador
                const cartCountElement = document.getElementById('cart-count');
                if (cartCountElement) {
                    cartCountElement.classList.add('animated');
                    setTimeout(() => cartCountElement.classList.remove('animated'), 300);
                }
            } else {
                showNotification(data.message || 'Erro ao adicionar ao carrinho', 'error');
            }
        })
        .catch(error => {
            console.error('Erro:', error);
            showNotification('Erro ao adicionar ao carrinho', 'error');
        })
        .finally(() => {
            if (button) button.classList.remove('loading');
        });
    };
    
    // Garantir que o sistema esteja disponível globalmente
    window.addEventListener('load', function() {
        // Certificar que MilPaginas está disponível e depois inicializar
        if (typeof MilPaginas !== 'undefined') {
            // Re-atualizar contador após todos os scripts carregarem
            setTimeout(updateCartCount, 100);
        }
    });
</script>