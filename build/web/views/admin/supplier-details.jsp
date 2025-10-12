<%@page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="utf-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <title>Chi tiết nhà cung cấp - Coffee Shop Management</title>
    <meta content="width=device-width, initial-scale=1, maximum-scale=1, user-scalable=no" name="viewport">
    <!-- Bootstrap 3.3.6 từ CDN -->
    <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/css/bootstrap.min.css" integrity="sha384-BVYiiSIFeK1dGmJRAkycuHAHRg32OmUcww7on3RYdg4Va+PmSTsz/K68vbdEjh4u" crossorigin="anonymous">
    <!-- Font Awesome -->
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/4.5.0/css/font-awesome.min.css">
    <!-- Ionicons -->
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/ionicons/2.0.1/css/ionicons.min.css">
    <!-- Theme style -->
    <link rel="stylesheet" href="${pageContext.request.contextPath}/dist/css/AdminLTE.min.css">
    <!-- AdminLTE Skins -->
    <link rel="stylesheet" href="${pageContext.request.contextPath}/dist/css/skins/_all-skins.min.css">
    <!-- Sidebar improvements -->
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/sidebar-improvements.css">
    <!-- jQuery từ CDN - load trước tiên -->
    <script src="https://code.jquery.com/jquery-2.2.4.min.js" integrity="sha256-BbhdlvQf/xTY9gja0Dq3HiwQF8LaCRTXxZKRutelT44=" crossorigin="anonymous"></script>
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
                    Chi tiết nhà cung cấp
                    <small>${supplier.supplierName}</small>
                </h1>
                <ol class="breadcrumb">
                    <li><a href="${pageContext.request.contextPath}/admin/dashboard"><i class="fa fa-dashboard"></i> Dashboard</a></li>
                    <li><a href="${pageContext.request.contextPath}/admin/supplier/list">Nhà cung cấp</a></li>
                    <li class="active">Chi tiết</li>
                </ol>
            </section>

            <!-- Main content -->
            <section class="content">
                <!-- Display messages -->
                <c:if test="${not empty sessionScope.message}">
                    <div class="alert alert-${sessionScope.messageType}">
                        ${sessionScope.message}
                        <c:remove var="message" scope="session"/>
                        <c:remove var="messageType" scope="session"/>
                    </div>
                </c:if>

                <div class="row">
                    <!-- Supplier Information -->
                    <div class="col-md-6">
                        <div class="box box-primary">
                            <div class="box-header with-border">
                                <h3 class="box-title">Thông tin nhà cung cấp</h3>
                                <div class="box-tools">
                                    <a href="${pageContext.request.contextPath}/admin/supplier/edit?id=${supplier.supplierID}" 
                                       class="btn btn-warning btn-sm">
                                        <i class="fa fa-edit"></i> Chỉnh sửa
                                    </a>
                                    <a href="${pageContext.request.contextPath}/admin/supplier/list" 
                                       class="btn btn-default btn-sm">
                                        <i class="fa fa-arrow-left"></i> Quay lại
                                    </a>
                                </div>
                            </div>
                            
                            <div class="box-body">
                                <dl>
                                    <dt><i class="fa fa-tag"></i> Mã nhà cung cấp:</dt>
                                    <dd>${supplier.supplierID}</dd>
                                    
                                    <dt><i class="fa fa-building"></i> Tên nhà cung cấp:</dt>
                                    <dd><strong>${supplier.supplierName}</strong></dd>
                                    
                                    <dt><i class="fa fa-user"></i> Người liên hệ:</dt>
                                    <dd>${not empty supplier.contactName ? supplier.contactName : '<em>Chưa cập nhật</em>'}</dd>
                                    
                                    <dt><i class="fa fa-envelope"></i> Email:</dt>
                                    <dd>
                                        <c:choose>
                                            <c:when test="${not empty supplier.email}">
                                                <a href="mailto:${supplier.email}">${supplier.email}</a>
                                            </c:when>
                                            <c:otherwise>
                                                <em>Chưa cập nhật</em>
                                            </c:otherwise>
                                        </c:choose>
                                    </dd>
                                    
                                    <dt><i class="fa fa-phone"></i> Số điện thoại:</dt>
                                    <dd>
                                        <c:choose>
                                            <c:when test="${not empty supplier.phone}">
                                                <a href="tel:${supplier.phone}">${supplier.phone}</a>
                                            </c:when>
                                            <c:otherwise>
                                                <em>Chưa cập nhật</em>
                                            </c:otherwise>
                                        </c:choose>
                                    </dd>
                                    
                                    <dt><i class="fa fa-map-marker"></i> Địa chỉ:</dt>
                                    <dd>${not empty supplier.address ? supplier.address : '<em>Chưa cập nhật</em>'}</dd>
                                    
                                    <dt><i class="fa fa-toggle-on"></i> Trạng thái:</dt>
                                    <dd>
                                        <c:choose>
                                            <c:when test="${supplier.active}">
                                                <span class="label label-success">Hoạt động</span>
                                            </c:when>
                                            <c:otherwise>
                                                <span class="label label-danger">Không hoạt động</span>
                                            </c:otherwise>
                                        </c:choose>
                                    </dd>
                                    
                                    <dt><i class="fa fa-calendar"></i> Ngày tạo:</dt>
                                    <dd><fmt:formatDate value="${supplier.createdAt}" pattern="dd/MM/yyyy HH:mm:ss" /></dd>
                                </dl>
                            </div>
                        </div>
                    </div>

                    <!-- Statistics -->
                    <div class="col-md-6">
                        <div class="info-box">
                            <span class="info-box-icon bg-aqua"><i class="fa fa-shopping-cart"></i></span>
                            <div class="info-box-content">
                                <span class="info-box-text">Tổng sản phẩm</span>
                                <span class="info-box-number">${not empty products ? products.size() : 0}</span>
                            </div>
                        </div>

                        <div class="info-box">
                            <span class="info-box-icon bg-green"><i class="fa fa-leaf"></i></span>
                            <div class="info-box-content">
                                <span class="info-box-text">Tổng nguyên liệu</span>
                                <span class="info-box-number">${not empty ingredients ? ingredients.size() : 0}</span>
                            </div>
                        </div>
                    </div>
                </div>

                <!-- Products from this supplier -->
                <div class="row">
                    <div class="col-md-6">
                        <div class="box box-info">
                            <div class="box-header with-border">
                                <h3 class="box-title">Sản phẩm cung cấp</h3>
                            </div>
                            <div class="box-body">
                                <c:choose>
                                    <c:when test="${empty products}">
                                        <p><em>Chưa có sản phẩm nào từ nhà cung cấp này.</em></p>
                                    </c:when>
                                    <c:otherwise>
                                        <div class="table-responsive">
                                            <table class="table table-striped">
                                                <thead>
                                                    <tr>
                                                        <th>Tên sản phẩm</th>
                                                        <th>Danh mục</th>
                                                        <th>Giá</th>
                                                        <th>Trạng thái</th>
                                                    </tr>
                                                </thead>
                                                <tbody>
                                                    <c:forEach var="product" items="${products}">
                                                        <tr>
                                                            <td>${product.productName}</td>
                                                            <td>${product.categoryName}</td>
                                                            <td><fmt:formatNumber value="${product.price}" pattern="#,###" /> đ</td>
                                                            <td>
                                                                <c:choose>
                                                                    <c:when test="${product.active}">
                                                                        <span class="label label-success">Hoạt động</span>
                                                                    </c:when>
                                                                    <c:otherwise>
                                                                        <span class="label label-danger">Ngừng</span>
                                                                    </c:otherwise>
                                                                </c:choose>
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

                    <!-- Ingredients from this supplier -->
                    <div class="col-md-6">
                        <div class="box box-warning">
                            <div class="box-header with-border">
                                <h3 class="box-title">Nguyên liệu cung cấp</h3>
                            </div>
                            <div class="box-body">
                                <c:choose>
                                    <c:when test="${empty ingredients}">
                                        <p><em>Chưa có nguyên liệu nào từ nhà cung cấp này.</em></p>
                                    </c:when>
                                    <c:otherwise>
                                        <div class="table-responsive">
                                            <table class="table table-striped">
                                                <thead>
                                                    <tr>
                                                        <th>Tên nguyên liệu</th>
                                                        <th>Số lượng</th>
                                                        <th>Đơn vị</th>
                                                        <th>Trạng thái</th>
                                                    </tr>
                                                </thead>
                                                <tbody>
                                                    <c:forEach var="ingredient" items="${ingredients}">
                                                        <tr>
                                                            <td>${ingredient.name}</td>
                                                            <td><fmt:formatNumber value="${ingredient.stockQuantity}" pattern="#,##0.00" /></td>
                                                            <td>${ingredient.unitName}</td>
                                                            <td>
                                                                <c:choose>
                                                                    <c:when test="${ingredient.active}">
                                                                        <span class="label label-success">Hoạt động</span>
                                                                    </c:when>
                                                                    <c:otherwise>
                                                                        <span class="label label-danger">Ngừng</span>
                                                                    </c:otherwise>
                                                                </c:choose>
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
            </section>
        </div>
    </div>

    <!-- Bootstrap 3.3.7 từ CDN -->
    <script src="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/js/bootstrap.min.js" integrity="sha384-Tc5IQib027qvyjSMfHjOMaLkfuWVxZxUPnCJA7l2mCWNIpG9mGCD8wGNIcPD7Txa" crossorigin="anonymous"></script>
    <!-- AdminLTE App -->
    <script src="${pageContext.request.contextPath}/dist/js/app.min.js"></script>
    <!-- Sidebar script -->
    <jsp:include page="../compoment/sidebar-scripts.jsp" />
</body>
</html>
