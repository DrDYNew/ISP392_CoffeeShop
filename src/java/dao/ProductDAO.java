package dao;

import model.Product;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;
import java.math.BigDecimal;

public class ProductDAO extends BaseDAO{
    
    /**
     * Get all products with pagination
     */
    public List<Product> getAllProducts(int page, int pageSize, String searchTerm, Integer categoryId, Boolean isActive) {
        List<Product> products = new ArrayList<>();
        String sql = "SELECT p.*, s1.Value as CategoryName, sup.SupplierName " +
                    "FROM Products p " +
                    "LEFT JOIN Setting s1 ON p.CategoryID = s1.SettingID " +
                    "LEFT JOIN Suppliers sup ON p.SupplierID = sup.SupplierID " +
                    "WHERE 1=1 ";
        
        if (searchTerm != null && !searchTerm.trim().isEmpty()) {
            sql += "AND (LOWER(p.ProductName) LIKE LOWER(?) OR LOWER(p.Description) LIKE LOWER(?)) ";
        }
        if (categoryId != null) {
            sql += "AND p.CategoryID = ? ";
        }
        if (isActive != null) {
            sql += "AND p.IsActive = ? ";
        }
        
        sql += "ORDER BY p.ProductID DESC LIMIT ? OFFSET ?";
        
        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            int paramIndex = 1;
            
            if (searchTerm != null && !searchTerm.trim().isEmpty()) {
                String searchPattern = "%" + searchTerm + "%";
                ps.setString(paramIndex++, searchPattern);
                ps.setString(paramIndex++, searchPattern);
            }
            if (categoryId != null) {
                ps.setInt(paramIndex++, categoryId);
            }
            if (isActive != null) {
                ps.setBoolean(paramIndex++, isActive);
            }
            
            ps.setInt(paramIndex++, pageSize);
            ps.setInt(paramIndex++, (page - 1) * pageSize);
            
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                Product product = new Product();
                product.setProductID(rs.getInt("ProductID"));
                product.setProductName(rs.getString("ProductName"));
                product.setDescription(rs.getString("Description"));
                product.setCategoryID(rs.getInt("CategoryID"));
                product.setPrice(rs.getBigDecimal("Price"));
                product.setSupplierID(rs.getInt("SupplierID"));
                product.setActive(rs.getBoolean("IsActive"));
                product.setCreatedAt(rs.getTimestamp("CreatedAt"));
                
                // Set additional display fields
                product.setCategoryName(rs.getString("CategoryName"));
                product.setSupplierName(rs.getString("SupplierName"));
                
                products.add(product);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return products;
    }
    
    /**
     * Get total count of products for pagination
     */
    public int getTotalProductsCount(String searchTerm, Integer categoryId, Boolean isActive) {
        String sql = "SELECT COUNT(*) FROM Products p WHERE 1=1 ";
        
        if (searchTerm != null && !searchTerm.trim().isEmpty()) {
            sql += "AND (LOWER(p.ProductName) LIKE LOWER(?) OR LOWER(p.Description) LIKE LOWER(?)) ";
        }
        if (categoryId != null) {
            sql += "AND p.CategoryID = ? ";
        }
        if (isActive != null) {
            sql += "AND p.IsActive = ? ";
        }
        
        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            int paramIndex = 1;
            
            if (searchTerm != null && !searchTerm.trim().isEmpty()) {
                String searchPattern = "%" + searchTerm + "%";
                ps.setString(paramIndex++, searchPattern);
                ps.setString(paramIndex++, searchPattern);
            }
            if (categoryId != null) {
                ps.setInt(paramIndex++, categoryId);
            }
            if (isActive != null) {
                ps.setBoolean(paramIndex++, isActive);
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
    
    /**
     * Get product by ID
     */
    public Product getProductById(int productId) {
        String sql = "SELECT p.*, s1.Value as CategoryName, sup.SupplierName " +
                    "FROM Products p " +
                    "LEFT JOIN Setting s1 ON p.CategoryID = s1.SettingID " +
                    "LEFT JOIN Suppliers sup ON p.SupplierID = sup.SupplierID " +
                    "WHERE p.ProductID = ?";
        
        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, productId);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                Product product = new Product();
                product.setProductID(rs.getInt("ProductID"));
                product.setProductName(rs.getString("ProductName"));
                product.setDescription(rs.getString("Description"));
                product.setCategoryID(rs.getInt("CategoryID"));
                product.setPrice(rs.getBigDecimal("Price"));
                product.setSupplierID(rs.getInt("SupplierID"));
                product.setActive(rs.getBoolean("IsActive"));
                product.setCreatedAt(rs.getTimestamp("CreatedAt"));
                
                // Set additional display fields
                product.setCategoryName(rs.getString("CategoryName"));
                product.setSupplierName(rs.getString("SupplierName"));
                
                return product;
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }
    
    /**
     * Create new product
     */
    public boolean createProduct(Product product) {
        String sql = "INSERT INTO Products (ProductName, Description, CategoryID, Price, SupplierID, IsActive) " +
                    "VALUES (?, ?, ?, ?, ?, ?)";
        
        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, product.getProductName());
            ps.setString(2, product.getDescription());
            ps.setInt(3, product.getCategoryID());
            ps.setBigDecimal(4, product.getPrice());
            ps.setInt(5, product.getSupplierID());
            ps.setBoolean(6, product.isActive());
            
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }
    
