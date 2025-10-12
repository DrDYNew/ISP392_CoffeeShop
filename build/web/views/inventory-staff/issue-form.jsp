<%@page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="utf-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <title>${isEdit ? 'Cập nhật' : 'Thêm mới'} vấn đề - Coffee Shop</title>
    <meta content="width=device-width, initial-scale=1, maximum-scale=1, user-scalable=no" name="viewport">
    <!-- Bootstrap 3.3.6 -->
    <link rel="stylesheet" href="${pageContext.request.contextPath}/bootstrap/css/bootstrap.min.css">
    <!-- Font Awesome -->
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/4.5.0/css/font-awesome.min.css">
    <!-- Theme style -->
    <link rel="stylesheet" href="${pageContext.request.contextPath}/dist/css/AdminLTE.min.css">
    <!-- AdminLTE Skins -->
    <link rel="stylesheet" href="${pageContext.request.contextPath}/dist/css/skins/_all-skins.min.css">
    <style>
        .form-section {
            background: #fff;
            padding: 20px;
            border-radius: 8px;
            box-shadow: 0 2px 4px rgba(0,0,0,0.1);
        }
        
        .required:after {
            content: " *";
            color: red;
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
                    ${isEdit ? 'Cập nhật' : 'Thêm mới'} vấn đề
                    <small>${isEdit ? 'Chỉnh sửa thông tin vấn đề' : 'Tạo vấn đề mới'}</small>
                </h1>
                <ol class="breadcrumb">
                    <li><a href="${pageContext.request.contextPath}/inventory-dashboard"><i class="fa fa-dashboard"></i> Dashboard</a></li>
                    <li><a href="${pageContext.request.contextPath}/issue?action=list">Quản lý vấn đề</a></li>
                    <li class="active">${isEdit ? 'Cập nhật' : 'Thêm mới'}</li>
                </ol>
            </section>

            <section class="content">
                <!-- Error Alert -->
                <c:if test="${not empty error}">
                    <div class="alert alert-danger alert-dismissible">
                        <button type="button" class="close" data-dismiss="alert" aria-hidden="true">&times;</button>
                        <h4><i class="icon fa fa-ban"></i> Lỗi!</h4>
                        ${error}
                    </div>
                </c:if>

                <div class="row">
                    <div class="col-md-8 col-md-offset-2">
                        <div class="box box-primary">
                            <div class="box-header with-border">
                                <h3 class="box-title">Thông tin vấn đề</h3>
                            </div>
                            
                            <form method="post" action="${pageContext.request.contextPath}/issue" id="issueForm">
                                <input type="hidden" name="action" value="${isEdit ? 'update' : 'create'}">
                                <c:if test="${isEdit}">
                                    <input type="hidden" name="issueId" value="${issue.issueID}">
                                </c:if>
                                
                                <div class="box-body">
                                    <!-- Ingredient Selection -->
                                    <div class="form-group">
                                        <label for="ingredientId" class="required">Nguyên liệu</label>
                                        <select class="form-control" id="ingredientId" name="ingredientId" required>
                                            <option value="">-- Chọn nguyên liệu --</option>
                                            <c:forEach items="${ingredients}" var="ingredient">
                                                <option value="${ingredient.ingredientID}" 
                                                    ${isEdit && issue.ingredientID eq ingredient.ingredientID ? 'selected' : ''}>
                                                    ${ingredient.name} (Tồn kho: 
                                                    <fmt:formatNumber value="${ingredient.stockQuantity}" pattern="#,##0.##"/> 
                                                    ${ingredient.unitName})
                                                </option>
                                            </c:forEach>
                                        </select>
                                    </div>

                                    <!-- Description -->
                                    <div class="form-group">
                                        <label for="description" class="required">Mô tả vấn đề</label>
                                        <textarea class="form-control" id="description" name="description" 
                                                  rows="4" required maxlength="500" 
                                                  placeholder="Mô tả chi tiết vấn đề gặp phải với nguyên liệu...">${isEdit ? issue.description : ''}</textarea>
                                        <small class="text-muted">Tối đa 500 ký tự</small>
                                    </div>

                                    <!-- Quantity -->
                                    <div class="form-group">
                                        <label for="quantity" class="required">Số lượng bị ảnh hưởng</label>
                                        <input type="number" class="form-control" id="quantity" name="quantity" 
                                               value="${isEdit ? issue.quantity : ''}" 
                                               step="0.01" min="0.01" required
                                               placeholder="Nhập số lượng">
                                        <small class="text-muted">Số lượng nguyên liệu bị ảnh hưởng</small>
                                    </div>

                                    <!-- Status -->
                                    <div class="form-group">
                                        <label for="statusId" class="required">Trạng thái</label>
                                        <c:choose>
                                            <c:when test="${isEdit}">
                                                <!-- Read-only status when editing -->
                                                <input type="text" class="form-control" value="${issue.statusName}" readonly>
                                                <input type="hidden" name="statusId" value="${issue.statusID}">
                                                <small class="text-muted">Trạng thái không thể thay đổi sau khi tạo</small>
                                            </c:when>
                                            <c:otherwise>
                                                <!-- Auto-select "Reported" when creating -->
                                                <input type="text" class="form-control" value="Reported - Đã báo cáo sự cố" readonly>
                                                <input type="hidden" name="statusId" value="${defaultStatusId}">
                                                <small class="text-muted">Mặc định: Reported (Đã báo cáo sự cố)</small>
                                            </c:otherwise>
                                        </c:choose>
                                    </div>

                                    <c:if test="${isEdit}">
                                        <!-- Confirmed By (read-only display) -->
                                        <div class="form-group">
                                            <label for="confirmedBy">Người xác nhận</label>
                                            <input type="text" class="form-control" 
                                                   value="${issue.confirmedByName ne null ? issue.confirmedByName : 'Chưa có người xác nhận'}" 
                                                   readonly style="background-color: #f4f4f4;">
                                            <small class="text-muted">Không thể thay đổi người xác nhận</small>
                                        </div>
                                    </c:if>
                                </div>

                                <div class="box-footer">
                                    <button type="submit" class="btn btn-primary">
                                        <i class="fa fa-save"></i> ${isEdit ? 'Cập nhật' : 'Tạo mới'}
                                    </button>
                                    <a href="${pageContext.request.contextPath}/issue?action=list" class="btn btn-default">
                                        <i class="fa fa-times"></i> Hủy
                                    </a>
                                </div>
                            </form>
                        </div>
                    </div>
                </div>
            </section>
        </div>

        <%@include file="../compoment/footer.jsp" %>
    </div>

    <!-- jQuery 2.2.0 -->
    <script src="${pageContext.request.contextPath}/bootstrap/js/jquery-2.2.0.min.js"></script>
    <!-- Bootstrap 3.3.6 -->
    <script src="${pageContext.request.contextPath}/bootstrap/js/bootstrap.min.js"></script>
    
    <script>
        // Form validation
        document.getElementById('issueForm').addEventListener('submit', function(e) {
            var quantity = parseFloat(document.getElementById('quantity').value);
            
            if (quantity <= 0) {
                e.preventDefault();
                alert('Số lượng phải lớn hơn 0');
                return false;
            }
            
            var description = document.getElementById('description').value.trim();
            if (description.length < 10) {
                e.preventDefault();
                alert('Mô tả vấn đề phải có ít nhất 10 ký tự');
                return false;
            }
            
            return true;
        });
    </script>
</body>
</html>
