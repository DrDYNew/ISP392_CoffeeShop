<%@page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="utf-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <title>Chỉnh sửa Profile - Coffee Shop Management</title>
    <meta content="width=device-width, initial-scale=1, maximum-scale=1, user-scalable=no" name="viewport">
    
    <!-- Bootstrap CSS từ CDN -->
    <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/css/bootstrap.min.css" integrity="sha384-BVYiiSIFeK1dGmJRAkycuHAHRg32OmUcww7on3RYdg4Va+PmSTsz/K68vbdEjh4u" crossorigin="anonymous">
    <!-- Font Awesome -->
    <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/font-awesome/4.7.0/css/font-awesome.min.css">
    <!-- AdminLTE CSS -->
    <link rel="stylesheet" href="${pageContext.request.contextPath}/dist/css/AdminLTE.min.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/dist/css/skins/_all-skins.min.css">
    
    <!-- jQuery từ CDN -->
    <script src="https://code.jquery.com/jquery-2.2.4.min.js" integrity="sha256-BbhdlvQf/xTY9gja0Dq3HiwQF8LaCRTXxZKRutelT44=" crossorigin="anonymous"></script>
    
    <style>
        .form-group label {
            font-weight: bold;
        }
        .required {
            color: red;
        }
        .profile-form {
            background: white;
            padding: 30px;
            border-radius: 5px;
            box-shadow: 0 2px 10px rgba(0,0,0,0.1);
        }
    </style>
