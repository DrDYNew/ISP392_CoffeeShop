package models;

import java.sql.Timestamp;

public class Order {
    private int orderID;
    private int shopID;
    private int createdBy;
    private int statusID;
    private Timestamp createdAt;

    // Default constructor
    public Order() {
    }

    // Constructor with all fields
    public Order(int orderID, int shopID, int createdBy, int statusID, Timestamp createdAt) {
        this.orderID = orderID;
        this.shopID = shopID;
        this.createdBy = createdBy;
        this.statusID = statusID;
        this.createdAt = createdAt;
    }

    // Constructor without ID and timestamp (for insert operations)
    public Order(int shopID, int createdBy, int statusID) {
        this.shopID = shopID;
        this.createdBy = createdBy;
        this.statusID = statusID;
    }

    // Getters and Setters
    public int getOrderID() {
        return orderID;
    }

    public void setOrderID(int orderID) {
        this.orderID = orderID;
    }

    public int getShopID() {
        return shopID;
    }

    public void setShopID(int shopID) {
        this.shopID = shopID;
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
        return "Order{" +
                "orderID=" + orderID +
                ", shopID=" + shopID +
                ", createdBy=" + createdBy +
                ", statusID=" + statusID +
                ", createdAt=" + createdAt +
                '}';
    }
}