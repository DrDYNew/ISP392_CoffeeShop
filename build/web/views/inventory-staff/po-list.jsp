<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Danh sách Đơn hàng - Purchase Orders</title>
    
    <!-- Bootstrap 3.3.6 -->
    <link rel="stylesheet" href="${pageContext.request.contextPath}/bootstrap/css/bootstrap.min.css">
    <!-- Font Awesome -->
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/4.5.0/css/font-awesome.min.css">
    <!-- Theme style -->
    <link rel="stylesheet" href="${pageContext.request.contextPath}/dist/css/AdminLTE.min.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/dist/css/skins/_all-skins.min.css">
    
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
        
        .status-badge {
            padding: 6px 14px;
            border-radius: 20px;
            font-size: 12px;
            font-weight: 600;
            text-transform: uppercase;
            letter-spacing: 0.5px;
            display: inline-block;
        }
        
        .status-badge.status-Pending {
            background: linear-gradient(135deg, #ffd89b 0%, #ffa400 100%);
            color: #fff;
            box-shadow: 0 2px 8px rgba(255, 164, 0, 0.4);
        }
        
        .status-badge.status-Approved {
            background: linear-gradient(135deg, #a8edea 0%, #00c6ff 100%);
            color: #fff;
            box-shadow: 0 2px 8px rgba(0, 198, 255, 0.4);
        }
        
        .status-badge.status-Shipping {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: #fff;
            box-shadow: 0 2px 8px rgba(118, 75, 162, 0.4);
        }
        
        .status-badge.status-Received {
            background: linear-gradient(135deg, #56ab2f 0%, #a8e063 100%);
            color: #fff;
            box-shadow: 0 2px 8px rgba(86, 171, 47, 0.4);
        }
        
        .status-badge.status-Cancelled {
            background: linear-gradient(135deg, #fc4a1a 0%, #f7b733 100%);
            color: #fff;
            box-shadow: 0 2px 8px rgba(252, 74, 26, 0.4);
        }
        
        .box {
            border-radius: 10px;
            box-shadow: 0 2px 10px rgba(0,0,0,0.08);
            border: none;
        }
        
        .box-header {
            background: #fff;
            border-bottom: 2px solid #f4f4f4;
            border-radius: 10px 10px 0 0;
        }
        
        .table > thead > tr > th {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            font-weight: 600;
            border: none !important;
            text-transform: uppercase;
            font-size: 12px;
            letter-spacing: 0.5px;
        }
        
        .table > tbody > tr:hover {
            background-color: #f8f9fa;
            transform: scale(1.01);
            transition: all 0.2s ease;
            box-shadow: 0 2px 8px rgba(0,0,0,0.1);
        }
        
        .table > tbody > tr > td {
            vertical-align: middle !important;
        }
        
        .btn-action {
            margin: 2px;
            padding: 5px 10px;
            border-radius: 5px;
            transition: all 0.3s ease;
        }
        
        .btn-action:hover {
            transform: translateY(-2px);
            box-shadow: 0 4px 8px rgba(0,0,0,0.2);
        }
        
        .alert {
            border-radius: 10px;
            border: none;
            box-shadow: 0 2px 10px rgba(0,0,0,0.1);
        }
        
        .breadcrumb {
            background: transparent;
            padding: 10px 0;
        }
        
        .empty-state {
            text-align: center;
            padding: 60px 20px;
            color: #999;
        }
        
        .empty-state i {
            font-size: 64px;
            margin-bottom: 20px;
            opacity: 0.3;
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
            <h1><i class="fa fa-file-text-o"></i> Quản lý Đơn hàng Nguyên liệu</h1>
            <ol class="breadcrumb" style="background: transparent; padding-top: 10px;">
                <li><a href="${pageContext.request.contextPath}/views/inventory-staff/dashboard.jsp" style="color: rgba(255,255,255,0.8);"><i class="fa fa-dashboard"></i> Dashboard</a></li>
                <li style="color: white;">Danh sách đơn hàng</li>
            </ol>
        </div>
        
        <!-- Success/Error Messages -->
        <c:if test="${not empty sessionScope.successMessage}">
            <div class="alert alert-success alert-dismissible">
                <button type="button" class="close" data-dismiss="alert">&times;</button>
                <i class="fa fa-check-circle"></i> ${sessionScope.successMessage}
            </div>
            <c:remove var="successMessage" scope="session"/>
        </c:if>
        
        <c:if test="${not empty sessionScope.errorMessage}">
            <div class="alert alert-danger alert-dismissible">
                <button type="button" class="close" data-dismiss="alert">&times;</button>
                <i class="fa fa-exclamation-circle"></i> ${sessionScope.errorMessage}
            </div>
            <c:remove var="errorMessage" scope="session"/>
        </c:if>
        
        <!-- Main Content -->
        <div class="box">
            <div class="box-header with-border">
                <h3 class="box-title"><i class="fa fa-list"></i> Danh sách đơn hàng</h3>
                <div class="box-tools pull-right">
                    <span class="label label-primary">Tổng số: ${poList != null ? poList.size() : 0} đơn hàng</span>
                </div>
            </div>
            <div class="box-body">
                <div class="row" style="margin-bottom: 15px;">
                    <div class="col-xs-12">
                        <a href="${pageContext.request.contextPath}/purchase-order?action=new" class="btn btn-primary">
                            <i class="fa fa-plus"></i> Tạo đơn hàng mới
                        </a>
                    </div>
                </div>
                
                <div class="table-responsive">
                    <table class="table table-striped table-hover">
                        <thead>
                            <tr>
                                <th>Mã đơn hàng</th>
                                <th>Cửa hàng</th>
                                <th>Nhà cung cấp</th>
                                <th>Người tạo</th>
                                <th>Trạng thái</th>
                                <th>Ngày tạo</th>
                                <th style="width: 180px;">Thao tác</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:choose>
                                <c:when test="${empty poList}">
                                    <tr>
                                        <td colspan="7">
                                            <div class="empty-state">
                                                <i class="fa fa-inbox"></i>
                                                <h4>Chưa có đơn hàng nào</h4>
                                                <p>Nhấn "Tạo đơn hàng mới" để bắt đầu</p>
                                            </div>
                                        </td>
                                    </tr>
                                </c:when>
                                <c:otherwise>
                                    <c:forEach var="po" items="${poList}">
                                        <tr>
                                            <td><strong style="color: #667eea;">PO-${po.poID}</strong></td>
                                            <td><i class="fa fa-building-o"></i> ${po.shopName}</td>
                                            <td><i class="fa fa-truck"></i> ${po.supplierName}</td>
                                            <td><i class="fa fa-user"></i> ${po.createdByName}</td>
                                            <td>
                                                <span class="status-badge status-${po.statusName}">${po.statusName}</span>
                                            </td>
                                            <td>
                                                <i class="fa fa-calendar"></i>
                                                <fmt:formatDate value="${po.createdAt}" pattern="dd/MM/yyyy HH:mm"/>
                                            </td>
                                            <td>
                                                <a href="${pageContext.request.contextPath}/purchase-order?action=view&id=${po.poID}" 
                                                   class="btn btn-info btn-xs btn-action" title="Xem chi tiết">
                                                    <i class="fa fa-eye"></i>
                                                </a>
                                                <c:if test="${po.statusID == 19}">
                                                    <a href="${pageContext.request.contextPath}/purchase-order?action=edit&id=${po.poID}" 
                                                       class="btn btn-warning btn-xs btn-action" title="Chỉnh sửa">
                                                        <i class="fa fa-edit"></i>
                                                    </a>
                                                </c:if>
                                            </td>
                                        </tr>
                                    </c:forEach>
                                </c:otherwise>
                            </c:choose>
                        </tbody>
                    </table>
                </div>
            </div>
        </div>
    </div>
</div>

<!-- jQuery 2.2.3 -->
<script src="${pageContext.request.contextPath}/plugins/jQuery/jquery-2.2.3.min.js"></script>
<!-- Bootstrap 3.3.6 -->
<script src="${pageContext.request.contextPath}/bootstrap/js/bootstrap.min.js"></script>
<!-- AdminLTE App -->
<script src="${pageContext.request.contextPath}/dist/js/app.min.js"></script>

</body>
</html>
