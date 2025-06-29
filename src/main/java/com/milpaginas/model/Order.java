package com.milpaginas.model;

import java.math.BigDecimal;
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;

public class Order {
    private int id;
    private int usuarioId;
    private User usuario;
    private LocalDateTime dataPedido;
    private OrderStatus statusPedido;
    private String enderecoEntrega;
    private BigDecimal valorTotal;
    private String observacoes;
    private List<OrderItem> itens;
    
    public enum OrderStatus {
        PENDENTE, PROCESSANDO, ENVIADO, ENTREGUE, CANCELADO
    }
    
    public Order() {
        this.dataPedido = LocalDateTime.now();
        this.statusPedido = OrderStatus.PENDENTE;
        this.itens = new ArrayList<>();
        this.valorTotal = BigDecimal.ZERO;
    }
    
    public Order(int usuarioId, String enderecoEntrega) {
        this();
        this.usuarioId = usuarioId;
        this.enderecoEntrega = enderecoEntrega;
    }
    
    public int getId() {
        return id;
    }
    
    public void setId(int id) {
        this.id = id;
    }
    
    public int getUsuarioId() {
        return usuarioId;
    }
    
    public void setUsuarioId(int usuarioId) {
        this.usuarioId = usuarioId;
    }
    
    public User getUsuario() {
        return usuario;
    }
    
    public void setUsuario(User usuario) {
        this.usuario = usuario;
    }
    
    public LocalDateTime getDataPedido() {
        return dataPedido;
    }
    
    public void setDataPedido(LocalDateTime dataPedido) {
        this.dataPedido = dataPedido;
    }
    
    public OrderStatus getStatusPedido() {
        return statusPedido;
    }
    
    public void setStatusPedido(OrderStatus statusPedido) {
        this.statusPedido = statusPedido;
    }
    
    public String getEnderecoEntrega() {
        return enderecoEntrega;
    }
    
    public void setEnderecoEntrega(String enderecoEntrega) {
        this.enderecoEntrega = enderecoEntrega;
    }
    
    public BigDecimal getValorTotal() {
        return valorTotal;
    }
    
    public void setValorTotal(BigDecimal valorTotal) {
        this.valorTotal = valorTotal;
    }
    
    public String getObservacoes() {
        return observacoes;
    }
    
    public void setObservacoes(String observacoes) {
        this.observacoes = observacoes;
    }
    
    public List<OrderItem> getItens() {
        return itens;
    }
    
    public void setItens(List<OrderItem> itens) {
        this.itens = itens;
    }
    
    public void addItem(OrderItem item) {
        this.itens.add(item);
        calcularValorTotal();
    }
    
    public void calcularValorTotal() {
        this.valorTotal = itens.stream()
                .map(OrderItem::getSubtotal)
                .reduce(BigDecimal.ZERO, BigDecimal::add);
    }
    
    public int getTotalItens() {
        return itens.stream()
                .mapToInt(OrderItem::getQuantidade)
                .sum();
    }
    
    @Override
    public String toString() {
        return "Order{" +
                "id=" + id +
                ", usuarioId=" + usuarioId +
                ", dataPedido=" + dataPedido +
                ", statusPedido=" + statusPedido +
                ", valorTotal=" + valorTotal +
                ", totalItens=" + getTotalItens() +
                '}';
    }
}