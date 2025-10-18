<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <title>Danh Sách Shop - User | Coffee Shop</title>
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
                    <i class="fa fa-building"></i> Danh Sách Shop
                    <small>Xem thông tin tất cả các shop</small>
                </h1>
                <ol class="breadcrumb">
                    <li><a href="${pageContext.request.contextPath}/views/common/dashboard.jsp"><i class="fa fa-dashboard"></i> Trang chủ</a></li>
                    <li class="active">Danh sách Shop</li>
                </ol>
            </section>

            <section class="content">
                <c:if test="${!authenticated}">
                    <!-- Form nhập Master Token -->
                    <div class="row">
                        <div class="col-md-6 col-md-offset-3">
                            <div class="box box-warning">
                                <div class="box-header with-border">
                                    <h3 class="box-title">
                                        <i class="fa fa-lock"></i> Xác Thực Master API Token
                                    </h3>
                                </div>
                                <form method="post" action="${pageContext.request.contextPath}/user/shop">
                                    <div class="box-body">
                                        <input type="hidden" name="action" value="viewList">
                                        
                                        <c:if test="${not empty error}">
                                            <div class="alert alert-danger alert-dismissible">
                                                <button type="button" class="close" data-dismiss="alert">&times;</button>
                                                <i class="fa fa-ban"></i> ${error}
                                            </div>
                                        </c:if>

                                        <div class="callout callout-info">
                                            <h4><i class="fa fa-info-circle"></i> Thông tin</h4>
                                            <p>Master API Token cho phép xem danh sách <strong>tất cả các shop</strong> trong hệ thống.</p>
                                            <p>Vui lòng liên hệ Admin để lấy Master Token nếu chưa có.</p>
                                        </div>

                                        <div class="form-group">
                                            <label for="masterToken">
                                                <i class="fa fa-key"></i> Master API Token 
                                                <span class="text-red">*</span>
                                            </label>
                                            <input type="password" class="form-control input-lg" 
                                                   id="masterToken" name="masterToken" 
                                                   placeholder="Nhập Master API Token" required>
                                        </div>
                                    </div>
                                    <div class="box-footer">
                                        <button type="submit" class="btn btn-warning btn-lg btn-block">
                                            <i class="fa fa-unlock-alt"></i> Xem Danh Sách Shop
                                        </button>
                                    </div>
                                </form>
                            </div>
                        </div>
                    </div>
                </c:if>

                <c:if test="${authenticated}">
                    <!-- Danh sách shops -->
                    <div class="row">
                        <div class="col-xs-12">
                            <div class="box box-success">
                                <div class="box-header with-border">
                                    <h3 class="box-title">
                                        <i class="fa fa-list"></i> Danh Sách Shop 
                                        <span class="label label-success">${shops.size()} shop</span>
                                    </h3>
                                    <div class="box-tools">
                                        <a href="${pageContext.request.contextPath}/user/shop?action=details" 
                                           class="btn btn-primary btn-sm">
                                            <i class="fa fa-search"></i> Xem Chi Tiết Shop
                                        </a>
                                    </div>
                                </div>
                                <div class="box-body">
                                    <c:choose>
                                        <c:when test="${empty shops}">
                                            <div class="alert alert-info">
                                                <h4><i class="fa fa-info-circle"></i> Thông báo</h4>
                                                <p>Chưa có shop nào trong hệ thống.</p>
                                            </div>
                                        </c:when>
                                        <c:otherwise>
                                            <div class="table-responsive">
                                                <table class="table table-bordered table-striped table-hover">
                                                    <thead>
                                                        <tr>
                                                            <th style="width: 50px;">ID</th>
                                                            <th>Tên Shop</th>
                                                            <th>Địa Chỉ</th>
                                                            <th>Số Điện Thoại</th>
                                                            <th style="width: 100px;">Trạng Thái</th>
                                                            <th style="width: 150px;">Ngày Tạo</th>
                                                            <th style="width: 100px;">Hành Động</th>
                                                        </tr>
                                                    </thead>
                                                    <tbody>
                                                        <c:forEach var="shop" items="${shops}">
                                                            <tr>
                                                                <td><strong>#${shop.shopID}</strong></td>
                                                                <td>
                                                                    <i class="fa fa-building text-primary"></i>
                                                                    <strong>${shop.shopName}</strong>
                                                                </td>
                                                                <td>
                                                                    <i class="fa fa-map-marker text-danger"></i>
                                                                    ${shop.address}
                                                                </td>
                                                                <td>
                                                                    <i class="fa fa-phone text-success"></i>
                                                                    ${shop.phone}
                                                                </td>
                                                                <td class="text-center">
                                                                    <c:choose>
                                                                        <c:when test="${shop.active}">
                                                                            <span class="label label-success">
                                                                                <i class="fa fa-check"></i> Hoạt động
                                                                            </span>
                                                                        </c:when>
                                                                        <c:otherwise>
                                                                            <span class="label label-danger">
                                                                                <i class="fa fa-times"></i> Ngừng
                                                                            </span>
                                                                        </c:otherwise>
                                                                    </c:choose>
                                                                </td>
                                                                <td>
                                                                    <i class="fa fa-calendar"></i>
                                                                    ${shop.createdAt}
                                                                </td>
                                                                <td class="text-center">
                                                                    <a href="${pageContext.request.contextPath}/user/shop?action=view&shopId=${shop.shopID}" 
                                                                       class="btn btn-primary btn-sm">
                                                                        <i class="fa fa-eye"></i> Xem
                                                                    </a>
                                                                </td>
                                                            </tr>
                                                        </c:forEach>
                                                    </tbody>
                                                </table>
                                            </div>
                                        </c:otherwise>
                                    </c:choose>
                                </div>
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
</body>
</html>
