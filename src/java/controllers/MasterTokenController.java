package controllers;

import dao.SystemConfigDAO;
import model.User;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;

/**
 * Controller cho Admin quản lý Master API Token
 */
@WebServlet(name = "MasterTokenController", urlPatterns = {"/admin/master-token"})
public class MasterTokenController extends HttpServlet {

    private final SystemConfigDAO configDAO = new SystemConfigDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");
        
        // Check if user is Admin (RoleID = 2)
        if (user == null || user.getRoleID() != 2) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        // Lấy Master Token hiện tại
        String masterToken = configDAO.getConfigValue("MASTER_API_TOKEN");
        request.setAttribute("masterToken", masterToken);
        
        request.getRequestDispatcher("/views/admin/master-token.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");
        
        if (user == null || user.getRoleID() != 2) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        String action = request.getParameter("action");

        if ("regenerate".equals(action)) {
            try {
                String newToken = configDAO.regenerateMasterToken();
                request.setAttribute("success", "Master Token đã được tạo mới thành công!");
                request.setAttribute("masterToken", newToken);
            } catch (Exception e) {
                request.setAttribute("error", "Lỗi khi tạo mới Master Token: " + e.getMessage());
                String currentToken = configDAO.getConfigValue("MASTER_API_TOKEN");
                request.setAttribute("masterToken", currentToken);
            }
        }
        
        request.getRequestDispatcher("/views/admin/master-token.jsp").forward(request, response);
    }
}
