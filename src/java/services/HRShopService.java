package services;

import dao.ShopDAO;
import dao.SystemConfigDAO;
import model.Shop;

import java.util.List;

/**
 * Service layer cho HR xem thông tin Shop
 */
public class HRShopService {
    
    private final ShopDAO shopDAO;
    private final SystemConfigDAO configDAO;
    
    public HRShopService() {
        this.shopDAO = new ShopDAO();
        this.configDAO = new SystemConfigDAO();
    }
    
    /**
     * Lấy danh sách tất cả shops với Master Token
     */
    public List<Shop> getAllShopsWithMasterToken(String masterToken) {
        if (masterToken == null || masterToken.trim().isEmpty()) {
            throw new IllegalArgumentException("Master API Token không được để trống!");
        }
        
        if (!configDAO.isMasterTokenValid(masterToken.trim())) {
            throw new SecurityException("Master API Token không hợp lệ!");
        }
        
        return shopDAO.getAllShops();
    }
    
    /**
     * Lấy thông tin chi tiết 1 shop với Shop Token
     */
    public Shop getShopByToken(String shopToken) {
        if (shopToken == null || shopToken.trim().isEmpty()) {
            throw new IllegalArgumentException("Shop API Token không được để trống!");
        }
        
        Shop shop = shopDAO.getShopByApiToken(shopToken.trim());
        
        if (shop == null) {
            throw new SecurityException("Shop API Token không hợp lệ hoặc shop không hoạt động!");
        }
        
        return shop;
    }
    
    /**
     * Kiểm tra Master Token có hợp lệ không
     */
    public boolean validateMasterToken(String masterToken) {
        return configDAO.isMasterTokenValid(masterToken);
    }
    
    /**
     * Kiểm tra Shop Token có hợp lệ không
     */
    public boolean validateShopToken(String shopToken) {
        return shopDAO.isApiTokenValid(shopToken);
    }
    
    /**
     * Lấy Master Token hiện tại (chỉ cho admin/super user)
     */
    public String getCurrentMasterToken() {
        return configDAO.getConfigValue("MASTER_API_TOKEN");
    }
    
    /**
     * Regenerate Master Token (chỉ cho admin)
     */
    public String regenerateMasterToken() {
        return configDAO.regenerateMasterToken();
    }
    
    /**
     * Lấy danh sách shops đang hoạt động
     */
    public List<Shop> getActiveShops() {
        return shopDAO.getActiveShops();
    }
    
    /**
     * Đếm tổng số shops
     */
    public int getTotalShopsCount() {
        return shopDAO.getAllShops().size();
    }
    
    /**
     * Đếm số shops đang hoạt động
     */
    public int getActiveShopsCount() {
        return shopDAO.getActiveShops().size();
    }
}
