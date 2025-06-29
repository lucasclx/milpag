package com.milpaginas.dao;

import com.milpaginas.model.Book;
import com.milpaginas.util.DatabaseConnection;
import com.milpaginas.util.ValidationUtil;

import java.math.BigDecimal;
import java.sql.*;
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;

public class BookDAO {
    
    public Book save(Book book) throws SQLException {
        String sql = "INSERT INTO livros (titulo, autor, isbn, editora, ano_publicacao, preco, quantidade_estoque, url_capa, descricao) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?)";
        
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            
            stmt.setString(1, ValidationUtil.sanitizeString(book.getTitulo()));
            stmt.setString(2, ValidationUtil.sanitizeString(book.getAutor()));
            stmt.setString(3, ValidationUtil.sanitizeString(book.getIsbn()));
            stmt.setString(4, ValidationUtil.sanitizeString(book.getEditora()));
            
            if (book.getAnoPublicacao() != null) {
                stmt.setInt(5, book.getAnoPublicacao());
            } else {
                stmt.setNull(5, Types.INTEGER);
            }
            
            stmt.setBigDecimal(6, book.getPreco());
            stmt.setInt(7, book.getQuantidadeEstoque());
            stmt.setString(8, ValidationUtil.sanitizeString(book.getUrlCapa()));
            stmt.setString(9, ValidationUtil.sanitizeString(book.getDescricao()));
            
            int affectedRows = stmt.executeUpdate();
            
            if (affectedRows == 0) {
                throw new SQLException("Falha ao criar livro, nenhuma linha afetada.");
            }
            
            try (ResultSet generatedKeys = stmt.getGeneratedKeys()) {
                if (generatedKeys.next()) {
                    book.setId(generatedKeys.getInt(1));
                } else {
                    throw new SQLException("Falha ao criar livro, ID não foi gerado.");
                }
            }
            
            return book;
        }
    }
    
    public Book findById(int id) throws SQLException {
        String sql = "SELECT * FROM livros WHERE id = ? AND ativo = TRUE";
        
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setInt(1, id);
            
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    return mapResultSetToBook(rs);
                }
            }
        }
        
        return null;
    }
    
    public List<Book> findAll() throws SQLException {
        String sql = "SELECT * FROM livros WHERE ativo = TRUE ORDER BY titulo";
        List<Book> books = new ArrayList<>();
        
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql);
             ResultSet rs = stmt.executeQuery()) {
            
            while (rs.next()) {
                books.add(mapResultSetToBook(rs));
            }
        }
        
        return books;
    }
    
    public List<Book> findAvailable() throws SQLException {
        String sql = "SELECT * FROM livros WHERE ativo = TRUE AND quantidade_estoque > 0 ORDER BY titulo";
        List<Book> books = new ArrayList<>();
        
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql);
             ResultSet rs = stmt.executeQuery()) {
            
            while (rs.next()) {
                books.add(mapResultSetToBook(rs));
            }
        }
        
        return books;
    }
    
    public List<Book> findByTitle(String title) throws SQLException {
        String sql = "SELECT * FROM livros WHERE ativo = TRUE AND titulo LIKE ? ORDER BY titulo";
        List<Book> books = new ArrayList<>();
        
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setString(1, "%" + ValidationUtil.sanitizeString(title) + "%");
            
            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    books.add(mapResultSetToBook(rs));
                }
            }
        }
        
        return books;
    }
    
    public List<Book> findByAuthor(String author) throws SQLException {
        String sql = "SELECT * FROM livros WHERE ativo = TRUE AND autor LIKE ? ORDER BY titulo";
        List<Book> books = new ArrayList<>();
        
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setString(1, "%" + ValidationUtil.sanitizeString(author) + "%");
            
            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    books.add(mapResultSetToBook(rs));
                }
            }
        }
        
        return books;
    }
    
    public List<Book> findByPublisher(String publisher) throws SQLException {
        String sql = "SELECT * FROM livros WHERE ativo = TRUE AND editora LIKE ? ORDER BY titulo";
        List<Book> books = new ArrayList<>();
        
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setString(1, "%" + ValidationUtil.sanitizeString(publisher) + "%");
            
            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    books.add(mapResultSetToBook(rs));
                }
            }
        }
        
        return books;
    }
    
    public List<Book> search(String searchTerm) throws SQLException {
        String sql = "SELECT * FROM livros WHERE ativo = TRUE AND (titulo LIKE ? OR autor LIKE ? OR editora LIKE ? OR isbn LIKE ?) ORDER BY titulo";
        List<Book> books = new ArrayList<>();
        
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            String term = "%" + ValidationUtil.sanitizeString(searchTerm) + "%";
            stmt.setString(1, term);
            stmt.setString(2, term);
            stmt.setString(3, term);
            stmt.setString(4, term);
            
            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    books.add(mapResultSetToBook(rs));
                }
            }
        }
        
        return books;
    }
    
    public List<Book> findWithPagination(int offset, int limit) throws SQLException {
        String sql = "SELECT * FROM livros WHERE ativo = TRUE ORDER BY titulo LIMIT ? OFFSET ?";
        List<Book> books = new ArrayList<>();
        
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setInt(1, limit);
            stmt.setInt(2, offset);
            
            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    books.add(mapResultSetToBook(rs));
                }
            }
        }
        
        return books;
    }
    
    public Book update(Book book) throws SQLException {
        String sql = "UPDATE livros SET titulo = ?, autor = ?, isbn = ?, editora = ?, ano_publicacao = ?, preco = ?, quantidade_estoque = ?, url_capa = ?, descricao = ? WHERE id = ?";
        
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setString(1, ValidationUtil.sanitizeString(book.getTitulo()));
            stmt.setString(2, ValidationUtil.sanitizeString(book.getAutor()));
            stmt.setString(3, ValidationUtil.sanitizeString(book.getIsbn()));
            stmt.setString(4, ValidationUtil.sanitizeString(book.getEditora()));
            
            if (book.getAnoPublicacao() != null) {
                stmt.setInt(5, book.getAnoPublicacao());
            } else {
                stmt.setNull(5, Types.INTEGER);
            }
            
            stmt.setBigDecimal(6, book.getPreco());
            stmt.setInt(7, book.getQuantidadeEstoque());
            stmt.setString(8, ValidationUtil.sanitizeString(book.getUrlCapa()));
            stmt.setString(9, ValidationUtil.sanitizeString(book.getDescricao()));
            stmt.setInt(10, book.getId());
            
            int affectedRows = stmt.executeUpdate();
            
            if (affectedRows == 0) {
                throw new SQLException("Falha ao atualizar livro, livro não encontrado.");
            }
            
            return book;
        }
    }
    
    public void updateStock(int bookId, int newQuantity) throws SQLException {
        String sql = "UPDATE livros SET quantidade_estoque = ? WHERE id = ?";
        
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setInt(1, newQuantity);
            stmt.setInt(2, bookId);
            
            int affectedRows = stmt.executeUpdate();
            
            if (affectedRows == 0) {
                throw new SQLException("Falha ao atualizar estoque, livro não encontrado.");
            }
        }
    }
    
    public void decreaseStock(int bookId, int quantity) throws SQLException {
        String sql = "UPDATE livros SET quantidade_estoque = quantidade_estoque - ? WHERE id = ? AND quantidade_estoque >= ?";
        
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setInt(1, quantity);
            stmt.setInt(2, bookId);
            stmt.setInt(3, quantity);
            
            int affectedRows = stmt.executeUpdate();
            
            if (affectedRows == 0) {
                throw new SQLException("Falha ao diminuir estoque, quantidade insuficiente ou livro não encontrado.");
            }
        }
    }
    
    public void delete(int id) throws SQLException {
        String sql = "UPDATE livros SET ativo = FALSE WHERE id = ?";
        
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setInt(1, id);
            
            int affectedRows = stmt.executeUpdate();
            
            if (affectedRows == 0) {
                throw new SQLException("Falha ao deletar livro, livro não encontrado.");
            }
        }
    }
    
    public long count() throws SQLException {
        String sql = "SELECT COUNT(*) FROM livros WHERE ativo = TRUE";
        
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql);
             ResultSet rs = stmt.executeQuery()) {
            
            if (rs.next()) {
                return rs.getLong(1);
            }
        }
        
        return 0;
    }
    
    private Book mapResultSetToBook(ResultSet rs) throws SQLException {
        Book book = new Book();
        book.setId(rs.getInt("id"));
        book.setTitulo(rs.getString("titulo"));
        book.setAutor(rs.getString("autor"));
        book.setIsbn(rs.getString("isbn"));
        book.setEditora(rs.getString("editora"));
        
        int anoPublicacao = rs.getInt("ano_publicacao");
        if (!rs.wasNull()) {
            book.setAnoPublicacao(anoPublicacao);
        }
        
        book.setPreco(rs.getBigDecimal("preco"));
        book.setQuantidadeEstoque(rs.getInt("quantidade_estoque"));
        book.setUrlCapa(rs.getString("url_capa"));
        book.setDescricao(rs.getString("descricao"));
        
        Timestamp timestamp = rs.getTimestamp("data_cadastro");
        if (timestamp != null) {
            book.setDataCadastro(timestamp.toLocalDateTime());
        }
        
        book.setAtivo(rs.getBoolean("ativo"));
        
        return book;
    }
}