<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <title>Chi Tiết Shop - User | Coffee Shop</title>
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
                    <i class="fa fa-search"></i> Chi Tiết Shop
                    <small>Xem thông tin chi tiết của 1 shop</small>
                </h1>
                <ol class="breadcrumb">
                    <li><a href="${pageContext.request.contextPath}/views/common/dashboard.jsp"><i class="fa fa-dashboard"></i> Trang chủ</a></li>
                    <li><a href="${pageContext.request.contextPath}/user/shop?action=list"><i class="fa fa-building"></i> Danh sách Shop</a></li>
                    <li class="active">Chi tiết Shop</li>
                </ol>
            </section>

            <section class="content">
                <c:if test="${!authenticated}">
                    <!-- Form nhập Shop Token -->
                    <div class="row">
                        <div class="col-md-6 col-md-offset-3">
                            <div class="box box-primary">
                                <div class="box-header with-border">
                                    <h3 class="box-title">
                                        <i class="fa fa-lock"></i> Xác Thực Shop API Token
                                    </h3>
                                </div>
                                <form method="post" action="${pageContext.request.contextPath}/user/shop">
                                    <div class="box-body">
                                        <input type="hidden" name="action" value="viewDetails">
                                        
                                        <c:if test="${not empty error}">
                                            <div class="alert alert-danger alert-dismissible">
                                                <button type="button" class="close" data-dismiss="alert">&times;</button>
                                                <i class="fa fa-ban"></i> ${error}
                                            </div>
                                        </c:if>

                                        <div class="callout callout-info">
                                            <h4><i class="fa fa-info-circle"></i> Thông tin</h4>
                                            <p>Shop API Token cho phép xem thông tin chi tiết của <strong>1 shop cụ thể</strong>.</p>
                                            <p>Mỗi shop có 1 token riêng biệt. Bạn có thể lấy token từ danh sách shop.</p>
                                        </div>

                                        <div class="form-group">
                                            <label for="shopToken">
                                                <i class="fa fa-key"></i> Shop API Token 
                                                <span class="text-red">*</span>
                                            </label>
                                            <input type="password" class="form-control input-lg" 
                                                   id="shopToken" name="shopToken" 
                                                   placeholder="Nhập Shop API Token" required>
                                        </div>
                                    </div>
                                    <div class="box-footer">
                                        <button type="submit" class="btn btn-primary btn-lg btn-block">
                                            <i class="fa fa-search"></i> Xem Chi Tiết Shop
                                        </button>
                                        <a href="${pageContext.request.contextPath}/user/shop?action=list" 
                                           class="btn btn-default btn-block">
                                            <i class="fa fa-list"></i> Quay Lại Danh Sách
                                        </a>
                                    </div>
                                </form>
                            </div>
                        </div>
                    </div>
                </c:if>

                <c:if test="${authenticated}">
                    <!-- Thông tin chi tiết shop -->
                    <div class="row">
                        <div class="col-md-8 col-md-offset-2">
                            <div class="box box-widget widget-user-2">
                                <div class="widget-user-header bg-aqua">
                                    <div class="widget-user-image">
                                        <i class="fa fa-building" style="font-size: 48px; margin-top: 10px;"></i>
                                    </div>
                                    <h3 class="widget-user-username">${shop.shopName}</h3>
                                    <h5 class="widget-user-desc">
                                        <c:choose>
                                            <c:when test="${shop.active}">
                                                <span class="label label-success">
                                                    <i class="fa fa-check"></i> Đang hoạt động
                                                </span>
                                            </c:when>
                                            <c:otherwise>
                                                <span class="label label-danger">
                                                    <i class="fa fa-times"></i> Ngừng hoạt động
                                                </span>
                                            </c:otherwise>
                                        </c:choose>
                                    </h5>
                                </div>
                                <div class="box-footer no-padding">
                                    <ul class="nav nav-stacked">
                                        <li>
                                            <a href="#">
                                                <i class="fa fa-hashtag text-primary"></i> Mã Shop
                                                <span class="pull-right badge bg-blue">${shop.shopID}</span>
                                            </a>
                                        </li>
                                        <li>
                                            <a href="#">
                                                <i class="fa fa-building text-aqua"></i> Tên Shop
                                                <span class="pull-right text-muted">${shop.shopName}</span>
                                            </a>
                                        </li>
                                        <li>
                                            <a href="#">
                                                <i class="fa fa-map-marker text-red"></i> Địa Chỉ
                                                <span class="pull-right text-muted">${shop.address}</span>
                                            </a>
                                        </li>
                                        <li>
                                            <a href="#">
                                                <i class="fa fa-phone text-green"></i> Số Điện Thoại
                                                <span class="pull-right text-muted">${shop.phone}</span>
                                            </a>
                                        </li>
                                        <li>
                                            <a href="#">
                                                <i class="fa fa-user text-yellow"></i> Chủ Shop ID
                                                <span class="pull-right text-muted">
                                                    <c:choose>
                                                        <c:when test="${shop.ownerID != null}">
                                                            #${shop.ownerID}
                                                        </c:when>
                                                        <c:otherwise>
                                                            <em>Chưa có</em>
                                                        </c:otherwise>
                                                    </c:choose>
                                                </span>
                                            </a>
                                        </li>
                                        <li>
                                            <a href="#">
                                                <i class="fa fa-calendar text-purple"></i> Ngày Tạo
                                                <span class="pull-right text-muted">${shop.createdAt}</span>
                                            </a>
                                        </li>
                                    </ul>
                                </div>
                            </div>

                            <!-- API Token Info -->
                            <div class="box box-info">
                                <div class="box-header with-border">
                                    <h3 class="box-title">
                                        <i class="fa fa-key"></i> Thông Tin API Token
                                    </h3>
                                </div>
                                <div class="box-body">
                                    <div class="callout callout-warning">
                                        <h4><i class="fa fa-warning"></i> Lưu ý Bảo Mật</h4>
                                        <p>API Token này cho phép truy cập thông tin shop. Vui lòng giữ bí mật và không chia sẻ.</p>
                                    </div>
                                    
                                    <div class="form-group">
                                        <label>Shop API Token:</label>
                                        <div class="input-group">
                                            <input type="password" class="form-control" id="shopTokenDisplay" 
                                                   value="${shop.apiToken}" readonly>
                                            <span class="input-group-btn">
                                                <button class="btn btn-default" type="button" 
                                                        onclick="toggleTokenVisibility()">
                                                    <i class="fa fa-eye" id="toggleIcon"></i>
                                                </button>
                                                <button class="btn btn-default" type="button" 
                                                        onclick="copyToken()">
                                                    <i class="fa fa-copy"></i> Copy
                                                </button>
                                            </span>
                                        </div>
                                    </div>
                                </div>
                            </div>

                            <!-- Actions -->
                            <div class="box-footer text-center">
                                <a href="${pageContext.request.contextPath}/user/shop?action=list" 
                                   class="btn btn-default">
                                    <i class="fa fa-arrow-left"></i> Quay Lại Danh Sách
                                </a>
                                <a href="${pageContext.request.contextPath}/user/shop?action=details" 
                                   class="btn btn-primary">
                                    <i class="fa fa-search"></i> Xem Shop Khác
                                </a>
                            </div>
                        </div>
                    </div>
                </c:if>
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
        function toggleTokenVisibility() {
            const input = document.getElementById('shopTokenDisplay');
            const icon = document.getElementById('toggleIcon');
            
            if (input.type === 'password') {
                input.type = 'text';
                icon.className = 'fa fa-eye-slash';
            } else {
                input.type = 'password';
                icon.className = 'fa fa-eye';
            }
        }
        
        function copyToken() {
            const input = document.getElementById('shopTokenDisplay');
            const originalType = input.type;
            
            // Tạm thời chuyển sang text để copy
            input.type = 'text';
            input.select();
            
            try {
                document.execCommand('copy');
                alert('✓ Token đã được copy vào clipboard!');
            } catch (err) {
                alert('✗ Không thể copy token. Vui lòng copy thủ công.');
            }
            
            // Chuyển lại về password
            input.type = originalType;
        }
    </script>
</body>
</html>
