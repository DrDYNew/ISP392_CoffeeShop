package services;

import dao.SettingDAO;
import model.Setting;
import java.util.List;

/**
 * Service class for Setting management
 */
public class SettingService {
    private SettingDAO settingDAO;
    
    public SettingService() {
        this.settingDAO = new SettingDAO();
    }
    
    /**
     * Get all settings
     * @return List of all settings
     */
    public List<Setting> getAllSettings() {
        return settingDAO.getAllSettings();
    }
    
    /**
     * Get settings by type
     * @param type Setting type
     * @return List of settings
     */
    public List<Setting> getSettingsByType(String type) {
        return settingDAO.getSettingsByType(type);
    }
    
    /**
     * Get setting by ID
     * @param settingID Setting ID
     * @return Setting object
     */
    public Setting getSettingById(int settingID) {
        return settingDAO.getSettingById(settingID);
    }
    
    /**
     * Get settings with pagination
     * @param page Page number
     * @param pageSize Page size
     * @param typeFilter Type filter
     * @return List of settings
     */
    public List<Setting> getSettings(int page, int pageSize, String typeFilter) {
        return settingDAO.getSettings(page, pageSize, typeFilter);
    }
    
    /**
     * Get total settings count
     * @param typeFilter Type filter
     * @return Total count
     */
    public int getTotalSettingsCount(String typeFilter) {
        return settingDAO.getTotalSettingsCount(typeFilter);
    }
    
    /**
     * Get distinct types
     * @return List of types
     */
    public List<String> getDistinctTypes() {
        return settingDAO.getDistinctTypes();
    }
    
    /**
     * Validate setting data
     * @param setting Setting object
     * @param isUpdate true if this is an update operation
     * @return Error message if validation fails, null if valid
     */
    public String validateSetting(Setting setting, boolean isUpdate) {
        // Validate required fields
        if (setting.getType() == null || setting.getType().trim().isEmpty()) {
            return "Loại cài đặt không được để trống";
        }
        
        if (setting.getValue() == null || setting.getValue().trim().isEmpty()) {
            return "Giá trị không được để trống";
        }
        
        // Validate type format
        if (!isValidType(setting.getType())) {
            return "Loại cài đặt không hợp lệ. Chỉ được sử dụng chữ cái, số và dấu gạch dưới";
        }
        
        // Validate value format
        if (!isValidValue(setting.getValue())) {
            return "Giá trị không hợp lệ. Không được chứa ký tự đặc biệt";
        }
        
        // Check uniqueness of value within type
        Integer excludeSettingID = isUpdate ? setting.getSettingID() : null;
        if (settingDAO.isSettingValueExists(setting.getType(), setting.getValue(), excludeSettingID)) {
            return "Giá trị này đã tồn tại trong loại cài đặt";
        }
        
        return null; // No validation errors
    }
    
    /**
     * Create new setting
     * @param setting Setting object
     * @return Error message if failed, null if successful
     */
    public String createSetting(Setting setting) {
        // Validate setting data
        String validationError = validateSetting(setting, false);
        if (validationError != null) {
            return validationError;
        }
        
        // Create setting
        if (settingDAO.createSetting(setting)) {
            return null; // Success
        } else {
            return "Lỗi hệ thống khi tạo cài đặt";
        }
    }
    
    /**
     * Update existing setting
     * @param setting Setting object
     * @return Error message if failed, null if successful
     */
    public String updateSetting(Setting setting) {
        // Check if setting exists
        Setting existingSetting = settingDAO.getSettingById(setting.getSettingID());
        if (existingSetting == null) {
            return "Không tìm thấy cài đặt";
        }
        
        // Validate setting data
        String validationError = validateSetting(setting, true);
        if (validationError != null) {
            return validationError;
        }
        
        // Update setting
        if (settingDAO.updateSetting(setting)) {
            return null; // Success
        } else {
            return "Lỗi hệ thống khi cập nhật cài đặt";
        }
    }
    
    /**
     * Delete setting
     * @param settingID Setting ID
     * @return Error message if failed, null if successful
     */
    public String deleteSetting(int settingID) {
        // Check if setting exists
        Setting setting = settingDAO.getSettingById(settingID);
        if (setting == null) {
            return "Không tìm thấy cài đặt";
        }
        
        // Check if setting is being used (basic validation)
        // Note: This would need more comprehensive checking based on business rules
        if (isSettingInUse(settingID)) {
            return "Không thể xóa cài đặt này vì đang được sử dụng trong hệ thống";
        }
        
        // Delete setting
        if (settingDAO.deleteSetting(settingID)) {
            return null; // Success
        } else {
            return "Lỗi hệ thống khi xóa cài đặt";
        }
    }
    
    /**
     * Validate type format
     * @param type Type value
     * @return true if valid
     */
    private boolean isValidType(String type) {
        // Allow letters, numbers, and underscores
        return type.matches("^[a-zA-Z][a-zA-Z0-9_]*$");
    }
    
    /**
     * Validate value format
     * @param value Value
     * @return true if valid
     */
    private boolean isValidValue(String value) {
        // Allow letters, numbers, spaces, and basic punctuation
        return value.matches("^[a-zA-Z0-9\\s\\-_.,()&]+$");
    }
    
    /**
     * Check if setting is being used in the system
     * @param settingID Setting ID
     * @return true if in use
     */
    private boolean isSettingInUse(int settingID) {
        // TODO: Implement comprehensive checking
        // This should check if the setting is referenced in:
        // - Users table (RoleID)
        // - Products table (CategoryID)
        // - Ingredients table (UnitID)
        // - PurchaseOrders table (StatusID)
        // - Issues table (StatusID)
        // - Orders table (StatusID)
        
        // For now, return false to allow deletion
        // In production, implement proper foreign key checking
        return false;
    }
}