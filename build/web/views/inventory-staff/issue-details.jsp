<%@page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="utf-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <title>Chi tiết vấn đề - Coffee Shop</title>
    <meta content="width=device-width, initial-scale=1, maximum-scale=1, user-scalable=no" name="viewport">
    <!-- Bootstrap 3.3.6 -->
    <link rel="stylesheet" href="${pageContext.request.contextPath}/bootstrap/css/bootstrap.min.css">
    <!-- Font Awesome -->
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/4.5.0/css/font-awesome.min.css">
    <!-- Theme style -->
    <link rel="stylesheet" href="${pageContext.request.contextPath}/dist/css/AdminLTE.min.css">
    <!-- AdminLTE Skins -->
    <link rel="stylesheet" href="${pageContext.request.contextPath}/dist/css/skins/_all-skins.min.css">
    <style>
        .detail-box {
            background: #fff;
            padding: 20px;
            border-radius: 8px;
            box-shadow: 0 2px 4px rgba(0,0,0,0.1);
            margin-bottom: 20px;
        }
        
        .info-row {
            padding: 10px 0;
            border-bottom: 1px solid #f0f0f0;
        }
        
        .info-row:last-child {
            border-bottom: none;
        }
        
        .info-label {
            font-weight: bold;
            color: #666;
        }
        
        .info-value {
            color: #333;
        }
        
        .status-badge {
            padding: 8px 15px;
            border-radius: 4px;
            font-size: 14px;
            display: inline-block;
        }
        
        .status-reported {
            background-color: #fee;
            color: #c00;
            border: 1px solid #fcc;
        }
        
        .status-investigation {
            background-color: #fff3cd;
            color: #856404;
            border: 1px solid #ffeaa7;
        }
        
        .status-resolved {
            background-color: #d4edda;
            color: #155724;
            border: 1px solid #c3e6cb;
        }
        
        .status-rejected {
            background-color: #e2e3e5;
            color: #383d41;
            border: 1px solid #d6d8db;
        }
    </style>
