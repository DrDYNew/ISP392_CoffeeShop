<%@page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="utf-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <title>HR Dashboard - Coffee Shop Management</title>
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
                HR Dashboard
                <small>Quản lý nhân sự</small>
            </h1>
            <ol class="breadcrumb">
                <li><a href="#"><i class="fa fa-dashboard"></i> Home</a></li>
                <li class="active">HR Dashboard</li>
            </ol>
        </section>

        <!-- Main content -->
        <section class="content">
            
            <!-- Debug info (sẽ xóa sau khi test) -->
            <div class="row" style="background: #f9f9f9; padding: 10px; margin-bottom: 20px; border: 1px solid #ddd;">
                <div class="col-md-12">
                    <h4>Debug Session Info:</h4>
                    <p><strong>User:</strong> ${sessionScope.user.fullName}</p>
                    <p><strong>Role Name:</strong> ${sessionScope.roleName}</p>
                    <p><strong>User ID:</strong> ${sessionScope.user.userID}</p>
                    <p><strong>Role ID:</strong> ${sessionScope.user.roleID}</p>
                </div>
            </div>
            <!-- Welcome Section -->
            <div class="row">
                <div class="col-md-12">
                    <div class="box">
                        <div class="box-header with-border">
                            <h3 class="box-title">Chào mừng, ${sessionScope.user.fullName}!</h3>
                            <p>Phòng Nhân sự - Quản lý nhân viên và tuyển dụng</p>
                        </div>
                    </div>
                </div>
            </div>
            
            <!-- Statistics Cards -->
            <div class="row">
                <div class="col-lg-3 col-xs-6">
                    <!-- small box -->
                    <div class="small-box bg-aqua">
                        <div class="inner">
                            <h3>8</h3>
                            <p>Tổng nhân viên</p>
                        </div>
                        <div class="icon">
                            <i class="fa fa-users"></i>
                        </div>
                        <a href="#" class="small-box-footer">100% đang hoạt động <i class="fa fa-arrow-circle-right"></i></a>
                    </div>
                </div>
                <!-- ./col -->
                <div class="col-lg-3 col-xs-6">
                    <!-- small box -->
                    <div class="small-box bg-green">
                        <div class="inner">
                            <h3>3</h3>
                            <p>Ứng viên mới</p>
                        </div>
                        <div class="icon">
                            <i class="fa fa-user-plus"></i>
                        </div>
                        <a href="#" class="small-box-footer">+2 tuần này <i class="fa fa-arrow-circle-right"></i></a>
                    </div>
                </div>
                <!-- ./col -->
                <div class="col-lg-3 col-xs-6">
                    <!-- small box -->
                    <div class="small-box bg-yellow">
                        <div class="inner">
                            <h3>95%</h3>
                            <p>Tỷ lệ chuyên cần</p>
                        </div>
                        <div class="icon">
                            <i class="fa fa-calendar-check-o"></i>
                        </div>
                        <a href="#" class="small-box-footer">+2% so với tháng trước <i class="fa fa-arrow-circle-right"></i></a>
                    </div>
                </div>
                <!-- ./col -->
                <div class="col-lg-3 col-xs-6">
                    <!-- small box -->
                    <div class="small-box bg-red">
                        <div class="inner">
                            <h3>160</h3>
                            <p>Giờ làm việc/tháng</p>
                        </div>
                        <div class="icon">
                            <i class="fa fa-clock-o"></i>
                        </div>
                        <a href="#" class="small-box-footer">Trung bình mỗi nhân viên <i class="fa fa-arrow-circle-right"></i></a>
                    </div>
                </div>
                <!-- ./col -->
            </div>
            <!-- /.row -->
            
            <!-- Quick Actions -->
            <div class="row">
                <div class="col-md-12">
                    <div class="box box-primary">
                        <div class="box-header with-border">
                            <h3 class="box-title">Thao tác nhanh</h3>
                        </div>
                        <div class="box-body">
                            <div class="row">
                                <div class="col-md-3">
                                    <a href="#" class="btn btn-app">
                                        <i class="fa fa-user-plus"></i>
                                        Tuyển dụng
                                    </a>
                                </div>
                                <div class="col-md-3">
                                    <a href="#" class="btn btn-app">
                                        <i class="fa fa-calendar"></i>
                                        Lịch làm việc
                                    </a>
                                </div>
                                <div class="col-md-3">
                                    <a href="#" class="btn btn-app">
                                        <i class="fa fa-money"></i>
                                        Bảng lương
                                    </a>
                                </div>
                                <div class="col-md-3">
                                    <a href="#" class="btn btn-app">
                                        <i class="fa fa-line-chart"></i>
                                        Báo cáo HR
                                    </a>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
                
                
            <div class="row">
                <!-- Employee Status -->
                <div class="col-md-8">
                    <div class="box box-info">
                        <div class="box-header with-border">
                            <h3 class="box-title">Trạng thái nhân viên hôm nay</h3>
                        </div>
                        <div class="box-body">
                            <div class="table-responsive">
                                <table class="table table-striped">
                                    <thead>
                                        <tr>
                                            <th>Nhân viên</th>
                                            <th>Vị trí</th>
                                            <th>Ca làm việc</th>
                                            <th>Trạng thái</th>
                                            <th>Check-in</th>
                                        </tr>
                                    </thead>
                                    <tbody>
                                        <tr>
                                            <td>
                                                <div class="user-block">
                                                    <img class="img-circle img-bordered-sm" src="${pageContext.request.contextPath}/dist/img/user1-128x128.jpg" alt="user image">
                                                    <span class="username">Lê Thị Mai</span>
                                                </div>
                                            </td>
                                            <td>Quản lý kho</td>
                                            <td>8:00 - 17:00</td>
                                            <td><span class="label label-success">Đang làm việc</span></td>
                                            <td>7:55 AM</td>
                                        </tr>
                                        <tr>
                                            <td>
                                                <div class="user-block">
                                                    <img class="img-circle img-bordered-sm" src="${pageContext.request.contextPath}/dist/img/user2-160x160.jpg" alt="user image">
                                                    <span class="username">Vũ Thị Nam</span>
                                                </div>
                                            </td>
                                            <td>Barista</td>
                                            <td>6:00 - 14:00</td>
                                            <td><span class="label label-success">Đang làm việc</span></td>
                                            <td>5:50 AM</td>
                                        </tr>
                                        <tr>
                                            <td>
                                                <div class="user-block">
                                                    <img class="img-circle img-bordered-sm" src="${pageContext.request.contextPath}/dist/img/user3-128x128.jpg" alt="user image">
                                                    <span class="username">Đỗ Văn Phong</span>
                                                </div>
                                            </td>
                                            <td>Barista</td>
                                            <td>14:00 - 22:00</td>
                                            <td><span class="label label-warning">Chưa check-in</span></td>
                                            <td>-</td>
                                        </tr>
                                        <tr>
                                            <td>
                                                <div class="user-block">
                                                    <img class="img-circle img-bordered-sm" src="${pageContext.request.contextPath}/dist/img/user4-128x128.jpg" alt="user image">
                                                    <span class="username">Phạm Thị Linh</span>
                                                </div>
                                            </td>
                                            <td>Nhân viên kho</td>
                                            <td>8:00 - 17:00</td>
                                            <td><span class="label label-success">Đang làm việc</span></td>
                                            <td>8:05 AM</td>
                                        </tr>
                                    </tbody>
                                </table>
                            </div>
                        </div>
                    </div>
                </div>
                
                <!-- HR Notifications -->
                <div class="col-md-4">
                    <div class="box box-warning">
                        <div class="box-header with-border">
                            <h3 class="box-title">Thông báo HR</h3>
                        </div>
                        <div class="box-body">
                            <ul class="products-list product-list-in-box">
                                <li class="item">
                                    <div class="product-img">
                                        <i class="fa fa-exclamation-triangle text-yellow"></i>
                                    </div>
                                    <div class="product-info">
                                        <a href="#" class="product-title">Hợp đồng sắp hết hạn</a>
                                        <span class="product-description">
                                            3 nhân viên có hợp đồng hết hạn trong tháng này
                                        </span>
                                        <span class="label label-warning pull-right">2 giờ trước</span>
                                    </div>
                                </li>
                                <li class="item">
                                    <div class="product-img">
                                        <i class="fa fa-user-plus text-blue"></i>
                                    </div>
                                    <div class="product-info">
                                        <a href="#" class="product-title">Ứng viên mới</a>
                                        <span class="product-description">
                                            Có 2 ứng viên mới ứng tuyển vị trí Barista
                                        </span>
                                        <span class="label label-info pull-right">5 giờ trước</span>
                                    </div>
                                </li>
                                <li class="item">
                                    <div class="product-img">
                                        <i class="fa fa-check-circle text-green"></i>
                                    </div>
                                    <div class="product-info">
                                        <a href="#" class="product-title">Lịch làm việc tuần mới</a>
                                        <span class="product-description">
                                            Đã hoàn thành sắp xếp lịch cho tuần tới
                                        </span>
                                        <span class="label label-success pull-right">1 ngày trước</span>
                                    </div>
                                </li>
                            </ul>
                        </div>
                    </div>
                    
                    <!-- Upcoming Events -->
                    <div class="box box-info">
                        <div class="box-header with-border">
                            <h3 class="box-title">Sự kiện sắp tới</h3>
                        </div>
                        <div class="box-body">
                            <ul class="products-list product-list-in-box">
                                <li class="item">
                                    <div class="product-img">
                                        <div class="text-center" style="background: #3c8dbc; color: white; padding: 10px; border-radius: 5px;">
                                            <div style="font-size: 18px; font-weight: bold;">15</div>
                                            <div style="font-size: 10px;">OCT</div>
                                        </div>
                                    </div>
                                    <div class="product-info">
                                        <a href="#" class="product-title">Họp team HR</a>
                                        <span class="product-description">
                                            Đánh giá hiệu suất Q3
                                        </span>
                                    </div>
                                </li>
                                <li class="item">
                                    <div class="product-img">
                                        <div class="text-center" style="background: #3c8dbc; color: white; padding: 10px; border-radius: 5px;">
                                            <div style="font-size: 18px; font-weight: bold;">20</div>
                                            <div style="font-size: 10px;">OCT</div>
                                        </div>
                                    </div>
                                    <div class="product-info">
                                        <a href="#" class="product-title">Training Barista</a>
                                        <span class="product-description">
                                            Khóa đào tạo kỹ năng pha chế
                                        </span>
                                    </div>
                                </li>
                            </ul>
                        </div>
                    </div>
                </div>
            </div>
            <!-- /.row -->
            
        </section>
        <!-- /.content -->
    </div>
    <!-- /.content-wrapper -->

    <!-- Include Footer -->
    <footer class="main-footer">
        <div class="pull-right hidden-xs">
            <b>Version</b> 2.3.8
        </div>
        <strong>Copyright &copy; 2014-2016 <a href="http://almsaeedstudio.com">Almsaeed Studio</a>.</strong> All rights
        reserved.
    </footer>

    <!-- Control Sidebar -->
    <aside class="control-sidebar control-sidebar-dark">
        <!-- Create the tabs -->
        <ul class="nav nav-tabs nav-justified control-sidebar-tabs">
            <li><a href="#control-sidebar-home-tab" data-toggle="tab"><i class="fa fa-home"></i></a></li>
            <li><a href="#control-sidebar-settings-tab" data-toggle="tab"><i class="fa fa-gears"></i></a></li>
        </ul>
    </aside>
    <!-- /.control-sidebar -->
    <!-- Add the sidebar's background. This div must be placed
         immediately after the control sidebar -->
    <div class="control-sidebar-bg"></div>
</div>
<!-- ./wrapper -->

<!-- jQuery 2.2.3 -->
<script src="${pageContext.request.contextPath}/plugins/jQuery/jquery-2.2.3.min.js"></script>
<!-- jQuery UI 1.11.4 -->
<script src="https://code.jquery.com/ui/1.11.4/jquery-ui.min.js"></script>
<!-- Resolve conflict in jQuery UI tooltip with Bootstrap tooltip -->
<script>
    $.widget.bridge('uibutton', $.ui.button);
</script>
<!-- Bootstrap 3.3.6 -->
<script src="${pageContext.request.contextPath}/bootstrap/js/bootstrap.min.js"></script>
<!-- AdminLTE App -->
<script src="${pageContext.request.contextPath}/dist/js/app.min.js"></script>

</body>
</html>