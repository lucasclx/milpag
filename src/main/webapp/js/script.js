// Mil Páginas - JavaScript Principal

document.addEventListener('DOMContentLoaded', function() {
    // Inicializar componentes
    initializeNavigation();
    initializeMessages();
    initializeFormValidation();
    initializeAnimations();
    initializeToastContainer();
});

// Navegação
function initializeNavigation() {
    // Mobile menu toggle
    const mobileToggle = document.querySelector('.mobile-menu-toggle');
    const navbarMenu = document.querySelector('.navbar-menu');
    
    if (mobileToggle && navbarMenu) {
        mobileToggle.addEventListener('click', function() {
            navbarMenu.classList.toggle('active');
            
            // Animar ícone do menu
            const icon = this.querySelector('i');
            if (navbarMenu.classList.contains('active')) {
                icon.classList.remove('fa-bars');
                icon.classList.add('fa-times');
            } else {
                icon.classList.remove('fa-times');
                icon.classList.add('fa-bars');
            }
        });
        
        // Fechar menu ao clicar fora
        document.addEventListener('click', function(e) {
            if (!mobileToggle.contains(e.target) && !navbarMenu.contains(e.target)) {
                navbarMenu.classList.remove('active');
                const icon = mobileToggle.querySelector('i');
                icon.classList.remove('fa-times');
                icon.classList.add('fa-bars');
            }
        });
    }
    
    // Dropdown menus
    const dropdowns = document.querySelectorAll('.dropdown');
    dropdowns.forEach(dropdown => {
        const toggle = dropdown.querySelector('.dropdown-toggle');
        const menu = dropdown.querySelector('.dropdown-menu');
        
        if (toggle && menu) {
            toggle.addEventListener('click', function(e) {
                e.preventDefault();
                
                // Fechar outros dropdowns
                dropdowns.forEach(otherDropdown => {
                    if (otherDropdown !== dropdown) {
                        const otherMenu = otherDropdown.querySelector('.dropdown-menu');
                        if (otherMenu) {
                            otherMenu.classList.remove('active');
                        }
                    }
                });
                
                // Toggle do dropdown atual
                menu.classList.toggle('active');
            });
        }
    });
    
    // Fechar dropdowns ao clicar fora
    document.addEventListener('click', function(e) {
        dropdowns.forEach(dropdown => {
            const toggle = dropdown.querySelector('.dropdown-toggle');
            const menu = dropdown.querySelector('.dropdown-menu');
            
            if (toggle && menu && !dropdown.contains(e.target)) {
                menu.classList.remove('active');
            }
        });
    });
}

// Sistema de mensagens
function initializeMessages() {
    // Auto-hide mensagens após 5 segundos
    const messages = document.querySelectorAll('.alert');
    messages.forEach(message => {
        setTimeout(() => {
            message.style.opacity = '0';
            setTimeout(() => {
                if (message.parentNode) {
                    message.parentNode.removeChild(message);
                }
            }, 300);
        }, 5000);
    });
}

// Validação de formulários
function initializeFormValidation() {
    // Validação em tempo real
    const inputs = document.querySelectorAll('input[required], textarea[required], select[required]');
    inputs.forEach(input => {
        input.addEventListener('blur', function() {
            validateField(this);
        });
        
        input.addEventListener('input', function() {
            if (this.classList.contains('is-invalid')) {
                validateField(this);
            }
        });
    });
    
    // Validação de email
    const emailInputs = document.querySelectorAll('input[type="email"]');
    emailInputs.forEach(input => {
        input.addEventListener('blur', function() {
            validateEmail(this);
        });
    });
    
    // Validação de senhas
    const passwordInputs = document.querySelectorAll('input[type="password"]');
    passwordInputs.forEach(input => {
        if (input.name === 'confirmarSenha') {
            input.addEventListener('input', function() {
                validatePasswordMatch();
            });
        }
    });
}

