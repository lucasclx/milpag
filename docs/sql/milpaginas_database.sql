-- Script SQL para criação do banco de dados Mil Páginas
-- Desenvolvido para MySQL

-- Criar o banco de dados
CREATE DATABASE IF NOT EXISTS milpaginas;
USE milpaginas;

-- Tabela de usuários
CREATE TABLE usuarios (
    id INT AUTO_INCREMENT PRIMARY KEY,
    nome VARCHAR(100) NOT NULL,
    email VARCHAR(150) UNIQUE NOT NULL,
    senha VARCHAR(255) NOT NULL,
    endereco TEXT,
    telefone VARCHAR(20),
    tipo_usuario ENUM('CLIENTE', 'ADMINISTRADOR') DEFAULT 'CLIENTE',
    data_cadastro TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    ativo BOOLEAN DEFAULT TRUE,
    INDEX idx_email (email),
    INDEX idx_tipo_usuario (tipo_usuario)
);

-- Tabela de livros
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
    ativo BOOLEAN DEFAULT TRUE,
    INDEX idx_titulo (titulo),
    INDEX idx_autor (autor),
    INDEX idx_editora (editora),
    INDEX idx_isbn (isbn),
    INDEX idx_preco (preco)
);

-- Tabela de carrinho (persistência)
CREATE TABLE carrinho (
    id INT AUTO_INCREMENT PRIMARY KEY,
    usuario_id INT NOT NULL,
    livro_id INT NOT NULL,
    quantidade INT DEFAULT 1,
    data_adicao TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (usuario_id) REFERENCES usuarios(id) ON DELETE CASCADE,
    FOREIGN KEY (livro_id) REFERENCES livros(id) ON DELETE CASCADE,
    UNIQUE KEY unique_usuario_livro (usuario_id, livro_id),
    INDEX idx_usuario_id (usuario_id)
);

-- Tabela de pedidos
CREATE TABLE pedidos (
    id INT AUTO_INCREMENT PRIMARY KEY,
    usuario_id INT NOT NULL,
    data_pedido TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    status_pedido ENUM('PENDENTE', 'PROCESSANDO', 'ENVIADO', 'ENTREGUE', 'CANCELADO') DEFAULT 'PENDENTE',
    endereco_entrega TEXT NOT NULL,
    valor_total DECIMAL(10,2) NOT NULL,
    observacoes TEXT,
    FOREIGN KEY (usuario_id) REFERENCES usuarios(id),
    INDEX idx_usuario_id (usuario_id),
    INDEX idx_status (status_pedido),
    INDEX idx_data_pedido (data_pedido)
);

-- Tabela de itens do pedido
CREATE TABLE itens_pedido (
    id INT AUTO_INCREMENT PRIMARY KEY,
    pedido_id INT NOT NULL,
    livro_id INT NOT NULL,
    quantidade INT NOT NULL,
    preco_unitario DECIMAL(10,2) NOT NULL,
    subtotal DECIMAL(10,2) NOT NULL,
    FOREIGN KEY (pedido_id) REFERENCES pedidos(id) ON DELETE CASCADE,
    FOREIGN KEY (livro_id) REFERENCES livros(id),
    INDEX idx_pedido_id (pedido_id),
    INDEX idx_livro_id (livro_id)
);

-- Inserir usuário administrador padrão
INSERT INTO usuarios (nome, email, senha, tipo_usuario) VALUES 
('Administrador', 'admin@milpaginas.com', '$2a$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', 'ADMINISTRADOR');

-- Inserir alguns livros de exemplo
INSERT INTO livros (titulo, autor, isbn, editora, ano_publicacao, preco, quantidade_estoque, descricao) VALUES
('Dom Casmurro', 'Machado de Assis', '9788525061096', 'Globo Livros', 2008, 29.90, 50, 'Clássico da literatura brasileira'),
('O Cortiço', 'Aluísio Azevedo', '9788508131940', 'Ática', 2013, 24.90, 30, 'Romance naturalista brasileiro'),
('O Pequeno Príncipe', 'Antoine de Saint-Exupéry', '9788595081376', 'HarperCollins', 2015, 19.90, 100, 'Fábula poética sobre a amizade e o amor'),
('1984', 'George Orwell', '9788535914849', 'Companhia das Letras', 2009, 34.90, 25, 'Distopia sobre totalitarismo'),
('Pride and Prejudice', 'Jane Austen', '9780141439518', 'Penguin Classics', 2003, 39.90, 15, 'Romance clássico inglês'),
('Cem Anos de Solidão', 'Gabriel García Márquez', '9788501012340', 'Record', 2017, 44.90, 20, 'Obra-prima do realismo mágico'),
('O Alquimista', 'Paulo Coelho', '9788576653264', 'Planeta', 2014, 27.90, 80, 'Fábula sobre seguir seus sonhos'),
('Harry Potter e a Pedra Filosofal', 'J.K. Rowling', '9788532511010', 'Rocco', 2000, 32.90, 60, 'Primeiro livro da série Harry Potter');

-- Criar índices adicionais para performance
CREATE INDEX idx_livros_ativo ON livros(ativo);
CREATE INDEX idx_usuarios_ativo ON usuarios(ativo);
CREATE INDEX idx_pedidos_data_status ON pedidos(data_pedido, status_pedido);

-- View para relatórios de vendas
CREATE VIEW vendas_por_livro AS
SELECT 
    l.id,
    l.titulo,
    l.autor,
    l.preco,
    COALESCE(SUM(ip.quantidade), 0) as total_vendido,
    COALESCE(SUM(ip.subtotal), 0) as receita_total
FROM livros l
LEFT JOIN itens_pedido ip ON l.id = ip.livro_id
LEFT JOIN pedidos p ON ip.pedido_id = p.id
WHERE p.status_pedido IN ('ENTREGUE', 'ENVIADO', 'PROCESSANDO')
   OR p.status_pedido IS NULL
GROUP BY l.id, l.titulo, l.autor, l.preco;

-- View para relatórios de usuários
CREATE VIEW resumo_usuarios AS
SELECT 
    u.id,
    u.nome,
    u.email,
    u.tipo_usuario,
    u.data_cadastro,
    COUNT(p.id) as total_pedidos,
    COALESCE(SUM(p.valor_total), 0) as valor_total_compras
FROM usuarios u
LEFT JOIN pedidos p ON u.id = p.usuario_id
WHERE u.ativo = TRUE
GROUP BY u.id, u.nome, u.email, u.tipo_usuario, u.data_cadastro;