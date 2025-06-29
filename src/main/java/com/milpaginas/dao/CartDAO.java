package com.milpaginas.dao;

import com.milpaginas.model.CartItem;
import com.milpaginas.model.Book;
import com.milpaginas.util.DatabaseConnection;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class CartDAO {
    
    private BookDAO bookDAO = new BookDAO();
    
    public CartItem addItem(CartItem cartItem) throws SQLException {
        String checkSql = "SELECT id, quantidade FROM carrinho WHERE usuario_id = ? AND livro_id = ?";
        String insertSql = "INSERT INTO carrinho (usuario_id, livro_id, quantidade) VALUES (?, ?, ?)";
        String updateSql = "UPDATE carrinho SET quantidade = quantidade + ? WHERE id = ?";
        
        try (Connection conn = DatabaseConnection.getConnection()) {
            try (PreparedStatement checkStmt = conn.prepareStatement(checkSql)) {
                checkStmt.setInt(1, cartItem.getUsuarioId());
                checkStmt.setInt(2, cartItem.getLivroId());
                
                try (ResultSet rs = checkStmt.executeQuery()) {
                    if (rs.next()) {
                        int existingId = rs.getInt("id");
                        try (PreparedStatement updateStmt = conn.prepareStatement(updateSql)) {
                            updateStmt.setInt(1, cartItem.getQuantidade());
                            updateStmt.setInt(2, existingId);
                            updateStmt.executeUpdate();
                            cartItem.setId(existingId);
                            cartItem.setQuantidade(rs.getInt("quantidade") + cartItem.getQuantidade());
                        }
                    } else {
                        try (PreparedStatement insertStmt = conn.prepareStatement(insertSql, Statement.RETURN_GENERATED_KEYS)) {
                            insertStmt.setInt(1, cartItem.getUsuarioId());
                            insertStmt.setInt(2, cartItem.getLivroId());
                            insertStmt.setInt(3, cartItem.getQuantidade());
                            insertStmt.executeUpdate();
                            
                            try (ResultSet generatedKeys = insertStmt.getGeneratedKeys()) {
                                if (generatedKeys.next()) {
                                    cartItem.setId(generatedKeys.getInt(1));
                                }
                            }
                        }
                    }
                }
            }
        }
        
        return cartItem;
    }
    
    public List<CartItem> findByUserId(int userId) throws SQLException {
        String sql = "SELECT c.*, l.titulo, l.autor, l.preco, l.url_capa FROM carrinho c " +
                    "JOIN livros l ON c.livro_id = l.id " +
                    "WHERE c.usuario_id = ? AND l.ativo = TRUE " +
                    "ORDER BY c.data_adicao DESC";
        
        List<CartItem> cartItems = new ArrayList<>();
        
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setInt(1, userId);
            
            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    CartItem cartItem = mapResultSetToCartItem(rs);
                    cartItems.add(cartItem);
                }
            }
        }
        
        return cartItems;
    }
    
    public CartItem findByUserAndBook(int userId, int bookId) throws SQLException {
        String sql = "SELECT c.*, l.titulo, l.autor, l.preco, l.url_capa FROM carrinho c " +
                    "JOIN livros l ON c.livro_id = l.id " +
                    "WHERE c.usuario_id = ? AND c.livro_id = ? AND l.ativo = TRUE";
        
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setInt(1, userId);
            stmt.setInt(2, bookId);
            
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    return mapResultSetToCartItem(rs);
                }
            }
        }
        
        return null;
    }
    
    public void updateQuantity(int cartItemId, int newQuantity) throws SQLException {
        if (newQuantity <= 0) {
            removeItem(cartItemId);
            return;
        }
        
        String sql = "UPDATE carrinho SET quantidade = ? WHERE id = ?";
        
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setInt(1, newQuantity);
            stmt.setInt(2, cartItemId);
            
            int affectedRows = stmt.executeUpdate();
            
            if (affectedRows == 0) {
                throw new SQLException("Falha ao atualizar quantidade, item não encontrado.");
            }
        }
    }
    
    public void removeItem(int cartItemId) throws SQLException {
        String sql = "DELETE FROM carrinho WHERE id = ?";
        
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setInt(1, cartItemId);
            
            int affectedRows = stmt.executeUpdate();
            
            if (affectedRows == 0) {
                throw new SQLException("Falha ao remover item, item não encontrado.");
            }
        }
    }
    
    public void removeByUserAndBook(int userId, int bookId) throws SQLException {
        String sql = "DELETE FROM carrinho WHERE usuario_id = ? AND livro_id = ?";
        
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setInt(1, userId);
            stmt.setInt(2, bookId);
            
            stmt.executeUpdate();
        }
    }
    
    public void clearCart(int userId) throws SQLException {
        String sql = "DELETE FROM carrinho WHERE usuario_id = ?";
        
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setInt(1, userId);
            stmt.executeUpdate();
        }
    }
    
    public int getCartItemCount(int userId) throws SQLException {
        String sql = "SELECT COALESCE(SUM(quantidade), 0) FROM carrinho c " +
                    "JOIN livros l ON c.livro_id = l.id " +
                    "WHERE c.usuario_id = ? AND l.ativo = TRUE";
        
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setInt(1, userId);
            
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt(1);
                }
            }
        }
        
        return 0;
    }
    
    private CartItem mapResultSetToCartItem(ResultSet rs) throws SQLException {
        CartItem cartItem = new CartItem();
        cartItem.setId(rs.getInt("id"));
        cartItem.setUsuarioId(rs.getInt("usuario_id"));
        cartItem.setLivroId(rs.getInt("livro_id"));
        cartItem.setQuantidade(rs.getInt("quantidade"));
        
        Timestamp timestamp = rs.getTimestamp("data_adicao");
        if (timestamp != null) {
            cartItem.setDataAdicao(timestamp.toLocalDateTime());
        }
        
        Book book = new Book();
        book.setId(rs.getInt("livro_id"));
        book.setTitulo(rs.getString("titulo"));
        book.setAutor(rs.getString("autor"));
        book.setPreco(rs.getBigDecimal("preco"));
        book.setUrlCapa(rs.getString("url_capa"));
        
        cartItem.setLivro(book);
        
        return cartItem;
    }
}