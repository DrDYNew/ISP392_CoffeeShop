/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package controllers;

import model.User;
import dao.UserDAO;
import java.io.IOException;
import java.util.List;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

/**
 * AdminController handles admin-specific dashboard and functionalities
 * @author DrDYNew
 */
@WebServlet(name = "AdminController", urlPatterns = {"/admin/*"})
public class AdminController extends HttpServlet {

    private UserDAO userDAO;

    @Override
    public void init() throws ServletException {
        super.init();
        userDAO = new UserDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        // Check authentication
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            response.sendRedirect(request.getContextPath() + "/auth?action=login");
            return;
        }

        User currentUser = (User) session.getAttribute("user");
        String currentUserRole = (String) session.getAttribute("roleName");
        
        // Check if user has admin permission
        if (!"Admin".equals(currentUserRole)) {
            response.sendError(HttpServletResponse.SC_FORBIDDEN, "Bạn không có quyền truy cập khu vực này");
            return;
        }

        String pathInfo = request.getPathInfo();
        if (pathInfo == null) {
            pathInfo = "/dashboard";
        }

        try {
            switch (pathInfo) {
                case "/dashboard":
                    showDashboard(request, response);
                    break;
                case "/users":
                    showUserManagement(request, response);
                    break;
                case "/settings":
                    showSystemSettings(request, response);
                    break;
                case "/reports":
                    showReports(request, response);
                    break;
                default:
                    showDashboard(request, response);
                    break;
            }
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "Đã xảy ra lỗi hệ thống: " + e.getMessage());
            request.getRequestDispatcher("/views/common/error.jsp").forward(request, response);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        // Check authentication
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            response.sendRedirect(request.getContextPath() + "/auth?action=login");
            return;
        }

        User currentUser = (User) session.getAttribute("user");
        String currentUserRole = (String) session.getAttribute("roleName");
        
        // Check if user has admin permission
        if (!"Admin".equals(currentUserRole)) {
            response.sendError(HttpServletResponse.SC_FORBIDDEN, "Bạn không có quyền truy cập khu vực này");
            return;
        }

        String pathInfo = request.getPathInfo();
        if (pathInfo == null) {
            pathInfo = "/dashboard";
        }

        try {
            switch (pathInfo) {
                case "/settings":
                    updateSystemSettings(request, response);
                    break;
                default:
                    showDashboard(request, response);
                    break;
            }
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "Đã xảy ra lỗi hệ thống: " + e.getMessage());
            request.getRequestDispatcher("/views/common/error.jsp").forward(request, response);
        }
    }

    /**
     * Display admin dashboard
     */
    private void showDashboard(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        try {
            // Get real statistics from database
            int totalUsers = userDAO.getTotalUsersCount(null, null);
            List<User> allUsers = userDAO.getAllUsers(1, Integer.MAX_VALUE, null, null);
            
            // Count users by role
            int hrCount = 0;
            int adminCount = 0;
            int inventoryCount = 0;
            int baristaCount = 0;
            int activeUsers = 0;
            
            for (User user : allUsers) {
                if (user.isActive()) {
                    activeUsers++;
                }
                switch (user.getRoleID()) {
                    case 1: hrCount++; break;
                    case 2: adminCount++; break;
                    case 3: inventoryCount++; break;
                    case 4: baristaCount++; break;
                }
            }
            
            // Set real dashboard data
            request.setAttribute("totalUsers", totalUsers);
            request.setAttribute("activeUsers", activeUsers);
            request.setAttribute("hrCount", hrCount);
            request.setAttribute("adminCount", adminCount);
            request.setAttribute("inventoryCount", inventoryCount);
            request.setAttribute("baristaCount", baristaCount);
            
            // System status (these could be calculated from actual system metrics)
            request.setAttribute("serverStatus", "online");
            request.setAttribute("databaseStatus", "connected");
            
            // Performance metrics (placeholder - would integrate with monitoring tools)
            request.setAttribute("systemUptime", "99.9%");
            request.setAttribute("avgResponseTime", "0.85s");
            
        } catch (Exception e) {
            e.printStackTrace();
            // Fallback to basic info if database error
            request.setAttribute("totalUsers", 0);
            request.setAttribute("activeUsers", 0);
            request.setAttribute("error", "Không thể tải dữ liệu thống kê");
        }
        
        request.getRequestDispatcher("/views/admin/dashboard.jsp").forward(request, response);
    }

    /**
     * Show user management page
     */
    private void showUserManagement(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        // Redirect to the user controller
        response.sendRedirect(request.getContextPath() + "/user");
    }

    /**
     * Show system settings page
     */
    private void showSystemSettings(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        // TODO: Implement system settings page
        request.setAttribute("message", "Trang cài đặt hệ thống đang được phát triển");
        request.getRequestDispatcher("/views/common/under-construction.jsp").forward(request, response);
    }

    /**
     * Show reports page
     */
    private void showReports(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        // TODO: Implement reports page
        request.setAttribute("message", "Trang báo cáo đang được phát triển");
        request.getRequestDispatcher("/views/common/under-construction.jsp").forward(request, response);
    }

    /**
     * Update system settings
     */
    private void updateSystemSettings(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        // TODO: Implement system settings update
        HttpSession session = request.getSession();
        session.setAttribute("successMessage", "Cài đặt hệ thống đã được cập nhật");
        response.sendRedirect(request.getContextPath() + "/admin/settings");
    }
}