/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package controllers;

import model.Supplier;
import model.User;
import dao.SupplierDAO;
import dao.ProductDAO;
import dao.IngredientDAO;
import java.io.IOException;
import java.util.List;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

/**
 * SupplierController handles supplier management operations for Admin
 * @author DrDYNew
 */
@WebServlet(name = "SupplierController", urlPatterns = {"/admin/supplier/*"})
public class SupplierController extends HttpServlet {

    private SupplierDAO supplierDAO;
    private ProductDAO productDAO;
    private IngredientDAO ingredientDAO;

    @Override
    public void init() throws ServletException {
        super.init();
        supplierDAO = new SupplierDAO();
        productDAO = new ProductDAO();
        ingredientDAO = new IngredientDAO();
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
            pathInfo = "/list";
        }

        try {
            switch (pathInfo) {
                case "/list":
                    showSupplierList(request, response);
                    break;
                case "/details":
                    showSupplierDetails(request, response);
                    break;
                case "/new":
                    showNewSupplierForm(request, response);
                    break;
                case "/edit":
                    showEditSupplierForm(request, response);
                    break;
                default:
                    showSupplierList(request, response);
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
            pathInfo = "/list";
        }

        try {
            switch (pathInfo) {
                case "/new":
                    createSupplier(request, response);
                    break;
                case "/edit":
                    updateSupplier(request, response);
                    break;
                default:
                    showSupplierList(request, response);
                    break;
            }
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "Đã xảy ra lỗi hệ thống: " + e.getMessage());
            request.getRequestDispatcher("/views/common/error.jsp").forward(request, response);
        }
    }

    /**
     * Display supplier list
     */
    private void showSupplierList(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        String searchKeyword = request.getParameter("search");
        
        List<Supplier> suppliers;
        if (searchKeyword != null && !searchKeyword.trim().isEmpty()) {
            suppliers = supplierDAO.searchSuppliers(searchKeyword);
            request.setAttribute("searchKeyword", searchKeyword);
        } else {
            suppliers = supplierDAO.getAllSuppliers();
        }
        
        request.setAttribute("suppliers", suppliers);
        request.setAttribute("totalSuppliers", suppliers.size());
        request.getRequestDispatcher("/views/admin/supplier-list.jsp").forward(request, response);
    }

    /**
     * Display supplier details
     */
    private void showSupplierDetails(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        String idParam = request.getParameter("id");
        if (idParam == null || idParam.isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/admin/supplier/list");
            return;
        }
        
        try {
            int supplierId = Integer.parseInt(idParam);
            Supplier supplier = supplierDAO.getSupplierById(supplierId);
            
            if (supplier == null) {
                request.setAttribute("error", "Không tìm thấy nhà cung cấp");
                showSupplierList(request, response);
                return;
            }
            
            // Get products from this supplier
            List<model.Product> products = productDAO.getProductsBySupplier(supplierId);
            
            // Get ingredients from this supplier
            List<model.Ingredient> ingredients = ingredientDAO.getIngredientsBySupplier(supplierId);
            
            request.setAttribute("supplier", supplier);
            request.setAttribute("products", products);
            request.setAttribute("ingredients", ingredients);
            request.getRequestDispatcher("/views/admin/supplier-details.jsp").forward(request, response);
            
        } catch (NumberFormatException e) {
            response.sendRedirect(request.getContextPath() + "/admin/supplier/list");
        }
    }

    /**
     * Show form to create new supplier
     */
    private void showNewSupplierForm(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        request.setAttribute("mode", "new");
        request.getRequestDispatcher("/views/admin/supplier-form.jsp").forward(request, response);
    }

    /**
     * Show form to edit existing supplier
     */
    private void showEditSupplierForm(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        String idParam = request.getParameter("id");
        if (idParam == null || idParam.isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/admin/supplier/list");
            return;
        }
        
        try {
            int supplierId = Integer.parseInt(idParam);
            Supplier supplier = supplierDAO.getSupplierById(supplierId);
            
            if (supplier == null) {
                request.setAttribute("error", "Không tìm thấy nhà cung cấp");
                showSupplierList(request, response);
                return;
            }
            
            request.setAttribute("supplier", supplier);
            request.setAttribute("mode", "edit");
            request.getRequestDispatcher("/views/admin/supplier-form.jsp").forward(request, response);
            
        } catch (NumberFormatException e) {
            response.sendRedirect(request.getContextPath() + "/admin/supplier/list");
        }
    }

    /**
     * Create new supplier
     */
    private void createSupplier(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        request.setCharacterEncoding("UTF-8");
        
        String supplierName = request.getParameter("supplierName");
        String contactName = request.getParameter("contactName");
        String email = request.getParameter("email");
        String phone = request.getParameter("phone");
        String address = request.getParameter("address");
        String isActiveParam = request.getParameter("isActive");
        
        // Validation
        if (supplierName == null || supplierName.trim().isEmpty()) {
            request.setAttribute("error", "Tên nhà cung cấp không được để trống");
            request.setAttribute("mode", "new");
            request.getRequestDispatcher("/views/admin/supplier-form.jsp").forward(request, response);
            return;
        }
        
        boolean isActive = "on".equals(isActiveParam) || "true".equals(isActiveParam);
        
        Supplier supplier = new Supplier();
        supplier.setSupplierName(supplierName);
        supplier.setContactName(contactName);
        supplier.setEmail(email);
        supplier.setPhone(phone);
        supplier.setAddress(address);
        supplier.setActive(isActive);
        
        int result = supplierDAO.insertSupplier(supplier);
        
        if (result > 0) {
            request.getSession().setAttribute("message", "Thêm nhà cung cấp thành công!");
            request.getSession().setAttribute("messageType", "success");
            response.sendRedirect(request.getContextPath() + "/admin/supplier/list");
        } else {
            request.setAttribute("error", "Không thể thêm nhà cung cấp. Vui lòng thử lại.");
            request.setAttribute("supplier", supplier);
            request.setAttribute("mode", "new");
            request.getRequestDispatcher("/views/admin/supplier-form.jsp").forward(request, response);
        }
    }

    /**
     * Update existing supplier
     */
    private void updateSupplier(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        request.setCharacterEncoding("UTF-8");
        
        String idParam = request.getParameter("supplierId");
        String supplierName = request.getParameter("supplierName");
        String contactName = request.getParameter("contactName");
        String email = request.getParameter("email");
        String phone = request.getParameter("phone");
        String address = request.getParameter("address");
        String isActiveParam = request.getParameter("isActive");
        
        // Validation
        if (idParam == null || idParam.isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/admin/supplier/list");
            return;
        }
        
        if (supplierName == null || supplierName.trim().isEmpty()) {
            request.setAttribute("error", "Tên nhà cung cấp không được để trống");
            request.setAttribute("mode", "edit");
            showEditSupplierForm(request, response);
            return;
        }
        
        try {
            int supplierId = Integer.parseInt(idParam);
            boolean isActive = "on".equals(isActiveParam) || "true".equals(isActiveParam);
            
            Supplier supplier = new Supplier();
            supplier.setSupplierID(supplierId);
            supplier.setSupplierName(supplierName);
            supplier.setContactName(contactName);
            supplier.setEmail(email);
            supplier.setPhone(phone);
            supplier.setAddress(address);
            supplier.setActive(isActive);
            
            boolean result = supplierDAO.updateSupplier(supplier);
            
            if (result) {
                request.getSession().setAttribute("message", "Cập nhật nhà cung cấp thành công!");
                request.getSession().setAttribute("messageType", "success");
                response.sendRedirect(request.getContextPath() + "/admin/supplier/details?id=" + supplierId);
            } else {
                request.setAttribute("error", "Không thể cập nhật nhà cung cấp. Vui lòng thử lại.");
                request.setAttribute("supplier", supplier);
                request.setAttribute("mode", "edit");
                request.getRequestDispatcher("/views/admin/supplier-form.jsp").forward(request, response);
            }
            
        } catch (NumberFormatException e) {
            response.sendRedirect(request.getContextPath() + "/admin/supplier/list");
        }
    }
}
