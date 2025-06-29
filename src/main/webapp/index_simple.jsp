<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="pt-BR">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Mil Páginas - Livraria Online</title>
    <link rel="stylesheet" href="css/style.css">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
</head>
<body>
    <%@ include file="includes/header_simple.jsp" %>
    
    <main>
        <!-- Hero Section -->
        <section class="hero">
            <div class="container">
                <div class="hero-content">
                    <h1>Bem-vindo à Mil Páginas</h1>
                    <p class="hero-subtitle">Descubra mundos infinitos através dos livros</p>
                    <a href="books" class="btn btn-primary">Explorar Livros</a>
                </div>
            </div>
        </section>
        
        <!-- Featured Books Section -->
        <section class="featured-books">
            <div class="container">
                <h2 class="section-title">Livros em Destaque</h2>
                <div class="books-grid" id="featured-books">
                    <!-- Livros serão carregados via JavaScript -->
                </div>
                <div class="text-center">
                    <a href="books" class="btn btn-outline">Ver Todos os Livros</a>
                </div>
            </div>
        </section>
        
        <!-- Categories Section -->
        <section class="categories">
            <div class="container">
                <h2 class="section-title">Buscar por Categoria</h2>
                <div class="categories-grid">
                    <div class="category-card">
                        <i class="fas fa-heart"></i>
                        <h3>Romance</h3>
                        <a href="books?type=title&q=amor" class="btn btn-small">Explorar</a>
                    </div>
                    <div class="category-card">
                        <i class="fas fa-magic"></i>
                        <h3>Fantasia</h3>
                        <a href="books?type=title&q=fantasia" class="btn btn-small">Explorar</a>
                    </div>
                    <div class="category-card">
                        <i class="fas fa-graduation-cap"></i>
                        <h3>Educação</h3>
                        <a href="books?type=title&q=educação" class="btn btn-small">Explorar</a>
                    </div>
                    <div class="category-card">
                        <i class="fas fa-history"></i>
                        <h3>História</h3>
                        <a href="books?type=title&q=história" class="btn btn-small">Explorar</a>
                    </div>
                </div>
            </div>
        </section>
        
        <!-- About Section -->
        <section class="about-section">
            <div class="container">
                <div class="about-content">
                    <div class="about-text">
                        <h2>Sobre a Mil Páginas</h2>
                        <p>A Mil Páginas é sua livraria online de confiança, oferecendo uma vasta seleção de livros de todos os gêneros. Nossa missão é conectar leitores apaixonados com as histórias que transformam vidas.</p>
                        <ul>
                            <li><i class="fas fa-check"></i> Mais de 1000 títulos disponíveis</li>
                            <li><i class="fas fa-check"></i> Entrega rápida e segura</li>
                            <li><i class="fas fa-check"></i> Preços competitivos</li>
                            <li><i class="fas fa-check"></i> Atendimento especializado</li>
                        </ul>
                    </div>
                    <div class="about-image">
                        <img src="images/bookstore.jpg" alt="Livraria Mil Páginas" onerror="this.style.display='none'">
                    </div>
                </div>
            </div>
        </section>
    </main>
    
    <%@ include file="includes/footer_simple.jsp" %>
    
    <script src="js/script.js"></script>
    <script>
        document.addEventListener('DOMContentLoaded', function() {
            loadFeaturedBooks();
        });
        
        function loadFeaturedBooks() {
            // Simular carregamento de livros em destaque
            const featuredContainer = document.getElementById('featured-books');
            featuredContainer.innerHTML = `
                <div class="book-card">
                    <div class="book-image">
                        <div class="book-placeholder">
                            <i class="fas fa-book"></i>
                        </div>
                    </div>
                    <div class="book-info">
                        <h3 class="book-title"><a href="books">Dom Casmurro</a></h3>
                        <p class="book-author">por Machado de Assis</p>
                        <div class="book-price">R$ 29,90</div>
                        <div class="book-actions">
                            <a href="books" class="btn btn-outline btn-small">Ver Detalhes</a>
                        </div>
                    </div>
                </div>
                <div class="book-card">
                    <div class="book-image">
                        <div class="book-placeholder">
                            <i class="fas fa-book"></i>
                        </div>
                    </div>
                    <div class="book-info">
                        <h3 class="book-title"><a href="books">1984</a></h3>
                        <p class="book-author">por George Orwell</p>
                        <div class="book-price">R$ 34,90</div>
                        <div class="book-actions">
                            <a href="books" class="btn btn-outline btn-small">Ver Detalhes</a>
                        </div>
                    </div>
                </div>
                <div class="book-card">
                    <div class="book-image">
                        <div class="book-placeholder">
                            <i class="fas fa-book"></i>
                        </div>
                    </div>
                    <div class="book-info">
                        <h3 class="book-title"><a href="books">O Pequeno Príncipe</a></h3>
                        <p class="book-author">por Antoine de Saint-Exupéry</p>
                        <div class="book-price">R$ 19,90</div>
                        <div class="book-actions">
                            <a href="books" class="btn btn-outline btn-small">Ver Detalhes</a>
                        </div>
                    </div>
                </div>
            `;
        }
    </script>
</body>
</html>