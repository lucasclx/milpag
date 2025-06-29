<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="pt-BR">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Livros DEBUG - Mil Páginas</title>
    <style>
        * { margin: 0; padding: 0; box-sizing: border-box; }
        body { font-family: Arial, sans-serif; background: #f8f9fa; }
        .container { max-width: 1200px; margin: 0 auto; padding: 20px; }
        .debug-panel { background: #fff3cd; padding: 20px; margin: 20px 0; border-radius: 8px; border: 1px solid #ffeaa7; }
        .debug-panel h3 { color: #856404; margin-bottom: 15px; }
        .debug-info { background: #000; color: #0f0; padding: 15px; border-radius: 5px; font-family: monospace; font-size: 12px; margin: 10px 0; }
        .book-card { background: white; border-radius: 8px; padding: 20px; margin: 15px 0; box-shadow: 0 2px 10px rgba(0,0,0,0.1); }
        .book-title { color: #2c3e50; font-size: 1.2rem; margin-bottom: 10px; }
        .book-author { color: #666; margin-bottom: 5px; }
        .book-price { color: #27ae60; font-weight: bold; font-size: 1.1rem; }
        .btn { padding: 10px 15px; margin: 5px; border: none; border-radius: 5px; cursor: pointer; text-decoration: none; display: inline-block; }
        .btn-primary { background: #3498db; color: white; }
        .btn-success { background: #27ae60; color: white; }
        .btn-warning { background: #f39c12; color: white; }
        .btn-danger { background: #e74c3c; color: white; }
        .no-books { text-align: center; padding: 40px; background: white; border-radius: 8px; }
        .test-controls { background: white; padding: 20px; border-radius: 8px; margin: 20px 0; }
    </style>
</head>
<body>
    <jsp:include page="includes/header.jsp" />
    
    <main>
        <div class="container">
            <div class="debug-panel">
                <h3>🐛 DEBUG DA PÁGINA DE LIVROS</h3>
                <div class="debug-info" id="debug-info">
                    Context Path: <%= request.getContextPath() %><br>
                    Request URI: <%= request.getRequestURI() %><br>
                    Query String: <%= request.getQueryString() %><br>
                    Método: <%= request.getMethod() %><br>
                    Total de livros na lista: ${books != null ? books.size() : 'NULL'}<br>
                    Total Books (atributo): ${totalBooks}<br>
                    Current Page: ${currentPage}<br>
                    Total Pages: ${totalPages}<br>
                </div>
            </div>
            
            <div class="test-controls">
                <h3>🧪 Controles de Teste</h3>
                <button class="btn btn-warning" onclick="testConnectivity()">🔗 Testar Conectividade</button>
                <button class="btn btn-primary" onclick="reloadPage()">🔄 Recarregar Dados</button>
                <button class="btn btn-success" onclick="testAddBook()">➕ Testar Adicionar</button>
                <a href="<%= request.getContextPath() %>/books?action=add" class="btn btn-success">📝 Novo Livro</a>
            </div>
            
            <h1>📚 Catálogo de Livros (DEBUG)</h1>
            
            <!-- Debug: Mostrar informações dos livros -->
            <c:choose>
                <c:when test="${empty books}">
                    <div class="no-books">
                        <h2>❌ NENHUM LIVRO ENCONTRADO</h2>
                        <div class="debug-info">
                            DEBUG: A variável 'books' está vazia ou nula.<br>
                            Possíveis causas:<br>
                            1. Problema na consulta SQL<br>
                            2. Erro no BookDAO<br>
                            3. Livros marcados como inativos<br>
                            4. Problema na conexão com banco<br>
                        </div>
                        <button class="btn btn-warning" onclick="debugEmptyBooks()">🔍 Debug Lista Vazia</button>
                    </div>
                </c:when>
                <c:otherwise>
                    <div class="debug-info">
                        ✅ ENCONTRADOS ${books.size()} LIVROS:
                    </div>
                    
                    <div class="books-container">
                        <c:forEach var="book" items="${books}" varStatus="status">
                            <div class="book-card">
                                <div class="debug-info" style="margin-bottom: 10px;">
                                    LIVRO ${status.index + 1}: ID=${book.id}, Ativo=${book.ativo}, Estoque=${book.quantidadeEstoque}
                                </div>
                                
                                <div class="book-title">${book.titulo}</div>
                                <div class="book-author">por ${book.autor}</div>
                                <div class="book-price">
                                    <fmt:formatNumber value="${book.preco}" type="currency" currencySymbol="R$" />
                                </div>
                                <div>Estoque: ${book.quantidadeEstoque}</div>
                                <div>Ativo: ${book.ativo ? 'SIM' : 'NÃO'}</div>
                                
                                <div style="margin-top: 10px;">
                                    <button class="btn btn-primary" onclick="addToCart(${book.id}, 1)">
                                        🛒 Adicionar ao Carrinho
                                    </button>
                                    <c:if test="${sessionScope.isAdmin}">
                                        <a href="<%= request.getContextPath() %>/books?action=edit&id=${book.id}" class="btn btn-warning">
                                            ✏️ Editar
                                        </a>
                                        <button class="btn btn-danger" onclick="deleteBook(${book.id})">
                                            🗑️ Excluir
                                        </button>
                                    </c:if>
                                </div>
                            </div>
                        </c:forEach>
                    </div>
                </c:otherwise>
            </c:choose>
            
            <!-- Debug Log -->
            <div class="debug-panel">
                <h3>📋 Log de Debug</h3>
                <div class="debug-info" id="debug-log">
                    Página carregada...<br>
                </div>
            </div>
        </div>
    </main>
    
    <script>
        const debugLog = document.getElementById('debug-log');
        
        function log(message) {
            const timestamp = new Date().toLocaleTimeString();
            debugLog.innerHTML += timestamp + ' - ' + message + '<br>';
            console.log('DEBUG:', message);
        }
        
        function testConnectivity() {
            log('🔗 Testando conectividade com servidor...');
            
            fetch('<%= request.getContextPath() %>/books?action=list')
                .then(response => {
                    log('✅ Resposta: ' + response.status + ' ' + response.statusText);
                    return response.text();
                })
                .then(html => {
                    log('📄 HTML recebido: ' + html.length + ' caracteres');
                    if (html.includes('book-card')) {
                        log('✅ HTML contém cards de livros');
                    } else {
                        log('❌ HTML NÃO contém cards de livros');
                    }
                })
                .catch(error => {
                    log('❌ ERRO: ' + error.message);
                });
        }
        
        function reloadPage() {
            log('🔄 Recarregando página...');
            window.location.reload();
        }
        
        function testAddBook() {
            log('➕ Redirecionando para adicionar livro...');
            window.location.href = '<%= request.getContextPath() %>/books?action=add';
        }
        
        function debugEmptyBooks() {
            log('🔍 Fazendo debug de lista vazia...');
            
            // Testar endpoint direto
            fetch('<%= request.getContextPath() %>/books')
                .then(response => response.text())
                .then(html => {
                    if (html.includes('no-books') || html.includes('Nenhum livro')) {
                        log('❌ Servidor retorna lista vazia');
                    } else if (html.includes('book-card')) {
                        log('⚠️ Servidor tem livros, mas não estão chegando na página');
                    } else {
                        log('❓ Resposta inesperada do servidor');
                    }
                })
                .catch(error => {
                    log('❌ Erro ao testar endpoint: ' + error.message);
                });
        }
        
        function deleteBook(bookId) {
            if (confirm('Tem certeza que deseja excluir este livro?')) {
                log('🗑️ Excluindo livro ID: ' + bookId);
                
                const formData = new FormData();
                formData.append('action', 'delete');
                formData.append('id', bookId);
                
                fetch('<%= request.getContextPath() %>/books', {
                    method: 'POST',
                    body: formData
                })
                .then(response => {
                    if (response.ok) {
                        log('✅ Livro excluído com sucesso');
                        reloadPage();
                    } else {
                        log('❌ Erro ao excluir: ' + response.status);
                    }
                })
                .catch(error => {
                    log('❌ Erro de rede: ' + error.message);
                });
            }
        }
        
        // Log inicial
        document.addEventListener('DOMContentLoaded', function() {
            log('📚 Página de livros carregada');
            log('Livros encontrados: ${books != null ? books.size() : 0}');
            
            <c:if test="${empty books}">
                log('⚠️ ATENÇÃO: Lista de livros está vazia!');
            </c:if>
        });
    </script>
</body>
</html>