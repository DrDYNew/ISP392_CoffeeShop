package controllers;

import dao.UserDAO;
import model.Shop;
import model.User;
import services.ShopService;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.util.List;

/**
 * Controller để Admin quản lý Shop
 */
@WebServlet(name = "ShopController", urlPatterns = {"/admin/shop"})
public class ShopController extends HttpServlet {

    private final ShopService shopService = new ShopService();
    private final UserDAO userDAO = new UserDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");
        
        // Check if user is Admin
        if (user == null || user.getRoleID() != 2) { // RoleID 2 = Admin
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        String action = request.getParameter("action");
        if (action == null) {
            action = "list";
        }

        switch (action) {
            case "list":
                listShops(request, response);
                break;
            case "add":
                showAddForm(request, response);
                break;
            case "edit":
                showEditForm(request, response);
                break;
            case "delete":
                deleteShop(request, response);
                break;
            case "regenerateToken":
                regenerateToken(request, response);
                break;
            default:
                listShops(request, response);
                break;
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");
        
        // Check if user is Admin
        if (user == null || user.getRoleID() != 2) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        String action = request.getParameter("action");

        switch (action) {
            case "add":
                addShop(request, response);
                break;
            case "edit":
                editShop(request, response);
                break;
            default:
                listShops(request, response);
                break;
        }
    }

    /**
     * Hiển thị danh sách shop
     */
    private void listShops(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        List<Shop> shops = shopService.getAllShops();
        request.setAttribute("shops", shops);
        request.getRequestDispatcher("/views/admin/shop-list.jsp").forward(request, response);
    }

    /**
     * Hiển thị form thêm shop
     */
    private void showAddForm(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Không cần load users nữa vì OwnerID sẽ tự động lấy từ session
        request.getRequestDispatcher("/views/admin/shop-form.jsp").forward(request, response);
    }

    /**
     * Hiển thị form sửa shop
     */
    private void showEditForm(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        int shopId = Integer.parseInt(request.getParameter("id"));
        Shop shop = shopService.getShopById(shopId);
        
        request.setAttribute("shop", shop);
        request.getRequestDispatcher("/views/admin/shop-form.jsp").forward(request, response);
    }

    /**
     * Thêm shop mới
     */
    private void addShop(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        HttpSession session = request.getSession();
        User currentUser = (User) session.getAttribute("user");
        
        String shopName = request.getParameter("shopName");
        String address = request.getParameter("address");
        String phone = request.getParameter("phone");
        boolean isActive = request.getParameter("isActive") != null;

        // Tự động lấy OwnerID từ user đang đăng nhập
        Integer ownerId = currentUser.getUserID();

        int newShopId = shopService.createShop(shopName, address, phone, ownerId, isActive);

        if (newShopId > 0) {
            session.setAttribute("message", "Thêm shop thành công!");
            session.setAttribute("messageType", "success");
        } else {
            session.setAttribute("message", "Thêm shop thất bại!");
            session.setAttribute("messageType", "error");
        }

        response.sendRedirect(request.getContextPath() + "/admin/shop?action=list");
    }

    /**
     * Sửa thông tin shop
     */
    private void editShop(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        int shopId = Integer.parseInt(request.getParameter("shopId"));
        String shopName = request.getParameter("shopName");
        String address = request.getParameter("address");
        String phone = request.getParameter("phone");
        boolean isActive = request.getParameter("isActive") != null;

        // Không cập nhật OwnerID khi edit, giữ nguyên chủ shop ban đầu
        Shop existingShop = shopService.getShopById(shopId);
        Integer ownerId = existingShop.getOwnerID();

        boolean success = shopService.updateShop(shopId, shopName, address, phone, ownerId, isActive);

        HttpSession session = request.getSession();
        if (success) {
            session.setAttribute("message", "Cập nhật shop thành công!");
            session.setAttribute("messageType", "success");
        } else {
            session.setAttribute("message", "Cập nhật shop thất bại!");
            session.setAttribute("messageType", "error");
        }

        response.sendRedirect(request.getContextPath() + "/admin/shop?action=list");
    }

    /**
     * Xóa shop (soft delete)
     */
    private void deleteShop(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        int shopId = Integer.parseInt(request.getParameter("id"));
        boolean success = shopService.deleteShop(shopId);

        if (success) {
            request.getSession().setAttribute("message", "Xóa shop thành công!");
            request.getSession().setAttribute("messageType", "success");
        } else {
            request.getSession().setAttribute("message", "Xóa shop thất bại!");
            request.getSession().setAttribute("messageType", "error");
        }

        response.sendRedirect(request.getContextPath() + "/admin/shop?action=list");
    }

    /**
     * Tạo lại API Token
     */
    private void regenerateToken(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        int shopId = Integer.parseInt(request.getParameter("id"));
        String newToken = shopService.regenerateApiToken(shopId);

        if (newToken != null) {
            request.getSession().setAttribute("message", "Tạo lại API Token thành công: " + newToken);
            request.getSession().setAttribute("messageType", "success");
        } else {
            request.getSession().setAttribute("message", "Tạo lại API Token thất bại!");
            request.getSession().setAttribute("messageType", "error");
        }

        response.sendRedirect(request.getContextPath() + "/admin/shop?action=list");
    }
}
