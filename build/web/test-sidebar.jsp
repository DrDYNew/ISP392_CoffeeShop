<%@page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%
    // Set mock session data for testing
    session.setAttribute("roleName", "Admin");
    // Có thể thay đổi thành "HR", "Barista", "Inventory" để test các role khác
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="utf-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <title>Test Sidebar Navigation</title>
    <meta content="width=device-width, initial-scale=1, maximum-scale=1, user-scalable=no" name="viewport">
    
    <!-- Bootstrap CSS từ CDN -->
    <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/css/bootstrap.min.css">
    <!-- Font Awesome -->
    <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/font-awesome/4.7.0/css/font-awesome.min.css">
    <!-- AdminLTE CSS -->
    <link rel="stylesheet" href="${pageContext.request.contextPath}/dist/css/AdminLTE.min.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/dist/css/skins/_all-skins.min.css">
    
    <!-- jQuery từ CDN -->
    <script src="https://code.jquery.com/jquery-2.2.4.min.js"></script>
    <!-- Bootstrap JS từ CDN -->
    <script src="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/js/bootstrap.min.js"></script>
    
    <style>
        .test-info {
            background: #f4f4f4;
            padding: 15px;
            border-left: 5px solid #3c8dbc;
            margin-bottom: 20px;
        }
    </style>
</head>
<body class="hold-transition skin-blue sidebar-mini">
<div class="wrapper">
    <!-- Main Header -->
    <header class="main-header">
        <a href="#" class="logo">
            <span class="logo-mini"><b>CS</b></span>
            <span class="logo-lg"><b>Coffee</b>Shop</span>
        </a>
        <nav class="navbar navbar-static-top">
            <a href="#" class="sidebar-toggle" data-toggle="push-menu" role="button">
                <span class="sr-only">Toggle navigation</span>
            </a>
        </nav>
    </header>

    <!-- Include Sidebar -->
    <jsp:include page="views/compoment/sidebar.jsp" />

    <!-- Content Wrapper -->
    <div class="content-wrapper">
        <section class="content-header">
            <h1>Test Sidebar Navigation <small>Kiểm tra chức năng điều hướng</small></h1>
        </section>
        <section class="content">
            <div class="row">
                <div class="col-md-12">
                    <div class="box box-primary">
                        <div class="box-header with-border">
                            <h3 class="box-title">Thông tin Test</h3>
                        </div>
                        <div class="box-body">
                            <div class="test-info">
                                <h4><i class="fa fa-info-circle"></i> Hướng dẫn test:</h4>
                                <ol>
                                    <li>Kiểm tra các menu trong sidebar bên trái</li>
                                    <li>Click vào các menu có submenu để xem có mở/đóng được không</li>
                                    <li>Click vào các link để xem có chuyển trang được không</li>
                                    <li>Hiện tại đang test với role: <strong style="color: blue;">${sessionScope.roleName}</strong></li>
                                </ol>
                            </div>
                            
                            <h4>Menu có sẵn theo role:</h4>
                            <c:if test="${sessionScope.roleName == 'Admin'}">
                                <div class="alert alert-info">
                                    <h5>Admin Menu:</h5>
                                    <ul>
                                        <li>Dashboard</li>
                                        <li>Quản lý người dùng (có submenu)</li>
                                        <li>Quản lý sản phẩm (có submenu)</li>
                                        <li>Quản trị hệ thống (có submenu)</li>
                                        <li>Thống kê tổng quan</li>
                                    </ul>
                                </div>
                            </c:if>
                            
                            <c:if test="${sessionScope.roleName == 'HR'}">
                                <div class="alert alert-success">
                                    <h5>HR Menu:</h5>
                                    <ul>
                                        <li>Dashboard</li>
                                        <li>Quản lý người dùng (có submenu)</li>
                                        <li>Quản lý nhân viên (có submenu)</li>
                                        <li>Tuyển dụng (có submenu)</li>
                                        <li>Lịch làm việc (có submenu)</li>
                                        <li>Bảng lương</li>
                                        <li>Báo cáo HR</li>
                                    </ul>
                                </div>
                            </c:if>
                            
                            <c:if test="${sessionScope.roleName == 'Inventory'}">
                                <div class="alert alert-warning">
                                    <h5>Inventory Menu:</h5>
                                    <ul>
                                        <li>Dashboard</li>
                                        <li>Quản lý kho (có submenu)</li>
                                        <li>Đơn đặt hàng (có submenu)</li>
                                        <li>Nhà cung cấp</li>
                                    </ul>
                                </div>
                            </c:if>
                            
                            <c:if test="${sessionScope.roleName == 'Barista'}">
                                <div class="alert alert-danger">
                                    <h5>Barista Menu:</h5>
                                    <ul>
                                        <li>Dashboard</li>
                                        <li>Đơn hàng</li>
                                        <li>Menu</li>
                                        <li>Ca làm việc</li>
                                    </ul>
                                </div>
                            </c:if>
                            
                            <h4>Console Log:</h4>
                            <p>Mở Developer Tools (F12) để xem console logs và kiểm tra lỗi JavaScript.</p>
                            
                            <h4>Thay đổi role để test:</h4>
                            <p>
                                <a href="?role=Admin" class="btn btn-primary">Test Admin</a>
                                <a href="?role=HR" class="btn btn-success">Test HR</a>
                                <a href="?role=Inventory" class="btn btn-warning">Test Inventory</a>
                                <a href="?role=Barista" class="btn btn-danger">Test Barista</a>
                            </p>
                        </div>
                    </div>
                </div>
            </div>
        </section>
    </div>
</div>

<%
    // Handle role change
    String roleParam = request.getParameter("role");
    if (roleParam != null && !roleParam.isEmpty()) {
        session.setAttribute("roleName", roleParam);
    }
%>

</body>
</html>