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
            <div class="alert alert-success">
                <i class="fas fa-check-circle"></i>
                ${param.message}
            </div>
        </c:if>
        
        <!-- Info Message -->
        <c:if test="${not empty message}">
            <div class="alert alert-info">
                <i class="fas fa-info-circle"></i>
                ${message}
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
        
        <!-- Divider -->
        <div class="login-divider">
            <span>HOẶC</span>
        </div>
        
        <!-- Google Login Button -->
        <button type="button" class="btn-google" onclick="loginWithGoogle()">
            <svg width="18" height="18" viewBox="0 0 18 18" xmlns="http://www.w3.org/2000/svg">
                <g fill="none" fill-rule="evenodd">
                    <path d="M17.64 9.205c0-.639-.057-1.252-.164-1.841H9v3.481h4.844a4.14 4.14 0 0 1-1.796 2.716v2.259h2.908c1.702-1.567 2.684-3.875 2.684-6.615z" fill="#4285F4"/>
                    <path d="M9 18c2.43 0 4.467-.806 5.956-2.18l-2.908-2.259c-.806.54-1.837.86-3.048.86-2.344 0-4.328-1.584-5.036-3.711H.957v2.332A8.997 8.997 0 0 0 9 18z" fill="#34A853"/>
                    <path d="M3.964 10.71A5.41 5.41 0 0 1 3.682 9c0-.593.102-1.17.282-1.71V4.958H.957A8.996 8.996 0 0 0 0 9c0 1.452.348 2.827.957 4.042l3.007-2.332z" fill="#FBBC05"/>
                    <path d="M9 3.58c1.321 0 2.508.454 3.44 1.345l2.582-2.58C13.463.891 11.426 0 9 0A8.997 8.997 0 0 0 .957 4.958L3.964 7.29C4.672 5.163 6.656 3.58 9 3.58z" fill="#EA4335"/>
                </g>
            </svg>
            Đăng nhập với Google
        </button>
        
        <!-- Additional Links -->
        <div class="forgot-password">
            <a href="${pageContext.request.contextPath}/forgot-password">
                <i class="fas fa-question-circle"></i>
                Quên mật khẩu?
            </a>
        </div>
    </div>

    <!-- Bootstrap JS -->
    <script src="${pageContext.request.contextPath}/bootstrap/js/bootstrap.bundle.min.js"></script>
    
    <!-- Custom Login JS -->
    <script src="${pageContext.request.contextPath}/js/login.js"></script>
    
    <!-- Google Login Script -->
    <script>
        function loginWithGoogle() {
            // Redirect to Google OAuth2 authorization URL
            window.location.href = '${pageContext.request.contextPath}/google-auth';
        }
    </script>
    
    <style>
        /* Divider Style */
        .login-divider {
            text-align: center;
            margin: 25px 0;
            position: relative;
        }
        
        .login-divider::before {
            content: '';
            position: absolute;
            top: 50%;
            left: 0;
            right: 0;
            height: 1px;
            background: #e0e0e0;
            z-index: 0;
        }
        
        .login-divider span {
            background: white;
            padding: 0 15px;
            color: #999;
            font-size: 13px;
            font-weight: 500;
            position: relative;
            z-index: 1;
        }
        
        /* Google Login Button */
        .btn-google {
            width: 100%;
            padding: 12px 20px;
            background: white;
            border: 2px solid #e0e0e0;
            border-radius: 8px;
            font-size: 15px;
            font-weight: 600;
            color: #333;
            cursor: pointer;
            transition: all 0.3s ease;
            display: flex;
            align-items: center;
            justify-content: center;
            gap: 10px;
            margin-bottom: 20px;
        }
        
        .btn-google:hover {
            background: #f8f9fa;
            border-color: #ccc;
            transform: translateY(-2px);
            box-shadow: 0 4px 12px rgba(0,0,0,0.15);
        }
        
        .btn-google:active {
            transform: translateY(0);
            box-shadow: 0 2px 6px rgba(0,0,0,0.1);
        }
        
        .btn-google svg {
            flex-shrink: 0;
        }
    </style>
  
</body>
</html>