<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="pt-BR">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>
        <c:choose>
            <c:when test="${not empty book}">Editar Livro</c:when>
            <c:otherwise>Adicionar Livro</c:otherwise>
        </c:choose>
        - Administração Mil Páginas
    </title>
    <link rel="stylesheet" href="../css/style.css">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
</head>
<body>
    <jsp:include page="../includes/header.jsp" />
    
    <main>
        <div class="container">
            <div class="form-header">
                <h1>
                    <i class="fas fa-book"></i>
                    <c:choose>
                        <c:when test="${not empty book}">Editar Livro</c:when>
                        <c:otherwise>Adicionar Novo Livro</c:otherwise>
                    </c:choose>
                </h1>
                <a href="../books?action=admin" class="btn btn-outline">
                    <i class="fas fa-arrow-left"></i> Voltar ao Catálogo
                </a>
            </div>
            
            <!-- Mensagens -->
            <c:if test="${not empty success}">
                <div class="alert alert-success">
                    <i class="fas fa-check-circle"></i> ${success}
                </div>
            </c:if>
            
            <c:if test="${not empty error}">
                <div class="alert alert-danger">
                    <i class="fas fa-exclamation-circle"></i> ${error}
                </div>
            </c:if>
            
            <div class="book-form-container">
                <form action="../books" method="post" class="book-form" enctype="multipart/form-data">
                    <c:choose>
                        <c:when test="${not empty book}">
                            <input type="hidden" name="action" value="update">
                            <input type="hidden" name="id" value="${book.id}">
                        </c:when>
                        <c:otherwise>
                            <input type="hidden" name="action" value="create">
                        </c:otherwise>
                    </c:choose>
                    
                    <div class="form-grid">
                        <!-- Coluna Esquerda -->
                        <div class="form-column">
                            <div class="form-section">
                                <h3><i class="fas fa-info-circle"></i> Informações Básicas</h3>
                                
                                <div class="form-group">
                                    <label for="titulo" class="form-label">Título *</label>
                                    <input type="text" id="titulo" name="titulo" class="form-control" 
                                           value="${book.titulo}" required maxlength="200"
                                           placeholder="Digite o título do livro">
                                </div>
                                
                                <div class="form-group">
                                    <label for="autor" class="form-label">Autor *</label>
                                    <input type="text" id="autor" name="autor" class="form-control" 
                                           value="${book.autor}" required maxlength="150"
                                           placeholder="Digite o nome do autor">
                                </div>
                                
                                <div class="form-row">
                                    <div class="form-group">
                                        <label for="editora" class="form-label">Editora</label>
                                        <input type="text" id="editora" name="editora" class="form-control" 
                                               value="${book.editora}" maxlength="100"
                                               placeholder="Digite o nome da editora">
                                    </div>
                                    
                                    <div class="form-group">
                                        <label for="anoPublicacao" class="form-label">Ano de Publicação</label>
                                        <input type="number" id="anoPublicacao" name="anoPublicacao" class="form-control" 
                                               value="${book.anoPublicacao}" min="1000" max="2030"
                                               placeholder="Ex: 2023">
                                    </div>
                                </div>
                                
                                <div class="form-group">
                                    <label for="isbn" class="form-label">ISBN</label>
                                    <input type="text" id="isbn" name="isbn" class="form-control" 
                                           value="${book.isbn}" maxlength="20"
                                           placeholder="Ex: 978-85-250-6109-6">
                                    <small class="form-text">Formato: XXX-XX-XXXXX-X-X (opcional)</small>
                                </div>
                                
                                <div class="form-group">
                                    <label for="descricao" class="form-label">Descrição</label>
                                    <textarea id="descricao" name="descricao" class="form-control" 
                                              rows="4" maxlength="1000"
                                              placeholder="Digite uma breve descrição do livro">${book.descricao}</textarea>
                                    <small class="form-text">Máximo 1000 caracteres</small>
                                </div>
                            </div>
                        </div>
                        
                        <!-- Coluna Direita -->
                        <div class="form-column">
                            <div class="form-section">
                                <h3><i class="fas fa-dollar-sign"></i> Preço e Estoque</h3>
                                
                                <div class="form-row">
                                    <div class="form-group">
                                        <label for="preco" class="form-label">Preço *</label>
                                        <div class="input-group">
                                            <span class="input-group-text">R$</span>
                                            <input type="number" id="preco" name="preco" class="form-control" 
                                                   value="${book.preco}" step="0.01" min="0" required
                                                   placeholder="0,00">
                                        </div>
                                    </div>
                                    
                                    <div class="form-group">
                                        <label for="quantidadeEstoque" class="form-label">Quantidade em Estoque *</label>
                                        <input type="number" id="quantidadeEstoque" name="quantidadeEstoque" 
                                               class="form-control" value="${book.quantidadeEstoque}" 
                                               min="0" required placeholder="0">
                                    </div>
                                </div>
                                
                                <div class="form-group">
                                    <label for="ativo" class="form-label">Status</label>
                                    <select id="ativo" name="ativo" class="form-control">
                                        <option value="true" ${book.ativo == true ? 'selected' : ''}>Ativo</option>
                                        <option value="false" ${book.ativo == false ? 'selected' : ''}>Inativo</option>
                                    </select>
                                </div>
                            </div>
                            
                            <div class="form-section">
                                <h3><i class="fas fa-image"></i> Imagem da Capa</h3>
                                
                                <div class="form-group">
                                    <label for="urlCapa" class="form-label">URL da Capa</label>
                                    <input type="url" id="urlCapa" name="urlCapa" class="form-control" 
                                           value="${book.urlCapa}" maxlength="500"
                                           placeholder="https://exemplo.com/capa.jpg">
                                    <small class="form-text">Insira a URL de uma imagem online</small>
                                </div>
                                
                                <!-- Preview da imagem -->
                                <div class="image-preview">
                                    <div id="imagePreview" class="preview-container">
                                        <c:choose>
                                            <c:when test="${not empty book.urlCapa}">
                                                <img src="${book.urlCapa}" alt="Preview" id="previewImg" 
                                                     onerror="this.style.display='none'; document.getElementById('previewPlaceholder').style.display='flex';">
                                                <div id="previewPlaceholder" class="preview-placeholder" style="display: none;">
                                                    <i class="fas fa-image"></i>
                                                    <p>Preview da Capa</p>
                                                </div>
                                            </c:when>
                                            <c:otherwise>
                                                <img src="" alt="Preview" id="previewImg" style="display: none;">
                                                <div id="previewPlaceholder" class="preview-placeholder">
                                                    <i class="fas fa-image"></i>
                                                    <p>Preview da Capa</p>
                                                </div>
                                            </c:otherwise>
                                        </c:choose>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                    
                    <!-- Botões de Ação -->
                    <div class="form-actions">
                        <button type="submit" class="btn btn-primary">
                            <i class="fas fa-save"></i>
                            <c:choose>
                                <c:when test="${not empty book}">Atualizar Livro</c:when>
                                <c:otherwise>Cadastrar Livro</c:otherwise>
                            </c:choose>
                        </button>
                        
                        <a href="../books?action=admin" class="btn btn-outline">
                            <i class="fas fa-times"></i> Cancelar
                        </a>
                        
                        <c:if test="${not empty book}">
                            <button type="button" class="btn btn-danger" onclick="confirmDelete(${book.id})">
                                <i class="fas fa-trash"></i> Excluir Livro
                            </button>
                        </c:if>
                    </div>
                </form>
            </div>
        </div>
    </main>
    
    <jsp:include page="../includes/footer.jsp" />
    
    <script>
        // Preview da imagem
        document.getElementById('urlCapa').addEventListener('input', function() {
            const url = this.value;
            const previewImg = document.getElementById('previewImg');
            const placeholder = document.getElementById('previewPlaceholder');
            
            if (url) {
                previewImg.src = url;
                previewImg.style.display = 'block';
                placeholder.style.display = 'none';
                
                previewImg.onerror = function() {
                    this.style.display = 'none';
                    placeholder.style.display = 'flex';
                };
            } else {
                previewImg.style.display = 'none';
                placeholder.style.display = 'flex';
            }
        });
        
        // Confirmação de exclusão
        function confirmDelete(bookId) {
            if (confirm('Tem certeza que deseja excluir este livro? Esta ação não pode ser desfeita.')) {
                const form = document.createElement('form');
                form.method = 'POST';
                form.action = '../books';
                
                const actionInput = document.createElement('input');
                actionInput.type = 'hidden';
                actionInput.name = 'action';
                actionInput.value = 'delete';
                
                const idInput = document.createElement('input');
                idInput.type = 'hidden';
                idInput.name = 'id';
                idInput.value = bookId;
                
                form.appendChild(actionInput);
                form.appendChild(idInput);
                document.body.appendChild(form);
                form.submit();
            }
        }
        
        // Validação do formulário
        document.querySelector('.book-form').addEventListener('submit', function(e) {
            const titulo = document.getElementById('titulo').value.trim();
            const autor = document.getElementById('autor').value.trim();
            const preco = document.getElementById('preco').value;
            const estoque = document.getElementById('quantidadeEstoque').value;
            
            if (!titulo || !autor || !preco || !estoque) {
                e.preventDefault();
                alert('Por favor, preencha todos os campos obrigatórios.');
                return false;
            }
            
            if (parseFloat(preco) <= 0) {
                e.preventDefault();
                alert('O preço deve ser maior que zero.');
                return false;
            }
            
            if (parseInt(estoque) < 0) {
                e.preventDefault();
                alert('A quantidade em estoque não pode ser negativa.');
                return false;
            }
        });
    </script>
    
    <style>
        .form-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin: 2rem 0;
            flex-wrap: wrap;
            gap: 1rem;
        }
        
        .form-header h1 {
            color: var(--primary-color);
            margin: 0;
        }
        
        .book-form-container {
            background: white;
            border-radius: 8px;
            box-shadow: 0 2px 8px rgba(0,0,0,0.1);
            padding: 2rem;
            margin: 2rem 0;
        }
        
        .form-grid {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 3rem;
        }
        
        .form-section {
            margin-bottom: 2rem;
        }
        
        .form-section h3 {
            color: var(--primary-color);
            margin-bottom: 1.5rem;
            padding-bottom: 0.5rem;
            border-bottom: 2px solid var(--light-bg);
        }
        
        .form-section h3 i {
            margin-right: 0.5rem;
        }
        
        .form-row {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 1rem;
        }
        
        .form-group {
            margin-bottom: 1.5rem;
        }
        
        .input-group {
            display: flex;
        }
        
        .input-group-text {
            background: var(--light-bg);
            border: 1px solid var(--border-color);
            border-right: none;
            padding: 10px 12px;
            border-radius: 4px 0 0 4px;
            color: var(--text-color);
            font-weight: 500;
        }
        
        .input-group .form-control {
            border-radius: 0 4px 4px 0;
        }
        
        .image-preview {
            margin-top: 1rem;
        }
        
        .preview-container {
            width: 200px;
            height: 250px;
            border: 2px dashed var(--border-color);
            border-radius: 8px;
            overflow: hidden;
            position: relative;
        }
        
        .preview-container img {
            width: 100%;
            height: 100%;
            object-fit: cover;
        }
        
        .preview-placeholder {
            width: 100%;
            height: 100%;
            display: flex;
            flex-direction: column;
            align-items: center;
            justify-content: center;
            color: var(--border-color);
            background: var(--light-bg);
        }
        
        .preview-placeholder i {
            font-size: 3rem;
            margin-bottom: 0.5rem;
        }
        
        .preview-placeholder p {
            margin: 0;
            font-size: 0.875rem;
        }
        
        .form-actions {
            display: flex;
            gap: 1rem;
            margin-top: 2rem;
            padding-top: 2rem;
            border-top: 2px solid var(--light-bg);
            flex-wrap: wrap;
        }
        
        .form-text {
            color: var(--text-color);
            font-size: 0.875rem;
            margin-top: 0.25rem;
        }
        
        @media (max-width: 768px) {
            .form-header {
                flex-direction: column;
                align-items: flex-start;
            }
            
            .form-grid {
                grid-template-columns: 1fr;
                gap: 2rem;
            }
            
            .form-row {
                grid-template-columns: 1fr;
            }
            
            .form-actions {
                flex-direction: column;
            }
            
            .form-actions .btn {
                width: 100%;
                justify-content: center;
            }
        }
    </style>
</body>
</html>