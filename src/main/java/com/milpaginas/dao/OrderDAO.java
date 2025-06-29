package com.milpaginas.dao;

import com.milpaginas.model.Order;
import com.milpaginas.model.OrderItem;
import com.milpaginas.model.Book;
import com.milpaginas.model.User;
import com.milpaginas.util.DatabaseConnection;
import com.milpaginas.util.ValidationUtil;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class OrderDAO {
    
    private UserDAO userDAO = new UserDAO();
    private BookDAO bookDAO = new BookDAO();
    
    public Order save(Order order) throws SQLException {
        Connection conn = null;
        try {
            conn = DatabaseConnection.getConnection();
            conn.setAutoCommit(false);
            
            String orderSql = "INSERT INTO pedidos (usuario_id, endereco_entrega, valor_total, observacoes, status_pedido) VALUES (?, ?, ?, ?, ?)";
            
            try (PreparedStatement orderStmt = conn.prepareStatement(orderSql, Statement.RETURN_GENERATED_KEYS)) {
                orderStmt.setInt(1, order.getUsuarioId());
                orderStmt.setString(2, ValidationUtil.sanitizeString(order.getEnderecoEntrega()));
                orderStmt.setBigDecimal(3, order.getValorTotal());
                orderStmt.setString(4, ValidationUtil.sanitizeString(order.getObservacoes()));
                orderStmt.setString(5, order.getStatusPedido().name());
                
                int affectedRows = orderStmt.executeUpdate();
                
                if (affectedRows == 0) {
                    throw new SQLException("Falha ao criar pedido, nenhuma linha afetada.");
                }
                
                try (ResultSet generatedKeys = orderStmt.getGeneratedKeys()) {
                    if (generatedKeys.next()) {
                        order.setId(generatedKeys.getInt(1));
                    } else {
                        throw new SQLException("Falha ao criar pedido, ID não foi gerado.");
                    }
                }
            }
            
            String itemSql = "INSERT INTO itens_pedido (pedido_id, livro_id, quantidade, preco_unitario, subtotal) VALUES (?, ?, ?, ?, ?)";
            
            try (PreparedStatement itemStmt = conn.prepareStatement(itemSql)) {
                for (OrderItem item : order.getItens()) {
                    itemStmt.setInt(1, order.getId());
                    itemStmt.setInt(2, item.getLivroId());
                    itemStmt.setInt(3, item.getQuantidade());
                    itemStmt.setBigDecimal(4, item.getPrecoUnitario());
                    itemStmt.setBigDecimal(5, item.getSubtotal());
                    itemStmt.addBatch();
                }
                itemStmt.executeBatch();
            }
            
            conn.commit();
            return order;
            
        } catch (SQLException e) {
            if (conn != null) {
                conn.rollback();
            }
            throw e;
        } finally {
            if (conn != null) {
                conn.setAutoCommit(true);
                DatabaseConnection.closeConnection(conn);
            }
        }
    }
    
    public Order findById(int id) throws SQLException {
        String sql = "SELECT p.*, u.nome as usuario_nome, u.email as usuario_email FROM pedidos p " +
                    "JOIN usuarios u ON p.usuario_id = u.id " +
                    "WHERE p.id = ?";
        
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setInt(1, id);
            
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    Order order = mapResultSetToOrder(rs);
                    order.setItens(findOrderItems(id));
                    return order;
                }
            }
        }
        
        return null;
    }
    
    public List<Order> findByUserId(int userId) throws SQLException {
        String sql = "SELECT p.*, u.nome as usuario_nome, u.email as usuario_email FROM pedidos p " +
                    "JOIN usuarios u ON p.usuario_id = u.id " +
                    "WHERE p.usuario_id = ? ORDER BY p.data_pedido DESC";
        
        List<Order> orders = new ArrayList<>();
        
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setInt(1, userId);
            
            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    Order order = mapResultSetToOrder(rs);
                    order.setItens(findOrderItems(order.getId()));
                    orders.add(order);
                }
            }
        }
        
        return orders;
    }
    
    public List<Order> findAll() throws SQLException {
        String sql = "SELECT p.*, u.nome as usuario_nome, u.email as usuario_email FROM pedidos p " +
                    "JOIN usuarios u ON p.usuario_id = u.id " +
                    "ORDER BY p.data_pedido DESC";
        
        List<Order> orders = new ArrayList<>();
        
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql);
             ResultSet rs = stmt.executeQuery()) {
            
            while (rs.next()) {
                Order order = mapResultSetToOrder(rs);
                order.setItens(findOrderItems(order.getId()));
                orders.add(order);
            }
        }
        
        return orders;
    }
    
    public List<Order> findByStatus(Order.OrderStatus status) throws SQLException {
        String sql = "SELECT p.*, u.nome as usuario_nome, u.email as usuario_email FROM pedidos p " +
                    "JOIN usuarios u ON p.usuario_id = u.id " +
                    "WHERE p.status_pedido = ? ORDER BY p.data_pedido DESC";
        
        List<Order> orders = new ArrayList<>();
        
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setString(1, status.name());
            
            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    Order order = mapResultSetToOrder(rs);
                    order.setItens(findOrderItems(order.getId()));
                    orders.add(order);
                }
            }
        }
        
        return orders;
    }
    
    public void updateStatus(int orderId, Order.OrderStatus newStatus) throws SQLException {
        String sql = "UPDATE pedidos SET status_pedido = ? WHERE id = ?";
        
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setString(1, newStatus.name());
            stmt.setInt(2, orderId);
            
            int affectedRows = stmt.executeUpdate();
            
            if (affectedRows == 0) {
                throw new SQLException("Falha ao atualizar status do pedido, pedido não encontrado.");
            }
        }
    }
    
    public List<OrderItem> findOrderItems(int orderId) throws SQLException {
        String sql = "SELECT ip.*, l.titulo, l.autor, l.url_capa FROM itens_pedido ip " +
                    "JOIN livros l ON ip.livro_id = l.id " +
                    "WHERE ip.pedido_id = ?";
        
        List<OrderItem> items = new ArrayList<>();
        
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setInt(1, orderId);
            
            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    OrderItem item = new OrderItem();
                    item.setId(rs.getInt("id"));
                    item.setPedidoId(rs.getInt("pedido_id"));
                    item.setLivroId(rs.getInt("livro_id"));
                    item.setQuantidade(rs.getInt("quantidade"));
                    item.setPrecoUnitario(rs.getBigDecimal("preco_unitario"));
                    item.setSubtotal(rs.getBigDecimal("subtotal"));
                    
                    Book book = new Book();
                    book.setId(rs.getInt("livro_id"));
                    book.setTitulo(rs.getString("titulo"));
                    book.setAutor(rs.getString("autor"));
                    book.setUrlCapa(rs.getString("url_capa"));
                    book.setPreco(rs.getBigDecimal("preco_unitario"));
                    
                    item.setLivro(book);
                    items.add(item);
                }
            }
        }
        
        return items;
    }
    
    public long countByStatus(Order.OrderStatus status) throws SQLException {
        String sql = "SELECT COUNT(*) FROM pedidos WHERE status_pedido = ?";
        
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setString(1, status.name());
            
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    return rs.getLong(1);
                }
            }
        }
        
        return 0;
    }
    
    public long countByUser(int userId) throws SQLException {
        String sql = "SELECT COUNT(*) FROM pedidos WHERE usuario_id = ?";
        
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setInt(1, userId);
            
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    return rs.getLong(1);
                }
            }
        }
        
        return 0;
    }
    
    private Order mapResultSetToOrder(ResultSet rs) throws SQLException {
        Order order = new Order();
        order.setId(rs.getInt("id"));
        order.setUsuarioId(rs.getInt("usuario_id"));
        order.setEnderecoEntrega(rs.getString("endereco_entrega"));
        order.setValorTotal(rs.getBigDecimal("valor_total"));
        order.setObservacoes(rs.getString("observacoes"));
        order.setStatusPedido(Order.OrderStatus.valueOf(rs.getString("status_pedido")));
        
        Timestamp timestamp = rs.getTimestamp("data_pedido");
        if (timestamp != null) {
            order.setDataPedido(timestamp.toLocalDateTime());
        }
        
        User user = new User();
        user.setId(rs.getInt("usuario_id"));
        user.setNome(rs.getString("usuario_nome"));
        user.setEmail(rs.getString("usuario_email"));
        order.setUsuario(user);
        
        return order;
    }
}