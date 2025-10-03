<%@page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="utf-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <title>Lỗi hệ thống - Coffee Shop Management</title>
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
        .error-page {
            width: 600px;
            margin: 20px auto 0 auto;
        }
        .error-page > .headline {
            float: left;
            font-size: 100px;
            font-weight: 300;
        }
        .error-page > .error-content {
            margin-left: 190px;
        }
        .error-page > .error-content > h3 {
            font-weight: 300;
            font-size: 25px;
        }
        @media (max-width: 991px) {
            .error-page {
                width: 100%;
                margin: 20px 0 0 0;
                padding: 0 15px;
            }
            .error-page > .headline {
                float: none;
                text-align: center;
            }
            .error-page > .error-content {
                margin-left: 0;
            }
        }
    </style>
</head>
<body class="hold-transition skin-blue sidebar-mini">
<div class="wrapper">

    <!-- Check if user is logged in to show header/sidebar -->
    <c:if test="${not empty sessionScope.user}">
        <!-- Include Header -->
        <%@include file="../compoment/header.jsp" %>
        
        <!-- Include Sidebar -->
        <%@include file="../compoment/sidebar.jsp" %>
    </c:if>

    <!-- Content Wrapper. Contains page content -->
    <div class="content-wrapper" style="${empty sessionScope.user ? 'margin-left: 0;' : ''}">
        <!-- Content Header (Page header) -->
        <section class="content-header">
            <h1>
                Lỗi hệ thống
                <small>Đã xảy ra lỗi</small>
            </h1>
            <c:if test="${not empty sessionScope.user}">
                <ol class="breadcrumb">
                    <li><a href="${pageContext.request.contextPath}/"><i class="fa fa-dashboard"></i> Trang chủ</a></li>
                    <li class="active">Lỗi</li>
                </ol>
            </c:if>
        </section>

        <!-- Main content -->
        <section class="content">
            <div class="error-page">
                <h2 class="headline text-red">
                    <i class="fa fa-warning text-red"></i>
                </h2>
                
                <div class="error-content">
                    <h3><i class="fa fa-warning text-red"></i> Oops! Đã xảy ra lỗi.</h3>
                    
                    <c:choose>
                        <c:when test="${not empty error}">
                            <div class="alert alert-danger">
                                <h4><i class="icon fa fa-ban"></i> Chi tiết lỗi:</h4>
                                ${error}
                            </div>
                        </c:when>
                        <c:when test="${not empty requestScope['javax.servlet.error.message']}">
                            <div class="alert alert-danger">
                                <h4><i class="icon fa fa-ban"></i> Chi tiết lỗi:</h4>
                                ${requestScope['javax.servlet.error.message']}
                            </div>
                        </c:when>
                        <c:otherwise>
                            <p>
                                Chúng tôi đang gặp một số vấn đề kỹ thuật. 
                                Vui lòng thử lại sau hoặc liên hệ với quản trị viên hệ thống.
                            </p>
                        </c:otherwise>
                    </c:choose>
                    
                    <div class="alert alert-info">
                        <h4><i class="icon fa fa-info"></i> Gợi ý:</h4>
                        <ul>
                            <li>Kiểm tra lại đường dẫn URL</li>
                            <li>Đảm bảo bạn đã đăng nhập với quyền phù hợp</li>
                            <li>Thử làm mới trang (F5)</li>
                            <li>Liên hệ với bộ phận hỗ trợ kỹ thuật</li>
                        </ul>
                    </div>
                    
                    <div class="btn-group">
                        <button type="button" onclick="history.back()" class="btn btn-default">
                            <i class="fa fa-arrow-left"></i> Quay lại
                        </button>
                        <c:choose>
                            <c:when test="${not empty sessionScope.user}">
                                <c:choose>
                                    <c:when test="${sessionScope.roleName == 'HR'}">
                                        <a href="${pageContext.request.contextPath}/hr/dashboard" class="btn btn-primary">
                                            <i class="fa fa-home"></i> Trang chủ HR
                                        </a>
                                    </c:when>
                                    <c:when test="${sessionScope.roleName == 'Admin'}">
                                        <a href="${pageContext.request.contextPath}/admin/dashboard" class="btn btn-primary">
                                            <i class="fa fa-home"></i> Trang chủ Admin
                                        </a>
                                    </c:when>
                                    <c:when test="${sessionScope.roleName == 'Inventory'}">
                                        <a href="${pageContext.request.contextPath}/inventory/dashboard" class="btn btn-primary">
                                            <i class="fa fa-home"></i> Trang chủ Inventory
                                        </a>
                                    </c:when>
                                    <c:when test="${sessionScope.roleName == 'Barista'}">
                                        <a href="${pageContext.request.contextPath}/barista/dashboard" class="btn btn-primary">
                                            <i class="fa fa-home"></i> Trang chủ Barista
                                        </a>
                                    </c:when>
                                    <c:otherwise>
                                        <a href="${pageContext.request.contextPath}/" class="btn btn-primary">
                                            <i class="fa fa-home"></i> Trang chủ
                                        </a>
                                    </c:otherwise>
                                </c:choose>
                            </c:when>
                            <c:otherwise>
                                <a href="${pageContext.request.contextPath}/login" class="btn btn-primary">
                                    <i class="fa fa-sign-in"></i> Đăng nhập
                                </a>
                            </c:otherwise>
                        </c:choose>
                    </div>
                </div>
            </div>
        </section>
    </div>
    
    <!-- Include Footer only if user is logged in -->
    <c:if test="${not empty sessionScope.user}">
        <!-- Include Footer -->
        <%@include file="../compoment/footer.jsp" %>
    </c:if>

</div>

<!-- jQuery -->
<script src="${pageContext.request.contextPath}/plugins/jQuery/jquery-2.2.3.min.js"></script>
<!-- Bootstrap -->
<script src="${pageContext.request.contextPath}/bootstrap/js/bootstrap.min.js"></script>
<!-- AdminLTE App -->
<script src="${pageContext.request.contextPath}/dist/js/app.min.js"></script>

<script>
    // Auto-redirect after 30 seconds if no user interaction
    setTimeout(function() {
        if (confirm('Bạn có muốn quay lại trang trước đó không?')) {
            history.back();
        }
    }, 30000);
</script>

</body>
</html>