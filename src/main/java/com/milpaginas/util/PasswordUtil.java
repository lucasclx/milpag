package com.milpaginas.util;

import java.security.MessageDigest;
import java.security.NoSuchAlgorithmException;
import java.security.SecureRandom;
import java.util.Base64;
import org.mindrot.jbcrypt.BCrypt;

public class PasswordUtil {
    
    // Prefixo para identificar o tipo de hash usado
    private static final String BCRYPT_PREFIX = "$2a$";
    private static final String SHA256_PREFIX = "$sha256$";
    
    /**
     * Gera hash de senha usando BCrypt (mais seguro)
     */
    public static String hashPassword(String password) {
        // Usar BCrypt como padrão para novos usuários
        return BCrypt.hashpw(password, BCrypt.gensalt(10));
    }
    
    /**
     * Verifica senha contra hash armazenado (suporta BCrypt e SHA-256 legado)
     */
    public static boolean verifyPassword(String password, String hashedPassword) {
        if (password == null || hashedPassword == null) {
            return false;
        }
        
        try {
            return BCrypt.checkpw(password, hashedPassword);
        } catch (Exception e) {
            // Log do erro seria ideal aqui
            e.printStackTrace();
            return false;
        }
    }
    
    
    
    /**
     * Gera senha aleatória segura
     */
    public static String generateRandomPassword(int length) {
        String chars = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789!@#$%";
        SecureRandom random = new SecureRandom();
        StringBuilder password = new StringBuilder();
        
        for (int i = 0; i < length; i++) {
            password.append(chars.charAt(random.nextInt(chars.length())));
        }
        
        return password.toString();
    }
    
    /**
     * Verifica força da senha
     */
    public static PasswordStrength checkPasswordStrength(String password) {
        if (password == null || password.length() < 6) {
            return PasswordStrength.WEAK;
        }
        
        int score = 0;
        
        // Comprimento
        if (password.length() >= 8) score++;
        if (password.length() >= 12) score++;
        
        // Complexidade
        if (password.matches(".*[a-z].*")) score++;
        if (password.matches(".*[A-Z].*")) score++;
        if (password.matches(".*[0-9].*")) score++;
        if (password.matches(".*[!@#$%^&*()_+\\-=\\[\\]{};':\"\\\\|,.<>/?].*")) score++;
        
        if (score <= 2) return PasswordStrength.WEAK;
        if (score <= 4) return PasswordStrength.MEDIUM;
        return PasswordStrength.STRONG;
    }
    
    public enum PasswordStrength {
        WEAK, MEDIUM, STRONG
    }
}