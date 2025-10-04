package controllers;

import model.User;
import dao.UserDAO;
import services.UserService;
import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

/**
 * ProfileController handles user profile management
 * @author DrDYNew
 */
@WebServlet(name = "ProfileController", urlPatterns = {"/profile"})
public class ProfileController extends HttpServlet {
    
    private UserService userService;
    private UserDAO userDAO;
    
    @Override
    public void init() throws ServletException {
        super.init();
        userService = new UserService();
        userDAO = new UserDAO();
    }
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        // Check authentication
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }
        
        User currentUser = (User) session.getAttribute("user");
        String action = request.getParameter("action");
        
        try {
            if ("edit".equals(action)) {
                showEditProfile(request, response, currentUser);
            } else if ("change-password".equals(action)) {
                showChangePassword(request, response, currentUser);
            } else {
                showProfile(request, response, currentUser);
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
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }
        
        User currentUser = (User) session.getAttribute("user");
        String action = request.getParameter("action");
        
        // Set encoding for Vietnamese
        request.setCharacterEncoding("UTF-8");
        response.setCharacterEncoding("UTF-8");
        
        try {
            if ("update-profile".equals(action)) {
                handleUpdateProfile(request, response, currentUser);
            } else if ("change-password".equals(action)) {
                handleChangePassword(request, response, currentUser);
            } else {
                showProfile(request, response, currentUser);
            }
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "Đã xảy ra lỗi hệ thống: " + e.getMessage());
            showProfile(request, response, currentUser);
        }
    }
    
    /**
     * Show user profile view
     */
    private void showProfile(HttpServletRequest request, HttpServletResponse response, User user)
            throws ServletException, IOException {
        
        // Get latest user data from database
        try {
            User latestUser = userDAO.getUserById(user.getUserID());
            if (latestUser != null) {
                request.setAttribute("profileUser", latestUser);
            } else {
                request.setAttribute("profileUser", user);
            }
        } catch (Exception e) {
            request.setAttribute("profileUser", user);
            request.setAttribute("warning", "Không thể tải thông tin mới nhất từ cơ sở dữ liệu");
        }
        
        request.getRequestDispatcher("/views/common/profile-view.jsp").forward(request, response);
    }
    
    /**
     * Show edit profile form
     */
    private void showEditProfile(HttpServletRequest request, HttpServletResponse response, User user)
            throws ServletException, IOException {
        
        // Get latest user data from database
        try {
            User latestUser = userDAO.getUserById(user.getUserID());
            if (latestUser != null) {
                request.setAttribute("profileUser", latestUser);
            } else {
                request.setAttribute("profileUser", user);
            }
        } catch (Exception e) {
            request.setAttribute("profileUser", user);
            request.setAttribute("warning", "Không thể tải thông tin mới nhất từ cơ sở dữ liệu");
        }
        
        request.getRequestDispatcher("/views/common/profile-edit.jsp").forward(request, response);
    }
    
    /**
     * Show change password form
     */
    private void showChangePassword(HttpServletRequest request, HttpServletResponse response, User user)
            throws ServletException, IOException {
        
        request.setAttribute("profileUser", user);
        request.getRequestDispatcher("/views/common/profile-change-password.jsp").forward(request, response);
    }
    
    /**
     * Handle profile update
     */
    private void handleUpdateProfile(HttpServletRequest request, HttpServletResponse response, User currentUser)
            throws ServletException, IOException {
        
        String fullName = request.getParameter("fullName");
        String email = request.getParameter("email");
        String phone = request.getParameter("phone");
        String address = request.getParameter("address");
        
        // Validate input
        if (fullName == null || fullName.trim().isEmpty()) {
            request.setAttribute("error", "Họ tên không được để trống");
            showEditProfile(request, response, currentUser);
            return;
        }
        
        if (email == null || email.trim().isEmpty()) {
            request.setAttribute("error", "Email không được để trống");
            showEditProfile(request, response, currentUser);
            return;
        }
        
        // Check if email is already used by another user
        try {
            User existingUser = userDAO.getUserByEmail(email.trim());
            if (existingUser != null && existingUser.getUserID() != currentUser.getUserID()) {
                request.setAttribute("error", "Email này đã được sử dụng bởi người khác");
                showEditProfile(request, response, currentUser);
                return;
            }
        } catch (Exception e) {
            request.setAttribute("error", "Lỗi kiểm tra email: " + e.getMessage());
            showEditProfile(request, response, currentUser);
            return;
        }
        
        // Update user data
        try {
            User updatedUser = new User();
            updatedUser.setUserID(currentUser.getUserID());
            updatedUser.setFullName(fullName.trim());
            updatedUser.setEmail(email.trim());
            updatedUser.setPhone(phone != null ? phone.trim() : "");
            updatedUser.setAddress(address != null ? address.trim() : "");
            updatedUser.setRoleID(currentUser.getRoleID());
            updatedUser.setActive(currentUser.isActive());
            updatedUser.setPasswordHash(currentUser.getPasswordHash());
            
            boolean success = userDAO.updateUser(updatedUser);
            
            if (success) {
                // Update session with new user data
                HttpSession session = request.getSession();
                session.setAttribute("user", updatedUser);
                
                request.setAttribute("success", "Cập nhật thông tin thành công!");
                showProfile(request, response, updatedUser);
            } else {
                request.setAttribute("error", "Cập nhật thông tin thất bại");
                showEditProfile(request, response, currentUser);
            }
            
        } catch (Exception e) {
            request.setAttribute("error", "Lỗi cập nhật: " + e.getMessage());
            showEditProfile(request, response, currentUser);
        }
    }
    
    /**
     * Handle password change
     */
    private void handleChangePassword(HttpServletRequest request, HttpServletResponse response, User currentUser)
            throws ServletException, IOException {
        
        String currentPassword = request.getParameter("currentPassword");
        String newPassword = request.getParameter("newPassword");
        String confirmPassword = request.getParameter("confirmPassword");
        
        // Validate input
        if (currentPassword == null || currentPassword.trim().isEmpty()) {
            request.setAttribute("error", "Vui lòng nhập mật khẩu hiện tại");
            showChangePassword(request, response, currentUser);
            return;
        }
        
        if (newPassword == null || newPassword.trim().isEmpty()) {
            request.setAttribute("error", "Vui lòng nhập mật khẩu mới");
            showChangePassword(request, response, currentUser);
            return;
        }
        
        if (newPassword.length() < 6) {
            request.setAttribute("error", "Mật khẩu mới phải có ít nhất 6 ký tự");
            showChangePassword(request, response, currentUser);
            return;
        }
        
        if (!newPassword.equals(confirmPassword)) {
            request.setAttribute("error", "Xác nhận mật khẩu không khớp");
            showChangePassword(request, response, currentUser);
            return;
        }
        
        try {
            // Verify current password
            boolean isCurrentPasswordValid = userService.verifyPassword(currentPassword, currentUser.getPasswordHash());
            
            if (!isCurrentPasswordValid) {
                request.setAttribute("error", "Mật khẩu hiện tại không đúng");
                showChangePassword(request, response, currentUser);
                return;
            }
            
            // Hash new password
            String newPasswordHash = userService.hashPassword(newPassword);
            
            // Update password in database
            boolean success = userDAO.updateUserPassword(currentUser.getUserID(), newPasswordHash);
            
            if (success) {
                // Update session
                currentUser.setPasswordHash(newPasswordHash);
                HttpSession session = request.getSession();
                session.setAttribute("user", currentUser);
                
                request.setAttribute("success", "Đổi mật khẩu thành công!");
                showProfile(request, response, currentUser);
            } else {
                request.setAttribute("error", "Đổi mật khẩu thất bại");
                showChangePassword(request, response, currentUser);
            }
            
        } catch (Exception e) {
            request.setAttribute("error", "Lỗi đổi mật khẩu: " + e.getMessage());
            showChangePassword(request, response, currentUser);
        }
    }
}