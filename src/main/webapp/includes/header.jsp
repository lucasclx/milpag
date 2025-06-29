<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<!-- HEADER DE EMERGÊNCIA - SEM EL COMPLEXO -->
<header style="background: #2c3e50; color: white; padding: 1rem;">
    <div style="max-width: 1200px; margin: 0 auto; display: flex; justify-content: space-between; align-items: center; flex-wrap: wrap; gap: 1rem;">
        
        <!-- Logo -->
        <a href="<%= request.getContextPath() %>/index.jsp" style="color: white; text-decoration: none; font-size: 1.5rem; font-weight: bold;">
            📚 Mil Páginas
        </a>
        
        <!-- Busca -->
        <form action="<%= request.getContextPath() %>/books" method="get" style="display: flex; gap: 0.5rem;">
            <input type="hidden" name="action" value="search">
            <input type="text" name="q" placeholder="Buscar livros..." 
                   style="padding: 0.5rem; border: none; border-radius: 4px; min-width: 200px;">
            <button type="submit" style="padding: 0.5rem 1rem; background: #3498db; color: white; border: none; border-radius: 4px; cursor: pointer;">
                🔍
            </button>
        </form>
        
        <!-- Menu -->
        <nav style="display: flex; gap: 1rem; align-items: center;">
            <a href="<%= request.getContextPath() %>/books" style="color: white; text-decoration: none; padding: 0.5rem;">
                📖 Livros
            </a>
            
            <% 
            Object user = session.getAttribute("user");
            String userName = (String) session.getAttribute("userName");
            Boolean isAdmin = (Boolean) session.getAttribute("isAdmin");
            
            if (user != null) { 
            %>
                <!-- Usuário Logado -->
                <span style="color: white;">Olá, <%= userName != null ? userName : "Usuário" %></span>
                
                <a href="<%= request.getContextPath() %>/cart" style="color: white; text-decoration: none; padding: 0.5rem;">
                    🛒 Carrinho <span id="cart-count" style="background: #e74c3c; padding: 2px 6px; border-radius: 50%; font-size: 0.8rem;">0</span>
                </a>
                
                <% if (isAdmin != null && isAdmin) { %>
                    <a href="<%= request.getContextPath() %>/admin/dashboard.jsp" style="color: #f39c12; text-decoration: none; padding: 0.5rem;">
                        ⚙️ Admin
                    </a>
                <% } %>
                
                <a href="<%= request.getContextPath() %>/logout" style="color: white; text-decoration: none; padding: 0.5rem;">
                    🚪 Sair
                </a>
            <% } else { %>
                <!-- Usuário NÃO Logado -->
                <a href="<%= request.getContextPath() %>/login" style="color: white; text-decoration: none; padding: 0.5rem;">
                    🔑 Entrar
                </a>
                <a href="<%= request.getContextPath() %>/register" style="color: white; text-decoration: none; padding: 0.5rem 1rem; background: #27ae60; border-radius: 4px;">
                    📝 Cadastrar
                </a>
            <% } %>
        </nav>
    </div>
</header>

<!-- JavaScript SIMPLES -->
<script>
console.log('Header de emergência carregado!');

// Função GLOBAL para adicionar ao carrinho
window.addToCart = function(bookId, quantity) {
    quantity = quantity || 1;
    console.log('Adicionando ao carrinho:', bookId, quantity);
    
    <% if (user != null) { %>
        // Usuário logado - enviar para servidor
        var formData = new FormData();
        formData.append('action', 'add');
        formData.append('bookId', bookId);
        formData.append('quantity', quantity);
        
        fetch('<%= request.getContextPath() %>/cart', {
            method: 'POST',
            body: formData
        })
        .then(function(response) { return response.json(); })
        .then(function(data) {
            if (data.success) {
                alert('✅ Livro adicionado ao carrinho!');
                updateCartCount();
            } else {
                alert('❌ ' + (data.message || 'Erro ao adicionar'));
            }
        })
        .catch(function(error) {
            console.error('Erro:', error);
            alert('❌ Erro de comunicação');
        });
    <% } else { %>
        // Usuário não logado
        alert('⚠️ Você precisa estar logado para adicionar itens ao carrinho');
        window.location.href = '<%= request.getContextPath() %>/login';
    <% } %>
};

// Atualizar contador do carrinho
function updateCartCount() {
    <% if (user != null) { %>
        fetch('<%= request.getContextPath() %>/cart?action=count')
            .then(function(response) { return response.json(); })
            .then(function(data) {
                if (data.success && data.data) {
                    var cartCount = document.getElementById('cart-count');
                    if (cartCount) {
                        cartCount.textContent = data.data.cartCount || 0;
                    }
                }
            })
            .catch(function(error) {
                console.error('Erro ao atualizar carrinho:', error);
            });
    <% } %>
}

// Atualizar contador quando carregar
document.addEventListener('DOMContentLoaded', function() {
    updateCartCount();
});
</script>