// Validar campo individual
function validateField(field) {
    const value = field.value.trim();
    let isValid = true;
    let message = '';
    
    // Verificar se é obrigatório
    if (field.hasAttribute('required') && !value) {
        isValid = false;
        message = 'Este campo é obrigatório';
    }
    
    // Verificar comprimento mínimo
    if (value && field.hasAttribute('minlength')) {
        const minLength = parseInt(field.getAttribute('minlength'));
        if (value.length < minLength) {
            isValid = false;
            message = `Deve ter pelo menos ${minLength} caracteres`;
        }
    }
    
    // Aplicar estilo de validação
    if (isValid) {
        field.classList.remove('is-invalid');
        field.classList.add('is-valid');
        removeFieldError(field);
    } else {
        field.classList.remove('is-valid');
        field.classList.add('is-invalid');
        showFieldError(field, message);
    }
    
    return isValid;
}

// Validar email
function validateEmail(field) {
    const email = field.value.trim();
    const emailRegex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
    
    if (email && !emailRegex.test(email)) {
        field.classList.add('is-invalid');
        showFieldError(field, 'Email inválido');
        return false;
    }
    
    return validateField(field);
}

// Validar coincidência de senhas
function validatePasswordMatch() {
    const senha = document.getElementById('senha');
    const confirmarSenha = document.getElementById('confirmarSenha');
    const message = document.getElementById('password-match-message');
    
    if (!senha || !confirmarSenha) return;
    
    if (confirmarSenha.value === '') {
        if (message) {
            message.textContent = '';
            message.className = 'field-message';
        }
        return;
    }
    
    if (senha.value === confirmarSenha.value) {
        confirmarSenha.classList.remove('is-invalid');
        confirmarSenha.classList.add('is-valid');
        if (message) {
            message.textContent = 'Senhas coincidem ✓';
            message.className = 'field-message success';
        }
        return true;
    } else {
        confirmarSenha.classList.remove('is-valid');
        confirmarSenha.classList.add('is-invalid');
        if (message) {
            message.textContent = 'Senhas não coincidem';
            message.className = 'field-message error';
        }
        return false;
    }
}

// Mostrar erro no campo
function showFieldError(field, message) {
    removeFieldError(field);
    
    const errorDiv = document.createElement('div');
    errorDiv.className = 'field-error';
    errorDiv.textContent = message;
    errorDiv.style.color = '#e74c3c';
    errorDiv.style.fontSize = '0.9rem';
    errorDiv.style.marginTop = '0.25rem';
    
    field.parentNode.insertBefore(errorDiv, field.nextSibling);
}

// Remover erro do campo
function removeFieldError(field) {
    const existingError = field.parentNode.querySelector('.field-error');
    if (existingError) {
        existingError.remove();
    }
}

// Animações
function initializeAnimations() {
    // Observador de interseção para animações de scroll
    const observerOptions = {
        threshold: 0.1,
        rootMargin: '0px 0px -50px 0px'
    };
    
    const observer = new IntersectionObserver(function(entries) {
        entries.forEach(entry => {
            if (entry.isIntersecting) {
                entry.target.classList.add('fade-in');
            }
        });
    }, observerOptions);
    
    // Observar elementos animáveis
    const animateElements = document.querySelectorAll('.book-card, .category-card, .feature-item');
    animateElements.forEach(el => {
        observer.observe(el);
    });
}

// Mostrar mensagem para o usuário
function showMessage(message, type = 'info', duration = 5000) {
    // Remover mensagens existentes
    const existingMessages = document.querySelectorAll('.message');
    existingMessages.forEach(msg => msg.remove());
    
    // Criar nova mensagem
    const messageDiv = document.createElement('div');
    messageDiv.className = `message ${type}`;
    messageDiv.textContent = message;
    
    // Adicionar à página
    document.body.appendChild(messageDiv);
    
    // Auto-remover após duração especificada
    setTimeout(() => {
        messageDiv.style.opacity = '0';
        setTimeout(() => {
            if (messageDiv.parentNode) {
                messageDiv.parentNode.removeChild(messageDiv);
            }
        }, 300);
    }, duration);
}

// Utilitários para AJAX
function makeRequest(url, options = {}) {
    const defaultOptions = {
        method: 'GET',
        headers: {
            'Content-Type': 'application/json',
        },
    };
    
    const mergedOptions = { ...defaultOptions, ...options };
    
    return fetch(url, mergedOptions)
        .then(response => {
            if (!response.ok) {
                throw new Error(`HTTP error! status: ${response.status}`);
            }
            
            const contentType = response.headers.get('content-type');
            if (contentType && contentType.includes('application/json')) {
                return response.json();
            } else {
                return response.text();
            }
        })
        .catch(error => {
            console.error('Request failed:', error);
            throw error;
        });
}

