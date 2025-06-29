// Mil Páginas - JavaScript Simplificado e Funcional

// Esperar o DOM carregar
document.addEventListener('DOMContentLoaded', function() {
    console.log('Mil Páginas - JavaScript carregado');
    
    // Inicializar componentes
    initializeButtons();
    initializeForms();
    initializeNavigation();
    
    // Garantir que as funções globais estejam disponíveis
    setupGlobalFunctions();
});

// Inicializar todos os botões da página
function initializeButtons() {
    console.log('Inicializando botões...');
    
    // Botões de adicionar ao carrinho
    const addToCartButtons = document.querySelectorAll('.add-to-cart-btn');
    addToCartButtons.forEach(button => {
        button.addEventListener('click', function(e) {
            e.preventDefault();
            const bookId = this.getAttribute('data-book-id') || this.dataset.bookId;
            if (bookId) {
                console.log('Clique no botão adicionar carrinho, ID:', bookId);
                addToCartSafe(bookId, 1);
            } else {
                console.error('ID do livro não encontrado no botão');
            }
        });
    });
    
    // Botões de delete (admin)
    const deleteButtons = document.querySelectorAll('.delete-book-btn');
    deleteButtons.forEach(button => {
        button.addEventListener('click', function(e) {
            e.preventDefault();
            const bookId = this.getAttribute('data-book-id') || this.dataset.bookId;
            const bookTitle = this.getAttribute('data-book-title') || 'este livro';
            
            if (confirm(`Tem certeza que deseja excluir "${bookTitle}"? Esta ação não pode ser desfeita.`)) {
                deleteBook(bookId);
            }
        });
    });
    
    // Botões de visualizar detalhes
    const detailButtons = document.querySelectorAll('.view-details-btn');
    detailButtons.forEach(button => {
        button.addEventListener('click', function(e) {
            e.preventDefault();
            const bookId = this.getAttribute('data-book-id') || this.dataset.bookId;
            if (bookId) {
                window.location.href = `${getContextPath()}/books?action=view&id=${bookId}`;
            }
        });
    });
    
    console.log(`Botões inicializados: ${addToCartButtons.length} carrinho, ${deleteButtons.length} delete`);
}

// Inicializar formulários
function initializeForms() {
    // Validação de formulários
    const forms = document.querySelectorAll('form');
    forms.forEach(form => {
        form.addEventListener('submit', function(e) {
            if (!validateForm(this)) {
                e.preventDefault();
            }
        });
    });
    
    // Máscaras de telefone
    const phoneInputs = document.querySelectorAll('input[type="tel"]');
    phoneInputs.forEach(input => {
        input.addEventListener('input', function() {
            applyPhoneMask(this);
        });
    });
}

// Inicializar navegação
function initializeNavigation() {
    // Links de navegação
    const navLinks = document.querySelectorAll('.navbar-nav a');
    navLinks.forEach(link => {
        link.addEventListener('click', function(e) {
            // Se não tem href válido, prevenir
            if (!this.href || this.href === '#') {
                e.preventDefault();
            }
        });
    });
}

// Configurar funções globais
function setupGlobalFunctions() {
    // Função global para adicionar ao carrinho
    window.addToCart = addToCartSafe;
    window.updateCartCount = updateCartCount;
    window.showMessage = showMessage;
    window.deleteBook = deleteBook;
}

// Função segura para adicionar ao carrinho
function addToCartSafe(bookId, quantity = 1) {
    console.log('addToCartSafe chamada:', bookId, quantity);
    
    // Verificar se o usuário está logado
    if (!isUserLoggedIn()) {
        showMessage('Você precisa estar logado para adicionar itens ao carrinho.', 'warning');
        setTimeout(() => {
            window.location.href = `${getContextPath()}/login`;
        }, 2000);
        return;
    }
    
    // Verificar se o bookId é válido
    if (!bookId || isNaN(bookId)) {
        showMessage('ID do livro inválido', 'error');
        return;
    }
    
    // Preparar dados
    const formData = new FormData();
    formData.append('action', 'add');
    formData.append('bookId', bookId);
    formData.append('quantity', quantity);
    
    // Fazer requisição
    fetch(`${getContextPath()}/cart`, {
        method: 'POST',
        body: formData
    })
    .then(response => {
        if (!response.ok) {
            throw new Error(`HTTP ${response.status}: ${response.statusText}`);
        }
        return response.json();
    })
    .then(data => {
        console.log('Resposta do servidor:', data);
        if (data.success) {
            showMessage('Livro adicionado ao carrinho!', 'success');
            updateCartCount();
        } else {
            showMessage(data.message || 'Erro ao adicionar ao carrinho', 'error');
        }
    })
    .catch(error => {
        console.error('Erro ao adicionar ao carrinho:', error);
        showMessage('Erro de comunicação com o servidor', 'error');
    });
}

