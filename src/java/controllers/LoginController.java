/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */

package controllers;

import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import services.AuthService;
import model.AuthResponse;
import model.User;

/**
 * Login Controller handles authentication
 * @author DrDYNew
 */
@WebServlet(name = "LoginController", urlPatterns = {"/login", "/logout"})
public class LoginController extends HttpServlet {
    
    private AuthService authService;
    
    @Override
    public void init() throws ServletException {
        super.init();
        authService = new AuthService();
    }
   
    /** 
     * Handles the HTTP <code>GET</code> method.
     * Shows login page or logout
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
    throws ServletException, IOException {
        System.out.println("=== LOGIN CONTROLLER DEBUG ===");
        System.out.println("Path: " + request.getServletPath());
        System.out.println("Message param: " + request.getParameter("message"));
        
        String path = request.getServletPath();
        
        if ("/logout".equals(path)) {
            // Handle logout
            HttpSession session = request.getSession(false);
            if (session != null) {
                session.invalidate();
            }
            response.sendRedirect(request.getContextPath() + "/login?message=Đăng xuất thành công");
            return;
        }
        
        // Check if user is already logged in
        HttpSession session = request.getSession(false);
        if (session != null && session.getAttribute("user") != null) {
            System.out.println("User already logged in, redirecting to dashboard");
            // User is already logged in, redirect to dashboard
            redirectToDashboard(request, response, (User) session.getAttribute("user"));
            return;
        }
        
        // Show login page
        System.out.println("Forwarding to login.jsp");
        request.getRequestDispatcher("/views/common/login.jsp").forward(request, response);
    }

    /** 
     * Handles the HTTP <code>POST</code> method.
     * Process login form
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
    throws ServletException, IOException {
        // Set encoding for Vietnamese
        request.setCharacterEncoding("UTF-8");
        response.setCharacterEncoding("UTF-8");
        
        String email = request.getParameter("email");
        String password = request.getParameter("password");
        String rememberMe = request.getParameter("rememberMe");
        
        // Authenticate user
        AuthResponse authResponse = authService.login(email, password);
        
        if (authResponse.isSuccess()) {
            // Login successful, create session
            HttpSession session = request.getSession();
            session.setAttribute("user", authResponse.getUser());
            session.setAttribute("roleName", authResponse.getRoleName());
            
            // Set session timeout (30 minutes)
            session.setMaxInactiveInterval(30 * 60);
            
            // TODO: Implement remember me functionality if needed
            
            // Redirect to appropriate dashboard
            redirectToDashboard(request, response, authResponse.getUser());
        } else {
            // Login failed, return to login page with error
            request.setAttribute("error", authResponse.getMessage());
            request.setAttribute("email", email); // Keep email for user convenience
            request.getRequestDispatcher("/views/common/login.jsp").forward(request, response);
        }
    }
    
    /**
     * Redirect user to appropriate dashboard based on role
     * @param request HTTP request
     * @param response HTTP response  
     * @param user Logged in user
     * @throws IOException if redirect fails
     */
    private void redirectToDashboard(HttpServletRequest request, HttpServletResponse response, User user) 
            throws IOException {
        
        String roleName = authService.getRoleName(user.getRoleID());
        String contextPath = request.getContextPath();
        
        switch (roleName.toLowerCase()) {
            case "admin":
                response.sendRedirect(contextPath + "/admin/dashboard");
                break;
            case "hr":
                response.sendRedirect(contextPath + "/views/hr/dashboard.jsp");
                break;
            case "inventory":
                response.sendRedirect(contextPath + "/inventory-dashboard");
                break;
            case "barista":
                response.sendRedirect(contextPath + "/views/barista/dashboard.jsp");
                break;
            case "user":
                response.sendRedirect(contextPath + "/user/shop?action=list");
                break;
            default:
                // Default dashboard if role not recognized
                response.sendRedirect(contextPath + "/views/common/dashboard.jsp");
                break;
        }
    }

    /** 
     * Returns a short description of the servlet.
     * @return a String containing servlet description
     */
    @Override
    public String getServletInfo() {
        return "Login Controller for Coffee Shop Management System";
    }
}
