-- Script SQL simplificado para criar banco Mil Páginas
-- Execute este script no MySQL Workbench ou linha de comando

-- 1. Criar o banco de dados
CREATE DATABASE IF NOT EXISTS milpaginas;
USE milpaginas;

-- 2. Criar tabela de usuários
CREATE TABLE usuarios (
    id INT AUTO_INCREMENT PRIMARY KEY,
    nome VARCHAR(100) NOT NULL,
    email VARCHAR(150) UNIQUE NOT NULL,
    senha VARCHAR(255) NOT NULL,
    endereco TEXT,
    telefone VARCHAR(20),
    tipo_usuario ENUM('CLIENTE', 'ADMINISTRADOR') DEFAULT 'CLIENTE',
    data_cadastro TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    ativo BOOLEAN DEFAULT TRUE
);

-- 3. Criar tabela de livros
CREATE TABLE livros (
    id INT AUTO_INCREMENT PRIMARY KEY,
    titulo VARCHAR(200) NOT NULL,
    autor VARCHAR(150) NOT NULL,
    isbn VARCHAR(20) UNIQUE,
    editora VARCHAR(100),
    ano_publicacao YEAR,
    preco DECIMAL(10,2) NOT NULL,
    quantidade_estoque INT DEFAULT 0,
    url_capa VARCHAR(500),
    descricao TEXT,
    data_cadastro TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    ativo BOOLEAN DEFAULT TRUE
);

-- 4. Criar tabela de carrinho
CREATE TABLE carrinho (
    id INT AUTO_INCREMENT PRIMARY KEY,
    usuario_id INT NOT NULL,
    livro_id INT NOT NULL,
    quantidade INT DEFAULT 1,
    data_adicao TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (usuario_id) REFERENCES usuarios(id) ON DELETE CASCADE,
    FOREIGN KEY (livro_id) REFERENCES livros(id) ON DELETE CASCADE,
    UNIQUE KEY unique_usuario_livro (usuario_id, livro_id)
);

-- 5. Criar tabela de pedidos
CREATE TABLE pedidos (
    id INT AUTO_INCREMENT PRIMARY KEY,
    usuario_id INT NOT NULL,
    data_pedido TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    status_pedido ENUM('PENDENTE', 'PROCESSANDO', 'ENVIADO', 'ENTREGUE', 'CANCELADO') DEFAULT 'PENDENTE',
    endereco_entrega TEXT NOT NULL,
    valor_total DECIMAL(10,2) NOT NULL,
    observacoes TEXT,
    FOREIGN KEY (usuario_id) REFERENCES usuarios(id)
);

-- 6. Criar tabela de itens do pedido
CREATE TABLE itens_pedido (
    id INT AUTO_INCREMENT PRIMARY KEY,
    pedido_id INT NOT NULL,
    livro_id INT NOT NULL,
    quantidade INT NOT NULL,
    preco_unitario DECIMAL(10,2) NOT NULL,
    subtotal DECIMAL(10,2) NOT NULL,
    FOREIGN KEY (pedido_id) REFERENCES pedidos(id) ON DELETE CASCADE,
    FOREIGN KEY (livro_id) REFERENCES livros(id)
);

-- 7. Inserir usuário administrador (senha: password)
INSERT INTO usuarios (nome, email, senha, tipo_usuario) VALUES 
('Administrador', 'admin@milpaginas.com', '$2a$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', 'ADMINISTRADOR');

-- 8. Inserir livros de exemplo
INSERT INTO livros (titulo, autor, isbn, editora, ano_publicacao, preco, quantidade_estoque, descricao) VALUES
('Dom Casmurro', 'Machado de Assis', '9788525061096', 'Globo Livros', 2008, 29.90, 50, 'Clássico da literatura brasileira'),
('1984', 'George Orwell', '9788535914849', 'Companhia das Letras', 2009, 34.90, 25, 'Distopia sobre totalitarismo'),
('O Pequeno Príncipe', 'Antoine de Saint-Exupéry', '9788595081376', 'HarperCollins', 2015, 19.90, 100, 'Fábula poética sobre a amizade'),
('O Alquimista', 'Paulo Coelho', '9788576653264', 'Planeta', 2014, 27.90, 80, 'Fábula sobre seguir seus sonhos'),
('Harry Potter e a Pedra Filosofal', 'J.K. Rowling', '9788532511010', 'Rocco', 2000, 32.90, 60, 'Primeiro livro da série Harry Potter');

-- Pronto! Seu banco de dados está criado.