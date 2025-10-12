<%@page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="utf-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <title>Danh sách báo cáo sự cố - Coffee Shop Management</title>
    <meta content="width=device-width, initial-scale=1, maximum-scale=1, user-scalable=no" name="viewport">
    <!-- Bootstrap 3.3.6 -->
    <link rel="stylesheet" href="${pageContext.request.contextPath}/bootstrap/css/bootstrap.min.css">
    <!-- Font Awesome -->
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/4.5.0/css/font-awesome.min.css">
    <!-- AdminLTE -->
    <link rel="stylesheet" href="https://adminlte.io/themes/AdminLTE/dist/css/AdminLTE.min.css">
    <link rel="stylesheet" href="https://adminlte.io/themes/AdminLTE/dist/css/skins/_all-skins.min.css">
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
                Danh sách báo cáo sự cố
                <small>Quản lý sự cố nguyên liệu</small>
            </h1>
            <ol class="breadcrumb">
                <li><a href="${pageContext.request.contextPath}/barista/dashboard"><i class="fa fa-dashboard"></i> Trang chủ</a></li>
                <li class="active">Báo cáo sự cố</li>
            </ol>
        </section>

        <!-- Main content -->
        <section class="content">
            <div class="row">
                <div class="col-xs-12">
                    <div class="box">
                        <div class="box-header">
                            <h3 class="box-title">Tất cả báo cáo sự cố</h3>
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
                                    <form method="get" action="${pageContext.request.contextPath}/barista/issues">
                                        <div class="form-group">
                                            <label>Lọc theo trạng thái:</label>
                                            <select class="form-control" name="status" onchange="this.form.submit()">
                                                <option value="">Tất cả</option>
                                                <c:forEach var="status" items="${issueStatuses}">
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
                            
                            <!-- Issues Table -->
                            <div class="table-responsive">
                                <table class="table table-bordered table-striped">
                                    <thead>
                                        <tr>
                                            <th>ID</th>
                                            <th>Nguyên liệu</th>
                                            <th>Mô tả</th>
                                            <th>Số lượng</th>
                                            <th>Trạng thái</th>
                                            <th>Người tạo</th>
                                            <th>Người xác nhận</th>
                                            <th>Ngày tạo</th>
                                            <th>Thao tác</th>
                                        </tr>
                                    </thead>
                                    <tbody>
                                        <c:forEach var="issue" items="${issues}">
                                            <tr>
                                                <td>${issue.issueID}</td>
                                                <td><strong>${issue.ingredientName}</strong></td>
                                                <td>${issue.description}</td>
                                                <td>${issue.quantity} ${issue.unitName}</td>
                                                <td>
                                                    <span class="label label-${issue.statusName == 'Reported' ? 'warning' : 
                                                                                 issue.statusName == 'Under Investigation' ? 'info' :
                                                                                 issue.statusName == 'Resolved' ? 'success' : 'danger'}">
                                                        ${issue.statusName}
                                                    </span>
                                                </td>
                                                <td>${issue.createdByName}</td>
                                                <td>${issue.confirmedByName != null ? issue.confirmedByName : '<i>Chưa xác nhận</i>'}</td>
                                                <td><fmt:formatDate value="${issue.createdAt}" pattern="dd/MM/yyyy HH:mm"/></td>
                                                <td>
                                                    <a href="${pageContext.request.contextPath}/barista/issue-details?id=${issue.issueID}" 
                                                       class="btn btn-info btn-xs">
                                                        <i class="fa fa-eye"></i> Xem
                                                    </a>
                                                </td>
                                            </tr>
                                        </c:forEach>
                                        <c:if test="${empty issues}">
                                            <tr>
                                                <td colspan="9" class="text-center">
                                                    <em>Không có báo cáo sự cố nào</em>
                                                </td>
                                            </tr>
                                        </c:if>
                                    </tbody>
                                </table>
                            </div>
                            
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

<!-- jQuery -->
<script src="${pageContext.request.contextPath}/bootstrap/js/jquery.min.js"></script>
<!-- Bootstrap -->
<script src="${pageContext.request.contextPath}/bootstrap/js/bootstrap.min.js"></script>
<!-- AdminLTE App -->
<script src="https://adminlte.io/themes/AdminLTE/dist/js/app.min.js"></script>

</body>
</html>
