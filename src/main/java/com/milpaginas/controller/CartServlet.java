package com.milpaginas.controller;

import com.milpaginas.dao.CartDAO;
import com.milpaginas.dao.BookDAO;
import com.milpaginas.model.CartItem;
import com.milpaginas.model.Book;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.io.PrintWriter;
import java.math.BigDecimal;
import java.sql.SQLException;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

public class CartServlet extends HttpServlet {
    
    private CartDAO cartDAO = new CartDAO();
    private BookDAO bookDAO = new BookDAO();
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        if (!isLoggedIn(request)) {
            response.sendRedirect("login?redirect=cart");
            return;
        }
        
        String action = request.getParameter("action");
        if (action == null) action = "view";
        
        try {
            switch (action) {
                case "view":
                    viewCart(request, response);
                    break;
                case "count":
                    getCartCount(request, response);
                    break;
                default:
                    viewCart(request, response);
            }
        } catch (SQLException e) {
            e.printStackTrace();
            request.setAttribute("error", "Erro interno do servidor");
            request.getRequestDispatcher("/error.jsp").forward(request, response);
        }
    }
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        if (!isLoggedIn(request)) {
            sendJsonResponse(response, false, "Usuário não logado", null);
            return;
        }
        
        String action = request.getParameter("action");
        if (action == null) {
            sendJsonResponse(response, false, "Ação não especificada", null);
            return;
        }
        
        try {
            switch (action) {
                case "add":
                    addToCart(request, response);
                    break;
                case "update":
                    updateCartItem(request, response);
                    break;
                case "remove":
                    removeFromCart(request, response);
                    break;
                case "clear":
                    clearCart(request, response);
                    break;
                default:
                    sendJsonResponse(response, false, "Ação inválida", null);
            }
        } catch (SQLException e) {
            e.printStackTrace();
            sendJsonResponse(response, false, "Erro interno do servidor", null);
        }
    }
    
    private void viewCart(HttpServletRequest request, HttpServletResponse response) 
            throws SQLException, ServletException, IOException {
        
        int userId = getUserId(request);
        List<CartItem> cartItems = cartDAO.findByUserId(userId);
        
        BigDecimal total = cartItems.stream()
                .map(CartItem::getSubtotal)
                .reduce(BigDecimal.ZERO, BigDecimal::add);
        
        int totalItems = cartItems.stream()
                .mapToInt(CartItem::getQuantidade)
                .sum();
        
        request.setAttribute("cartItems", cartItems);
        request.setAttribute("cartTotal", total);
        request.setAttribute("totalItems", totalItems);
        
        request.getRequestDispatcher("/cart.jsp").forward(request, response);
    }
    
    private void addToCart(HttpServletRequest request, HttpServletResponse response) 
            throws SQLException, IOException {
        
        String bookIdStr = request.getParameter("bookId");
        String quantityStr = request.getParameter("quantity");
        
        if (bookIdStr == null || quantityStr == null) {
            sendJsonResponse(response, false, "Parâmetros obrigatórios", null);
            return;
        }
        
        try {
            int bookId = Integer.parseInt(bookIdStr);
            int quantity = Integer.parseInt(quantityStr);
            
            if (quantity <= 0) {
                sendJsonResponse(response, false, "Quantidade deve ser positiva", null);
                return;
            }
            
            Book book = bookDAO.findById(bookId);
            if (book == null) {
                sendJsonResponse(response, false, "Livro não encontrado", null);
                return;
            }
            
            if (book.getQuantidadeEstoque() < quantity) {
                sendJsonResponse(response, false, "Quantidade insuficiente em estoque", null);
                return;
            }
            
            int userId = getUserId(request);
            CartItem cartItem = new CartItem(userId, bookId, quantity);
            cartDAO.addItem(cartItem);
            
            int cartCount = cartDAO.getCartItemCount(userId);
            Map<String, Object> data = new HashMap<>();
            data.put("cartCount", cartCount);
            
            sendJsonResponse(response, true, "Item adicionado ao carrinho", data);
            
        } catch (NumberFormatException e) {
            sendJsonResponse(response, false, "Parâmetros inválidos", null);
        }
    }
    
    private void updateCartItem(HttpServletRequest request, HttpServletResponse response) 
            throws SQLException, IOException {
        
        String cartItemIdStr = request.getParameter("cartItemId");
        String quantityStr = request.getParameter("quantity");
        
        if (cartItemIdStr == null || quantityStr == null) {
            sendJsonResponse(response, false, "Parâmetros obrigatórios", null);
            return;
        }
        
        try {
            int cartItemId = Integer.parseInt(cartItemIdStr);
            int quantity = Integer.parseInt(quantityStr);
            
            cartDAO.updateQuantity(cartItemId, quantity);
            
            int userId = getUserId(request);
            int cartCount = cartDAO.getCartItemCount(userId);
            Map<String, Object> data = new HashMap<>();
            data.put("cartCount", cartCount);
            
            sendJsonResponse(response, true, "Carrinho atualizado", data);
            
        } catch (NumberFormatException e) {
            sendJsonResponse(response, false, "Parâmetros inválidos", null);
        }
    }
    
    private void removeFromCart(HttpServletRequest request, HttpServletResponse response) 
            throws SQLException, IOException {
        
        String cartItemIdStr = request.getParameter("cartItemId");
        
        if (cartItemIdStr == null) {
            sendJsonResponse(response, false, "ID do item é obrigatório", null);
            return;
        }
        
        try {
            int cartItemId = Integer.parseInt(cartItemIdStr);
            cartDAO.removeItem(cartItemId);
            
            int userId = getUserId(request);
            int cartCount = cartDAO.getCartItemCount(userId);
            Map<String, Object> data = new HashMap<>();
            data.put("cartCount", cartCount);
            
            sendJsonResponse(response, true, "Item removido do carrinho", data);
            
        } catch (NumberFormatException e) {
            sendJsonResponse(response, false, "ID inválido", null);
        }
    }
    
    private void clearCart(HttpServletRequest request, HttpServletResponse response) 
            throws SQLException, IOException {
        
        int userId = getUserId(request);
        cartDAO.clearCart(userId);
        
        Map<String, Object> data = new HashMap<>();
        data.put("cartCount", 0);
        
        sendJsonResponse(response, true, "Carrinho limpo", data);
    }
    
    private void getCartCount(HttpServletRequest request, HttpServletResponse response) 
            throws SQLException, IOException {
        
        int userId = getUserId(request);
        int cartCount = cartDAO.getCartItemCount(userId);
        
        Map<String, Object> data = new HashMap<>();
        data.put("cartCount", cartCount);
        
        sendJsonResponse(response, true, null, data);
    }
    
    private boolean isLoggedIn(HttpServletRequest request) {
        HttpSession session = request.getSession(false);
        return session != null && session.getAttribute("userId") != null;
    }
    
    private int getUserId(HttpServletRequest request) {
        HttpSession session = request.getSession();
        Integer userId = (Integer) session.getAttribute("userId");
        return userId != null ? userId : 0;
    }
    
    private void sendJsonResponse(HttpServletResponse response, boolean success, String message, Object data) 
            throws IOException {
        
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        
        Map<String, Object> result = new HashMap<>();
        result.put("success", success);
        if (message != null) {
            result.put("message", message);
        }
        if (data != null) {
            result.put("data", data);
        }
        
        PrintWriter out = response.getWriter();
        out.print(mapToJson(result));
        out.flush();
    }
    
    private String mapToJson(Map<String, Object> map) {
        StringBuilder json = new StringBuilder("{");
        boolean first = true;
        
        for (Map.Entry<String, Object> entry : map.entrySet()) {
            if (!first) {
                json.append(",");
            }
            
            json.append("\"").append(entry.getKey()).append("\":");
            
            Object value = entry.getValue();
            if (value == null) {
                json.append("null");
            } else if (value instanceof String) {
                json.append("\"").append(value.toString().replace("\"", "\\\"")).append("\"");
            } else if (value instanceof Boolean) {
                json.append(value.toString());
            } else if (value instanceof Number) {
                json.append(value.toString());
            } else if (value instanceof Map) {
                json.append(mapToJson((Map<String, Object>) value));
            } else {
                json.append("\"").append(value.toString().replace("\"", "\\\"")).append("\"");
            }
            
            first = false;
        }
        
        json.append("}");
        return json.toString();
    }
}