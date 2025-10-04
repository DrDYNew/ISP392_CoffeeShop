package model;

import java.math.BigDecimal;
import java.sql.Timestamp;

public class Product {
    private int productID;
    private String productName;
    private String description;
    private int categoryID;
    private BigDecimal price;
    private int supplierID;
    private boolean isActive;
    private Timestamp createdAt;
    
    // Additional fields for display purposes
    private String categoryName;
    private String supplierName;

    // Default constructor
    public Product() {
    }

    // Constructor with all fields
    public Product(int productID, String productName, String description, int categoryID, 
                  BigDecimal price, int supplierID, boolean isActive, Timestamp createdAt) {
        this.productID = productID;
        this.productName = productName;
        this.description = description;
        this.categoryID = categoryID;
        this.price = price;
        this.supplierID = supplierID;
        this.isActive = isActive;
        this.createdAt = createdAt;
    }

    // Constructor without ID and timestamp (for insert operations)
    public Product(String productName, String description, int categoryID, 
                  BigDecimal price, int supplierID, boolean isActive) {
        this.productName = productName;
        this.description = description;
        this.categoryID = categoryID;
        this.price = price;
        this.supplierID = supplierID;
        this.isActive = isActive;
    }

    // Getters and Setters
    public int getProductID() {
        return productID;
    }

    public void setProductID(int productID) {
        this.productID = productID;
    }

    public String getProductName() {
        return productName;
    }

    public void setProductName(String productName) {
        this.productName = productName;
    }

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }

    public int getCategoryID() {
        return categoryID;
    }

    public void setCategoryID(int categoryID) {
        this.categoryID = categoryID;
    }

    public BigDecimal getPrice() {
        return price;
    }

    public void setPrice(BigDecimal price) {
        this.price = price;
    }

    public int getSupplierID() {
        return supplierID;
    }

    public void setSupplierID(int supplierID) {
        this.supplierID = supplierID;
    }

    public boolean isActive() {
        return isActive;
    }

    public void setActive(boolean active) {
        isActive = active;
    }

    public Timestamp getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(Timestamp createdAt) {
        this.createdAt = createdAt;
    }

    public String getCategoryName() {
        return categoryName;
    }

    public void setCategoryName(String categoryName) {
        this.categoryName = categoryName;
    }

    public String getSupplierName() {
        return supplierName;
    }

    public void setSupplierName(String supplierName) {
        this.supplierName = supplierName;
    }

    public String toString() {
        return "Product{" +
                "productID=" + productID +
                ", productName='" + productName + '\'' +
                ", description='" + description + '\'' +
                ", categoryID=" + categoryID +
                ", price=" + price +
                ", supplierID=" + supplierID +
                ", isActive=" + isActive +
                ", createdAt=" + createdAt +
                '}';
    }
}