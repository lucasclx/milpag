package com.milpaginas.util;

import java.io.IOException;
import java.io.InputStream;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;
import java.util.Properties;

public class DatabaseConnection {
    private static Properties properties = new Properties();
    private static boolean propertiesLoaded = false;
    
    private static void loadProperties() {
        if (!propertiesLoaded) {
            try (InputStream input = DatabaseConnection.class.getClassLoader()
                    .getResourceAsStream("db.properties")) {
                if (input == null) {
                    try (InputStream webInfInput = DatabaseConnection.class.getClassLoader()
                            .getResourceAsStream("/WEB-INF/db.properties")) {
                        if (webInfInput != null) {
                            properties.load(webInfInput);
                        } else {
                            setDefaultProperties();
                        }
                    }
                } else {
                    properties.load(input);
                }
                propertiesLoaded = true;
            } catch (IOException e) {
                e.printStackTrace();
                setDefaultProperties();
                propertiesLoaded = true;
            }
        }
    }
    
    private static void setDefaultProperties() {
        properties.setProperty("db.url", "jdbc:mysql://localhost:3306/milpaginas?useSSL=false&allowPublicKeyRetrieval=true&serverTimezone=UTC");
        properties.setProperty("db.username", "root");
        properties.setProperty("db.password", "");
        properties.setProperty("db.driver", "com.mysql.cj.jdbc.Driver");
    }
    
    public static Connection getConnection() throws SQLException {
        loadProperties();
        
        try {
            Class.forName(properties.getProperty("db.driver"));
        } catch (ClassNotFoundException e) {
            throw new SQLException("Driver MySQL não encontrado", e);
        }
        
        return DriverManager.getConnection(
                properties.getProperty("db.url"),
                properties.getProperty("db.username"),
                properties.getProperty("db.password")
        );
    }
    
    public static void closeConnection(Connection connection) {
        if (connection != null) {
            try {
                connection.close();
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }
    }
    
    public static boolean testConnection() {
        try (Connection connection = getConnection()) {
            return connection != null && !connection.isClosed();
        } catch (SQLException e) {
            System.err.println("Erro ao testar conexão com o banco de dados: " + e.getMessage());
            return false;
        }
    }
}