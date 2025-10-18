package controllers;

import model.Shop;
import model.User;
import services.HRShopService;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.util.List;

/**
 * Controller cho HR xem thông tin Shop bằng API Token
 */
@WebServlet(name = "HRShopController", urlPatterns = {"/hr/shop"})
public class HRShopController extends HttpServlet {

    private final HRShopService hrShopService = new HRShopService();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");
        
        // Check if user is HR (RoleID = 1)
        if (user == null || user.getRoleID() != 1) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        String action = request.getParameter("action");
        if (action == null) {
            action = "list";
        }

        switch (action) {
            case "list":
                showListForm(request, response);
                break;
            case "details":
                showDetailsForm(request, response);
                break;
            default:
                showListForm(request, response);
                break;
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");
        
        if (user == null || user.getRoleID() != 1) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        String action = request.getParameter("action");

        switch (action) {
            case "viewList":
                viewShopList(request, response);
                break;
            case "viewDetails":
                viewShopDetails(request, response);
                break;
            default:
                showListForm(request, response);
                break;
        }
    }

    /**
     * Hiển thị form nhập Master Token để xem list shops
     */
    private void showListForm(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.getRequestDispatcher("/views/hr/shop-list.jsp").forward(request, response);
    }

    /**
     * Hiển thị form nhập Shop Token để xem details
     */
    private void showDetailsForm(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.getRequestDispatcher("/views/hr/shop-details.jsp").forward(request, response);
    }

    /**
     * Xem danh sách shops với Master Token
     */
    private void viewShopList(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        String masterToken = request.getParameter("masterToken");
        
        try {
            // Sử dụng service để validate và lấy danh sách
            List<Shop> shops = hrShopService.getAllShopsWithMasterToken(masterToken);
            
            request.setAttribute("shops", shops);
            request.setAttribute("authenticated", true);
            request.setAttribute("masterToken", masterToken);
            
        } catch (IllegalArgumentException | SecurityException e) {
            request.setAttribute("error", e.getMessage());
        }
        
        request.getRequestDispatcher("/views/hr/shop-list.jsp").forward(request, response);
    }

    /**
     * Xem chi tiết 1 shop với Shop Token
     */
    private void viewShopDetails(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        String shopToken = request.getParameter("shopToken");
        
        try {
            // Sử dụng service để validate và lấy thông tin shop
            Shop shop = hrShopService.getShopByToken(shopToken);
            
            request.setAttribute("shop", shop);
            request.setAttribute("authenticated", true);
            request.setAttribute("shopToken", shopToken);
            
        } catch (IllegalArgumentException | SecurityException e) {
            request.setAttribute("error", e.getMessage());
        }
        
        request.getRequestDispatcher("/views/hr/shop-details.jsp").forward(request, response);
    }
}
