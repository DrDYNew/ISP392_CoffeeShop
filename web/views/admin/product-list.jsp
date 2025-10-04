<%@page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html>
<c:set var="title" value="Quản lý sản phẩm - Coffee Shop Management" scope="request"/>
 <meta charset="utf-8">
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
        
        .btn-success {
            color: #fff;
            background-color: #00a65a;
            border-color: #008d4c;
        }
        
        .btn-warning {
            color: #fff;
            background-color: #f39c12;
            border-color: #e08e0b;
        }
        
        .btn-danger {
            color: #fff;
            background-color: #dd4b39;
            border-color: #d73925;
        }
        
        .btn-sm {
            padding: 5px 10px;
            font-size: 12px;
            line-height: 1.5;
            border-radius: 3px;
        }
        
        .table {
            width: 100%;
            max-width: 100%;
            margin-bottom: 20px;
            background-color: transparent;
            border-collapse: collapse;
        }
        
        .table > thead > tr > th,
        .table > tbody > tr > th,
        .table > tfoot > tr > th,
        .table > thead > tr > td,
        .table > tbody > tr > td,
        .table > tfoot > tr > td {
            padding: 8px;
            line-height: 1.42857143;
            vertical-align: top;
            border-top: 1px solid #ddd;
        }
        
        .table > thead > tr > th {
            vertical-align: bottom;
            border-bottom: 2px solid #ddd;
            background-color: #f5f5f5;
        }
        
        .table-striped > tbody > tr:nth-of-type(odd) {
            background-color: #f9f9f9;
        }
        
        .form-control {
            display: inline-block;
            width: auto;
            padding: 6px 12px;
            font-size: 14px;
            line-height: 1.42857143;
            color: #555;
            background-color: #fff;
            background-image: none;
            border: 1px solid #ccc;
            border-radius: 4px;
        }
        
        .pagination {
            display: inline-block;
            padding-left: 0;
            margin: 20px 0;
            border-radius: 4px;
        }
        
        .pagination > li {
            display: inline;
        }
        
        .pagination > li > a {
            position: relative;
            float: left;
            padding: 6px 12px;
            margin-left: -1px;
            line-height: 1.42857143;
            color: #337ab7;
            text-decoration: none;
            background-color: #fff;
            border: 1px solid #ddd;
        }
        
        .pagination > .active > a {
            z-index: 3;
            color: #fff;
            cursor: default;
            background-color: #337ab7;
            border-color: #337ab7;
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
        
        .filters {
            margin-bottom: 20px;
            padding: 15px;
            background: #f8f9fa;
            border-radius: 4px;
        }
        
        .row {
            margin-left: -15px;
            margin-right: -15px;
        }
        
        .col-md-3 {
            position: relative;
            min-height: 1px;
            padding-left: 15px;
            padding-right: 15px;
            width: 25%;
            float: left;
        }
        
        .col-md-6 {
            position: relative;
            min-height: 1px;
            padding-left: 15px;
            padding-right: 15px;
            width: 50%;
            float: left;
        }
        
        .clearfix:after {
            content: "";
            display: table;
            clear: both;
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
                Quản lý sản phẩm
                <small>Danh sách sản phẩm</small>
            </h1>
            <ol class="breadcrumb">
                <li><a href="${pageContext.request.contextPath}/admin/dashboard"><i class="fa fa-dashboard"></i> Trang chủ</a></li>
                <li class="active">Quản lý sản phẩm</li>
            </ol>
        </section>

        <!-- Main content -->
        <section class="content">
            <!-- Success/Error Messages -->
            <c:if test="${not empty sessionScope.successMessage}">
                <div class="alert alert-success alert-dismissible">
                    <button type="button" class="close" data-dismiss="alert" aria-hidden="true">×</button>
                    <i class="icon fa fa-check"></i> ${sessionScope.successMessage}
                </div>
                <c:remove var="successMessage" scope="session" />
            </c:if>
            
            <c:if test="${not empty sessionScope.errorMessage}">
                <div class="alert alert-danger alert-dismissible">
                    <button type="button" class="close" data-dismiss="alert" aria-hidden="true">×</button>
                    <i class="icon fa fa-ban"></i> ${sessionScope.errorMessage}
                </div>
                <c:remove var="errorMessage" scope="session" />
            </c:if>

            <div class="box">
                <div class="box-header">
                    <h3 class="box-title">Danh sách sản phẩm</h3>
                </div>
                
                <!-- Filters -->
                <div class="box-body">
                    <form method="GET" action="${pageContext.request.contextPath}/admin/products" class="filters">
                        <div class="row">
                            <div class="col-md-3">
                                <input type="text" name="search" class="form-control" placeholder="Tìm kiếm sản phẩm..." value="${searchTerm}">
                            </div>
                            <div class="col-md-3">
                                <select name="category" class="form-control">
                                    <option value="">Tất cả danh mục</option>
                                    <c:forEach var="category" items="${categories}">
                                        <option value="${category[0]}" ${selectedCategory == category[0] ? 'selected' : ''}>${category[1]}</option>
                                    </c:forEach>
                                </select>
                            </div>
                            <div class="col-md-3">
                                <select name="status" class="form-control">
                                    <option value="">Tất cả trạng thái</option>
                                    <option value="active" ${selectedStatus == 'active' ? 'selected' : ''}>Hoạt động</option>
                                    <option value="inactive" ${selectedStatus == 'inactive' ? 'selected' : ''}>Không hoạt động</option>
                                </select>
                            </div>
                            <div class="col-md-3">
                                <button type="submit" class="btn btn-primary">
                                    <i class="fa fa-search"></i> Tìm kiếm
                                </button>
                                <a href="${pageContext.request.contextPath}/admin/products" class="btn btn-default">
                                    <i class="fa fa-refresh"></i> Reset
                                </a>
                            </div>
                        </div>
                    </form>
                    
                    <!-- Results Info -->
                    <div class="clearfix" style="margin-bottom: 15px;">
                        <div style="float: left;">
                            Hiển thị ${products.size()} / ${totalCount} sản phẩm
                        </div>
                    </div>
                    
                    <!-- Products Table -->
                    <c:choose>
                        <c:when test="${empty products}">
                            <div style="text-align: center; padding: 50px; color: #999;">
                                <i class="fa fa-inbox fa-3x"></i>
                                <p>Không có sản phẩm nào được tìm thấy</p>
                            </div>
                        </c:when>
                        <c:otherwise>
                            <table class="table table-striped">
                                <thead>
                                    <tr>
                                        <th>ID</th>
                                        <th>Tên sản phẩm</th>
                                        <th>Danh mục</th>
                                        <th>Giá</th>
                                        <th>Nhà cung cấp</th>
                                        <th>Trạng thái</th>
                                        <th>Ngày tạo</th>
                                        <th style="width: 100px;">Thao tác</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <c:forEach var="product" items="${products}">
                                        <tr>
                                            <td>${product.productID}</td>
                                            <td>
                                                <strong>${product.productName}</strong>
                                                <c:if test="${not empty product.description}">
                                                    <br><small style="color: #666;">${product.description}</small>
                                                </c:if>
                                            </td>
                                            <td>
                                                <c:choose>
                                                    <c:when test="${not empty product.categoryName}">
                                                        ${product.categoryName}
                                                    </c:when>
                                                    <c:otherwise>
                                                        <span style="color: #999;">Không xác định</span>
                                                    </c:otherwise>
                                                </c:choose>
                                            </td>
                                            <td>
                                                <fmt:formatNumber value="${product.price}" type="currency" currencySymbol="₫" />
                                            </td>
                                            <td>
                                                <c:choose>
                                                    <c:when test="${not empty product.supplierName}">
                                                        ${product.supplierName}
                                                    </c:when>
                                                    <c:otherwise>
                                                        <span style="color: #999;">Không xác định</span>
                                                    </c:otherwise>
                                                </c:choose>
                                            </td>
                                            <td>
                                                <c:choose>
                                                    <c:when test="${product.active}">
                                                        <span class="label label-success">Hoạt động</span>
                                                    </c:when>
                                                    <c:otherwise>
                                                        <span class="label label-danger">Không hoạt động</span>
                                                    </c:otherwise>
                                                </c:choose>
                                            </td>
                                            <td>
                                                <fmt:formatDate value="${product.createdAt}" pattern="dd/MM/yyyy HH:mm" />
                                            </td>
                                            <td>
                                                <a href="${pageContext.request.contextPath}/admin/products/view?id=${product.productID}" 
                                                   class="btn btn-info btn-sm" title="Xem chi tiết">
                                                    <i class="fa fa-eye"></i>
                                                </a>
                                            </td>
                                        </tr>
                                    </c:forEach>
                                </tbody>
                            </table>
                        </c:otherwise>
                    </c:choose>
                    
                    <!-- Pagination -->
                    <c:if test="${totalPages > 1}">
                        <div style="text-align: center;">
                            <ul class="pagination">
                                <c:if test="${currentPage > 1}">
                                    <li>
                                        <a href="?page=${currentPage - 1}&search=${searchTerm}&category=${selectedCategory}&status=${selectedStatus}">
                                            <i class="fa fa-angle-left"></i>
                                        </a>
                                    </li>
                                </c:if>
                                
                                <c:forEach begin="1" end="${totalPages}" var="i">
                                    <li class="${currentPage == i ? 'active' : ''}">
                                        <a href="?page=${i}&search=${searchTerm}&category=${selectedCategory}&status=${selectedStatus}">${i}</a>
                                    </li>
                                </c:forEach>
                                
                                <c:if test="${currentPage < totalPages}">
                                    <li>
                                        <a href="?page=${currentPage + 1}&search=${searchTerm}&category=${selectedCategory}&status=${selectedStatus}">
                                            <i class="fa fa-angle-right"></i>
                                        </a>
                                    </li>
                                </c:if>
                            </ul>
                        </div>
                    </c:if>
                </div>
            </div>
        </section>
    </div>
</div>


</body>
</html>