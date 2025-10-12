<%@page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="utf-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <title>Danh sách đơn hàng - Coffee Shop Management</title>
    <meta content="width=device-width, initial-scale=1, maximum-scale=1, user-scalable=no" name="viewport">
    <!-- Bootstrap 3.3.6 -->
    <link rel="stylesheet" href="${pageContext.request.contextPath}/bootstrap/css/bootstrap.min.css">
    <!-- Font Awesome -->
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/4.5.0/css/font-awesome.min.css">
    <!-- AdminLTE -->
    <link rel="stylesheet" href="https://adminlte.io/themes/AdminLTE/dist/css/AdminLTE.min.css">
    <link rel="stylesheet" href="https://adminlte.io/themes/AdminLTE/dist/css/skins/_all-skins.min.css">
    <style>
        .order-card {
            margin-bottom: 15px;
            border-left: 4px solid #3c8dbc;
        }
        .order-card.status-new {
            border-left-color: #00c0ef;
        }
        .order-card.status-preparing {
            border-left-color: #f39c12;
        }
        .order-card.status-ready {
            border-left-color: #00a65a;
        }
        .order-card.status-completed {
            border-left-color: #777;
        }
        .order-card.status-cancelled {
            border-left-color: #dd4b39;
        }
    </style>
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
                Danh sách đơn hàng
                <small>Quản lý đơn hàng</small>
            </h1>
            <ol class="breadcrumb">
                <li><a href="${pageContext.request.contextPath}/barista/dashboard"><i class="fa fa-dashboard"></i> Trang chủ</a></li>
                <li class="active">Danh sách đơn hàng</li>
            </ol>
        </section>

        <!-- Main content -->
        <section class="content">
            <div class="row">
                <div class="col-xs-12">
                    <div class="box">
                        <div class="box-header">
                            <h3 class="box-title">Tất cả đơn hàng</h3>
                        </div>
                        
                        <div class="box-body">
                            <!-- Success Message -->
                            <c:if test="${not empty sessionScope.successMessage}">
                                <div class="alert alert-success alert-dismissible">
                                    <button type="button" class="close" data-dismiss="alert">&times;</button>
                                    <i class="icon fa fa-check"></i> ${sessionScope.successMessage}
                                </div>
                                <c:remove var="successMessage" scope="session"/>
                            </c:if>
                            
                            <!-- Error Message -->
                            <c:if test="${not empty sessionScope.errorMessage}">
                                <div class="alert alert-danger alert-dismissible">
                                    <button type="button" class="close" data-dismiss="alert">&times;</button>
                                    <i class="icon fa fa-ban"></i> ${sessionScope.errorMessage}
                                </div>
                                <c:remove var="errorMessage" scope="session"/>
                            </c:if>
                            
                            <!-- Filter -->
                            <div class="row" style="margin-bottom: 15px;">
                                <div class="col-md-4">
                                    <form method="get" action="${pageContext.request.contextPath}/barista/orders">
                                        <div class="form-group">
                                            <label>Lọc theo trạng thái:</label>
                                            <select class="form-control" name="status" onchange="this.form.submit()">
                                                <option value="">Tất cả</option>
                                                <c:forEach var="status" items="${orderStatuses}">
                                                    <option value="${status.settingID}" 
                                                            ${statusFilter == status.settingID ? 'selected' : ''}>
                                                        ${status.value}
                                                    </option>
                                                </c:forEach>
                                            </select>
                                        </div>
                                    </form>
                                </div>
                            </div>
                            
                            <!-- Orders List -->
                            <c:forEach var="order" items="${orders}">
                                <div class="order-card box box-solid status-${fn:toLowerCase(order.statusName)}">
                                    <div class="box-body">
                                        <div class="row">
                                            <div class="col-md-8">
                                                <h4>
                                                    <a href="${pageContext.request.contextPath}/barista/order-details?id=${order.orderID}">
                                                        Đơn hàng #${order.orderID}
                                                    </a>
                                                    <span class="label label-${order.statusName == 'New' ? 'info' : 
                                                                                 order.statusName == 'Preparing' ? 'warning' :
                                                                                 order.statusName == 'Ready' ? 'success' :
                                                                                 order.statusName == 'Completed' ? 'default' : 'danger'}">
                                                        ${order.statusName}
                                                    </span>
                                                </h4>
                                                <p>
                                                    <i class="fa fa-store"></i> ${order.shopName}<br>
                                                    <i class="fa fa-user"></i> ${order.createdByName}<br>
                                                    <i class="fa fa-clock-o"></i> 
                                                    <fmt:formatDate value="${order.createdAt}" pattern="dd/MM/yyyy HH:mm"/>
                                                </p>
                                            </div>
                                            <div class="col-md-4 text-right">
                                                <a href="${pageContext.request.contextPath}/barista/order-details?id=${order.orderID}" 
                                                   class="btn btn-primary btn-sm">
                                                    <i class="fa fa-eye"></i> Xem chi tiết
                                                </a>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </c:forEach>
                            
                            <c:if test="${empty orders}">
                                <div class="alert alert-info">
                                    <i class="icon fa fa-info"></i> Không có đơn hàng nào
                                </div>
                            </c:if>
                            
                            <!-- Pagination -->
                            <c:if test="${totalPages > 1}">
                                <div class="text-center">
                                    <ul class="pagination">
                                        <c:if test="${currentPage > 1}">
                                            <li>
                                                <a href="?page=${currentPage - 1}&status=${statusFilter}">
                                                    <i class="fa fa-angle-left"></i>
                                                </a>
                                            </li>
                                        </c:if>
                                        
                                        <c:forEach begin="1" end="${totalPages}" var="pageNum">
                                            <li class="${pageNum == currentPage ? 'active' : ''}">
                                                <a href="?page=${pageNum}&status=${statusFilter}">
                                                    ${pageNum}
                                                </a>
                                            </li>
                                        </c:forEach>
                                        
                                        <c:if test="${currentPage < totalPages}">
                                            <li>
                                                <a href="?page=${currentPage + 1}&status=${statusFilter}">
                                                    <i class="fa fa-angle-right"></i>
                                                </a>
                                            </li>
                                        </c:if>
                                    </ul>
                                </div>
                            </c:if>
                        </div>
                    </div>
                </div>
            </div>
        </section>
    </div>
    
    <!-- Include Footer -->
    <%@include file="../compoment/footer.jsp" %>

</div>

<!-- jQuery 2.2.3 -->
<script src="https://code.jquery.com/jquery-2.2.3.min.js"></script>
<!-- Bootstrap 3.3.6 JS -->
<script src="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.6/js/bootstrap.min.js"></script>
<!-- AdminLTE App -->
<script src="https://adminlte.io/themes/AdminLTE/dist/js/app.min.js"></script>

</body>
</html>
