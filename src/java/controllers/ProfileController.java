package controllers;

import model.User;
import dao.UserDAO;
import services.UserService;
import java.io.IOException;
import java.io.File;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.nio.file.StandardCopyOption;
import java.util.UUID;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import jakarta.servlet.http.Part;

/**
 * ProfileController handles user profile management
 * @author DrDYNew
 */
@WebServlet(name = "ProfileController", urlPatterns = {"/profile"})
@MultipartConfig(
    fileSizeThreshold = 1024 * 1024 * 2,  // 2MB
    maxFileSize = 1024 * 1024 * 10,       // 10MB
    maxRequestSize = 1024 * 1024 * 50     // 50MB
)
public class ProfileController extends HttpServlet {
    
    private static final String UPLOAD_DIR = "uploads/avatars";
    private static final String[] ALLOWED_EXTENSIONS = {".jpg", ".jpeg", ".png", ".gif"};
    
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
            } else if ("upload-avatar".equals(action)) {
                handleUploadAvatar(request, response, currentUser);
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
            String gender = request.getParameter("gender");
            
            User updatedUser = new User();
            updatedUser.setUserID(currentUser.getUserID());
            updatedUser.setFullName(fullName.trim());
            updatedUser.setEmail(email.trim());
            updatedUser.setPhone(phone != null ? phone.trim() : "");
            updatedUser.setAddress(address != null ? address.trim() : "");
            updatedUser.setGender(gender != null ? gender.trim() : currentUser.getGender());
            updatedUser.setAvatarUrl(currentUser.getAvatarUrl()); // Keep current avatar
            updatedUser.setRoleID(currentUser.getRoleID());
            updatedUser.setActive(currentUser.isActive());
            updatedUser.setPasswordHash(currentUser.getPasswordHash());
            
            boolean success = userDAO.updateUser(updatedUser);
            
            if (success) {
                // Get fresh user data from database to ensure all fields are loaded
                User freshUser = userDAO.getUserById(currentUser.getUserID());
                if (freshUser != null) {
                    // Update session with fresh data from database
                    HttpSession session = request.getSession();
                    session.setAttribute("user", freshUser);
                    
                    request.setAttribute("success", "Cập nhật thông tin thành công!");
                    showProfile(request, response, freshUser);
                } else {
                    // Fallback: use updatedUser
                    HttpSession session = request.getSession();
                    session.setAttribute("user", updatedUser);
                    
                    request.setAttribute("success", "Cập nhật thông tin thành công!");
                    showProfile(request, response, updatedUser);
                }
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
    
    /**
     * Handle avatar upload
     */
    private void handleUploadAvatar(HttpServletRequest request, HttpServletResponse response, User currentUser)
            throws ServletException, IOException {
        
        try {
            Part filePart = request.getPart("avatarFile");
            
            if (filePart == null || filePart.getSize() == 0) {
                request.setAttribute("error", "Vui lòng chọn file ảnh");
                showEditProfile(request, response, currentUser);
                return;
            }
            
            // Get filename
            String fileName = getFileName(filePart);
            if (fileName == null || fileName.isEmpty()) {
                request.setAttribute("error", "File không hợp lệ");
                showEditProfile(request, response, currentUser);
                return;
            }
            
            // Validate file extension
            String fileExtension = getFileExtension(fileName);
            if (!isAllowedExtension(fileExtension)) {
                request.setAttribute("error", "Chỉ chấp nhận file ảnh (.jpg, .jpeg, .png, .gif)");
                showEditProfile(request, response, currentUser);
                return;
            }
            
            // Generate unique filename
            String uniqueFileName = UUID.randomUUID().toString() + fileExtension;
            
            // Get upload directory path - use web folder instead of build folder
            // This prevents images from being deleted on clean & build
            String realPath = request.getServletContext().getRealPath("");
            String webPath;
            
            if (realPath.contains("build")) {
                // Running from build folder, save to web folder
                webPath = realPath.substring(0, realPath.indexOf("build")) + "web";
            } else {
                // Already in web folder
                webPath = realPath;
            }
            
            String uploadPath = webPath + File.separator + UPLOAD_DIR;
            
            // Create directory if not exists
            File uploadDir = new File(uploadPath);
            if (!uploadDir.exists()) {
                uploadDir.mkdirs();
            }
            
            // Save file to web/uploads/avatars
            String filePath = uploadPath + File.separator + uniqueFileName;
            Path path = Paths.get(filePath);
            Files.copy(filePart.getInputStream(), path, StandardCopyOption.REPLACE_EXISTING);
            
            // Also copy to build folder for immediate display (if different from web)
            if (realPath.contains("build")) {
                String buildUploadPath = realPath + File.separator + UPLOAD_DIR;
                File buildUploadDir = new File(buildUploadPath);
                if (!buildUploadDir.exists()) {
                    buildUploadDir.mkdirs();
                }
                String buildFilePath = buildUploadPath + File.separator + uniqueFileName;
                // Copy file from web to build
                Files.copy(path, Paths.get(buildFilePath), StandardCopyOption.REPLACE_EXISTING);
            }
            
            // Generate URL for avatar (RELATIVE PATH - không bao gồm contextPath)
            String avatarUrl = "/" + UPLOAD_DIR + "/" + uniqueFileName;
            
            // Update database
            boolean success = userDAO.updateAvatar(currentUser.getUserID(), avatarUrl);
            
            if (success) {
                // Delete old avatar file if exists
                if (currentUser.getAvatarUrl() != null && !currentUser.getAvatarUrl().isEmpty()) {
                    deleteOldAvatar(webPath, currentUser.getAvatarUrl());
                }
                
                // Get updated user from database to ensure all data is fresh
                User updatedUser = userDAO.getUserById(currentUser.getUserID());
                if (updatedUser != null) {
                    // Update session with fresh data from database
                    HttpSession session = request.getSession();
                    session.setAttribute("user", updatedUser);
                    
                    request.setAttribute("success", "Cập nhật ảnh đại diện thành công!");
                    showEditProfile(request, response, updatedUser);
                } else {
                    // Fallback: just update avatarUrl in current user
                    currentUser.setAvatarUrl(avatarUrl);
                    HttpSession session = request.getSession();
                    session.setAttribute("user", currentUser);
                    
                    request.setAttribute("success", "Cập nhật ảnh đại diện thành công!");
                    showEditProfile(request, response, currentUser);
                }
            } else {
                // Delete uploaded file if database update failed
                Files.deleteIfExists(path);
                request.setAttribute("error", "Cập nhật ảnh đại diện thất bại");
                showEditProfile(request, response, currentUser);
            }
            
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "Lỗi upload ảnh: " + e.getMessage());
            showEditProfile(request, response, currentUser);
        }
    }
    
    /**
     * Get filename from multipart content
     */
    private String getFileName(Part part) {
        String contentDisposition = part.getHeader("content-disposition");
        if (contentDisposition != null) {
            String[] items = contentDisposition.split(";");
            for (String item : items) {
                if (item.trim().startsWith("filename")) {
                    return item.substring(item.indexOf("=") + 2, item.length() - 1);
                }
            }
        }
        return null;
    }
    
    /**
     * Get file extension
     */
    private String getFileExtension(String fileName) {
        if (fileName == null || fileName.isEmpty()) {
            return "";
        }
        int lastDot = fileName.lastIndexOf('.');
        if (lastDot > 0) {
            return fileName.substring(lastDot).toLowerCase();
        }
        return "";
    }
    
    /**
     * Check if file extension is allowed
     */
    private boolean isAllowedExtension(String extension) {
        for (String allowed : ALLOWED_EXTENSIONS) {
            if (allowed.equalsIgnoreCase(extension)) {
                return true;
            }
        }
        return false;
    }
    
    /**
     * Delete old avatar file
     */
    private void deleteOldAvatar(String applicationPath, String avatarUrl) {
        try {
            if (avatarUrl != null && avatarUrl.contains(UPLOAD_DIR)) {
                String fileName = avatarUrl.substring(avatarUrl.lastIndexOf('/') + 1);
                String filePath = applicationPath + File.separator + UPLOAD_DIR + File.separator + fileName;
                Path path = Paths.get(filePath);
                Files.deleteIfExists(path);
            }
        } catch (Exception e) {
            // Log error but don't fail the operation
            e.printStackTrace();
        }
    }
}