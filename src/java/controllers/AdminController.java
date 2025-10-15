/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package controllers;

import model.User;
import model.Product;
import dao.UserDAO;
import services.ProductService;
import java.io.IOException;
import java.util.List;
import java.math.BigDecimal;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import jakarta.servlet.http.Part;
import java.io.File;
import java.nio.file.Paths;
import java.util.UUID;

/**
 * AdminController handles admin-specific dashboard and functionalities
 * @author DrDYNew
 */
@WebServlet(name = "AdminController", urlPatterns = {"/admin/*"})
@MultipartConfig(
    fileSizeThreshold = 1024 * 1024 * 1, // 1 MB
    maxFileSize = 1024 * 1024 * 10,      // 10 MB
    maxRequestSize = 1024 * 1024 * 15    // 15 MB
)
public class AdminController extends HttpServlet {

    private UserDAO userDAO;
    private ProductService productService;

    @Override
    public void init() throws ServletException {
        super.init();
        userDAO = new UserDAO();
        productService = new ProductService();
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
        
        // Check if user has admin permission
        if (!"Admin".equals(currentUserRole)) {
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
                case "/users":
                    showUserManagement(request, response);
                    break;
                case "/products":
                    showProductManagement(request, response);
                    break;
                case "/products/view":
                    showProductView(request, response);
                    break;
                case "/products/new":
                    showProductForm(request, response, null);
                    break;
                case "/products/edit":
                    try {
                        String idParam = request.getParameter("id");
                        if (idParam == null || idParam.isEmpty()) {
                            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Thiếu ID sản phẩm");
                            return;
                        }
                        int editProductId = Integer.parseInt(idParam);
                        Product editProduct = productService.getProductById(editProductId);
                        if (editProduct == null) {
                            response.sendError(HttpServletResponse.SC_NOT_FOUND, "Không tìm thấy sản phẩm");
                            return;
                        }
                        showProductForm(request, response, editProduct);
                    } catch (NumberFormatException e) {
                        response.sendError(HttpServletResponse.SC_BAD_REQUEST, "ID sản phẩm không hợp lệ");
                        return;
                    }
                    break;
                case "/settings":
                    showSystemSettings(request, response);
                    break;
                case "/reports":
                    showReports(request, response);
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
        
        // Check if user has admin permission
        if (!"Admin".equals(currentUserRole)) {
            response.sendError(HttpServletResponse.SC_FORBIDDEN, "Bạn không có quyền truy cập khu vực này");
            return;
        }

        String pathInfo = request.getPathInfo();
        if (pathInfo == null) {
            pathInfo = "/dashboard";
        }

        try {
            switch (pathInfo) {
                case "/products/create":
                    createProduct(request, response);
                    break;
                case "/products/update":
                    updateProduct(request, response);
                    break;
                case "/settings":
                    updateSystemSettings(request, response);
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
     * Display admin dashboard
     */
    private void showDashboard(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        try {
            // Get real statistics from database
            int totalUsers = userDAO.getTotalUsersCount(null, null);
            List<User> allUsers = userDAO.getAllUsers(1, Integer.MAX_VALUE, null, null);
            
            // Count users by role
            int hrCount = 0;
            int adminCount = 0;
            int inventoryCount = 0;
            int baristaCount = 0;
            int activeUsers = 0;
            
            for (User user : allUsers) {
                if (user.isActive()) {
                    activeUsers++;
                }
                switch (user.getRoleID()) {
                    case 1: hrCount++; break;
                    case 2: adminCount++; break;
                    case 3: inventoryCount++; break;
                    case 4: baristaCount++; break;
                }
            }
            
            // Set real dashboard data
            request.setAttribute("totalUsers", totalUsers);
            request.setAttribute("activeUsers", activeUsers);
            request.setAttribute("hrCount", hrCount);
            request.setAttribute("adminCount", adminCount);
            request.setAttribute("inventoryCount", inventoryCount);
            request.setAttribute("baristaCount", baristaCount);
            
            // System status (these could be calculated from actual system metrics)
            request.setAttribute("serverStatus", "online");
            request.setAttribute("databaseStatus", "connected");
            
            // Performance metrics (placeholder - would integrate with monitoring tools)
            request.setAttribute("systemUptime", "99.9%");
            request.setAttribute("avgResponseTime", "0.85s");
            
        } catch (Exception e) {
            e.printStackTrace();
            // Fallback to basic info if database error
            request.setAttribute("totalUsers", 0);
            request.setAttribute("activeUsers", 0);
            request.setAttribute("error", "Không thể tải dữ liệu thống kê");
        }
        
        request.getRequestDispatcher("/views/admin/dashboard.jsp").forward(request, response);
    }

    /**
     * Show user management page
     */
    private void showUserManagement(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        // Redirect to the user controller
        response.sendRedirect(request.getContextPath() + "/user");
    }

    /**
     * Show system settings page
     */
    private void showSystemSettings(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        // TODO: Implement system settings page
        request.setAttribute("message", "Trang cài đặt hệ thống đang được phát triển");
        request.getRequestDispatcher("/views/common/under-construction.jsp").forward(request, response);
    }

    /**
     * Show reports page
     */
    private void showReports(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        // TODO: Implement reports page
        request.setAttribute("message", "Trang báo cáo đang được phát triển");
        request.getRequestDispatcher("/views/common/under-construction.jsp").forward(request, response);
    }

    /**
     * Update system settings
     */
    private void updateSystemSettings(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        // TODO: Implement system settings update
        HttpSession session = request.getSession();
        session.setAttribute("successMessage", "Cài đặt hệ thống đã được cập nhật");
        response.sendRedirect(request.getContextPath() + "/admin/settings");
    }
    
    // ==================== PRODUCT MANAGEMENT METHODS ====================
    
    /**
     * Show product management page
     */
    private void showProductManagement(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        try {
            // Get parameters
            int page = 1;
            int pageSize = 10;
            String searchTerm = request.getParameter("search");
            String categoryParam = request.getParameter("category");
            String statusParam = request.getParameter("status");
            
            if (request.getParameter("page") != null) {
                page = Integer.parseInt(request.getParameter("page"));
            }
            
            Integer categoryId = null;
            if (categoryParam != null && !categoryParam.isEmpty()) {
                categoryId = Integer.parseInt(categoryParam);
            }
            
            Boolean isActive = null;
            if ("active".equals(statusParam)) {
                isActive = true;
            } else if ("inactive".equals(statusParam)) {
                isActive = false;
            }
            
            // Get data
            List<Product> products = productService.getAllProducts(page, pageSize, searchTerm, categoryId, isActive);
            int totalCount = productService.getTotalProductsCount(searchTerm, categoryId, isActive);
            int totalPages = productService.getTotalPages(totalCount, pageSize);
            
            // Get dropdown data
            List<Object[]> categories = productService.getCategories();
            
            // Set attributes
            request.setAttribute("products", products);
            request.setAttribute("currentPage", page);
            request.setAttribute("totalPages", totalPages);
            request.setAttribute("totalCount", totalCount);
            request.setAttribute("pageSize", pageSize);
            request.setAttribute("searchTerm", searchTerm);
            request.setAttribute("selectedCategory", categoryId);
            request.setAttribute("selectedStatus", statusParam);
            request.setAttribute("categories", categories);
            
            request.getRequestDispatcher("/views/admin/product-list.jsp").forward(request, response);
            
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "Lỗi khi tải danh sách sản phẩm: " + e.getMessage());
            request.getRequestDispatcher("/views/common/error.jsp").forward(request, response);
        }
    }
    
    /**
     * Show product view
     */
    private void showProductView(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        try {
            int productId = Integer.parseInt(request.getParameter("id"));
            Product product = productService.getProductById(productId);
            
            if (product == null) {
                response.sendError(HttpServletResponse.SC_NOT_FOUND, "Không tìm thấy sản phẩm");
                return;
            }
            
            request.setAttribute("product", product);
            request.getRequestDispatcher("/views/admin/product-view.jsp").forward(request, response);
            
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "Lỗi khi tải chi tiết sản phẩm: " + e.getMessage());
            request.getRequestDispatcher("/views/common/error.jsp").forward(request, response);
        }
    }
    
    /**
     * Show product form (for create or edit)
     */
    private void showProductForm(HttpServletRequest request, HttpServletResponse response, Product product)
            throws ServletException, IOException {
        try {
            System.out.println("=== showProductForm DEBUG ===");
            System.out.println("Product: " + (product != null ? product.getProductID() : "null"));
            
            // Get dropdown data
            List<Object[]> categories = productService.getCategories();
            List<Object[]> suppliers = productService.getSuppliers();
            
            System.out.println("Categories count: " + (categories != null ? categories.size() : "null"));
            System.out.println("Suppliers count: " + (suppliers != null ? suppliers.size() : "null"));
            
            // Check if data is loaded
            if (categories == null || categories.isEmpty()) {
                throw new Exception("Không thể tải danh mục sản phẩm");
            }
            
            if (suppliers == null || suppliers.isEmpty()) {
                throw new Exception("Không thể tải danh sách nhà cung cấp");
            }
            
            request.setAttribute("categories", categories);
            request.setAttribute("suppliers", suppliers);
            request.setAttribute("product", product);
            
            System.out.println("Forwarding to product-form.jsp...");
            request.getRequestDispatcher("/views/admin/product-form.jsp").forward(request, response);
            
        } catch (Exception e) {
            System.err.println("ERROR in showProductForm: " + e.getMessage());
            e.printStackTrace();
            
            HttpSession session = request.getSession();
            session.setAttribute("errorMessage", "Lỗi khi tải form sản phẩm: " + e.getMessage());
            response.sendRedirect(request.getContextPath() + "/admin/products");
        }
    }
    
    /**
     * Create new product
     */
    private void createProduct(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        HttpSession session = request.getSession();
        
        try {
            // Get form data
            String productName = request.getParameter("productName");
            String description = request.getParameter("description");
            int categoryId = Integer.parseInt(request.getParameter("categoryId"));
            BigDecimal price = new BigDecimal(request.getParameter("price"));
            int supplierId = Integer.parseInt(request.getParameter("supplierId"));
            boolean isActive = "on".equals(request.getParameter("isActive"));
            
            // Handle image upload
            String imageUrl = handleImageUpload(request);
            
            // Create product (without ID and timestamp)
            Product product = new Product(productName, description, imageUrl, categoryId, price, supplierId, isActive);
            boolean success = productService.createProduct(product);
            
            if (success) {
                session.setAttribute("successMessage", "Tạo sản phẩm thành công!");
                response.sendRedirect(request.getContextPath() + "/admin/products");
            } else {
                session.setAttribute("errorMessage", "Không thể tạo sản phẩm. Vui lòng thử lại.");
                response.sendRedirect(request.getContextPath() + "/admin/products/new");
            }
            
        } catch (Exception e) {
            e.printStackTrace();
            session.setAttribute("errorMessage", "Lỗi: " + e.getMessage());
            response.sendRedirect(request.getContextPath() + "/admin/products/new");
        }
    }
    
    /**
     * Update existing product
     */
    private void updateProduct(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        HttpSession session = request.getSession();
        
        try {
            // Get form data
            int productId = Integer.parseInt(request.getParameter("productId"));
            String productName = request.getParameter("productName");
            String description = request.getParameter("description");
            int categoryId = Integer.parseInt(request.getParameter("categoryId"));
            BigDecimal price = new BigDecimal(request.getParameter("price"));
            int supplierId = Integer.parseInt(request.getParameter("supplierId"));
            boolean isActive = "on".equals(request.getParameter("isActive"));
            
            // Get existing product to check for old image
            Product existingProduct = productService.getProductById(productId);
            
            // Handle image upload
            String imageUrl = handleImageUpload(request);
            if (imageUrl == null || imageUrl.isEmpty()) {
                // No new image, keep old one
                imageUrl = existingProduct.getImageUrl();
            } else {
                // New image uploaded, delete old one
                deleteOldImage(existingProduct.getImageUrl());
            }
            
            // Update product (set ID manually)
            Product product = new Product(productName, description, imageUrl, categoryId, price, supplierId, isActive);
            product.setProductID(productId);
            boolean success = productService.updateProduct(product);
            
            if (success) {
                session.setAttribute("successMessage", "Cập nhật sản phẩm thành công!");
                response.sendRedirect(request.getContextPath() + "/admin/products/view?id=" + productId);
            } else {
                session.setAttribute("errorMessage", "Không thể cập nhật sản phẩm. Vui lòng thử lại.");
                response.sendRedirect(request.getContextPath() + "/admin/products/edit?id=" + productId);
            }
            
        } catch (Exception e) {
            e.printStackTrace();
            session.setAttribute("errorMessage", "Lỗi: " + e.getMessage());
            response.sendRedirect(request.getContextPath() + "/admin/products");
        }
    }
    
    /**
     * Handle image upload and return the image URL
     */
    private String handleImageUpload(HttpServletRequest request) throws Exception {
        Part imagePart = request.getPart("imageFile");
        
        if (imagePart == null || imagePart.getSize() == 0) {
            return null;
        }
        
        // Validate file type
        String contentType = imagePart.getContentType();
        if (!contentType.startsWith("image/")) {
            throw new Exception("File phải là hình ảnh");
        }
        
        // Get file extension
        String originalFileName = Paths.get(imagePart.getSubmittedFileName()).getFileName().toString();
        String fileExtension = originalFileName.substring(originalFileName.lastIndexOf("."));
        
        // Validate extension
        if (!fileExtension.matches("\\.(jpg|jpeg|png|gif)$")) {
            throw new Exception("Chỉ hỗ trợ định dạng: jpg, jpeg, png, gif");
        }
        
        // Generate unique filename
        String uniqueFileName = UUID.randomUUID().toString() + fileExtension;
        
        // Get upload directory - use web folder instead of build folder
        // This prevents images from being deleted on clean & build
        String realPath = request.getServletContext().getRealPath("");
        String webPath;
        
        if (realPath.contains("build")) {
            // Running from build folder, save to web folder
            webPath = realPath.substring(0, realPath.indexOf("build")) + "web";
        } else {
            // Already in web folder
            webPath = realPath;
        }
        
        String uploadPath = webPath + File.separator + "uploads" + File.separator + "products";
        File uploadDir = new File(uploadPath);
        if (!uploadDir.exists()) {
            uploadDir.mkdirs();
        }
        
        // Save file to web/uploads/products
        String filePath = uploadPath + File.separator + uniqueFileName;
        imagePart.write(filePath);
        
        // Also copy to build folder for immediate display (if different from web)
        if (realPath.contains("build")) {
            String buildUploadPath = realPath + File.separator + "uploads" + File.separator + "products";
            File buildUploadDir = new File(buildUploadPath);
            if (!buildUploadDir.exists()) {
                buildUploadDir.mkdirs();
            }
            String buildFilePath = buildUploadPath + File.separator + uniqueFileName;
            // Copy file from web to build
            java.nio.file.Files.copy(
                new File(filePath).toPath(),
                new File(buildFilePath).toPath(),
                java.nio.file.StandardCopyOption.REPLACE_EXISTING
            );
        }
        
        // Return relative URL (without contextPath)
        return "/uploads/products/" + uniqueFileName;
    }
    
    /**
     * Delete old image file from server
     */
    private void deleteOldImage(String imageUrl) {
        if (imageUrl == null || imageUrl.isEmpty()) {
            return;
        }
        
        try {
            String realPath = getServletContext().getRealPath("") + imageUrl.replace("/", File.separator);
            File file = new File(realPath);
            if (file.exists()) {
                file.delete();
            }
        } catch (Exception e) {
            System.err.println("Error deleting old image: " + e.getMessage());
        }
    }
}