<%@page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="utf-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <title>${mode == 'new' ? 'Thêm' : 'Chỉnh sửa'} nhà cung cấp - Coffee Shop Management</title>
    <meta content="width=device-width, initial-scale=1, maximum-scale=1, user-scalable=no" name="viewport">
    <!-- Bootstrap 3.3.6 từ CDN -->
    <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/css/bootstrap.min.css" integrity="sha384-BVYiiSIFeK1dGmJRAkycuHAHRg32OmUcww7on3RYdg4Va+PmSTsz/K68vbdEjh4u" crossorigin="anonymous">
    <!-- Font Awesome -->
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/4.5.0/css/font-awesome.min.css">
    <!-- Ionicons -->
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/ionicons/2.0.1/css/ionicons.min.css">
    <!-- Theme style -->
    <link rel="stylesheet" href="${pageContext.request.contextPath}/dist/css/AdminLTE.min.css">
    <!-- AdminLTE Skins -->
    <link rel="stylesheet" href="${pageContext.request.contextPath}/dist/css/skins/_all-skins.min.css">
    <!-- Sidebar improvements -->
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/sidebar-improvements.css">
    <!-- jQuery từ CDN - load trước tiên -->
    <script src="https://code.jquery.com/jquery-2.2.4.min.js" integrity="sha256-BbhdlvQf/xTY9gja0Dq3HiwQF8LaCRTXxZKRutelT44=" crossorigin="anonymous"></script>
