<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>


<header class="main-header">
    <!-- Logo -->
    <a href="${pageContext.request.contextPath}/" class="logo">
        <!-- mini logo for sidebar mini 50x50 pixels -->
        <span class="logo-mini"><b>C</b>S</span>
        <!-- logo for regular state and mobile devices -->
        <span class="logo-lg"><b>Coffee</b>Shop</span>
    </a>
    <!-- Header Navbar: style can be found in header.less -->
    <nav class="navbar navbar-static-top">
        <!-- Sidebar toggle button-->
        <a href="#" class="sidebar-toggle" data-toggle="offcanvas" role="button">
            <span class="sr-only">Toggle navigation</span>
        </a>

        <div class="navbar-custom-menu">
            <ul class="nav navbar-nav">
                <!-- User Account Menu -->
                <li class="dropdown user user-menu">
                    <a href="#" class="dropdown-toggle" data-toggle="dropdown">
                       
                                <img src="https://ui-avatars.com/api/?name=${sessionScope.user.fullName}&size=160&background=3c8dbc&color=fff" class="user-image" alt="User Image">
                          
                        <span class="hidden-xs">${sessionScope.user.fullName != null ? sessionScope.user.fullName : 'User'}</span>
                    </a>
                    <ul class="dropdown-menu">
                        <!-- User image -->
                        <li class="user-header">
                           
                                    <img src="https://ui-avatars.com/api/?name=${sessionScope.user.fullName}&size=160&background=3c8dbc&color=fff" class="img-circle" alt="User Image">
                             
                            <p>
                                ${sessionScope.user.fullName != null ? sessionScope.user.fullName : 'User'} - ${sessionScope.roleName != null ? sessionScope.roleName : 'Staff'}
                                <small>Member in ${sessionScope.user.createdAt != null ? sessionScope.user.createdAt : 'N/A'}</small>
                            </p>
                        </li>
                        <!-- Menu Footer-->
                        <li class="user-footer">
                            <div class="pull-left">
                                <a href="${pageContext.request.contextPath}/profile" class="btn btn-default btn-flat">
                                    <i class="fa fa-user"></i> Profile
                                </a>
                            </div>
                            <div class="pull-right">
                                <a href="${pageContext.request.contextPath}/logout" class="btn btn-default btn-flat">
                                    <i class="fa fa-sign-out"></i> Logut
                                </a>
                            </div>
                        </li>
                    </ul>
                </li>
            </ul>
        </div>
    </nav>
</header>
