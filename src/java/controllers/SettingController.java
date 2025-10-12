package controllers;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import model.Setting;
import services.SettingService;

import java.io.IOException;
import java.util.List;

/**
 * Controller for Setting management
 */
@WebServlet("/admin/setting")
public class SettingController extends HttpServlet {
    private SettingService settingService;
    
    @Override
    public void init() throws ServletException {
        settingService = new SettingService();
    }
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        HttpSession session = request.getSession();
        String currentUserRole = (String) session.getAttribute("roleName");
        
        // Check if user has permission to access setting management
        if (!"Admin".equals(currentUserRole)) {
            response.sendError(HttpServletResponse.SC_FORBIDDEN, "Bạn không có quyền truy cập chức năng này");
            return;
        }
        
        String action = request.getParameter("action");
        
        try {
            if (action == null || action.isEmpty()) {
                listSettings(request, response);
            } else {
                switch (action) {
                    case "create":
                        showCreateForm(request, response);
                        break;
                    case "edit":
                        showEditForm(request, response);
                        break;
                    case "view":
                        viewSetting(request, response);
                        break;
                    case "delete":
                        deleteSetting(request, response);
                        break;
                    default:
                        listSettings(request, response);
                        break;
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "Lỗi hệ thống: " + e.getMessage());
            request.getRequestDispatcher("/views/common/error.jsp").forward(request, response);
        }
    }
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        HttpSession session = request.getSession();
        String currentUserRole = (String) session.getAttribute("roleName");
        
        // Check if user has permission to access setting management
        if (!"Admin".equals(currentUserRole)) {
            response.sendError(HttpServletResponse.SC_FORBIDDEN, "Bạn không có quyền truy cập chức năng này");
            return;
        }
        
        String action = request.getParameter("action");
        