</head>
<body class="hold-transition skin-blue sidebar-mini">
    <div class="wrapper">
        <%@include file="../compoment/sidebar.jsp" %>
        <%@include file="../compoment/header.jsp" %>
        
        <div class="content-wrapper">
            <section class="content-header">
                <h1>
                    Chi tiết vấn đề
                    <small>Thông tin chi tiết vấn đề #${issue.issueID}</small>
                </h1>
                <ol class="breadcrumb">
                    <li><a href="${pageContext.request.contextPath}/inventory-dashboard"><i class="fa fa-dashboard"></i> Dashboard</a></li>
                    <li><a href="${pageContext.request.contextPath}/issue?action=list">Quản lý vấn đề</a></li>
                    <li class="active">Chi tiết vấn đề</li>
                </ol>
            </section>

            <section class="content">
                <!-- Success Alert -->
                <c:if test="${param.success eq '2'}">
                    <div class="alert alert-success alert-dismissible">
                        <button type="button" class="close" data-dismiss="alert" aria-hidden="true">&times;</button>
                        <h4><i class="icon fa fa-check"></i> Thành công!</h4>
                        Cập nhật vấn đề thành công
                    </div>
                </c:if>

                <div class="row">
                    <div class="col-md-8">
                        <!-- Issue Information -->
                        <div class="box box-primary">
                            <div class="box-header with-border">
                                <h3 class="box-title">Thông tin vấn đề</h3>
                            </div>
                            <div class="box-body">
                                <div class="info-row">
                                    <div class="row">
                                        <div class="col-md-4 info-label">ID vấn đề:</div>
                                        <div class="col-md-8 info-value">#${issue.issueID}</div>
                                    </div>
                                </div>
                                
                                <div class="info-row">
                                    <div class="row">
                                        <div class="col-md-4 info-label">Nguyên liệu:</div>
                                        <div class="col-md-8 info-value">
                                            <strong>${issue.ingredientName}</strong>
                                        </div>
                                    </div>
                                </div>
                                
                                <div class="info-row">
                                    <div class="row">
                                        <div class="col-md-4 info-label">Mô tả vấn đề:</div>
                                        <div class="col-md-8 info-value">
                                            ${issue.description}
                                        </div>
                                    </div>
                                </div>
                                
                                <div class="info-row">
                                    <div class="row">
                                        <div class="col-md-4 info-label">Số lượng bị ảnh hưởng:</div>
                                        <div class="col-md-8 info-value">
                                            <strong>
                                                <fmt:formatNumber value="${issue.quantity}" pattern="#,##0.##"/> 
                                                ${issue.unitName}
                                            </strong>
                                        </div>
                                    </div>
                                </div>
                                
                                <div class="info-row">
                                    <div class="row">
                                        <div class="col-md-4 info-label">Trạng thái:</div>
                                        <div class="col-md-8 info-value">
                                            <c:choose>
                                                <c:when test="${issue.statusName eq 'Reported'}">
                                                    <span class="status-badge status-reported">
                                                        <i class="fa fa-exclamation-circle"></i> ${issue.statusName}
                                                    </span>
                                                </c:when>
                                                <c:when test="${issue.statusName eq 'Under Investigation'}">
                                                    <span class="status-badge status-investigation">
                                                        <i class="fa fa-search"></i> ${issue.statusName}
                                                    </span>
                                                </c:when>
                                                <c:when test="${issue.statusName eq 'Resolved'}">
                                                    <span class="status-badge status-resolved">
                                                        <i class="fa fa-check-circle"></i> ${issue.statusName}
                                                    </span>
                                                </c:when>
                                                <c:otherwise>
                                                    <span class="status-badge status-rejected">
                                                        <i class="fa fa-times-circle"></i> ${issue.statusName}
                                                    </span>
                                                </c:otherwise>
                                            </c:choose>
                                        </div>
                                    </div>
                                </div>
                                
                                <div class="info-row">
                                    <div class="row">
                                        <div class="col-md-4 info-label">Người báo cáo:</div>
                                        <div class="col-md-8 info-value">
                                            <i class="fa fa-user"></i> ${issue.createdByName}
                                        </div>
                                    </div>
                                </div>
                                
                                <div class="info-row">
                                    <div class="row">
                                        <div class="col-md-4 info-label">Ngày báo cáo:</div>
                                        <div class="col-md-8 info-value">
                                            <i class="fa fa-calendar"></i> 
                                            <fmt:formatDate value="${issue.createdAt}" pattern="dd/MM/yyyy HH:mm:ss"/>
                                        </div>
                                    </div>
                                </div>
                                
                                <c:if test="${not empty issue.confirmedByName}">
                                    <div class="info-row">
                                        <div class="row">
                                            <div class="col-md-4 info-label">Người xác nhận:</div>
                                            <div class="col-md-8 info-value">
                                                <i class="fa fa-user-check"></i> ${issue.confirmedByName}
                                            </div>
                                        </div>
                                    </div>
                                </c:if>
                            </div>
                            
                            <div class="box-footer">
                                <a href="${pageContext.request.contextPath}/issue?action=edit&id=${issue.issueID}" 
                                   class="btn btn-warning">
                                    <i class="fa fa-edit"></i> Chỉnh sửa
                                </a>
                                <a href="${pageContext.request.contextPath}/issue?action=list" 
                                   class="btn btn-default pull-right">
                                    <i class="fa fa-arrow-left"></i> Quay lại danh sách
                                </a>
                            </div>
                        </div>
                    </div>
                    
                    <div class="col-md-4">
                        <!-- Quick Actions -->
                        <div class="box box-success">
                            <div class="box-header with-border">
                                <h3 class="box-title">Thao tác nhanh</h3>
                            </div>
                            <div class="box-body">
                                <a href="${pageContext.request.contextPath}/ingredient?action=view&id=${issue.ingredientID}" 
                                   class="btn btn-block btn-info">
                                    <i class="fa fa-box"></i> Xem thông tin nguyên liệu
                                </a>
                                <a href="${pageContext.request.contextPath}/issue?action=create" 
                                   class="btn btn-block btn-success">
                                    <i class="fa fa-plus"></i> Thêm vấn đề mới
                                </a>
                                <a href="${pageContext.request.contextPath}/issue?action=list&ingredientFilter=${issue.ingredientID}" 
                                   class="btn btn-block btn-default">
                                    <i class="fa fa-filter"></i> Xem các vấn đề khác của nguyên liệu này
                                </a>
                            </div>
                        </div>
                        
                        <!-- Status Guide -->
                        <div class="box box-info">
                            <div class="box-header with-border">
                                <h3 class="box-title">Hướng dẫn trạng thái</h3>
                            </div>
                            <div class="box-body">
                                <p><strong>Reported (Đã báo cáo):</strong><br>
                                   Vấn đề vừa được báo cáo và chờ xử lý</p>
                                
                                <p><strong>Under Investigation:</strong><br>
                                   Đang điều tra và xác minh vấn đề</p>
                                
                                <p><strong>Resolved (Đã giải quyết):</strong><br>
                                   Vấn đề đã được xử lý xong</p>
                                
                                <p><strong>Rejected (Từ chối):</strong><br>
                                   Vấn đề không hợp lệ hoặc không cần xử lý</p>
                            </div>
                        </div>
                    </div>
                </div>
            </section>
        </div>

        <%@include file="../compoment/footer.jsp" %>
    </div>

    <!-- jQuery 2.2.0 -->
    <script src="${pageContext.request.contextPath}/bootstrap/js/jquery-2.2.0.min.js"></script>
    <!-- Bootstrap 3.3.6 -->
    <script src="${pageContext.request.contextPath}/bootstrap/js/bootstrap.min.js"></script>
    
    <script>
        // Auto dismiss alerts after 5 seconds
        setTimeout(function() {
            $('.alert').fadeOut('slow');
        }, 5000);
    </script>
</body>
</html>