</head>
<body class="hold-transition skin-blue sidebar-mini">
    <div class="wrapper">
        <!-- Include Header -->
        <%@include file="../compoment/header.jsp" %>
        
        <!-- Include Sidebar -->
        <%@include file="../compoment/sidebar.jsp" %>

        <!-- Content Wrapper -->
        <div class="content-wrapper">
            <!-- Content Header -->
            <section class="content-header">
                <h1>
                    ${mode == 'new' ? 'Thêm' : 'Chỉnh sửa'} nhà cung cấp
                    <small>${mode == 'new' ? 'Tạo mới nhà cung cấp' : 'Cập nhật thông tin nhà cung cấp'}</small>
                </h1>
                <ol class="breadcrumb">
                    <li><a href="${pageContext.request.contextPath}/admin/dashboard"><i class="fa fa-dashboard"></i> Dashboard</a></li>
                    <li><a href="${pageContext.request.contextPath}/admin/supplier/list">Nhà cung cấp</a></li>
                    <li class="active">${mode == 'new' ? 'Thêm mới' : 'Chỉnh sửa'}</li>
                </ol>
            </section>

            <!-- Main content -->
            <section class="content">
                <!-- Display error -->
                <c:if test="${not empty error}">
                    <div class="alert alert-danger alert-dismissible">
                        <button type="button" class="close" data-dismiss="alert" aria-hidden="true">&times;</button>
                        <h4><i class="icon fa fa-ban"></i> Lỗi!</h4>
                        ${error}
                    </div>
                </c:if>

                <div class="row">
                    <div class="col-md-8 col-md-offset-2">
                        <div class="box box-primary">
                            <div class="box-header with-border">
                                <h3 class="box-title">
                                    <i class="fa fa-edit"></i> 
                                    ${mode == 'new' ? 'Thông tin nhà cung cấp mới' : 'Cập nhật thông tin nhà cung cấp'}
                                </h3>
                            </div>
                            
                            <!-- Form -->
                            <form method="post" 
                                  action="${pageContext.request.contextPath}/admin/supplier/${mode == 'new' ? 'new' : 'edit'}"
                                  onsubmit="return validateForm()">
                                
                                <c:if test="${mode == 'edit'}">
                                    <input type="hidden" name="supplierId" value="${supplier.supplierID}">
                                </c:if>
                                
                                <div class="box-body">
                                    <!-- Supplier Name -->
                                    <div class="form-group" id="supplierNameGroup">
                                        <label for="supplierName">
                                            Tên nhà cung cấp <span style="color: red;">*</span>
                                        </label>
                                        <input type="text" 
                                               class="form-control" 
                                               id="supplierName" 
                                               name="supplierName" 
                                               placeholder="Nhập tên nhà cung cấp"
                                               value="${supplier.supplierName}"
                                               required>
                                        <span class="help-block" id="supplierNameError" style="display: none; color: #dd4b39;"></span>
                                    </div>

                                    <!-- Contact Name -->
                                    <div class="form-group">
                                        <label for="contactName">Người liên hệ</label>
                                        <input type="text" 
                                               class="form-control" 
                                               id="contactName" 
                                               name="contactName" 
                                               placeholder="Nhập tên người liên hệ"
                                               value="${supplier.contactName}">
                                    </div>

                                    <!-- Email -->
                                    <div class="form-group" id="emailGroup">
                                        <label for="email">Email</label>
                                        <input type="email" 
                                               class="form-control" 
                                               id="email" 
                                               name="email" 
                                               placeholder="Nhập địa chỉ email"
                                               value="${supplier.email}">
                                        <span class="help-block" id="emailError" style="display: none; color: #dd4b39;"></span>
                                    </div>

                                    <!-- Phone -->
                                    <div class="form-group" id="phoneGroup">
                                        <label for="phone">Số điện thoại</label>
                                        <input type="tel" 
                                               class="form-control" 
                                               id="phone" 
                                               name="phone" 
                                               placeholder="Nhập số điện thoại"
                                               value="${supplier.phone}">
                                        <span class="help-block" id="phoneError" style="display: none; color: #dd4b39;"></span>
                                    </div>

                                    <!-- Address -->
                                    <div class="form-group">
                                        <label for="address">Địa chỉ</label>
                                        <textarea class="form-control" 
                                                  id="address" 
                                                  name="address" 
                                                  rows="3" 
                                                  placeholder="Nhập địa chỉ chi tiết">${supplier.address}</textarea>
                                    </div>

                                    <!-- Is Active -->
                                    <div class="form-group">
                                        <div class="checkbox">
                                            <label>
                                                <input type="checkbox" 
                                                       id="isActive" 
                                                       name="isActive" 
                                                       ${mode == 'new' || supplier.active ? 'checked' : ''}>
                                                Hoạt động
                                            </label>
                                        </div>
                                        <span class="help-block">Bỏ chọn nếu muốn tạm ngưng hoạt động của nhà cung cấp này</span>
                                    </div>
                                </div>

                                <div class="box-footer">
                                    <button type="submit" class="btn btn-primary">
                                        <i class="fa fa-save"></i> ${mode == 'new' ? 'Tạo mới' : 'Cập nhật'}
                                    </button>
                                    <a href="${mode == 'edit' ? pageContext.request.contextPath.concat('/admin/supplier/details?id=').concat(supplier.supplierID) : pageContext.request.contextPath.concat('/admin/supplier/list')}" 
                                       class="btn btn-default">
                                        <i class="fa fa-times"></i> Hủy
                                    </a>
                                </div>
                            </form>
                        </div>
                    </div>
                </div>
            </section>
        </div>
    </div>

    <!-- Bootstrap 3.3.7 từ CDN -->
    <script src="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/js/bootstrap.min.js" integrity="sha384-Tc5IQib027qvyjSMfHjOMaLkfuWVxZxUPnCJA7l2mCWNIpG9mGCD8wGNIcPD7Txa" crossorigin="anonymous"></script>
    <!-- AdminLTE App -->
    <script src="${pageContext.request.contextPath}/dist/js/app.min.js"></script>
    <!-- Sidebar script -->
    <jsp:include page="../compoment/sidebar-scripts.jsp" />
    
    <script>
        function validateForm() {
            let isValid = true;
            
            // Reset error states
            document.getElementById('supplierNameGroup').classList.remove('has-error');
            document.getElementById('emailGroup').classList.remove('has-error');
            document.getElementById('phoneGroup').classList.remove('has-error');
            document.getElementById('supplierNameError').style.display = 'none';
            document.getElementById('emailError').style.display = 'none';
            document.getElementById('phoneError').style.display = 'none';
            
            // Validate supplier name
            const supplierName = document.getElementById('supplierName').value.trim();
            if (supplierName === '') {
                document.getElementById('supplierNameGroup').classList.add('has-error');
                document.getElementById('supplierNameError').textContent = 'Vui lòng nhập tên nhà cung cấp';
                document.getElementById('supplierNameError').style.display = 'block';
                isValid = false;
            }
            
            // Validate email if provided
            const email = document.getElementById('email').value.trim();
            if (email !== '') {
                const emailPattern = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
                if (!emailPattern.test(email)) {
                    document.getElementById('emailGroup').classList.add('has-error');
                    document.getElementById('emailError').textContent = 'Email không hợp lệ';
                    document.getElementById('emailError').style.display = 'block';
                    isValid = false;
                }
            }
            
            // Validate phone if provided
            const phone = document.getElementById('phone').value.trim();
            if (phone !== '') {
                const phonePattern = /^[0-9+\-\s()]+$/;
                if (!phonePattern.test(phone) || phone.length < 10) {
                    document.getElementById('phoneGroup').classList.add('has-error');
                    document.getElementById('phoneError').textContent = 'Số điện thoại không hợp lệ (ít nhất 10 ký tự số)';
                    document.getElementById('phoneError').style.display = 'block';
                    isValid = false;
                }
            }
            
            return isValid;
        }
    </script>
</body>
</html>
