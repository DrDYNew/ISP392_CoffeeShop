<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<!-- Left side column. contains the logo and sidebar -->
<aside class="main-sidebar">
    <section class="sidebar">
        <!-- Sidebar user panel -->
        <div class="user-panel">
            <div class="pull-left image">
               <img src="https://ui-avatars.com/api/?name=${sessionScope.user.fullName}&size=160&background=00a65a&color=fff" class="img-circle" alt="User Image"> </div> <div class="pull-left info"> <p>${sessionScope.user.fullName != null ? sessionScope.user.fullName : 'User'}</p> <a href="#"><i class="fa fa-circle text-success"></i> Online</a> </div> </div>

        <ul class="sidebar-menu">
            <li class="header">MAIN NAVIGATION</li>

            <!-- Dashboard -->
            <li class="active">
                <c:choose>
                    <c:when test="${fn:toLowerCase(sessionScope.roleName) == 'admin'}">
                        <a href="${pageContext.request.contextPath}/admin/dashboard">
                            <i class="fa fa-dashboard"></i> <span>Dashboard</span>
                        </a>
                    </c:when>
                    <c:when test="${fn:toLowerCase(sessionScope.roleName) == 'hr'}">
                        <a href="${pageContext.request.contextPath}/hr/dashboard">
                            <i class="fa fa-dashboard"></i> <span>Dashboard</span>
                        </a>
                    </c:when>
                    <c:when test="${fn:toLowerCase(sessionScope.roleName) == 'barista'}">
                        <a href="${pageContext.request.contextPath}/barista/dashboard">
                            <i class="fa fa-dashboard"></i> <span>Dashboard</span>
                        </a>
                    </c:when>
                    <c:when test="${fn:toLowerCase(sessionScope.roleName) == 'inventory'}">
                        <a href="${pageContext.request.contextPath}/inventory-dashboard">
                            <i class="fa fa-dashboard"></i> <span>Dashboard</span>
                        </a>
                    </c:when>
                    <c:when test="${fn:toLowerCase(sessionScope.roleName) == 'user'}">
                        <a href="${pageContext.request.contextPath}/views/common/dashboard.jsp">
                            <i class="fa fa-dashboard"></i> <span>Dashboard</span>
                        </a>
                    </c:when>
                    <c:otherwise>
                        <a href="${pageContext.request.contextPath}/dashboard">
                            <i class="fa fa-dashboard"></i> <span>Dashboard</span>
                        </a>
                    </c:otherwise>
                </c:choose>
            </li>

            <!-- HR menu -->
            <c:if test="${fn:toLowerCase(sessionScope.roleName) == 'hr'}">
                <li class="treeview">
                    <a href="javascript:void(0)" onclick="toggleMenu(this)">
                        <i class="fa fa-users"></i>
                        <span>Quản lý người dùng</span>
                        <span class="pull-right-container"><i class="fa fa-angle-left pull-right"></i></span>
                    </a>
                    <ul class="treeview-menu">
                        <li><a href="${pageContext.request.contextPath}/user"><i class="fa fa-circle-o"></i> Danh sách người dùng</a></li>
                        <li><a href="${pageContext.request.contextPath}/user?action=create"><i class="fa fa-circle-o"></i> Thêm người dùng</a></li>
                    </ul>
                </li>

                <li class="treeview">
                    <a href="javascript:void(0)" onclick="toggleMenu(this)">
                        <i class="fa fa-users"></i>
                        <span>Quản lý nhân viên</span>
                        <span class="pull-right-container"><i class="fa fa-angle-left pull-right"></i></span>
                    </a>
                    <ul class="treeview-menu">
                        <li><a href="${pageContext.request.contextPath}/hr/employees"><i class="fa fa-circle-o"></i> Danh sách nhân viên</a></li>
                        <li><a href="${pageContext.request.contextPath}/hr/employees?action=create"><i class="fa fa-circle-o"></i> Thêm nhân viên</a></li>
                        <li><a href="${pageContext.request.contextPath}/hr/employees?action=profile"><i class="fa fa-circle-o"></i> Hồ sơ nhân viên</a></li>
                    </ul>
                </li>

                <li class="treeview">
                    <a href="javascript:void(0)" onclick="toggleMenu(this)">
                        <i class="fa fa-user-plus"></i>
                        <span>Tuyển dụng</span>
                        <span class="pull-right-container"><i class="fa fa-angle-left pull-right"></i></span>
                    </a>
                    <ul class="treeview-menu">
                        <li><a href="${pageContext.request.contextPath}/hr/recruitment?action=job-posting"><i class="fa fa-circle-o"></i> Đăng tin tuyển dụng</a></li>
                        <li><a href="${pageContext.request.contextPath}/hr/recruitment?action=candidates"><i class="fa fa-circle-o"></i> Quản lý ứng viên</a></li>
                        <li><a href="${pageContext.request.contextPath}/hr/recruitment?action=interviews"><i class="fa fa-circle-o"></i> Lịch phỏng vấn</a></li>
                    </ul>
                </li>

                <li class="treeview">
                    <a href="javascript:void(0)" onclick="toggleMenu(this)">
                        <i class="fa fa-calendar"></i>
                        <span>Lịch làm việc</span>
                        <span class="pull-right-container"><i class="fa fa-angle-left pull-right"></i></span>
                    </a>
                    <ul class="treeview-menu">
                        <li><a href="${pageContext.request.contextPath}/hr/schedule?action=shifts"><i class="fa fa-circle-o"></i> Sắp xếp ca làm</a></li>
                        <li><a href="${pageContext.request.contextPath}/hr/schedule?action=attendance"><i class="fa fa-circle-o"></i> Chấm công</a></li>
                        <li><a href="${pageContext.request.contextPath}/hr/schedule?action=leave-request"><i class="fa fa-circle-o"></i> Xin nghỉ phép</a></li>
                    </ul>
                </li>

                <li><a href="${pageContext.request.contextPath}/hr/payroll"><i class="fa fa-money"></i> <span>Bảng lương</span></a></li>
            </c:if>

            <!-- User menu -->
            <c:if test="${fn:toLowerCase(sessionScope.roleName) == 'user'}">
                <li class="treeview">
                    <a href="javascript:void(0)" onclick="toggleMenu(this)">
                        <i class="fa fa-building"></i>
                        <span>Thông tin Shop</span>
                        <span class="pull-right-container"><i class="fa fa-angle-left pull-right"></i></span>
                    </a>
                    <ul class="treeview-menu">
                        <li><a href="${pageContext.request.contextPath}/user/shop?action=list"><i class="fa fa-circle-o"></i> Danh sách Shop</a></li>
                        <li><a href="${pageContext.request.contextPath}/user/shop?action=details"><i class="fa fa-circle-o"></i> Chi tiết Shop</a></li>
                    </ul>
                </li>
            </c:if>

            <!-- Inventory Staff menu -->
            <c:if test="${fn:toLowerCase(sessionScope.roleName) == 'inventory'}">
                <li class="treeview">
                    <a href="javascript:void(0)" onclick="toggleMenu(this)">
                        <i class="fa fa-cubes"></i>
                        <span>Quản lý kho</span>
                        <span class="pull-right-container"><i class="fa fa-angle-left pull-right"></i></span>
                    </a>
                    <ul class="treeview-menu">
                        <li><a href="${pageContext.request.contextPath}/ingredient"><i class="fa fa-circle-o"></i> Danh sách nguyên liệu</a></li>
                        <li><a href="${pageContext.request.contextPath}/ingredient?action=low-stock"><i class="fa fa-circle-o"></i> Nguyên liệu sắp hết</a></li>
                    </ul>
                </li>

                <li class="treeview">
                    <a href="javascript:void(0)" onclick="toggleMenu(this)">
                        <i class="fa fa-shopping-cart"></i>
                        <span>Đơn đặt hàng</span>
                        <span class="pull-right-container"><i class="fa fa-angle-left pull-right"></i></span>
                    </a>
                    <ul class="treeview-menu">
                        <li><a href="${pageContext.request.contextPath}/purchase-order"><i class="fa fa-circle-o"></i> Danh sách đơn hàng</a></li>
                        <li><a href="${pageContext.request.contextPath}/purchase-order?action=create"><i class="fa fa-circle-o"></i> Tạo đơn hàng</a></li>
                    </ul>
                </li>

                <li class="treeview">
                    <a href="javascript:void(0)" onclick="toggleMenu(this)">
                        <i class="fa fa-exclamation-triangle"></i>
                        <span>Vấn đề nguyên liệu</span>
                        <span class="pull-right-container"><i class="fa fa-angle-left pull-right"></i></span>
                    </a>
                    <ul class="treeview-menu">
                        <li><a href="${pageContext.request.contextPath}/issue?action=list"><i class="fa fa-circle-o"></i> Danh sách vấn đề</a></li>
                        <li><a href="${pageContext.request.contextPath}/issue?action=create"><i class="fa fa-circle-o"></i> Thêm vấn đề mới</a></li>
                    </ul>
                </li>

                <li><a href="${pageContext.request.contextPath}/supplier"><i class="fa fa-truck"></i> <span>Nhà cung cấp</span></a></li>
            </c:if>

            <!-- Barista menu -->
            <c:if test="${fn:toLowerCase(sessionScope.roleName) == 'barista'}">
                <li><a href="${pageContext.request.contextPath}/barista/orders"><i class="fa fa-coffee"></i> <span>Đơn hàng</span></a></li>
                <li><a href="${pageContext.request.contextPath}/barista/issues"><i class="fa fa-exclamation-triangle"></i> <span>Vấn đề nguyên liệu</span></a></li>
                <li><a href="${pageContext.request.contextPath}/barista/menu"><i class="fa fa-list"></i> <span>Menu</span></a></li>
                <li><a href="${pageContext.request.contextPath}/barista/schedule"><i class="fa fa-clock-o"></i> <span>Ca làm việc</span></a></li>
            </c:if>

            <!-- Admin menu -->
            <c:if test="${fn:toLowerCase(sessionScope.roleName) == 'admin'}">
                <li class="treeview">
                    <a href="javascript:void(0)" onclick="toggleMenu(this)">
                        <i class="fa fa-users"></i>
                        <span>Quản lý người dùng</span>
                        <span class="pull-right-container"><i class="fa fa-angle-left pull-right"></i></span>
                    </a>
                    <ul class="treeview-menu">
                        <li><a href="${pageContext.request.contextPath}/user"><i class="fa fa-circle-o"></i> Danh sách người dùng</a></li>
                        <li><a href="${pageContext.request.contextPath}/user?action=create"><i class="fa fa-circle-o"></i> Thêm người dùng</a></li>
                    </ul>
                </li>

                <li class="treeview">
                    <a href="javascript:void(0)" onclick="toggleMenu(this)">
                        <i class="fa fa-cube"></i>
                        <span>Quản lý sản phẩm</span>
                        <span class="pull-right-container"><i class="fa fa-angle-left pull-right"></i></span>
                    </a>
                    <ul class="treeview-menu">
                        <li><a href="${pageContext.request.contextPath}/admin/products"><i class="fa fa-circle-o"></i> Danh sách sản phẩm</a></li>
                    </ul>
                </li>

                <li class="treeview">
                    <a href="javascript:void(0)" onclick="toggleMenu(this)">
                        <i class="fa fa-building"></i>
                        <span>Quản lý Shop</span>
                        <span class="pull-right-container"><i class="fa fa-angle-left pull-right"></i></span>
                    </a>
                    <ul class="treeview-menu">
                        <li><a href="${pageContext.request.contextPath}/admin/shop?action=list"><i class="fa fa-circle-o"></i> Danh sách Shop</a></li>
                        <li><a href="${pageContext.request.contextPath}/admin/shop?action=add"><i class="fa fa-circle-o"></i> Thêm Shop mới</a></li>
                        <li><a href="${pageContext.request.contextPath}/admin/master-token"><i class="fa fa-key"></i> Master API Token</a></li>
                    </ul>
                </li>

                <li class="treeview">
                    <a href="javascript:void(0)" onclick="toggleMenu(this)">
                        <i class="fa fa-truck"></i>
                        <span>Quản lý nhà cung cấp</span>
                        <span class="pull-right-container"><i class="fa fa-angle-left pull-right"></i></span>
                    </a>
                    <ul class="treeview-menu">
                        <li><a href="${pageContext.request.contextPath}/admin/supplier/list"><i class="fa fa-circle-o"></i> Danh sách nhà cung cấp</a></li>
                        <li><a href="${pageContext.request.contextPath}/admin/supplier/new"><i class="fa fa-circle-o"></i> Thêm nhà cung cấp</a></li>
                    </ul>
                </li>

                <li class="treeview">
                    <a href="javascript:void(0)" onclick="toggleMenu(this)">
                        <i class="fa fa-shopping-cart"></i>
                        <span>Đơn đặt hàng</span>
                        <span class="pull-right-container"><i class="fa fa-angle-left pull-right"></i></span>
                    </a>
                    <ul class="treeview-menu">
                        <li><a href="${pageContext.request.contextPath}/purchase-order"><i class="fa fa-circle-o"></i> Danh sách đơn hàng</a></li>
                        <li><a href="${pageContext.request.contextPath}/purchase-order?status=20"><i class="fa fa-clock-o"></i> Chờ duyệt (Pending)</a></li>
                        <li><a href="${pageContext.request.contextPath}/purchase-order?status=21"><i class="fa fa-check-circle"></i> Đã duyệt (Approved)</a></li>
                        <li><a href="${pageContext.request.contextPath}/purchase-order?status=24"><i class="fa fa-ban"></i> Đã hủy (Cancelled)</a></li>
                    </ul>
                </li>

                <li class="treeview">
                    <a href="javascript:void(0)" onclick="toggleMenu(this)">
                        <i class="fa fa-cogs"></i>
                        <span>Quản trị hệ thống</span>
                        <span class="pull-right-container"><i class="fa fa-angle-left pull-right"></i></span>
                    </a>
                    <ul class="treeview-menu">
                        <li><a href="${pageContext.request.contextPath}/admin/setting"><i class="fa fa-circle-o"></i> Quản lý Setting</a></li>
                        <li><a href="${pageContext.request.contextPath}/admin/setting?action=create"><i class="fa fa-circle-o"></i> Thêm Setting mới</a></li>
                    </ul>
                </li>
            </c:if>

            <!-- Common for all roles -->
            <li class="header">CÁ NHÂN</li>

            <li><a href="${pageContext.request.contextPath}/profile"><i class="fa fa-user"></i> <span>Thông tin cá nhân</span></a></li>

            <li class="treeview">
                <a href="javascript:void(0)" onclick="toggleMenu(this)">
                    <i class="fa fa-cogs"></i>
                    <span>Cài đặt</span>
                    <span class="pull-right-container"><i class="fa fa-angle-left pull-right"></i></span>
                </a>
                <ul class="treeview-menu">
                    <li><a href="${pageContext.request.contextPath}/profile?action=edit"><i class="fa fa-circle-o"></i> Chỉnh sửa thông tin</a></li>
                    <li><a href="${pageContext.request.contextPath}/profile?action=change-password"><i class="fa fa-circle-o"></i> Đổi mật khẩu</a></li>
                </ul>
            </li>

            <li><a href="${pageContext.request.contextPath}/logout"><i class="fa fa-sign-out"></i> <span>Đăng xuất</span></a></li>
        </ul>
    </section>
