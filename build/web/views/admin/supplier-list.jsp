<%@page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="utf-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <title>Quản lý nhà cung cấp - Coffee Shop Management</title>
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
                    Quản lý nhà cung cấp
                    <small>Danh sách nhà cung cấp</small>
                </h1>
                <ol class="breadcrumb">
                    <li><a href="${pageContext.request.contextPath}/admin/dashboard"><i class="fa fa-dashboard"></i> Dashboard</a></li>
                    <li class="active">Nhà cung cấp</li>
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
                
                <c:if test="${not empty error}">
                    <div class="alert alert-danger">
                        ${error}
                    </div>
                </c:if>

                <div class="row">
                    <div class="col-xs-12">
                        <div class="box box-primary">
                            <div class="box-header with-border">
                                <h3 class="box-title">Danh sách nhà cung cấp (${totalSuppliers})</h3>
                                <div class="box-tools">
                                    <a href="${pageContext.request.contextPath}/admin/supplier/new" class="btn btn-success btn-sm">
                                        <i class="fa fa-plus"></i> Thêm nhà cung cấp
                                    </a>
                                </div>
                            </div>
                            
                            <div class="box-body">
                                <!-- Search Form -->
                                <form method="get" action="${pageContext.request.contextPath}/admin/supplier/list" class="form-inline" style="margin-bottom: 15px;">
                                    <div class="form-group">
                                        <input type="text" name="search" class="form-control" 
                                               placeholder="Tìm kiếm theo tên, email, phone..." 
                                               value="${searchKeyword}" style="width: 300px;">
                                    </div>
                                    <button type="submit" class="btn btn-primary">
                                        <i class="fa fa-search"></i> Tìm kiếm
                                    </button>
                                    <c:if test="${not empty searchKeyword}">
                                        <a href="${pageContext.request.contextPath}/admin/supplier/list" class="btn btn-default">
                                            <i class="fa fa-refresh"></i> Xóa lọc
                                        </a>
                                    </c:if>
                                </form>

                                <!-- Supplier Table -->
                                <div class="table-responsive">
                                    <table class="table table-striped table-hover">
                                        <thead>
                                            <tr>
                                                <th>ID</th>
                                                <th>Tên nhà cung cấp</th>
                                                <th>Người liên hệ</th>
                                                <th>Email</th>
                                                <th>Số điện thoại</th>
                                                <th>Địa chỉ</th>
                                                <th>Trạng thái</th>
                                                <th>Hành động</th>
                                            </tr>
                                        </thead>
                                        <tbody>
                                            <c:choose>
                                                <c:when test="${empty suppliers}">
                                                    <tr>
                                                        <td colspan="8" style="text-align: center;">
                                                            <em>Không tìm thấy nhà cung cấp nào.</em>
                                                        </td>
                                                    </tr>
                                                </c:when>
                                                <c:otherwise>
                                                    <c:forEach var="supplier" items="${suppliers}">
                                                        <tr>
                                                            <td>${supplier.supplierID}</td>
                                                            <td>
                                                                <strong>${supplier.supplierName}</strong>
                                                            </td>
                                                            <td>${supplier.contactName}</td>
                                                            <td>${supplier.email}</td>
                                                            <td>${supplier.phone}</td>
                                                            <td>
                                                                <c:choose>
                                                                    <c:when test="${not empty supplier.address}">
                                                                        ${supplier.address.length() > 50 ? supplier.address.substring(0, 50).concat('...') : supplier.address}
                                                                    </c:when>
                                                                    <c:otherwise>
                                                                        <em>Chưa cập nhật</em>
                                                                    </c:otherwise>
                                                                </c:choose>
                                                            </td>
                                                            <td>
                                                                <c:choose>
                                                                    <c:when test="${supplier.active}">
                                                                        <span class="label label-success">Hoạt động</span>
                                                                    </c:when>
                                                                    <c:otherwise>
                                                                        <span class="label label-danger">Không hoạt động</span>
                                                                    </c:otherwise>
                                                                </c:choose>
                                                            </td>
                                                            <td>
                                                                <a href="${pageContext.request.contextPath}/admin/supplier/details?id=${supplier.supplierID}" 
                                                                   class="btn btn-info btn-sm" title="Xem chi tiết">
                                                                    <i class="fa fa-eye"></i>
                                                                </a>
                                                                <a href="${pageContext.request.contextPath}/admin/supplier/edit?id=${supplier.supplierID}" 
                                                                   class="btn btn-warning btn-sm" title="Chỉnh sửa">
                                                                    <i class="fa fa-edit"></i>
                                                                </a>
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
