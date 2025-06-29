package com.milpaginas.model;

import java.time.LocalDateTime;

public class User {
    private int id;
    private String nome;
    private String email;
    private String senha;
    private String endereco;
    private String telefone;
    private UserType tipoUsuario;
    private LocalDateTime dataCadastro;
    private boolean ativo;
    
    public enum UserType {
        CLIENTE, ADMINISTRADOR
    }
    
    public User() {
        this.tipoUsuario = UserType.CLIENTE;
        this.ativo = true;
        this.dataCadastro = LocalDateTime.now();
    }
    
    public User(String nome, String email, String senha) {
        this();
        this.nome = nome;
        this.email = email;
        this.senha = senha;
    }
    
    public int getId() {
        return id;
    }
    
    public void setId(int id) {
        this.id = id;
    }
    
    public String getNome() {
        return nome;
    }
    
    public void setNome(String nome) {
        this.nome = nome;
    }
    
    public String getEmail() {
        return email;
    }
    
    public void setEmail(String email) {
        this.email = email;
    }
    
    public String getSenha() {
        return senha;
    }
    
    public void setSenha(String senha) {
        this.senha = senha;
    }
    
    public String getEndereco() {
        return endereco;
    }
    
    public void setEndereco(String endereco) {
        this.endereco = endereco;
    }
    
    public String getTelefone() {
        return telefone;
    }
    
    public void setTelefone(String telefone) {
        this.telefone = telefone;
    }
    
    public UserType getTipoUsuario() {
        return tipoUsuario;
    }
    
    public void setTipoUsuario(UserType tipoUsuario) {
        this.tipoUsuario = tipoUsuario;
    }
    
    public LocalDateTime getDataCadastro() {
        return dataCadastro;
    }
    
    public void setDataCadastro(LocalDateTime dataCadastro) {
        this.dataCadastro = dataCadastro;
    }
    
    public boolean isAtivo() {
        return ativo;
    }
    
    public void setAtivo(boolean ativo) {
        this.ativo = ativo;
    }
    
    public boolean isAdmin() {
        return this.tipoUsuario == UserType.ADMINISTRADOR;
    }
    
    @Override
    public String toString() {
        return "User{" +
                "id=" + id +
                ", nome='" + nome + '\'' +
                ", email='" + email + '\'' +
                ", tipoUsuario=" + tipoUsuario +
                ", ativo=" + ativo +
                '}';
    }
}