</aside>

<script>
function toggleMenu(element) {
    const menu = element.nextElementSibling;
    const icon = element.querySelector('.fa-angle-left, .fa-angle-down');
    const parentLi = element.parentElement;

    if (menu && menu.classList.contains('treeview-menu')) {
        const isOpen = menu.style.display === 'block';
        menu.style.display = isOpen ? 'none' : 'block';
        if (icon) {
            icon.classList.toggle('fa-angle-left', isOpen);
            icon.classList.toggle('fa-angle-down', !isOpen);
        }
        parentLi.classList.toggle('active', !isOpen);
    }
}

document.addEventListener('DOMContentLoaded', function() {
    const currentPath = window.location.pathname;
    const menuItems = document.querySelectorAll('.sidebar-menu a');

    menuItems.forEach(function(item) {
        const href = item.getAttribute('href');
        if (href && href !== 'javascript:void(0)' && currentPath.includes(href.split('?')[0])) {
            const li = item.parentElement;
            li.classList.add('active');
            const parentTreeview = li.closest('.treeview');
            if (parentTreeview) {
                const parentMenu = parentTreeview.querySelector('.treeview-menu');
                const parentIcon = parentTreeview.querySelector('.fa-angle-left');
                if (parentMenu) parentMenu.style.display = 'block';
                if (parentIcon) {
                    parentIcon.classList.remove('fa-angle-left');
                    parentIcon.classList.add('fa-angle-down');
                }
                parentTreeview.classList.add('active');
            }
        }
    });
});
</script>
