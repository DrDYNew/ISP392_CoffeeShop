/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package controllers;

import models.User;
import models.Setting;
import services.UserService;
import java.io.IOException;
import java.util.List;
import java.util.ArrayList;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

/**
 *
 * @author DrDYNew
 */
@WebServlet(name = "UserController", urlPatterns = {"/user"})
public class UserController extends HttpServlet {
    
    private UserService userService;
    
    @Override
    public void init() throws ServletException {
        super.init();
        userService = new UserService();
    }
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        // Check authentication and authorization
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            response.sendRedirect(request.getContextPath() + "/auth?action=login");
            return;
        }
        
        User currentUser = (User) session.getAttribute("user");
        String currentUserRole = (String) session.getAttribute("roleName");
        
        // Check if user has permission to access user management
        if (!"HR".equals(currentUserRole) && !"Admin".equals(currentUserRole)) {
            response.sendError(HttpServletResponse.SC_FORBIDDEN, "Bạn không có quyền truy cập chức năng này");
            return;
        }
        
        String action = request.getParameter("action");
        if (action == null) {
            action = "list";
        }
        
        try {
            switch (action) {
                case "list":
                    listUsers(request, response, currentUserRole);
                    break;
                case "create":
                    showCreateForm(request, response, currentUserRole);
                    break;
                case "edit":
                    showEditForm(request, response, currentUserRole);
                    break;
                case "view":
                    viewUser(request, response);
                    break;
                case "changePassword":
                    showChangePasswordForm(request, response);
                    break;
                default:
                    listUsers(request, response, currentUserRole);
                    break;
            }
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "Lỗi hệ thống: " + e.getMessage());
            request.getRequestDispatcher("/views/common/error.jsp").forward(request, response);
        }
    }
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        // Check authentication and authorization
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            response.sendRedirect(request.getContextPath() + "/auth?action=login");
            return;
        }
        
        User currentUser = (User) session.getAttribute("user");
        String currentUserRole = (String) session.getAttribute("roleName");
        
        // Check if user has permission to access user management
        if (!"HR".equals(currentUserRole) && !"Admin".equals(currentUserRole)) {
            response.sendError(HttpServletResponse.SC_FORBIDDEN, "Bạn không có quyền truy cập chức năng này");
            return;
        }
        
        String action = request.getParameter("action");
        
        try {
            switch (action) {
                case "create":
                    createUser(request, response, currentUserRole);
                    break;
                case "update":
                    updateUser(request, response, currentUserRole);
                    break;
                case "delete":
                    deleteUser(request, response, currentUserRole);
                    break;
                case "changePassword":
                    changePassword(request, response);
                    break;
                default:
                    response.sendRedirect(request.getContextPath() + "/user");
                    break;
            }
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "Lỗi hệ thống: " + e.getMessage());
            request.getRequestDispatcher("/views/common/error.jsp").forward(request, response);
        }
    }
    
    private void listUsers(HttpServletRequest request, HttpServletResponse response, String currentUserRole)
            throws ServletException, IOException {
        
        // Get pagination parameters
        int page = 1;
        int pageSize = 10;
        
        String pageParam = request.getParameter("page");
        if (pageParam != null && !pageParam.isEmpty()) {
            try {
                page = Integer.parseInt(pageParam);
                if (page < 1) page = 1;
            } catch (NumberFormatException e) {
                page = 1;
            }
        }
        
        String pageSizeParam = request.getParameter("pageSize");
        if (pageSizeParam != null && !pageSizeParam.isEmpty()) {
            try {
                pageSize = Integer.parseInt(pageSizeParam);
                if (pageSize < 5) pageSize = 5;
                if (pageSize > 50) pageSize = 50;
            } catch (NumberFormatException e) {
                pageSize = 10;
            }
        }
        
        // Get filter parameters
        Integer roleFilter = null;
        String roleFilterParam = request.getParameter("roleFilter");
        if (roleFilterParam != null && !roleFilterParam.isEmpty() && !"all".equals(roleFilterParam)) {
            try {
                roleFilter = Integer.parseInt(roleFilterParam);
            } catch (NumberFormatException e) {
                // Ignore invalid role filter
            }
        }
        
        String searchKeyword = request.getParameter("search");
        if (searchKeyword != null && searchKeyword.trim().isEmpty()) {
            searchKeyword = null;
        }
        
        // Get users and pagination info
        List<User> users = userService.getUsers(page, pageSize, roleFilter, searchKeyword);
        int totalUsers = userService.getTotalUsersCount(roleFilter, searchKeyword);
        
        // Filter out Admin users for HR
        if ("HR".equals(currentUserRole)) {
            users = users.stream()
                    .filter(user -> user.getRoleID() != 2) // Exclude Admin (roleID = 2)
                    .collect(java.util.stream.Collectors.toList());
        }
        int totalPages = (int) Math.ceil((double) totalUsers / pageSize);
        
        // Get available roles for filtering
        List<Setting> availableRoles = userService.getAvailableRoles(currentUserRole);
        
        // Set attributes
        request.setAttribute("users", users);
        request.setAttribute("currentPage", page);
        request.setAttribute("pageSize", pageSize);
        request.setAttribute("totalPages", totalPages);
        request.setAttribute("totalUsers", totalUsers);
        request.setAttribute("roleFilter", roleFilter);
        request.setAttribute("searchKeyword", searchKeyword);
        request.setAttribute("availableRoles", availableRoles);
        request.setAttribute("currentUserRole", currentUserRole);
        
        // Forward to JSP
        request.getRequestDispatcher("/views/hr/user-list.jsp").forward(request, response);
    }
    
    private void showCreateForm(HttpServletRequest request, HttpServletResponse response, String currentUserRole)
            throws ServletException, IOException {
        
        // Get available roles for current user
        List<Setting> availableRoles = userService.getAvailableRoles(currentUserRole);
        
        request.setAttribute("availableRoles", availableRoles);
        request.setAttribute("action", "create");
        
        request.getRequestDispatcher("/views/hr/user-form.jsp").forward(request, response);
    }
    
    private void showEditForm(HttpServletRequest request, HttpServletResponse response, String currentUserRole)
            throws ServletException, IOException {
        
        String userIdParam = request.getParameter("id");
        if (userIdParam == null || userIdParam.isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/user");
            return;
        }
        
        try {
            int userId = Integer.parseInt(userIdParam);
            User user = userService.getUserById(userId);
            
            if (user == null) {
                request.setAttribute("error", "Không tìm thấy người dùng");
                request.getRequestDispatcher("/views/common/error.jsp").forward(request, response);
                return;
            }
            
            // Get available roles for current user
            List<Setting> availableRoles = userService.getAvailableRoles(currentUserRole);
            
            request.setAttribute("user", user);
            request.setAttribute("availableRoles", availableRoles);
            request.setAttribute("action", "edit");
            
            request.getRequestDispatcher("/views/hr/user-form.jsp").forward(request, response);
            
        } catch (NumberFormatException e) {
            response.sendRedirect(request.getContextPath() + "/user");
        }
    }
    
    private void viewUser(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        String userIdParam = request.getParameter("id");
        if (userIdParam == null || userIdParam.isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/user");
            return;
        }
        
        try {
            int userId = Integer.parseInt(userIdParam);
            User user = userService.getUserById(userId);
            
            if (user == null) {
                request.setAttribute("error", "Không tìm thấy người dùng");
                request.getRequestDispatcher("/views/common/error.jsp").forward(request, response);
                return;
            }
            
            request.setAttribute("user", user);
            request.getRequestDispatcher("/views/hr/user-view.jsp").forward(request, response);
            
        } catch (NumberFormatException e) {
            response.sendRedirect(request.getContextPath() + "/user");
        }
    }
    
    private void showChangePasswordForm(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        String userIdParam = request.getParameter("id");
        if (userIdParam == null || userIdParam.isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/user");
            return;
        }
        
        try {
            int userId = Integer.parseInt(userIdParam);
            User user = userService.getUserById(userId);
            
            if (user == null) {
                request.setAttribute("error", "Không tìm thấy người dùng");
                request.getRequestDispatcher("/views/common/error.jsp").forward(request, response);
                return;
            }
            
            request.setAttribute("user", user);
            request.getRequestDispatcher("/views/hr/change-password.jsp").forward(request, response);
            
        } catch (NumberFormatException e) {
            response.sendRedirect(request.getContextPath() + "/user");
        }
    }
    
    private void createUser(HttpServletRequest request, HttpServletResponse response, String currentUserRole)
            throws ServletException, IOException {
        
        // Get form data
        String fullName = request.getParameter("fullName");
        String email = request.getParameter("email");
        String password = request.getParameter("password");
        String phone = request.getParameter("phone");
        String address = request.getParameter("address");
        String roleIdParam = request.getParameter("roleId");
        
        try {
            int roleId = Integer.parseInt(roleIdParam);
            
            // Create user object
            User user = new User();
            user.setFullName(fullName);
            user.setEmail(email);
            user.setPhone(phone);
            user.setAddress(address);
            user.setRoleID(roleId);
            
            // Create user
            String error = userService.createUser(user, password, currentUserRole);
            
            if (error == null) {
                // Success
                request.getSession().setAttribute("successMessage", "Tạo tài khoản thành công");
                response.sendRedirect(request.getContextPath() + "/user");
            } else {
                // Error
                List<Setting> availableRoles = userService.getAvailableRoles(currentUserRole);
                request.setAttribute("user", user);
                request.setAttribute("availableRoles", availableRoles);
                request.setAttribute("action", "create");
                request.setAttribute("error", error);
                
                request.getRequestDispatcher("/views/hr/user-form.jsp").forward(request, response);
            }
            
        } catch (NumberFormatException e) {
            List<Setting> availableRoles = userService.getAvailableRoles(currentUserRole);
            request.setAttribute("availableRoles", availableRoles);
            request.setAttribute("action", "create");
            request.setAttribute("error", "Vui lòng chọn vai trò hợp lệ");
            
            request.getRequestDispatcher("/views/hr/user-form.jsp").forward(request, response);
        }
    }
    
    private void updateUser(HttpServletRequest request, HttpServletResponse response, String currentUserRole)
            throws ServletException, IOException {
        
        String userIdParam = request.getParameter("userId");
        String fullName = request.getParameter("fullName");
        String email = request.getParameter("email");
        String phone = request.getParameter("phone");
        String address = request.getParameter("address");
        String roleIdParam = request.getParameter("roleId");
        String isActiveParam = request.getParameter("isActive");
        
        try {
            int userId = Integer.parseInt(userIdParam);
            int roleId = Integer.parseInt(roleIdParam);
            boolean isActive = "on".equals(isActiveParam);
            
            // Create user object
            User user = new User();
            user.setUserID(userId);
            user.setFullName(fullName);
            user.setEmail(email);
            user.setPhone(phone);
            user.setAddress(address);
            user.setRoleID(roleId);
            user.setActive(isActive);
            
            // Update user
            String error = userService.updateUser(user, currentUserRole);
            
            if (error == null) {
                // Success
                request.getSession().setAttribute("successMessage", "Cập nhật thông tin thành công");
                response.sendRedirect(request.getContextPath() + "/user");
            } else {
                // Error
                List<Setting> availableRoles = userService.getAvailableRoles(currentUserRole);
                request.setAttribute("user", user);
                request.setAttribute("availableRoles", availableRoles);
                request.setAttribute("action", "edit");
                request.setAttribute("error", error);
                
                request.getRequestDispatcher("/views/hr/user-form.jsp").forward(request, response);
            }
            
        } catch (NumberFormatException e) {
            response.sendRedirect(request.getContextPath() + "/user");
        }
    }
    
    private void deleteUser(HttpServletRequest request, HttpServletResponse response, String currentUserRole)
            throws ServletException, IOException {
        
        String userIdParam = request.getParameter("userId");
        
        try {
            int userId = Integer.parseInt(userIdParam);
            
            String error = userService.deleteUser(userId, currentUserRole);
            
            if (error == null) {
                request.getSession().setAttribute("successMessage", "Xóa tài khoản thành công");
            } else {
                request.getSession().setAttribute("errorMessage", error);
            }
            
        } catch (NumberFormatException e) {
            request.getSession().setAttribute("errorMessage", "ID người dùng không hợp lệ");
        }
        
        response.sendRedirect(request.getContextPath() + "/user");
    }
    
    private void changePassword(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        String userIdParam = request.getParameter("userId");
        String newPassword = request.getParameter("newPassword");
        String confirmPassword = request.getParameter("confirmPassword");
        
        try {
            int userId = Integer.parseInt(userIdParam);
            
            // Check if passwords match
            if (!newPassword.equals(confirmPassword)) {
                User user = userService.getUserById(userId);
                request.setAttribute("user", user);
                request.setAttribute("error", "Mật khẩu xác nhận không khớp");
                request.getRequestDispatcher("/views/hr/change-password.jsp").forward(request, response);
                return;
            }
            
            String error = userService.changePassword(userId, newPassword);
            
            if (error == null) {
                request.getSession().setAttribute("successMessage", "Đổi mật khẩu thành công");
                response.sendRedirect(request.getContextPath() + "/user");
            } else {
                User user = userService.getUserById(userId);
                request.setAttribute("user", user);
                request.setAttribute("error", error);
                request.getRequestDispatcher("/views/hr/change-password.jsp").forward(request, response);
            }
            
        } catch (NumberFormatException e) {
            response.sendRedirect(request.getContextPath() + "/user");
        }
    }
}