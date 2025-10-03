# Coffee Shop Management System - Login Feature

## Tổng quan
Hệ thống quản lý cửa hàng cà phê với chức năng đăng nhập hoàn chỉnh, phân quyền người dùng và dashboard riêng biệt cho từng role.

## Cấu trúc Database
Hệ thống sử dụng PostgreSQL với các bảng chính:
- `Users`: Quản lý thông tin người dùng
- `Setting`: Cấu hình roles, categories, status
- `Shops`: Thông tin cửa hàng
- `Products`, `Ingredients`: Sản phẩm và nguyên liệu
- `Orders`, `PurchaseOrders`: Đơn hàng bán và nhập

## Roles & Permissions

### 1. Admin
- **Quyền**: Toàn quyền hệ thống
- **Dashboard**: `/views/admin/dashboard.jsp`
- **Chức năng**:
  - Quản lý tất cả nhân viên
  - Xem báo cáo tổng hợp
  - Cài đặt hệ thống
  - Quản lý cửa hàng

### 2. HR (Human Resources)
- **Quyền**: Quản lý nhân sự
- **Dashboard**: `/views/hr/dashboard.jsp`
- **Chức năng**:
  - Tuyển dụng nhân viên
  - Sắp xếp lịch làm việc
  - Tính lương
  - Quản lý chuyên cần

### 3. Inventory Staff
- **Quyền**: Quản lý kho
- **Dashboard**: `/views/inventory-staff/dashboard.jsp`
- **Chức năng**:
  - Quản lý nguyên liệu
  - Tạo đơn nhập hàng
  - Báo cáo sự cố
  - Quản lý nhà cung cấp

### 4. Barista
- **Quyền**: Pha chế và bán hàng
- **Dashboard**: `/views/barista/dashboard.jsp`
- **Chức năng**:
  - Tạo đơn hàng
  - Xem menu sản phẩm
  - POS bán hàng
  - Báo cáo vấn đề nguyên liệu

## Tài khoản Demo

### Thông tin đăng nhập:

**Admin:**
- Email: `admin@coffeelux.com`
- Password: `123456`

**HR:**
- Email: `hr@coffeelux.com`
- Password: `123456`

**Inventory Staff:**
- Email: `inventory.hcm@coffeelux.com`
- Password: `123456`

**Barista:**
- Email: `employee01@coffeelux.com`
- Password: `123456`

## Cấu trúc Code

### Backend (Java)

#### Models/DTOs:
- `User.java`: Entity người dùng
- `AuthResponse.java`: Response cho authentication

#### DAO Layer:
- `AuthDAO.java`: Xử lý authentication với database
- `DBContext.java`: Kết nối database

#### Service Layer:
- `AuthService.java`: Business logic cho authentication

#### Controllers:
- `LoginController.java`: Servlet xử lý đăng nhập/đăng xuất

### Frontend (JSP + CSS + JS)

#### Views:
- `/views/common/login.jsp`: Trang đăng nhập
- `/views/admin/dashboard.jsp`: Dashboard admin
- `/views/hr/dashboard.jsp`: Dashboard HR
- `/views/inventory-staff/dashboard.jsp`: Dashboard inventory
- `/views/barista/dashboard.jsp`: Dashboard barista

#### Components:
- `/views/compoment/header.jsp`: Header chung
- `/views/compoment/sidebar.jsp`: Sidebar với phân quyền

#### Assets:
- `/css/login.css`: Styles cho trang login
- `/css/dashboard.css`: Styles cho dashboard
- `/js/login.js`: JavaScript cho login
- `/js/dashboard.js`: JavaScript cho dashboard

## Bảo mật

### Password Hashing:
- Sử dụng **bcrypt** thay vì SHA256
- Salt tự động sinh cho mỗi password
- Verification an toàn

### Session Management:
- Session timeout: 30 phút
- Automatic logout khi session hết hạn
- Check role-based access

### Authorization:
- Role-based UI hiding/showing
- Server-side permission check
- Redirect based on user role

