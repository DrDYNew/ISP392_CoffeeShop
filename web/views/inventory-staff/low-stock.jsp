<%@page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="utf-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <title>Nguyên liệu sắp hết - Coffee Shop</title>
    <!-- Tell the browser to be responsive to screen width -->
    <meta content="width=device-width, initial-scale=1, maximum-scale=1, user-scalable=no" name="viewport">
    <!-- Bootstrap 3.3.6 -->
    <link rel="stylesheet" href="${pageContext.request.contextPath}/bootstrap/css/bootstrap.min.css">
    <!-- Font Awesome -->
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/4.5.0/css/font-awesome.min.css">
    <!-- Ionicons -->
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/ionicons/2.0.1/css/ionicons.min.css">
    <!-- Theme style -->
    <link rel="stylesheet" href="${pageContext.request.contextPath}/dist/css/AdminLTE.min.css">
    <!-- AdminLTE Skins -->
    <link rel="stylesheet" href="${pageContext.request.contextPath}/dist/css/skins/_all-skins.min.css">
        <style>
            .alert-card {
                border-left: 4px solid #e53e3e;
                background: #fff5f5;
                border-radius: 8px;
                transition: all 0.3s ease;
                margin-bottom: 15px;
            }
            
            .alert-card:hover {
                box-shadow: 0 4px 12px rgba(0,0,0,0.1);
                transform: translateY(-2px);
            }
            
            .critical-low {
                border-left-color: #c53030;
                background: #fed7d7;
            }
            
            .warning-low {
                border-left-color: #d69e2e;
                background: #feebc8;
            }
            
            .threshold-section {
                background: #f8f9fa;
                padding: 20px;
                border-radius: 8px;
                margin-bottom: 20px;
            }
            
            .stock-quantity {
                font-size: 18px;
                font-weight: bold;
            }
            
            .critical {
                color: #c53030;
            }
            
            .warning {
                color: #d69e2e;
            }
            
            .action-buttons .btn {
                margin-right: 5px;
                margin-bottom: 5px;
            }
            
            .priority-high {
                border-left-color: #c53030 !important;
                background: #fed7d7 !important;
            }
            
            .priority-medium {
                border-left-color: #d69e2e !important;
                background: #feebc8 !important;
            }
        </style>
    </head>
    <body class="hold-transition skin-blue sidebar-mini">
        <div class="wrapper">
            <%@include file="../compoment/sidebar.jsp" %>
            <%@include file="../compoment/header.jsp" %>
            
            <div class="content-wrapper">
                <section class="content-header">
                    <h1>
                        Nguyên liệu sắp hết
                        <small>Danh sách nguyên liệu cần bổ sung</small>
                    </h1>
                    <ol class="breadcrumb">
                        <li><a href="${pageContext.request.contextPath}/views/inventory-staff/dashboard.jsp"><i class="fa fa-dashboard"></i> Dashboard</a></li>
                        <li><a href="${pageContext.request.contextPath}/ingredient">Quản lý nguyên liệu</a></li>
                        <li class="active">Nguyên liệu sắp hết</li>
                    </ol>
                </section>

                <section class="content">
                    <!-- Threshold Setting -->
                    <div class="threshold-section">
                        <form method="GET" action="${pageContext.request.contextPath}/ingredient">
                            <input type="hidden" name="action" value="low-stock">
                            <div class="row">
                                <div class="col-md-4">
                                    <div class="form-group">
                                        <label for="threshold">Ngưỡng cảnh báo:</label>
                                        <div class="input-group">
                                            <input type="number" step="0.01" min="0" name="threshold" 
                                                   id="threshold" class="form-control" 
                                                   value="${threshold}" placeholder="10.0">
                                            <div class="input-group-addon">đơn vị</div>
                                        </div>
                                        <small class="help-block">Hiển thị nguyên liệu có tồn kho thấp hơn ngưỡng này</small>
                                    </div>
                                </div>
                                <div class="col-md-2">
                                    <div class="form-group">
                                        <label>&nbsp;</label>
                                        <button type="submit" class="btn btn-primary btn-block">
                                            <i class="fa fa-search"></i> Cập nhật
                                        </button>
                                    </div>
                                </div>
                                <div class="col-md-6">
                                    <div class="form-group">
                                        <label>&nbsp;</label>
                                        <div class="btn-group btn-block" role="group">
                                            <a href="${pageContext.request.contextPath}/ingredient" 
                                               class="btn btn-default">
                                                <i class="fa fa-arrow-left"></i> Quay lại danh sách
                                            </a>
                                            <a href="${pageContext.request.contextPath}/ingredient?action=create" 
                                               class="btn btn-success">
                                                <i class="fa fa-plus"></i> Thêm nguyên liệu
                                            </a>
                                            <button type="button" class="btn btn-warning" onclick="createBulkOrder()">
                                                <i class="fa fa-shopping-cart"></i> Đặt hàng tất cả
                                            </button>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </form>
                    </div>

                    <!-- Statistics Row -->
                    <div class="row">
                        <div class="col-lg-3 col-xs-6">
                            <div class="small-box bg-red">
                                <div class="inner">
                                    <h3>
                                        <c:set var="criticalCount" value="0"/>
                                        <c:forEach var="ingredient" items="${lowStockIngredients}">
                                            <c:if test="${ingredient.stockQuantity < 5}">
                                                <c:set var="criticalCount" value="${criticalCount + 1}"/>
                                            </c:if>
                                        </c:forEach>
                                        ${criticalCount}
                                    </h3>
                                    <p>Nguy cấp (&lt; 5)</p>
                                </div>
                                <div class="icon">
                                    <i class="fa fa-exclamation-triangle"></i>
                                </div>
                            </div>
                        </div>
                        
                        <div class="col-lg-3 col-xs-6">
                            <div class="small-box bg-yellow">
                                <div class="inner">
                                    <h3>
                                        <c:set var="warningCount" value="0"/>
                                        <c:forEach var="ingredient" items="${lowStockIngredients}">
                                            <c:if test="${ingredient.stockQuantity >= 5 && ingredient.stockQuantity < threshold}">
                                                <c:set var="warningCount" value="${warningCount + 1}"/>
                                            </c:if>
                                        </c:forEach>
                                        ${warningCount}
                                    </h3>
                                    <p>Cảnh báo (5 - ${threshold})</p>
                                </div>
                                <div class="icon">
                                    <i class="fa fa-warning"></i>
                                </div>
                            </div>
                        </div>
                        
                        <div class="col-lg-3 col-xs-6">
                            <div class="small-box bg-blue">
                                <div class="inner">
                                    <h3>${fn:length(lowStockIngredients)}</h3>
                                    <p>Tổng nguyên liệu</p>
                                </div>
                                <div class="icon">
                                    <i class="fa fa-list"></i>
                                </div>
                            </div>
                        </div>
                        
                        <div class="col-lg-3 col-xs-6">
                            <div class="small-box bg-green">
                                <div class="inner">
                                    <h3>
                                        <fmt:formatNumber value="${threshold}" pattern="#,##0.##"/>
                                    </h3>
                                    <p>Ngưỡng cảnh báo</p>
                                </div>
                                <div class="icon">
                                    <i class="fa fa-cog"></i>
                                </div>
                            </div>
                        </div>
                    </div>

                    <!-- Low Stock Ingredients List -->
                    <div class="row">
                        <div class="col-md-12">
                            <div class="box">
                                <div class="box-header">
                                    <h3 class="box-title">
                                        Danh sách nguyên liệu sắp hết
                                        <span class="label label-danger">${fn:length(lowStockIngredients)} nguyên liệu</span>
                                    </h3>
                                </div>
                                <div class="box-body">
                                    <c:choose>
                                        <c:when test="${empty lowStockIngredients}">
                                            <div class="text-center">
                                                <div class="alert alert-success">
                                                    <h4><i class="fa fa-check-circle"></i> Tuyệt vời!</h4>
                                                    <p>Không có nguyên liệu nào sắp hết với ngưỡng cảnh báo hiện tại.</p>
                                                    <p>Tất cả nguyên liệu đều có đủ tồn kho.</p>
                                                </div>
                                                <a href="${pageContext.request.contextPath}/ingredient" 
                                                   class="btn btn-primary">
                                                    <i class="fa fa-list"></i> Xem tất cả nguyên liệu
                                                </a>
                                            </div>
                                        </c:when>
                                        <c:otherwise>
                                            <c:forEach var="ingredient" items="${lowStockIngredients}" varStatus="status">
                                                <div class="alert-card 
                                                    <c:choose>
                                                        <c:when test="${ingredient.stockQuantity < 5}">priority-high</c:when>
                                                        <c:otherwise>priority-medium</c:otherwise>
                                                    </c:choose>">
                                                    <div class="box-body">
                                                        <div class="row">
                                                            <div class="col-md-6">
                                                                <h4>
                                                                    <strong>${ingredient.name}</strong>
                                                                    <c:if test="${ingredient.stockQuantity < 5}">
                                                                        <span class="label label-danger">NGUY CẤP</span>
                                                                    </c:if>
                                                                </h4>
                                                                <p class="text-muted">
                                                                    Mã: #${ingredient.ingredientID} | 
                                                                    Nhà cung cấp: ${ingredient.supplierID} |
                                                                    Đơn vị: ${ingredient.unitID}
                                                                </p>
                                                            </div>
                                                            <div class="col-md-3 text-center">
                                                                <div class="stock-quantity 
                                                                    <c:choose>
                                                                        <c:when test="${ingredient.stockQuantity < 5}">critical</c:when>
                                                                        <c:otherwise>warning</c:otherwise>
                                                                    </c:choose>">
                                                                    <fmt:formatNumber value="${ingredient.stockQuantity}" pattern="#,##0.##"/>
                                                                </div>
                                                                <small class="text-muted">Số lượng tồn kho</small>
                                                            </div>
                                                            <div class="col-md-3 text-right action-buttons">
                                                                <button type="button" class="btn btn-primary btn-sm quick-order-btn" 
                                                                        data-ingredient-id="${ingredient.ingredientID}"
                                                                        data-ingredient-name="${ingredient.name}">
                                                                    <i class="fa fa-shopping-cart"></i> Đặt hàng
                                                                </button>
                                                                
                                                                <button type="button" class="btn btn-info btn-sm update-stock-btn" 
                                                                        data-ingredient-id="${ingredient.ingredientID}"
                                                                        data-ingredient-name="${ingredient.name}"
                                                                        data-current-quantity="${ingredient.stockQuantity}">
                                                                    <i class="fa fa-edit"></i> Cập nhật
                                                                </button>
                                                                
                                                                <a href="${pageContext.request.contextPath}/ingredient?action=view&id=${ingredient.ingredientID}" 
                                                                   class="btn btn-default btn-sm">
                                                                    <i class="fa fa-eye"></i> Chi tiết
                                                                </a>
                                                            </div>
                                                        </div>
                                                        
                                                        <!-- Progress Bar -->
                                                        <div class="row" style="margin-top: 10px;">
                                                            <div class="col-md-12">
                                                                <div class="progress progress-xs">
                                                                    <c:set var="percentage" value="${(ingredient.stockQuantity / threshold) * 100}"/>
                                                                    <c:if test="${percentage > 100}">
                                                                        <c:set var="percentage" value="100"/>
                                                                    </c:if>
                                                                    <div class="progress-bar 
                                                                        <c:choose>
                                                                            <c:when test="${percentage < 25}">progress-bar-danger</c:when>
                                                                            <c:when test="${percentage < 50}">progress-bar-warning</c:when>
                                                                            <c:otherwise>progress-bar-success</c:otherwise>
                                                                        </c:choose>" 
                                                                        style="width: ${percentage}%">
                                                                    </div>
                                                                </div>
                                                                <small class="text-muted">
                                                                    <fmt:formatNumber value="${percentage}" pattern="#.#"/>% so với ngưỡng cảnh báo
                                                                </small>
                                                            </div>
                                                        </div>
                                                    </div>
                                                </div>
                                            </c:forEach>
                                        </c:otherwise>
                                    </c:choose>
                                </div>
                            </div>
                        </div>
                    </div>
                </section>
            </div>
        </div>

        <!-- Quick Order Modal -->
        <div class="modal fade" id="quickOrderModal" tabindex="-1" role="dialog">
            <div class="modal-dialog" role="document">
                <div class="modal-content">
                    <div class="modal-header">
                        <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                            <span aria-hidden="true">&times;</span>
                        </button>
                        <h4 class="modal-title">Đặt hàng nhanh</h4>
                    </div>
                    <div class="modal-body">
                        <form id="quickOrderForm">
                            <input type="hidden" id="orderIngredientId">
                            
                            <div class="form-group">
                                <label>Nguyên liệu:</label>
                                <p id="orderIngredientName" class="form-control-static"></p>
                            </div>
                            
                            <div class="form-group">
                                <label for="orderQuantity">Số lượng đặt hàng: <span class="text-danger">*</span></label>
                                <input type="number" step="0.01" min="1" id="orderQuantity" 
                                       class="form-control" required placeholder="Nhập số lượng cần đặt">
                            </div>
                            
                            <div class="form-group">
                                <label for="orderNote">Ghi chú:</label>
                                <textarea id="orderNote" class="form-control" rows="3" 
                                          placeholder="Ghi chú cho đơn đặt hàng (tùy chọn)"></textarea>
                            </div>
                        </form>
                    </div>
                    <div class="modal-footer">
                        <button type="button" class="btn btn-default" data-dismiss="modal">Hủy</button>
                        <button type="button" class="btn btn-primary" onclick="submitQuickOrder()">Tạo đơn đặt hàng</button>
                    </div>
                </div>
            </div>
        </div>

        <!-- Quick Stock Update Modal -->
        <div class="modal fade" id="stockUpdateModal" tabindex="-1" role="dialog">
            <div class="modal-dialog" role="document">
                <div class="modal-content">
                    <div class="modal-header">
                        <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                            <span aria-hidden="true">&times;</span>
                        </button>
                        <h4 class="modal-title">Cập nhật số lượng tồn kho</h4>
                    </div>
                    <form method="POST" action="${pageContext.request.contextPath}/ingredient">
                        <div class="modal-body">
                            <input type="hidden" name="action" value="update-stock">
                            <input type="hidden" name="ingredientId" id="stockIngredientId">
                            
                            <div class="form-group">
                                <label>Nguyên liệu:</label>
                                <p id="stockIngredientName" class="form-control-static"></p>
                            </div>
                            
                            <div class="form-group">
                                <label>Số lượng hiện tại:</label>
                                <p id="stockCurrentQuantity" class="form-control-static"></p>
                            </div>
                            
                            <div class="form-group">
                                <label for="newQuantity">Số lượng mới: <span class="text-danger">*</span></label>
                                <input type="number" step="0.01" min="0" name="newQuantity" 
                                       id="newQuantity" class="form-control" required>
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

        <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
        <!-- jQuery 3.6.0 -->
        <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
        <!-- Bootstrap 3.3.6 -->
        <script src="${pageContext.request.contextPath}/bootstrap/js/bootstrap.min.js"></script>
        <!-- AdminLTE App -->
        <script src="${pageContext.request.contextPath}/dist/js/app.min.js"></script>
        <script>
            $(document).ready(function() {
                $('.quick-order-btn').click(function() {
                    var ingredientId = $(this).data('ingredient-id');
                    var ingredientName = $(this).data('ingredient-name');
                    quickOrder(ingredientId, ingredientName);
                });
                
                $('.update-stock-btn').click(function() {
                    var ingredientId = $(this).data('ingredient-id');
                    var ingredientName = $(this).data('ingredient-name');
                    var currentQuantity = $(this).data('current-quantity');
                    quickUpdateStock(ingredientId, ingredientName, currentQuantity);
                });
            });
            
            function quickOrder(ingredientId, ingredientName) {
                document.getElementById('orderIngredientId').value = ingredientId;
                document.getElementById('orderIngredientName').textContent = ingredientName;
                document.getElementById('orderQuantity').value = '';
                document.getElementById('orderNote').value = '';
                $('#quickOrderModal').modal('show');
            }
            
            function submitQuickOrder() {
                var ingredientId = document.getElementById('orderIngredientId').value;
                var quantity = document.getElementById('orderQuantity').value;
                var note = document.getElementById('orderNote').value;
                
                if (!quantity || quantity <= 0) {
                    alert('Vui lòng nhập số lượng hợp lệ');
                    return;
                }
                
                // Implementation for creating purchase order
                alert('Chức năng tạo đơn đặt hàng sẽ được triển khai sau.\n' +
                      'Nguyên liệu: ' + document.getElementById('orderIngredientName').textContent + '\n' +
                      'Số lượng: ' + quantity + '\n' +
                      'Ghi chú: ' + note);
                
                $('#quickOrderModal').modal('hide');
            }
            
            function quickUpdateStock(ingredientId, ingredientName, currentQuantity) {
                document.getElementById('stockIngredientId').value = ingredientId;
                document.getElementById('stockIngredientName').textContent = ingredientName;
                document.getElementById('stockCurrentQuantity').textContent = currentQuantity;
                document.getElementById('newQuantity').value = currentQuantity;
                $('#stockUpdateModal').modal('show');
            }
            
            function createBulkOrder() {
                var totalIngredients = <c:out value="${fn:length(lowStockIngredients)}" />;
                if (totalIngredients === 0) {
                    alert('Không có nguyên liệu nào cần đặt hàng');
                    return;
                }
                
                var confirmMsg = 'Bạn có muốn tạo đơn đặt hàng cho tất cả ' + 
                               totalIngredients + ' nguyên liệu sắp hết?';
                
                if (confirm(confirmMsg)) {
                    // Implementation for bulk order creation
                    alert('Chức năng đặt hàng hàng loạt sẽ được triển khai sau');
                }
            }
        </script>
    </body>
</html>