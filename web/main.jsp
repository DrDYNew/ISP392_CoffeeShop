<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%
    // Check if user is already logged in
    if (session.getAttribute("user") != null) {
        // User is logged in, redirect to appropriate dashboard
        String roleName = (String) session.getAttribute("roleName");
        if (roleName != null) {
            switch (roleName.toLowerCase()) {
                case "admin":
                    response.sendRedirect(request.getContextPath() + "/views/admin/dashboard.jsp");
                    break;
                case "hr":
                    response.sendRedirect(request.getContextPath() + "/views/hr/dashboard.jsp");
                    break;
                case "inventory":
                    response.sendRedirect(request.getContextPath() + "/views/inventory-staff/dashboard.jsp");
                    break;
                case "barista":
                    response.sendRedirect(request.getContextPath() + "/views/barista/dashboard.jsp");
                    break;
                default:
                    response.sendRedirect(request.getContextPath() + "/login");
                    break;
            }
        } else {
            response.sendRedirect(request.getContextPath() + "/login");
        }
    } else {
        // User is not logged in, redirect to login page
        response.sendRedirect(request.getContextPath() + "/login");
    }
%>