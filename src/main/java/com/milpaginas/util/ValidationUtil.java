package com.milpaginas.util;

import java.util.regex.Pattern;

public class ValidationUtil {
    
    private static final String EMAIL_PATTERN = 
            "^[a-zA-Z0-9_+&*-]+(?:\\.[a-zA-Z0-9_+&*-]+)*@(?:[a-zA-Z0-9-]+\\.)+[a-zA-Z]{2,7}$";
    
    private static final String PHONE_PATTERN = 
            "^\\(?[0-9]{2}\\)?[\\s-]?[0-9]{4,5}[\\s-]?[0-9]{4}$";
    
    private static final String ISBN_PATTERN = 
            "^(?:ISBN(?:-1[03])?:? )?(?=[0-9X]{10}$|(?=(?:[0-9]+[- ]){3})[- 0-9X]{13}$|97[89][0-9]{10}$|(?=(?:[0-9]+[- ]){4})[- 0-9]{17}$)(?:97[89][- ]?)?[0-9]{1,5}[- ]?[0-9]+[- ]?[0-9]+[- ]?[0-9X]$";
    
    private static final Pattern emailPattern = Pattern.compile(EMAIL_PATTERN);
    private static final Pattern phonePattern = Pattern.compile(PHONE_PATTERN);
    private static final Pattern isbnPattern = Pattern.compile(ISBN_PATTERN);
    
    public static boolean isValidEmail(String email) {
        return email != null && emailPattern.matcher(email).matches();
    }
    
    public static boolean isValidPhone(String phone) {
        return phone != null && phonePattern.matcher(phone).matches();
    }
    
    public static boolean isValidISBN(String isbn) {
        return isbn != null && isbnPattern.matcher(isbn).matches();
    }
    
    public static boolean isValidPassword(String password) {
        return password != null && password.length() >= 6;
    }
    
    public static boolean isNotEmpty(String str) {
        return str != null && !str.trim().isEmpty();
    }
    
    public static boolean isValidYear(Integer year) {
        if (year == null) return true;
        int currentYear = java.time.Year.now().getValue();
        return year >= 1000 && year <= currentYear;
    }
    
    public static boolean isPositiveNumber(Number number) {
        return number != null && number.doubleValue() > 0;
    }
    
    public static boolean isNonNegativeInteger(Integer number) {
        return number != null && number >= 0;
    }
    
    public static String sanitizeString(String input) {
        if (input == null) return null;
        return input.trim()
                .replaceAll("<", "&lt;")
                .replaceAll(">", "&gt;")
                .replaceAll("\"", "&quot;")
                .replaceAll("'", "&#x27;");
    }
    
    public static String validateAndSanitize(String input, String fieldName) {
        if (!isNotEmpty(input)) {
            throw new IllegalArgumentException(fieldName + " é obrigatório");
        }
        return sanitizeString(input);
    }
}