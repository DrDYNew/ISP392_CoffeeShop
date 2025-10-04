package controllers;

import model.User;
import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

/**
 * TestController for testing sidebar functionality
 * @author DrDYNew
 */
@WebServlet(name = "TestController", urlPatterns = {"/test"})
public class TestController extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        // Create a mock session for testing
        HttpSession session = request.getSession();
        
        // Set test user data if not exists
        if (session.getAttribute("user") == null) {
            // Mock user for testing
            User testUser = new User();
            testUser.setUserID(1);
            testUser.setFullName("Test Admin");
            testUser.setEmail("admin@test.com");
            
            session.setAttribute("user", testUser);
            session.setAttribute("roleName", "Admin"); // Change to HR, Barista, Inventory for testing different roles
        }
        
        // Forward to test page
        request.getRequestDispatcher("/views/common/test-sidebar.jsp").forward(request, response);
    }
}