<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Chi tiết Đơn hàng - PO Details</title>
    
    <!-- Bootstrap 3.3.6 -->
    <link rel="stylesheet" href="${pageContext.request.contextPath}/bootstrap/css/bootstrap.min.css">
    <!-- Font Awesome -->
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/4.5.0/css/font-awesome.min.css">
    <!-- Theme style -->
    <link rel="stylesheet" href="${pageContext.request.contextPath}/dist/css/AdminLTE.min.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/dist/css/skins/_all-skins.min.css">
    <!-- Custom sidebar styles -->
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/sidebar-custom.css">
    
    <style>
        body {
            background-color: #ecf0f5;
        }
        
        .content-wrapper {
            margin-left: 230px;
            padding: 20px;
            min-height: 100vh;
        }
        
        .page-header {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            padding: 30px;
            border-radius: 10px;
            margin-bottom: 30px;
            box-shadow: 0 4px 15px rgba(0,0,0,0.1);
        }
        
        .page-header h1 {
            margin: 0;
            font-size: 28px;
            font-weight: 600;
        }
        
        .info-box-custom {
            background: white;
            border-radius: 10px;
            padding: 20px;
            margin-bottom: 20px;
            box-shadow: 0 2px 10px rgba(0,0,0,0.08);
            border-left: 4px solid #667eea;
        }
        
        .info-box-custom p {
            margin: 10px 0;
            font-size: 14px;
        }
        
        .info-box-custom strong {
            color: #667eea;
        }
        
        .status-badge {
            padding: 8px 16px;
            border-radius: 20px;
            font-size: 13px;
            font-weight: 600;
            text-transform: uppercase;
        }
        
        .status-pending {
            background: linear-gradient(135deg, #f7b733 0%, #fc4a1a 100%);
            color: white;
        }
        
        .status-approved {
            background: linear-gradient(135deg, #4facfe 0%, #00f2fe 100%);
            color: white;
        }
        
        .status-shipping {
            background: linear-gradient(135deg, #43e97b 0%, #38f9d7 100%);
            color: white;
        }
        
        .status-received {
            background: linear-gradient(135deg, #11998e 0%, #38ef7d 100%);
            color: white;
        }
        
        .status-cancelled {
            background: linear-gradient(135deg, #ee0979 0%, #ff6a00 100%);
            color: white;
        }
        
        .box {
            border-radius: 10px;
            box-shadow: 0 2px 10px rgba(0,0,0,0.08);
        }
        
        .box-header {
            border-radius: 10px 10px 0 0;
        }
        
        .btn-action {
            border-radius: 25px;
            padding: 10px 25px;
            margin: 5px;
            transition: all 0.3s;
            border: none;
        }
        
        .btn-action:hover {
            transform: translateY(-2px);
            box-shadow: 0 5px 15px rgba(0,0,0,0.2);
        }
        
        .modal {
            z-index: 1050;
        }
        
        .modal-backdrop {
            z-index: 1040;
        }
        
        .modal-content {
            border-radius: 15px;
            border: none;
            box-shadow: 0 5px 25px rgba(0,0,0,0.3);
        }
        
        .modal-header {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            border-radius: 15px 15px 0 0;
            border: none;
        }
        
        .modal-header.bg-danger {
            background: linear-gradient(135deg, #dc3545 0%, #c82333 100%) !important;
        }
        
        .workflow-info {
            background: #f8f9fa;
            border-left: 4px solid #17a2b8;
            padding: 15px;
            margin: 20px 0;
            border-radius: 5px;
        }
        
        .workflow-steps {
            display: flex;
            align-items: center;
            justify-content: space-between;
            margin-top: 10px;
        }
        
        .workflow-step {
            text-align: center;
            flex: 1;
        }
        
        .workflow-step .step-icon {
            width: 40px;
            height: 40px;
            border-radius: 50%;
            display: inline-flex;
            align-items: center;
            justify-content: center;
            background: #ddd;
            color: white;
            font-weight: bold;
        }
        
        .workflow-step.active .step-icon {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
        }
        
        .workflow-step.completed .step-icon {
            background: linear-gradient(135deg, #11998e 0%, #38ef7d 100%);
        }
        
        .workflow-arrow {
            color: #ddd;
            font-size: 20px;
        }
    </style>
</head>
<body class="hold-transition skin-blue sidebar-mini">
    <div class="wrapper">
        <!-- Include Sidebar -->
        <jsp:include page="../compoment/sidebar.jsp" />
        
        <!-- Content Wrapper -->
        <div class="content-wrapper">
            <!-- Page Header -->
            <div class="page-header">
                <h1><i class="fa fa-file-text-o"></i> Chi tiết Đơn hàng #PO-${po.poID}</h1>
                <ol class="breadcrumb" style="background: transparent; padding: 10px 0;">
                    <li><a href="${pageContext.request.contextPath}/inventory-dashboard" style="color: white;"><i class="fa fa-dashboard"></i> Dashboard</a></li>
                    <li><a href="${pageContext.request.contextPath}/purchase-order?action=list" style="color: white;">Danh sách đơn hàng</a></li>
                    <li class="active" style="color: rgba(255,255,255,0.8);">Chi tiết PO-${po.poID}</li>
                </ol>
            </div>
            
            <!-- Success/Error Messages -->
            <c:if test="${not empty sessionScope.successMessage}">
                <div class="alert alert-success alert-dismissible">
                    <button type="button" class="close" data-dismiss="alert">×</button>
                    <h4><i class="icon fa fa-check"></i> Thành công!</h4>
                    ${sessionScope.successMessage}
                </div>
                <c:remove var="successMessage" scope="session"/>
            </c:if>
            
            <c:if test="${not empty sessionScope.errorMessage}">
                <div class="alert alert-danger alert-dismissible">
                    <button type="button" class="close" data-dismiss="alert">×</button>
                    <h4><i class="icon fa fa-ban"></i> Lỗi!</h4>
                    ${sessionScope.errorMessage}
                </div>
                <c:remove var="errorMessage" scope="session"/>
            </c:if>
            
            <!-- Workflow Information -->
            <div class="workflow-info">
                <h4><i class="fa fa-info-circle"></i> Luồng trạng thái đơn hàng</h4>
                <p>Trạng thái chỉ được chuyển theo thứ tự: <strong>Pending → Approved → Shipping → (Received hoặc Cancelled)</strong></p>
                <div class="workflow-steps">
                    <div class="workflow-step ${po.statusID >= 19 ? 'completed' : ''}">
                        <div class="step-icon">1</div>
                        <p>Pending</p>
                    </div>
                    <span class="workflow-arrow"><i class="fa fa-arrow-right"></i></span>
                    <div class="workflow-step ${po.statusID >= 20 ? 'completed' : ''} ${po.statusID == 20 ? 'active' : ''}">
                        <div class="step-icon">2</div>
                        <p>Approved</p>
                    </div>
                    <span class="workflow-arrow"><i class="fa fa-arrow-right"></i></span>
                    <div class="workflow-step ${po.statusID >= 21 ? 'completed' : ''} ${po.statusID == 21 ? 'active' : ''}">
                        <div class="step-icon">3</div>
                        <p>Shipping</p>
                    </div>
                    <span class="workflow-arrow"><i class="fa fa-arrow-right"></i></span>
                    <div class="workflow-step ${po.statusID == 22 || po.statusID == 23 ? 'completed active' : ''}">
                        <div class="step-icon">4</div>
                        <p>Received/Cancelled</p>
                    </div>
                </div>
            </div>
            
            <!-- PO Information -->
            <div class="row">
                <div class="col-md-12">
                    <div class="box box-primary">
                        <div class="box-header with-border">
                            <h3 class="box-title"><i class="fa fa-info-circle"></i> Thông tin đơn hàng</h3>
                        </div>
                        <div class="box-body">
                            <div class="row">
                                <div class="col-md-6">
                                    <div class="info-box-custom">
                                        <p><strong><i class="fa fa-hashtag"></i> Mã đơn hàng:</strong> PO-${po.poID}</p>
                                        <p><strong><i class="fa fa-store"></i> Cửa hàng:</strong> Shop ${po.shopID}</p>
                                        <p><strong><i class="fa fa-truck"></i> Nhà cung cấp:</strong> Supplier ${po.supplierID}</p>
                                    </div>
                                </div>
                                <div class="col-md-6">
                                    <div class="info-box-custom">
                                        <p><strong><i class="fa fa-user"></i> Người tạo:</strong> User ${po.createdBy}</p>
                                        <p><strong><i class="fa fa-calendar"></i> Ngày tạo:</strong> 
                                            <fmt:formatDate value="${po.createdAt}" pattern="dd/MM/yyyy HH:mm"/>
                                        </p>
                                        <p><strong><i class="fa fa-flag"></i> Trạng thái:</strong>
                                            <c:choose>
                                                <c:when test="${po.statusID == 19}">
                                                    <span class="status-badge status-pending">Pending</span>
                                                </c:when>
                                                <c:when test="${po.statusID == 20}">
                                                    <span class="status-badge status-approved">Approved</span>
                                                </c:when>
                                                <c:when test="${po.statusID == 21}">
                                                    <span class="status-badge status-shipping">Shipping</span>
                                                </c:when>
                                                <c:when test="${po.statusID == 22}">
                                                    <span class="status-badge status-received">Received</span>
                                                </c:when>
                                                <c:otherwise>
                                                    <span class="status-badge status-cancelled">Cancelled</span>
                                                </c:otherwise>
                                            </c:choose>
                                        </p>
                                    </div>
                                </div>
                            </div>
                            
                            <!-- Action Buttons -->
                            <div class="text-center" style="margin-top: 20px;">
                                <a href="${pageContext.request.contextPath}/purchase-order?action=list" class="btn btn-default btn-action">
                                    <i class="fa fa-arrow-left"></i> Quay lại
                                </a>
                                
                                <c:if test="${po.statusID == 20}">
                                    <a href="${pageContext.request.contextPath}/purchase-order?action=edit&id=${po.poID}" class="btn btn-warning btn-action">
                                        <i class="fa fa-edit"></i> Chỉnh sửa
                                    </a>
                                    <button type="button" class="btn btn-success btn-action" onclick="confirmApprove(${po.poID})">
                                        <i class="fa fa-check-circle"></i> Duyệt đơn (Approved)
                                    </button>
                                    <button type="button" class="btn btn-danger btn-action" onclick="showRejectModal()">
                                        <i class="fa fa-times-circle"></i> Từ chối (Reject)
                                    </button>
                                </c:if>
                                
                                <c:if test="${po.statusID == 21}">
                                    <button type="button" class="btn btn-info btn-action" onclick="updateStatus(${po.poID}, 22, 'Shipping')">
                                        <i class="fa fa-truck"></i> Chuyển sang Shipping
                                    </button>
                                </c:if>
                                
                                <c:if test="${po.statusID == 22}">
                                    <button type="button" class="btn btn-success btn-action" onclick="updateStatus(${po.poID}, 23, 'Received')">
                                        <i class="fa fa-check"></i> Đã nhận hàng (Received)
                                    </button>
                                    <button type="button" class="btn btn-danger btn-action" onclick="showCancelModal()">
                                        <i class="fa fa-ban"></i> Hủy đơn (Cancel)
                                    </button>
                                </c:if>
                                
                                <!-- Status 23 (Received) and 24 (Cancelled) are final states - no actions available -->
                                <c:if test="${po.statusID == 23 || po.statusID == 24}">
                                    <div class="alert alert-info" style="margin-top: 10px;">
                                        <i class="fa fa-info-circle"></i> 
                                        Đơn hàng đã hoàn tất. Không thể thực hiện thêm thao tác nào.
                                    </div>
                                </c:if>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
            
            <!-- PO Details Table -->
            <div class="row">
                <div class="col-md-12">
                    <div class="box box-success">
                        <div class="box-header with-border">
                            <h3 class="box-title"><i class="fa fa-list"></i> Chi tiết nguyên liệu</h3>
                            <c:if test="${po.statusID == 19}">
                                <div class="box-tools pull-right">
                                    <button type="button" class="btn btn-success btn-sm" data-toggle="modal" data-target="#addDetailModal">
                                        <i class="fa fa-plus"></i> Thêm nguyên liệu
                                    </button>
                                </div>
                            </c:if>
                        </div>
                        <div class="box-body">
                            <div class="table-responsive">
                                <table class="table table-bordered table-striped table-hover">
                                    <thead>
                                        <tr>
                                            <th style="width: 50px;">STT</th>
                                            <th style="width: 100px;">Mã chi tiết</th>
                                            <th>Nguyên liệu</th>
                                            <th style="width: 120px;">Số lượng đặt</th>
                                            <th style="width: 120px;">Số lượng nhận</th>
                                            <th style="width: 150px;">Thao tác</th>
                                        </tr>
                                    </thead>
                                    <tbody>
                                        <c:choose>
                                            <c:when test="${empty details}">
                                                <tr>
                                                    <td colspan="6" class="text-center" style="padding: 50px;">
                                                        <i class="fa fa-inbox" style="font-size: 60px; color: #ccc;"></i>
                                                        <p style="color: #999; margin-top: 15px; font-size: 16px;">Chưa có chi tiết nào</p>
                                                    </td>
                                                </tr>
                                            </c:when>
                                            <c:otherwise>
                                                <c:forEach var="detail" items="${details}" varStatus="status">
                                                    <tr>
                                                        <td>${status.index + 1}</td>
                                                        <td><span class="label label-info">POD-${detail.poDetailID}</span></td>
                                                        <td>Ingredient ${detail.ingredientID}</td>
                                                        <td><span class="badge bg-blue">${detail.quantity}</span></td>
                                                        <td><span class="badge bg-green">${detail.receivedQuantity}</span></td>
                                                        <td>
                                                            <c:if test="${po.statusID == 19}">
                                                                <button type="button" class="btn btn-warning btn-xs" 
                                                                        data-toggle="modal" 
                                                                        data-target="#editDetailModal${detail.poDetailID}">
                                                                    <i class="fa fa-edit"></i> Sửa
                                                                </button>
                                                                <form action="${pageContext.request.contextPath}/purchase-order" method="post" style="display: inline;">
                                                                    <input type="hidden" name="action" value="delete-detail">
                                                                    <input type="hidden" name="poDetailID" value="${detail.poDetailID}">
                                                                    <input type="hidden" name="poID" value="${po.poID}">
                                                                    <button type="submit" class="btn btn-danger btn-xs" 
                                                                            onclick="return confirm('Bạn có chắc muốn xóa chi tiết này?')">
                                                                        <i class="fa fa-trash"></i> Xóa
                                                                    </button>
                                                                </form>
                                                            </c:if>
                                                        </td>
                                                    </tr>
                                                    
                                                    <!-- Edit Detail Modal -->
                                                    <div class="modal fade" id="editDetailModal${detail.poDetailID}" tabindex="-1">
                                                        <div class="modal-dialog">
                                                            <div class="modal-content">
                                                                <div class="modal-header">
                                                                    <button type="button" class="close" data-dismiss="modal">&times;</button>
                                                                    <h4 class="modal-title">Chỉnh sửa chi tiết</h4>
                                                                </div>
                                                                <form action="${pageContext.request.contextPath}/purchase-order" method="post">
                                                                    <div class="modal-body">
                                                                        <input type="hidden" name="action" value="update-detail">
                                                                        <input type="hidden" name="poDetailID" value="${detail.poDetailID}">
                                                                        <input type="hidden" name="poID" value="${po.poID}">
                                                                        
                                                                        <div class="form-group">
                                                                            <label>Nguyên liệu</label>
                                                                            <select name="ingredientID" class="form-control" required>
                                                                                <c:forEach var="ingredient" items="${ingredients}">
                                                                                    <option value="${ingredient.ingredientID}" 
                                                                                            ${ingredient.ingredientID == detail.ingredientID ? 'selected' : ''}>
                                                                                        ${ingredient.name}
                                                                                    </option>
                                                                                </c:forEach>
                                                                            </select>
                                                                        </div>
                                                                        
                                                                        <div class="form-group">
                                                                            <label>Số lượng đặt</label>
                                                                            <input type="number" name="quantity" class="form-control" 
                                                                                   value="${detail.quantity}" step="0.01" required>
                                                                        </div>
                                                                        
                                                                        <div class="form-group">
                                                                            <label>Số lượng nhận</label>
                                                                            <input type="number" name="receivedQuantity" class="form-control" 
                                                                                   value="${detail.receivedQuantity}" step="0.01" required>
                                                                        </div>
                                                                    </div>
                                                                    <div class="modal-footer">
                                                                        <button type="button" class="btn btn-default" data-dismiss="modal">Hủy</button>
                                                                        <button type="submit" class="btn btn-primary">Cập nhật</button>
                                                                    </div>
                                                                </form>
                                                            </div>
                                                        </div>
                                                    </div>
                                                </c:forEach>
                                            </c:otherwise>
                                        </c:choose>
                                    </tbody>
                                </table>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
    
    <!-- Add Detail Modal -->
    <div class="modal fade" id="addDetailModal" tabindex="-1">
        <div class="modal-dialog">
            <div class="modal-content">
                <div class="modal-header">
                    <button type="button" class="close" data-dismiss="modal">&times;</button>
                    <h4 class="modal-title">Thêm nguyên liệu mới</h4>
                </div>
                <form action="${pageContext.request.contextPath}/purchase-order" method="post">
                    <div class="modal-body">
                        <input type="hidden" name="action" value="add-detail">
                        <input type="hidden" name="poID" value="${po.poID}">
                        
                        <div class="form-group">
                            <label>Nguyên liệu</label>
                            <select name="ingredientID" class="form-control" required>
                                <option value="">-- Chọn nguyên liệu --</option>
                                <c:forEach var="ingredient" items="${ingredients}">
                                    <option value="${ingredient.ingredientID}">${ingredient.name}</option>
                                </c:forEach>
                            </select>
                        </div>
                        
                        <div class="form-group">
                            <label>Số lượng</label>
                            <input type="number" name="quantity" class="form-control" step="0.01" required>
                        </div>
                    </div>
                    <div class="modal-footer">
                        <button type="button" class="btn btn-default" data-dismiss="modal">Hủy</button>
                        <button type="submit" class="btn btn-primary">Thêm</button>
                    </div>
                </form>
            </div>
        </div>
    </div>
    
    <!-- Reject Modal -->
    <div class="modal fade" id="rejectModal" tabindex="-1" role="dialog">
        <div class="modal-dialog" role="document">
            <div class="modal-content">
                <div class="modal-header bg-danger">
                    <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                        <span aria-hidden="true">&times;</span>
                    </button>
                    <h4 class="modal-title" style="color: white;"><i class="fa fa-times-circle"></i> Từ chối đơn hàng</h4>
                </div>
                <form id="rejectForm" action="${pageContext.request.contextPath}/purchase-order" method="post" onsubmit="return validateRejectForm()">
                    <div class="modal-body">
                        <input type="hidden" name="action" value="reject">
                        <input type="hidden" name="id" value="${po.poID}">
                        
                        <div class="alert alert-warning">
                            <i class="fa fa-exclamation-triangle"></i> Bạn đang từ chối đơn hàng <strong>PO-${po.poID}</strong>. Vui lòng cung cấp lý do từ chối.
                        </div>
                        
                        <div class="form-group">
                            <label>Lý do từ chối <span class="text-danger">*</span></label>
                            <textarea id="rejectReasonInput" name="rejectReason" class="form-control" rows="4" 
                                      placeholder="Nhập lý do từ chối đơn hàng (tối thiểu 10 ký tự)..." 
                                      style="resize: vertical;"></textarea>
                            <small class="help-block text-muted">
                                <i class="fa fa-info-circle"></i> Vui lòng nhập ít nhất 10 ký tự để mô tả lý do từ chối.
                            </small>
                        </div>
                    </div>
                    <div class="modal-footer">
                        <button type="button" class="btn btn-default" data-dismiss="modal">Đóng</button>
                        <button type="submit" class="btn btn-danger"><i class="fa fa-times-circle"></i> Xác nhận từ chối</button>
                    </div>
                </form>
            </div>
        </div>
    </div>
    
    <!-- Cancel Modal (for Shipping status) -->
    <div class="modal fade" id="cancelModal" tabindex="-1" role="dialog">
        <div class="modal-dialog" role="document">
            <div class="modal-content">
                <div class="modal-header bg-danger">
                    <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                        <span aria-hidden="true">&times;</span>
                    </button>
                    <h4 class="modal-title" style="color: white;"><i class="fa fa-ban"></i> Hủy đơn hàng</h4>
                </div>
                <form id="cancelForm" action="${pageContext.request.contextPath}/purchase-order" method="post" onsubmit="return validateCancelForm()">
                    <div class="modal-body">
                        <input type="hidden" name="action" value="cancel">
                        <input type="hidden" name="id" value="${po.poID}">
                        
                        <div class="alert alert-danger">
                            <i class="fa fa-exclamation-triangle"></i> Bạn đang hủy đơn hàng <strong>PO-${po.poID}</strong>. Vui lòng cung cấp lý do hủy.
                        </div>
                        
                        <div class="form-group">
                            <label>Lý do hủy <span class="text-danger">*</span></label>
                            <textarea id="cancelReasonInput" name="cancelReason" class="form-control" rows="4" 
                                      placeholder="Nhập lý do hủy đơn hàng (tối thiểu 10 ký tự)..." 
                                      style="resize: vertical;"></textarea>
                            <small class="help-block text-muted">
                                <i class="fa fa-info-circle"></i> Vui lòng nhập ít nhất 10 ký tự để mô tả lý do hủy.
                            </small>
                        </div>
                    </div>
                    <div class="modal-footer">
                        <button type="button" class="btn btn-default" data-dismiss="modal">Đóng</button>
                        <button type="submit" class="btn btn-danger"><i class="fa fa-ban"></i> Xác nhận hủy đơn</button>
                    </div>
                </form>
            </div>
        </div>
    </div>
    
    <!-- jQuery 2.2.3 - Try local first, fallback to CDN -->
    <script src="${pageContext.request.contextPath}/plugins/jQuery/jquery-2.2.3.min.js"></script>
    <script>
        // Fallback to CDN if local jQuery fails to load
        if (typeof jQuery === 'undefined') {
            document.write('<script src="https://code.jquery.com/jquery-2.2.3.min.js"><\/script>');
        }
    </script>
    <!-- Bootstrap 3.3.6 -->
    <script src="${pageContext.request.contextPath}/bootstrap/js/bootstrap.min.js"></script>
    <!-- AdminLTE App -->
    <script src="${pageContext.request.contextPath}/dist/js/app.min.js"></script>
    
    <script>
        // ===== DEBUG: Kiểm tra jQuery ngay khi script được load =====
        console.log('Script tag loaded');
        console.log('jQuery available:', typeof jQuery !== 'undefined');
        console.log('$ available:', typeof $ !== 'undefined');
        
        // ===== GLOBAL FUNCTIONS (phải khai báo NGOÀI document.ready) =====
        
        // Function để hiện cancel modal
        function showCancelModal() {
            console.log('showCancelModal() called');
            console.log('Checking jQuery...');
            console.log('typeof $:', typeof $);
            console.log('typeof jQuery:', typeof jQuery);
            
            if (typeof $ === 'undefined' && typeof jQuery === 'undefined') {
                var msg = 'Lỗi: jQuery chưa được load!\n\n';
                msg += 'Vui lòng:\n';
                msg += '1. Kiểm tra Console (F12) có lỗi 404 không\n';
                msg += '2. Reload trang với Ctrl+F5\n';
                msg += '3. Kiểm tra đường dẫn jQuery file';
                alert(msg);
                return;
            }
            
            // Nếu jQuery tồn tại nhưng $ không, dùng jQuery
            var jq = (typeof $ !== 'undefined') ? $ : jQuery;
            
            try {
                console.log('Attempting to show modal...');
                jq('#cancelModal').modal('show');
                console.log('Modal show command executed');
            } catch (error) {
                console.error('Error showing modal:', error);
                alert('Lỗi: Không thể mở modal. ' + error.message);
            }
        }
        
        // Function để hiện reject modal
        function showRejectModal() {
            console.log('showRejectModal() called');
            console.log('Checking jQuery...');
            console.log('typeof $:', typeof $);
            console.log('typeof jQuery:', typeof jQuery);
            
            if (typeof $ === 'undefined' && typeof jQuery === 'undefined') {
                var msg = 'Lỗi: jQuery chưa được load!\n\n';
                msg += 'Vui lòng:\n';
                msg += '1. Kiểm tra Console (F12) có lỗi 404 không\n';
                msg += '2. Reload trang với Ctrl+F5\n';
                msg += '3. Kiểm tra đường dẫn jQuery file';
                alert(msg);
                return;
            }
            
            // Nếu jQuery tồn tại nhưng $ không, dùng jQuery
            var jq = (typeof $ !== 'undefined') ? $ : jQuery;
            
            try {
                console.log('Attempting to show modal...');
                jq('#rejectModal').modal('show');
                console.log('Modal show command executed');
            } catch (error) {
                console.error('Error showing modal:', error);
                alert('Lỗi: Không thể mở modal. ' + error.message);
            }
        }
        
        // ===== DOCUMENT READY =====
        (function() {
            // Dùng jQuery hoặc $ tùy theo cái nào có sẵn
            var jq = (typeof $ !== 'undefined') ? $ : (typeof jQuery !== 'undefined' ? jQuery : null);
            
            if (!jq) {
                console.error('FATAL: jQuery not loaded!');
                alert('FATAL ERROR: jQuery chưa được load. Vui lòng reload trang!');
                return;
            }
            
            jq(document).ready(function() {
                console.log('=== PO Details Page Loaded ===');
                console.log('jQuery loaded successfully');
                console.log('jQuery version:', jq.fn.jquery);
                console.log('$ defined:', typeof $ !== 'undefined');
                console.log('jQuery defined:', typeof jQuery !== 'undefined');
                console.log('Bootstrap version:', jq.fn.modal ? 'loaded' : 'not loaded');
                console.log('Cancel Modal exists:', jq('#cancelModal').length > 0);
                console.log('Reject Modal exists:', jq('#rejectModal').length > 0);
            
                // Reset form khi đóng modal
                jq('#cancelModal').on('hidden.bs.modal', function () {
                    console.log('Cancel modal closed, resetting form');
                    jq('#cancelForm')[0].reset();
                });
                
                jq('#rejectModal').on('hidden.bs.modal', function () {
                    console.log('Reject modal closed, resetting form');
                    jq('#rejectForm')[0].reset();
                });
                
                // Debug: Log khi modal được mở
                jq('#cancelModal').on('show.bs.modal', function () {
                    console.log('Cancel modal opening...');
                });
                
                jq('#cancelModal').on('shown.bs.modal', function () {
                    console.log('Cancel modal opened successfully');
                    // Focus vào textarea
                    jq('#cancelReasonInput').focus();
                });
                
                jq('#rejectModal').on('shown.bs.modal', function () {
                    console.log('Reject modal opened successfully');
                    jq('#rejectReasonInput').focus();
                });
            });
        })();
        
        function confirmApprove(poID) {
            if (confirm('Bạn có chắc muốn duyệt đơn hàng này? Sau khi duyệt, trạng thái sẽ chuyển sang Approved.')) {
                // Call approve action directly
                var form = document.createElement('form');
                form.method = 'POST';
                form.action = '${pageContext.request.contextPath}/purchase-order';
                
                var actionInput = document.createElement('input');
                actionInput.type = 'hidden';
                actionInput.name = 'action';
                actionInput.value = 'approve';
                form.appendChild(actionInput);
                
                var poIDInput = document.createElement('input');
                poIDInput.type = 'hidden';
                poIDInput.name = 'poID';
                poIDInput.value = poID;
                form.appendChild(poIDInput);
                
                document.body.appendChild(form);
                form.submit();
            }
        }
        
        function updateStatus(poID, statusID, statusName) {
            console.log('Updating status:', poID, statusID, statusName);
            var form = document.createElement('form');
            form.method = 'POST';
            form.action = '${pageContext.request.contextPath}/purchase-order';
            
            var actionInput = document.createElement('input');
            actionInput.type = 'hidden';
            actionInput.name = 'action';
            actionInput.value = 'update-status';
            form.appendChild(actionInput);
            
            var idInput = document.createElement('input');
            idInput.type = 'hidden';
            idInput.name = 'id';
            idInput.value = poID;
            form.appendChild(idInput);
            
            var statusInput = document.createElement('input');
            statusInput.type = 'hidden';
            statusInput.name = 'statusID';
            statusInput.value = statusID;
            form.appendChild(statusInput);
            
            document.body.appendChild(form);
            form.submit();
        }
        
        function validateCancelForm() {
            console.log('=== validateCancelForm() called ===');
            var cancelReasonInput = document.getElementById('cancelReasonInput');
            
            if (!cancelReasonInput) {
                console.error('Cancel reason input not found!');
                alert('Lỗi: Không tìm thấy trường nhập lý do!');
                return false;
            }
            
            var cancelReason = cancelReasonInput.value.trim();
            console.log('Cancel reason:', cancelReason);
            console.log('Cancel reason length:', cancelReason.length);
            
            if (cancelReason.length === 0) {
                alert('⚠️ Vui lòng nhập lý do hủy đơn hàng!');
                cancelReasonInput.focus();
                return false;
            }
            
            if (cancelReason.length < 10) {
                alert('⚠️ Lý do hủy phải có ít nhất 10 ký tự!\n\nBạn đã nhập: ' + cancelReason.length + ' ký tự\nCần thêm: ' + (10 - cancelReason.length) + ' ký tự');
                cancelReasonInput.focus();
                return false;
            }
            
            console.log('✓ Cancel form validation passed');
            console.log('Submitting form...');
            return true;
        }
        
        function validateRejectForm() {
            console.log('=== validateRejectForm() called ===');
            var rejectReasonInput = document.getElementById('rejectReasonInput');
            
            if (!rejectReasonInput) {
                console.error('Reject reason input not found!');
                alert('Lỗi: Không tìm thấy trường nhập lý do!');
                return false;
            }
            
            var rejectReason = rejectReasonInput.value.trim();
            console.log('Reject reason:', rejectReason);
            console.log('Reject reason length:', rejectReason.length);
            
            if (rejectReason.length === 0) {
                alert('⚠️ Vui lòng nhập lý do từ chối đơn hàng!');
                rejectReasonInput.focus();
                return false;
            }
            
            if (rejectReason.length < 10) {
                alert('⚠️ Lý do từ chối phải có ít nhất 10 ký tự!\n\nBạn đã nhập: ' + rejectReason.length + ' ký tự\nCần thêm: ' + (10 - rejectReason.length) + ' ký tự');
                rejectReasonInput.focus();
                return false;
            }
            
            console.log('✓ Reject form validation passed');
            console.log('Submitting form...');
            return true;
        }
    </script>
</body>
</html>
