package model;

import java.sql.Timestamp;

public class PurchaseOrder {
    private int poID;
    private int shopID;
    private int supplierID;
    private int createdBy;
    private int statusID;
    private Timestamp createdAt;

    // Default constructor
    public PurchaseOrder() {
    }

    // Constructor with all fields
    public PurchaseOrder(int poID, int shopID, int supplierID, int createdBy, 
                        int statusID, Timestamp createdAt) {
        this.poID = poID;
        this.shopID = shopID;
        this.supplierID = supplierID;
        this.createdBy = createdBy;
        this.statusID = statusID;
        this.createdAt = createdAt;
    }

    // Constructor without ID and timestamp (for insert operations)
    public PurchaseOrder(int shopID, int supplierID, int createdBy, int statusID) {
        this.shopID = shopID;
        this.supplierID = supplierID;
        this.createdBy = createdBy;
        this.statusID = statusID;
    }

    // Getters and Setters
    public int getPoID() {
        return poID;
    }

    public void setPoID(int poID) {
        this.poID = poID;
    }

    public int getShopID() {
        return shopID;
    }

    public void setShopID(int shopID) {
        this.shopID = shopID;
    }

    public int getSupplierID() {
        return supplierID;
    }

    public void setSupplierID(int supplierID) {
        this.supplierID = supplierID;
    }

    public int getCreatedBy() {
        return createdBy;
    }

    public void setCreatedBy(int createdBy) {
        this.createdBy = createdBy;
    }

    public int getStatusID() {
        return statusID;
    }

    public void setStatusID(int statusID) {
        this.statusID = statusID;
    }

    public Timestamp getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(Timestamp createdAt) {
        this.createdAt = createdAt;
    }

    public String toString() {
        return "PurchaseOrder{" +
                "poID=" + poID +
                ", shopID=" + shopID +
                ", supplierID=" + supplierID +
                ", createdBy=" + createdBy +
                ", statusID=" + statusID +
                ", createdAt=" + createdAt +
                '}';
    }
}