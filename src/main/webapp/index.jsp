<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
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
    <jsp:include page="includes/header.jsp" />
    
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
    
    <jsp:include page="includes/footer.jsp" />
    
    <script src="js/script.js"></script>
    <script>
        document.addEventListener('DOMContentLoaded', function() {
            loadFeaturedBooks();
        });
        
        function loadFeaturedBooks() {
            fetch('books?action=list')
                .then(response => response.text())
                .then(html => {
                    const parser = new DOMParser();
                    const doc = parser.parseFromString(html, 'text/html');
                    const books = doc.querySelectorAll('.book-card');
                    const featuredContainer = document.getElementById('featured-books');
                    
                    for (let i = 0; i < Math.min(6, books.length); i++) {
                        featuredContainer.appendChild(books[i].cloneNode(true));
                    }
                })
                .catch(error => {
                    console.error('Erro ao carregar livros em destaque:', error);
                });
        }
    </script>
</body>
</html>