## Setup Instructions

### 1. Database Setup:
```sql
-- Chạy file SQL.sql để tạo database và sample data
-- Database: PostgreSQL
-- Encoding: UTF-8
```

### 2. Dependencies:
- Jakarta EE 10
- PostgreSQL JDBC Driver
- jBCrypt 0.4
- Bootstrap 5
- Font Awesome 6

### 3. Configuration:
- Cập nhật `DBContext.java` với thông tin database
- Deploy project lên server (Tomcat/GlassFish)

### 4. Access:
- Truy cập: `http://localhost:8080/project-name/`
- Tự động redirect tới login page
- Đăng nhập với tài khoản demo

## Features

### Login Page:
- ✅ Responsive design
- ✅ Email validation
- ✅ Password show/hide toggle
- ✅ Remember me functionality
- ✅ Error handling
- ✅ Loading states
- ✅ Vietnamese language

### Dashboard Features:
- ✅ Role-based sidebar navigation
- ✅ Collapsible sidebar
- ✅ Statistics cards
- ✅ Quick actions
- ✅ Recent activities
- ✅ Responsive design
- ✅ Dark/Light theme ready

### Security Features:
- ✅ BCrypt password hashing
- ✅ Session management
- ✅ Role-based access control
- ✅ CSRF protection ready
- ✅ Input validation
- ✅ SQL injection prevention

## File Structure

```
src/
├── java/
│   ├── controllers/
│   │   └── LoginController.java
│   ├── dao/
│   │   ├── AuthDAO.java
│   │   └── DBContext.java
│   ├── models/
│   │   ├── User.java
│   │   └── AuthResponse.java
│   ├── services/
│   │   └── AuthService.java
│   └── test/
│       └── PasswordHashTest.java

web/
├── views/
│   ├── common/
│   │   └── login.jsp
│   ├── admin/
│   │   └── dashboard.jsp
│   ├── hr/
│   │   └── dashboard.jsp
│   ├── inventory-staff/
│   │   └── dashboard.jsp
│   ├── barista/
│   │   └── dashboard.jsp
│   └── compoment/
│       ├── header.jsp
│       └── sidebar.jsp
├── css/
│   ├── login.css
│   └── dashboard.css
├── js/
│   ├── login.js
│   └── dashboard.js
├── WEB-INF/
│   ├── web.xml
│   └── lib/
│       └── jbcrypt-0.4.jar
└── index.jsp
```

## Customization

### Thêm Role mới:
1. Thêm role vào bảng `Setting`
2. Cập nhật `AuthService.java`
3. Tạo dashboard mới
4. Cập nhật sidebar permissions
5. Thêm redirect logic

### Thêm chức năng:
1. Tạo DAO mới
2. Tạo Service layer
3. Tạo Controller
4. Tạo JSP views
5. Cập nhật navigation

### Styling:
- Sửa CSS variables trong `dashboard.css`
- Customize Bootstrap theme
- Thêm custom components

## Troubleshooting

### Lỗi BCrypt:
- Đảm bảo jBCrypt-0.4.jar trong classpath
- Copy vào cả `/web/WEB-INF/lib` và `/build/web/WEB-INF/lib`

### Lỗi Database:
- Check connection string trong `DBContext.java`
- Đảm bảo PostgreSQL đang chạy
- Verify user permissions

### Lỗi Session:
- Check session timeout settings
- Verify session attributes
- Clear browser cache

## Next Steps

### Suggestions for improvement:
1. **Remember Me**: Implement với cookies an toàn
2. **Password Reset**: Email-based password reset
3. **2FA**: Two-factor authentication
4. **Activity Logs**: User activity tracking
5. **API Security**: JWT tokens cho REST APIs
6. **Internationalization**: Multi-language support
7. **Theme Switching**: Dark/Light mode toggle
8. **Mobile App**: Companion mobile app

---

**Developed by:** DrDYNew  
**Version:** 1.0  
**Date:** October 2025