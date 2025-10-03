<%@page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="utf-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <title>${action eq 'create' ? 'Thêm' : 'Chỉnh sửa'} cài đặt hệ thống - Coffee Shop Management</title>
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
        .required {
            color: #dd4b39;
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
                ${action eq 'create' ? 'Thêm cài đặt mới' : 'Chỉnh sửa cài đặt'}
                <small>Quản lý cài đặt hệ thống</small>
            </h1>
            <ol class="breadcrumb">
                <li><a href="${pageContext.request.contextPath}/admin/dashboard"><i class="fa fa-dashboard"></i> Trang chủ</a></li>
                <li><a href="${pageContext.request.contextPath}/admin/setting">Cài đặt hệ thống</a></li>
                <li class="active">${action eq 'create' ? 'Thêm mới' : 'Chỉnh sửa'}</li>
            </ol>
        </section>

        <!-- Main content -->
        <section class="content">
            <div class="row">
                <div class="col-md-12">
                    <div class="box box-primary">
                        <div class="box-header with-border">
                            <h3 class="box-title">
                                <i class="fa fa-${action eq 'create' ? 'plus' : 'edit'}"></i>
                                ${action eq 'create' ? 'Thêm cài đặt mới' : 'Chỉnh sửa cài đặt'}
                            </h3>
                        </div>
                        
                        <form method="post" action="${pageContext.request.contextPath}/admin/setting?action=${action eq 'create' ? 'create' : 'update'}">
                            <div class="box-body">
                                <!-- Error Message -->
                                <c:if test="${not empty error}">
                                    <div class="alert alert-danger alert-dismissible">
                                        <button type="button" class="close" data-dismiss="alert" aria-hidden="true">&times;</button>
                                        <h4><i class="icon fa fa-ban"></i> Lỗi!</h4>
                                        ${error}
                                    </div>
                                </c:if>
                                
                                <!-- Hidden ID field for update -->
                                <c:if test="${action eq 'edit'}">
                                    <input type="hidden" name="settingId" value="${setting.settingID}">
                                </c:if>
                                
                                <div class="row">
                                    <div class="col-md-6">
                                        <!-- Setting Type -->
                                        <div class="form-group">
                                            <label for="type">
                                                Loại cài đặt <span class="required">*</span>
                                            </label>
                                            <select class="form-control" id="type" name="type" required>
                                                <option value="">Chọn loại cài đặt</option>
                                                <option value="Role" ${setting.type == 'Role' ? 'selected' : ''}>Vai trò (Role)</option>
                                                <option value="Category" ${setting.type == 'Category' ? 'selected' : ''}>Danh mục (Category)</option>
                                                <option value="Unit" ${setting.type == 'Unit' ? 'selected' : ''}>Đơn vị (Unit)</option>
                                                <option value="System" ${setting.type == 'System' ? 'selected' : ''}>Hệ thống (System)</option>
                                            </select>
                                        </div>
                                        
                                        <!-- Setting Value -->
                                        <div class="form-group">
                                            <label for="value">
                                                Giá trị <span class="required">*</span>
                                            </label>
                                            <input type="text" class="form-control" id="value" name="value" 
                                                   value="${setting.value}" required maxlength="100"
                                                   placeholder="Nhập giá trị cài đặt...">
                                        </div>
                                    </div>
                                    
                                    <div class="col-md-6">
                                        <!-- Description -->
                                        <div class="form-group">
                                            <label for="description">
                                                Mô tả <span class="required">*</span>
                                            </label>
                                            <textarea class="form-control" id="description" name="description" 
                                                      rows="4" required maxlength="500"
                                                      placeholder="Nhập mô tả cho cài đặt...">${setting.description}</textarea>
                                        </div>
                                        
                                        <!-- Status -->
                                        <div class="form-group">
                                            <label>Trạng thái</label>
                                            <div class="checkbox">
                                                <label>
                                                    <input type="checkbox" name="isActive" value="true" 
                                                           ${setting.active || action eq 'create' ? 'checked' : ''}>
                                                    Hoạt động
                                                </label>
                                            </div>
                                            <small class="text-muted">Chỉ các cài đặt được kích hoạt mới có hiệu lực</small>
                                        </div>
                                    </div>
                                </div>
                            </div>
                            
                            <div class="box-footer">
                                <button type="submit" class="btn btn-primary">
                                    <i class="fa fa-save"></i> 
                                    ${action eq 'create' ? 'Thêm cài đặt' : 'Cập nhật'}
                                </button>
                                <a href="${pageContext.request.contextPath}/admin/setting" class="btn btn-default">
                                    <i class="fa fa-times"></i> Hủy
                                </a>
                            </div>
                        </form>
                    </div>
                </div>
            </div>
        </section>
    </div>
    
    <!-- Include Footer -->
    <%@include file="../compoment/footer.jsp" %>

</div>

<!-- jQuery -->
<script src="${pageContext.request.contextPath}/plugins/jQuery/jquery-2.2.3.min.js"></script>
<!-- Bootstrap -->
<script src="${pageContext.request.contextPath}/bootstrap/js/bootstrap.min.js"></script>
<!-- AdminLTE App -->
<script src="${pageContext.request.contextPath}/dist/js/app.min.js"></script>

<script>
    // No additional JavaScript needed for simplified form
</script>

</body>
</html>