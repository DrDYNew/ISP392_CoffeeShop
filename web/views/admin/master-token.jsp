<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <title>Master API Token - Admin | Coffee Shop</title>
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
    <!-- Shop Management CSS -->
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/shop-management.css">
</head>
<body class="hold-transition skin-blue sidebar-mini">
    <div class="wrapper">
        <!-- Header -->
        <jsp:include page="../compoment/header.jsp" />
        
        <!-- Sidebar -->
        <jsp:include page="../compoment/sidebar.jsp" />

        <!-- Content Wrapper -->
        <div class="content-wrapper">
            <section class="content-header">
                <h1>
                    <i class="fa fa-key"></i> Master API Token
                    <small>Quản lý Master Token cho hệ thống</small>
                </h1>
                <ol class="breadcrumb">
                    <li><a href="${pageContext.request.contextPath}/admin/dashboard"><i class="fa fa-dashboard"></i> Trang chủ</a></li>
                    <li class="active">Master API Token</li>
                </ol>
            </section>

            <section class="content">
                <!-- Success/Error Messages -->
                <c:if test="${not empty success}">
                    <div class="alert alert-success alert-dismissible">
                        <button type="button" class="close" data-dismiss="alert">&times;</button>
                        <i class="fa fa-check-circle"></i> ${success}
                    </div>
                </c:if>
                
                <c:if test="${not empty error}">
                    <div class="alert alert-danger alert-dismissible">
                        <button type="button" class="close" data-dismiss="alert">&times;</button>
                        <i class="fa fa-ban"></i> ${error}
                    </div>
                </c:if>

                <div class="row">
                    <div class="col-md-8 col-md-offset-2">
                        <!-- Master Token Info Box -->
                        <div class="box box-warning">
                            <div class="box-header with-border">
                                <h3 class="box-title">
                                    <i class="fa fa-shield"></i> Master API Token Hiện Tại
                                </h3>
                            </div>
                            <div class="box-body">
                                <div class="callout callout-warning">
                                    <h4><i class="fa fa-warning"></i> Cảnh Báo Bảo Mật</h4>
                                    <p><strong>Master API Token</strong> cho phép truy cập vào <strong>TẤT CẢ</strong> thông tin shop trong hệ thống.</p>
                                    <p>Vui lòng:</p>
                                    <ul>
                                        <li>Giữ bí mật và không chia sẻ công khai</li>
                                        <li>Chỉ cung cấp cho nhân viên HR có thẩm quyền</li>
                                        <li>Định kỳ tạo lại token mới để đảm bảo bảo mật</li>
                                    </ul>
                                </div>

                                <div class="form-group">
                                    <label for="masterToken">
                                        <i class="fa fa-key"></i> Master API Token:
                                    </label>
                                    <div class="input-group">
                                        <input type="password" class="form-control input-lg api-token-text masked" 
                                               id="masterToken" value="${masterToken}" readonly>
                                        <span class="input-group-btn">
                                            <button class="btn btn-default btn-lg" type="button" 
                                                    onclick="toggleTokenVisibility()" title="Hiện/Ẩn token">
                                                <i class="fa fa-eye" id="toggleIcon"></i>
                                            </button>
                                            <button class="btn btn-success btn-lg" type="button" 
                                                    onclick="copyToken()" title="Copy token">
                                                <i class="fa fa-copy"></i> Copy
                                            </button>
                                        </span>
                                    </div>
                                </div>

                                <!-- Token Statistics -->
                                <div class="row">
                                    <div class="col-md-6">
                                        <div class="info-box bg-aqua">
                                            <span class="info-box-icon"><i class="fa fa-building"></i></span>
                                            <div class="info-box-content">
                                                <span class="info-box-text">Phạm Vi Truy Cập</span>
                                                <span class="info-box-number">Tất Cả Shops</span>
                                            </div>
                                        </div>
                                    </div>
                                    <div class="col-md-6">
                                        <div class="info-box bg-green">
                                            <span class="info-box-icon"><i class="fa fa-users"></i></span>
                                            <div class="info-box-content">
                                                <span class="info-box-text">Dành Cho</span>
                                                <span class="info-box-number">HR & Admin</span>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>

                        <!-- Regenerate Token Box -->
                        <div class="box box-danger">
                            <div class="box-header with-border">
                                <h3 class="box-title">
                                    <i class="fa fa-refresh"></i> Tạo Lại Master Token
                                </h3>
                            </div>
                            <form method="post" action="${pageContext.request.contextPath}/admin/master-token" 
                                  onsubmit="return confirmRegenerate()">
                                <div class="box-body">
                                    <input type="hidden" name="action" value="regenerate">
                                    
                                    <div class="callout callout-danger">
                                        <h4><i class="fa fa-exclamation-triangle"></i> Lưu Ý Quan Trọng</h4>
                                        <p>Khi tạo lại Master Token mới:</p>
                                        <ul>
                                            <li><strong>Token cũ sẽ NGAY LẬP TỨC bị vô hiệu hóa</strong></li>
                                            <li>Tất cả nhân viên HR đang sử dụng token cũ sẽ không thể truy cập</li>
                                            <li>Bạn cần cung cấp token mới cho tất cả nhân viên HR</li>
                                        </ul>
                                        <p class="text-bold">Chỉ thực hiện khi thực sự cần thiết!</p>
                                    </div>

                                    <div class="alert alert-info">
                                        <h4><i class="fa fa-info-circle"></i> Khi Nào Nên Tạo Lại Token?</h4>
                                        <ul>
                                            <li>Token bị lộ hoặc nghi ngờ bị lộ</li>
                                            <li>Nhân viên có quyền truy cập nghỉ việc</li>
                                            <li>Định kỳ bảo trì bảo mật (khuyến nghị 6 tháng/lần)</li>
                                            <li>Phát hiện truy cập bất thường</li>
                                        </ul>
                                    </div>
                                </div>
                                <div class="box-footer">
                                    <button type="submit" class="btn btn-danger btn-lg btn-block">
                                        <i class="fa fa-refresh"></i> Tạo Lại Master Token Mới
                                    </button>
                                </div>
                            </form>
                        </div>

                        <!-- Usage Instructions -->
                        <div class="box box-info collapsed-box">
                            <div class="box-header with-border">
                                <h3 class="box-title">
                                    <i class="fa fa-question-circle"></i> Hướng Dẫn Sử Dụng
                                </h3>
                                <div class="box-tools pull-right">
                                    <button type="button" class="btn btn-box-tool" data-widget="collapse">
                                        <i class="fa fa-plus"></i>
                                    </button>
                                </div>
                            </div>
                            <div class="box-body">
                                <h4><strong>Cho Nhân Viên HR:</strong></h4>
                                <ol>
                                    <li>Truy cập menu <strong>"Thông tin Shop" → "Danh sách Shop"</strong></li>
                                    <li>Nhập Master API Token vào form xác thực</li>
                                    <li>Nhấn <strong>"Xem Danh Sách Shop"</strong></li>
                                    <li>Hệ thống sẽ hiển thị tất cả shops đang hoạt động</li>
                                </ol>

                                <h4><strong>Cấp Quyền Cho HR Mới:</strong></h4>
                                <ol>
                                    <li>Click nút <strong>"Copy"</strong> để copy Master Token</li>
                                    <li>Gửi token cho nhân viên HR qua kênh bảo mật</li>
                                    <li>Hướng dẫn nhân viên cách sử dụng token</li>
                                    <li>Nhắc nhở về chính sách bảo mật</li>
                                </ol>

                                <h4><strong>Quản Lý Bảo Mật:</strong></h4>
                                <ul>
                                    <li>Kiểm tra log truy cập định kỳ</li>
                                    <li>Tạo lại token khi có nhân viên nghỉ việc</li>
                                    <li>Không lưu token vào email, chat công khai</li>
                                    <li>Sử dụng kênh mã hóa khi chia sẻ</li>
                                </ul>
                            </div>
                        </div>

                        <!-- Back Button -->
                        <div class="text-center">
                            <a href="${pageContext.request.contextPath}/admin/dashboard" 
                               class="btn btn-default btn-lg">
                                <i class="fa fa-arrow-left"></i> Quay Lại Dashboard
                            </a>
                        </div>
                    </div>
                </div>
            </section>
        </div>
        <!-- /.content-wrapper -->
    </div>
    <!-- ./wrapper -->

    <!-- jQuery 3.6.0 -->
    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
    <!-- Bootstrap 3.3.6 -->
    <script src="${pageContext.request.contextPath}/bootstrap/js/bootstrap.min.js"></script>
    <!-- AdminLTE App -->
    <script src="${pageContext.request.contextPath}/dist/js/app.min.js"></script>
    
    <script>
        function toggleTokenVisibility() {
            const input = document.getElementById('masterToken');
            const icon = document.getElementById('toggleIcon');
            
            if (input.type === 'password') {
                input.type = 'text';
                input.classList.remove('masked');
                icon.className = 'fa fa-eye-slash';
            } else {
                input.type = 'password';
                input.classList.add('masked');
                icon.className = 'fa fa-eye';
            }
        }
        
        function copyToken() {
            const input = document.getElementById('masterToken');
            const originalType = input.type;
            
            // Tạm thời chuyển sang text để copy
            input.type = 'text';
            input.select();
            input.setSelectionRange(0, 99999); // For mobile devices
            
            try {
                document.execCommand('copy');
                
                // Show success notification
                const btn = event.target.closest('button');
                const originalHTML = btn.innerHTML;
                btn.innerHTML = '<i class="fa fa-check"></i> Đã Copy!';
                btn.classList.remove('btn-success');
                btn.classList.add('btn-primary');
                
                setTimeout(function() {
                    btn.innerHTML = originalHTML;
                    btn.classList.remove('btn-primary');
                    btn.classList.add('btn-success');
                }, 2000);
                
            } catch (err) {
                alert('✗ Không thể copy token. Vui lòng copy thủ công.');
            }
            
            // Chuyển lại về password
            input.type = originalType;
            window.getSelection().removeAllRanges();
        }
        
        function confirmRegenerate() {
            return confirm(
                '⚠️ CẢNH BÁO: Bạn có chắc chắn muốn tạo lại Master Token?\n\n' +
                '- Token cũ sẽ NGAY LẬP TỨC không còn hoạt động\n' +
                '- Tất cả HR đang dùng token cũ sẽ bị mất quyền truy cập\n' +
                '- Bạn phải cấp token mới cho tất cả HR\n\n' +
                'Nhấn OK để tiếp tục, Cancel để hủy.'
            );
        }

        // Auto dismiss alerts after 5 seconds
        setTimeout(function() {
            $('.alert').fadeOut('slow');
        }, 5000);
    </script>
</body>
</html>
