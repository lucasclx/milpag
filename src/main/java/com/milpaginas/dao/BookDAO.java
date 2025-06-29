package com.milpaginas.dao;

import com.milpaginas.model.Book;
import com.milpaginas.util.DatabaseConnectionPool;
import com.milpaginas.util.ValidationUtil;

import java.math.BigDecimal;
import java.sql.*;
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;

public class BookDAO {
    
    /**
     * Salva um novo livro com validação
     */
    public Book save(Book book) throws SQLException {
        String sql = "INSERT INTO livros (titulo, autor, isbn, editora, ano_publicacao, preco, quantidade_estoque, url_capa, descricao, version) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, 1)";
        
        Connection conn = null;
        PreparedStatement stmt = null;
        ResultSet rs = null;
        
        try {
            conn = DatabaseConnectionPool.getConnection();
            conn.setAutoCommit(false);
            
            // Verificar ISBN duplicado
            if (book.getIsbn() != null && isbnExists(book.getIsbn(), conn)) {
                throw new SQLException("ISBN já cadastrado");
            }
            
            stmt = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS);
            
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
            
            rs = stmt.getGeneratedKeys();
            if (rs.next()) {
                book.setId(rs.getInt(1));
                book.setVersion(1);
            } else {
                throw new SQLException("Falha ao criar livro, ID não foi gerado.");
            }
            
            conn.commit();
            return book;
            
        } catch (SQLException e) {
            if (conn != null) {
                conn.rollback();
            }
            throw e;
        } finally {
            DatabaseConnectionPool.closeAll(conn, stmt, rs);
        }
    }
    
    /**
     * Busca livro por ID com lock para leitura
     */
    public Book findById(int id) throws SQLException {
        return findById(id, false);
    }
    
    /**
     * Busca livro por ID com opção de lock para atualização
     */
    public Book findById(int id, boolean forUpdate) throws SQLException {
        String sql = "SELECT * FROM livros WHERE id = ? AND ativo = TRUE";
        if (forUpdate) {
            sql += " FOR UPDATE";
        }
        
        Connection conn = null;
        PreparedStatement stmt = null;
        ResultSet rs = null;
        
        try {
            conn = DatabaseConnectionPool.getConnection();
            stmt = conn.prepareStatement(sql);
            stmt.setInt(1, id);
            
            rs = stmt.executeQuery();
            if (rs.next()) {
                return mapResultSetToBook(rs);
            }
            return null;
            
        } finally {
            DatabaseConnectionPool.closeAll(conn, stmt, rs);
        }
    }
    
    /**
     * Lista todos os livros ativos
     */
    public List<Book> findAll() throws SQLException {
        String sql = "SELECT * FROM livros WHERE ativo = TRUE ORDER BY titulo";
        List<Book> books = new ArrayList<>();
        
        Connection conn = null;
        PreparedStatement stmt = null;
        ResultSet rs = null;
        
        try {
            conn = DatabaseConnectionPool.getConnection();
            stmt = conn.prepareStatement(sql);
            rs = stmt.executeQuery();
            
            while (rs.next()) {
                books.add(mapResultSetToBook(rs));
            }
            
            return books;
            
        } finally {
            DatabaseConnectionPool.closeAll(conn, stmt, rs);
        }
    }
    
    /**
     * Busca livros com paginação
     */
    public List<Book> findWithPagination(int offset, int limit) throws SQLException {
        String sql = "SELECT * FROM livros WHERE ativo = TRUE ORDER BY titulo LIMIT ? OFFSET ?";
        List<Book> books = new ArrayList<>();
        
        Connection conn = null;
        PreparedStatement stmt = null;
        ResultSet rs = null;
        
        try {
            conn = DatabaseConnectionPool.getConnection();
            stmt = conn.prepareStatement(sql);
            stmt.setInt(1, limit);
            stmt.setInt(2, offset);
            
            rs = stmt.executeQuery();
            while (rs.next()) {
                books.add(mapResultSetToBook(rs));
            }
            
            return books;
            
        } finally {
            DatabaseConnectionPool.closeAll(conn, stmt, rs);
        }
    }
    
    /**
     * Busca livros por título com proteção contra SQL injection
     */
    public List<Book> findByTitle(String title) throws SQLException {
        String sql = "SELECT * FROM livros WHERE ativo = TRUE AND titulo LIKE ? ORDER BY titulo";
        return findByLikeQuery(sql, title);
    }
    
    /**
     * Busca livros por autor
     */
    public List<Book> findByAuthor(String author) throws SQLException {
        String sql = "SELECT * FROM livros WHERE ativo = TRUE AND autor LIKE ? ORDER BY titulo";
        return findByLikeQuery(sql, author);
    }
    
    /**
     * Busca livros por editora
     */
    public List<Book> findByPublisher(String publisher) throws SQLException {
        String sql = "SELECT * FROM livros WHERE ativo = TRUE AND editora LIKE ? ORDER BY titulo";
        return findByLikeQuery(sql, publisher);
    }
    
    /**
     * Busca genérica em múltiplos campos
     */
    public List<Book> search(String searchTerm) throws SQLException {
        String sql = "SELECT * FROM livros WHERE ativo = TRUE AND (titulo LIKE ? OR autor LIKE ? OR editora LIKE ? OR isbn LIKE ?) ORDER BY titulo";
        List<Book> books = new ArrayList<>();
        
        Connection conn = null;
        PreparedStatement stmt = null;
        ResultSet rs = null;
        
        try {
            conn = DatabaseConnectionPool.getConnection();
            stmt = conn.prepareStatement(sql);
            
            String term = "%" + ValidationUtil.sanitizeString(searchTerm) + "%";
            stmt.setString(1, term);
            stmt.setString(2, term);
            stmt.setString(3, term);
            stmt.setString(4, term);
            
            rs = stmt.executeQuery();
            while (rs.next()) {
                books.add(mapResultSetToBook(rs));
            }
            
            return books;
            
        } finally {
            DatabaseConnectionPool.closeAll(conn, stmt, rs);
        }
    }
    
    /**
     * Atualiza livro com controle de versão otimista
     */
    public Book update(Book book) throws SQLException {
        String sql = "UPDATE livros SET titulo = ?, autor = ?, isbn = ?, editora = ?, " +
                    "ano_publicacao = ?, preco = ?, quantidade_estoque = ?, url_capa = ?, " +
                    "descricao = ?, version = version + 1 WHERE id = ? AND version = ?";
        
        Connection conn = null;
        PreparedStatement stmt = null;
        
        try {
            conn = DatabaseConnectionPool.getConnection();
            conn.setAutoCommit(false);
            
            stmt = conn.prepareStatement(sql);
            
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
            stmt.setInt(11, book.getVersion());
            
            int affectedRows = stmt.executeUpdate();
            
            if (affectedRows == 0) {
                throw new SQLException("Falha ao atualizar livro. Livro foi modificado por outro usuário.");
            }
            
            book.setVersion(book.getVersion() + 1);
            conn.commit();
            return book;
            
        } catch (SQLException e) {
            if (conn != null) {
                conn.rollback();
            }
            throw e;
        } finally {
            DatabaseConnectionPool.closeAll(conn, stmt, null);
        }
    }
    
    /**
     * Diminui estoque com verificação e lock
     */
    public void decreaseStock(int bookId, int quantity) throws SQLException {
        String checkSql = "SELECT quantidade_estoque, version FROM livros WHERE id = ? AND ativo = TRUE FOR UPDATE";
        String updateSql = "UPDATE livros SET quantidade_estoque = quantidade_estoque - ?, " +
                          "version = version + 1 WHERE id = ? AND quantidade_estoque >= ? AND version = ?";
        
        Connection conn = null;
        PreparedStatement checkStmt = null;
        PreparedStatement updateStmt = null;
        ResultSet rs = null;
        
        try {
            conn = DatabaseConnectionPool.getConnection();
            conn.setAutoCommit(false);
            
            // Verificar estoque atual com lock
            checkStmt = conn.prepareStatement(checkSql);
            checkStmt.setInt(1, bookId);
            rs = checkStmt.executeQuery();
            
            if (!rs.next()) {
                throw new SQLException("Livro não encontrado");
            }
            
            int currentStock = rs.getInt("quantidade_estoque");
            int version = rs.getInt("version");
            
            if (currentStock < quantity) {
                throw new SQLException("Estoque insuficiente. Disponível: " + currentStock);
            }
            
            // Atualizar estoque
            updateStmt = conn.prepareStatement(updateSql);
            updateStmt.setInt(1, quantity);
            updateStmt.setInt(2, bookId);
            updateStmt.setInt(3, quantity);
            updateStmt.setInt(4, version);
            
            int affectedRows = updateStmt.executeUpdate();
            
            if (affectedRows == 0) {
                throw new SQLException("Falha ao atualizar estoque. Tente novamente.");
            }
            
            conn.commit();
            
        } catch (SQLException e) {
            if (conn != null) {
                conn.rollback();
            }
            throw e;
        } finally {
            DatabaseConnectionPool.closeAll(conn, updateStmt, rs);
            if (checkStmt != null) checkStmt.close();
        }
    }
    
    /**
     * Aumenta estoque com verificação e lock
     */
    public void increaseStock(int bookId, int quantity) throws SQLException {
        String checkSql = "SELECT quantidade_estoque, version FROM livros WHERE id = ? AND ativo = TRUE FOR UPDATE";
        String updateSql = "UPDATE livros SET quantidade_estoque = quantidade_estoque + ?, " +
                          "version = version + 1 WHERE id = ? AND version = ?";
        
        Connection conn = null;
        PreparedStatement checkStmt = null;
        PreparedStatement updateStmt = null;
        ResultSet rs = null;
        
        try {
            conn = DatabaseConnectionPool.getConnection();
            conn.setAutoCommit(false);
            
            // Verificar estoque atual com lock
            checkStmt = conn.prepareStatement(checkSql);
            checkStmt.setInt(1, bookId);
            rs = checkStmt.executeQuery();
            
            if (!rs.next()) {
                throw new SQLException("Livro não encontrado");
            }
            
            int version = rs.getInt("version");
            
            // Atualizar estoque
            updateStmt = conn.prepareStatement(updateSql);
            updateStmt.setInt(1, quantity);
            updateStmt.setInt(2, bookId);
            updateStmt.setInt(3, version);
            
            int affectedRows = updateStmt.executeUpdate();
            
            if (affectedRows == 0) {
                throw new SQLException("Falha ao atualizar estoque. Tente novamente.");
            }
            
            conn.commit();
            
        } catch (SQLException e) {
            if (conn != null) {
                conn.rollback();
            }
            throw e;
        } finally {
            DatabaseConnectionPool.closeAll(conn, updateStmt, rs);
            if (checkStmt != null) checkStmt.close();
        }
    }
    
    /**
     * Soft delete de livro
     */
    public void delete(int id) throws SQLException {
        String sql = "UPDATE livros SET ativo = FALSE WHERE id = ?";
        
        Connection conn = null;
        PreparedStatement stmt = null;
        
        try {
            conn = DatabaseConnectionPool.getConnection();
            stmt = conn.prepareStatement(sql);
            stmt.setInt(1, id);
            
            int affectedRows = stmt.executeUpdate();
            
            if (affectedRows == 0) {
                throw new SQLException("Falha ao deletar livro, livro não encontrado.");
            }
            
        } finally {
            DatabaseConnectionPool.closeAll(conn, stmt, null);
        }
    }
    
    /**
     * Conta total de livros ativos
     */
    public long count() throws SQLException {
        String sql = "SELECT COUNT(*) FROM livros WHERE ativo = TRUE";
        
        Connection conn = null;
        PreparedStatement stmt = null;
        ResultSet rs = null;
        
        try {
            conn = DatabaseConnectionPool.getConnection();
            stmt = conn.prepareStatement(sql);
            rs = stmt.executeQuery();
            
            if (rs.next()) {
                return rs.getLong(1);
            }
            return 0;
            
        } finally {
            DatabaseConnectionPool.closeAll(conn, stmt, rs);
        }
    }
    
    /**
     * Verifica se ISBN já existe
     */
    private boolean isbnExists(String isbn, Connection conn) throws SQLException {
        String sql = "SELECT COUNT(*) FROM livros WHERE isbn = ? AND ativo = TRUE";
        
        try (PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, isbn);
            try (ResultSet rs = stmt.executeQuery()) {
                return rs.next() && rs.getInt(1) > 0;
            }
        }
    }
    
    /**
     * Busca genérica com LIKE
     */
    private List<Book> findByLikeQuery(String sql, String searchTerm) throws SQLException {
        List<Book> books = new ArrayList<>();
        
        Connection conn = null;
        PreparedStatement stmt = null;
        ResultSet rs = null;
        
        try {
            conn = DatabaseConnectionPool.getConnection();
            stmt = conn.prepareStatement(sql);
            stmt.setString(1, "%" + escapeLikePattern(ValidationUtil.sanitizeString(searchTerm)) + "%");
            
            rs = stmt.executeQuery();
            while (rs.next()) {
                books.add(mapResultSetToBook(rs));
            }
            
            return books;
            
        } finally {
            DatabaseConnectionPool.closeAll(conn, stmt, rs);
        }
    }
    
    /**
     * Escapa caracteres especiais para LIKE
     */
    private String escapeLikePattern(String pattern) {
        if (pattern == null) return null;
        return pattern
            .replace("\\", "\\\\")
            .replace("%", "\\%")
            .replace("_", "\\_");
    }
    
    /**
     * Mapeia ResultSet para Book
     */
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
        
        // Version para controle otimista
        try {
            book.setVersion(rs.getInt("version"));
        } catch (SQLException e) {
            // Coluna pode não existir em bancos legados
            book.setVersion(1);
        }
        
        Timestamp timestamp = rs.getTimestamp("data_cadastro");
        if (timestamp != null) {
            book.setDataCadastro(timestamp.toLocalDateTime());
        }
        
        book.setAtivo(rs.getBoolean("ativo"));
        
        return book;
    }
}