        try {
            switch (action) {
                case "create":
                    createSetting(request, response);
                    break;
                case "update":
                    updateSetting(request, response);
                    break;
                default:
                    response.sendRedirect(request.getContextPath() + "/admin/setting");
                    break;
            }
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "Lỗi hệ thống: " + e.getMessage());
            request.getRequestDispatcher("/views/common/error.jsp").forward(request, response);
        }
    }
    
    private void listSettings(HttpServletRequest request, HttpServletResponse response)
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
        String typeFilter = request.getParameter("type");
        if (typeFilter != null && typeFilter.trim().isEmpty()) {
            typeFilter = null;
        }
        
        // Get settings
        List<Setting> settings = settingService.getSettings(page, pageSize, typeFilter);
        int totalSettings = settingService.getTotalSettingsCount(typeFilter);
        int totalPages = (int) Math.ceil((double) totalSettings / pageSize);
        
        // Get available types for filter
        List<String> availableTypes = settingService.getDistinctTypes();
        
        // Set attributes
        request.setAttribute("settings", settings);
        request.setAttribute("currentPage", page);
        request.setAttribute("totalPages", totalPages);
        request.setAttribute("totalSettings", totalSettings);
        request.setAttribute("typeFilter", typeFilter);
        request.setAttribute("availableTypes", availableTypes);
        
        // Forward to JSP
        request.getRequestDispatcher("/views/admin/setting-list.jsp").forward(request, response);
    }
    
    private void showCreateForm(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        // Get available types for dropdown
        List<String> availableTypes = settingService.getDistinctTypes();
        
        request.setAttribute("availableTypes", availableTypes);
        request.setAttribute("action", "create");
        
        request.getRequestDispatcher("/views/admin/setting-form.jsp").forward(request, response);
    }
    
    private void showEditForm(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        String settingIdParam = request.getParameter("id");
        if (settingIdParam == null || settingIdParam.isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/admin/setting");
            return;
        }
        
        try {
            int settingId = Integer.parseInt(settingIdParam);
            Setting setting = settingService.getSettingById(settingId);
            
            if (setting == null) {
                request.setAttribute("error", "Không tìm thấy cài đặt");
                request.getRequestDispatcher("/views/common/error.jsp").forward(request, response);
                return;
            }
            
            // Get available types for dropdown
            List<String> availableTypes = settingService.getDistinctTypes();
            
            request.setAttribute("setting", setting);
            request.setAttribute("availableTypes", availableTypes);
            request.setAttribute("action", "edit");
            
            request.getRequestDispatcher("/views/admin/setting-form.jsp").forward(request, response);
            
        } catch (NumberFormatException e) {
            response.sendRedirect(request.getContextPath() + "/admin/setting");
        }
    }
    
    private void viewSetting(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        String settingIdParam = request.getParameter("id");
        if (settingIdParam == null || settingIdParam.isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/admin/setting");
            return;
        }
        
        try {
            int settingId = Integer.parseInt(settingIdParam);
            Setting setting = settingService.getSettingById(settingId);
            
            if (setting == null) {
                request.setAttribute("error", "Không tìm thấy cài đặt");
                request.getRequestDispatcher("/views/common/error.jsp").forward(request, response);
                return;
            }
            
            request.setAttribute("setting", setting);
            request.getRequestDispatcher("/views/admin/setting-view.jsp").forward(request, response);
            
        } catch (NumberFormatException e) {
            response.sendRedirect(request.getContextPath() + "/admin/setting");
        }
    }
    
    private void createSetting(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        // Get form data
        String type = request.getParameter("type");
        String value = request.getParameter("value");
        String description = request.getParameter("description");
        boolean isActive = request.getParameter("isActive") != null;
        
        // Create setting object
        Setting setting = new Setting();
        setting.setType(type);
        setting.setValue(value);
        setting.setDescription(description);
        setting.setActive(isActive);
        
        // Create setting
        String error = settingService.createSetting(setting);
        
        if (error == null) {
            // Success
            request.getSession().setAttribute("successMessage", "Tạo cài đặt thành công");
            response.sendRedirect(request.getContextPath() + "/admin/setting");
        } else {
            // Error
            List<String> availableTypes = settingService.getDistinctTypes();
            request.setAttribute("setting", setting);
            request.setAttribute("availableTypes", availableTypes);
            request.setAttribute("action", "create");
            request.setAttribute("error", error);
            
            request.getRequestDispatcher("/views/admin/setting-form.jsp").forward(request, response);
        }
    }
    
    private void updateSetting(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        // Get form data
        String settingIdParam = request.getParameter("settingId");
        String type = request.getParameter("type");
        String value = request.getParameter("value");
        String description = request.getParameter("description");
        boolean isActive = request.getParameter("isActive") != null;
        
        try {
            int settingId = Integer.parseInt(settingIdParam);
            
            // Create setting object
            Setting setting = new Setting();
            setting.setSettingID(settingId);
            setting.setType(type);
            setting.setValue(value);
            setting.setDescription(description);
            setting.setActive(isActive);
            
            // Update setting
            String error = settingService.updateSetting(setting);
            
            if (error == null) {
                // Success
                request.getSession().setAttribute("successMessage", "Cập nhật cài đặt thành công");
                response.sendRedirect(request.getContextPath() + "/admin/setting");
            } else {
                // Error
                List<String> availableTypes = settingService.getDistinctTypes();
                request.setAttribute("setting", setting);
                request.setAttribute("availableTypes", availableTypes);
                request.setAttribute("action", "edit");
                request.setAttribute("error", error);
                
                request.getRequestDispatcher("/views/admin/setting-form.jsp").forward(request, response);
            }
            
        } catch (NumberFormatException e) {
            response.sendRedirect(request.getContextPath() + "/admin/setting");
        }
    }
    
    private void deleteSetting(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        String settingIdParam = request.getParameter("id");
        
        if (settingIdParam == null || settingIdParam.isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/admin/setting");
            return;
        }
        
        try {
            int settingId = Integer.parseInt(settingIdParam);
            
            // Delete setting
            String error = settingService.deleteSetting(settingId);
            
            if (error == null) {
                // Success
                request.getSession().setAttribute("successMessage", "Xóa cài đặt thành công");
            } else {
                // Error
                request.getSession().setAttribute("errorMessage", error);
            }
            
            response.sendRedirect(request.getContextPath() + "/admin/setting");
            
        } catch (NumberFormatException e) {
            response.sendRedirect(request.getContextPath() + "/admin/setting");
        }
    }
}