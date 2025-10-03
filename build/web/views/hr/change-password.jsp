<%-- 
    Document   : change-password
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
    <title>Đổi mật khẩu - Coffee Shop</title>
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
            color: #f39c12;
            border-bottom: 2px solid #f39c12;
            padding-bottom: 5px;
            margin-bottom: 15px;
        }
        
        .input-group-addon {
            min-width: 45px;
            text-align: center;
            background-color: #f39c12;
            color: white;
            border-color: #f39c12;
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
        
        .alert-info {
            background-color: #d9edf7;
            border-color: #bce8f1;
            color: #31708f;
        }
        
        .text-green {
            color: #00a65a !important;
        }
        
        .text-orange {
            color: #f39c12 !important;
        }
        
        .list-unstyled {
            padding-left: 0;
            list-style: none;
        }
        
        .list-unstyled li {
            margin-bottom: 5px;
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
                Đổi mật khẩu
                <small>Thiết lập mật khẩu mới cho tài khoản</small>
            </h1>
            <ol class="breadcrumb">
                <li><a href="${pageContext.request.contextPath}/hr/dashboard"><i class="fa fa-dashboard"></i> Dashboard</a></li>
                <li><a href="${pageContext.request.contextPath}/user">Quản lý người dùng</a></li>
                <li class="active">Đổi mật khẩu</li>
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
                <div class="col-md-8 col-md-offset-2">
                    <div class="box box-warning">
                        <div class="box-header with-border">
                            <h3 class="box-title">
                                <i class="fa fa-key"></i> Đổi mật khẩu người dùng
                            </h3>
                            <div class="box-tools pull-right">
                                <a href="${pageContext.request.contextPath}/user" class="btn btn-default btn-sm">
                                    <i class="fa fa-arrow-left"></i> Quay lại
                                </a>
                            </div>
                        </div>

                        <!-- User Information -->
                        <c:if test="${not empty user}">
                            <div class="box-body">
                                <div class="row">
                                    <div class="col-md-12">
                                        <div class="alert alert-info">
                                            <h4><i class="icon fa fa-info"></i> Thông tin người dùng</h4>
                                            <div class="row">
                                                <div class="col-md-6">
                                                    <strong><i class="fa fa-user"></i> Tên:</strong> ${user.fullName}
                                                </div>
                                                <div class="col-md-6">
                                                    <strong><i class="fa fa-envelope"></i> Email:</strong> ${user.email}
                                                </div>
                                            </div>
                                        </div>
                                    </div>
                                </div>

                                <form method="POST" action="${pageContext.request.contextPath}/user" id="changePasswordForm">
                                    <input type="hidden" name="action" value="changePassword">
                                    <input type="hidden" name="userId" value="${user.userID}">

                                    <div class="row">
                                        <div class="col-md-12">
                                            <h4 class="box-title"><i class="fa fa-lock"></i> Thiết lập mật khẩu mới</h4>
                                            <hr>
                                        </div>
                                    </div>

                                    <div class="row">
                                        <div class="col-md-6">
                                            <div class="form-group">
                                                <label for="newPassword">Mật khẩu mới <span class="text-red">*</span></label>
                                                <div class="input-group">
                                                    <span class="input-group-addon"><i class="fa fa-lock"></i></span>
                                                    <input type="password" class="form-control" id="newPassword" name="newPassword" 
                                                           required minlength="6" maxlength="50" placeholder="Nhập mật khẩu mới">
                                                </div>
                                                <small class="text-muted">Mật khẩu phải có ít nhất 6 ký tự, bao gồm chữ cái và số</small>
                                                <div id="passwordStrength" class="text-sm"></div>
                                            </div>
                                        </div>
                                        <div class="col-md-6">
                                            <div class="form-group">
                                                <label for="confirmPassword">Xác nhận mật khẩu mới <span class="text-red">*</span></label>
                                                <div class="input-group">
                                                    <span class="input-group-addon"><i class="fa fa-key"></i></span>
                                                    <input type="password" class="form-control" id="confirmPassword" name="confirmPassword" 
                                                           required minlength="6" maxlength="50" placeholder="Nhập lại mật khẩu mới">
                                                </div>
                                                <div id="passwordMatch" class="text-sm"></div>
                                            </div>
                                        </div>
                                    </div>

                                    <div class="row">
                                        <div class="col-md-12">
                                            <div class="callout callout-warning">
                                                <h4><i class="icon fa fa-warning"></i> Lưu ý quan trọng:</h4>
                                                <ul class="list-unstyled">
                                                    <li><i class="fa fa-check text-green"></i> Mật khẩu phải có ít nhất 6 ký tự</li>
                                                    <li><i class="fa fa-check text-green"></i> Nên bao gồm cả chữ cái và số</li>
                                                    <li><i class="fa fa-check text-green"></i> Tránh sử dụng thông tin cá nhân dễ đoán</li>
                                                    <li><i class="fa fa-warning text-orange"></i> Người dùng sẽ cần đăng nhập lại với mật khẩu mới</li>
                                                </ul>
                                            </div>
                                        </div>
                                    </div>
                                </form>
                            </div>

                            <div class="box-footer clearfix">
                                <div class="row">
                                    <div class="col-md-12">
                                        <a href="${pageContext.request.contextPath}/user" class="btn btn-default btn-lg">
                                            <i class="fa fa-times"></i> Hủy bỏ
                                        </a>
                                        <button type="submit" form="changePasswordForm" class="btn btn-warning btn-lg pull-right">
                                            <i class="fa fa-save"></i> Cập nhật mật khẩu
                                        </button>
                                        <a href="${pageContext.request.contextPath}/user?action=view&id=${user.userID}" 
                                           class="btn btn-info btn-lg pull-right" style="margin-right: 10px;">
                                            <i class="fa fa-eye"></i> Xem thông tin
                                        </a>
                                    </div>
                                </div>
                            </div>
                        </c:if>
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
        var newPassword = $('#newPassword');
        var confirmPassword = $('#confirmPassword');
        var passwordStrength = $('#passwordStrength');
        var passwordMatch = $('#passwordMatch');
        
        // Password strength checker
        function checkPasswordStrength(password) {
            var length = password.length;
            var hasLower = /[a-z]/.test(password);
            var hasUpper = /[A-Z]/.test(password);
            var hasNumber = /\d/.test(password);
            var hasSpecial = /[!@#$%^&*(),.?":{}|<>]/.test(password);
            
            var strength = 0;
            var message = '';
            var className = '';
            
            if (length >= 6) strength++;
            if (hasLower && hasUpper) strength++;
            if (hasNumber) strength++;
            if (hasSpecial) strength++;
            
            switch (strength) {
                case 0:
                case 1:
                    message = 'Mật khẩu yếu';
                    className = 'text-red';
                    break;
                case 2:
                    message = 'Mật khẩu trung bình';
                    className = 'text-yellow';
                    break;
                case 3:
                    message = 'Mật khẩu mạnh';
                    className = 'text-blue';
                    break;
                case 4:
                    message = 'Mật khẩu rất mạnh';
                    className = 'text-green';
                    break;
            }
            
            return { message: message, className: className };
        }
        
        // Password validation
        function validatePasswords() {
            var pwd1 = newPassword.val();
            var pwd2 = confirmPassword.val();
            
            // Check password strength
            if (pwd1.length > 0) {
                var strength = checkPasswordStrength(pwd1);
                passwordStrength.text(strength.message).removeClass('text-red text-yellow text-blue text-green').addClass(strength.className);
            } else {
                passwordStrength.text('').removeClass('text-red text-yellow text-blue text-green');
            }
            
            // Check password match
            if (pwd2.length === 0) {
                passwordMatch.text('').removeClass('text-green text-red');
                return;
            }
            
            if (pwd1 === pwd2) {
                passwordMatch.text('Mật khẩu khớp').removeClass('text-red').addClass('text-green');
            } else {
                passwordMatch.text('Mật khẩu không khớp').removeClass('text-green').addClass('text-red');
            }
        }
        
        newPassword.on('input', validatePasswords);
        confirmPassword.on('input', validatePasswords);
        
        // Form validation
        $('#changePasswordForm').on('submit', function(e) {
            var pwd1 = newPassword.val();
            var pwd2 = confirmPassword.val();
            
            if (pwd1 !== pwd2) {
                e.preventDefault();
                alert('Mật khẩu xác nhận không khớp!');
                confirmPassword.focus();
                return false;
            }
            
            // Password strength validation
            var hasLetter = /[a-zA-Z]/.test(pwd1);
            var hasNumber = /\d/.test(pwd1);
            
            if (!hasLetter || !hasNumber) {
                e.preventDefault();
                alert('Mật khẩu phải chứa ít nhất một chữ cái và một số!');
                newPassword.focus();
                return false;
            }
            
            // Confirmation
            if (!confirm('Bạn có chắc chắn muốn đổi mật khẩu cho người dùng này?')) {
                e.preventDefault();
                return false;
            }
        });
        
        // Auto-hide alerts after 5 seconds
        setTimeout(function() {
            $('.alert').fadeOut();
        }, 5000);
    });
</script>
</body>
</html>