package com.milpaginas.model;

import java.math.BigDecimal;
import java.time.LocalDateTime;

public class CartItem {
    private int id;
    private int usuarioId;
    private int livroId;
    private Book livro;
    private int quantidade;
    private LocalDateTime dataAdicao;
    
    public CartItem() {
        this.quantidade = 1;
        this.dataAdicao = LocalDateTime.now();
    }
    
    public CartItem(int usuarioId, int livroId, int quantidade) {
        this();
        this.usuarioId = usuarioId;
        this.livroId = livroId;
        this.quantidade = quantidade;
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
    }
    
    public LocalDateTime getDataAdicao() {
        return dataAdicao;
    }
    
    public void setDataAdicao(LocalDateTime dataAdicao) {
        this.dataAdicao = dataAdicao;
    }
    
    public BigDecimal getSubtotal() {
        if (livro != null && livro.getPreco() != null) {
            return livro.getPreco().multiply(BigDecimal.valueOf(quantidade));
        }
        return BigDecimal.ZERO;
    }
    
    @Override
    public String toString() {
        return "CartItem{" +
                "id=" + id +
                ", usuarioId=" + usuarioId +
                ", livroId=" + livroId +
                ", quantidade=" + quantidade +
                ", subtotal=" + getSubtotal() +
                '}';
    }
}