<%-- 
    Document   : user-list
    Created on : Oct 3, 2025
    Author     : DrDYNew
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="utf-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <title>Quản lý người dùng - Coffee Shop</title>
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
        .search-form {
            background: #f4f4f4;
            padding: 15px;
            border-radius: 3px;
            margin-bottom: 20px;
        }
        
        .badge-role {
            font-size: 0.875em;
            padding: 6px 12px;
        }
        
        .badge-hr { background-color: #00a65a; }
        .badge-admin { background-color: #dd4b39; }
        .badge-inventory { background-color: #f39c12; }
        .badge-barista { background-color: #00c0ef; }
        
        .action-buttons .btn {
            margin-right: 3px;
            margin-bottom: 3px;
        }
    </style>
</head>
<body class="hold-transition skin-blue sidebar-mini">
<div class="wrapper">
    <!-- Include Header -->
    <%@include file="../compoment/header.jsp" %>
    
    <!-- Include Sidebar -->
    <%@include file="../compoment/sidebar.jsp" %>
    
    <!-- Content Wrapper. Contains page content -->
    <div class="content-wrapper">
        <!-- Content Header (Page header) -->
        <section class="content-header">
            <h1>
                Quản lý người dùng
                <small>Tạo và quản lý tài khoản người dùng</small>
            </h1>
            <ol class="breadcrumb">
                <li><a href="${pageContext.request.contextPath}/hr/dashboard"><i class="fa fa-dashboard"></i> Dashboard</a></li>
                <li class="active">Quản lý người dùng</li>
            </ol>
        </section>

        <!-- Main content -->
        <section class="content">
            <!-- Success/Error Messages -->
            <c:if test="${not empty sessionScope.successMessage}">
                <div class="alert alert-success alert-dismissible">
                    <button type="button" class="close" data-dismiss="alert" aria-hidden="true">&times;</button>
                    <h4><i class="icon fa fa-check"></i> Thành công!</h4>
                    ${sessionScope.successMessage}
                </div>
                <c:remove var="successMessage" scope="session"/>
            </c:if>

            <c:if test="${not empty sessionScope.errorMessage}">
                <div class="alert alert-danger alert-dismissible">
                    <button type="button" class="close" data-dismiss="alert" aria-hidden="true">&times;</button>
                    <h4><i class="icon fa fa-ban"></i> Lỗi!</h4>
                    ${sessionScope.errorMessage}
                </div>
                <c:remove var="errorMessage" scope="session"/>
            </c:if>

            <!-- Search and Filter Form -->
            <div class="row">
                <div class="col-md-12">
                    <div class="box">
                        <div class="box-header with-border">
                            <h3 class="box-title">Tìm kiếm và lọc</h3>
                            <div class="box-tools pull-right">
                                <a href="${pageContext.request.contextPath}/user?action=create" class="btn btn-primary btn-sm">
                                    <i class="fa fa-plus"></i> Thêm người dùng
                                </a>
                            </div>
                        </div>
                        <div class="box-body">
                            <form method="GET" action="${pageContext.request.contextPath}/user">
                                <div class="row">
                                    <div class="col-md-3">
                                        <div class="form-group">
                                            <label for="search">Tìm kiếm</label>
                                            <input type="text" class="form-control" id="search" name="search" 
                                                   value="${searchKeyword}" placeholder="Tên hoặc email...">
                                        </div>
                                    </div>
                                    <div class="col-md-3">
                                        <div class="form-group">
                                            <label for="roleFilter">Vai trò</label>
                                            <select class="form-control" id="roleFilter" name="roleFilter">
                                                <option value="all">Tất cả vai trò</option>
                                                <c:forEach var="role" items="${availableRoles}">
                                                    <option value="${role.settingID}" 
                                                            ${roleFilter == role.settingID ? 'selected' : ''}>
                                                        ${role.description}
                                                    </option>
                                                </c:forEach>
                                            </select>
                                        </div>
                                    </div>
                                    <div class="col-md-2">
                                        <div class="form-group">
                                            <label for="pageSize">Hiển thị</label>
                                            <select class="form-control" id="pageSize" name="pageSize">
                                                <option value="10" ${pageSize == 10 ? 'selected' : ''}>10 bản ghi</option>
                                                <option value="20" ${pageSize == 20 ? 'selected' : ''}>20 bản ghi</option>
                                                <option value="50" ${pageSize == 50 ? 'selected' : ''}>50 bản ghi</option>
                                            </select>
                                        </div>
                                    </div>
                                    <div class="col-md-2">
                                        <div class="form-group">
                                            <label>&nbsp;</label><br>
                                            <button type="submit" class="btn btn-primary">
                                                <i class="fa fa-search"></i> Tìm kiếm
                                            </button>
                                        </div>
                                    </div>
                                </div>
                            </form>
                        </div>
                    </div>
                </div>
            </div>

            <!-- User Table -->
            <div class="row">
                <div class="col-md-12">
                    <div class="box">
                        <div class="box-header with-border">
                            <h3 class="box-title">Danh sách người dùng (${totalUsers} bản ghi)</h3>
                        </div>
                        
                        <div class="box-body table-responsive no-padding">
                            <table class="table table-hover">
                                <thead>
                                    <tr>
                                        <th>ID</th>
                                        <th>Họ tên</th>
                                        <th>Email</th>
                                        <th>Giới tính</th>
                                        <th>Vai trò</th>
                                        <th>Trạng thái</th>
                                        <th>Ngày tạo</th>
                                        <th>Thao tác</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <c:choose>
                                        <c:when test="${empty users}">
                                            <tr>
                                                <td colspan="8" class="text-center">
                                                    <i class="fa fa-inbox fa-3x text-muted"></i>
                                                    <p class="text-muted">Không tìm thấy người dùng nào</p>
                                                </td>
                                            </tr>
                                        </c:when>
                                        <c:otherwise>
                                            <c:forEach var="user" items="${users}">
                                                <tr>
                                                    <td>${user.userID}</td>
                                                    <td>
                                                        <strong>${user.fullName}</strong>
                                                        <c:if test="${not empty user.phone}">
                                                            <br><small class="text-muted">${user.phone}</small>
                                                        </c:if>
                                                    </td>
                                                    <td>${user.email}</td>
                                                    <td>
                                                        <c:choose>
                                                            <c:when test="${user.gender == 'Nam'}">
                                                                <i class="fa fa-mars text-primary"></i> Nam
                                                            </c:when>
                                                            <c:when test="${user.gender == 'Nữ'}">
                                                                <i class="fa fa-venus text-danger"></i> Nữ
                                                            </c:when>
                                                            <c:otherwise>
                                                                <span class="text-muted">N/A</span>
                                                            </c:otherwise>
                                                        </c:choose>
                                                    </td>
                                                    <td>
                                                        <c:choose>
                                                            <c:when test="${user.roleID == 1}">
                                                                <span class="label label-success">HR</span>
                                                            </c:when>
                                                            <c:when test="${user.roleID == 2}">
                                                                <span class="label label-danger">Admin</span>
                                                            </c:when>
                                                            <c:when test="${user.roleID == 3}">
                                                                <span class="label label-warning">Inventory</span>
                                                            </c:when>
                                                            <c:when test="${user.roleID == 4}">
                                                                <span class="label label-info">Barista</span>
                                                            </c:when>
                                                            <c:otherwise>
                                                                <span class="label label-default">Unknown</span>
                                                            </c:otherwise>
                                                        </c:choose>
                                                    </td>
                                                    <td>
                                                        <c:choose>
                                                            <c:when test="${user.active}">
                                                                <span class="label label-success">Hoạt động</span>
                                                            </c:when>
                                                            <c:otherwise>
                                                                <span class="label label-danger">Ngưng hoạt động</span>
                                                            </c:otherwise>
                                                        </c:choose>
                                                    </td>
                                                    <td>
                                                        <fmt:formatDate value="${user.createdAt}" pattern="dd/MM/yyyy HH:mm"/>
                                                    </td>
                                                    <td>
                                                        <div class="action-buttons">
                                                            <a href="${pageContext.request.contextPath}/user?action=view&id=${user.userID}" 
                                                               class="btn btn-xs btn-info" title="Xem chi tiết">
                                                                <i class="fa fa-eye"></i>
                                                            </a>
                                                            <a href="${pageContext.request.contextPath}/user?action=edit&id=${user.userID}" 
                                                               class="btn btn-xs btn-primary" title="Chỉnh sửa">
                                                                <i class="fa fa-edit"></i>
                                                            </a>
                                                            <a href="${pageContext.request.contextPath}/user?action=changePassword&id=${user.userID}" 
                                                               class="btn btn-xs btn-warning" title="Đổi mật khẩu">
                                                                <i class="fa fa-key"></i>
                                                            </a>
                                                            
                                                        </div>
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

            <!-- Pagination -->
            <c:if test="${totalPages > 1}">
                <div class="row">
                    <div class="col-md-12">
                        <div class="box-footer clearfix">
                            <div class="pull-left">
                                Hiển thị ${(currentPage - 1) * pageSize + 1} - 
                                ${currentPage * pageSize > totalUsers ? totalUsers : currentPage * pageSize} 
                                của ${totalUsers} 
                            </div>
                            
                            <ul class="pagination pagination-sm no-margin pull-right">
                                <c:if test="${currentPage > 1}">
                                    <li>
                                        <a href="?page=${currentPage - 1}&pageSize=${pageSize}&roleFilter=${roleFilter}&search=${searchKeyword}">
                                            &laquo;
                                        </a>
                                    </li>
                                </c:if>
                                
                                <c:forEach begin="1" end="${totalPages}" var="i">
                                    <c:if test="${i == currentPage || Math.abs(i - currentPage) <= 2}">
                                        <li class="${i == currentPage ? 'active' : ''}">
                                            <a href="?page=${i}&pageSize=${pageSize}&roleFilter=${roleFilter}&search=${searchKeyword}">
                                                ${i}
                                            </a>
                                        </li>
                                    </c:if>
                                </c:forEach>
                                
                                <c:if test="${currentPage < totalPages}">
                                    <li>
                                        <a href="?page=${currentPage + 1}&pageSize=${pageSize}&roleFilter=${roleFilter}&search=${searchKeyword}">
                                            &raquo;
                                        </a>
                                    </li>
                                </c:if>
                            </ul>
                        </div>
                    </div>
                </div>
            </c:if>
        </section>
        <!-- /.content -->
    </div>
    <!-- /.content-wrapper -->

    <!-- Delete Confirmation Modal -->
    

</div>
<!-- ./wrapper -->

<!-- jQuery 2.2.3 -->
<script src="${pageContext.request.contextPath}/plugins/jQuery/jquery-2.2.3.min.js"></script>
<!-- Bootstrap 3.3.6 -->
<script src="${pageContext.request.contextPath}/bootstrap/js/bootstrap.min.js"></script>
<!-- AdminLTE App -->
<script src="${pageContext.request.contextPath}/dist/js/app.min.js"></script>

<script>
    function confirmDelete(userId, userName) {
        document.getElementById('deleteUserId').value = userId;
        document.getElementById('deleteUserName').textContent = userName;
        $('#deleteModal').modal('show');
    }
    
    // Auto-hide alerts after 5 seconds
    setTimeout(function() {
        $('.alert').fadeOut();
    }, 5000);
</script>
</body>
</html>