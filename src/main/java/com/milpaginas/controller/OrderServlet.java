package com.milpaginas.controller;

import com.milpaginas.dao.OrderDAO;
import com.milpaginas.dao.CartDAO;
import com.milpaginas.dao.BookDAO;
import com.milpaginas.model.Order;
import com.milpaginas.model.OrderItem;
import com.milpaginas.model.CartItem;
import com.milpaginas.model.Book;
import com.milpaginas.util.DatabaseConnectionPool;
import com.milpaginas.util.ValidationUtil;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.math.BigDecimal;
import java.sql.Connection;
import java.sql.SQLException;
import java.util.List;

public class OrderServlet extends HttpServlet {
    
    private OrderDAO orderDAO = new OrderDAO();
    private CartDAO cartDAO = new CartDAO();
    private BookDAO bookDAO = new BookDAO();
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        if (!isLoggedIn(request)) {
            response.sendRedirect("login?redirect=orders");
            return;
        }
        
        String action = request.getParameter("action");
        if (action == null) action = "list";
        
        try {
            switch (action) {
                case "list":
                    listOrders(request, response);
                    break;
                case "view":
                    viewOrder(request, response);
                    break;
                case "checkout":
                    showCheckout(request, response);
                    break;
                case "admin":
                    adminListOrders(request, response);
                    break;
                case "updateStatus":
                    updateOrderStatus(request, response);
                    break;
                default:
                    listOrders(request, response);
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
            response.sendRedirect("login");
            return;
        }
        
        String action = request.getParameter("action");
        if (action == null) {
            response.sendRedirect("orders");
            return;
        }
        
        try {
            switch (action) {
                case "create":
                    createOrder(request, response);
                    break;
                case "updateStatus":
                    updateOrderStatus(request, response);
                    break;
                default:
                    response.sendRedirect("orders");
            }
        } catch (SQLException e) {
            e.printStackTrace();
            request.setAttribute("error", "Erro interno do servidor");
            request.getRequestDispatcher("/error.jsp").forward(request, response);
        }
    }
    
    private void listOrders(HttpServletRequest request, HttpServletResponse response) 
            throws SQLException, ServletException, IOException {
        
        int userId = getUserId(request);
        List<Order> orders = orderDAO.findByUserId(userId);
        
        request.setAttribute("orders", orders);
        request.getRequestDispatcher("/orders.jsp").forward(request, response);
    }
    
    private void viewOrder(HttpServletRequest request, HttpServletResponse response) 
            throws SQLException, ServletException, IOException {
        
        String idParam = request.getParameter("id");
        if (idParam == null) {
            response.sendRedirect("orders");
            return;
        }
        
        try {
            int orderId = Integer.parseInt(idParam);
            Order order = orderDAO.findById(orderId);
            
            if (order == null) {
                request.setAttribute("error", "Pedido não encontrado");
                request.getRequestDispatcher("/error.jsp").forward(request, response);
                return;
            }
            
            int userId = getUserId(request);
            if (!isAdmin(request) && order.getUsuarioId() != userId) {
                request.setAttribute("error", "Acesso negado");
                request.getRequestDispatcher("/error.jsp").forward(request, response);
                return;
            }
            
            request.setAttribute("order", order);
            request.getRequestDispatcher("/order-detail.jsp").forward(request, response);
            
        } catch (NumberFormatException e) {
            response.sendRedirect("orders");
        }
    }
    
    private void showCheckout(HttpServletRequest request, HttpServletResponse response) 
            throws SQLException, ServletException, IOException {
        
        int userId = getUserId(request);
        List<CartItem> cartItems = cartDAO.findByUserId(userId);
        
        if (cartItems.isEmpty()) {
            request.setAttribute("error", "Carrinho vazio");
            response.sendRedirect("cart");
            return;
        }
        
        BigDecimal total = cartItems.stream()
                .map(CartItem::getSubtotal)
                .reduce(BigDecimal.ZERO, BigDecimal::add);
        
        request.setAttribute("cartItems", cartItems);
        request.setAttribute("cartTotal", total);
        request.getRequestDispatcher("/checkout.jsp").forward(request, response);
    }
    
