package filters;

import jakarta.servlet.*;
import jakarta.servlet.annotation.WebFilter;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.File;
import java.io.FileInputStream;
import java.io.IOException;
import java.io.OutputStream;

/**
 * ImageServeFilter - Serves images from web/uploads folder
 * This ensures images are always available even after Clean & Build
 * 
 * @author DrDYNew
 */
@WebFilter(urlPatterns = {"/uploads/*"})
public class ImageServeFilter implements Filter {

    @Override
    public void init(FilterConfig filterConfig) throws ServletException {
        System.out.println("ImageServeFilter initialized");
    }

    @Override
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain)
            throws IOException, ServletException {
        
        HttpServletRequest httpRequest = (HttpServletRequest) request;
        HttpServletResponse httpResponse = (HttpServletResponse) response;
        
        String requestURI = httpRequest.getRequestURI();
        String contextPath = httpRequest.getContextPath();
        
        // Remove context path to get the relative path
        String relativePath = requestURI.substring(contextPath.length());
        
        // Get real path from ServletContext
        String realPath = request.getServletContext().getRealPath("");
        String webPath;
        
        // If running from build folder, redirect to web folder
        if (realPath.contains("build")) {
            webPath = realPath.substring(0, realPath.indexOf("build")) + "web";
        } else {
            webPath = realPath;
        }
        
        // Construct full file path
        String filePath = webPath + relativePath.replace("/", File.separator);
        File imageFile = new File(filePath);
        
        // If file exists in web folder, serve it
        if (imageFile.exists() && imageFile.isFile()) {
            String mimeType = getServletContext(request).getMimeType(imageFile.getName());
            if (mimeType == null) {
                mimeType = "application/octet-stream";
            }
            
            httpResponse.setContentType(mimeType);
            httpResponse.setContentLength((int) imageFile.length());
            
            // Set cache headers (1 day)
            httpResponse.setHeader("Cache-Control", "public, max-age=86400");
            
            try (FileInputStream in = new FileInputStream(imageFile);
                 OutputStream out = httpResponse.getOutputStream()) {
                
                byte[] buffer = new byte[4096];
                int bytesRead;
                while ((bytesRead = in.read(buffer)) != -1) {
                    out.write(buffer, 0, bytesRead);
                }
                out.flush();
            }
            
            return; // Don't continue the chain
        }
        
        // If file not found, continue with normal processing (might be in build folder)
        chain.doFilter(request, response);
    }

    @Override
    public void destroy() {
        System.out.println("ImageServeFilter destroyed");
    }
    
    private ServletContext getServletContext(ServletRequest request) {
        return request.getServletContext();
    }
}
