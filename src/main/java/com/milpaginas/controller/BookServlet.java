package com.milpaginas.controller;

import com.milpaginas.dao.BookDAO;
import com.milpaginas.model.Book;
import com.milpaginas.model.User;
import com.milpaginas.util.ValidationUtil;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.math.BigDecimal;
import java.sql.SQLException;
import java.util.List;

public class BookServlet extends HttpServlet {
    
    private BookDAO bookDAO = new BookDAO();
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        String action = request.getParameter("action");
        if (action == null) action = "list";
        
        try {
            switch (action) {
                case "list":
                    listBooks(request, response);
                    break;
                case "search":
                    searchBooks(request, response);
                    break;
                case "view":
                    viewBook(request, response);
                    break;
                case "add":
                    showAddForm(request, response);
                    break;
                case "edit":
                    showEditForm(request, response);
                    break;
                case "delete":
                    deleteBook(request, response);
                    break;
                default:
                    listBooks(request, response);
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
        
        String action = request.getParameter("action");
        if (action == null) {
            response.sendRedirect("books");
            return;
        }
        
        try {
            switch (action) {
                case "add":
                    addBook(request, response);
                    break;
                case "edit":
                    editBook(request, response);
                    break;
                default:
                    response.sendRedirect("books");
            }
        } catch (SQLException e) {
            e.printStackTrace();
            request.setAttribute("error", "Erro interno do servidor");
            request.getRequestDispatcher("/error.jsp").forward(request, response);
        }
    }
    
    private void listBooks(HttpServletRequest request, HttpServletResponse response) 
            throws SQLException, ServletException, IOException {
        
        String pageParam = request.getParameter("page");
        int page = 1;
        int itemsPerPage = 12;
        
        if (pageParam != null) {
            try {
                page = Integer.parseInt(pageParam);
                if (page < 1) page = 1;
            } catch (NumberFormatException e) {
                page = 1;
            }
        }
        
        int offset = (page - 1) * itemsPerPage;
        List<Book> books = bookDAO.findWithPagination(offset, itemsPerPage);
        long totalBooks = bookDAO.count();
        int totalPages = (int) Math.ceil((double) totalBooks / itemsPerPage);
        
        request.setAttribute("books", books);
        request.setAttribute("currentPage", page);
        request.setAttribute("totalPages", totalPages);
        request.setAttribute("totalBooks", totalBooks);
        
        request.getRequestDispatcher("/books.jsp").forward(request, response);
    }
    
    private void searchBooks(HttpServletRequest request, HttpServletResponse response) 
            throws SQLException, ServletException, IOException {
        
        String searchTerm = request.getParameter("q");
        String searchType = request.getParameter("type");
        
        List<Book> books;
        
        if (!ValidationUtil.isNotEmpty(searchTerm)) {
            books = bookDAO.findAll();
        } else {
            searchTerm = ValidationUtil.sanitizeString(searchTerm);
            
            if ("author".equals(searchType)) {
                books = bookDAO.findByAuthor(searchTerm);
            } else if ("publisher".equals(searchType)) {
                books = bookDAO.findByPublisher(searchTerm);
            } else if ("title".equals(searchType)) {
                books = bookDAO.findByTitle(searchTerm);
            } else {
                books = bookDAO.search(searchTerm);
            }
        }
        
        request.setAttribute("books", books);
        request.setAttribute("searchTerm", searchTerm);
        request.setAttribute("searchType", searchType);
        request.getRequestDispatcher("/books.jsp").forward(request, response);
    }
    
    private void viewBook(HttpServletRequest request, HttpServletResponse response) 
            throws SQLException, ServletException, IOException {
        
        String idParam = request.getParameter("id");
        if (idParam == null) {
            response.sendRedirect("books");
            return;
        }
        
        try {
            int id = Integer.parseInt(idParam);
            Book book = bookDAO.findById(id);
            
            if (book == null) {
                request.setAttribute("error", "Livro não encontrado");
                request.getRequestDispatcher("/error.jsp").forward(request, response);
                return;
            }
            
            request.setAttribute("book", book);
            request.getRequestDispatcher("/book-detail.jsp").forward(request, response);
            
        } catch (NumberFormatException e) {
            response.sendRedirect("books");
        }
    }
    
    private void showAddForm(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        if (!isAdmin(request)) {
            response.sendRedirect("books");
            return;
        }
        
        request.getRequestDispatcher("/admin/book-form.jsp").forward(request, response);
    }
    
    private void showEditForm(HttpServletRequest request, HttpServletResponse response) 
            throws SQLException, ServletException, IOException {
        
        if (!isAdmin(request)) {
            response.sendRedirect("books");
            return;
        }
        
        String idParam = request.getParameter("id");
        if (idParam == null) {
            response.sendRedirect("books");
            return;
        }
        
        try {
            int id = Integer.parseInt(idParam);
            Book book = bookDAO.findById(id);
            
            if (book == null) {
                request.setAttribute("error", "Livro não encontrado");
                request.getRequestDispatcher("/error.jsp").forward(request, response);
                return;
            }
            
            request.setAttribute("book", book);
            request.setAttribute("isEdit", true);
            request.getRequestDispatcher("/admin/book-form.jsp").forward(request, response);
            
        } catch (NumberFormatException e) {
            response.sendRedirect("books");
        }
    }
    
    private void addBook(HttpServletRequest request, HttpServletResponse response) 
            throws SQLException, ServletException, IOException {
        
        if (!isAdmin(request)) {
            response.sendRedirect("books");
            return;
        }
        
        try {
            Book book = createBookFromRequest(request);
            bookDAO.save(book);
            
            request.setAttribute("success", "Livro adicionado com sucesso!");
            response.sendRedirect("books");
            
        } catch (IllegalArgumentException e) {
            request.setAttribute("error", e.getMessage());
            request.getRequestDispatcher("/admin/book-form.jsp").forward(request, response);
        }
    }
    
    private void editBook(HttpServletRequest request, HttpServletResponse response) 
            throws SQLException, ServletException, IOException {
        
        if (!isAdmin(request)) {
            response.sendRedirect("books");
            return;
        }
        
        String idParam = request.getParameter("id");
        if (idParam == null) {
            response.sendRedirect("books");
            return;
        }
        
        try {
            int id = Integer.parseInt(idParam);
            Book book = createBookFromRequest(request);
            book.setId(id);
            
            bookDAO.update(book);
            
            request.setAttribute("success", "Livro atualizado com sucesso!");
            response.sendRedirect("books?action=view&id=" + id);
            
        } catch (NumberFormatException e) {
            response.sendRedirect("books");
        } catch (IllegalArgumentException e) {
            request.setAttribute("error", e.getMessage());
            request.setAttribute("book", createBookFromRequest(request));
            request.setAttribute("isEdit", true);
            request.getRequestDispatcher("/admin/book-form.jsp").forward(request, response);
        }
    }
    
    private void deleteBook(HttpServletRequest request, HttpServletResponse response) 
            throws SQLException, IOException {
        
        if (!isAdmin(request)) {
            response.sendRedirect("books");
            return;
        }
        
        String idParam = request.getParameter("id");
        if (idParam == null) {
            response.sendRedirect("books");
            return;
        }
        
        try {
            int id = Integer.parseInt(idParam);
            bookDAO.delete(id);
            response.sendRedirect("books");
        } catch (NumberFormatException e) {
            response.sendRedirect("books");
        }
    }
    
    private Book createBookFromRequest(HttpServletRequest request) {
        String titulo = ValidationUtil.validateAndSanitize(request.getParameter("titulo"), "Título");
        String autor = ValidationUtil.validateAndSanitize(request.getParameter("autor"), "Autor");
        String precoStr = request.getParameter("preco");
        String quantidadeStr = request.getParameter("quantidade");
        
        if (!ValidationUtil.isNotEmpty(precoStr)) {
            throw new IllegalArgumentException("Preço é obrigatório");
        }
        
        if (!ValidationUtil.isNotEmpty(quantidadeStr)) {
            throw new IllegalArgumentException("Quantidade é obrigatória");
        }
        
        BigDecimal preco;
        int quantidade;
        
        try {
            preco = new BigDecimal(precoStr);
            if (!ValidationUtil.isPositiveNumber(preco)) {
                throw new IllegalArgumentException("Preço deve ser positivo");
            }
        } catch (NumberFormatException e) {
            throw new IllegalArgumentException("Preço inválido");
        }
        
        try {
            quantidade = Integer.parseInt(quantidadeStr);
            if (!ValidationUtil.isNonNegativeInteger(quantidade)) {
                throw new IllegalArgumentException("Quantidade deve ser não negativa");
            }
        } catch (NumberFormatException e) {
            throw new IllegalArgumentException("Quantidade inválida");
        }
        
        Book book = new Book();
        book.setTitulo(titulo);
        book.setAutor(autor);
        book.setPreco(preco);
        book.setQuantidadeEstoque(quantidade);
        
        String isbn = request.getParameter("isbn");
        if (ValidationUtil.isNotEmpty(isbn)) {
            if (!ValidationUtil.isValidISBN(isbn)) {
                throw new IllegalArgumentException("ISBN inválido");
            }
            book.setIsbn(ValidationUtil.sanitizeString(isbn));
        }
        
        String editora = request.getParameter("editora");
        if (ValidationUtil.isNotEmpty(editora)) {
            book.setEditora(ValidationUtil.sanitizeString(editora));
        }
        
        String anoStr = request.getParameter("anoPublicacao");
        if (ValidationUtil.isNotEmpty(anoStr)) {
            try {
                Integer ano = Integer.parseInt(anoStr);
                if (!ValidationUtil.isValidYear(ano)) {
                    throw new IllegalArgumentException("Ano de publicação inválido");
                }
                book.setAnoPublicacao(ano);
            } catch (NumberFormatException e) {
                throw new IllegalArgumentException("Ano de publicação inválido");
            }
        }
        
        String urlCapa = request.getParameter("urlCapa");
        if (ValidationUtil.isNotEmpty(urlCapa)) {
            book.setUrlCapa(ValidationUtil.sanitizeString(urlCapa));
        }
        
        String descricao = request.getParameter("descricao");
        if (ValidationUtil.isNotEmpty(descricao)) {
            book.setDescricao(ValidationUtil.sanitizeString(descricao));
        }
        
        return book;
    }
    
    private boolean isAdmin(HttpServletRequest request) {
        HttpSession session = request.getSession(false);
        if (session == null) return false;
        
        Boolean isAdmin = (Boolean) session.getAttribute("isAdmin");
        return isAdmin != null && isAdmin;
    }
}