    private void createOrder(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        int userId = getUserId(request);
        String enderecoEntrega = ValidationUtil.validateAndSanitize(
                request.getParameter("enderecoEntrega"), "Endereço de entrega");
        String observacoes = ValidationUtil.sanitizeString(request.getParameter("observacoes"));
        
        Connection conn = null;
        try {
            conn = DatabaseConnectionPool.getConnection();
            conn.setAutoCommit(false);

            List<CartItem> cartItems = cartDAO.findByUserId(userId);
            
            if (cartItems.isEmpty()) {
                request.setAttribute("error", "Carrinho vazio");
                response.sendRedirect("cart");
                return;
            }
            
            Order order = new Order(userId, enderecoEntrega);
            order.setObservacoes(observacoes);
            
            for (CartItem cartItem : cartItems) {
                Book book = bookDAO.findById(cartItem.getLivroId(), true); // Lock for update
                if (book == null || book.getQuantidadeEstoque() < cartItem.getQuantidade()) {
                    throw new SQLException("Produto indisponível: " + 
                            (book != null ? book.getTitulo() : "Livro não encontrado"));
                }
                
                OrderItem orderItem = new OrderItem(
                        0, // será setado após salvar o pedido
                        cartItem.getLivroId(),
                        cartItem.getQuantidade(),
                        book.getPreco()
                );
                
                order.addItem(orderItem);
            }
            
            orderDAO.save(order, conn);
            
            for (CartItem cartItem : cartItems) {
                bookDAO.decreaseStock(cartItem.getLivroId(), cartItem.getQuantidade());
            }
            
            cartDAO.clearCart(userId);
            
            conn.commit();
            
            request.setAttribute("success", "Pedido realizado com sucesso!");
            response.sendRedirect("orders?action=view&id=" + order.getId());
            
        } catch (SQLException e) {
            if (conn != null) {
                try {
                    conn.rollback();
                } catch (SQLException ex) {
                    ex.printStackTrace();
                }
            }
            e.printStackTrace();
            request.setAttribute("error", "Erro ao processar pedido: " + e.getMessage());
            request.getRequestDispatcher("/checkout.jsp").forward(request, response);
        } finally {
            if (conn != null) {
                try {
                    conn.close();
                } catch (SQLException e) {
                    e.printStackTrace();
                }
            }
        }
    }
    
    private void adminListOrders(HttpServletRequest request, HttpServletResponse response) 
            throws SQLException, ServletException, IOException {
        
        if (!isAdmin(request)) {
            response.sendRedirect("orders");
            return;
        }
        
        String statusParam = request.getParameter("status");
        List<Order> orders;
        
        if (statusParam != null && !statusParam.isEmpty()) {
            try {
                Order.OrderStatus status = Order.OrderStatus.valueOf(statusParam.toUpperCase());
                orders = orderDAO.findByStatus(status);
            } catch (IllegalArgumentException e) {
                orders = orderDAO.findAll();
            }
        } else {
            orders = orderDAO.findAll();
        }
        
        request.setAttribute("orders", orders);
        request.setAttribute("selectedStatus", statusParam);
        request.getRequestDispatcher("/admin/orders.jsp").forward(request, response);
    }
    
    private void updateOrderStatus(HttpServletRequest request, HttpServletResponse response) 
            throws SQLException, IOException {
        
        if (!isAdmin(request)) {
            response.sendRedirect("orders");
            return;
        }
        
        String orderIdStr = request.getParameter("orderId");
        String newStatusStr = request.getParameter("newStatus");
        
        if (orderIdStr == null || newStatusStr == null) {
            response.sendRedirect("orders?action=admin");
            return;
        }
        
        try {
            int orderId = Integer.parseInt(orderIdStr);
            Order.OrderStatus newStatus = Order.OrderStatus.valueOf(newStatusStr.toUpperCase());
            
            orderDAO.updateStatus(orderId, newStatus);
            response.sendRedirect("orders?action=admin");
            
        } catch (IllegalArgumentException e) {
            response.sendRedirect("orders?action=admin");
        }
    }
    
    private boolean isLoggedIn(HttpServletRequest request) {
        HttpSession session = request.getSession(false);
        return session != null && session.getAttribute("userId") != null;
    }
    
    private boolean isAdmin(HttpServletRequest request) {
        HttpSession session = request.getSession(false);
        if (session == null) return false;
        
        Boolean isAdmin = (Boolean) session.getAttribute("isAdmin");
        return isAdmin != null && isAdmin;
    }
    
    private int getUserId(HttpServletRequest request) {
        HttpSession session = request.getSession();
        Integer userId = (Integer) session.getAttribute("userId");
        return userId != null ? userId : 0;
    }
}