</head>
<body class="hold-transition skin-blue sidebar-mini">
<div class="wrapper">
    <!-- Main Header -->
    <header class="main-header">
        <a href="${pageContext.request.contextPath}/" class="logo">
            <span class="logo-mini"><b>CS</b></span>
            <span class="logo-lg"><b>Coffee</b>Shop</span>
        </a>
        <nav class="navbar navbar-static-top">
            <a href="#" class="sidebar-toggle" data-toggle="push-menu" role="button">
                <span class="sr-only">Toggle navigation</span>
            </a>
            <div class="navbar-custom-menu">
                <ul class="nav navbar-nav">
                    <li class="dropdown user user-menu">
                        <a href="#" class="dropdown-toggle" data-toggle="dropdown">
                            <img src="https://via.placeholder.com/160x160/00a65a/ffffff/png?text=${sessionScope.user.fullName.substring(0,1)}" class="user-image" alt="User Image">
                            <span class="hidden-xs">${sessionScope.user.fullName}</span>
                        </a>
                        <ul class="dropdown-menu">
                            <li class="user-header">
                                <img src="https://via.placeholder.com/160x160/00a65a/ffffff/png?text=${sessionScope.user.fullName.substring(0,1)}" class="img-circle" alt="User Image">
                                <p>
                                    ${sessionScope.user.fullName}
                                    <small>Thành viên từ ${sessionScope.user.createdAt != null ? sessionScope.user.createdAt : 'N/A'}</small>
                                </p>
                            </li>
                            <li class="user-footer">
                                <div class="pull-left">
                                    <a href="${pageContext.request.contextPath}/profile" class="btn btn-default btn-flat">Profile</a>
                                </div>
                                <div class="pull-right">
                                    <a href="${pageContext.request.contextPath}/login?action=logout" class="btn btn-default btn-flat">Đăng xuất</a>
                                </div>
                            </li>
                        </ul>
                    </li>
                </ul>
            </div>
        </nav>
    </header>

    <!-- Include Sidebar -->
    <jsp:include page="../compoment/sidebar.jsp" />

    <!-- Content Wrapper -->
    <div class="content-wrapper">
        <section class="content-header">
            <h1>
                Chỉnh sửa thông tin cá nhân
                <small>Cập nhật thông tin của bạn</small>
            </h1>
            <ol class="breadcrumb">
                <li><a href="${pageContext.request.contextPath}/"><i class="fa fa-dashboard"></i> Home</a></li>
                <li><a href="${pageContext.request.contextPath}/profile">Profile</a></li>
                <li class="active">Chỉnh sửa</li>
            </ol>
        </section>

        <section class="content">
            <!-- Alert messages -->
            <c:if test="${not empty error}">
                <div class="alert alert-danger alert-dismissible">
                    <button type="button" class="close" data-dismiss="alert" aria-hidden="true">&times;</button>
                    <h4><i class="icon fa fa-ban"></i> Lỗi!</h4>
                    ${error}
                </div>
            </c:if>
            
            <c:if test="${not empty warning}">
                <div class="alert alert-warning alert-dismissible">
                    <button type="button" class="close" data-dismiss="alert" aria-hidden="true">&times;</button>
                    <h4><i class="icon fa fa-warning"></i> Cảnh báo!</h4>
                    ${warning}
                </div>
            </c:if>

            <div class="row">
                <div class="col-md-8 col-md-offset-2">
                    <div class="profile-form">
                        <form action="${pageContext.request.contextPath}/profile" method="post" id="profileForm">
                            <input type="hidden" name="action" value="update-profile">
                            
                            <div class="row">
                                <div class="col-md-12">
                                    <h3><i class="fa fa-user"></i> Thông tin cá nhân</h3>
                                    <hr>
                                </div>
                            </div>
                            
                            <div class="row">
                                <div class="col-md-6">
                                    <div class="form-group">
                                        <label for="fullName">Họ và tên <span class="required">*</span></label>
                                        <input type="text" class="form-control" id="fullName" name="fullName" 
                                               value="${profileUser.fullName}" required maxlength="100">
                                        <small class="help-block">Nhập họ và tên đầy đủ của bạn</small>
                                    </div>
                                </div>
                                
                                <div class="col-md-6">
                                    <div class="form-group">
                                        <label for="email">Email <span class="required">*</span></label>
                                        <input type="email" class="form-control" id="email" name="email" 
                                               value="${profileUser.email}" readonly>
                                        <small class="help-block">Email sẽ được sử dụng để đăng nhập</small>
                                    </div>
                                </div>
                            </div>
                            
                            <div class="row">
                                <div class="col-md-6">
                                    <div class="form-group">
                                        <label for="phone">Số điện thoại</label>
                                        <input type="tel" class="form-control" id="phone" name="phone" 
                                               value="${profileUser.phone}" maxlength="15" 
                                               pattern="[0-9+\-\s()]*" title="Chỉ nhập số và ký tự đặc biệt +, -, (), space">
                                        <small class="help-block">Nhập số điện thoại liên hệ</small>
                                    </div>
                                </div>
                                
                                <div class="col-md-6">
                                    <div class="form-group">
                                        <label>Vai trò hiện tại</label>
                                        <input type="text" class="form-control" value="${sessionScope.roleName}" readonly>
                                        <small class="help-block">Vai trò không thể thay đổi</small>
                                    </div>
                                </div>
                            </div>
                            
                            <div class="row">
                                <div class="col-md-12">
                                    <div class="form-group">
                                        <label for="address">Địa chỉ</label>
                                        <textarea class="form-control" id="address" name="address" 
                                                  rows="3" maxlength="200" placeholder="Nhập địa chỉ của bạn">${profileUser.address}</textarea>
                                        <small class="help-block">Nhập địa chỉ nơi ở hiện tại</small>
                                    </div>
                                </div>
                            </div>
                            
                            <div class="row">
                                <div class="col-md-12">
                                    <hr>
                                    <div class="form-group text-center">
                                        <button type="submit" class="btn btn-primary btn-lg">
                                            <i class="fa fa-save"></i> Lưu thay đổi
                                        </button>
                                        <a href="${pageContext.request.contextPath}/profile" class="btn btn-default btn-lg">
                                            <i class="fa fa-times"></i> Hủy bỏ
                                        </a>
                                    </div>
                                </div>
                            </div>
                        </form>
                    </div>
                </div>
            </div>
        </section>
    </div>
</div>

<!-- Bootstrap JS từ CDN -->
<script src="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/js/bootstrap.min.js" integrity="sha384-Tc5IQib027qvyjSMfHjOMaLkfuWVxZxUPnCJA7l2mCWNIpG9mGCD8wGNIcPD7Txa" crossorigin="anonymous"></script>

<script>
$(document).ready(function() {
    // Auto hide alerts after 5 seconds
    setTimeout(function() {
        $('.alert').fadeOut('slow');
    }, 5000);
    
    // Form validation
    $('#profileForm').on('submit', function(e) {
        var fullName = $('#fullName').val().trim();
        
        if (fullName === '') {
            alert('Vui lòng nhập họ và tên');
            $('#fullName').focus();
            e.preventDefault();
            return false;
        }
    });
    
    // Phone number formatting
    $('#phone').on('input', function() {
        var value = $(this).val();
        // Remove any non-digit characters except +, -, (), space
        value = value.replace(/[^\d+\-\s()]/g, '');
        $(this).val(value);
    });
});
</script>

</body>
</html>