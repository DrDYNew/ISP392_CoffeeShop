<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Đăng Nhập - Coffee Shop Management</title>
    
    <!-- Bootstrap CSS -->
    <link href="${pageContext.request.contextPath}/bootstrap/css/bootstrap.min.css" rel="stylesheet">
    
    <!-- Custom Login CSS -->
    <link href="${pageContext.request.contextPath}/css/login.css" rel="stylesheet">
    
    <!-- Font Awesome for icons -->
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
</head>
<body>
    <div class="login-container">
        <!-- Login Header -->
        <div class="login-header">
            <div class="coffee-animation"></div>
            <div class="logo">
                <i class="fas fa-coffee"></i> CoffeeLux
            </div>
            <h2>Đăng Nhập Hệ Thống</h2>
            <p>Quản lý cửa hàng cà phê chuyên nghiệp</p>
        </div>
        
        <!-- Error Message -->
        <c:if test="${not empty error}">
            <div class="alert alert-error">
                <i class="fas fa-exclamation-circle"></i>
                ${error}
            </div>
        </c:if>
        
        <!-- Success Message -->
        <c:if test="${not empty param.message}">
            <div class="alert alert-info">
                <i class="fas fa-info-circle"></i>
                ${param.message}
            </div>
        </c:if>
        
        <!-- Login Form -->
        <form id="loginForm" method="post" action="${pageContext.request.contextPath}/login">
            <div class="form-group">
                <label for="email">
                    <i class="fas fa-envelope"></i>
                    Email
                </label>
                <input 
                    type="email" 
                    id="email" 
                    name="email" 
                    class="form-control" 
                    placeholder="Nhập email của bạn"
                    value="${email != null ? email : ''}"
                    required
                    autocomplete="email"
                >
            </div>
            
            <div class="form-group">
                <label for="password">
                    <i class="fas fa-lock"></i>
                    Mật khẩu
                </label>
                <div style="position: relative;">
                    <input 
                        type="password" 
                        id="password" 
                        name="password" 
                        class="form-control" 
                        placeholder="Nhập mật khẩu"
                        required
                        autocomplete="current-password"
                    >
                    <button 
                        type="button" 
                        class="password-toggle"
                        onclick="togglePasswordVisibility()"
                        style="position: absolute; right: 10px; top: 50%; transform: translateY(-50%); background: none; border: none; cursor: pointer; font-size: 1.2rem;"
                        title="Hiện/Ẩn mật khẩu"
                    >
                        👁️
                    </button>
                </div>
            </div>
            
            <div class="checkbox-group">
                <input type="checkbox" id="rememberMe" name="rememberMe">
                <label for="rememberMe">Ghi nhớ đăng nhập</label>
            </div>
            
            <button type="submit" class="btn-login">
                <i class="fas fa-sign-in-alt"></i>
                Đăng Nhập
            </button>
        </form>
        
        <!-- Additional Links -->
        <div class="forgot-password">
            <a href="#" onclick="showForgotPasswordInfo()">
                <i class="fas fa-question-circle"></i>
                Quên mật khẩu?
            </a>
        </div>
    </div>

    <!-- Bootstrap JS -->
    <script src="${pageContext.request.contextPath}/bootstrap/js/bootstrap.bundle.min.js"></script>
    
    <!-- Custom Login JS -->
    <script src="${pageContext.request.contextPath}/js/login.js"></script>
    
  
</body>
</html>