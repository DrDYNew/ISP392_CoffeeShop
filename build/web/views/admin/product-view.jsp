<%@page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html>
<c:set var="title" value="Chi tiết sản phẩm - Coffee Shop Management" scope="request"/> <meta charset="utf-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <title>Admin Dashboard - Coffee Shop Management</title>
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
    <!-- Morris charts -->
    <link rel="stylesheet" href="${pageContext.request.contextPath}/plugins/morris/morris.css">
    <!-- Sidebar improvements -->
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/sidebar-improvements.css">
    <!-- Chart.js -->
    
    <style>
        .content-wrapper {
            margin-left: 230px;
            min-height: 100vh;
            background-color: #f4f4f4;
            padding: 20px;
        }
        
        .content-header {
            margin-bottom: 20px;
        }
        
        .content-header h1 {
            margin: 0;
            font-size: 24px;
            font-weight: 300;
        }
        
        .breadcrumb {
            background: transparent;
            margin-top: 5px;
            padding: 0;
            font-size: 12px;
        }
        
        .box {
            background: #fff;
            border-top: 3px solid #d2d6de;
            margin-bottom: 20px;
            width: 100%;
            box-shadow: 0 1px 3px rgba(0,0,0,0.12), 0 1px 2px rgba(0,0,0,0.24);
        }
        
        .box-header {
            border-bottom: 1px solid #f4f4f4;
            padding: 10px 15px;
            position: relative;
        }
        
        .box-title {
            font-size: 18px;
            margin: 0;
            line-height: 1.8;
        }
        
        .box-body {
            padding: 15px;
        }
        
        .btn {
            display: inline-block;
            padding: 6px 12px;
            margin-bottom: 0;
            font-size: 14px;
            font-weight: normal;
            line-height: 1.42857143;
            text-align: center;
            white-space: nowrap;
            vertical-align: middle;
            cursor: pointer;
            border: 1px solid transparent;
            border-radius: 4px;
            text-decoration: none;
        }
        
        .btn-primary {
            color: #fff;
            background-color: #3c8dbc;
            border-color: #367fa9;
        }
        
        .btn-default {
            color: #333;
            background-color: #fff;
            border-color: #ccc;
        }
        
        .label {
            display: inline;
            padding: .2em .6em .3em;
            font-size: 75%;
            font-weight: bold;
            line-height: 1;
            color: #fff;
            text-align: center;
            white-space: nowrap;
            vertical-align: baseline;
            border-radius: .25em;
        }
        
        .label-success {
            background-color: #5cb85c;
        }
        
        .label-danger {
            background-color: #d9534f;
        }
        
        .info-item {
            display: flex;
            margin-bottom: 15px;
            padding: 10px 0;
            border-bottom: 1px solid #eee;
        }
        
        .info-label {
            font-weight: bold;
            width: 150px;
            color: #333;
        }
        
        .info-value {
            flex: 1;
            color: #666;
        }
        
        .product-details {
            background: #f9f9f9;
            padding: 20px;
            border-radius: 4px;
            margin-bottom: 20px;
        }
        
        .price-display {
            font-size: 24px;
            color: #e74c3c;
            font-weight: bold;
        }
        
        .category-name, .supplier-name {
            color: #3498db;
            font-weight: 500;
        }
        
        .category-name i, .supplier-name i {
            margin-right: 5px;
            color: #7f8c8d;
        }
    </style>
