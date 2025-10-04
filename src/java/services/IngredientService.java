/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package services;

import dao.IngredientDAO;
import model.Ingredient;
import model.Setting;
import model.Supplier;
import java.util.List;
import java.math.BigDecimal;

/**
 * Service class for Ingredient management
 * @author DrDYNew
 */
public class IngredientService {
    
    private IngredientDAO ingredientDAO;
    
    public IngredientService() {
        this.ingredientDAO = new IngredientDAO();
    }
    
    /**
     * Get all ingredients with pagination and filtering
     * @param page Page number
     * @param pageSize Page size
     * @param supplierFilter Supplier filter
     * @param searchKeyword Search keyword
     * @param activeOnly Show only active ingredients
     * @return List of ingredients
     */
    public List<Ingredient> getAllIngredients(int page, int pageSize, Integer supplierFilter, 
                                            String searchKeyword, Boolean activeOnly) {
        return ingredientDAO.getAllIngredients(page, pageSize, supplierFilter, searchKeyword, activeOnly);
    }
    
    /**
     * Get total count of ingredients with filters
     * @param supplierFilter Supplier filter
     * @param searchKeyword Search keyword
     * @param activeOnly Show only active ingredients
     * @return Total count
     */
    public int getTotalIngredientsCount(Integer supplierFilter, String searchKeyword, Boolean activeOnly) {
        return ingredientDAO.getTotalIngredientsCount(supplierFilter, searchKeyword, activeOnly);
    }
    
    /**
     * Get ingredient by ID
     * @param ingredientID Ingredient ID
     * @return Ingredient object
     */
    public Ingredient getIngredientById(int ingredientID) {
        return ingredientDAO.getIngredientById(ingredientID);
    }
    
    /**
     * Create new ingredient with validation
     * @param ingredient Ingredient to create
     * @return Result object with success status and message
     */
    public IngredientResult createIngredient(Ingredient ingredient) {
        // Validate input
        if (ingredient.getName() == null || ingredient.getName().trim().isEmpty()) {
            return new IngredientResult(false, "Tên nguyên liệu không được để trống");
        }
        
        if (ingredient.getStockQuantity() == null || ingredient.getStockQuantity().compareTo(BigDecimal.ZERO) < 0) {
            return new IngredientResult(false, "Số lượng tồn kho phải lớn hơn hoặc bằng 0");
        }
        
        // Check if name already exists
        if (ingredientDAO.isIngredientNameExists(ingredient.getName(), null)) {
            return new IngredientResult(false, "Tên nguyên liệu đã tồn tại");
        }
        
        // Set default values
        ingredient.setName(ingredient.getName().trim());
        if (ingredient.getStockQuantity() == null) {
            ingredient.setStockQuantity(BigDecimal.ZERO);
        }
        
        int ingredientID = ingredientDAO.createIngredient(ingredient);
        
        if (ingredientID > 0) {
            return new IngredientResult(true, "Thêm nguyên liệu thành công", ingredientID);
        } else {
            return new IngredientResult(false, "Có lỗi xảy ra khi thêm nguyên liệu");
        }
    }
    
    /**
     * Update ingredient with validation
     * @param ingredient Ingredient to update
     * @return Result object with success status and message
     */
    public IngredientResult updateIngredient(Ingredient ingredient) {
        // Validate input
        if (ingredient.getIngredientID() <= 0) {
            return new IngredientResult(false, "ID nguyên liệu không hợp lệ");
        }
        
        if (ingredient.getName() == null || ingredient.getName().trim().isEmpty()) {
            return new IngredientResult(false, "Tên nguyên liệu không được để trống");
        }
        
        if (ingredient.getStockQuantity() == null || ingredient.getStockQuantity().compareTo(BigDecimal.ZERO) < 0) {
            return new IngredientResult(false, "Số lượng tồn kho phải lớn hơn hoặc bằng 0");
        }
        
        // Check if ingredient exists
        Ingredient existingIngredient = ingredientDAO.getIngredientById(ingredient.getIngredientID());
        if (existingIngredient == null) {
            return new IngredientResult(false, "Nguyên liệu không tồn tại");
        }
        
        // Check if name already exists (excluding current ingredient)
        if (ingredientDAO.isIngredientNameExists(ingredient.getName(), ingredient.getIngredientID())) {
            return new IngredientResult(false, "Tên nguyên liệu đã tồn tại");
        }
        
        // Set values
        ingredient.setName(ingredient.getName().trim());
        
        boolean success = ingredientDAO.updateIngredient(ingredient);
        
        if (success) {
            return new IngredientResult(true, "Cập nhật nguyên liệu thành công");
        } else {
            return new IngredientResult(false, "Có lỗi xảy ra khi cập nhật nguyên liệu");
        }
    }
    
