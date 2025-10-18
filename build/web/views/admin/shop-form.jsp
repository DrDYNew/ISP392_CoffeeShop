<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <title>${shop != null ? 'Sửa' : 'Thêm'} Shop - Admin | Coffee Shop</title>
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
    <!-- Shop Management CSS -->
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/shop-management.css">
</head>
<body class="hold-transition skin-blue sidebar-mini">
    <div class="wrapper">
        <!-- Header -->
        <jsp:include page="../compoment/header.jsp" />
        
        <!-- Sidebar -->
        <jsp:include page="../compoment/sidebar.jsp" />

        <!-- Content Wrapper -->
        <div class="content-wrapper">
            <section class="content-header">
                <h1>
                    <c:choose>
                        <c:when test="${shop != null}">
                            <i class="fa fa-edit"></i> Sửa Thông Tin Shop
                        </c:when>
                        <c:otherwise>
                            <i class="fa fa-plus-circle"></i> Thêm Shop Mới
                        </c:otherwise>
                    </c:choose>
                </h1>
                <ol class="breadcrumb">
                    <li><a href="${pageContext.request.contextPath}/admin/dashboard"><i class="fa fa-dashboard"></i> Trang chủ</a></li>
                    <li><a href="${pageContext.request.contextPath}/admin/shop?action=list"><i class="fa fa-store"></i> Quản lý Shop</a></li>
                    <li class="active">${shop != null ? 'Sửa' : 'Thêm'} Shop</li>
                </ol>
            </section>

            <section class="content">
                <div class="row">
                    <div class="col-md-8 col-md-offset-2">
                        <div class="box box-primary">
                            <div class="box-header with-border">
                                <h3 class="box-title">
                                    <i class="fa fa-pencil"></i> Thông Tin Shop
                                </h3>
                            </div>

                            <form method="post" action="${pageContext.request.contextPath}/admin/shop">
                                <div class="box-body">
                                    <input type="hidden" name="action" value="${shop != null ? 'edit' : 'add'}">
                                    <c:if test="${shop != null}">
                                        <input type="hidden" name="shopId" value="${shop.shopID}">
                                    </c:if>

                                    <div class="form-group">
                                        <label for="shopName">
                                            <i class="fa fa-store"></i> Tên Shop 
                                            <span class="text-red">*</span>
                                        </label>
                                        <input type="text" class="form-control" id="shopName" name="shopName" 
                                               value="${shop != null ? shop.shopName : ''}" 
                                               placeholder="Nhập tên shop" required>
                                    </div>

                                    <div class="form-group">
                                        <label for="address">
                                            <i class="fa fa-map-marker"></i> Địa Chỉ 
                                            <span class="text-red">*</span>
                                        </label>
                                        <input type="text" class="form-control" id="address" name="address" 
                                               value="${shop != null ? shop.address : ''}" 
                                               placeholder="Nhập địa chỉ shop" required>
                                    </div>

                                    <div class="form-group">
                                        <label for="phone">
                                            <i class="fa fa-phone"></i> Số Điện Thoại 
                                            <span class="text-red">*</span>
                                        </label>
                                        <input type="tel" class="form-control" id="phone" name="phone" 
                                               value="${shop != null ? shop.phone : ''}" 
                                               placeholder="Nhập số điện thoại" 
                                               pattern="[0-9]{10,11}" 
                                               title="Số điện thoại phải có 10-11 chữ số" required>
                                        <span class="help-block">Vui lòng nhập số điện thoại hợp lệ (10-11 chữ số)</span>
                                    </div>

                                    <div class="form-group">
                                        <div class="checkbox">
                                            <label>
                                                <input type="checkbox" id="isActive" name="isActive" 
                                                       ${shop == null || shop.active ? 'checked' : ''}>
                                                <i class="fa fa-check-square-o"></i> Shop đang hoạt động
                                            </label>
                                        </div>
                                    </div>

                                    <c:if test="${shop != null && shop.apiToken != null}">
                                        <div class="callout callout-info">
                                            <h4><i class="fa fa-key"></i> API Token</h4>
                                            <p>Token hiện tại được tạo tự động khi thêm shop. Sử dụng chức năng "Tạo Lại Token" nếu cần token mới.</p>
                                            <div class="input-group">
                                                <input type="text" class="form-control" id="currentToken" 
                                                       value="${shop.apiToken}" readonly>
                                                <span class="input-group-btn">
                                                    <button class="btn btn-default" type="button" onclick="copyCurrentToken()">
                                                        <i class="fa fa-copy"></i> Copy
                                                    </button>
                                                </span>
                                            </div>
                                        </div>
                                    </c:if>
                                </div>

                                <div class="box-footer">
                                    <button type="submit" class="btn btn-primary">
                                        <i class="fa fa-save"></i> Lưu Thông Tin
                                    </button>
                                    <a href="${pageContext.request.contextPath}/admin/shop?action=list" 
                                       class="btn btn-default">
                                        <i class="fa fa-times"></i> Hủy Bỏ
                                    </a>
                                </div>
                            </form>
                        </div>
                    </div>
                </div>
            </section>
        </div>
        <!-- /.content-wrapper -->
    </div>
    <!-- ./wrapper -->

    <!-- jQuery 3.6.0 -->
    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
    <!-- Bootstrap 3.3.6 -->
    <script src="${pageContext.request.contextPath}/bootstrap/js/bootstrap.min.js"></script>
    <!-- AdminLTE App -->
    <script src="${pageContext.request.contextPath}/dist/js/app.min.js"></script>
    
    <script>
        function copyCurrentToken() {
            const tokenInput = document.getElementById('currentToken');
            tokenInput.select();
            
            try {
                document.execCommand('copy');
                alert('✓ Token đã được copy vào clipboard!');
            } catch (err) {
                alert('✗ Không thể copy token. Vui lòng copy thủ công.');
            }
        }
    </script>
</body>
</html>
