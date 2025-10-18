package services;

import dao.ShopDAO;
import model.Shop;
import java.util.List;

/**
 * Service layer for Shop business logic
 */
public class ShopService {
    
    private final ShopDAO shopDAO;
    
    public ShopService() {
        this.shopDAO = new ShopDAO();
    }
    
    /**
     * Get all shops
     */
    public List<Shop> getAllShops() {
        return shopDAO.getAllShops();
    }
    
    /**
     * Get active shops only
     */
    public List<Shop> getActiveShops() {
        return shopDAO.getActiveShops();
    }
    
    /**
     * Get shop by ID
     */
    public Shop getShopById(int shopId) {
        return shopDAO.getShopById(shopId);
    }
    
    /**
     * Get shop by API Token (for public access)
     */
    public Shop getShopByApiToken(String apiToken) {
        if (apiToken == null || apiToken.trim().isEmpty()) {
            return null;
        }
        return shopDAO.getShopByApiToken(apiToken.trim());
    }
    
    /**
     * Create new shop
     */
    public int createShop(String shopName, String address, String phone, Integer ownerId, boolean isActive) {
        // Validate input
        if (shopName == null || shopName.trim().isEmpty()) {
            throw new IllegalArgumentException("Shop name is required");
        }
        if (address == null || address.trim().isEmpty()) {
            throw new IllegalArgumentException("Address is required");
        }
        if (phone == null || phone.trim().isEmpty()) {
            throw new IllegalArgumentException("Phone is required");
        }
        
        Shop shop = new Shop(shopName, address, phone, ownerId, null, isActive);
        return shopDAO.insertShop(shop);
    }
    
    /**
     * Update shop information
     */
    public boolean updateShop(int shopId, String shopName, String address, String phone, Integer ownerId, boolean isActive) {
        // Validate input
        if (shopName == null || shopName.trim().isEmpty()) {
            throw new IllegalArgumentException("Shop name is required");
        }
        if (address == null || address.trim().isEmpty()) {
            throw new IllegalArgumentException("Address is required");
        }
        if (phone == null || phone.trim().isEmpty()) {
            throw new IllegalArgumentException("Phone is required");
        }
        
        Shop shop = shopDAO.getShopById(shopId);
        if (shop == null) {
            return false;
        }
        
        shop.setShopName(shopName);
        shop.setAddress(address);
        shop.setPhone(phone);
        shop.setOwnerID(ownerId);
        shop.setActive(isActive);
        
        return shopDAO.updateShop(shop);
    }
    
    /**
     * Delete shop (soft delete)
     */
    public boolean deleteShop(int shopId) {
        Shop shop = shopDAO.getShopById(shopId);
        if (shop == null) {
            return false;
        }
        return shopDAO.deleteShop(shopId);
    }
    
    /**
     * Regenerate API Token for a shop
     */
    public String regenerateApiToken(int shopId) {
        Shop shop = shopDAO.getShopById(shopId);
        if (shop == null) {
            return null;
        }
        return shopDAO.regenerateApiToken(shopId);
    }
    
    /**
     * Validate API Token
     */
    public boolean validateApiToken(String apiToken) {
        if (apiToken == null || apiToken.trim().isEmpty()) {
            return false;
        }
        return shopDAO.isApiTokenValid(apiToken.trim());
    }
    
    /**
     * Check if API Token is valid (alias for validateApiToken)
     */
    public boolean isApiTokenValid(String apiToken) {
        return validateApiToken(apiToken);
    }
    
    /**
     * Search shops by name
     */
    public List<Shop> searchShopsByName(String keyword) {
        if (keyword == null || keyword.trim().isEmpty()) {
            return getAllShops();
        }
        return shopDAO.searchShopsByName(keyword.trim());
    }
}