    /**
     * Update product
     */
    public boolean updateProduct(Product product) {
        String sql = "UPDATE Products SET ProductName = ?, Description = ?, CategoryID = ?, " +
                    "Price = ?, SupplierID = ?, IsActive = ? WHERE ProductID = ?";
        
        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, product.getProductName());
            ps.setString(2, product.getDescription());
            ps.setInt(3, product.getCategoryID());
            ps.setBigDecimal(4, product.getPrice());
            ps.setInt(5, product.getSupplierID());
            ps.setBoolean(6, product.isActive());
            ps.setInt(7, product.getProductID());
            
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }
    
    /**
     * Delete product (soft delete)
     */
    public boolean deleteProduct(int productId) {
        String sql = "UPDATE Products SET IsActive = FALSE WHERE ProductID = ?";
        
        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, productId);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }
    
    /**
     * Get categories for dropdown
     */
    public List<Object[]> getCategories() {
        List<Object[]> categories = new ArrayList<>();
        String sql = "SELECT SettingID, Value FROM Setting WHERE Type = 'Category' AND IsActive = TRUE ORDER BY Value";
        
        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                categories.add(new Object[]{rs.getInt("SettingID"), rs.getString("Value")});
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return categories;
    }
    
    /**
     * Get suppliers for dropdown
     */
    public List<Object[]> getSuppliers() {
        List<Object[]> suppliers = new ArrayList<>();
        String sql = "SELECT SupplierID, SupplierName FROM Suppliers WHERE IsActive = TRUE ORDER BY SupplierName";
        
        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                suppliers.add(new Object[]{rs.getInt("SupplierID"), rs.getString("SupplierName")});
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return suppliers;
    }
    
    /**
     * Get products by supplier ID
     */
    public List<Product> getProductsBySupplier(int supplierId) {
        List<Product> products = new ArrayList<>();
        String sql = "SELECT p.*, s1.Value as CategoryName, sup.SupplierName " +
                    "FROM Products p " +
                    "LEFT JOIN Setting s1 ON p.CategoryID = s1.SettingID " +
                    "LEFT JOIN Suppliers sup ON p.SupplierID = sup.SupplierID " +
                    "WHERE p.SupplierID = ? " +
                    "ORDER BY p.ProductName";
        
        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setInt(1, supplierId);
            ResultSet rs = ps.executeQuery();
            
            while (rs.next()) {
                Product product = new Product();
                product.setProductID(rs.getInt("ProductID"));
                product.setProductName(rs.getString("ProductName"));
                product.setDescription(rs.getString("Description"));
                product.setCategoryID(rs.getInt("CategoryID"));
                product.setPrice(rs.getBigDecimal("Price"));
                product.setSupplierID(rs.getInt("SupplierID"));
                product.setActive(rs.getBoolean("IsActive"));
                product.setCreatedAt(rs.getTimestamp("CreatedAt"));
                
                // Set additional display fields
                product.setCategoryName(rs.getString("CategoryName"));
                product.setSupplierName(rs.getString("SupplierName"));
                
                products.add(product);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return products;
    }
}