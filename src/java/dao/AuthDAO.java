/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package dao;



import model.User;
import model.AuthResponse;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import org.mindrot.jbcrypt.BCrypt;

import dao.BaseDAO;


/**
 *
 * @author DrDYNew
 */
public class AuthDAO extends BaseDAO {
    
    /**
     * Authenticate user by email and password
     * @param email User email
     * @param password Plain text password
     * @return AuthResponse with user info if successful, error message if failed
     */
    public AuthResponse authenticateUser(String email, String password) {
        String sql = "SELECT u.UserID, u.FullName, u.Email, u.PasswordHash, u.Phone, " +
                    "u.Address, u.RoleID, u.IsActive, u.CreatedAt, s.Value as RoleName " +
                    "FROM \"User\" u " +
                    "JOIN Setting s ON u.RoleID = s.SettingID " +
                    "WHERE u.Email = ? AND u.IsActive = true AND s.Type = 'Role'";
        
        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setString(1, email);
            ResultSet rs = ps.executeQuery();
            
            if (rs.next()) {
                String storedHash = rs.getString("PasswordHash");
                
                // Verify password using bcrypt
                if (BCrypt.checkpw(password, storedHash)) {
                    // Password is correct, create user object
                    User user = new User();
                    user.setUserID(rs.getInt("UserID"));
                    user.setFullName(rs.getString("FullName"));
                    user.setEmail(rs.getString("Email"));
                    user.setPasswordHash(storedHash);
                    user.setPhone(rs.getString("Phone"));
                    user.setAddress(rs.getString("Address"));
                    user.setRoleID(rs.getInt("RoleID"));
                    user.setActive(rs.getBoolean("IsActive"));
                    user.setCreatedAt(rs.getTimestamp("CreatedAt"));
                    
                    String roleName = rs.getString("RoleName");
                    
                    return new AuthResponse(true, "Đăng nhập thành công", user, roleName);
                } else {
                    return new AuthResponse(false, "Email hoặc mật khẩu không đúng");
                }
            } else {
                return new AuthResponse(false, "Email hoặc mật khẩu không đúng");
            }
            
        } catch (SQLException e) {
            e.printStackTrace();
            return new AuthResponse(false, "Lỗi hệ thống: " + e.getMessage());
        }
    }
    
    /**
     * Hash password using bcrypt
     * @param password Plain text password
     * @return Hashed password
     */
    public String hashPassword(String password) {
        return BCrypt.hashpw(password, BCrypt.gensalt());
    }
    
    /**
     * Verify if password matches the hash
     * @param password Plain text password
     * @param hash Stored password hash
     * @return true if password matches, false otherwise
     */
    public boolean verifyPassword(String password, String hash) {
        return BCrypt.checkpw(password, hash);
    }
    
    /**
     * Get user by ID with role information
     * @param userID User ID
     * @return User object with role name, null if not found
     */
    public User getUserByIdWithRole(int userID) {
        String sql = "SELECT u.UserID, u.FullName, u.Email, u.PasswordHash, u.Phone, " +
                    "u.Address, u.RoleID, u.IsActive, u.CreatedAt " +
                    "FROM \"User\" u " +
                    "WHERE u.UserID = ? AND u.IsActive = true";
        
        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setInt(1, userID);
            ResultSet rs = ps.executeQuery();
            
            if (rs.next()) {
                User user = new User();
                user.setUserID(rs.getInt("UserID"));
                user.setFullName(rs.getString("FullName"));
                user.setEmail(rs.getString("Email"));
                user.setPasswordHash(rs.getString("PasswordHash"));
                user.setPhone(rs.getString("Phone"));
                user.setAddress(rs.getString("Address"));
                user.setRoleID(rs.getInt("RoleID"));
                user.setActive(rs.getBoolean("IsActive"));
                user.setCreatedAt(rs.getTimestamp("CreatedAt"));
                
                return user;
            }
            
        } catch (SQLException e) {
            e.printStackTrace();
        }
        
        return null;
    }
    
    /**
     * Get role name by role ID
     * @param roleID Role ID
     * @return Role name, null if not found
     */
    public String getRoleName(int roleID) {
        String sql = "SELECT Value FROM Setting WHERE SettingID = ? AND Type = 'Role' AND IsActive = true";
        
        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setInt(1, roleID);
            ResultSet rs = ps.executeQuery();
            
            if (rs.next()) {
                return rs.getString("Value");
            }
            
        } catch (SQLException e) {
            e.printStackTrace();
        }
        
        return null;
    }
}
