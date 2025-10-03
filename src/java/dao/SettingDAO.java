package dao;

import model.Setting;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

/**
 * Data Access Object for Setting
 */
public class SettingDAO extends DBContext {
    
    /**
     * Get all settings
     * @return List of all settings
     */
    public List<Setting> getAllSettings() {
        List<Setting> settings = new ArrayList<>();
        String sql = "SELECT * FROM Setting ORDER BY Type, Value";
        
        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            
            while (rs.next()) {
                Setting setting = new Setting();
                setting.setSettingID(rs.getInt("SettingID"));
                setting.setType(rs.getString("Type"));
                setting.setValue(rs.getString("Value"));
                setting.setDescription(rs.getString("Description"));
                setting.setActive(rs.getBoolean("IsActive"));
                settings.add(setting);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        
        return settings;
    }
    
    /**
     * Get settings by type
     * @param type Setting type
     * @return List of settings with specified type
     */
    public List<Setting> getSettingsByType(String type) {
        List<Setting> settings = new ArrayList<>();
        String sql = "SELECT * FROM Setting WHERE Type = ? ORDER BY Value";
        
        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setString(1, type);
            ResultSet rs = ps.executeQuery();
            
            while (rs.next()) {
                Setting setting = new Setting();
                setting.setSettingID(rs.getInt("SettingID"));
                setting.setType(rs.getString("Type"));
                setting.setValue(rs.getString("Value"));
                setting.setDescription(rs.getString("Description"));
                setting.setActive(rs.getBoolean("IsActive"));
                settings.add(setting);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        
        return settings;
    }
    
    /**
     * Get setting by ID
     * @param settingID Setting ID
     * @return Setting object or null if not found
     */
    public Setting getSettingById(int settingID) {
        String sql = "SELECT * FROM Setting WHERE SettingID = ?";
        
        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setInt(1, settingID);
            ResultSet rs = ps.executeQuery();
            
            if (rs.next()) {
                Setting setting = new Setting();
                setting.setSettingID(rs.getInt("SettingID"));
                setting.setType(rs.getString("Type"));
                setting.setValue(rs.getString("Value"));
                setting.setDescription(rs.getString("Description"));
                setting.setActive(rs.getBoolean("IsActive"));
                return setting;
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        
        return null;
    }
    
    /**
     * Create new setting
     * @param setting Setting object
     * @return true if successful, false otherwise
     */
    public boolean createSetting(Setting setting) {
        String sql = "INSERT INTO Setting (Type, Value, Description, IsActive) VALUES (?, ?, ?, ?)";
        
        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setString(1, setting.getType());
            ps.setString(2, setting.getValue());
            ps.setString(3, setting.getDescription());
            ps.setBoolean(4, setting.isActive());
            
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        
        return false;
    }
    
    /**
     * Update existing setting
     * @param setting Setting object
     * @return true if successful, false otherwise
     */
    public boolean updateSetting(Setting setting) {
        String sql = "UPDATE Setting SET Type = ?, Value = ?, Description = ?, IsActive = ? WHERE SettingID = ?";
        
        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setString(1, setting.getType());
            ps.setString(2, setting.getValue());
            ps.setString(3, setting.getDescription());
            ps.setBoolean(4, setting.isActive());
            ps.setInt(5, setting.getSettingID());
            
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        
        return false;
    }
    
    /**
     * Delete setting by ID
     * @param settingID Setting ID
     * @return true if successful, false otherwise
     */
    public boolean deleteSetting(int settingID) {
        String sql = "DELETE FROM Setting WHERE SettingID = ?";
        
        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setInt(1, settingID);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        
        return false;
    }
    
    /**
     * Check if setting value exists for a specific type (excluding a specific ID)
     * @param type Setting type
     * @param value Setting value
     * @param excludeSettingID Setting ID to exclude from check (for updates)
     * @return true if exists, false otherwise
     */
    public boolean isSettingValueExists(String type, String value, Integer excludeSettingID) {
        String sql = "SELECT COUNT(*) FROM Setting WHERE Type = ? AND Value = ?";
        if (excludeSettingID != null) {
            sql += " AND SettingID != ?";
        }
        
        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setString(1, type);
            ps.setString(2, value);
            if (excludeSettingID != null) {
                ps.setInt(3, excludeSettingID);
            }
            
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
     * Get distinct setting types
     * @return List of distinct types
     */
    public List<String> getDistinctTypes() {
        List<String> types = new ArrayList<>();
        String sql = "SELECT DISTINCT Type FROM Setting ORDER BY Type";
        
        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            
            while (rs.next()) {
                types.add(rs.getString("Type"));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        
        return types;
    }
    
    /**
     * Get settings with pagination
     * @param page Page number (1-based)
     * @param pageSize Number of items per page
     * @param typeFilter Type filter (optional)
     * @return List of settings
     */
    public List<Setting> getSettings(int page, int pageSize, String typeFilter) {
        List<Setting> settings = new ArrayList<>();
        String sql = "SELECT * FROM Setting";
        
        if (typeFilter != null && !typeFilter.trim().isEmpty()) {
            sql += " WHERE Type = ?";
        }
        
        sql += " ORDER BY Type, Value LIMIT ? OFFSET ?";
        
        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            int paramIndex = 1;
            if (typeFilter != null && !typeFilter.trim().isEmpty()) {
                ps.setString(paramIndex++, typeFilter);
            }
            
            ps.setInt(paramIndex++, pageSize);
            ps.setInt(paramIndex, (page - 1) * pageSize);
            
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                Setting setting = new Setting();
                setting.setSettingID(rs.getInt("SettingID"));
                setting.setType(rs.getString("Type"));
                setting.setValue(rs.getString("Value"));
                setting.setDescription(rs.getString("Description"));
                setting.setActive(rs.getBoolean("IsActive"));
                settings.add(setting);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        
        return settings;
    }
    
    /**
     * Get total count of settings
     * @param typeFilter Type filter (optional)
     * @return Total count
     */
    public int getTotalSettingsCount(String typeFilter) {
        String sql = "SELECT COUNT(*) FROM Setting";
        
        if (typeFilter != null && !typeFilter.trim().isEmpty()) {
            sql += " WHERE Type = ?";
        }
        
        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            if (typeFilter != null && !typeFilter.trim().isEmpty()) {
                ps.setString(1, typeFilter);
            }
            
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return rs.getInt(1);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        
        return 0;
    }
}