package controller;

import dao.BookDAO;
import java.io.IOException;
import java.util.List;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import model.Book;

@WebServlet(name = "SearchServlet", urlPatterns = {"/search"})
public class SearchServlet extends HttpServlet {

    private BookDAO bookDAO;
    
    @Override
    public void init() {
        bookDAO = new BookDAO();
    }
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String searchTerm = request.getParameter("q");
        
        if (searchTerm == null || searchTerm.trim().isEmpty()) {
            response.sendRedirect("BookServlet");
            return;
        }
        
        List<Book> searchResults = bookDAO.searchBooks(searchTerm);
        request.setAttribute("bookList", searchResults);
        request.setAttribute("searchTerm", searchTerm);
        request.getRequestDispatcher("bookList.jsp").forward(request, response);
    }
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doGet(request, response);
    }
}
