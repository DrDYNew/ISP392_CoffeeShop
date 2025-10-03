<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page pageEncoding="UTF-8" %>

<!-- Left side column. contains the logo and sidebar -->
<aside class="main-sidebar">
    <!-- sidebar: style can be found in sidebar.less -->
    <section class="sidebar">
        <!-- Sidebar user panel -->
        <div class="user-panel">
            <div class="pull-left image">
                <img src="${pageContext.request.contextPath}/dist/img/user2-160x160.jpg" class="img-circle" alt="User Image">
            </div>
            <div class="pull-left info">
                <p>${sessionScope.user.fullName != null ? sessionScope.user.fullName : 'User'}</p>
                <a href="#"><i class="fa fa-circle text-success"></i> Online</a>
            </div>
        </div>
       
        <ul class="sidebar-menu" style="list-style: none; margin: 0; padding: 0;">
            <li class="header" style="color: #4b646f; background: #1a2226; padding: 10px 25px 10px 15px; font-size: 12px;">MAIN NAVIGATION</li>
            
            <!-- Dashboard -->
            <li class="active">
                <a href="${pageContext.request.contextPath}/hr/dashboard" style="padding: 12px 5px 12px 15px; display: block; color: #b8c7ce; text-decoration: none;">
                    <i class="fa fa-dashboard"></i> <span>Dashboard</span>
                </a>
            </li>
            
            <!-- HR specific menu items -->
            <c:if test="${sessionScope.roleName == 'HR' || sessionScope.roleName == 'hr'}">
                <li class="treeview">
                    <a href="javascript:void(0)" onclick="toggleMenu(this)" style="padding: 12px 5px 12px 15px; display: block; color: #b8c7ce; text-decoration: none;">
                        <i class="fa fa-users"></i>
                        <span>Quản lý người dùng</span>
                        <span class="pull-right-container" style="float: right;">
                            <i class="fa fa-angle-left pull-right"></i>
                        </span>
                    </a>
                    <ul class="treeview-menu" style="display: none; list-style: none; margin: 0; padding: 0;">
                        <li><a href="${pageContext.request.contextPath}/user" style="color: #8aa4af; padding: 5px 5px 5px 35px; display: block; text-decoration: none;"><i class="fa fa-circle-o"></i> Danh sách người dùng</a></li>
                        <li><a href="${pageContext.request.contextPath}/user?action=create" style="color: #8aa4af; padding: 5px 5px 5px 35px; display: block; text-decoration: none;"><i class="fa fa-circle-o"></i> Thêm người dùng</a></li>
                    </ul>
                </li>
                
                <li class="treeview">
                    <a href="javascript:void(0)" onclick="toggleMenu(this)" style="padding: 12px 5px 12px 15px; display: block; color: #b8c7ce; text-decoration: none;">
                        <i class="fa fa-users"></i>
                        <span>Quản lý nhân viên</span>
                        <span class="pull-right-container" style="float: right;">
                            <i class="fa fa-angle-left pull-right"></i>
                        </span>
                    </a>
                    <ul class="treeview-menu" style="display: none; list-style: none; margin: 0; padding: 0;">
                        <li><a href="javascript:void(0)" style="color: #8aa4af; padding: 5px 5px 5px 35px; display: block; text-decoration: none;"><i class="fa fa-circle-o"></i> Danh sách nhân viên</a></li>
                        <li><a href="javascript:void(0)" style="color: #8aa4af; padding: 5px 5px 5px 35px; display: block; text-decoration: none;"><i class="fa fa-circle-o"></i> Thêm nhân viên</a></li>
                        <li><a href="javascript:void(0)" style="color: #8aa4af; padding: 5px 5px 5px 35px; display: block; text-decoration: none;"><i class="fa fa-circle-o"></i> Hồ sơ nhân viên</a></li>
                    </ul>
                </li>
                
                <li class="treeview">
                    <a href="javascript:void(0)" onclick="toggleMenu(this)" style="padding: 12px 5px 12px 15px; display: block; color: #b8c7ce; text-decoration: none;">
                        <i class="fa fa-user-plus"></i>
                        <span>Tuyển dụng</span>
                        <span class="pull-right-container" style="float: right;">
                            <i class="fa fa-angle-left pull-right"></i>
                        </span>
                    </a>
                    <ul class="treeview-menu" style="display: none; list-style: none; margin: 0; padding: 0;">
                        <li><a href="javascript:void(0)" style="color: #8aa4af; padding: 5px 5px 5px 35px; display: block; text-decoration: none;"><i class="fa fa-circle-o"></i> Đăng tin tuyển dụng</a></li>
                        <li><a href="javascript:void(0)" style="color: #8aa4af; padding: 5px 5px 5px 35px; display: block; text-decoration: none;"><i class="fa fa-circle-o"></i> Quản lý ứng viên</a></li>
                        <li><a href="javascript:void(0)" style="color: #8aa4af; padding: 5px 5px 5px 35px; display: block; text-decoration: none;"><i class="fa fa-circle-o"></i> Lịch phỏng vấn</a></li>
                    </ul>
                </li>
                
                <li class="treeview">
                    <a href="javascript:void(0)" onclick="toggleMenu(this)" style="padding: 12px 5px 12px 15px; display: block; color: #b8c7ce; text-decoration: none;">
                        <i class="fa fa-calendar"></i>
                        <span>Lịch làm việc</span>
                        <span class="pull-right-container" style="float: right;">
                            <i class="fa fa-angle-left pull-right"></i>
                        </span>
                    </a>
                    <ul class="treeview-menu" style="display: none; list-style: none; margin: 0; padding: 0;">
                        <li><a href="javascript:void(0)" style="color: #8aa4af; padding: 5px 5px 5px 35px; display: block; text-decoration: none;"><i class="fa fa-circle-o"></i> Sắp xếp ca làm</a></li>
                        <li><a href="javascript:void(0)" style="color: #8aa4af; padding: 5px 5px 5px 35px; display: block; text-decoration: none;"><i class="fa fa-circle-o"></i> Chấm công</a></li>
                        <li><a href="javascript:void(0)" style="color: #8aa4af; padding: 5px 5px 5px 35px; display: block; text-decoration: none;"><i class="fa fa-circle-o"></i> Xin nghỉ phép</a></li>
                    </ul>
                </li>
                
                <li>
                    <a href="javascript:void(0)" style="padding: 12px 5px 12px 15px; display: block; color: #b8c7ce; text-decoration: none;">
                        <i class="fa fa-money"></i> <span>Bảng lương</span>
                    </a>
                </li>
                
                <li>
                    <a href="javascript:void(0)" style="padding: 12px 5px 12px 15px; display: block; color: #b8c7ce; text-decoration: none;">
                        <i class="fa fa-line-chart"></i> <span>Báo cáo HR</span>
                    </a>
                </li>
            </c:if>
            
            <!-- Inventory Staff specific menu items -->
            <c:if test="${sessionScope.roleName == 'Inventory' || sessionScope.roleName == 'inventory'}">
                <li class="treeview">
                    <a href="javascript:void(0)" onclick="toggleMenu(this)">
                        <i class="fa fa-cubes"></i>
                        <span>Quản lý kho</span>
                        <span class="pull-right-container">
                            <i class="fa fa-angle-left pull-right"></i>
                        </span>
                    </a>
                    <ul class="treeview-menu">
                        <li><a href="javascript:void(0)"><i class="fa fa-circle-o"></i> Tồn kho</a></li>
                        <li><a href="javascript:void(0)"><i class="fa fa-circle-o"></i> Nhập hàng</a></li>
                        <li><a href="javascript:void(0)"><i class="fa fa-circle-o"></i> Xuất hàng</a></li>
                    </ul>
                </li>
                
                <li>
                    <a href="javascript:void(0)">
                        <i class="fa fa-shopping-cart"></i> <span>Đơn đặt hàng</span>
                    </a>
                </li>
                
                <li>
                    <a href="javascript:void(0)">
                        <i class="fa fa-truck"></i> <span>Nhà cung cấp</span>
                    </a>
                </li>
                
                <li>
                    <a href="javascript:void(0)">
                        <i class="fa fa-bar-chart"></i> <span>Báo cáo kho</span>
                    </a>
                </li>
            </c:if>
            
            <!-- Barista specific menu items -->
            <c:if test="${sessionScope.roleName == 'Barista' || sessionScope.roleName == 'barista'}">
                <li>
                    <a href="javascript:void(0)">
                        <i class="fa fa-coffee"></i> <span>Đơn hàng</span>
                    </a>
                </li>
                
                <li>
                    <a href="javascript:void(0)">
                        <i class="fa fa-list"></i> <span>Menu</span>
                    </a>
                </li>
                
                <li>
                    <a href="javascript:void(0)">
                        <i class="fa fa-clock-o"></i> <span>Ca làm việc</span>
                    </a>
                </li>
            </c:if>
            
            <!-- Admin specific menu items -->
            <c:if test="${sessionScope.roleName == 'Admin' || sessionScope.roleName == 'admin'}">
                <li class="treeview">
                    <a href="javascript:void(0)" onclick="toggleMenu(this)" style="padding: 12px 5px 12px 15px; display: block; color: #b8c7ce; text-decoration: none;">
                        <i class="fa fa-users"></i>
                        <span>Quản lý người dùng</span>
                        <span class="pull-right-container" style="float: right;">
                            <i class="fa fa-angle-left pull-right"></i>
                        </span>
                    </a>
                    <ul class="treeview-menu" style="display: none; list-style: none; margin: 0; padding: 0;">
                        <li><a href="${pageContext.request.contextPath}/user" style="color: #8aa4af; padding: 5px 5px 5px 35px; display: block; text-decoration: none;"><i class="fa fa-circle-o"></i> Danh sách người dùng</a></li>
                        <li><a href="${pageContext.request.contextPath}/user?action=create" style="color: #8aa4af; padding: 5px 5px 5px 35px; display: block; text-decoration: none;"><i class="fa fa-circle-o"></i> Thêm người dùng</a></li>
                    </ul>
                </li>
                
                <li class="treeview">
                    <a href="javascript:void(0)" onclick="toggleMenu(this)">
                        <i class="fa fa-cogs"></i>
                        <span>Quản trị hệ thống</span>
                        <span class="pull-right-container">
                            <i class="fa fa-angle-left pull-right"></i>
                        </span>
                    </a>
                    <ul class="treeview-menu">
                        <li><a href="javascript:void(0)"><i class="fa fa-circle-o"></i> Phân quyền</a></li>
                        <li><a href="javascript:void(0)"><i class="fa fa-circle-o"></i> Cài đặt</a></li>
                    </ul>
                </li>
                
                <li>
                    <a href="javascript:void(0)">
                        <i class="fa fa-pie-chart"></i> <span>Thống kê tổng quan</span>
                    </a>
                </li>
            </c:if>
        </ul>
    </section>
    <!-- /.sidebar -->
</aside>

<script>
function toggleMenu(element) {
    const parentLi = element.parentElement;
    const treeviewMenu = parentLi.querySelector('.treeview-menu');
    const arrow = parentLi.querySelector('.fa-angle-left');
    
    if (treeviewMenu) {
        if (treeviewMenu.style.display === 'none' || treeviewMenu.style.display === '') {
            treeviewMenu.style.display = 'block';
            arrow.style.transform = 'rotate(-90deg)';
            parentLi.classList.add('active');
        } else {
            treeviewMenu.style.display = 'none';
            arrow.style.transform = 'rotate(0deg)';
            parentLi.classList.remove('active');
        }
    }
}

// Initialize menu state on page load
document.addEventListener('DOMContentLoaded', function() {
    // Close all menus by default
    const treeviewMenus = document.querySelectorAll('.treeview-menu');
    treeviewMenus.forEach(function(menu) {
        menu.style.display = 'none';
    });
    
    // Reset all arrows
    const arrows = document.querySelectorAll('.fa-angle-left');
    arrows.forEach(function(arrow) {
        arrow.style.transform = 'rotate(0deg)';
        arrow.style.transition = 'transform 0.3s ease';
    });
});
</script>