// Função para deletar livro (admin)
function deleteBook(bookId) {
    console.log('Deletando livro:', bookId);
    
    const formData = new FormData();
    formData.append('action', 'delete');
    formData.append('id', bookId);
    
    fetch(`${getContextPath()}/books`, {
        method: 'POST',
        body: formData
    })
    .then(response => {
        if (response.ok) {
            showMessage('Livro excluído com sucesso!', 'success');
            // Remover o card da página
            const bookCard = document.querySelector(`[data-book-id="${bookId}"]`)?.closest('.book-card');
            if (bookCard) {
                bookCard.remove();
            }
        } else {
            throw new Error('Erro ao excluir livro');
        }
    })
    .catch(error => {
        console.error('Erro:', error);
        showMessage('Erro ao excluir livro', 'error');
    });
}

// Atualizar contador do carrinho
function updateCartCount() {
    if (!isUserLoggedIn()) return;
    
    fetch(`${getContextPath()}/cart?action=count`)
        .then(response => response.json())
        .then(data => {
            if (data.success && data.data) {
                const cartCount = document.getElementById('cart-count');
                if (cartCount) {
                    cartCount.textContent = data.data.cartCount || 0;
                }
            }
        })
        .catch(error => {
            console.error('Erro ao atualizar contador:', error);
        });
}

// Verificar se usuário está logado
function isUserLoggedIn() {
    // Método 1: Verificar variável global definida no header
    if (typeof window.isUserLoggedIn !== 'undefined') {
        return window.isUserLoggedIn;
    }
    
    // Método 2: Verificar se existe menu de usuário
    const userMenu = document.querySelector('.dropdown-toggle');
    if (userMenu && userMenu.textContent.trim() !== 'Entrar') {
        return true;
    }
    
    // Método 3: Verificar se existe link de logout
    const logoutLink = document.querySelector('a[href*="logout"]');
    return !!logoutLink;
}

// Obter o context path da aplicação
function getContextPath() {
    // Método 1: Usar variável global
    if (typeof window.contextPath !== 'undefined') {
        return window.contextPath;
    }
    
    // Método 2: Extrair do caminho atual
    const pathArray = window.location.pathname.split('/');
    return pathArray.length > 1 ? '/' + pathArray[1] : '';
}

// Sistema de mensagens
function showMessage(message, type = 'info') {
    console.log(`Mensagem (${type}):`, message);
    
    // Remover mensagens existentes
    const existingMessages = document.querySelectorAll('.temp-message');
    existingMessages.forEach(msg => msg.remove());
    
    // Criar nova mensagem
    const messageDiv = document.createElement('div');
    messageDiv.className = `temp-message temp-message-${type}`;
    messageDiv.innerHTML = `
        <i class="fas fa-${getIconForType(type)}"></i>
        <span>${message}</span>
        <button onclick="this.parentElement.remove()" style="margin-left: auto;">&times;</button>
    `;
    
    // Aplicar estilos inline para garantir que funcione
    Object.assign(messageDiv.style, {
        position: 'fixed',
        top: '20px',
        right: '20px',
        background: getColorForType(type),
        color: 'white',
        padding: '15px 20px',
        borderRadius: '8px',
        boxShadow: '0 4px 12px rgba(0,0,0,0.15)',
        zIndex: '9999',
        display: 'flex',
        alignItems: 'center',
        gap: '10px',
        maxWidth: '400px',
        animation: 'slideIn 0.3s ease'
    });
    
    // Estilo do botão
    const button = messageDiv.querySelector('button');
    Object.assign(button.style, {
        background: 'none',
        border: 'none',
        color: 'white',
        fontSize: '18px',
        cursor: 'pointer'
    });
    
    document.body.appendChild(messageDiv);
    
    // Auto-remover após 5 segundos
    setTimeout(() => {
        if (messageDiv.parentElement) {
            messageDiv.remove();
        }
    }, 5000);
}

// Utilitários para mensagens
function getIconForType(type) {
    const icons = {
        success: 'check-circle',
        error: 'exclamation-circle',
        warning: 'exclamation-triangle',
        info: 'info-circle'
    };
    return icons[type] || icons.info;
}

function getColorForType(type) {
    const colors = {
        success: '#28a745',
        error: '#dc3545',
        warning: '#ffc107',
        info: '#17a2b8'
    };
    return colors[type] || colors.info;
}

// Validação simples de formulário
function validateForm(form) {
    const requiredFields = form.querySelectorAll('[required]');
    let isValid = true;
    
    requiredFields.forEach(field => {
        if (!field.value.trim()) {
            field.style.borderColor = '#dc3545';
            isValid = false;
        } else {
            field.style.borderColor = '';
        }
    });
    
    if (!isValid) {
        showMessage('Por favor, preencha todos os campos obrigatórios', 'error');
    }
    
    return isValid;
}

// Máscara para telefone
function applyPhoneMask(input) {
    let value = input.value.replace(/\D/g, '');
    if (value.length <= 11) {
        value = value.replace(/^(\d{2})(\d)/g, '($1) $2');
        value = value.replace(/(\d)(\d{4})$/, '$1-$2');
        input.value = value;
    }
}

// Log para debug
console.log('Mil Páginas - JavaScript carregado e pronto!');