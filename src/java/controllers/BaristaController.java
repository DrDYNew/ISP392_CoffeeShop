/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package controllers;

import model.User;
import model.Issue;
import model.Setting;
import services.IssueService;
import services.OrderService;
import services.SettingService;
import java.io.IOException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.math.BigDecimal;
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

    private IssueService issueService;
    private OrderService orderService;
    private SettingService settingService;

    @Override
    public void init() throws ServletException {
        super.init();
        issueService = new IssueService();
        orderService = new OrderService();
        settingService = new SettingService();
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
                case "/order-details":
                    showOrderDetails(request, response);
                    break;
                case "/issues":
                    showIssues(request, response);
                    break;
                case "/issue-details":
                    showIssueDetails(request, response);
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
                    handleOrderAction(request, response, action, currentUser);
                    break;
                case "/issues":
                    handleIssueAction(request, response, action, currentUser);
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
    
    /**
     * Show order list with real data
     */
    private void showOrders(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        // Get pagination parameters
        int page = 1;
        int pageSize = 15;
        
        String pageParam = request.getParameter("page");
        if (pageParam != null && !pageParam.isEmpty()) {
            try {
                page = Integer.parseInt(pageParam);
                if (page < 1) page = 1;
            } catch (NumberFormatException e) {
                page = 1;
            }
        }
        
        // Get filter parameters
        String statusParam = request.getParameter("status");
        Integer statusFilter = null;
        if (statusParam != null && !statusParam.isEmpty()) {
            try {
                statusFilter = Integer.parseInt(statusParam);
            } catch (NumberFormatException e) {
                // Ignore invalid status
            }
        }
        
        // Get orders with details
        List<Map<String, Object>> orders = orderService.getOrdersWithDetails(page, pageSize, statusFilter, null);
        int totalOrders = orderService.getTotalOrderCount(statusFilter, null);
        int totalPages = (int) Math.ceil((double) totalOrders / pageSize);
        
        // Get order statuses for filter
        List<Setting> orderStatuses = settingService.getSettingsByType("OrderStatus");
        
        // Set attributes
        request.setAttribute("orders", orders);
        request.setAttribute("currentPage", page);
        request.setAttribute("totalPages", totalPages);
        request.setAttribute("totalOrders", totalOrders);
        request.setAttribute("statusFilter", statusFilter);
        request.setAttribute("orderStatuses", orderStatuses);
        
        // Forward to JSP
        request.getRequestDispatcher("/views/barista/order-list.jsp").forward(request, response);
    }
    
    /**
     * Show order details
     */
    private void showOrderDetails(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        String orderIdParam = request.getParameter("id");
        if (orderIdParam == null || orderIdParam.isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/barista/orders");
            return;
        }
        
        try {
            int orderID = Integer.parseInt(orderIdParam);
            
            // Get order with details
            Map<String, Object> order = orderService.getOrderWithDetailsById(orderID);
            if (order == null) {
                request.setAttribute("error", "Không tìm thấy đơn hàng");
                request.getRequestDispatcher("/views/common/error.jsp").forward(request, response);
                return;
            }
            
            // Get order details with product info
            List<Map<String, Object>> orderDetails = orderService.getOrderDetailsWithProduct(orderID);
            
            // Calculate total
            BigDecimal total = orderService.calculateOrderTotal(orderID);
            
            // Get order statuses
            List<Setting> orderStatuses = settingService.getSettingsByType("OrderStatus");
            
            // Set attributes
            request.setAttribute("order", order);
            request.setAttribute("orderDetails", orderDetails);
            request.setAttribute("total", total);
            request.setAttribute("orderStatuses", orderStatuses);
            
            // Forward to JSP
            request.getRequestDispatcher("/views/barista/order-details.jsp").forward(request, response);
            
        } catch (NumberFormatException e) {
            response.sendRedirect(request.getContextPath() + "/barista/orders");
        }
    }
    
    /**
     * Show issues list
     */
    private void showIssues(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        // Get pagination parameters
        int page = 1;
        int pageSize = 10;
        
        String pageParam = request.getParameter("page");
        if (pageParam != null && !pageParam.isEmpty()) {
            try {
                page = Integer.parseInt(pageParam);
                if (page < 1) page = 1;
            } catch (NumberFormatException e) {
                page = 1;
            }
        }
        
        // Get filter parameters
        String statusParam = request.getParameter("status");
        Integer statusFilter = null;
        if (statusParam != null && !statusParam.isEmpty()) {
            try {
                statusFilter = Integer.parseInt(statusParam);
            } catch (NumberFormatException e) {
                // Ignore invalid status
            }
        }
        
        // Get issues
        IssueService.IssueResult result = issueService.getAllIssues(page, pageSize, statusFilter, null, null);
        
        // Get issue statuses for filter
        List<Setting> issueStatuses = settingService.getSettingsByType("IssueStatus");
        
        // Set attributes
        request.setAttribute("issues", result.getIssues());
        request.setAttribute("currentPage", result.getCurrentPage());
        request.setAttribute("totalPages", result.getTotalPages());
        request.setAttribute("totalIssues", result.getTotalCount());
        request.setAttribute("statusFilter", statusFilter);
        request.setAttribute("issueStatuses", issueStatuses);
        
        // Forward to JSP
        request.getRequestDispatcher("/views/barista/issue-list.jsp").forward(request, response);
    }
    
    /**
     * Show issue details
     */
    private void showIssueDetails(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        String issueIdParam = request.getParameter("id");
        if (issueIdParam == null || issueIdParam.isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/barista/issues");
            return;
        }
        
        try {
            int issueID = Integer.parseInt(issueIdParam);
            
            // Get issue by ID
            Issue issue = issueService.getIssueById(issueID);
            if (issue == null) {
                request.setAttribute("error", "Không tìm thấy báo cáo sự cố");
                request.getRequestDispatcher("/views/common/error.jsp").forward(request, response);
                return;
            }
            
            // Get issue statuses
            List<Setting> issueStatuses = settingService.getSettingsByType("IssueStatus");
            
            // Set attributes
            request.setAttribute("issue", issue);
            request.setAttribute("issueStatuses", issueStatuses);
            
            // Forward to JSP
            request.getRequestDispatcher("/views/barista/issue-details.jsp").forward(request, response);
            
        } catch (NumberFormatException e) {
            response.sendRedirect(request.getContextPath() + "/barista/issues");
        }
    }
    
    /**
     * Handle order actions (update status, cancel)
     */
    private void handleOrderAction(HttpServletRequest request, HttpServletResponse response, 
                                   String action, User currentUser)
            throws ServletException, IOException {
        
        String orderIdParam = request.getParameter("id");
        if (orderIdParam == null || orderIdParam.isEmpty()) {
            request.getSession().setAttribute("errorMessage", "ID đơn hàng không hợp lệ");
            response.sendRedirect(request.getContextPath() + "/barista/orders");
            return;
        }
        
        try {
            int orderID = Integer.parseInt(orderIdParam);
            
            String error = null;
            switch (action) {
                case "updateStatus":
                    String statusIdParam = request.getParameter("statusId");
                    if (statusIdParam != null) {
                        int statusID = Integer.parseInt(statusIdParam);
                        error = orderService.updateOrderStatus(orderID, statusID);
                        if (error == null) {
                            request.getSession().setAttribute("successMessage", 
                                "Cập nhật trạng thái đơn hàng thành công");
                        }
                    }
                    break;
                case "cancel":
                    String cancellationReason = request.getParameter("cancellationReason");
                    if (cancellationReason == null || cancellationReason.trim().isEmpty()) {
                        error = "Vui lòng nhập lý do hủy đơn";
                    } else {
                        error = orderService.cancelOrder(orderID, cancellationReason.trim());
                        if (error == null) {
                            request.getSession().setAttribute("successMessage", "Hủy đơn hàng thành công");
                        }
                    }
                    break;
                default:
                    error = "Hành động không hợp lệ";
                    break;
            }
            
            if (error != null) {
                request.getSession().setAttribute("errorMessage", error);
            }
            
            // Redirect back to order details
            response.sendRedirect(request.getContextPath() + "/barista/order-details?id=" + orderID);
            
        } catch (NumberFormatException e) {
            request.getSession().setAttribute("errorMessage", "Dữ liệu không hợp lệ");
            response.sendRedirect(request.getContextPath() + "/barista/orders");
        }
    }
    
    /**
     * Handle issue actions (review, agree)
     */
    private void handleIssueAction(HttpServletRequest request, HttpServletResponse response,
                                   String action, User currentUser)
            throws ServletException, IOException {
        
        String issueIdParam = request.getParameter("id");
        if (issueIdParam == null || issueIdParam.isEmpty()) {
            request.getSession().setAttribute("errorMessage", "ID sự cố không hợp lệ");
            response.sendRedirect(request.getContextPath() + "/barista/issues");
            return;
        }
        
        try {
            int issueID = Integer.parseInt(issueIdParam);
            
            Issue issue = issueService.getIssueById(issueID);
            if (issue == null) {
                request.getSession().setAttribute("errorMessage", "Không tìm thấy sự cố");
                response.sendRedirect(request.getContextPath() + "/barista/issues");
                return;
            }
            
            String error = null;
            switch (action) {
                case "updateStatus":
                    String statusIdParam = request.getParameter("statusId");
                    if (statusIdParam != null) {
                        int statusID = Integer.parseInt(statusIdParam);
                        error = issueService.updateIssueStatus(issueID, statusID);
                        if (error == null) {
                            request.getSession().setAttribute("successMessage", 
                                "Cập nhật trạng thái sự cố thành công");
                        }
                    }
                    break;
                case "resolve":
                    error = issueService.resolveIssue(issueID);
                    if (error == null) {
                        request.getSession().setAttribute("successMessage", "Đã giải quyết sự cố thành công");
                    }
                    break;
                case "reject":
                    String rejectionReason = request.getParameter("rejectionReason");
                    if (rejectionReason == null || rejectionReason.trim().isEmpty()) {
                        error = "Vui lòng nhập lý do từ chối";
                    } else {
                        error = issueService.rejectIssue(issueID, rejectionReason.trim());
                        if (error == null) {
                            request.getSession().setAttribute("successMessage", "Đã từ chối xử lý sự cố");
                        }
                    }
                    break;
                default:
                    error = "Hành động không hợp lệ";
                    break;
            }
            
            if (error != null) {
                request.getSession().setAttribute("errorMessage", error);
            }
            
            // Redirect back to issue details
            response.sendRedirect(request.getContextPath() + "/barista/issue-details?id=" + issueID);
            
        } catch (NumberFormatException e) {
            request.getSession().setAttribute("errorMessage", "Dữ liệu không hợp lệ");
            response.sendRedirect(request.getContextPath() + "/barista/issues");
        }
    }
}