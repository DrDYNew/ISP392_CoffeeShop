package controllers;

import com.google.gson.Gson;
import services.ShopService;
import model.Shop;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.io.PrintWriter;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 * API Controller cho trang public xem shop (cần API Token)
 */
@WebServlet(name = "ShopAPIController", urlPatterns = {"/api/shop"})
public class ShopAPIController extends HttpServlet {

    private final ShopService shopService = new ShopService();
    private final Gson gson = new Gson();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        PrintWriter out = response.getWriter();

        String apiToken = request.getParameter("token");
        String action = request.getParameter("action");

        if (action == null) {
            action = "details";
        }

        Map<String, Object> result = new HashMap<>();

        // Validate API Token
        if (apiToken == null || apiToken.trim().isEmpty()) {
            result.put("success", false);
            result.put("message", "API Token is required");
            out.print(gson.toJson(result));
            return;
        }

        switch (action) {
            case "details":
                getShopDetails(apiToken, result);
                break;
            case "validate":
                validateToken(apiToken, result);
                break;
            default:
                result.put("success", false);
                result.put("message", "Invalid action");
                break;
        }

        out.print(gson.toJson(result));
    }

    /**
     * Lấy thông tin chi tiết shop theo API Token
     */
    private void getShopDetails(String apiToken, Map<String, Object> result) {
        Shop shop = shopService.getShopByApiToken(apiToken);
        
        if (shop != null) {
            Map<String, Object> shopData = new HashMap<>();
            shopData.put("shopID", shop.getShopID());
            shopData.put("shopName", shop.getShopName());
            shopData.put("address", shop.getAddress());
            shopData.put("phone", shop.getPhone());
            shopData.put("isActive", shop.isActive());
            shopData.put("createdAt", shop.getCreatedAt().toString());
            
            result.put("success", true);
            result.put("data", shopData);
        } else {
            result.put("success", false);
            result.put("message", "Invalid API Token or shop is inactive");
        }
    }

    /**
     * Validate API Token
     */
    private void validateToken(String apiToken, Map<String, Object> result) {
        boolean isValid = shopService.isApiTokenValid(apiToken);
        
        result.put("success", isValid);
        result.put("message", isValid ? "Token is valid" : "Token is invalid");
    }
}
