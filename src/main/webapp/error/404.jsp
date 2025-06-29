<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="pt-BR">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Página Não Encontrada - Mil Páginas</title>
    <link rel="stylesheet" href="../css/style.css">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
</head>
<body>
    <jsp:include page="../includes/header.jsp" />
    
    <main>
        <div class="container">
            <div class="error-container">
                <div class="error-content">
                    <div class="error-illustration">
                        <i class="fas fa-book-open"></i>
                        <div class="error-code">404</div>
                    </div>
                    
                    <div class="error-message">
                        <h1>Oops! Página não encontrada</h1>
                        <p class="error-subtitle">
                            A página que você está procurando parece ter sido movida, deletada ou não existe.
                        </p>
                        <p class="error-description">
                            Que tal explorar nosso catálogo de livros ou retornar à página inicial?
                        </p>
                    </div>
                    
                    <div class="error-actions">
                        <a href="${pageContext.request.contextPath}/" class="btn btn-primary">
                            <i class="fas fa-home"></i> Página Inicial
                        </a>
                        <a href="${pageContext.request.contextPath}/books" class="btn btn-outline">
                            <i class="fas fa-book"></i> Ver Catálogo
                        </a>
                        <button onclick="goBack()" class="btn btn-outline">
                            <i class="fas fa-arrow-left"></i> Voltar
                        </button>
                    </div>
                    
                    <div class="error-suggestions">
                        <h3>Sugestões:</h3>
                        <ul>
                            <li><i class="fas fa-check"></i> Verifique se o endereço foi digitado corretamente</li>
                            <li><i class="fas fa-check"></i> Use a busca para encontrar o que você procura</li>
                            <li><i class="fas fa-check"></i> Navegue pelo nosso catálogo de livros</li>
                            <li><i class="fas fa-check"></i> Entre em contato conosco se o problema persistir</li>
                        </ul>
                    </div>
                </div>
                
                <!-- Busca rápida -->
                <div class="quick-search">
                    <h3>Busca Rápida</h3>
                    <form action="${pageContext.request.contextPath}/books" method="get" class="search-form">
                        <div class="search-group">
                            <select name="type" class="search-type">
                                <option value="title">Título</option>
                                <option value="author">Autor</option>
                                <option value="isbn">ISBN</option>
                            </select>
                            <input type="text" name="q" class="search-input" 
                                   placeholder="Digite sua busca..." required>
                            <button type="submit" class="search-btn">
                                <i class="fas fa-search"></i> Buscar
                            </button>
                        </div>
                    </form>
                </div>
                
                <!-- Livros populares -->
                <div class="popular-books">
                    <h3>Livros Populares</h3>
                    <div class="books-grid">
                        <div class="book-card">
                            <div class="book-image">
                                <div class="book-placeholder">
                                    <i class="fas fa-book"></i>
                                </div>
                            </div>
                            <div class="book-info">
                                <h4 class="book-title">
                                    <a href="${pageContext.request.contextPath}/books">Dom Casmurro</a>
                                </h4>
                                <p class="book-author">Machado de Assis</p>
                                <div class="book-price">R$ 29,90</div>
                            </div>
                        </div>
                        
                        <div class="book-card">
                            <div class="book-image">
                                <div class="book-placeholder">
                                    <i class="fas fa-book"></i>
                                </div>
                            </div>
                            <div class="book-info">
                                <h4 class="book-title">
                                    <a href="${pageContext.request.contextPath}/books">1984</a>
                                </h4>
                                <p class="book-author">George Orwell</p>
                                <div class="book-price">R$ 34,90</div>
                            </div>
                        </div>
                        
                        <div class="book-card">
                            <div class="book-image">
                                <div class="book-placeholder">
                                    <i class="fas fa-book"></i>
                                </div>
                            </div>
                            <div class="book-info">
                                <h4 class="book-title">
                                    <a href="${pageContext.request.contextPath}/books">O Pequeno Príncipe</a>
                                </h4>
                                <p class="book-author">Antoine de Saint-Exupéry</p>
                                <div class="book-price">R$ 19,90</div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </main>
    
    <jsp:include page="../includes/footer.jsp" />
    
    <script>
        function goBack() {
            if (window.history.length > 1) {
                window.history.back();
            } else {
                window.location.href = '${pageContext.request.contextPath}/';
            }
        }
        
        // Adicionar animação aos elementos
        document.addEventListener('DOMContentLoaded', function() {
            const elements = document.querySelectorAll('.error-content > div');
            elements.forEach((element, index) => {
                element.style.opacity = '0';
                element.style.transform = 'translateY(20px)';
                
                setTimeout(() => {
                    element.style.transition = 'all 0.6s ease';
                    element.style.opacity = '1';
                    element.style.transform = 'translateY(0)';
                }, index * 200);
            });
        });
    </script>
    
    <style>
        .error-container {
            max-width: 800px;
            margin: 2rem auto;
            padding: 2rem;
        }
        
        .error-content {
            text-align: center;
            margin-bottom: 3rem;
        }
        
        .error-illustration {
            position: relative;
            margin-bottom: 2rem;
        }
        
        .error-illustration i {
            font-size: 8rem;
            color: var(--secondary-color);
            opacity: 0.7;
        }
        
        .error-code {
            position: absolute;
            top: 50%;
            left: 50%;
            transform: translate(-50%, -50%);
            font-size: 4rem;
            font-weight: bold;
            color: white;
            text-shadow: 2px 2px 4px rgba(0,0,0,0.3);
        }
        
        .error-message h1 {
            color: var(--primary-color);
            margin-bottom: 1rem;
            font-size: 2.5rem;
        }
        
        .error-subtitle {
            font-size: 1.2rem;
            color: var(--text-color);
            margin-bottom: 1rem;
        }
        
        .error-description {
            color: var(--text-color);
            margin-bottom: 2rem;
        }
        
        .error-actions {
            display: flex;
            justify-content: center;
            gap: 1rem;
            margin-bottom: 3rem;
            flex-wrap: wrap;
        }
        
        .error-suggestions {
            background: var(--light-bg);
            border-radius: 8px;
            padding: 2rem;
            margin-bottom: 3rem;
            text-align: left;
        }
        
        .error-suggestions h3 {
            color: var(--primary-color);
            margin-bottom: 1rem;
            text-align: center;
        }
        
        .error-suggestions ul {
            list-style: none;
            max-width: 400px;
            margin: 0 auto;
        }
        
        .error-suggestions li {
            margin: 0.5rem 0;
            display: flex;
            align-items: center;
            gap: 0.5rem;
        }
        
        .error-suggestions li i {
            color: var(--success-color);
            font-size: 0.875rem;
        }
        
        .quick-search {
            background: white;
            border-radius: 8px;
            padding: 2rem;
            box-shadow: 0 2px 8px rgba(0,0,0,0.1);
            margin-bottom: 3rem;
        }
        
        .quick-search h3 {
            color: var(--primary-color);
            margin-bottom: 1.5rem;
            text-align: center;
        }
        
        .search-group {
            display: flex;
            max-width: 500px;
            margin: 0 auto;
            background: var(--light-bg);
            border-radius: 8px;
            overflow: hidden;
            border: 1px solid var(--border-color);
        }
        
        .search-type {
            border: none;
            background: transparent;
            padding: 12px;
            min-width: 100px;
            font-size: 14px;
            outline: none;
        }
        
        .search-input {
            flex: 1;
            border: none;
            background: transparent;
            padding: 12px;
            outline: none;
            font-size: 14px;
        }
        
        .search-btn {
            background: var(--secondary-color);
            color: white;
            border: none;
            padding: 12px 16px;
            cursor: pointer;
            transition: background-color 0.3s;
        }
        
        .search-btn:hover {
            background: #2980b9;
        }
        
        .popular-books {
            background: white;
            border-radius: 8px;
            padding: 2rem;
            box-shadow: 0 2px 8px rgba(0,0,0,0.1);
        }
        
        .popular-books h3 {
            color: var(--primary-color);
            margin-bottom: 1.5rem;
            text-align: center;
        }
        
        .books-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
            gap: 1.5rem;
        }
        
        .book-card {
            background: var(--light-bg);
            border-radius: 8px;
            overflow: hidden;
            transition: transform 0.3s;
        }
        
        .book-card:hover {
            transform: translateY(-2px);
        }
        
        .book-image {
            height: 150px;
            background: var(--border-color);
            display: flex;
            align-items: center;
            justify-content: center;
        }
        
        .book-placeholder {
            color: white;
            font-size: 2rem;
        }
        
        .book-info {
            padding: 1rem;
            text-align: center;
        }
        
        .book-title {
            margin: 0 0 0.5rem 0;
            font-size: 1rem;
        }
        
        .book-title a {
            text-decoration: none;
            color: var(--primary-color);
        }
        
        .book-title a:hover {
            text-decoration: underline;
        }
        
        .book-author {
            margin: 0 0 0.5rem 0;
            color: var(--text-color);
            font-size: 0.875rem;
        }
        
        .book-price {
            font-weight: bold;
            color: var(--success-color);
        }
        
        @media (max-width: 768px) {
            .error-container {
                padding: 1rem;
            }
            
            .error-illustration i {
                font-size: 6rem;
            }
            
            .error-code {
                font-size: 3rem;
            }
            
            .error-message h1 {
                font-size: 2rem;
            }
            
            .error-actions {
                flex-direction: column;
                align-items: center;
            }
            
            .error-actions .btn {
                width: 200px;
            }
            
            .search-group {
                flex-direction: column;
            }
            
            .books-grid {
                grid-template-columns: 1fr;
            }
        }
    </style>
</body>
</html>