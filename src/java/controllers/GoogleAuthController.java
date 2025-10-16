package controllers;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import services.GoogleAuthService;
import java.io.IOException;

/**
 * Google Auth Redirect Controller
 * Redirects user to Google OAuth2 authorization page
 * @author DrDYNew
 */
@WebServlet(name = "GoogleAuthController", urlPatterns = {"/google-auth"})
public class GoogleAuthController extends HttpServlet {
    
    private GoogleAuthService googleAuthService;
    
    @Override
    public void init() throws ServletException {
        super.init();
        googleAuthService = new GoogleAuthService();
    }
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        // Get Google authorization URL
        String authUrl = googleAuthService.getAuthorizationUrl(request.getContextPath());
        
        if (authUrl != null) {
            // Redirect to Google OAuth2 authorization page
            response.sendRedirect(authUrl);
        } else {
            // Error generating auth URL
            request.setAttribute("error", "Không thể tạo URL xác thực Google");
            request.getRequestDispatcher("/views/common/login.jsp").forward(request, response);
        }
    }
    
    @Override
    public String getServletInfo() {
        return "Google Auth Redirect Controller";
    }
}
