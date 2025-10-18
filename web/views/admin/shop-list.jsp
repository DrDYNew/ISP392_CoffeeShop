<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <title>Quản Lý Shop - Admin | Coffee Shop</title>
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
            <div class="shop-management-content">
                <!-- Page Header -->
                <div class="shop-page-header">
                    <h1><i class="fa fa-store"></i> Quản Lý Shop</h1>
                    <p>Quản lý danh sách cửa hàng và API Token</p>
                </div>

                <!-- Messages -->
                <c:if test="${not empty sessionScope.message}">
                    <div class="shop-alert shop-alert-${sessionScope.messageType}">
                        <i class="fa fa-${sessionScope.messageType == 'success' ? 'check-circle' : 'exclamation-triangle'}"></i>
                        <span>${sessionScope.message}</span>
                    </div>
                    <c:remove var="message" scope="session"/>
                    <c:remove var="messageType" scope="session"/>
                </c:if>

                <!-- Add Button -->
                <div style="margin-bottom: 20px;">
                    <a href="${pageContext.request.contextPath}/admin/shop?action=add" class="btn-add-shop">
                        <i class="fa fa-plus"></i> Thêm Shop Mới
                    </a>
                </div>

                <!-- Shop List -->
                <c:forEach var="shop" items="${shops}">
                    <div class="shop-card">
                        <div class="shop-card-header">
                            <div class="shop-name">
                                <i class="fa fa-store"></i> ${shop.shopName}
                            </div>
                            <span class="shop-status ${shop.active ? 'status-active' : 'status-inactive'}">
                                ${shop.active ? 'Hoạt động' : 'Ngừng hoạt động'}
                            </span>
                        </div>

                        <div class="shop-info-section">
                            <div class="shop-info-item">
                                <i class="fa fa-map-marker"></i>
                                <div class="shop-info-content">
                                    <div class="shop-info-label">Địa chỉ</div>
                                    <div class="shop-info-value">${shop.address}</div>
                                </div>
                            </div>
                            <div class="shop-info-item">
                                <i class="fa fa-phone"></i>
                                <div class="shop-info-content">
                                    <div class="shop-info-label">Điện thoại</div>
                                    <div class="shop-info-value">${shop.phone}</div>
                                </div>
                            </div>
                            <div class="shop-info-item">
                                <i class="fa fa-calendar"></i>
                                <div class="shop-info-content">
                                    <div class="shop-info-label">Ngày tạo</div>
                                    <div class="shop-info-value">${shop.createdAt}</div>
                                </div>
                            </div>
                        </div>

                        <div class="api-token-section">
                            <div class="api-token-header">
                                <i class="fa fa-key"></i>
                                <strong>API Token</strong>
                            </div>
                            <div class="api-token-display">
                                <button class="btn-toggle-token" onclick="toggleToken('token-${shop.shopID}')">
                                    <i class="fa fa-eye"></i> Hiện
                                </button>
                                <div class="api-token-text masked" id="token-${shop.shopID}">${shop.apiToken}</div>
                                <button class="btn-copy-token" onclick="copyToken('token-${shop.shopID}')">
                                    <i class="fa fa-copy"></i> Copy
                                </button>
                            </div>
                        </div>

                        <div class="shop-actions">
                            <a href="${pageContext.request.contextPath}/admin/shop?action=edit&id=${shop.shopID}" 
                               class="btn-shop-action btn-edit">
                                <i class="fa fa-edit"></i> Sửa
                            </a>
                            <a href="${pageContext.request.contextPath}/admin/shop?action=regenerateToken&id=${shop.shopID}" 
                               class="btn-shop-action btn-regenerate"
                               onclick="return confirm('Bạn có chắc muốn tạo lại API Token? Token cũ sẽ không còn hoạt động!')">
                                <i class="fa fa-refresh"></i> Tạo Lại Token
                            </a>
                            <a href="${pageContext.request.contextPath}/admin/shop?action=delete&id=${shop.shopID}" 
                               class="btn-shop-action btn-delete"
                               onclick="return confirm('Bạn có chắc muốn xóa shop này?')">
                                <i class="fa fa-trash"></i> Xóa
                            </a>
                        </div>
                    </div>
                </c:forEach>

                <c:if test="${empty shops}">
                    <div class="shop-empty-state">
                        <i class="fa fa-store"></i>
                        <h3>Chưa có shop nào</h3>
                        <p>Hãy thêm shop mới để bắt đầu quản lý</p>
                        <a href="${pageContext.request.contextPath}/admin/shop?action=add" class="btn-add-shop">
                            <i class="fa fa-plus"></i> Thêm Shop Mới
                        </a>
                    </div>
                </c:if>
            </div>
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
        // Toggle token visibility
        function toggleToken(elementId) {
            const tokenElement = document.getElementById(elementId);
            const button = event.currentTarget;
            const icon = button.querySelector('i');
            
            if (tokenElement.classList.contains('masked')) {
                // Show token
                tokenElement.classList.remove('masked');
                icon.className = 'fa fa-eye-slash';
                button.innerHTML = '<i class="fa fa-eye-slash"></i> Ẩn';
            } else {
                // Hide token
                tokenElement.classList.add('masked');
                icon.className = 'fa fa-eye';
                button.innerHTML = '<i class="fa fa-eye"></i> Hiện';
            }
        }
        
        // Copy token to clipboard
        function copyToken(elementId) {
            const tokenElement = document.getElementById(elementId);
            const token = tokenElement.innerText;
            
            // Modern clipboard API
            if (navigator.clipboard && navigator.clipboard.writeText) {
                navigator.clipboard.writeText(token).then(function() {
                    alert('✓ Token đã được copy vào clipboard!');
                }, function(err) {
                    // Fallback for older browsers
                    copyToClipboardFallback(token);
                });
            } else {
                // Fallback for older browsers
                copyToClipboardFallback(token);
            }
        }
        
        // Fallback method for older browsers
        function copyToClipboardFallback(text) {
            const textArea = document.createElement("textarea");
            textArea.value = text;
            textArea.style.position = "fixed";
            textArea.style.left = "-999999px";
            document.body.appendChild(textArea);
            textArea.focus();
            textArea.select();
            
            try {
                const successful = document.execCommand('copy');
                if (successful) {
                    alert('✓ Token đã được copy vào clipboard!');
                } else {
                    alert('✗ Không thể copy token. Vui lòng copy thủ công.');
                }
            } catch (err) {
                alert('✗ Không thể copy token. Vui lòng copy thủ công.');
            }
            
            document.body.removeChild(textArea);
        }
        
        // Auto-hide alerts after 5 seconds
        $(document).ready(function() {
            setTimeout(function() {
                $('.shop-alert').fadeOut('slow');
            }, 5000);
        });
    </script>
</body>
</html>
