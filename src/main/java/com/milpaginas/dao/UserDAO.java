package com.milpaginas.dao;

import com.milpaginas.model.User;
import com.milpaginas.util.DatabaseConnectionPool;
import com.milpaginas.util.ValidationUtil;

import java.sql.*;
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;

public class UserDAO {
    
    public User save(User user) throws SQLException {
        String sql = "INSERT INTO usuarios (nome, email, senha, endereco, telefone, tipo_usuario) VALUES (?, ?, ?, ?, ?, ?)";
        
        try (Connection conn = DatabaseConnectionPool.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            
            stmt.setString(1, ValidationUtil.sanitizeString(user.getNome()));
            stmt.setString(2, ValidationUtil.sanitizeString(user.getEmail()));
            stmt.setString(3, user.getSenha());
            stmt.setString(4, ValidationUtil.sanitizeString(user.getEndereco()));
            stmt.setString(5, ValidationUtil.sanitizeString(user.getTelefone()));
            stmt.setString(6, user.getTipoUsuario().name());
            
            int affectedRows = stmt.executeUpdate();
            
            if (affectedRows == 0) {
                throw new SQLException("Falha ao criar usuário, nenhuma linha afetada.");
            }
            
            try (ResultSet generatedKeys = stmt.getGeneratedKeys()) {
                if (generatedKeys.next()) {
                    user.setId(generatedKeys.getInt(1));
                } else {
                    throw new SQLException("Falha ao criar usuário, ID não foi gerado.");
                }
            }
            
            return user;
        }
    }
    
    public User findById(int id) throws SQLException {
        String sql = "SELECT * FROM usuarios WHERE id = ? AND ativo = TRUE";
        
        try (Connection conn = DatabaseConnectionPool.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setInt(1, id);
            
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    return mapResultSetToUser(rs);
                }
            }
        }
        
        return null;
    }
    
    public User findByEmail(String email) throws SQLException {
        String sql = "SELECT * FROM usuarios WHERE email = ? AND ativo = TRUE";
        
        try (Connection conn = DatabaseConnectionPool.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setString(1, email);
            
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    return mapResultSetToUser(rs);
                }
            }
        }
        
        return null;
    }
    
    public List<User> findAll() throws SQLException {
        String sql = "SELECT * FROM usuarios WHERE ativo = TRUE ORDER BY nome";
        List<User> users = new ArrayList<>();
        
        try (Connection conn = DatabaseConnectionPool.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql);
             ResultSet rs = stmt.executeQuery()) {
            
            while (rs.next()) {
                users.add(mapResultSetToUser(rs));
            }
        }
        
        return users;
    }
    
    public List<User> findByType(User.UserType userType) throws SQLException {
        String sql = "SELECT * FROM usuarios WHERE tipo_usuario = ? AND ativo = TRUE ORDER BY nome";
        List<User> users = new ArrayList<>();
        
        try (Connection conn = DatabaseConnectionPool.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setString(1, userType.name());
            
            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    users.add(mapResultSetToUser(rs));
                }
            }
        }
        
        return users;
    }
    
    public User update(User user) throws SQLException {
        String sql = "UPDATE usuarios SET nome = ?, email = ?, endereco = ?, telefone = ?, tipo_usuario = ? WHERE id = ?";
        
        try (Connection conn = DatabaseConnectionPool.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setString(1, ValidationUtil.sanitizeString(user.getNome()));
            stmt.setString(2, ValidationUtil.sanitizeString(user.getEmail()));
            stmt.setString(3, ValidationUtil.sanitizeString(user.getEndereco()));
            stmt.setString(4, ValidationUtil.sanitizeString(user.getTelefone()));
            stmt.setString(5, user.getTipoUsuario().name());
            stmt.setInt(6, user.getId());
            
            int affectedRows = stmt.executeUpdate();
            
            if (affectedRows == 0) {
                throw new SQLException("Falha ao atualizar usuário, usuário não encontrado.");
            }
            
            return user;
        }
    }
    
    public void updatePassword(int userId, String newHashedPassword) throws SQLException {
        String sql = "UPDATE usuarios SET senha = ? WHERE id = ?";
        
        try (Connection conn = DatabaseConnectionPool.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setString(1, newHashedPassword);
            stmt.setInt(2, userId);
            
            int affectedRows = stmt.executeUpdate();
            
            if (affectedRows == 0) {
                throw new SQLException("Falha ao atualizar senha, usuário não encontrado.");
            }
        }
    }
    
    public void delete(int id) throws SQLException {
        String sql = "UPDATE usuarios SET ativo = FALSE WHERE id = ?";
        
        try (Connection conn = DatabaseConnectionPool.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setInt(1, id);
            
            int affectedRows = stmt.executeUpdate();
            
            if (affectedRows == 0) {
                throw new SQLException("Falha ao deletar usuário, usuário não encontrado.");
            }
        }
    }
    
    public boolean emailExists(String email) throws SQLException {
        String sql = "SELECT COUNT(*) FROM usuarios WHERE email = ? AND ativo = TRUE";
        
        try (Connection conn = DatabaseConnectionPool.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setString(1, email);
            
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt(1) > 0;
                }
            }
        }
        
        return false;
    }
    
    private User mapResultSetToUser(ResultSet rs) throws SQLException {
        User user = new User();
        user.setId(rs.getInt("id"));
        user.setNome(rs.getString("nome"));
        user.setEmail(rs.getString("email"));
        user.setSenha(rs.getString("senha"));
        user.setEndereco(rs.getString("endereco"));
        user.setTelefone(rs.getString("telefone"));
        user.setTipoUsuario(User.UserType.valueOf(rs.getString("tipo_usuario")));
        
        Timestamp timestamp = rs.getTimestamp("data_cadastro");
        if (timestamp != null) {
            user.setDataCadastro(timestamp.toLocalDateTime());
        }
        
        user.setAtivo(rs.getBoolean("ativo"));
        
        return user;
    }
}