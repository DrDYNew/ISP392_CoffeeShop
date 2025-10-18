/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package dao;

import java.nio.charset.StandardCharsets;
import java.security.MessageDigest;
import java.security.NoSuchAlgorithmException;
import java.util.Base64;
import java.util.UUID;
import model.Shop;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

/**
 *
 * @author DrDYNew
 */

public class ShopDAO extends BaseDAO {

    private String generateApiToken() {
        try {
            String header = "{\"alg\":\"HS256\",\"typ\":\"JWT\"}";
            String encodedHeader = base64UrlEncode(header);
            
            long timestamp = System.currentTimeMillis() / 1000;
            String uuid = UUID.randomUUID().toString();
            String payload = "{\"shop_id\":\"" + uuid + "\",\"iat\":" + timestamp + "}";
            String encodedPayload = base64UrlEncode(payload);
            
            String secret = "COFFEE_SHOP_SECRET_KEY_2025";
            String dataToSign = encodedHeader + "." + encodedPayload;
            String signature = generateSignature(dataToSign, secret);
            
            return encodedHeader + "." + encodedPayload + "." + signature;
            
        } catch (Exception e) {
            e.printStackTrace();
            return "SHOP_" + UUID.randomUUID().toString().replace("-", "");
        }
    }
    
    private String base64UrlEncode(String input) {
        return Base64.getUrlEncoder()
                .withoutPadding()
                .encodeToString(input.getBytes(StandardCharsets.UTF_8));
    }
    
    private String generateSignature(String data, String secret) {
        try {
            MessageDigest digest = MessageDigest.getInstance("SHA-256");
            String combined = data + secret;
            byte[] hash = digest.digest(combined.getBytes(StandardCharsets.UTF_8));
            
            StringBuilder hexString = new StringBuilder();
            for (int i = 0; i < Math.min(16, hash.length); i++) {
                String hex = Integer.toHexString(0xff & hash[i]);
                if (hex.length() == 1) hexString.append('0');
                hexString.append(hex);
            }
            return hexString.toString();
            
        } catch (NoSuchAlgorithmException e) {
            e.printStackTrace();
            return UUID.randomUUID().toString().substring(0, 16);
        }
    }

    private Shop extractShopFromResultSet(ResultSet rs) throws SQLException {
        Shop shop = new Shop();
        shop.setShopID(rs.getInt("ShopID"));
        shop.setShopName(rs.getString("ShopName"));
        shop.setAddress(rs.getString("Address"));
        shop.setPhone(rs.getString("Phone"));
        
        int ownerId = rs.getInt("OwnerID");
        shop.setOwnerID(rs.wasNull() ? null : ownerId);
        
        shop.setActive(rs.getBoolean("IsActive"));
        shop.setCreatedAt(rs.getTimestamp("CreatedAt"));
        shop.setApiToken(rs.getString("APIToken"));
        
        return shop;
    }

    public List<Shop> getAllShops() {
        List<Shop> shops = new ArrayList<>();
        String sql = "SELECT * FROM Shop ORDER BY CreatedAt DESC";
        
        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            
            while (rs.next()) {
                shops.add(extractShopFromResultSet(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return shops;
    }

    public Shop getShopById(int shopId) {
        String sql = "SELECT * FROM Shop WHERE ShopID = ?";
        
        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setInt(1, shopId);
            ResultSet rs = ps.executeQuery();
            
            if (rs.next()) {
                return extractShopFromResultSet(rs);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    public Shop getShopByApiToken(String apiToken) {
        String sql = "SELECT * FROM Shop WHERE APIToken = ? AND IsActive = TRUE";
        
        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setString(1, apiToken);
            ResultSet rs = ps.executeQuery();
            
            if (rs.next()) {
                return extractShopFromResultSet(rs);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    public int insertShop(Shop shop) {
        String sql = "INSERT INTO Shop (ShopName, Address, Phone, OwnerID, IsActive, APIToken) VALUES (?, ?, ?, ?, ?, ?) RETURNING ShopID";
        
        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setString(1, shop.getShopName());
            ps.setString(2, shop.getAddress());
            ps.setString(3, shop.getPhone());
            
            if (shop.getOwnerID() != null) {
                ps.setInt(4, shop.getOwnerID());
            } else {
                ps.setNull(4, Types.INTEGER);
            }
            
            ps.setBoolean(5, shop.isActive());
            
            String apiToken = shop.getApiToken();
            if (apiToken == null || apiToken.isEmpty()) {
                apiToken = generateApiToken();
            }
            ps.setString(6, apiToken);
            
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return rs.getInt(1);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return 0;
    }

    public boolean updateShop(Shop shop) {
        String sql = "UPDATE Shop SET ShopName = ?, Address = ?, Phone = ?, OwnerID = ?, IsActive = ? WHERE ShopID = ?";
        
        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setString(1, shop.getShopName());
            ps.setString(2, shop.getAddress());
            ps.setString(3, shop.getPhone());
            
            if (shop.getOwnerID() != null) {
                ps.setInt(4, shop.getOwnerID());
            } else {
                ps.setNull(4, Types.INTEGER);
            }
            
            ps.setBoolean(5, shop.isActive());
            ps.setInt(6, shop.getShopID());
            
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    public boolean deleteShop(int shopId) {
        String sql = "UPDATE Shop SET IsActive = FALSE WHERE ShopID = ?";
        
        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setInt(1, shopId);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    public String regenerateApiToken(int shopId) {
        String newToken = generateApiToken();
        String sql = "UPDATE Shop SET APIToken = ? WHERE ShopID = ?";
        
        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setString(1, newToken);
            ps.setInt(2, shopId);
            
            if (ps.executeUpdate() > 0) {
                return newToken;
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    public boolean isApiTokenValid(String apiToken) {
        String sql = "SELECT COUNT(*) FROM Shop WHERE APIToken = ? AND IsActive = TRUE";
        
        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setString(1, apiToken);
            ResultSet rs = ps.executeQuery();
            
            if (rs.next()) {
                return rs.getInt(1) > 0;
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }
    
    /**
     * Get active shops only
     */
    public List<Shop> getActiveShops() {
        List<Shop> shops = new ArrayList<>();
        String sql = "SELECT * FROM Shop WHERE IsActive = TRUE ORDER BY CreatedAt DESC";
        
        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            
            while (rs.next()) {
                shops.add(extractShopFromResultSet(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return shops;
    }
    
    /**
     * Search shops by name
     */
    public List<Shop> searchShopsByName(String keyword) {
        List<Shop> shops = new ArrayList<>();
        String sql = "SELECT * FROM Shop WHERE LOWER(ShopName) LIKE LOWER(?) ORDER BY CreatedAt DESC";
        
        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setString(1, "%" + keyword + "%");
            ResultSet rs = ps.executeQuery();
            
            while (rs.next()) {
                shops.add(extractShopFromResultSet(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return shops;
    }
}
