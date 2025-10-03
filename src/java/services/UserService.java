/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package services;

import dao.UserDAO;
import models.User;
import models.Setting;
import java.util.List;
import java.util.regex.Pattern;

/**
 *
 * @author DrDYNew
 */
public class UserService {
    private UserDAO userDAO;
    
    public UserService() {
        this.userDAO = new UserDAO();
    }
    
    /**
     * Validate user data
     * @param user User object to validate
     * @param isUpdate true if this is an update operation
     * @return Error message if validation fails, null if valid
     */
    public String validateUser(User user, boolean isUpdate) {
        // Validate required fields
        if (user.getFullName() == null || user.getFullName().trim().isEmpty()) {
            return "Họ tên không được để trống";
        }
        
        if (user.getEmail() == null || user.getEmail().trim().isEmpty()) {
            return "Email không được để trống";
        }
        
        if (!isUpdate && (user.getPasswordHash() == null || user.getPasswordHash().trim().isEmpty())) {
            return "Mật khẩu không được để trống";
        }
        
        // Validate email format
        if (!isValidEmail(user.getEmail())) {
            return "Email không hợp lệ";
        }
        
        // Validate phone number format (if provided)
        if (user.getPhone() != null && !user.getPhone().trim().isEmpty()) {
            if (!isValidPhoneNumber(user.getPhone())) {
                return "Số điện thoại không hợp lệ";
            }
        }
        
        // Check email uniqueness
        Integer excludeUserID = isUpdate ? user.getUserID() : null;
        if (userDAO.isEmailExists(user.getEmail(), excludeUserID)) {
            return "Email đã tồn tại trong hệ thống";
        }
        
        // Validate role
        if (user.getRoleID() <= 0) {
            return "Vui lòng chọn vai trò";
        }
        
        return null; // No validation errors
    }
    
    /**
     * Validate password strength
     * @param password Plain text password
     * @return Error message if validation fails, null if valid
     */
    public String validatePassword(String password) {
        if (password == null || password.trim().isEmpty()) {
            return "Mật khẩu không được để trống";
        }
        
        if (password.length() < 6) {
            return "Mật khẩu phải có ít nhất 6 ký tự";
        }
        
        if (password.length() > 50) {
            return "Mật khẩu không được quá 50 ký tự";
        }
        
        // Check if password contains at least one letter and one number
        boolean hasLetter = password.matches(".*[a-zA-Z].*");
        boolean hasNumber = password.matches(".*\\d.*");
        
        if (!hasLetter || !hasNumber) {
            return "Mật khẩu phải chứa ít nhất một chữ cái và một số";
        }
        
        return null; // Password is valid
    }
    
    /**
     * Create new user with validation
     * @param user User object to create
     * @param plainPassword Plain text password
     * @param currentUserRole Current user's role for permission check
     * @return Error message if failed, null if successful
     */
    public String createUser(User user, String plainPassword, String currentUserRole) {
        // Check permission
        if (!canCreateUser(currentUserRole, user.getRoleID())) {
            return "Bạn không có quyền tạo tài khoản với vai trò này";
        }
        
        // Validate password
        String passwordError = validatePassword(plainPassword);
        if (passwordError != null) {
            return passwordError;
        }
        
        // Hash password
        user.setPasswordHash(userDAO.hashPassword(plainPassword));
        
        // Validate user data
        String validationError = validateUser(user, false);
        if (validationError != null) {
            return validationError;
        }
        
        // Set user as active by default
        user.setActive(true);
        
        // Create user
        if (userDAO.createUser(user)) {
            return null; // Success
        } else {
            return "Lỗi hệ thống khi tạo tài khoản";
        }
    }
    
    /**
     * Update user with validation
     * @param user User object to update
     * @param currentUserRole Current user's role for permission check
     * @return Error message if failed, null if successful
     */
    public String updateUser(User user, String currentUserRole) {
        // Get original user to check role changes
        User originalUser = userDAO.getUserById(user.getUserID());
        if (originalUser == null) {
            return "Không tìm thấy người dùng";
        }
        
        // Check permission for role change
        if (originalUser.getRoleID() != user.getRoleID()) {
            if (!canCreateUser(currentUserRole, user.getRoleID())) {
                return "Bạn không có quyền thay đổi vai trò thành vai trò này";
            }
        }
        
        // Validate user data
        String validationError = validateUser(user, true);
        if (validationError != null) {
            return validationError;
        }
        
        // Update user
        if (userDAO.updateUser(user)) {
            return null; // Success
        } else {
            return "Lỗi hệ thống khi cập nhật thông tin";
        }
    }
    
