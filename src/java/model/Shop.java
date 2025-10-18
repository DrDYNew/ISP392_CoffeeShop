package model;

import java.sql.Timestamp;

public class Shop {
    private int shopID;
    private String shopName;
    private String address;
    private String phone;
    private Integer ownerID;
    private String apiToken;
    private boolean isActive;
    private Timestamp createdAt;

    // Default constructor
    public Shop() {
    }

    // Constructor with all fields
    public Shop(int shopID, String shopName, String address, String phone, Integer ownerID,
               String apiToken, boolean isActive, Timestamp createdAt) {
        this.shopID = shopID;
        this.shopName = shopName;
        this.address = address;
        this.phone = phone;
        this.ownerID = ownerID;
        this.apiToken = apiToken;
        this.isActive = isActive;
        this.createdAt = createdAt;
    }

    // Constructor without ID and timestamp (for insert operations)
    public Shop(String shopName, String address, String phone, Integer ownerID, 
               String apiToken, boolean isActive) {
        this.shopName = shopName;
        this.address = address;
        this.phone = phone;
        this.ownerID = ownerID;
        this.apiToken = apiToken;
        this.isActive = isActive;
    }

    // Getters and Setters
    public int getShopID() {
        return shopID;
    }

    public void setShopID(int shopID) {
        this.shopID = shopID;
    }

    public String getShopName() {
        return shopName;
    }

    public void setShopName(String shopName) {
        this.shopName = shopName;
    }

    public String getAddress() {
        return address;
    }

    public void setAddress(String address) {
        this.address = address;
    }

    public String getPhone() {
        return phone;
    }

    public void setPhone(String phone) {
        this.phone = phone;
    }

    public Integer getOwnerID() {
        return ownerID;
    }

    public void setOwnerID(Integer ownerID) {
        this.ownerID = ownerID;
    }

    public String getApiToken() {
        return apiToken;
    }

    public void setApiToken(String apiToken) {
        this.apiToken = apiToken;
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

    public String toString() {
        return "Shop{" +
                "shopID=" + shopID +
                ", shopName='" + shopName + '\'' +
                ", address='" + address + '\'' +
                ", phone='" + phone + '\'' +
                ", ownerID=" + ownerID +
                ", apiToken='" + apiToken + '\'' +
                ", isActive=" + isActive +
                ", createdAt=" + createdAt +
                '}';
    }
}