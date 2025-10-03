/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package controllers;

import model.User;
import java.io.IOException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

/**
 * BaristaController handles barista-specific dashboard and functionalities
 * @author DrDYNew
 */
@WebServlet(name = "BaristaController", urlPatterns = {"/barista/*"})
public class BaristaController extends HttpServlet {

    @Override
    public void init() throws ServletException {
        super.init();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        // Check authentication
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            response.sendRedirect(request.getContextPath() + "/auth?action=login");
            return;
        }

        User currentUser = (User) session.getAttribute("user");
        String currentUserRole = (String) session.getAttribute("roleName");
        
        // Check if user has barista permission
        if (!"Barista".equals(currentUserRole)) {
            response.sendError(HttpServletResponse.SC_FORBIDDEN, "Bạn không có quyền truy cập khu vực này");
            return;
        }

        String pathInfo = request.getPathInfo();
        if (pathInfo == null) {
            pathInfo = "/dashboard";
        }

        try {
            switch (pathInfo) {
                case "/dashboard":
                    showDashboard(request, response);
                    break;
                case "/orders":
                    showOrders(request, response);
                    break;
                case "/menu":
                    showMenu(request, response);
                    break;
                case "/schedule":
                    showSchedule(request, response);
                    break;
                default:
                    showDashboard(request, response);
                    break;
            }
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "Đã xảy ra lỗi hệ thống: " + e.getMessage());
            request.getRequestDispatcher("/views/common/error.jsp").forward(request, response);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        // Check authentication
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            response.sendRedirect(request.getContextPath() + "/auth?action=login");
            return;
        }

        User currentUser = (User) session.getAttribute("user");
        String currentUserRole = (String) session.getAttribute("roleName");
        
        // Check if user has barista permission
        if (!"Barista".equals(currentUserRole)) {
            response.sendError(HttpServletResponse.SC_FORBIDDEN, "Bạn không có quyền truy cập khu vực này");
            return;
        }

        String pathInfo = request.getPathInfo();
        String action = request.getParameter("action");

        try {
            switch (pathInfo) {
                case "/orders":
                    handleOrderAction(request, response, action);
                    break;
                default:
                    showDashboard(request, response);
                    break;
            }
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "Đã xảy ra lỗi hệ thống: " + e.getMessage());
            request.getRequestDispatcher("/views/common/error.jsp").forward(request, response);
        }
    }

    /**
     * Display barista dashboard
     */
    private void showDashboard(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        // Set dashboard statistics
        request.setAttribute("todayOrders", 23);
        request.setAttribute("completedOrders", 18);
        request.setAttribute("preparingOrders", 5);
        request.setAttribute("shiftRevenue", "850,000");
        
        // Current shift info
        request.setAttribute("shiftStart", "06:00");
        request.setAttribute("shiftEnd", "14:00");
        request.setAttribute("shiftStatus", "active");
        
        // Performance metrics
        request.setAttribute("averageTime", "4.2");
        request.setAttribute("customerRating", "4.8");
        request.setAttribute("completionRate", 95);
        request.setAttribute("performanceBonus", "50,000");
        
        // Mock current orders queue
        List<Map<String, Object>> currentOrders = createMockOrders();
        request.setAttribute("currentOrders", currentOrders);
        
        // Menu items
        List<Map<String, Object>> popularMenuItems = createMockMenu();
        request.setAttribute("popularMenuItems", popularMenuItems);
        
        request.getRequestDispatcher("/views/barista/dashboard.jsp").forward(request, response);
    }

    /**
     * Show orders management page
     */
    private void showOrders(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        // TODO: Load orders from database
        List<Map<String, Object>> allOrders = createMockOrders();
        request.setAttribute("orders", allOrders);
        
        request.getRequestDispatcher("/views/barista/orders.jsp").forward(request, response);
    }

    /**
     * Show menu page
     */
    private void showMenu(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        // TODO: Load menu from database
        List<Map<String, Object>> menuItems = createMockMenu();
        request.setAttribute("menuItems", menuItems);
        
        request.getRequestDispatcher("/views/barista/menu.jsp").forward(request, response);
    }

    /**
     * Show schedule page
     */
    private void showSchedule(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        // TODO: Load schedule from database
        request.setAttribute("message", "Trang lịch làm việc đang được phát triển");
        request.getRequestDispatcher("/views/common/under-construction.jsp").forward(request, response);
    }

    /**
     * Handle order actions (start, complete, etc.)
     */
    private void handleOrderAction(HttpServletRequest request, HttpServletResponse response, String action)
            throws ServletException, IOException {
        
        String orderId = request.getParameter("orderId");
        HttpSession session = request.getSession();
        
        if (orderId == null || orderId.isEmpty()) {
            session.setAttribute("errorMessage", "ID đơn hàng không hợp lệ");
            response.sendRedirect(request.getContextPath() + "/barista/orders");
            return;
        }
        
        switch (action) {
            case "start":
                // TODO: Update order status to "preparing"
                session.setAttribute("successMessage", "Đã bắt đầu pha chế đơn hàng #" + orderId);
                break;
            case "complete":
                // TODO: Update order status to "completed"
                session.setAttribute("successMessage", "Đã hoàn thành đơn hàng #" + orderId);
                break;
            case "cancel":
                // TODO: Update order status to "cancelled"
                session.setAttribute("successMessage", "Đã hủy đơn hàng #" + orderId);
                break;
            default:
                session.setAttribute("errorMessage", "Hành động không hợp lệ");
                break;
        }
        
        response.sendRedirect(request.getContextPath() + "/barista/dashboard");
    }

    /**
     * Create mock orders for demonstration
     */
    private List<Map<String, Object>> createMockOrders() {
        List<Map<String, Object>> orders = new ArrayList<>();
        
        Map<String, Object> order1 = new HashMap<>();
        order1.put("id", "001");
        order1.put("table", "Bàn 5");
        order1.put("time", "08:30");
        order1.put("customer", "Nguyễn Văn A");
        order1.put("items", "2x Cappuccino, 1x Americano, 1x Croissant");
        order1.put("status", "preparing");
        order1.put("urgent", true);
        orders.add(order1);
        
        Map<String, Object> order2 = new HashMap<>();
        order2.put("id", "002");
        order2.put("table", "Mang về");
        order2.put("time", "08:35");
        order2.put("customer", "Trần Thị B");
        order2.put("items", "1x Latte, 1x Macchiato");
        order2.put("status", "new");
        order2.put("urgent", false);
        orders.add(order2);
        
        Map<String, Object> order3 = new HashMap<>();
        order3.put("id", "003");
        order3.put("table", "Bàn 2");
        order3.put("time", "08:40");
        order3.put("customer", "Lê Văn C");
        order3.put("items", "3x Espresso, 2x Muffin");
        order3.put("status", "new");
        order3.put("urgent", false);
        orders.add(order3);
        
        return orders;
    }

    /**
     * Create mock menu for demonstration
     */
    private List<Map<String, Object>> createMockMenu() {
        List<Map<String, Object>> menu = new ArrayList<>();
        
        Map<String, Object> item1 = new HashMap<>();
        item1.put("name", "Espresso");
        item1.put("price", "35,000đ");
        item1.put("icon", "fa-coffee");
        item1.put("color", "#8B4513");
        menu.add(item1);
        
        Map<String, Object> item2 = new HashMap<>();
        item2.put("name", "Americano");
        item2.put("price", "40,000đ");
        item2.put("icon", "fa-coffee");
        item2.put("color", "#D2691E");
        menu.add(item2);
        
        Map<String, Object> item3 = new HashMap<>();
        item3.put("name", "Cappuccino");
        item3.put("price", "50,000đ");
        item3.put("icon", "fa-coffee");
        item3.put("color", "#CD853F");
        menu.add(item3);
        
        Map<String, Object> item4 = new HashMap<>();
        item4.put("name", "Latte");
        item4.put("price", "55,000đ");
        item4.put("icon", "fa-coffee");
        item4.put("color", "#DEB887");
        menu.add(item4);
        
        return menu;
    }
}