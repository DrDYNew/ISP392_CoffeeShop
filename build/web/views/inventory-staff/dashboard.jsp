<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Inventory Dashboard - Coffee Shop Management</title>
    
    <!-- Bootstrap CSS -->
    <link href="${pageContext.request.contextPath}/bootstrap/css/bootstrap.min.css" rel="stylesheet">
    
    <!-- Custom Dashboard CSS -->
    <link href="${pageContext.request.contextPath}/css/dashboard.css" rel="stylesheet">
    
    <!-- Font Awesome -->
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
</head>
<body class="role-inventory">
    <div class="dashboard-container">
        <!-- Include Sidebar -->
        <%@include file="../compoment/sidebar.jsp" %>
        
        <!-- Main Content -->
        <div class="main-content">
            <!-- Include Header -->
            <%@include file="../compoment/header.jsp" %>
            
            <!-- Content Area -->
            <div class="content-area">
                <!-- Welcome Section -->
                <div class="welcome-section mb-4">
                    <h2>Chào mừng, ${sessionScope.user.fullName}!</h2>
                    <p class="text-muted">Quản lý kho - Theo dõi tồn kho và nhập hàng</p>
                </div>
                
                <!-- Statistics Cards -->
                <div class="stats-grid">
                    <div class="stat-card">
                        <div class="stat-icon primary">
                            <i class="fas fa-boxes"></i>
                        </div>
                        <div class="stat-value">18</div>
                        <div class="stat-label">Loại nguyên liệu</div>
                        <div class="stat-change positive">
                            <i class="fas fa-arrow-up"></i>
                            <span>100% đang quản lý</span>
                        </div>
                    </div>
                    
                    <div class="stat-card">
                        <div class="stat-icon warning">
                            <i class="fas fa-exclamation-triangle"></i>
                        </div>
                        <div class="stat-value">3</div>
                        <div class="stat-label">Nguyên liệu sắp hết</div>
                        <div class="stat-change negative">
                            <i class="fas fa-arrow-down"></i>
                            <span>Cần nhập thêm</span>
                        </div>
                    </div>
                    
                    <div class="stat-card">
                        <div class="stat-icon success">
                            <i class="fas fa-shopping-cart"></i>
                        </div>
                        <div class="stat-value">5</div>
                        <div class="stat-label">Đơn nhập hàng</div>
                        <div class="stat-change positive">
                            <i class="fas fa-arrow-up"></i>
                            <span>2 đang chờ duyệt</span>
                        </div>
                    </div>
                    
                    <div class="stat-card">
                        <div class="stat-icon danger">
                            <i class="fas fa-bug"></i>
                        </div>
                        <div class="stat-value">2</div>
                        <div class="stat-label">Sự cố báo cáo</div>
                        <div class="stat-change">
                            <i class="fas fa-minus"></i>
                            <span>1 đang xử lý</span>
                        </div>
                    </div>
                </div>
                
                <!-- Quick Actions -->
                <div class="dashboard-card">
                    <div class="card-header">
                        <h5 class="card-title">Thao tác nhanh</h5>
                    </div>
                    <div class="card-body">
                        <div class="quick-actions">
                            <a href="#" class="quick-action">
                                <div class="quick-action-icon" style="background: var(--success-color);">
                                    <i class="fas fa-plus"></i>
                                </div>
                                <div class="quick-action-content">
                                    <h6>Tạo đơn nhập hàng</h6>
                                    <p>Đặt hàng từ nhà cung cấp</p>
                                </div>
                            </a>
                            
                            <a href="#" class="quick-action">
                                <div class="quick-action-icon" style="background: var(--warning-color);">
                                    <i class="fas fa-exclamation-triangle"></i>
                                </div>
                                <div class="quick-action-content">
                                    <h6>Báo cáo sự cố</h6>
                                    <p>Báo nguyên liệu hỏng/hết hạn</p>
                                </div>
                            </a>
                            
                            <a href="#" class="quick-action">
                                <div class="quick-action-icon" style="background: var(--info-color);">
                                    <i class="fas fa-clipboard-check"></i>
                                </div>
                                <div class="quick-action-content">
                                    <h6>Kiểm kho</h6>
                                    <p>Kiểm tra tồn kho định kỳ</p>
                                </div>
                            </a>
                            
                            <a href="#" class="quick-action">
                                <div class="quick-action-icon" style="background: var(--primary-color);">
                                    <i class="fas fa-truck"></i>
                                </div>
                                <div class="quick-action-content">
                                    <h6>Nhà cung cấp</h6>
                                    <p>Quản lý nhà cung cấp</p>
                                </div>
                            </a>
                        </div>
                    </div>
                </div>
                
                <div class="row">
                    <!-- Low Stock Alert -->
                    <div class="col-lg-6">
                        <div class="dashboard-card">
                            <div class="card-header">
                                <h5 class="card-title">
                                    <i class="fas fa-exclamation-triangle text-warning"></i>
                                    Nguyên liệu sắp hết
                                </h5>
                            </div>
                            <div class="card-body">
                                <div class="table-responsive">
                                    <table class="dashboard-table">
                                        <thead>
                                            <tr>
                                                <th>Nguyên liệu</th>
                                                <th>Tồn kho</th>
                                                <th>Đơn vị</th>
                                                <th>Mức cảnh báo</th>
                                                <th>Hành động</th>
                                            </tr>
                                        </thead>
                                        <tbody>
                                            <tr>
                                                <td>Cà phê Arabica hạt</td>
                                                <td class="text-danger"><strong>5.0</strong></td>
                                                <td>kg</td>
                                                <td>10.0 kg</td>
                                                <td>
                                                    <button class="btn btn-sm btn-warning">
                                                        <i class="fas fa-shopping-cart"></i> Đặt hàng
                                                    </button>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td>Sữa tươi nguyên kem</td>
                                                <td class="text-warning"><strong>15.0</strong></td>
                                                <td>L</td>
                                                <td>20.0 L</td>
                                                <td>
                                                    <button class="btn btn-sm btn-warning">
                                                        <i class="fas fa-shopping-cart"></i> Đặt hàng
                                                    </button>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td>Đường trắng</td>
                                                <td class="text-danger"><strong>3.0</strong></td>
                                                <td>kg</td>
                                                <td>5.0 kg</td>
                                                <td>
                                                    <button class="btn btn-sm btn-warning">
                                                        <i class="fas fa-shopping-cart"></i> Đặt hàng
                                                    </button>
                                                </td>
                                            </tr>
                                        </tbody>
                                    </table>
                                </div>
                            </div>
                        </div>
                    </div>
                    
                    <!-- Recent Purchase Orders -->
                    <div class="col-lg-6">
                        <div class="dashboard-card">
                            <div class="card-header">
                                <h5 class="card-title">Đơn nhập hàng gần đây</h5>
                            </div>
                            <div class="card-body">
                                <div class="table-responsive">
                                    <table class="dashboard-table">
                                        <thead>
                                            <tr>
                                                <th>Mã đơn</th>
                                                <th>Nhà cung cấp</th>
                                                <th>Ngày tạo</th>
                                                <th>Trạng thái</th>
                                            </tr>
                                        </thead>
                                        <tbody>
                                            <tr>
                                                <td><strong>PO001</strong></td>
                                                <td>Highlands Coffee</td>
                                                <td>03/10/2025</td>
                                                <td><span class="badge badge-success">Đã nhận</span></td>
                                            </tr>
                                            <tr>
                                                <td><strong>PO002</strong></td>
                                                <td>TH True Milk</td>
                                                <td>02/10/2025</td>
                                                <td><span class="badge badge-info">Đang giao</span></td>
                                            </tr>
                                            <tr>
                                                <td><strong>PO003</strong></td>
                                                <td>Trung Nguyên</td>
                                                <td>01/10/2025</td>
                                                <td><span class="badge badge-warning">Đã duyệt</span></td>
                                            </tr>
                                            <tr>
                                                <td><strong>PO004</strong></td>
                                                <td>Kinh Đô</td>
                                                <td>30/09/2025</td>
                                                <td><span class="badge badge-secondary">Chờ duyệt</span></td>
                                            </tr>
                                        </tbody>
                                    </table>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
                
                <div class="row mt-4">
                    <!-- Supplier Contact -->
                    <div class="col-lg-4">
                        <div class="dashboard-card">
                            <div class="card-header">
                                <h5 class="card-title">Nhà cung cấp chính</h5>
                            </div>
                            <div class="card-body">
                                <div class="supplier-list">
                                    <div class="supplier-item">
                                        <div class="supplier-info">
                                            <h6>Highlands Coffee</h6>
                                            <p>Cà phê & Gia vị</p>
                                            <small class="text-muted">
                                                <i class="fas fa-phone"></i> 0901234567
                                            </small>
                                        </div>
                                        <div class="supplier-actions">
                                            <button class="btn btn-sm btn-outline-primary">
                                                <i class="fas fa-phone"></i>
                                            </button>
                                        </div>
                                    </div>
                                    
                                    <div class="supplier-item">
                                        <div class="supplier-info">
                                            <h6>TH True Milk</h6>
                                            <p>Sản phẩm sữa</p>
                                            <small class="text-muted">
                                                <i class="fas fa-phone"></i> 0923456789
                                            </small>
                                        </div>
                                        <div class="supplier-actions">
                                            <button class="btn btn-sm btn-outline-primary">
                                                <i class="fas fa-phone"></i>
                                            </button>
                                        </div>
                                    </div>
                                    
                                    <div class="supplier-item">
                                        <div class="supplier-info">
                                            <h6>Kinh Đô</h6>
                                            <p>Bánh kẹo & Nguyên liệu</p>
                                            <small class="text-muted">
                                                <i class="fas fa-phone"></i> 0934567890
                                            </small>
                                        </div>
                                        <div class="supplier-actions">
                                            <button class="btn btn-sm btn-outline-primary">
                                                <i class="fas fa-phone"></i>
                                            </button>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                    
                    <!-- Recent Issues -->
                    <div class="col-lg-8">
                        <div class="dashboard-card">
                            <div class="card-header">
                                <h5 class="card-title">Sự cố và báo cáo</h5>
                            </div>
                            <div class="card-body">
                                <div class="table-responsive">
                                    <table class="dashboard-table">
                                        <thead>
                                            <tr>
                                                <th>Nguyên liệu</th>
                                                <th>Vấn đề</th>
                                                <th>Người báo cáo</th>
                                                <th>Ngày báo cáo</th>
                                                <th>Trạng thái</th>
                                                <th>Hành động</th>
                                            </tr>
                                        </thead>
                                        <tbody>
                                            <tr>
                                                <td>Cà phê Arabica</td>
                                                <td>Bị ẩm mốc (2.5kg)</td>
                                                <td>Phạm Thị Linh</td>
                                                <td>02/10/2025</td>
                                                <td><span class="badge badge-success">Đã xử lý</span></td>
                                                <td>
                                                    <button class="btn btn-sm btn-outline-success">
                                                        <i class="fas fa-check"></i>
                                                    </button>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td>Sữa tươi</td>
                                                <td>Hết hạn (5L)</td>
                                                <td>Hoàng Minh Tú</td>
                                                <td>03/10/2025</td>
                                                <td><span class="badge badge-warning">Đang xử lý</span></td>
                                                <td>
                                                    <button class="btn btn-sm btn-warning">
                                                        <i class="fas fa-cog"></i>
                                                    </button>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td>Đường trắng</td>
                                                <td>Bị vón cục (1kg)</td>
                                                <td>Vũ Thị Nam</td>
                                                <td>01/10/2025</td>
                                                <td><span class="badge badge-info">Đang điều tra</span></td>
                                                <td>
                                                    <button class="btn btn-sm btn-info">
                                                        <i class="fas fa-search"></i>
                                                    </button>
                                                </td>
                                            </tr>
                                        </tbody>
                                    </table>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
    
    <!-- Bootstrap JS -->
    <script src="${pageContext.request.contextPath}/bootstrap/js/bootstrap.bundle.min.js"></script>
    
    <!-- Custom Dashboard JS -->
    <script src="${pageContext.request.contextPath}/js/dashboard.js"></script>
    
    <style>
        .supplier-list .supplier-item {
            display: flex;
            align-items: center;
            justify-content: space-between;
            padding: 15px 0;
            border-bottom: 1px solid #edf2f7;
        }
        
        .supplier-list .supplier-item:last-child {
            border-bottom: none;
        }
        
        .supplier-info h6 {
            margin: 0 0 5px 0;
            font-weight: 600;
            font-size: 0.9rem;
        }
        
        .supplier-info p {
            margin: 0 0 5px 0;
            font-size: 0.8rem;
            color: #718096;
        }
        
        .supplier-info small {
            font-size: 0.75rem;
        }
        
        .text-warning {
            color: #ed8936 !important;
        }
        
        .text-danger {
            color: #f56565 !important;
        }
    </style>
</body>
</html>