// Formatação de moeda
function formatCurrency(value) {
    return new Intl.NumberFormat('pt-BR', {
        style: 'currency',
        currency: 'BRL'
    }).format(value);
}

// Formatação de data
function formatDate(date) {
    return new Intl.DateTimeFormat('pt-BR').format(new Date(date));
}

// Debounce para otimizar eventos
function debounce(func, wait, immediate) {
    let timeout;
    return function executedFunction(...args) {
        const later = () => {
            timeout = null;
            if (!immediate) func(...args);
        };
        const callNow = immediate && !timeout;
        clearTimeout(timeout);
        timeout = setTimeout(later, wait);
        if (callNow) func(...args);
    };
}

// Throttle para otimizar eventos
function throttle(func, limit) {
    let inThrottle;
    return function(...args) {
        if (!inThrottle) {
            func.apply(this, args);
            inThrottle = true;
            setTimeout(() => inThrottle = false, limit);
        }
    };
}

// Utilitários para localStorage
const storage = {
    set: function(key, value) {
        try {
            localStorage.setItem(key, JSON.stringify(value));
        } catch (e) {
            console.warn('Failed to save to localStorage:', e);
        }
    },
    
    get: function(key, defaultValue = null) {
        try {
            const item = localStorage.getItem(key);
            return item ? JSON.parse(item) : defaultValue;
        } catch (e) {
            console.warn('Failed to read from localStorage:', e);
            return defaultValue;
        }
    },
    
    remove: function(key) {
        try {
            localStorage.removeItem(key);
        } catch (e) {
            console.warn('Failed to remove from localStorage:', e);
        }
    },
    
    clear: function() {
        try {
            localStorage.clear();
        } catch (e) {
            console.warn('Failed to clear localStorage:', e);
        }
    }
};