    /**
     * Delete ingredient (soft delete)
     * @param ingredientID Ingredient ID to delete
     * @return Result object with success status and message
     */
    public IngredientResult deleteIngredient(int ingredientID) {
        if (ingredientID <= 0) {
            return new IngredientResult(false, "ID nguyên liệu không hợp lệ");
        }
        
        // Check if ingredient exists
        Ingredient existingIngredient = ingredientDAO.getIngredientById(ingredientID);
        if (existingIngredient == null) {
            return new IngredientResult(false, "Nguyên liệu không tồn tại");
        }
        
        if (!existingIngredient.isActive()) {
            return new IngredientResult(false, "Nguyên liệu đã bị xóa");
        }
        
        boolean success = ingredientDAO.deleteIngredient(ingredientID);
        
        if (success) {
            return new IngredientResult(true, "Xóa nguyên liệu thành công");
        } else {
            return new IngredientResult(false, "Có lỗi xảy ra khi xóa nguyên liệu");
        }
    }
    
    /**
     * Get all available units
     * @return List of units
     */
    public List<Setting> getAvailableUnits() {
        return ingredientDAO.getAvailableUnits();
    }
    
    /**
     * Get all active suppliers
     * @return List of suppliers
     */
    public List<Supplier> getActiveSuppliers() {
        return ingredientDAO.getActiveSuppliers();
    }
    
    /**
     * Get ingredients with low stock
     * @param threshold Minimum stock threshold
     * @return List of low stock ingredients
     */
    public List<Ingredient> getLowStockIngredients(BigDecimal threshold) {
        if (threshold == null) {
            threshold = new BigDecimal("10.0"); // Default threshold
        }
        return ingredientDAO.getLowStockIngredients(threshold);
    }
    
    /**
     * Update ingredient stock quantity
     * @param ingredientID Ingredient ID
     * @param newQuantity New stock quantity
     * @return Result object
     */
    public IngredientResult updateStockQuantity(int ingredientID, BigDecimal newQuantity) {
        if (ingredientID <= 0) {
            return new IngredientResult(false, "ID nguyên liệu không hợp lệ");
        }
        
        if (newQuantity == null || newQuantity.compareTo(BigDecimal.ZERO) < 0) {
            return new IngredientResult(false, "Số lượng tồn kho phải lớn hơn hoặc bằng 0");
        }
        
        // Check if ingredient exists
        Ingredient existingIngredient = ingredientDAO.getIngredientById(ingredientID);
        if (existingIngredient == null) {
            return new IngredientResult(false, "Nguyên liệu không tồn tại");
        }
        
        boolean success = ingredientDAO.updateStockQuantity(ingredientID, newQuantity);
        
        if (success) {
            return new IngredientResult(true, "Cập nhật số lượng tồn kho thành công");
        } else {
            return new IngredientResult(false, "Có lỗi xảy ra khi cập nhật số lượng tồn kho");
        }
    }
    
    /**
     * Inner class for service operation results
     */
    public static class IngredientResult {
        private boolean success;
        private String message;
        private int generatedId;
        
        public IngredientResult(boolean success, String message) {
            this.success = success;
            this.message = message;
        }
        
        public IngredientResult(boolean success, String message, int generatedId) {
            this.success = success;
            this.message = message;
            this.generatedId = generatedId;
        }
        
        public boolean isSuccess() {
            return success;
        }
        
        public String getMessage() {
            return message;
        }
        
        public int getGeneratedId() {
            return generatedId;
        }
    }
}