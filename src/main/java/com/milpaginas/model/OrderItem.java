package com.milpaginas.model;

import java.math.BigDecimal;

public class OrderItem {
    private int id;
    private int pedidoId;
    private int livroId;
    private Book livro;
    private int quantidade;
    private BigDecimal precoUnitario;
    private BigDecimal subtotal;
    
    public OrderItem() {
        this.quantidade = 1;
    }
    
    public OrderItem(int pedidoId, int livroId, int quantidade, BigDecimal precoUnitario) {
        this();
        this.pedidoId = pedidoId;
        this.livroId = livroId;
        this.quantidade = quantidade;
        this.precoUnitario = precoUnitario;
        this.subtotal = precoUnitario.multiply(BigDecimal.valueOf(quantidade));
    }
    
    public int getId() {
        return id;
    }
    
    public void setId(int id) {
        this.id = id;
    }
    
    public int getPedidoId() {
        return pedidoId;
    }
    
    public void setPedidoId(int pedidoId) {
        this.pedidoId = pedidoId;
    }
    
    public int getLivroId() {
        return livroId;
    }
    
    public void setLivroId(int livroId) {
        this.livroId = livroId;
    }
    
    public Book getLivro() {
        return livro;
    }
    
    public void setLivro(Book livro) {
        this.livro = livro;
    }
    
    public int getQuantidade() {
        return quantidade;
    }
    
    public void setQuantidade(int quantidade) {
        this.quantidade = quantidade;
        if (precoUnitario != null) {
            this.subtotal = precoUnitario.multiply(BigDecimal.valueOf(quantidade));
        }
    }
    
    public BigDecimal getPrecoUnitario() {
        return precoUnitario;
    }
    
    public void setPrecoUnitario(BigDecimal precoUnitario) {
        this.precoUnitario = precoUnitario;
        this.subtotal = precoUnitario.multiply(BigDecimal.valueOf(quantidade));
    }
    
    public BigDecimal getSubtotal() {
        return subtotal;
    }
    
    public void setSubtotal(BigDecimal subtotal) {
        this.subtotal = subtotal;
    }
    
    @Override
    public String toString() {
        return "OrderItem{" +
                "id=" + id +
                ", pedidoId=" + pedidoId +
                ", livroId=" + livroId +
                ", quantidade=" + quantidade +
                ", precoUnitario=" + precoUnitario +
                ", subtotal=" + subtotal +
                '}';
    }
}