// Funções para carrinho de compras
const cart = {
    add: function(bookId, quantity = 1) {
        const formData = new FormData();
        formData.append('action', 'add');
        formData.append('bookId', bookId);
        formData.append('quantity', quantity);
        
        return fetch('cart', {
            method: 'POST',
            body: formData
        })
        .then(response => response.json())
        .then(data => {
            if (data.success) {
                showToast('Livro adicionado ao carrinho!', 'success');
                this.updateCount();
                this.animateCartCount();
            } else {
                showToast(data.message || 'Erro ao adicionar ao carrinho', 'error');
            }
            return data;
        })
        .catch(error => {
            console.error('Erro:', error);
            showToast('Erro ao adicionar ao carrinho', 'error');
            throw error;
        });
    },
    
    remove: function(itemId) {
        return fetch('cart', {
            method: 'POST',
            headers: {
                'Content-Type': 'application/x-www-form-urlencoded',
            },
            body: `action=remove&cartItemId=${itemId}`
        })
        .then(response => response.json())
        .then(data => {
            if (data.success) {
                showToast('Item removido do carrinho', 'success');
                this.updateCount();
            } else {
                showToast('Erro ao remover item', 'error');
            }
            return data;
        })
        .catch(error => {
            console.error('Erro ao remover item:', error);
            showToast('Erro ao remover item', 'error');
            throw error;
        });
    },
    
    updateQuantity: function(itemId, quantity) {
        return fetch('cart', {
            method: 'POST',
            headers: {
                'Content-Type': 'application/x-www-form-urlencoded',
            },
            body: `action=updateQuantity&cartItemId=${itemId}&quantity=${quantity}`
        })
        .then(response => response.json())
        .then(data => {
            if (data.success) {
                this.updateCount();
            } else {
                showToast('Erro ao atualizar quantidade', 'error');
            }
            return data;
        })
        .catch(error => {
            console.error('Erro ao atualizar quantidade:', error);
            showToast('Erro ao atualizar quantidade', 'error');
            throw error;
        });
    },
    
    clear: function() {
        return fetch('cart', {
            method: 'POST',
            headers: {
                'Content-Type': 'application/x-www-form-urlencoded',
            },
            body: 'action=clear'
        })
        .then(response => response.json())
        .then(data => {
            if (data.success) {
                showToast('Carrinho limpo', 'success');
                this.updateCount();
            } else {
                showToast('Erro ao limpar carrinho', 'error');
            }
            return data;
        })
        .catch(error => {
            console.error('Erro ao limpar carrinho:', error);
            showToast('Erro ao limpar carrinho', 'error');
            throw error;
        });
    },
    
    updateCount: function() {
        return fetch('cart?action=count')
            .then(response => response.json())
            .then(data => {
                if (data.success && data.data) {
                    const cartCountElement = document.getElementById('cart-count');
                    if (cartCountElement) {
                        cartCountElement.textContent = data.data.cartCount || 0;
                    }
                }
                return data;
            })
            .catch(error => {
                console.error('Erro ao atualizar contador do carrinho:', error);
            });
    },
    
    animateCartCount: function() {
        const cartCountElement = document.getElementById('cart-count');
        if (cartCountElement) {
            cartCountElement.classList.add('animated');
            setTimeout(() => {
                cartCountElement.classList.remove('animated');
            }, 300);
        }
    },
    
    // Funções para localStorage (usuários não logados)
    addToLocal: function(bookId, quantity = 1) {
        const cartItems = storage.get('cart_items', []);
        const existingItem = cartItems.find(item => item.bookId == bookId);
        
        if (existingItem) {
            existingItem.quantity += quantity;
        } else {
            cartItems.push({ bookId: parseInt(bookId), quantity: quantity });
        }
        
        storage.set('cart_items', cartItems);
        this.updateLocalCount();
        showToast('Livro adicionado ao carrinho!', 'success');
        this.animateCartCount();
    },
    
    removeFromLocal: function(bookId) {
        const cartItems = storage.get('cart_items', []);
        const filteredItems = cartItems.filter(item => item.bookId != bookId);
        
        storage.set('cart_items', filteredItems);
        this.updateLocalCount();
        showToast('Item removido do carrinho', 'success');
    },
    
    updateLocalQuantity: function(bookId, quantity) {
        const cartItems = storage.get('cart_items', []);
        const item = cartItems.find(item => item.bookId == bookId);
        
        if (item) {
            if (quantity <= 0) {
                this.removeFromLocal(bookId);
            } else {
                item.quantity = quantity;
                storage.set('cart_items', cartItems);
                this.updateLocalCount();
            }
        }
    },
    
    clearLocal: function() {
        storage.remove('cart_items');
        this.updateLocalCount();
        showToast('Carrinho limpo', 'success');
    },
    
    updateLocalCount: function() {
        const cartItems = storage.get('cart_items', []);
        const totalCount = cartItems.reduce((total, item) => total + item.quantity, 0);
        
        const cartCountElement = document.getElementById('cart-count');
        if (cartCountElement) {
            cartCountElement.textContent = totalCount;
        }
    },
    
    getLocalItems: function() {
        return storage.get('cart_items', []);
    },
    
    // Função universal que detecta se o usuário está logado
    addItem: function(bookId, quantity = 1) {
        // Esta função será chamada pelo addToCartGlobal no header
        if (typeof addToCartGlobal === 'function') {
            return addToCartGlobal(bookId, quantity);
        } else {
            // Fallback para localStorage
            this.addToLocal(bookId, quantity);
        }
    }
};

// Lazy loading para imagens
function initializeLazyLoading() {
    const images = document.querySelectorAll('img[data-src]');
    
    const imageObserver = new IntersectionObserver((entries, observer) => {
        entries.forEach(entry => {
            if (entry.isIntersecting) {
                const img = entry.target;
                img.src = img.dataset.src;
                img.classList.remove('lazy');
                imageObserver.unobserve(img);
            }
        });
    });
    
    images.forEach(img => imageObserver.observe(img));
}

// Máscara para telefone
function phoneMask(input) {
    let value = input.value.replace(/\D/g, '');
    value = value.replace(/^(\d{2})(\d)/g, '($1) $2');
    value = value.replace(/(\d)(\d{4})$/, '$1-$2');
    input.value = value;
}

// Máscara para CEP
function cepMask(input) {
    let value = input.value.replace(/\D/g, '');
    value = value.replace(/^(\d{5})(\d{3})$/, '$1-$2');
    input.value = value;
}

