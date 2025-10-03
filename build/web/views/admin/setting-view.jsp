<%@page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="utf-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <title>Chi tiết cài đặt hệ thống - Coffee Shop Management</title>
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
                Chi tiết cài đặt hệ thống
                <small>Thông tin cài đặt</small>
            </h1>
            <ol class="breadcrumb">
                <li><a href="${pageContext.request.contextPath}/admin/dashboard"><i class="fa fa-dashboard"></i> Trang chủ</a></li>
                <li><a href="${pageContext.request.contextPath}/admin/setting">Cài đặt hệ thống</a></li>
                <li class="active">Chi tiết</li>
            </ol>
        </section>

        <!-- Main content -->
        <section class="content">
            <div class="row">
                <div class="col-md-12">
                    <div class="box box-primary">
                        <div class="box-header with-border">
                            <h3 class="box-title">
                                <i class="fa fa-info-circle"></i>
                                Thông tin cài đặt: ${setting.value}
                            </h3>
                            <div class="box-tools pull-right">
                                <a href="${pageContext.request.contextPath}/admin/setting?action=edit&id=${setting.settingID}" 
                                   class="btn btn-warning btn-sm">
                                    <i class="fa fa-edit"></i> Chỉnh sửa
                                </a>
                                <a href="${pageContext.request.contextPath}/admin/setting" 
                                   class="btn btn-default btn-sm">
                                    <i class="fa fa-arrow-left"></i> Quay lại
                                </a>
                            </div>
                        </div>
                        
                        <div class="box-body">
                            <div class="row">
                                <div class="col-md-6">
                                    <table class="table table-bordered">
                                        <tr>
                                            <th width="30%">ID:</th>
                                            <td>${setting.settingID}</td>
                                        </tr>
                                        <tr>
                                            <th>Loại cài đặt:</th>
                                            <td><strong>${setting.type}</strong></td>
                                        </tr>
                                        <tr>
                                            <th>Giá trị:</th>
                                            <td><code>${setting.value}</code></td>
                                        </tr>
                                        <tr>
                                            <th>Trạng thái:</th>
                                            <td>
                                                <span class="label ${setting.active ? 'label-success' : 'label-danger'}">
                                                    <i class="fa fa-${setting.active ? 'check' : 'times'}"></i>
                                                    ${setting.active ? 'Hoạt động' : 'Không hoạt động'}
                                                </span>
                                            </td>
                                        </tr>
                                    </table>
                                </div>
                                
                                <div class="col-md-6">
                                    <div class="form-group">
                                        <label>Mô tả:</label>
                                        <div class="well well-sm">
                                            ${setting.description}
                                        </div>
                                    </div>
                                    
                                    <div class="alert alert-info">
                                        <h4><i class="icon fa fa-info"></i> Thông tin bổ sung:</h4>
                                        <ul class="list-unstyled">
                                            <li><strong>Loại cài đặt:</strong> ${setting.type}</li>
                                            <li><strong>Trạng thái:</strong> 
                                                ${setting.active ? 'Cài đặt này đang được sử dụng' : 'Cài đặt này đã bị vô hiệu hóa'}
                                            </li>
                                            <li><strong>Ghi chú:</strong> Đây là cài đặt hệ thống được sử dụng để phân loại dữ liệu</li>
                                        </ul>
                                    </div>
                                </div>
                            </div>
                        </div>
                        
                        <div class="box-footer">
                            <div class="btn-group">
                                <a href="${pageContext.request.contextPath}/admin/setting?action=edit&id=${setting.settingID}" 
                                   class="btn btn-warning">
                                    <i class="fa fa-edit"></i> Chỉnh sửa
                                </a>
                                <button type="button" class="btn btn-danger" 
                                        onclick="confirmDelete(${setting.settingID}, '${setting.value}')">
                                    <i class="fa fa-trash"></i> Xóa
                                </button>
                            </div>
                            <a href="${pageContext.request.contextPath}/admin/setting" 
                               class="btn btn-default pull-right">
                                <i class="fa fa-arrow-left"></i> Quay lại danh sách
                            </a>
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
<script src="${pageContext.request.contextPath}/plugins/jQuery/jquery-2.2.3.min.js"></script>
<!-- Bootstrap -->
<script src="${pageContext.request.contextPath}/bootstrap/js/bootstrap.min.js"></script>
<!-- AdminLTE App -->
<script src="${pageContext.request.contextPath}/dist/js/app.min.js"></script>

<script>
    function confirmDelete(settingId, settingName) {
        if (confirm('Bạn có chắc chắn muốn xóa cài đặt "' + settingName + '"?\nHành động này không thể hoàn tác.')) {
            window.location.href = '${pageContext.request.contextPath}/admin/setting?action=delete&id=' + settingId;
        }
    }
</script>

</body>
</html>