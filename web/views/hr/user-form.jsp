<%-- 
    Document   : user-form
    Created on : Oct 3, 2025
    Author     : DrDYNew
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="utf-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <title>${action == 'create' ? 'Thêm người dùng' : 'Chỉnh sửa người dùng'} - Coffee Shop</title>
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
        .form-section-title {
            color: #3c8dbc;
            border-bottom: 2px solid #3c8dbc;
            padding-bottom: 5px;
            margin-bottom: 15px;
        }
        
        .input-group-addon {
            min-width: 45px;
            text-align: center;
        }
        
        .box-footer {
            background-color: #f4f4f4;
            border-top: 1px solid #ddd;
            padding: 15px 20px;
        }
        
        .btn-lg {
            padding: 10px 20px;
            font-size: 16px;
        }
        
        .control-label {
            font-weight: normal;
        }
        
        .form-group label {
            font-weight: 600;
            color: #555;
        }
        
        .text-red {
            color: #dd4b39 !important;
        }
        
        .callout {
            border-radius: 3px;
            margin: 20px 0;
            padding: 15px 30px 15px 15px;
            border-left: 5px solid #eee;
        }
        
        .callout-warning {
            border-left-color: #f39c12;
            background-color: #fcf8e3;
        }
        
        .box-title {
            font-size: 16px;
            font-weight: 600;
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
                <c:choose>
                    <c:when test="${action == 'create'}">Thêm người dùng mới</c:when>
                    <c:otherwise>Chỉnh sửa người dùng</c:otherwise>
                </c:choose>
                <small>Quản lý thông tin người dùng</small>
            </h1>
            <ol class="breadcrumb">
                <li><a href="${pageContext.request.contextPath}/hr/dashboard"><i class="fa fa-dashboard"></i> Dashboard</a></li>
                <li><a href="${pageContext.request.contextPath}/user">Quản lý người dùng</a></li>
                <li class="active">
                    <c:choose>
                        <c:when test="${action == 'create'}">Thêm mới</c:when>
                        <c:otherwise>Chỉnh sửa</c:otherwise>
                    </c:choose>
                </li>
            </ol>
        </section>

        <!-- Main content -->
        <section class="content">
            <!-- Error Message -->
            <c:if test="${not empty error}">
                <div class="alert alert-danger alert-dismissible">
                    <button type="button" class="close" data-dismiss="alert" aria-hidden="true">&times;</button>
                    <h4><i class="icon fa fa-ban"></i> Lỗi!</h4>
                    ${error}
                </div>
            </c:if>

            <div class="row">
                <div class="col-md-12">
                    <div class="box box-primary">
                        <div class="box-header with-border">
                            <h3 class="box-title">
                                <i class="fa fa-user"></i>
                                <c:choose>
                                    <c:when test="${action == 'create'}">Thông tin người dùng mới</c:when>
                                    <c:otherwise>Chỉnh sửa thông tin người dùng</c:otherwise>
                                </c:choose>
                            </h3>
                            <div class="box-tools pull-right">
                                <a href="${pageContext.request.contextPath}/user" class="btn btn-default btn-sm">
                                    <i class="fa fa-arrow-left"></i> Quay lại
                                </a>
                            </div>
                        </div>

                        <form method="POST" action="${pageContext.request.contextPath}/user" id="userForm">
                            <div class="box-body">
                                <input type="hidden" name="action" value="${action == 'create' ? 'create' : 'update'}">
                                <c:if test="${action == 'edit'}">
                                    <input type="hidden" name="userId" value="${user.userID}">
                                </c:if>

                                <!-- Basic Information Section -->
                                <div class="row">
                                    <div class="col-md-12">
                                        <h4 class="box-title"><i class="fa fa-info-circle"></i> Thông tin cơ bản</h4>
                                        <hr>
                                    </div>
                                </div>
                                <div class="row">
                                    <div class="col-md-6">
                                        <div class="form-group">
                                            <label for="fullName">Họ và tên <span class="text-red">*</span></label>
                                            <div class="input-group">
                                                <span class="input-group-addon"><i class="fa fa-user"></i></span>
                                                <input type="text" class="form-control" id="fullName" name="fullName" 
                                                       value="${user != null ? user.fullName : ''}" required maxlength="100"
                                                       placeholder="Nhập họ và tên đầy đủ">
                                            </div>
                                        </div>
                                    </div>
                                    <div class="col-md-6">
                                        <div class="form-group">
                                            <label for="email">Email <span class="text-red">*</span></label>
                                            <div class="input-group">
                                                <span class="input-group-addon"><i class="fa fa-envelope"></i></span>
                                                <input type="email" class="form-control" id="email" name="email" 
                                                       value="${user != null ? user.email : ''}" required maxlength="100"
                                                       placeholder="Nhập địa chỉ email">
                                            </div>
                                        </div>
                                    </div>
                                </div>

                                <!-- Password Section (only for create) -->
                                <c:if test="${action == 'create'}">
                                    <div class="row">
                                        <div class="col-md-12">
                                            <h4 class="box-title"><i class="fa fa-lock"></i> Mật khẩu</h4>
                                            <hr>
                                        </div>
                                    </div>
                                    <div class="row">
                                        <div class="col-md-6">
                                            <div class="form-group">
                                                <label for="password">Mật khẩu <span class="text-red">*</span></label>
                                                <div class="input-group">
                                                    <span class="input-group-addon"><i class="fa fa-key"></i></span>
                                                    <input type="password" class="form-control" id="password" name="password" 
                                                           required minlength="6" maxlength="50" placeholder="Nhập mật khẩu">
                                                </div>
                                                <small class="text-muted">Mật khẩu phải có ít nhất 6 ký tự, bao gồm chữ cái và số</small>
                                            </div>
                                        </div>
                                        <div class="col-md-6">
                                            <div class="form-group">
                                                <label for="confirmPassword">Xác nhận mật khẩu <span class="text-red">*</span></label>
                                                <div class="input-group">
                                                    <span class="input-group-addon"><i class="fa fa-key"></i></span>
                                                    <input type="password" class="form-control" id="confirmPassword" name="confirmPassword" 
                                                           required minlength="6" maxlength="50" placeholder="Nhập lại mật khẩu">
                                                </div>
                                                <div id="passwordMatch" class="text-sm"></div>
                                            </div>
                                        </div>
                                    </div>
                                </c:if>

                                <!-- Contact Information Section -->
                                <div class="row">
                                    <div class="col-md-12">
                                        <h4 class="box-title"><i class="fa fa-phone"></i> Thông tin liên hệ</h4>
                                        <hr>
                                    </div>
                                </div>
                                <div class="row">
                                    <div class="col-md-6">
                                        <div class="form-group">
                                            <label for="phone">Số điện thoại</label>
                                            <div class="input-group">
                                                <span class="input-group-addon"><i class="fa fa-phone"></i></span>
                                                <input type="tel" class="form-control" id="phone" name="phone" 
                                                       value="${user != null ? user.phone : ''}" maxlength="20"
                                                       placeholder="Nhập số điện thoại">
                                            </div>
                                        </div>
                                    </div>
                                    <div class="col-md-6">
                                        <div class="form-group">
                                            <label for="roleId">Vai trò <span class="text-red">*</span></label>
                                            <div class="input-group">
                                                <span class="input-group-addon"><i class="fa fa-users"></i></span>
                                                <select class="form-control" id="roleId" name="roleId" required>
                                                    <option value="">-- Chọn vai trò --</option>
                                                    <c:forEach var="role" items="${availableRoles}">
                                                        <option value="${role.settingID}" 
                                                                ${user != null && user.roleID == role.settingID ? 'selected' : ''}>
                                                            ${role.description}
                                                        </option>
                                                    </c:forEach>
                                                </select>
                                            </div>
                                        </div>
                                    </div>
                                </div>

                                <div class="row">
                                    <div class="col-md-12">
                                        <div class="form-group">
                                            <label for="address">Địa chỉ</label>
                                            <div class="input-group">
                                                <span class="input-group-addon"><i class="fa fa-map-marker"></i></span>
                                                <textarea class="form-control" id="address" name="address" rows="3" maxlength="255"
                                                          placeholder="Nhập địa chỉ liên hệ">${user != null ? user.address : ''}</textarea>
                                            </div>
                                        </div>
                                    </div>
                                </div>

                                <!-- Status Section (only for edit) -->
                                <c:if test="${action == 'edit'}">
                                    <div class="row">
                                        <div class="col-md-12">
                                            <h4 class="box-title"><i class="fa fa-cog"></i> Trạng thái tài khoản</h4>
                                            <hr>
                                        </div>
                                    </div>
                                    <div class="row">
                                        <div class="col-md-12">
                                            <div class="form-group">
                                                <div class="checkbox">
                                                    <label class="control-label">
                                                        <input type="checkbox" id="isActive" name="isActive" 
                                                               ${user != null && user.active ? 'checked' : ''}>
                                                        <strong>Tài khoản hoạt động</strong>
                                                    </label>
                                                </div>
                                                <small class="text-muted">Bỏ tick để vô hiệu hóa tài khoản này</small>
                                            </div>
                                        </div>
                                    </div>
                                </c:if>
                            </div>

                            <div class="box-footer clearfix">
                                <div class="row">
                                    <div class="col-md-12">
                                        <a href="${pageContext.request.contextPath}/user" class="btn btn-default btn-lg">
                                            <i class="fa fa-times"></i> Hủy bỏ
                                        </a>
                                        <button type="submit" class="btn btn-primary btn-lg pull-right">
                                            <i class="fa fa-save"></i> 
                                            <c:choose>
                                                <c:when test="${action == 'create'}">Tạo người dùng</c:when>
                                                <c:otherwise>Cập nhật thông tin</c:otherwise>
                                            </c:choose>
                                        </button>
                                        <c:if test="${action == 'edit'}">
                                            <a href="${pageContext.request.contextPath}/user?action=changePassword&id=${user.userID}" 
                                               class="btn btn-warning btn-lg pull-right" style="margin-right: 10px;">
                                                <i class="fa fa-key"></i> Đổi mật khẩu
                                            </a>
                                        </c:if>
                                    </div>
                                </div>
                            </div>
                        </form>
                    </div>
                </div>
            </div>
        </section>
        <!-- /.content -->
    </div>
    <!-- /.content-wrapper -->

</div>
<!-- ./wrapper -->

<!-- jQuery 2.2.3 -->
<script src="${pageContext.request.contextPath}/plugins/jQuery/jquery-2.2.3.min.js"></script>
<!-- Bootstrap 3.3.6 -->
<script src="${pageContext.request.contextPath}/bootstrap/js/bootstrap.min.js"></script>
<!-- AdminLTE App -->
<script src="${pageContext.request.contextPath}/dist/js/app.min.js"></script>

<script>
    $(document).ready(function() {
        var password = $('#password');
        var confirmPassword = $('#confirmPassword');
        var passwordMatch = $('#passwordMatch');
        
        // Password validation (only for create form)
        if (password.length && confirmPassword.length) {
            function validatePasswords() {
                var pwd1 = password.val();
                var pwd2 = confirmPassword.val();
                
                if (pwd2.length === 0) {
                    passwordMatch.text('').removeClass('text-success text-danger');
                    return;
                }
                
                if (pwd1 === pwd2) {
                    passwordMatch.text('Mật khẩu khớp').removeClass('text-danger').addClass('text-success');
                } else {
                    passwordMatch.text('Mật khẩu không khớp').removeClass('text-success').addClass('text-danger');
                }
            }
            
            password.on('input', validatePasswords);
            confirmPassword.on('input', validatePasswords);
            
            // Form validation
            $('#userForm').on('submit', function(e) {
                if (password.val() !== confirmPassword.val()) {
                    e.preventDefault();
                    alert('Mật khẩu xác nhận không khớp!');
                    confirmPassword.focus();
                    return false;
                }
                
                // Password strength validation
                var pwd = password.val();
                var hasLetter = /[a-zA-Z]/.test(pwd);
                var hasNumber = /\d/.test(pwd);
                
                if (!hasLetter || !hasNumber) {
                    e.preventDefault();
                    alert('Mật khẩu phải chứa ít nhất một chữ cái và một số!');
                    password.focus();
                    return false;
                }
            });
        }
        
        // Auto-hide alerts after 5 seconds
        setTimeout(function() {
            $('.alert').fadeOut();
        }, 5000);
    });
</script>
</body>
</html>