<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="pt-BR">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Finalizar Compra - Mil Páginas</title>
    <link rel="stylesheet" href="css/style.css">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
</head>
<body>
    <jsp:include page="includes/header.jsp" />
    
    <main>
        <div class="container">
            <div class="page-header">
                <h1><i class="fas fa-credit-card"></i> Finalizar Compra</h1>
                <nav class="breadcrumb">
                    <a href="index.jsp">Início</a> / 
                    <a href="cart">Carrinho</a> / 
                    <span>Checkout</span>
                </nav>
            </div>
            
            <c:if test="${not empty error}">
                <div class="alert alert-error">
                    <i class="fas fa-exclamation-circle"></i>
                    ${error}
                </div>
            </c:if>
            
            <div class="checkout-container">
                <div class="checkout-form-section">
                    <form action="orders" method="post" class="checkout-form" id="checkout-form">
                        <input type="hidden" name="action" value="create">
                        
                        <!-- Informações de Entrega -->
                        <div class="form-section">
                            <h2><i class="fas fa-truck"></i> Informações de Entrega</h2>
                            
                            <div class="form-row">
                                <div class="form-group">
                                    <label for="nomeEntrega">Nome Completo *</label>
                                    <input type="text" id="nomeEntrega" name="nomeEntrega" required 
                                           value="${sessionScope.user.nome}" class="form-control">
                                </div>
                                
                                <div class="form-group">
                                    <label for="telefoneEntrega">Telefone *</label>
                                    <input type="tel" id="telefoneEntrega" name="telefoneEntrega" required 
                                           value="${sessionScope.user.telefone}" class="form-control">
                                </div>
                            </div>
                            
                            <div class="form-group">
                                <label for="enderecoEntrega">Endereço Completo *</label>
                                <textarea id="enderecoEntrega" name="enderecoEntrega" rows="4" required 
                                          class="form-control" placeholder="Rua, número, bairro, cidade, estado, CEP">${sessionScope.user.endereco}</textarea>
                            </div>
                            
                            <div class="form-row">
                                <div class="form-group">
                                    <label for="cep">CEP *</label>
                                    <input type="text" id="cep" name="cep" required 
                                           class="form-control" placeholder="00000-000">
                                </div>
                                
                                <div class="form-group">
                                    <label for="cidade">Cidade *</label>
                                    <input type="text" id="cidade" name="cidade" required 
                                           class="form-control" placeholder="Sua cidade">
                                </div>
                            </div>
                        </div>
                        
                        <!-- Forma de Pagamento -->
                        <div class="form-section">
                            <h2><i class="fas fa-credit-card"></i> Forma de Pagamento</h2>
                            
                            <div class="payment-options">
                                <div class="payment-option">
                                    <input type="radio" id="cartao" name="formaPagamento" value="cartao" checked>
                                    <label for="cartao">
                                        <i class="fas fa-credit-card"></i>
                                        Cartão de Crédito/Débito
                                    </label>
                                </div>
                                
                                <div class="payment-option">
                                    <input type="radio" id="pix" name="formaPagamento" value="pix">
                                    <label for="pix">
                                        <i class="fas fa-qrcode"></i>
                                        PIX
                                    </label>
                                </div>
                                
                                <div class="payment-option">
                                    <input type="radio" id="boleto" name="formaPagamento" value="boleto">
                                    <label for="boleto">
                                        <i class="fas fa-barcode"></i>
                                        Boleto Bancário
                                    </label>
                                </div>
                            </div>
                            
                            <!-- Detalhes do Cartão (mostrado apenas se cartão selecionado) -->
                            <div id="cartao-details" class="payment-details">
                                <div class="form-row">
                                    <div class="form-group">
                                        <label for="numeroCartao">Número do Cartão *</label>
                                        <input type="text" id="numeroCartao" name="numeroCartao" 
                                               class="form-control" placeholder="0000 0000 0000 0000"
                                               maxlength="19">
                                    </div>
                                    
                                    <div class="form-group">
                                        <label for="nomeCartao">Nome no Cartão *</label>
                                        <input type="text" id="nomeCartao" name="nomeCartao" 
                                               class="form-control" placeholder="Nome como no cartão">
                                    </div>
                                </div>
                                
                                <div class="form-row">
                                    <div class="form-group">
                                        <label for="validadeCartao">Validade *</label>
                                        <input type="text" id="validadeCartao" name="validadeCartao" 
                                               class="form-control" placeholder="MM/AA" maxlength="5">
                                    </div>
                                    
                                    <div class="form-group">
                                        <label for="cvv">CVV *</label>
                                        <input type="text" id="cvv" name="cvv" 
                                               class="form-control" placeholder="000" maxlength="4">
                                    </div>
                                </div>
                            </div>
                        </div>
                        
                        <!-- Observações -->
                        <div class="form-section">
                            <h2><i class="fas fa-comment"></i> Observações</h2>
                            <div class="form-group">
                                <label for="observacoes">Observações do Pedido</label>
                                <textarea id="observacoes" name="observacoes" rows="3" 
                                          class="form-control" placeholder="Informações adicionais sobre a entrega (opcional)"></textarea>
                            </div>
                        </div>
                        
                        <!-- Termos e Condições -->
                        <div class="form-section">
                            <div class="checkbox-group">
                                <label class="checkbox-container">
                                    <input type="checkbox" id="aceitarTermos" required>
                                    <span class="checkmark"></span>
                                    Li e aceito os <a href="terms.jsp" target="_blank">Termos de Uso</a> 
                                    e a <a href="privacy.jsp" target="_blank">Política de Privacidade</a>
                                </label>
                            </div>
                            
                            <div class="checkbox-group">
                                <label class="checkbox-container">
                                    <input type="checkbox" id="confirmarDados">
                                    <span class="checkmark"></span>
                                    Confirmo que todos os dados estão corretos
                                </label>
                            </div>
                        </div>
                        
                        <div class="form-actions">
                            <a href="cart" class="btn btn-outline btn-large">
                                <i class="fas fa-arrow-left"></i>
                                Voltar ao Carrinho
                            </a>
                            <button type="submit" class="btn btn-success btn-large" id="finalize-btn">
                                <i class="fas fa-check"></i>
                                Finalizar Pedido
                            </button>
                        </div>
                    </form>
                </div>
                
                <!-- Resumo do Pedido -->
                <div class="order-summary">
                    <div class="summary-card">
                        <h3><i class="fas fa-receipt"></i> Resumo do Pedido</h3>
                        
                        <div class="summary-items">
                            <c:forEach var="item" items="${cartItems}">
                                <div class="summary-item">
                                    <div class="item-info">
                                        <span class="item-title">${item.livro.titulo}</span>
                                        <span class="item-quantity">Qtd: ${item.quantidade}</span>
                                    </div>
                                    <span class="item-price">
                                        <fmt:formatNumber value="${item.subtotal}" type="currency" currencySymbol="R$" />
                                    </span>
                                </div>
                            </c:forEach>
                        </div>
                        
                        <hr>
                        
                        <div class="summary-totals">
                            <div class="summary-line">
                                <span>Subtotal:</span>
                                <span><fmt:formatNumber value="${cartTotal}" type="currency" currencySymbol="R$" /></span>
                            </div>
                            
                            <div class="summary-line">
                                <span>Frete:</span>
                                <span class="free-shipping">Grátis</span>
                            </div>
                            
                            <div class="summary-line discount" style="display: none;">
                                <span>Desconto:</span>
                                <span id="discount-amount">R$ 0,00</span>
                            </div>
                            
                            <div class="summary-total">
                                <span>Total:</span>
                                <span><fmt:formatNumber value="${cartTotal}" type="currency" currencySymbol="R$" /></span>
                            </div>
                        </div>
                        
                        <!-- Cupom de Desconto -->
                        <div class="coupon-section">
                            <h4>Cupom de Desconto</h4>
                            <div class="coupon-input">
                                <input type="text" id="coupon-code" placeholder="Digite o código do cupom">
                                <button type="button" class="btn btn-outline btn-small" onclick="applyCoupon()">
                                    Aplicar
                                </button>
                            </div>
                        </div>
                        
                        <!-- Informações de Segurança -->
                        <div class="security-info">
                            <h4><i class="fas fa-shield-alt"></i> Compra Segura</h4>
                            <ul>
                                <li><i class="fas fa-lock"></i> Dados protegidos por SSL</li>
                                <li><i class="fas fa-credit-card"></i> Pagamento seguro</li>
                                <li><i class="fas fa-undo"></i> Política de devolução</li>
                            </ul>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </main>
    
    <jsp:include page="includes/footer.jsp" />
    
    <script src="js/script.js"></script>
    <script>
        document.addEventListener('DOMContentLoaded', function() {
            initializeCheckoutForm();
        });
        
        function initializeCheckoutForm() {
            // Máscara para telefone
            const telefoneInput = document.getElementById('telefoneEntrega');
            if (telefoneInput) {
                telefoneInput.addEventListener('input', function() {
                    phoneMask(this);
                });
            }
            
            // Máscara para CEP
            const cepInput = document.getElementById('cep');
            if (cepInput) {
                cepInput.addEventListener('input', function() {
                    cepMask(this);
                });
                
                // Buscar endereço por CEP
                cepInput.addEventListener('blur', function() {
                    const cep = this.value.replace(/\D/g, '');
                    if (cep.length === 8) {
                        fetchAddressByCep(cep);
                    }
                });
            }
            
            // Máscara para cartão de crédito
            const numeroCartaoInput = document.getElementById('numeroCartao');
            if (numeroCartaoInput) {
                numeroCartaoInput.addEventListener('input', function() {
                    cardNumberMask(this);
                });
            }
            
            // Máscara para validade do cartão
            const validadeInput = document.getElementById('validadeCartao');
            if (validadeInput) {
                validadeInput.addEventListener('input', function() {
                    expiryMask(this);
                });
            }
            
            // Controle de formas de pagamento
            const paymentOptions = document.querySelectorAll('input[name="formaPagamento"]');
            paymentOptions.forEach(option => {
                option.addEventListener('change', function() {
                    togglePaymentDetails(this.value);
                });
            });
            
            // Validação do formulário
            const form = document.getElementById('checkout-form');
            form.addEventListener('submit', function(e) {
                if (!validateCheckoutForm()) {
                    e.preventDefault();
                }
            });
        }
        
        function togglePaymentDetails(paymentType) {
            const cartaoDetails = document.getElementById('cartao-details');
            
            if (paymentType === 'cartao') {
                cartaoDetails.style.display = 'block';
                // Tornar campos obrigatórios
                cartaoDetails.querySelectorAll('input').forEach(input => {
                    input.required = true;
                });
            } else {
                cartaoDetails.style.display = 'none';
                // Remover obrigatoriedade
                cartaoDetails.querySelectorAll('input').forEach(input => {
                    input.required = false;
                });
            }
        }
        
        function cardNumberMask(input) {
            let value = input.value.replace(/\D/g, '');
            value = value.replace(/(\d{4})(?=\d)/g, '$1 ');
            input.value = value;
        }
        
        function expiryMask(input) {
            let value = input.value.replace(/\D/g, '');
            if (value.length >= 2) {
                value = value.substring(0, 2) + '/' + value.substring(2, 4);
            }
            input.value = value;
        }
        
        function fetchAddressByCep(cep) {
            fetch(`https://viacep.com.br/ws/${cep}/json/`)
                .then(response => response.json())
                .then(data => {
                    if (!data.erro) {
                        document.getElementById('cidade').value = data.localidade;
                        
                        // Atualizar endereço se estiver vazio
                        const enderecoField = document.getElementById('enderecoEntrega');
                        if (!enderecoField.value.trim()) {
                            enderecoField.value = `${data.logradouro}, ${data.bairro}, ${data.localidade} - ${data.uf}, ${cep}`;
                        }
                    }
                })
                .catch(error => {
                    console.error('Erro ao buscar CEP:', error);
                });
        }
        
        function validateCheckoutForm() {
            const aceitarTermos = document.getElementById('aceitarTermos').checked;
            
            if (!aceitarTermos) {
                showMessage('Você deve aceitar os termos de uso para continuar', 'error');
                return false;
            }
            
            const formaPagamento = document.querySelector('input[name="formaPagamento"]:checked').value;
            
            if (formaPagamento === 'cartao') {
                const numeroCartao = document.getElementById('numeroCartao').value.replace(/\D/g, '');
                const cvv = document.getElementById('cvv').value;
                
                if (numeroCartao.length < 13 || numeroCartao.length > 19) {
                    showMessage('Número do cartão inválido', 'error');
                    return false;
                }
                
                if (cvv.length < 3 || cvv.length > 4) {
                    showMessage('CVV inválido', 'error');
                    return false;
                }
            }
            
            return true;
        }
        
        function applyCoupon() {
            const couponCode = document.getElementById('coupon-code').value.trim();
            
            if (!couponCode) {
                showMessage('Digite um código de cupom', 'warning');
                return;
            }
            
            // Simular aplicação de cupom
            // Em uma implementação real, isso seria uma chamada para o servidor
            const validCoupons = {
                'DESCONTO10': 0.10,
                'PRIMEIRACOMPRA': 0.15,
                'BLACKFRIDAY': 0.20
            };
            
            if (validCoupons[couponCode.toUpperCase()]) {
                const discount = validCoupons[couponCode.toUpperCase()];
                showMessage(`Cupom aplicado! Desconto de ${(discount * 100)}%`, 'success');
                
                // Mostrar desconto no resumo
                const discountLine = document.querySelector('.discount');
                const discountAmount = document.getElementById('discount-amount');
                const total = ${cartTotal};
                const discountValue = total * discount;
                
                discountAmount.textContent = 'R$ ' + discountValue.toFixed(2).replace('.', ',');
                discountLine.style.display = 'flex';
                
                // Atualizar total
                const newTotal = total - discountValue;
                document.querySelector('.summary-total span:last-child').textContent = 
                    'R$ ' + newTotal.toFixed(2).replace('.', ',');
                    
                // Desabilitar input do cupom
                document.getElementById('coupon-code').disabled = true;
            } else {
                showMessage('Cupom inválido ou expirado', 'error');
            }
        }
    </script>
    
    <style>
        .checkout-container {
            display: grid;
            grid-template-columns: 1fr 400px;
            gap: 3rem;
            margin-top: 2rem;
        }
        
        .form-section {
            background: white;
            padding: 2rem;
            border-radius: var(--border-radius);
            box-shadow: var(--box-shadow);
            margin-bottom: 2rem;
        }
        
        .form-section h2 {
            color: var(--primary-color);
            margin-bottom: 1.5rem;
            display: flex;
            align-items: center;
        }
        
        .form-section h2 i {
            margin-right: 0.5rem;
        }
        
        .payment-options {
            display: flex;
            flex-direction: column;
            gap: 1rem;
            margin-bottom: 2rem;
        }
        
        .payment-option {
            border: 2px solid var(--gray-300);
            border-radius: var(--border-radius);
            padding: 1rem;
            cursor: pointer;
            transition: var(--transition);
        }
        
        .payment-option:hover {
            border-color: var(--secondary-color);
        }
        
        .payment-option input[type="radio"] {
            margin-right: 1rem;
        }
        
        .payment-option input[type="radio"]:checked + label {
            color: var(--secondary-color);
            font-weight: bold;
        }
        
        .payment-option label {
            cursor: pointer;
            display: flex;
            align-items: center;
            margin: 0;
        }
        
        .payment-option label i {
            margin-right: 0.5rem;
            font-size: 1.2rem;
        }
        
        .payment-details {
            display: none;
            margin-top: 1rem;
            padding-top: 1rem;
            border-top: 1px solid var(--gray-200);
        }
        
        .checkbox-group {
            margin-bottom: 1rem;
        }
        
        .form-actions {
            display: flex;
            gap: 1rem;
            margin-top: 2rem;
        }
        
        .form-actions .btn {
            flex: 1;
        }
        
        .order-summary {
            position: sticky;
            top: 120px;
            height: fit-content;
        }
        
        .summary-items {
            margin-bottom: 1rem;
        }
        
        .summary-item {
            display: flex;
            justify-content: space-between;
            align-items: center;
            padding: 1rem 0;
            border-bottom: 1px solid var(--gray-200);
        }
        
        .summary-item:last-child {
            border-bottom: none;
        }
        
        .item-info {
            display: flex;
            flex-direction: column;
        }
        
        .item-title {
            font-weight: 500;
            margin-bottom: 0.25rem;
        }
        
        .item-quantity {
            font-size: 0.9rem;
            color: var(--gray-600);
        }
        
        .item-price {
            font-weight: bold;
            color: var(--accent-color);
        }
        
        .summary-totals {
            margin-top: 1rem;
        }
        
        .summary-line {
            display: flex;
            justify-content: space-between;
            margin-bottom: 0.5rem;
        }
        
        .summary-total {
            display: flex;
            justify-content: space-between;
            font-size: 1.2rem;
            font-weight: bold;
            color: var(--primary-color);
            margin-top: 1rem;
            padding-top: 1rem;
            border-top: 2px solid var(--gray-200);
        }
        
        .coupon-section {
            margin-top: 2rem;
            padding-top: 2rem;
            border-top: 1px solid var(--gray-200);
        }
        
        .coupon-section h4 {
            margin-bottom: 1rem;
            color: var(--primary-color);
        }
        
        .coupon-input {
            display: flex;
            gap: 0.5rem;
        }
        
        .coupon-input input {
            flex: 1;
            padding: 0.5rem;
            border: 1px solid var(--gray-300);
            border-radius: var(--border-radius);
        }
        
        .security-info {
            margin-top: 2rem;
            padding-top: 2rem;
            border-top: 1px solid var(--gray-200);
        }
        
        .security-info h4 {
            margin-bottom: 1rem;
            color: var(--success-color);
        }
        
        .security-info ul {
            list-style: none;
        }
        
        .security-info li {
            padding: 0.5rem 0;
            display: flex;
            align-items: center;
        }
        
        .security-info li i {
            color: var(--success-color);
            margin-right: 0.5rem;
            width: 20px;
        }
        
        .discount {
            color: var(--success-color);
            font-weight: bold;
        }
        
        @media (max-width: 768px) {
            .checkout-container {
                grid-template-columns: 1fr;
                gap: 2rem;
            }
            
            .form-actions {
                flex-direction: column;
            }
            
            .order-summary {
                position: static;
            }
        }
    </style>
</body>
</html>