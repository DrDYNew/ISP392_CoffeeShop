<%@page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="utf-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <title>Tạo yêu cầu sự cố - Coffee Shop Management</title>
    <meta content="width=device-width, initial-scale=1, maximum-scale=1, user-scalable=no" name="viewport">
    <!-- Bootstrap 3.3.6 -->
    <link rel="stylesheet" href="${pageContext.request.contextPath}/bootstrap/css/bootstrap.min.css">
    <!-- Font Awesome -->
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/4.5.0/css/font-awesome.min.css">
    <!-- AdminLTE -->
    <link rel="stylesheet" href="https://adminlte.io/themes/AdminLTE/dist/css/AdminLTE.min.css">
    <link rel="stylesheet" href="https://adminlte.io/themes/AdminLTE/dist/css/skins/_all-skins.min.css">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/css/sidebar-custom.css">

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
                Tạo yêu cầu sự cố
                <small>Báo cáo sự cố nguyên liệu</small>
            </h1>
            <ol class="breadcrumb">
                <li><a href="${pageContext.request.contextPath}/barista/dashboard"><i class="fa fa-dashboard"></i> Trang chủ</a></li>
                <li><a href="${pageContext.request.contextPath}/barista/issues">Báo cáo sự cố</a></li>
                <li class="active">Tạo yêu cầu</li>
            </ol>
        </section>

        <!-- Main content -->
        <section class="content">
            <div class="row">
                <div class="col-md-8 col-md-offset-2">
                    <div class="box box-primary">
                        <div class="box-header with-border">
                            <h3 class="box-title">
                                <i class="fa fa-exclamation-triangle"></i> Thông tin sự cố
                            </h3>
                        </div>
                        
                        <!-- Error Message -->
                        <c:if test="${not empty sessionScope.errorMessage}">
                            <div class="alert alert-danger alert-dismissible" style="margin: 15px;">
                                <button type="button" class="close" data-dismiss="alert">&times;</button>
                                <i class="icon fa fa-ban"></i> ${sessionScope.errorMessage}
                            </div>
                            <c:remove var="errorMessage" scope="session"/>
                        </c:if>
                        
                        <form method="post" action="${pageContext.request.contextPath}/barista/create-issue">
                            <div class="box-body">
                                <div class="callout callout-info">
                                    <h4><i class="fa fa-info-circle"></i> Lưu ý</h4>
                                    <p>Yêu cầu sự cố sẽ được gửi đến Inventory Staff để phê duyệt. Vui lòng mô tả chi tiết vấn đề.</p>
                                </div>
                                
                                <!-- Ingredient Selection -->
                                <div class="form-group">
                                    <label for="ingredientId">
                                        Nguyên liệu <span class="text-danger">*</span>
                                    </label>
                                    <select class="form-control" id="ingredientId" name="ingredientId" required>
                                        <option value="">-- Chọn nguyên liệu --</option>
                                        <c:forEach var="ingredient" items="${ingredients}">
                                            <option value="${ingredient.ingredientID}">
                                                ${ingredient.name} (Tồn kho: ${ingredient.stockQuantity})
                                            </option>
                                        </c:forEach>
                                    </select>
                                    <p class="help-block">Chọn nguyên liệu gặp sự cố</p>
                                </div>
                                
                                <!-- Quantity -->
                                <div class="form-group">
                                    <label for="quantity">
                                        Số lượng <span class="text-danger">*</span>
                                    </label>
                                    <input type="number" 
                                           class="form-control" 
                                           id="quantity" 
                                           name="quantity" 
                                           min="0.01" 
                                           step="0.01" 
                                           placeholder="Nhập số lượng"
                                           required>
                                    <p class="help-block">Số lượng nguyên liệu gặp sự cố</p>
                                </div>
                                
                                <!-- Description -->
                                <div class="form-group">
                                    <label for="description">
                                        Mô tả sự cố <span class="text-danger">*</span>
                                    </label>
                                    <textarea class="form-control" 
                                              id="description" 
                                              name="description" 
                                              rows="5" 
                                              placeholder="Mô tả chi tiết vấn đề: hỏng hóc, hết hạn, chất lượng kém,..."
                                              required></textarea>
                                    <p class="help-block">Mô tả chi tiết về sự cố</p>
                                </div>
                                
                                <div class="callout callout-warning">
                                    <p><i class="fa fa-clock-o"></i> <strong>Trạng thái:</strong> Yêu cầu sẽ ở trạng thái "Chờ xử lý" và chờ Inventory Staff phê duyệt</p>
                                </div>
                            </div>
                            
                            <div class="box-footer">
                                <a href="${pageContext.request.contextPath}/barista/issues" class="btn btn-default">
                                    <i class="fa fa-arrow-left"></i> Quay lại
                                </a>
                                <button type="submit" class="btn btn-primary pull-right">
                                    <i class="fa fa-paper-plane"></i> Gửi yêu cầu
                                </button>
                            </div>
                        </form>
                    </div>
                </div>
            </div>
        </section>
    </div>
    <!-- /.content-wrapper -->
    
    <!-- Include Footer -->
    <%@include file="../compoment/footer.jsp" %>
</div>
<!-- ./wrapper -->

<!-- jQuery 3.6.0 -->
<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
<!-- Bootstrap 3.3.6 -->
<script src="${pageContext.request.contextPath}/bootstrap/js/bootstrap.min.js"></script>
<!-- AdminLTE App -->
<script src="https://adminlte.io/themes/AdminLTE/dist/js/app.min.js"></script>

<script>
    // Auto dismiss alerts after 5 seconds
    setTimeout(function() {
        $('.alert').fadeOut();
    }, 5000);
</script>
</body>
</html>