// Validação de CPF
function validateCPF(cpf) {
    cpf = cpf.replace(/[^\d]+/g, '');
    
    if (cpf.length !== 11 || /^(.)\1{10}$/.test(cpf)) {
        return false;
    }
    
    let soma = 0;
    for (let i = 0; i < 9; i++) {
        soma += parseInt(cpf.charAt(i)) * (10 - i);
    }
    
    let resto = 11 - (soma % 11);
    if (resto === 10 || resto === 11) resto = 0;
    if (resto !== parseInt(cpf.charAt(9))) return false;
    
    soma = 0;
    for (let i = 0; i < 10; i++) {
        soma += parseInt(cpf.charAt(i)) * (11 - i);
    }
    
    resto = 11 - (soma % 11);
    if (resto === 10 || resto === 11) resto = 0;
    return resto === parseInt(cpf.charAt(10));
}

// Scroll suave para âncoras
function initializeSmoothScroll() {
    const links = document.querySelectorAll('a[href^="#"]');
    
    links.forEach(link => {
        link.addEventListener('click', function(e) {
            e.preventDefault();
            
            const targetId = this.getAttribute('href').substring(1);
            const targetElement = document.getElementById(targetId);
            
            if (targetElement) {
                targetElement.scrollIntoView({
                    behavior: 'smooth',
                    block: 'start'
                });
            }
        });
    });
}

// Inicializar funcionalidades adicionais quando necessário
function initializeAdditionalFeatures() {
    initializeLazyLoading();
    initializeSmoothScroll();
    
    // Aplicar máscaras de telefone
    const phoneInputs = document.querySelectorAll('input[type="tel"]');
    phoneInputs.forEach(input => {
        input.addEventListener('input', function() {
            phoneMask(this);
        });
    });
    
    // Aplicar máscaras de CEP
    const cepInputs = document.querySelectorAll('input[name="cep"]');
    cepInputs.forEach(input => {
        input.addEventListener('input', function() {
            cepMask(this);
        });
    });
}

// Chamar funcionalidades adicionais quando o DOM estiver pronto
if (document.readyState === 'loading') {
    document.addEventListener('DOMContentLoaded', initializeAdditionalFeatures);
} else {
    initializeAdditionalFeatures();
}

// Inicializar container de toast
function initializeToastContainer() {
    if (!document.getElementById('toast-container')) {
        const container = document.createElement('div');
        container.id = 'toast-container';
        container.className = 'toast-container';
        document.body.appendChild(container);
    }
}

// Sistema de Notificações Toast Melhorado
function showToast(message, type = 'info', duration = 5000) {
    const container = document.getElementById('toast-container');
    if (!container) {
        initializeToastContainer();
        return showToast(message, type, duration);
    }
    
    const toast = document.createElement('div');
    toast.className = `toast toast-${type}`;
    
    // Definir ícones para cada tipo
    const icons = {
        success: 'fas fa-check-circle',
        error: 'fas fa-exclamation-circle',
        warning: 'fas fa-exclamation-triangle',
        info: 'fas fa-info-circle'
    };
    
    toast.innerHTML = `
        <div class="toast-content">
            <i class="${icons[type] || icons.info}"></i>
            <span class="toast-message">${message}</span>
        </div>
        <button class="toast-close" onclick="removeToast(this.parentElement)">
            <i class="fas fa-times"></i>
        </button>
    `;
    
    // Adicionar ao container
    container.appendChild(toast);
    
    // Animar entrada
    setTimeout(() => {
        toast.classList.add('show');
    }, 100);
    
    // Auto-remover
    if (duration > 0) {
        setTimeout(() => {
            removeToast(toast);
        }, duration);
    }
    
    return toast;
}

// Remover toast
function removeToast(toast) {
    if (toast && toast.parentElement) {
        toast.classList.add('hide');
        setTimeout(() => {
            if (toast.parentElement) {
                toast.parentElement.removeChild(toast);
            }
        }, 300);
    }
}

// Exportar funções úteis para uso global
window.MilPaginas = {
    showMessage,
    showToast,
    removeToast,
    makeRequest,
    formatCurrency,
    formatDate,
    debounce,
    throttle,
    storage,
    cart,
    validateCPF,
    phoneMask,
    cepMask
};