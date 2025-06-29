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
                                                <a href="cart" class="btn btn-outline btn-small">Ver Carrinho</a>
                                                <a href="orders?action=checkout" class="btn btn-primary btn-small">Finalizar</a>
                                            </div>
                                        </div>
                                    </div>
                                    <div class="mini-cart-empty" id="mini-cart-empty" style="display: none;">
                                        <i class="fas fa-shopping-cart"></i>
                                        <p>Seu carrinho está vazio</p>
                                        <a href="books" class="btn btn-primary btn-small">Continuar Comprando</a>
                                    </div>
                                </div>
                            </li>
                        </c:when>
                        <c:otherwise>
                            <li><a href="login">Entrar</a></li>
                            <li><a href="register" class="btn btn-primary btn-small">Cadastrar</a></li>
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
        <c:if test="${not empty sessionScope.user}">
            updateCartCount();
        </c:if>
        
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
        fetch('cart?action=count')
            .then(response => response.json())
            .then(data => {
                if (data.success && data.data) {
                    const cartCountElement = document.getElementById('cart-count');
                    if (cartCountElement) {
                        cartCountElement.textContent = data.data.cartCount || 0;
                    }
                }
            })
            .catch(error => console.error('Erro ao atualizar contador do carrinho:', error));
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
        // Para usuários logados, buscar do servidor
        <c:if test="${not empty sessionScope.user}">
            fetch('cart?action=json')
                .then(response => response.json())
                .then(data => {
                    if (data.success && data.data && data.data.items) {
                        displayMiniCartItems(data.data.items);
                    } else {
                        showEmptyMiniCart();
                    }
                })
                .catch(error => {
                    console.error('Erro ao carregar itens do carrinho:', error);
                    // Fallback para localStorage
                    loadFromLocalStorage();
                });
        </c:if>
        
        // Para usuários não logados, usar localStorage
        <c:if test="${empty sessionScope.user}">
            loadFromLocalStorage();
        </c:if>
    }
    
    function loadFromLocalStorage() {
        const cartItems = MilPaginas.storage.get('cart_items', []);
        if (cartItems.length > 0) {
            // Buscar detalhes dos livros do servidor
            const bookIds = cartItems.map(item => item.bookId);
            fetch('books?action=details&ids=' + bookIds.join(','))
                .then(response => response.json())
                .then(data => {
                    if (data.success && data.books) {
                        const items = cartItems.map(cartItem => {
                            const book = data.books.find(b => b.id == cartItem.bookId);
                            return book ? {
                                id: book.id,
                                title: book.titulo,
                                author: book.autor,
                                price: book.preco,
                                quantity: cartItem.quantity,
                                image: book.urlCapa || 'images/book-placeholder.jpg'
                            } : null;
                        }).filter(item => item !== null);
                        
                        displayMiniCartItems(items);
                        updateLocalStorageCount(items.length);
                    } else {
                        showEmptyMiniCart();
                    }
                })
                .catch(error => {
                    console.error('Erro ao buscar detalhes dos livros:', error);
                    showEmptyMiniCart();
                });
        } else {
            showEmptyMiniCart();
        }
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
        <c:choose>
            <c:when test="${not empty sessionScope.user}">
                // Usuário logado - remover do servidor
                fetch('cart', {
                    method: 'POST',
                    headers: {
                        'Content-Type': 'application/x-www-form-urlencoded',
                    },
                    body: `action=remove&cartItemId=${itemId}`
                })
                .then(response => response.json())
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
            </c:when>
            <c:otherwise>
                // Usuário não logado - remover do localStorage
                removeFromLocalStorageCart(itemId);
            </c:otherwise>
        </c:choose>
    }
    
    function showNotification(message, type) {
        if (typeof MilPaginas !== 'undefined' && MilPaginas.showToast) {
            MilPaginas.showToast(message, type);
        } else {
            console.log(`${type.toUpperCase()}: ${message}`);
        }
    }
    
    // Funções para localStorage
    function addToLocalStorageCart(bookId, quantity = 1) {
        const cartItems = MilPaginas.storage.get('cart_items', []);
        const existingItem = cartItems.find(item => item.bookId == bookId);
        
        if (existingItem) {
            existingItem.quantity += quantity;
        } else {
            cartItems.push({ bookId: parseInt(bookId), quantity: quantity });
        }
        
        MilPaginas.storage.set('cart_items', cartItems);
        updateLocalStorageCount(cartItems.reduce((total, item) => total + item.quantity, 0));
        showNotification('Livro adicionado ao carrinho!', 'success');
    }
    
    function removeFromLocalStorageCart(bookId) {
        const cartItems = MilPaginas.storage.get('cart_items', []);
        const filteredItems = cartItems.filter(item => item.bookId != bookId);
        
        MilPaginas.storage.set('cart_items', filteredItems);
        updateLocalStorageCount(filteredItems.reduce((total, item) => total + item.quantity, 0));
        loadMiniCartItems();
        showNotification('Item removido do carrinho', 'success');
    }
    
    function updateLocalStorageCount(count) {
        const cartCountElement = document.getElementById('cart-count');
        if (cartCountElement) {
            cartCountElement.textContent = count || 0;
        }
    }
    
    function clearLocalStorageCart() {
        MilPaginas.storage.remove('cart_items');
        updateLocalStorageCount(0);
    }
    
    // Função global para adicionar ao carrinho (usada em outras páginas)
    window.addToCartGlobal = function(bookId, quantity = 1) {
        <c:choose>
            <c:when test="${not empty sessionScope.user}">
                // Usuário logado - enviar para servidor
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
                    } else {
                        showNotification(data.message || 'Erro ao adicionar ao carrinho', 'error');
                    }
                })
                .catch(error => {
                    console.error('Erro:', error);
                    showNotification('Erro ao adicionar ao carrinho', 'error');
                });
            </c:when>
            <c:otherwise>
                // Usuário não logado - usar localStorage
                addToLocalStorageCart(bookId, quantity);
            </c:otherwise>
        </c:choose>
    };
    
    // Inicializar contador na página inicial
    document.addEventListener('DOMContentLoaded', function() {
        <c:if test="${empty sessionScope.user}">
            const cartItems = MilPaginas.storage.get('cart_items', []);
            updateLocalStorageCount(cartItems.reduce((total, item) => total + item.quantity, 0));
        </c:if>
    });
</script>