package com.milpaginas.util;

import com.zaxxer.hikari.HikariConfig;
import com.zaxxer.hikari.HikariDataSource;

import java.io.IOException;
import java.io.InputStream;
import java.sql.Connection;
import java.sql.SQLException;
import java.util.Properties;

/**
 * Gerenciador de pool de conexões usando HikariCP
 */
public class DatabaseConnectionPool {
    private static HikariDataSource dataSource;
    private static final Object lock = new Object();
    
    static {
        try {
            initialize();
        } catch (Exception e) {
            throw new RuntimeException("Falha ao inicializar pool de conexões", e);
        }
    }
    
    private static void initialize() throws IOException {
        Properties props = loadProperties();
        
        HikariConfig config = new HikariConfig();
        
        // Configurações básicas
        config.setJdbcUrl(props.getProperty("db.url"));
        config.setUsername(props.getProperty("db.username"));
        config.setPassword(props.getProperty("db.password"));
        config.setDriverClassName(props.getProperty("db.driver", "com.mysql.cj.jdbc.Driver"));
        
        // Configurações do pool
        config.setMaximumPoolSize(Integer.parseInt(props.getProperty("db.maxConnections", "20")));
        config.setMinimumIdle(Integer.parseInt(props.getProperty("db.minConnections", "5")));
        config.setConnectionTimeout(Long.parseLong(props.getProperty("db.connectionTimeout", "30000")));
        config.setIdleTimeout(Long.parseLong(props.getProperty("db.idleTimeout", "600000")));
        config.setMaxLifetime(Long.parseLong(props.getProperty("db.maxLifetime", "1800000")));
        
        // Configurações de validação
        config.setConnectionTestQuery(props.getProperty("db.validationQuery", "SELECT 1"));
        config.setValidationTimeout(5000);
        
        // Configurações de performance
        config.addDataSourceProperty("cachePrepStmts", props.getProperty("db.mysql.cachePrepStmts", "true"));
        config.addDataSourceProperty("prepStmtCacheSize", props.getProperty("db.mysql.prepStmtCacheSize", "250"));
        config.addDataSourceProperty("prepStmtCacheSqlLimit", props.getProperty("db.mysql.prepStmtCacheSqlLimit", "2048"));
        config.addDataSourceProperty("useServerPrepStmts", props.getProperty("db.mysql.useServerPrepStmts", "true"));
        
        // Nome do pool para debugging
        config.setPoolName("MilPaginasPool");
        
        // Configurações de leak detection
        config.setLeakDetectionThreshold(60000); // 1 minuto
        
        dataSource = new HikariDataSource(config);
    }
    
    private static Properties loadProperties() throws IOException {
        Properties properties = new Properties();
        
        // Tentar carregar de diferentes locais
        InputStream input = DatabaseConnectionPool.class.getClassLoader()
                .getResourceAsStream("db.properties");
        
        if (input == null) {
            input = DatabaseConnectionPool.class.getClassLoader()
                    .getResourceAsStream("/WEB-INF/db.properties");
        }
        
        if (input != null) {
            properties.load(input);
            input.close();
        } else {
            // Configurações padrão
            setDefaultProperties(properties);
        }
        
        return properties;
    }
    
    private static void setDefaultProperties(Properties properties) {
        // Usar variáveis de ambiente com fallback para desenvolvimento
        properties.setProperty("db.url", 
            System.getenv("DB_URL") != null ? System.getenv("DB_URL") : 
            "jdbc:mysql://localhost:3306/milpaginas?useSSL=false&allowPublicKeyRetrieval=true&serverTimezone=UTC");
        properties.setProperty("db.username", 
            System.getenv("DB_USERNAME") != null ? System.getenv("DB_USERNAME") : "root");
        properties.setProperty("db.password", 
            System.getenv("DB_PASSWORD") != null ? System.getenv("DB_PASSWORD") : "");
        properties.setProperty("db.driver", "com.mysql.cj.jdbc.Driver");
        properties.setProperty("db.maxConnections", "20");
        properties.setProperty("db.minConnections", "5");
    }
    
    /**
     * Obtém uma conexão do pool
     */
    public static Connection getConnection() throws SQLException {
        if (dataSource == null) {
            synchronized (lock) {
                if (dataSource == null) {
                    try {
                        initialize();
                    } catch (IOException e) {
                        throw new SQLException("Erro ao inicializar pool", e);
                    }
                }
            }
        }
        return dataSource.getConnection();
    }
    
    /**
     * Fecha uma conexão (retorna ao pool)
     */
    public static void closeConnection(Connection connection) {
        if (connection != null) {
            try {
                connection.close();
            } catch (SQLException e) {
                // Log do erro
                e.printStackTrace();
            }
        }
    }
    
    /**
     * Fecha conexão, statement e resultset
     */
    public static void closeAll(Connection conn, java.sql.Statement stmt, java.sql.ResultSet rs) {
        if (rs != null) {
            try {
                rs.close();
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }
        
        if (stmt != null) {
            try {
                stmt.close();
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }
        
        closeConnection(conn);
    }
    
    /**
     * Testa se o pool está funcionando
     */
    public static boolean testConnection() {
        try (Connection conn = getConnection()) {
            return conn != null && !conn.isClosed();
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }
    
    /**
     * Obtém estatísticas do pool
     */
    
    
    

    public static PoolStats getPoolStats() {
        if (dataSource != null) {
            return new PoolStats(
                dataSource.getHikariPoolMXBean().getActiveConnections(),
                dataSource.getHikariPoolMXBean().getIdleConnections(),
                dataSource.getHikariPoolMXBean().getTotalConnections(),
                dataSource.getHikariPoolMXBean().getThreadsAwaitingConnection()
            );
        }
        return null;
    }
    
    /**
     * Fecha o pool (usar apenas no shutdown da aplicação)
     */
    public static void shutdown() {
        if (dataSource != null && !dataSource.isClosed()) {
            dataSource.close();
        }
    }
    
    /**
     * Classe para estatísticas do pool
     */
    public static class PoolStats {
        private final int activeConnections;
        private final int idleConnections;
        private final int totalConnections;
        private final int threadsWaiting;
        
        public PoolStats(int active, int idle, int total, int waiting) {
            this.activeConnections = active;
            this.idleConnections = idle;
            this.totalConnections = total;
            this.threadsWaiting = waiting;
        }
        
        // Getters
        public int getActiveConnections() { return activeConnections; }
        public int getIdleConnections() { return idleConnections; }
        public int getTotalConnections() { return totalConnections; }
        public int getThreadsWaiting() { return threadsWaiting; }
    }
}