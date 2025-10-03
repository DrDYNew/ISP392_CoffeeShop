<%@page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="utf-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <title>Barista Dashboard - Coffee Shop Management</title>
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
        .info-box {
            display: block;
            min-height: 90px;
            background: #fff;
            width: 100%;
            box-shadow: 0 1px 3px rgba(0,0,0,0.12), 0 1px 2px rgba(0,0,0,0.24);
            border-radius: 2px;
            margin-bottom: 15px;
        }
        
        .info-box-icon {
            border-top-left-radius: 2px;
            border-top-right-radius: 0;
            border-bottom-right-radius: 0;
            border-bottom-left-radius: 2px;
            display: block;
            float: left;
            height: 90px;
            width: 90px;
            text-align: center;
            font-size: 45px;
            line-height: 90px;
            background: rgba(0,0,0,0.2);
        }
        
        .info-box-content {
            padding: 5px 10px;
            margin-left: 90px;
        }
        
        .info-box-number {
            display: block;
            font-weight: bold;
            font-size: 18px;
        }
        
        .info-box-text {
            display: block;
            font-size: 14px;
            white-space: nowrap;
            overflow: hidden;
            text-overflow: ellipsis;
        }
        
        .bg-coffee { background-color: #8B4513 !important; }
        .bg-green { background-color: #00a65a !important; }
        .bg-yellow { background-color: #f39c12 !important; }
        .bg-aqua { background-color: #00c0ef !important; }
        .bg-blue { background-color: #3c8dbc !important; }
        .bg-purple { background-color: #605ca8 !important; }
        .bg-orange { background-color: #ff6b35 !important; }
        
        .small-box {
            border-radius: 2px;
            position: relative;
            display: block;
            margin-bottom: 20px;
            box-shadow: 0 1px 3px rgba(0,0,0,0.12), 0 1px 2px rgba(0,0,0,0.24);
        }
        
        .small-box > .inner {
            padding: 15px;
        }
        
        .small-box .icon {
            -webkit-transition: all .3s linear;
            -o-transition: all .3s linear;
            transition: all .3s linear;
            position: absolute;
            top: -10px;
            right: 10px;
            z-index: 0;
            font-size: 90px;
            color: rgba(0,0,0,0.15);
        }
        
        .small-box p {
            font-size: 15px;
        }
        
        .small-box h3 {
            font-size: 38px;
            font-weight: bold;
            margin: 0 0 10px 0;
            white-space: nowrap;
            padding: 0;
        }
        
        .small-box-footer {
            position: relative;
            text-align: center;
            padding: 3px 0;
            color: #fff;
            color: rgba(255,255,255,0.8);
            display: block;
            z-index: 10;
            background: rgba(0,0,0,0.1);
            text-decoration: none;
        }
        
        .small-box-footer:hover {
            color: #fff;
            background: rgba(0,0,0,0.15);
        }
        
        .order-item {
            background: #f9f9f9;
            border-left: 4px solid #3c8dbc;
            margin-bottom: 10px;
            padding: 10px;
            border-radius: 3px;
        }
        
        .order-urgent {
            border-left-color: #dd4b39;
            background: #fdf2f2;
        }
        
        .order-status {
            float: right;
            font-weight: bold;
        }
        
        .status-new { color: #f39c12; }
        .status-preparing { color: #3c8dbc; }
        .status-ready { color: #00a65a; }
        
        .menu-item {
            background: #fff;
            border: 1px solid #ddd;
            border-radius: 5px;
            padding: 15px;
            margin-bottom: 15px;
            text-align: center;
            transition: transform 0.2s;
        }
        
        .menu-item:hover {
            transform: translateY(-2px);
            box-shadow: 0 4px 8px rgba(0,0,0,0.15);
        }
        
        .menu-item img {
            width: 80px;
            height: 80px;
            border-radius: 50%;
            margin-bottom: 10px;
        }
        
        .price {
            color: #27ae60;
            font-weight: bold;
            font-size: 16px;
        }
        
        .shift-info {
            background: linear-gradient(45deg, #3c8dbc, #5bc0de);
            color: white;
            padding: 20px;
            border-radius: 5px;
            margin-bottom: 20px;
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
                Barista Dashboard
                <small>Quản lý pha chế</small>
            </h1>
            <ol class="breadcrumb">
                <li><a href="${pageContext.request.contextPath}/barista/dashboard"><i class="fa fa-dashboard"></i> Home</a></li>
                <li class="active">Barista Dashboard</li>
            </ol>
        </section>

        <!-- Main content -->
        <section class="content">
            
            <!-- Welcome Message & Shift Info -->
            <div class="row">
                <div class="col-md-12">
                    <div class="shift-info">
                        <div class="row">
                            <div class="col-md-8">
                                <h3><i class="fa fa-coffee"></i> Xin chào, ${sessionScope.user.fullName}!</h3>
                                <p>Ca làm việc hôm nay: <strong>06:00 - 14:00</strong></p>
                                <p>Thời gian hiện tại: <strong><span id="currentTime"></span></strong></p>
                            </div>
                            <div class="col-md-4 text-right">
                                <h4>Trạng thái ca làm việc</h4>
                                <span class="label label-success label-lg">Đang làm việc</span>
                            </div>
                        </div>
                    </div>
                </div>
            </div>

            <!-- Daily Stats -->
            <div class="row">
                <div class="col-lg-3 col-xs-6">
                    <div class="small-box bg-coffee">
                        <div class="inner">
                            <h3>23</h3>
                            <p>Đơn hàng hôm nay</p>
                        </div>
                        <div class="icon">
                            <i class="fa fa-coffee"></i>
                        </div>
                        <a href="javascript:void(0)" class="small-box-footer">
                            Xem chi tiết <i class="fa fa-arrow-circle-right"></i>
                        </a>
                    </div>
                </div>
                
                <div class="col-lg-3 col-xs-6">
                    <div class="small-box bg-green">
                        <div class="inner">
                            <h3>18</h3>
                            <p>Đơn đã hoàn thành</p>
                        </div>
                        <div class="icon">
                            <i class="fa fa-check-circle"></i>
                        </div>
                        <a href="javascript:void(0)" class="small-box-footer">
                            Xem chi tiết <i class="fa fa-arrow-circle-right"></i>
                        </a>
                    </div>
                </div>
                
                <div class="col-lg-3 col-xs-6">
                    <div class="small-box bg-yellow">
                        <div class="inner">
                            <h3>5</h3>
                            <p>Đang pha chế</p>
                        </div>
                        <div class="icon">
                            <i class="fa fa-clock-o"></i>
                        </div>
                        <a href="javascript:void(0)" class="small-box-footer">
                            Xem chi tiết <i class="fa fa-arrow-circle-right"></i>
                        </a>
                    </div>
                </div>
                
                <div class="col-lg-3 col-xs-6">
                    <div class="small-box bg-aqua">
                        <div class="inner">
                            <h3>850K</h3>
                            <p>Doanh thu ca làm</p>
                        </div>
                        <div class="icon">
                            <i class="fa fa-money"></i>
                        </div>
                        <a href="javascript:void(0)" class="small-box-footer">
                            Xem chi tiết <i class="fa fa-arrow-circle-right"></i>
                        </a>
                    </div>
                </div>
            </div>

            <!-- Orders and Menu -->
            <div class="row">
                <div class="col-md-8">
                    <!-- Current Orders Queue -->
                    <div class="box box-primary">
                        <div class="box-header with-border">
                            <h3 class="box-title"><i class="fa fa-list-alt"></i> Đơn hàng cần pha chế</h3>
                            <div class="box-tools pull-right">
                                <span class="label label-primary">5 đơn</span>
                            </div>
                        </div>
                        <div class="box-body" style="max-height: 400px; overflow-y: auto;">
                            <!-- Order 1 -->
                            <div class="order-item order-urgent">
                                <div class="row">
                                    <div class="col-md-8">
                                        <h5><strong>Đơn #001</strong> - Bàn 5</h5>
                                        <p><i class="fa fa-clock-o"></i> 08:30 | <i class="fa fa-user"></i> Nguyễn Văn A</p>
                                        <ul class="list-unstyled">
                                            <li>• 2x Cappuccino</li>
                                            <li>• 1x Americano</li>
                                            <li>• 1x Croissant</li>
                                        </ul>
                                    </div>
                                    <div class="col-md-4 text-right">
                                        <span class="order-status status-preparing">Đang pha</span>
                                        <br><br>
                                        <button class="btn btn-success btn-sm">
                                            <i class="fa fa-check"></i> Hoàn thành
                                        </button>
                                    </div>
                                </div>
                            </div>
                            
                            <!-- Order 2 -->
                            <div class="order-item">
                                <div class="row">
                                    <div class="col-md-8">
                                        <h5><strong>Đơn #002</strong> - Mang về</h5>
                                        <p><i class="fa fa-clock-o"></i> 08:35 | <i class="fa fa-user"></i> Trần Thị B</p>
                                        <ul class="list-unstyled">
                                            <li>• 1x Latte</li>
                                            <li>• 1x Macchiato</li>
                                        </ul>
                                    </div>
                                    <div class="col-md-4 text-right">
                                        <span class="order-status status-new">Chờ pha</span>
                                        <br><br>
                                        <button class="btn btn-primary btn-sm">
                                            <i class="fa fa-play"></i> Bắt đầu
                                        </button>
                                    </div>
                                </div>
                            </div>
                            
                            <!-- Order 3 -->
                            <div class="order-item">
                                <div class="row">
                                    <div class="col-md-8">
                                        <h5><strong>Đơn #003</strong> - Bàn 2</h5>
                                        <p><i class="fa fa-clock-o"></i> 08:40 | <i class="fa fa-user"></i> Lê Văn C</p>
                                        <ul class="list-unstyled">
                                            <li>• 3x Espresso</li>
                                            <li>• 2x Muffin</li>
                                        </ul>
                                    </div>
                                    <div class="col-md-4 text-right">
                                        <span class="order-status status-new">Chờ pha</span>
                                        <br><br>
                                        <button class="btn btn-primary btn-sm">
                                            <i class="fa fa-play"></i> Bắt đầu
                                        </button>
                                    </div>
                                </div>
                            </div>
                            
                            <!-- Order 4 -->
                            <div class="order-item">
                                <div class="row">
                                    <div class="col-md-8">
                                        <h5><strong>Đơn #004</strong> - Bàn 7</h5>
                                        <p><i class="fa fa-clock-o"></i> 08:45 | <i class="fa fa-user"></i> Phạm Thị D</p>
                                        <ul class="list-unstyled">
                                            <li>• 1x Mocha</li>
                                            <li>• 1x Frappuccino</li>
                                            <li>• 1x Sandwich</li>
                                        </ul>
                                    </div>
                                    <div class="col-md-4 text-right">
                                        <span class="order-status status-new">Chờ pha</span>
                                        <br><br>
                                        <button class="btn btn-primary btn-sm">
                                            <i class="fa fa-play"></i> Bắt đầu
                                        </button>
                                    </div>
                                </div>
                            </div>
                        </div>
                        <div class="box-footer">
                            <button class="btn btn-success btn-block">
                                <i class="fa fa-refresh"></i> Làm mới danh sách đơn hàng
                            </button>
                        </div>
                    </div>
                </div>
                
                <div class="col-md-4">
                    <!-- Quick Menu -->
                    <div class="box box-info">
                        <div class="box-header with-border">
                            <h3 class="box-title"><i class="fa fa-coffee"></i> Menu nhanh</h3>
                        </div>
                        <div class="box-body">
                            <div class="row">
                                <div class="col-xs-6">
                                    <div class="menu-item">
                                        <i class="fa fa-coffee" style="font-size: 40px; color: #8B4513;"></i>
                                        <h5>Espresso</h5>
                                        <p class="price">35,000đ</p>
                                    </div>
                                </div>
                                <div class="col-xs-6">
                                    <div class="menu-item">
                                        <i class="fa fa-coffee" style="font-size: 40px; color: #D2691E;"></i>
                                        <h5>Americano</h5>
                                        <p class="price">40,000đ</p>
                                    </div>
                                </div>
                                <div class="col-xs-6">
                                    <div class="menu-item">
                                        <i class="fa fa-coffee" style="font-size: 40px; color: #CD853F;"></i>
                                        <h5>Cappuccino</h5>
                                        <p class="price">50,000đ</p>
                                    </div>
                                </div>
                                <div class="col-xs-6">
                                    <div class="menu-item">
                                        <i class="fa fa-coffee" style="font-size: 40px; color: #DEB887;"></i>
                                        <h5>Latte</h5>
                                        <p class="price">55,000đ</p>
                                    </div>
                                </div>
                            </div>
                        </div>
                        <div class="box-footer">
                            <a href="javascript:void(0)" class="btn btn-info btn-block">
                                <i class="fa fa-list"></i> Xem menu đầy đủ
                            </a>
                        </div>
                    </div>
                    
                    <!-- Quick Actions -->
                    <div class="box box-success">
                        <div class="box-header with-border">
                            <h3 class="box-title"><i class="fa fa-bolt"></i> Thao tác nhanh</h3>
                        </div>
                        <div class="box-body">
                            <a href="javascript:void(0)" class="btn btn-app">
                                <i class="fa fa-plus"></i> Đơn mới
                            </a>
                            <a href="javascript:void(0)" class="btn btn-app">
                                <i class="fa fa-list"></i> Lịch sử
                            </a>
                            <a href="javascript:void(0)" class="btn btn-app">
                                <i class="fa fa-clock-o"></i> Ca làm việc
                            </a>
                            <a href="javascript:void(0)" class="btn btn-app">
                                <i class="fa fa-calendar"></i> Lịch trình
                            </a>
                        </div>
                    </div>
                    
                    <!-- Today's Schedule -->
                    <div class="box box-warning">
                        <div class="box-header with-border">
                            <h3 class="box-title"><i class="fa fa-calendar"></i> Lịch hôm nay</h3>
                        </div>
                        <div class="box-body">
                            <ul class="list-unstyled">
                                <li>
                                    <i class="fa fa-clock-o text-blue"></i> <strong>06:00</strong> - Bắt đầu ca sáng
                                </li>
                                <li>
                                    <i class="fa fa-coffee text-brown"></i> <strong>07:00</strong> - Chuẩn bị máy móc
                                </li>
                                <li>
                                    <i class="fa fa-users text-green"></i> <strong>08:00</strong> - Rush hour sáng
                                </li>
                                <li>
                                    <i class="fa fa-cutlery text-orange"></i> <strong>12:00</strong> - Nghỉ trưa
                                </li>
                                <li>
                                    <i class="fa fa-home text-red"></i> <strong>14:00</strong> - Kết thúc ca
                                </li>
                            </ul>
                        </div>
                    </div>
                </div>
            </div>

            <!-- Performance Today -->
            <div class="row">
                <div class="col-md-12">
                    <div class="box box-success">
                        <div class="box-header with-border">
                            <h3 class="box-title"><i class="fa fa-bar-chart"></i> Hiệu suất làm việc hôm nay</h3>
                        </div>
                        <div class="box-body">
                            <div class="row">
                                <div class="col-md-3 col-sm-6">
                                    <div class="info-box bg-green">
                                        <span class="info-box-icon"><i class="fa fa-trophy"></i></span>
                                        <div class="info-box-content">
                                            <span class="info-box-text">Thời gian trung bình</span>
                                            <span class="info-box-number">4.2 phút</span>
                                            <div class="progress">
                                                <div class="progress-bar" style="width: 85%"></div>
                                            </div>
                                            <span class="progress-description">Tốt hơn mục tiêu</span>
                                        </div>
                                    </div>
                                </div>
                                
                                <div class="col-md-3 col-sm-6">
                                    <div class="info-box bg-blue">
                                        <span class="info-box-icon"><i class="fa fa-heart"></i></span>
                                        <div class="info-box-content">
                                            <span class="info-box-text">Đánh giá khách hàng</span>
                                            <span class="info-box-number">4.8/5</span>
                                            <div class="progress">
                                                <div class="progress-bar" style="width: 96%"></div>
                                            </div>
                                            <span class="progress-description">Xuất sắc</span>
                                        </div>
                                    </div>
                                </div>
                                
                                <div class="col-md-3 col-sm-6">
                                    <div class="info-box bg-yellow">
                                        <span class="info-box-icon"><i class="fa fa-star"></i></span>
                                        <div class="info-box-content">
                                            <span class="info-box-text">Tỷ lệ hoàn thành</span>
                                            <span class="info-box-number">95%</span>
                                            <div class="progress">
                                                <div class="progress-bar" style="width: 95%"></div>
                                            </div>
                                            <span class="progress-description">Rất tốt</span>
                                        </div>
                                    </div>
                                </div>
                                
                                <div class="col-md-3 col-sm-6">
                                    <div class="info-box bg-purple">
                                        <span class="info-box-icon"><i class="fa fa-gift"></i></span>
                                        <div class="info-box-content">
                                            <span class="info-box-text">Thưởng hiệu suất</span>
                                            <span class="info-box-number">+50K</span>
                                            <div class="progress">
                                                <div class="progress-bar" style="width: 75%"></div>
                                            </div>
                                            <span class="progress-description">Đạt mục tiêu</span>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
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
    // Update current time
    function updateTime() {
        const now = new Date();
        const timeString = now.toLocaleTimeString('vi-VN');
        document.getElementById('currentTime').textContent = timeString;
    }
    
    // Update time every second
    setInterval(updateTime, 1000);
    updateTime(); // Initial call
    
    // Simulate order status updates
    function simulateOrderUpdates() {
        // This would typically be done via WebSocket or AJAX calls
        console.log("Checking for new orders...");
    }
    
    // Check for updates every 30 seconds
    setInterval(simulateOrderUpdates, 30000);
</script>

</body>
</html>