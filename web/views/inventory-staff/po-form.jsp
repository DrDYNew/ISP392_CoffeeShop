<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>${po != null ? 'Chỉnh sửa' : 'Tạo mới'} Đơn hàng</title>
    
    <!-- Bootstrap 3.3.6 -->
    <link rel="stylesheet" href="${pageContext.request.contextPath}/bootstrap/css/bootstrap.min.css">
    <!-- Font Awesome -->
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/4.5.0/css/font-awesome.min.css">
    <!-- Theme style -->
    <link rel="stylesheet" href="${pageContext.request.contextPath}/dist/css/AdminLTE.min.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/dist/css/skins/_all-skins.min.css">
    <!-- Select2 -->
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/select2/4.0.13/css/select2.min.css">
    
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
        
        .box {
            border-radius: 10px;
            box-shadow: 0 2px 10px rgba(0,0,0,0.08);
            border: none;
        }
        
        .box-header {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            border-radius: 10px 10px 0 0;
            padding: 15px;
        }
        
        .box-header h3 {
            margin: 0;
            color: white;
            font-weight: 600;
        }
        
        .form-group label {
            font-weight: 600;
            color: #555;
        }
        
        .form-control, .select2-container--default .select2-selection--single {
            border-radius: 8px;
            border: 2px solid #e0e0e0;
            transition: all 0.3s ease;
        }
        
        .form-control:focus {
            border-color: #667eea;
            box-shadow: 0 0 0 0.2rem rgba(102, 126, 234, 0.25);
        }
        
        .detail-row {
            background: #f8f9fa;
            border: 2px solid #e9ecef;
            border-radius: 10px;
            padding: 20px;
            margin-bottom: 15px;
            transition: all 0.3s ease;
        }
        
        .detail-row:hover {
            border-color: #667eea;
            box-shadow: 0 4px 12px rgba(102, 126, 234, 0.2);
        }
        
        .btn-gradient {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            border: none;
            border-radius: 8px;
            padding: 10px 25px;
            font-weight: 600;
            transition: all 0.3s ease;
        }
        
        .btn-gradient:hover {
            transform: translateY(-2px);
            box-shadow: 0 6px 20px rgba(102, 126, 234, 0.4);
            color: white;
        }
        
        .btn-add-detail {
            background: linear-gradient(135deg, #56ab2f 0%, #a8e063 100%);
            color: white;
            border: none;
            border-radius: 8px;
            padding: 10px 25px;
            font-weight: 600;
            margin-bottom: 20px;
        }
        
        .btn-add-detail:hover {
            transform: translateY(-2px);
            box-shadow: 0 6px 20px rgba(86, 171, 47, 0.4);
            color: white;
        }
        
        .btn-remove {
            background: linear-gradient(135deg, #fc4a1a 0%, #f7b733 100%);
            color: white;
            border: none;
            border-radius: 8px;
        }
        
        .btn-remove:hover {
            transform: translateY(-2px);
            box-shadow: 0 6px 20px rgba(252, 74, 26, 0.4);
            color: white;
        }
        
        .required-star {
            color: #fc4a1a;
            font-weight: bold;
        }
        
        .breadcrumb {
            background: transparent;
            padding: 10px 0;
        }
        
        .section-title {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            -webkit-background-clip: text;
            -webkit-text-fill-color: transparent;
            background-clip: text;
            font-weight: 700;
            font-size: 20px;
            margin-bottom: 20px;
        }
        
        .alert {
            border-radius: 10px;
            border: none;
            box-shadow: 0 2px 10px rgba(0,0,0,0.1);
        }
        
        .help-block {
            color: #999;
            font-size: 12px;
            margin-top: 5px;
        }
    </style>
</head>
<body class="hold-transition skin-blue sidebar-mini">
<div class="wrapper">
    
    <!-- Include Sidebar -->
    <jsp:include page="../compoment/sidebar.jsp" />
    
    <div class="content-wrapper">
        <!-- Page Header -->
        <div class="page-header">
            <h1>
                <i class="fa ${po != null ? 'fa-edit' : 'fa-plus-circle'}"></i> 
                ${po != null ? 'Chỉnh sửa' : 'Tạo mới'} Đơn hàng
            </h1>
            <ol class="breadcrumb" style="background: transparent; padding-top: 10px;">
                <li><a href="${pageContext.request.contextPath}/views/inventory-staff/dashboard.jsp" style="color: rgba(255,255,255,0.8);"><i class="fa fa-dashboard"></i> Dashboard</a></li>
                <li><a href="${pageContext.request.contextPath}/purchase-order?action=list" style="color: rgba(255,255,255,0.8);">Danh sách đơn hàng</a></li>
                <li style="color: white;">${po != null ? 'Chỉnh sửa' : 'Tạo mới'}</li>
            </ol>
        </div>
        
        <!-- Success/Error Messages -->
        <c:if test="${not empty errorMessage}">
            <div class="alert alert-danger alert-dismissible">
                <button type="button" class="close" data-dismiss="alert">&times;</button>
                <i class="fa fa-exclamation-circle"></i> ${errorMessage}
            </div>
        </c:if>
        
        <!-- Form -->
        <form action="${pageContext.request.contextPath}/purchase-order" method="post" id="poForm">
            <input type="hidden" name="action" value="${po != null ? 'update' : 'create'}">
            <c:if test="${po != null}">
                <input type="hidden" name="poID" value="${po.poID}">
            </c:if>
            
            <!-- Purchase Order Information -->
            <div class="box">
                <div class="box-header">
                    <h3 class="box-title"><i class="fa fa-info-circle"></i> Thông tin đơn hàng</h3>
                </div>
                <div class="box-body">
                    <div class="row">
                        <div class="col-md-6">
                            <div class="form-group">
                                <label for="shopID">
                                    <i class="fa fa-building-o"></i> Cửa hàng 
                                    <span class="required-star">*</span>
                                </label>
                                <select class="form-control select2" id="shopID" name="shopID" required>
                                    <option value="">-- Chọn cửa hàng --</option>
                                    <option value="1" ${po != null && po.shopID == 1 ? 'selected' : ''}>CoffeeLux - Chi nhánh Quận 1</option>
                                    <option value="2" ${po != null && po.shopID == 2 ? 'selected' : ''}>CoffeeLux - Chi nhánh Quận 3</option>
                                    <option value="3" ${po != null && po.shopID == 3 ? 'selected' : ''}>CoffeeLux - Chi nhánh Hà Nội</option>
                                    <option value="4" ${po != null && po.shopID == 4 ? 'selected' : ''}>CoffeeLux - Chi nhánh Đà Nẵng</option>
                                </select>
                                <span class="help-block">Chọn cửa hàng nhận hàng</span>
                            </div>
                        </div>
                        
                        <div class="col-md-6">
                            <div class="form-group">
                                <label for="supplierID">
                                    <i class="fa fa-truck"></i> Nhà cung cấp 
                                    <span class="required-star">*</span>
                                </label>
                                <select class="form-control select2" id="supplierID" name="supplierID" required>
                                    <option value="">-- Chọn nhà cung cấp --</option>
                                    <option value="1" ${po != null && po.supplierID == 1 ? 'selected' : ''}>Công ty TNHH Cà phê Highlands</option>
                                    <option value="2" ${po != null && po.supplierID == 2 ? 'selected' : ''}>Trung Nguyên Coffee</option>
                                    <option value="3" ${po != null && po.supplierID == 3 ? 'selected' : ''}>Công ty Sữa TH True Milk</option>
                                    <option value="4" ${po != null && po.supplierID == 4 ? 'selected' : ''}>Công ty Bánh Kẹo Kinh Đô</option>
                                    <option value="5" ${po != null && po.supplierID == 5 ? 'selected' : ''}>Công ty Đường Biên Hòa</option>
                                </select>
                                <span class="help-block">Chọn nhà cung cấp nguyên liệu</span>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
            
            <!-- Purchase Order Details -->
            <div class="box" style="margin-top: 20px;">
                <div class="box-header">
                    <h3 class="box-title"><i class="fa fa-list"></i> Chi tiết nguyên liệu</h3>
                </div>
                <div class="box-body">
                    <div id="detailsContainer">
                            <div class="detail-row">
                                <div class="row">
                                    <div class="col-md-5">
                                        <div class="form-group">
                                            <label>
                                                <i class="fa fa-cube"></i> Nguyên liệu 
                                                <span class="required-star">*</span>
                                            </label>
                                            <select class="form-control select2-ingredient" name="ingredientID[]" required>
                                                <option value="">-- Chọn nguyên liệu --</option>
                                                <c:forEach var="ingredient" items="${ingredients}">
                                                    <option value="${ingredient.ingredientID}">${ingredient.name}</option>
                                                </c:forEach>
                                            </select>
                                        </div>
                                    </div>
                                    <div class="col-md-5">
                                        <div class="form-group">
                                            <label>
                                                <i class="fa fa-calculator"></i> Số lượng 
                                                <span class="required-star">*</span>
                                            </label>
                                            <input type="number" class="form-control" name="quantity[]" step="0.01" min="0.01" placeholder="Nhập số lượng" required>
                                        </div>
                                    </div>
                                    <div class="col-md-2">
                                        <label style="display: block;">&nbsp;</label>
                                        <button type="button" class="btn btn-remove btn-block" onclick="removeDetail(this)">
                                            <i class="fa fa-trash"></i> Xóa
                                        </button>
                                    </div>
                                </div>
                            </div>
                        </div>
                        
                        <button type="button" class="btn btn-add-detail" onclick="addDetail()">
                            <i class="fa fa-plus"></i> Thêm nguyên liệu
                        </button>
                    </div>
                </div>
            </div>
            
            <!-- Action Buttons -->
            <div class="box" style="margin-top: 20px;">
                <div class="box-body">
                    <div class="row">
                        <div class="col-xs-6">
                            <a href="${pageContext.request.contextPath}/purchase-order?action=list" class="btn btn-default btn-lg btn-block">
                                <i class="fa fa-arrow-left"></i> Quay lại
                            </a>
                        </div>
                        <div class="col-xs-6">
                            <button type="submit" class="btn btn-gradient btn-lg btn-block">
                                <i class="fa fa-save"></i> ${po != null ? 'Cập nhật đơn hàng' : 'Tạo đơn hàng'}
                            </button>
                        </div>
                    </div>
                </div>
            </div>
        </form>
    </div>
</div>

<!-- jQuery 2.2.4 from CDN -->
<script src="https://code.jquery.com/jquery-2.2.4.min.js"></script>
<!-- Bootstrap 3.3.6 -->
<script src="${pageContext.request.contextPath}/bootstrap/js/bootstrap.min.js"></script>
<!-- Select2 -->
<script src="https://cdnjs.cloudflare.com/ajax/libs/select2/4.0.13/js/select2.min.js"></script>
<!-- AdminLTE App -->
<script src="${pageContext.request.contextPath}/dist/js/app.min.js"></script>

<script>
    $(document).ready(function() {
        // Initialize Select2
        $('.select2').select2({
            theme: 'classic',
            width: '100%'
        });
        
        $('.select2-ingredient').select2({
            theme: 'classic',
            width: '100%',
            placeholder: '-- Chọn nguyên liệu --'
        });
    });
    
    function addDetail() {
        const container = document.getElementById('detailsContainer');
        const detailRow = document.querySelector('.detail-row').cloneNode(true);
        
        // Reset values
        detailRow.querySelectorAll('select, input').forEach(el => {
            el.value = '';
            // Remove Select2 if already initialized
            if ($(el).hasClass('select2-hidden-accessible')) {
                $(el).select2('destroy');
            }
        });
        
        container.appendChild(detailRow);
        
        // Re-initialize Select2 for new row
        $(detailRow).find('.select2-ingredient').select2({
            theme: 'classic',
            width: '100%',
            placeholder: '-- Chọn nguyên liệu --'
        });
    }
    
    function removeDetail(button) {
        const container = document.getElementById('detailsContainer');
        const rows = container.querySelectorAll('.detail-row');
        
        if (rows.length > 1) {
            button.closest('.detail-row').remove();
        } else {
            alert('Phải có ít nhất 1 nguyên liệu trong đơn hàng!');
        }
    }
    
    // Form validation
    document.getElementById('poForm').addEventListener('submit', function(e) {
        const ingredientSelects = document.querySelectorAll('select[name="ingredientID[]"]');
        const quantities = document.querySelectorAll('input[name="quantity[]"]');
        
        if (ingredientSelects.length > 0) {
            for (let i = 0; i < ingredientSelects.length; i++) {
                if (!ingredientSelects[i].value) {
                    e.preventDefault();
                    alert('Vui lòng chọn nguyên liệu cho tất cả các dòng!');
                    ingredientSelects[i].focus();
                    return;
                }
                
                if (!quantities[i].value || parseFloat(quantities[i].value) <= 0) {
                    e.preventDefault();
                    alert('Số lượng phải lớn hơn 0!');
                    quantities[i].focus();
                    return;
                }
            }
            
            // Check for duplicate ingredients
            const selectedIngredients = Array.from(ingredientSelects).map(s => s.value);
            const uniqueIngredients = new Set(selectedIngredients);
            if (selectedIngredients.length !== uniqueIngredients.size) {
                e.preventDefault();
                alert('Không được chọn trùng nguyên liệu!');
                return;
            }
        }
    });
</script>

</body>
</html>
