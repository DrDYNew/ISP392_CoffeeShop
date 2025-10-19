<%@ page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<!DOCTYPE html>
<html>
    <head>
        <meta charset="UTF-8">
        <meta http-equiv="X-UA-Compatible" content="IE=edge">
        <title>Chỉnh Sửa Yêu Cầu Sự Cố - Coffee Shop</title>
        <meta content="width=device-width, initial-scale=1, maximum-scale=1, user-scalable=no" name="viewport">
        <!-- Bootstrap 3.3.6 -->
        <link rel="stylesheet" href="${pageContext.request.contextPath}/bootstrap/css/bootstrap.min.css">
        <!-- Font Awesome -->
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/4.5.0/css/font-awesome.min.css">
        <!-- AdminLTE -->
        <link rel="stylesheet" href="https://adminlte.io/themes/AdminLTE/dist/css/AdminLTE.min.css">
        <link rel="stylesheet" href="https://adminlte.io/themes/AdminLTE/dist/css/skins/_all-skins.min.css">
    </head>
    <body class="hold-transition skin-blue sidebar-mini">
    <div class="wrapper">
        
        <!-- Include Header -->
        <%@include file="../compoment/header.jsp" %>
        
        <!-- Include Sidebar -->
        <%@include file="../compoment/sidebar.jsp" %>

        <!-- Content Wrapper -->
        <div class="content-wrapper">
            <!-- Content Header -->
            <section class="content-header">
                <h1>
                    Chỉnh Sửa Yêu Cầu Sự Cố
                    <small>Cập nhật thông tin issue</small>
                </h1>
                <ol class="breadcrumb">
                    <li><a href="${pageContext.request.contextPath}/barista/dashboard"><i class="fa fa-dashboard"></i> Trang chủ</a></li>
                    <li><a href="${pageContext.request.contextPath}/barista/issues">Báo cáo sự cố</a></li>
                    <li class="active">Chỉnh sửa</li>
                </ol>
            </section>

            <!-- Main content -->
            <section class="content">
                <div class="row">
                <div class="row">
                    <div class="col-md-8 col-md-offset-2">
                        <!-- Issue Edit Box -->
                        <div class="box box-warning">
                            <div class="box-header with-border">
                                <h3 class="box-title">
                                    <i class="fa fa-edit"></i> Chỉnh sửa yêu cầu sự cố
                                </h3>
                            </div>
                            
                            <div class="box-body">
                                <!-- Error Message -->
                                <c:if test="${not empty sessionScope.errorMessage}">
                                    <div class="alert alert-danger alert-dismissible">
                                        <button type="button" class="close" data-dismiss="alert">&times;</button>
                                        <i class="icon fa fa-ban"></i> ${sessionScope.errorMessage}
                                    </div>
                                    <c:remove var="errorMessage" scope="session"/>
                                </c:if>

                                <!-- Success Message -->
                                <c:if test="${not empty sessionScope.successMessage}">
                                    <div class="alert alert-success alert-dismissible">
                                        <button type="button" class="close" data-dismiss="alert">&times;</button>
                                        <i class="icon fa fa-check"></i> ${sessionScope.successMessage}
                                    </div>
                                    <c:remove var="successMessage" scope="session"/>
                                </c:if>

                                <!-- Edit Form -->
                                <form action="${pageContext.request.contextPath}/barista/edit-issue" method="post" id="editIssueForm">
                                    <input type="hidden" name="id" value="${issue.issueID}">

                                    <div class="form-group">
                                        <label for="ingredientId">
                                            <i class="fa fa-cube"></i> Nguyên liệu <span class="text-danger">*</span>
                                        </label>
                                        <select class="form-control" id="ingredientId" name="ingredientId" required>
                                            <option value="">-- Chọn nguyên liệu --</option>
                                            <c:forEach var="ingredient" items="${ingredients}">
                                                <option value="${ingredient.ingredientID}" 
                                                        ${ingredient.ingredientID == issue.ingredientID ? 'selected' : ''}>
                                                    ${ingredient.name}
                                                </option>
                                            </c:forEach>
                                    </div>

                                    <div class="form-group">
                                        <label for="quantity">
                                            <i class="fa fa-sort-numeric-asc"></i> Số lượng <span class="text-danger">*</span>
                                        </label>
                                        <input type="number" 
                                               class="form-control" 
                                               id="quantity" 
                                               name="quantity" 
                                               step="0.01" 
                                               min="0.01"
                                               value="${issue.quantity}"
                                               placeholder="Nhập số lượng" 
                                               required>
                                        <small class="text-muted">Số lượng phải lớn hơn 0</small>
                                    </div>

                                    <div class="form-group">
                                        <label for="description">
                                            <i class="fa fa-align-left"></i> Mô tả sự cố <span class="text-danger">*</span>
                                        </label>
                                        <textarea class="form-control" 
                                                  id="description" 
                                                  name="description" 
                                                  rows="5" 
                                                  placeholder="Mô tả chi tiết về sự cố..." 
                                                  required>${issue.description}</textarea>
                                        <small class="text-muted">Mô tả rõ ràng để Inventory Staff dễ xử lý</small>
                                    </div>

                                    <div class="callout callout-info">
                                        <h4><i class="fa fa-info-circle"></i> Lưu ý</h4>
                                        <p>Sau khi chỉnh sửa, yêu cầu vẫn ở trạng thái <strong>Chờ xử lý</strong> 
                                        và cần được Inventory Staff phê duyệt lại.</p>
                                    </div>

                                    <div class="box-footer">
                                        <a href="${pageContext.request.contextPath}/barista/issue-details?id=${issue.issueID}" 
                                           class="btn btn-default">
                                            <i class="fa fa-arrow-left"></i> Quay lại
                                        </a>
                                        <button type="submit" class="btn btn-warning pull-right">
                                            <i class="fa fa-save"></i> Lưu thay đổi
                                        </button>
                                    </div>
                                </form>
                            </div>
                        </div>
                    </div>
                </div>
            </section>
        </div>
        
        <!-- Footer -->
        <%@include file="../compoment/footer.jsp" %>
    </div>
    
    <!-- Scripts -->
    <script src="https://code.jquery.com/jquery-2.2.4.min.js"></script>
    <script src="${pageContext.request.contextPath}/bootstrap/js/bootstrap.min.js"></script>
    <script src="https://adminlte.io/themes/AdminLTE/dist/js/app.min.js"></script>
    <script>
        $(document).ready(function() {
            // Form validation
            $('#editIssueForm').on('submit', function(e) {
                var ingredientId = $('#ingredientId').val();
                var quantity = $('#quantity').val();
                var description = $('#description').val().trim();

                if (!ingredientId) {
                    e.preventDefault();
                    alert('Vui lòng chọn nguyên liệu');
                    return false;
                }

                if (!quantity || parseFloat(quantity) <= 0) {
                    e.preventDefault();
                    alert('Số lượng phải lớn hơn 0');
                    return false;
                }

                if (!description) {
                    e.preventDefault();
                    alert('Vui lòng nhập mô tả sự cố');
                    return false;
                }

                return true;
            });
        });
    </script>
</body>
</html>
</html>
