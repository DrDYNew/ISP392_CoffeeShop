package dao;

import java.sql.*;

/**
 * DAO cho bảng SystemConfig - Lưu Master API Token và cấu hình hệ thống
 */
public class SystemConfigDAO extends BaseDAO {
    
    /**
     * Lấy giá trị config theo key
     */
    public String getConfigValue(String configKey) {
        String sql = "SELECT ConfigValue FROM SystemConfig WHERE ConfigKey = ?";
        
        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setString(1, configKey);
            ResultSet rs = ps.executeQuery();
            
            if (rs.next()) {
                return rs.getString("ConfigValue");
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }
    
    /**
     * Kiểm tra Master API Token có hợp lệ không
     */
    public boolean isMasterTokenValid(String token) {
        String masterToken = getConfigValue("MASTER_API_TOKEN");
        return masterToken != null && masterToken.equals(token);
    }
    
    /**
     * Tạo Master API Token mới (JWT format)
     */
    public String generateMasterToken() {
        try {
            String header = "{\"alg\":\"HS256\",\"typ\":\"JWT\"}";
            String encodedHeader = base64UrlEncode(header);
            
            long timestamp = System.currentTimeMillis() / 1000;
            String payload = "{\"access\":\"all_shops\",\"iat\":" + timestamp + "}";
            String encodedPayload = base64UrlEncode(payload);
            
            String secret = "COFFEE_SHOP_MASTER_SECRET_KEY_2025";
            String dataToSign = encodedHeader + "." + encodedPayload;
            String signature = generateSignature(dataToSign, secret);
            
            return "MASTER_" + encodedHeader + "." + encodedPayload + "." + signature;
            
        } catch (Exception e) {
            e.printStackTrace();
            return "MASTER_" + java.util.UUID.randomUUID().toString().replace("-", "");
        }
    }
    
    /**
     * Regenerate Master API Token
     */
    public String regenerateMasterToken() {
        String newToken = generateMasterToken();
        if (updateConfigValue("MASTER_API_TOKEN", newToken)) {
            return newToken;
        }
        return null;
    }
    
    private String base64UrlEncode(String input) {
        return java.util.Base64.getUrlEncoder()
                .withoutPadding()
                .encodeToString(input.getBytes(java.nio.charset.StandardCharsets.UTF_8));
    }
    
    private String generateSignature(String data, String secret) {
        try {
            java.security.MessageDigest digest = java.security.MessageDigest.getInstance("SHA-256");
            String combined = data + secret;
            byte[] hash = digest.digest(combined.getBytes(java.nio.charset.StandardCharsets.UTF_8));
            
            StringBuilder hexString = new StringBuilder();
            for (int i = 0; i < Math.min(16, hash.length); i++) {
                String hex = Integer.toHexString(0xff & hash[i]);
                if (hex.length() == 1) hexString.append('0');
                hexString.append(hex);
            }
            return hexString.toString();
            
        } catch (java.security.NoSuchAlgorithmException e) {
            e.printStackTrace();
            return java.util.UUID.randomUUID().toString().substring(0, 16);
        }
    }
    
    /**
     * Cập nhật giá trị config
     */
    public boolean updateConfigValue(String configKey, String configValue) {
        String sql = "UPDATE SystemConfig SET ConfigValue = ?, UpdatedAt = CURRENT_TIMESTAMP WHERE ConfigKey = ?";
        
        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setString(1, configValue);
            ps.setString(2, configKey);
            
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }
    
    /**
     * Tạo config mới
     */
    public boolean insertConfig(String configKey, String configValue, String description) {
        String sql = "INSERT INTO SystemConfig (ConfigKey, ConfigValue, Description) VALUES (?, ?, ?)";
        
        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setString(1, configKey);
            ps.setString(2, configValue);
            ps.setString(3, description);
            
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }
}
