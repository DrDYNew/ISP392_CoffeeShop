package services;

import dao.ProductDAO;
import model.Product;
import java.util.List;
import java.math.BigDecimal;

public class ProductService {
    
    private ProductDAO productDAO;
    
    public ProductService() {
        this.productDAO = new ProductDAO();
    }
    
    /**
     * Get all products with pagination and filters
     */
    public List<Product> getAllProducts(int page, int pageSize, String searchTerm, Integer categoryId, Boolean isActive) {
        return productDAO.getAllProducts(page, pageSize, searchTerm, categoryId, isActive);
    }
    
    /**
     * Get total count for pagination
     */
    public int getTotalProductsCount(String searchTerm, Integer categoryId, Boolean isActive) {
        return productDAO.getTotalProductsCount(searchTerm, categoryId, isActive);
    }
    
    /**
     * Get product by ID
     */
    public Product getProductById(int productId) {
        return productDAO.getProductById(productId);
    }
    
    /**
     * Create new product with validation
     */
    public boolean createProduct(Product product) throws Exception {
        // Validate product data
        validateProduct(product);
        
        // Check if product name already exists
        if (isProductNameExists(product.getProductName(), null)) {
            throw new Exception("Tên sản phẩm đã tồn tại");
        }
        
        return productDAO.createProduct(product);
    }
    
    /**
     * Update product with validation
     */
    public boolean updateProduct(Product product) throws Exception {
        // Validate product data
        validateProduct(product);
        
        // Check if product name already exists (excluding current product)
        if (isProductNameExists(product.getProductName(), product.getProductID())) {
            throw new Exception("Tên sản phẩm đã tồn tại");
        }
        
        return productDAO.updateProduct(product);
    }
    
    /**
     * Delete product (soft delete)
     */
    public boolean deleteProduct(int productId) {
        return productDAO.deleteProduct(productId);
    }
    
    /**
     * Get categories for dropdown
     */
    public List<Object[]> getCategories() {
        return productDAO.getCategories();
    }
    
    /**
     * Get suppliers for dropdown
     */
    public List<Object[]> getSuppliers() {
        return productDAO.getSuppliers();
    }
    
    /**
     * Validate product data
     */
    private void validateProduct(Product product) throws Exception {
        if (product.getProductName() == null || product.getProductName().trim().isEmpty()) {
            throw new Exception("Tên sản phẩm không được để trống");
        }
        
        if (product.getProductName().length() > 100) {
            throw new Exception("Tên sản phẩm không được vượt quá 100 ký tự");
        }
        
        if (product.getDescription() != null && product.getDescription().length() > 255) {
            throw new Exception("Mô tả không được vượt quá 255 ký tự");
        }
        
        if (product.getCategoryID() <= 0) {
            throw new Exception("Vui lòng chọn danh mục");
        }
        
        if (product.getPrice() == null || product.getPrice().compareTo(BigDecimal.ZERO) <= 0) {
            throw new Exception("Giá sản phẩm phải lớn hơn 0");
        }
        
        if (product.getSupplierID() <= 0) {
            throw new Exception("Vui lòng chọn nhà cung cấp");
        }
    }
    
    /**
     * Check if product name already exists
     */
    private boolean isProductNameExists(String productName, Integer excludeProductId) {
        // This would be implemented in DAO if needed
        // For now, we'll skip this check
        return false;
    }
    
    /**
     * Calculate total pages for pagination
     */
    public int getTotalPages(int totalRecords, int pageSize) {
        return (int) Math.ceil((double) totalRecords / pageSize);
    }
    
    /**
     * Get active products only
     */
    public List<Product> getActiveProducts(int page, int pageSize, String searchTerm, Integer categoryId) {
        return productDAO.getAllProducts(page, pageSize, searchTerm, categoryId, true);
    }
    
    /**
     * Toggle product status
     */
    public boolean toggleProductStatus(int productId) {
        Product product = productDAO.getProductById(productId);
        if (product != null) {
            product.setActive(!product.isActive());
            return productDAO.updateProduct(product);
        }
        return false;
    }
}