    /**
     * Change user password
     * @param userID User ID
     * @param newPassword New plain text password
     * @return Error message if failed, null if successful
     */
    public String changePassword(int userID, String newPassword) {
        // Validate password
        String passwordError = validatePassword(newPassword);
        if (passwordError != null) {
            return passwordError;
        }
        
        // Hash new password
        String hashedPassword = userDAO.hashPassword(newPassword);
        
        // Update password
        if (userDAO.updatePassword(userID, hashedPassword)) {
            return null; // Success
        } else {
            return "Lỗi hệ thống khi đổi mật khẩu";
        }
    }
    
    /**
     * Delete user (soft delete)
     * @param userID User ID to delete
     * @param currentUserRole Current user's role for permission check
     * @return Error message if failed, null if successful
     */
    public String deleteUser(int userID, String currentUserRole) {
        // Get user to check role
        User user = userDAO.getUserById(userID);
        if (user == null) {
            return "Không tìm thấy người dùng";
        }
        
        // Check permission
        if (!canDeleteUser(currentUserRole, user.getRoleID())) {
            return "Bạn không có quyền xóa tài khoản này";
        }
        
        // Delete user
        if (userDAO.deleteUser(userID)) {
            return null; // Success
        } else {
            return "Lỗi hệ thống khi xóa tài khoản";
        }
    }
    
    /**
     * Check if current user can create/modify user with specific role
     * @param currentUserRole Current user's role
     * @param targetRoleID Target role ID
     * @return true if allowed, false otherwise
     */
    private boolean canCreateUser(String currentUserRole, int targetRoleID) {
        if ("Admin".equals(currentUserRole)) {
            return true; // Admin can create all roles
        }
        
        if ("HR".equals(currentUserRole)) {
            // HR can only create Inventory (3) and Barista (4) roles
            return targetRoleID == 3 || targetRoleID == 4;
        }
        
        return false; // Other roles cannot create users
    }
    
    /**
     * Check if current user can delete user with specific role
     * @param currentUserRole Current user's role
     * @param targetRoleID Target role ID
     * @return true if allowed, false otherwise
     */
    private boolean canDeleteUser(String currentUserRole, int targetRoleID) {
        if ("Admin".equals(currentUserRole)) {
            return true; // Admin can delete all roles except other admins
        }
        
        if ("HR".equals(currentUserRole)) {
            // HR can only delete Inventory (3) and Barista (4) roles
            return targetRoleID == 3 || targetRoleID == 4;
        }
        
        return false; // Other roles cannot delete users
    }
    
    /**
     * Get roles that current user can assign
     * @param currentUserRole Current user's role
     * @return List of available roles
     */
    public List<Setting> getAvailableRoles(String currentUserRole) {
        if ("Admin".equals(currentUserRole)) {
            return userDAO.getAllRoles();
        } else if ("HR".equals(currentUserRole)) {
            return userDAO.getAvailableRolesForHR();
        }
        
        return List.of(); // Return empty list for other roles
    }
    
    /**
     * Validate email format
     * @param email Email to validate
     * @return true if valid, false otherwise
     */
    private boolean isValidEmail(String email) {
        String emailRegex = "^[a-zA-Z0-9_+&*-]+(?:\\.[a-zA-Z0-9_+&*-]+)*@(?:[a-zA-Z0-9-]+\\.)+[a-zA-Z]{2,7}$";
        Pattern pattern = Pattern.compile(emailRegex);
        return pattern.matcher(email).matches();
    }
    
    /**
     * Validate phone number format (Vietnamese phone numbers)
     * @param phone Phone number to validate
     * @return true if valid, false otherwise
     */
    private boolean isValidPhoneNumber(String phone) {
        // Remove all non-digit characters
        String cleanPhone = phone.replaceAll("[^0-9]", "");
        
        // Vietnamese phone number patterns
        // Mobile: 09x, 08x, 07x, 05x, 03x (10 digits)
        // Landline: 02x (10-11 digits)
        if (cleanPhone.length() >= 10 && cleanPhone.length() <= 11) {
            return cleanPhone.matches("^(09|08|07|05|03|02)[0-9]{8,9}$");
        }
        
        return false;
    }
    
    /**
     * Get users with pagination and filtering
     * @param page Page number
     * @param pageSize Page size
     * @param roleFilter Role filter
     * @param searchKeyword Search keyword
     * @return List of users
     */
    public List<User> getUsers(int page, int pageSize, Integer roleFilter, String searchKeyword) {
        return userDAO.getAllUsers(page, pageSize, roleFilter, searchKeyword);
    }
    
    /**
     * Get total users count for pagination
     * @param roleFilter Role filter
     * @param searchKeyword Search keyword
     * @return Total count
     */
    public int getTotalUsersCount(Integer roleFilter, String searchKeyword) {
        return userDAO.getTotalUsersCount(roleFilter, searchKeyword);
    }
    
    /**
     * Get user by ID
     * @param userID User ID
     * @return User object
     */
    public User getUserById(int userID) {
        return userDAO.getUserById(userID);
    }
}