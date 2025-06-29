package com.milpaginas.listener;

import com.milpaginas.util.DatabaseConnection;

import javax.servlet.ServletContextEvent;
import javax.servlet.ServletContextListener;

public class ApplicationStartupListener implements ServletContextListener {
    
    @Override
    public void contextInitialized(ServletContextEvent sce) {
        System.out.println("=== Mil Páginas - Aplicação Iniciando ===");
        
        try {
            boolean dbConnected = DatabaseConnection.testConnection();
            if (dbConnected) {
                System.out.println("✓ Conexão com banco de dados estabelecida com sucesso");
            } else {
                System.err.println("✗ Falha ao conectar com o banco de dados");
            }
        } catch (Exception e) {
            System.err.println("✗ Erro ao testar conexão com banco de dados: " + e.getMessage());
        }
        
        String appName = sce.getServletContext().getInitParameter("app-name");
        String appVersion = sce.getServletContext().getInitParameter("app-version");
        String developmentMode = sce.getServletContext().getInitParameter("development-mode");
        
        System.out.println("Aplicação: " + appName);
        System.out.println("Versão: " + appVersion);
        System.out.println("Modo de desenvolvimento: " + developmentMode);
        
        sce.getServletContext().setAttribute("startupTime", System.currentTimeMillis());
        
        System.out.println("=== Aplicação iniciada com sucesso ===");
    }
    
    @Override
    public void contextDestroyed(ServletContextEvent sce) {
        System.out.println("=== Mil Páginas - Aplicação Finalizando ===");
        
        Long startupTime = (Long) sce.getServletContext().getAttribute("startupTime");
        if (startupTime != null) {
            long uptime = System.currentTimeMillis() - startupTime;
            System.out.println("Tempo de execução: " + (uptime / 1000) + " segundos");
        }
        
        System.out.println("=== Aplicação finalizada ===");
    }
}