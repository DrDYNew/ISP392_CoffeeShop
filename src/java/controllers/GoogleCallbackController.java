package controllers;

import dao.UserDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import model.User;
import services.AuthService;
import services.GoogleAuthService;
import services.GoogleAuthService.GoogleUserInfo;
import java.io.IOException;

/**
 * Google OAuth2 Callback Controller
 * @author DrDYNew
 */
@WebServlet(name = "GoogleCallbackController", urlPatterns = {"/google-callback"})
public class GoogleCallbackController extends HttpServlet {
    
    private GoogleAuthService googleAuthService;
    private UserDAO userDAO;
    private AuthService authService;
    
    @Override
    public void init() throws ServletException {
        super.init();
        googleAuthService = new GoogleAuthService();
        userDAO = new UserDAO();
        authService = new AuthService();
    }
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        String code = request.getParameter("code");
        String error = request.getParameter("error");
        
        // Check if user denied permission
        if (error != null) {
            request.setAttribute("error", "Bạn đã từ chối quyền truy cập Google");
            request.getRequestDispatcher("/views/common/login.jsp").forward(request, response);
            return;
        }
        
        // Check if code is present
        if (code == null || code.isEmpty()) {
            request.setAttribute("error", "Không nhận được mã xác thực từ Google");
            request.getRequestDispatcher("/views/common/login.jsp").forward(request, response);
            return;
        }
        
        try {
            // Exchange code for access token
            String accessToken = googleAuthService.getAccessToken(code);
            
            if (accessToken == null) {
                request.setAttribute("error", "Không thể lấy access token từ Google");
                request.getRequestDispatcher("/views/common/login.jsp").forward(request, response);
                return;
            }
            
            // Get user info from Google
            GoogleUserInfo googleUserInfo = googleAuthService.getUserInfo(accessToken);
            
            if (googleUserInfo == null) {
                request.setAttribute("error", "Không thể lấy thông tin người dùng từ Google");
                request.getRequestDispatcher("/views/common/login.jsp").forward(request, response);
                return;
            }
            
            // Check if email is verified
            if (!googleUserInfo.isVerifiedEmail()) {
                request.setAttribute("error", "Email Google của bạn chưa được xác minh");
                request.getRequestDispatcher("/views/common/login.jsp").forward(request, response);
                return;
            }
            
            // Check if user exists in database
            User user = userDAO.getUserByEmail(googleUserInfo.getEmail());
            
            if (user == null) {
                // User doesn't exist in database
                request.setAttribute("error", "Tài khoản không tồn tại trong hệ thống. Vui lòng liên hệ quản trị viên để được cấp tài khoản.");
                request.setAttribute("email", googleUserInfo.getEmail());
                request.getRequestDispatcher("/views/common/login.jsp").forward(request, response);
                return;
            }
            
            // Check if user is active
            if (!user.isActive()) {
                request.setAttribute("error", "Tài khoản của bạn đã bị khóa");
                request.getRequestDispatcher("/views/common/login.jsp").forward(request, response);
                return;
            }
            
            // Login successful - Create session
            HttpSession session = request.getSession();
            session.setAttribute("user", user);
            session.setAttribute("roleName", authService.getRoleName(user.getRoleID()));
            session.setAttribute("loginMethod", "google"); // Mark as Google login
            
            // Set session timeout (30 minutes)
            session.setMaxInactiveInterval(30 * 60);
            
            // Redirect to appropriate dashboard
            redirectToDashboard(request, response, user);
            
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "Đã xảy ra lỗi khi đăng nhập với Google: " + e.getMessage());
            request.getRequestDispatcher("/views/common/login.jsp").forward(request, response);
        }
    }
    
    /**
     * Redirect user to appropriate dashboard based on role
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
            default:
                response.sendRedirect(contextPath + "/views/common/dashboard.jsp");
                break;
        }
    }
    
    @Override
    public String getServletInfo() {
        return "Google OAuth2 Callback Controller";
    }
}
