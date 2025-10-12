package controllers;

import services.PurchaseOrderService;
import services.IngredientService;
import services.SettingService;
import model.PurchaseOrder;
import model.PurchaseOrderDetail;
import model.PurchaseOrderView;
import model.Ingredient;
import model.Setting;
import model.User;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.math.BigDecimal;
import java.util.ArrayList;
import java.util.List;

/**
 * Controller for Purchase Order operations
 */
@WebServlet(name = "PurchaseOrderController", urlPatterns = {"/purchase-order"})
public class PurchaseOrderController extends HttpServlet {

    private PurchaseOrderService poService;
    private IngredientService ingredientService;
    private SettingService settingService;

    @Override
    public void init() throws ServletException {
        poService = new PurchaseOrderService();
        ingredientService = new IngredientService();
        settingService = new SettingService();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");
        
        // Check if user is logged in and has appropriate role
        if (user == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        String action = request.getParameter("action");
        if (action == null) action = "list";

        try {
            switch (action) {
                case "list":
                    showPOList(request, response);
                    break;
                case "view":
                    viewPODetails(request, response);
                    break;
                case "new":
                    showNewPOForm(request, response);
                    break;
                case "edit":
                    showEditPOForm(request, response);
                    break;
                case "confirm":
                    confirmPO(request, response);
                    break;
                default:
                    showPOList(request, response);
                    break;
            }
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("errorMessage", "Có lỗi xảy ra: " + e.getMessage());
            request.getRequestDispatcher("/views/common/error.jsp").forward(request, response);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");
        
        if (user == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        String action = request.getParameter("action");

        try {
            switch (action) {
                case "create":
                    createPO(request, response, user);
                    break;
                case "update":
                    updatePO(request, response);
                    break;
                case "add-detail":
                    addPODetail(request, response);
                    break;
                case "update-detail":
                    updatePODetail(request, response);
                    break;
                case "delete-detail":
                    deletePODetail(request, response);
                    break;
                case "update-status":
                    updatePOStatus(request, response);
                    break;
                case "reject":
                    rejectPO(request, response);
                    break;
                case "cancel":
                    cancelPO(request, response);
                    break;
                default:
                    showPOList(request, response);
                    break;
            }
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("errorMessage", "Có lỗi xảy ra: " + e.getMessage());
            request.getRequestDispatcher("/views/common/error.jsp").forward(request, response);
        }
    }

    /**
     * Show list of all purchase orders
     */
    private void showPOList(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        List<PurchaseOrderView> poList = poService.getAllPurchaseOrdersView();
        List<Setting> statuses = poService.getAllPOStatuses();
        
        request.setAttribute("poList", poList);
        request.setAttribute("statuses", statuses);
        request.getRequestDispatcher("/views/inventory-staff/po-list.jsp").forward(request, response);
    }

    /**
     * View purchase order details
     */
    private void viewPODetails(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        int poID = Integer.parseInt(request.getParameter("id"));
        
        PurchaseOrder po = poService.getPurchaseOrderById(poID);
        List<PurchaseOrderDetail> details = poService.getPurchaseOrderDetails(poID);
        List<Ingredient> ingredients = poService.getAllIngredients();
        List<Setting> statuses = poService.getAllPOStatuses();
        
        request.setAttribute("po", po);
        request.setAttribute("details", details);
        request.setAttribute("ingredients", ingredients);
        request.setAttribute("statuses", statuses);
        request.getRequestDispatcher("/views/inventory-staff/po-details.jsp").forward(request, response);
    }

    /**
     * Show form to create new purchase order
     */
    private void showNewPOForm(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        List<Ingredient> ingredients = poService.getAllIngredients();
        List<Setting> statuses = poService.getAllPOStatuses();
        
        request.setAttribute("ingredients", ingredients);
        request.setAttribute("statuses", statuses);
        request.getRequestDispatcher("/views/inventory-staff/po-form.jsp").forward(request, response);
    }

    /**
     * Show form to edit purchase order
     */
    private void showEditPOForm(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        int poID = Integer.parseInt(request.getParameter("id"));
        
        PurchaseOrder po = poService.getPurchaseOrderById(poID);
        List<PurchaseOrderDetail> details = poService.getPurchaseOrderDetails(poID);
        List<Ingredient> ingredients = poService.getAllIngredients();
        List<Setting> statuses = poService.getAllPOStatuses();
        
        request.setAttribute("po", po);
        request.setAttribute("details", details);
        request.setAttribute("ingredients", ingredients);
        request.setAttribute("statuses", statuses);
        request.getRequestDispatcher("/views/inventory-staff/po-form.jsp").forward(request, response);
    }

    /**
     * Create new purchase order
     */
    private void createPO(HttpServletRequest request, HttpServletResponse response, User user)
            throws ServletException, IOException {
        
        int shopID = Integer.parseInt(request.getParameter("shopID"));
        int supplierID = Integer.parseInt(request.getParameter("supplierID"));
        int statusID = Integer.parseInt(request.getParameter("statusID"));
        
        PurchaseOrder po = new PurchaseOrder();
        po.setShopID(shopID);
        po.setSupplierID(supplierID);
        po.setCreatedBy(user.getUserID());
        po.setStatusID(statusID);
        
        // Get details
        List<PurchaseOrderDetail> details = new ArrayList<>();
        String[] ingredientIDs = request.getParameterValues("ingredientID[]");
        String[] quantities = request.getParameterValues("quantity[]");
        
        if (ingredientIDs != null && quantities != null) {
            for (int i = 0; i < ingredientIDs.length; i++) {
                PurchaseOrderDetail detail = new PurchaseOrderDetail();
                detail.setIngredientID(Integer.parseInt(ingredientIDs[i]));
                detail.setQuantity(new BigDecimal(quantities[i]));
                detail.setReceivedQuantity(BigDecimal.ZERO);
                details.add(detail);
            }
        }
        
        boolean success = poService.createPurchaseOrder(po, details);
        
        if (success) {
            request.getSession().setAttribute("successMessage", "Tạo đơn hàng thành công!");
            response.sendRedirect(request.getContextPath() + "/purchase-order?action=list");
        } else {
            request.setAttribute("errorMessage", "Không thể tạo đơn hàng. Vui lòng thử lại.");
            showNewPOForm(request, response);
        }
    }

    /**
     * Update purchase order
     */
    private void updatePO(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        int poID = Integer.parseInt(request.getParameter("poID"));
        int shopID = Integer.parseInt(request.getParameter("shopID"));
        int supplierID = Integer.parseInt(request.getParameter("supplierID"));
        int statusID = Integer.parseInt(request.getParameter("statusID"));
        
        PurchaseOrder po = new PurchaseOrder();
        po.setPoID(poID);
        po.setShopID(shopID);
        po.setSupplierID(supplierID);
        po.setStatusID(statusID);
        
        boolean success = poService.updatePurchaseOrder(po);
        
        if (success) {
            request.getSession().setAttribute("successMessage", "Cập nhật đơn hàng thành công!");
            response.sendRedirect(request.getContextPath() + "/purchase-order?action=view&id=" + poID);
        } else {
            request.setAttribute("errorMessage", "Không thể cập nhật đơn hàng. Vui lòng thử lại.");
            viewPODetails(request, response);
        }
    }

    /**
     * Add detail to purchase order
     */
    private void addPODetail(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        int poID = Integer.parseInt(request.getParameter("poID"));
        int ingredientID = Integer.parseInt(request.getParameter("ingredientID"));
        BigDecimal quantity = new BigDecimal(request.getParameter("quantity"));
        
        PurchaseOrderDetail detail = new PurchaseOrderDetail();
        detail.setPoID(poID);
        detail.setIngredientID(ingredientID);
        detail.setQuantity(quantity);
        detail.setReceivedQuantity(BigDecimal.ZERO);
        
        boolean success = poService.addPurchaseOrderDetail(detail);
        
        if (success) {
            request.getSession().setAttribute("successMessage", "Thêm chi tiết thành công!");
        } else {
            request.getSession().setAttribute("errorMessage", "Không thể thêm chi tiết. Vui lòng thử lại.");
        }
        
        response.sendRedirect(request.getContextPath() + "/purchase-order?action=view&id=" + poID);
    }

    /**
     * Update purchase order detail
     */
    private void updatePODetail(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        int poDetailID = Integer.parseInt(request.getParameter("poDetailID"));
        int poID = Integer.parseInt(request.getParameter("poID"));
        int ingredientID = Integer.parseInt(request.getParameter("ingredientID"));
        BigDecimal quantity = new BigDecimal(request.getParameter("quantity"));
        BigDecimal receivedQuantity = new BigDecimal(request.getParameter("receivedQuantity"));
        
        PurchaseOrderDetail detail = new PurchaseOrderDetail();
        detail.setPoDetailID(poDetailID);
        detail.setPoID(poID);
        detail.setIngredientID(ingredientID);
        detail.setQuantity(quantity);
        detail.setReceivedQuantity(receivedQuantity);
        
        boolean success = poService.updatePurchaseOrderDetail(detail);
        
        if (success) {
            request.getSession().setAttribute("successMessage", "Cập nhật chi tiết thành công!");
        } else {
            request.getSession().setAttribute("errorMessage", "Không thể cập nhật chi tiết. Vui lòng thử lại.");
        }
        
        response.sendRedirect(request.getContextPath() + "/purchase-order?action=view&id=" + poID);
    }

    /**
     * Delete purchase order detail
     */
    private void deletePODetail(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        int poDetailID = Integer.parseInt(request.getParameter("poDetailID"));
        int poID = Integer.parseInt(request.getParameter("poID"));
        
        boolean success = poService.deletePurchaseOrderDetail(poDetailID);
        
        if (success) {
            request.getSession().setAttribute("successMessage", "Xóa chi tiết thành công!");
        } else {
            request.getSession().setAttribute("errorMessage", "Không thể xóa chi tiết. Vui lòng thử lại.");
        }
        
        response.sendRedirect(request.getContextPath() + "/purchase-order?action=view&id=" + poID);
    }

    /**
     * Confirm purchase order
     */
    private void confirmPO(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        int poID = Integer.parseInt(request.getParameter("id"));
        
        boolean success = poService.confirmPurchaseOrder(poID);
        
        if (success) {
            request.getSession().setAttribute("successMessage", "Xác nhận đơn hàng thành công!");
        } else {
            request.getSession().setAttribute("errorMessage", "Không thể xác nhận đơn hàng. Vui lòng thử lại.");
        }
        
        response.sendRedirect(request.getContextPath() + "/purchase-order?action=view&id=" + poID);
    }
    
    /**
     * Update purchase order status (following workflow: Pending -> Approved -> Shipping -> Received)
     */
    private void updatePOStatus(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        int poID = Integer.parseInt(request.getParameter("id"));
        int newStatusID = Integer.parseInt(request.getParameter("statusID"));
        
        // Get current PO to verify workflow
        PurchaseOrder po = poService.getPurchaseOrderById(poID);
        
        // Validate workflow: cannot go backward
        if (po.getStatusID() >= newStatusID && po.getStatusID() != 19) {
            request.getSession().setAttribute("errorMessage", "Không thể chuyển ngược trạng thái! Vui lòng tuân thủ luồng: Pending → Approved → Shipping → Received/Cancelled");
            response.sendRedirect(request.getContextPath() + "/purchase-order?action=view&id=" + poID);
            return;
        }
        
        // Validate correct workflow
        boolean validTransition = false;
        if (po.getStatusID() == 19 && newStatusID == 20) validTransition = true;  // Pending -> Approved
        if (po.getStatusID() == 20 && newStatusID == 21) validTransition = true;  // Approved -> Shipping
        if (po.getStatusID() == 21 && (newStatusID == 22 || newStatusID == 23)) validTransition = true;  // Shipping -> Received/Cancelled
        
        if (!validTransition) {
            request.getSession().setAttribute("errorMessage", "Chuyển trạng thái không hợp lệ! Vui lòng tuân thủ luồng: Pending → Approved → Shipping → Received/Cancelled");
            response.sendRedirect(request.getContextPath() + "/purchase-order?action=view&id=" + poID);
            return;
        }
        
        boolean success = poService.updatePurchaseOrderStatus(poID, newStatusID);
        
        if (success) {
            request.getSession().setAttribute("successMessage", "Cập nhật trạng thái thành công!");
        } else {
            request.getSession().setAttribute("errorMessage", "Không thể cập nhật trạng thái. Vui lòng thử lại.");
        }
        
        response.sendRedirect(request.getContextPath() + "/purchase-order?action=view&id=" + poID);
    }
    
    /**
     * Reject purchase order with reason (only from Pending status)
     */
    private void rejectPO(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        int poID = Integer.parseInt(request.getParameter("id"));
        String rejectReason = request.getParameter("rejectReason");
        
        // Get current PO to verify can reject
        PurchaseOrder po = poService.getPurchaseOrderById(poID);
        
        if (po.getStatusID() != 19) {
            request.getSession().setAttribute("errorMessage", "Chỉ có thể từ chối đơn hàng ở trạng thái Pending!");
            response.sendRedirect(request.getContextPath() + "/purchase-order?action=view&id=" + poID);
            return;
        }
        
        if (rejectReason == null || rejectReason.trim().isEmpty()) {
            request.getSession().setAttribute("errorMessage", "Vui lòng nhập lý do từ chối!");
            response.sendRedirect(request.getContextPath() + "/purchase-order?action=view&id=" + poID);
            return;
        }
        
        // Status 23 = Cancelled
        boolean success = poService.updatePurchaseOrderStatusWithReason(poID, 23, rejectReason);
        
        if (success) {
            request.getSession().setAttribute("successMessage", "Từ chối đơn hàng thành công!");
        } else {
            request.getSession().setAttribute("errorMessage", "Không thể từ chối đơn hàng. Vui lòng thử lại.");
        }
        
        response.sendRedirect(request.getContextPath() + "/purchase-order?action=view&id=" + poID);
    }
    
    /**
     * Cancel purchase order with reason (only from Shipping status)
     */
    private void cancelPO(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        int poID = Integer.parseInt(request.getParameter("id"));
        String cancelReason = request.getParameter("cancelReason");
        
        // Get current PO to verify can cancel
        PurchaseOrder po = poService.getPurchaseOrderById(poID);
        
        if (po.getStatusID() != 21) {
            request.getSession().setAttribute("errorMessage", "Chỉ có thể hủy đơn hàng ở trạng thái Shipping!");
            response.sendRedirect(request.getContextPath() + "/purchase-order?action=view&id=" + poID);
            return;
        }
        
        if (cancelReason == null || cancelReason.trim().isEmpty()) {
            request.getSession().setAttribute("errorMessage", "Vui lòng nhập lý do hủy đơn!");
            response.sendRedirect(request.getContextPath() + "/purchase-order?action=view&id=" + poID);
            return;
        }
        
        // Status 23 = Cancelled
        boolean success = poService.updatePurchaseOrderStatusWithReason(poID, 23, cancelReason);
        
        if (success) {
            request.getSession().setAttribute("successMessage", "Hủy đơn hàng thành công!");
        } else {
            request.getSession().setAttribute("errorMessage", "Không thể hủy đơn hàng. Vui lòng thử lại.");
        }
        
        response.sendRedirect(request.getContextPath() + "/purchase-order?action=view&id=" + poID);
    }
}