</head>
<body class="hold-transition skin-blue sidebar-mini">
<div class="wrapper">
    <!-- Include header -->
    <jsp:include page="../compoment/header.jsp" />
    
    <!-- Include sidebar -->
    <jsp:include page="../compoment/sidebar.jsp" />
    
    <!-- Content Wrapper -->
    <div class="content-wrapper">
        <!-- Content Header -->
        <section class="content-header">
            <h1>
                Chi tiết sản phẩm
                <small>${product.productName}</small>
            </h1>
            <ol class="breadcrumb">
                <li><a href="${pageContext.request.contextPath}/admin/dashboard"><i class="fa fa-dashboard"></i> Trang chủ</a></li>
                <li><a href="${pageContext.request.contextPath}/admin/products">Quản lý sản phẩm</a></li>
                <li class="active">Chi tiết sản phẩm</li>
            </ol>
        </section>

        <!-- Main content -->
        <section class="content">
            <c:if test="${not empty error}">
                <div class="alert alert-danger alert-dismissible">
                    <button type="button" class="close" data-dismiss="alert" aria-hidden="true">×</button>
                    <i class="icon fa fa-ban"></i> ${error}
                </div>
            </c:if>

            <div class="box">
                <div class="box-header">
                    <h3 class="box-title">Thông tin sản phẩm</h3>
                    <div class="box-tools pull-right">
                        <a href="${pageContext.request.contextPath}/admin/products" class="btn btn-default">
                            <i class="fa fa-arrow-left"></i> Quay lại danh sách
                        </a>
                    </div>
                </div>
                
                <div class="box-body">
                    <div class="product-details">
                        <div class="info-item">
                            <div class="info-label">ID sản phẩm:</div>
                            <div class="info-value">${product.productID}</div>
                        </div>
                        
                        <div class="info-item">
                            <div class="info-label">Tên sản phẩm:</div>
                            <div class="info-value">
                                <strong style="font-size: 18px;">${product.productName}</strong>
                            </div>
                        </div>
                        
                        <div class="info-item">
                            <div class="info-label">Mô tả:</div>
                            <div class="info-value">
                                <c:choose>
                                    <c:when test="${not empty product.description}">
                                        ${product.description}
                                    </c:when>
                                    <c:otherwise>
                                        <em style="color: #999;">Không có mô tả</em>
                                    </c:otherwise>
                                </c:choose>
                            </div>
                        </div>
                        
                        <div class="info-item">
                            <div class="info-label">Danh mục:</div>
                            <div class="info-value">
                                <c:choose>
                                    <c:when test="${not empty product.categoryName}">
                                        <span class="category-name">
                                            <i class="fa fa-tag"></i> ${product.categoryName}
                                        </span>
                                    </c:when>
                                    <c:otherwise>
                                        <em style="color: #999;">Không xác định</em>
                                    </c:otherwise>
                                </c:choose>
                            </div>
                        </div>
                        
                        <div class="info-item">
                            <div class="info-label">Giá:</div>
                            <div class="info-value">
                                <span class="price-display">
                                    <fmt:formatNumber value="${product.price}" type="currency" currencySymbol="₫" />
                                </span>
                            </div>
                        </div>
                        
                        <div class="info-item">
                            <div class="info-label">Nhà cung cấp:</div>
                            <div class="info-value">
                                <c:choose>
                                    <c:when test="${not empty product.supplierName}">
                                        <span class="supplier-name">
                                            <i class="fa fa-truck"></i> ${product.supplierName}
                                        </span>
                                    </c:when>
                                    <c:otherwise>
                                        <em style="color: #999;">Không xác định</em>
                                    </c:otherwise>
                                </c:choose>
                            </div>
                        </div>
                        
                        <div class="info-item">
                            <div class="info-label">Trạng thái:</div>
                            <div class="info-value">
                                <c:choose>
                                    <c:when test="${product.active}">
                                        <span class="label label-success">
                                            <i class="fa fa-check"></i> Đang hoạt động
                                        </span>
                                    </c:when>
                                    <c:otherwise>
                                        <span class="label label-danger">
                                            <i class="fa fa-ban"></i> Không hoạt động
                                        </span>
                                    </c:otherwise>
                                </c:choose>
                            </div>
                        </div>
                        
                        <div class="info-item">
                            <div class="info-label">Ngày tạo:</div>
                            <div class="info-value">
                                <c:choose>
                                    <c:when test="${not empty product.createdAt}">
                                        <fmt:formatDate value="${product.createdAt}" pattern="dd/MM/yyyy HH:mm:ss" />
                                    </c:when>
                                    <c:otherwise>
                                        <em style="color: #999;">Không có thông tin</em>
                                    </c:otherwise>
                                </c:choose>
                            </div>
                        </div>
                    </div>
                    
                    <!-- Action Buttons -->
                    <div style="text-align: center; margin-top: 20px;">
                        <a href="${pageContext.request.contextPath}/admin/products" class="btn btn-primary">
                            <i class="fa fa-list"></i> Quay lại danh sách
                        </a>
                    </div>
                </div>
            </div>
        </section>
    </div>
</div>


</body>
</html>