/*
 * Email Service for sending emails
 */
package services;

import java.util.Properties;
import java.util.Date;
import jakarta.mail.Authenticator;
import jakarta.mail.Message;
import jakarta.mail.PasswordAuthentication;
import jakarta.mail.Session;
import jakarta.mail.Transport;
import jakarta.mail.internet.InternetAddress;
import jakarta.mail.internet.MimeMessage;

/**
 * Service to send emails
 * @author DrDYNew
 */
public class EmailService {
    
    private static final String EMAIL_FROM = "dungbd07@gmail.com";
    private static final String EMAIL_PASSWORD = "ugqy qkwr eavc epwk";
    private static final String SMTP_HOST = "smtp.gmail.com";
    private static final String SMTP_PORT = "587";
    
    /**
     * Send password reset email
     * @param toEmail Recipient email
     * @param resetLink Password reset link
     * @return true if sent successfully
     */
    public boolean sendPasswordResetEmail(String toEmail, String resetLink) {
        try {
            System.out.println("=== EMAIL SENDING DEBUG ===");
            System.out.println("From: " + EMAIL_FROM);
            System.out.println("To: " + toEmail);
            System.out.println("SMTP: " + SMTP_HOST + ":" + SMTP_PORT);
            
            // Setup mail server properties
            Properties props = new Properties();
            props.put("mail.smtp.auth", "true");
            props.put("mail.smtp.starttls.enable", "true");
            props.put("mail.smtp.host", SMTP_HOST);
            props.put("mail.smtp.port", SMTP_PORT);
            props.put("mail.smtp.ssl.trust", SMTP_HOST);
            props.put("mail.smtp.ssl.protocols", "TLSv1.2");
            
            // Create authenticator
            Authenticator auth = new Authenticator() {
                @Override
                protected PasswordAuthentication getPasswordAuthentication() {
                    return new PasswordAuthentication(EMAIL_FROM, EMAIL_PASSWORD);
                }
            };
            
            // Create session with debug enabled
            Session session = Session.getInstance(props, auth);
            
            System.out.println("Creating message...");
            // Create message
            Message message = new MimeMessage(session);
            message.setFrom(new InternetAddress(EMAIL_FROM));
            message.setRecipients(Message.RecipientType.TO, InternetAddress.parse(toEmail));
            message.setSubject("Đặt Lại Mật Khẩu - Coffee Shop Management");
            message.setSentDate(new Date());
            
            // Create HTML email content
            String htmlContent = createEmailTemplate(resetLink);
            message.setContent(htmlContent, "text/html; charset=utf-8");
            
            System.out.println("Sending email...");
            // Send email
            Transport.send(message);
            
            System.out.println("✓ Password reset email sent successfully to: " + toEmail);
            System.out.println("=========================");
            return true;
            
        } catch (Exception e) {
            System.err.println("✗ ERROR SENDING EMAIL:");
            System.err.println("Error type: " + e.getClass().getName());
            System.err.println("Error message: " + e.getMessage());
            e.printStackTrace();
            System.err.println("=========================");
            return false;
        }
    }
    
    /**
     * Create HTML email template
     * @param resetLink Password reset link
     * @return HTML content
     */
    private String createEmailTemplate(String resetLink) {
        return "<!DOCTYPE html>"
                + "<html>"
                + "<head>"
                + "<meta charset='UTF-8'>"
                + "<style>"
                + "body { font-family: Arial, sans-serif; background-color: #f4f4f4; margin: 0; padding: 20px; }"
                + ".container { max-width: 600px; margin: 0 auto; background-color: #ffffff; border-radius: 10px; overflow: hidden; box-shadow: 0 4px 6px rgba(0,0,0,0.1); }"
                + ".header { background: linear-gradient(135deg, #6B4423 0%, #3E2723 100%); color: white; padding: 30px; text-align: center; }"
                + ".header h1 { margin: 0; font-size: 28px; }"
                + ".content { padding: 40px 30px; color: #333333; }"
                + ".content h2 { color: #6B4423; margin-top: 0; }"
                + ".content p { line-height: 1.6; font-size: 16px; }"
                + ".button { display: inline-block; padding: 15px 40px; background: linear-gradient(135deg, #6B4423 0%, #8B6F47 100%); color: white !important; text-decoration: none; border-radius: 5px; font-weight: bold; margin: 20px 0; }"
                + ".button:hover { background: linear-gradient(135deg, #8B6F47 0%, #6B4423 100%); }"
                + ".warning { background-color: #fff3cd; border-left: 4px solid #ffc107; padding: 15px; margin: 20px 0; }"
                + ".footer { background-color: #f8f9fa; padding: 20px; text-align: center; color: #666666; font-size: 14px; }"
                + ".icon { font-size: 48px; margin-bottom: 20px; }"
                + "</style>"
                + "</head>"
                + "<body>"
                + "<div class='container'>"
                + "<div class='header'>"
                + "<div class='icon'>☕</div>"
                + "<h1>Coffee Shop Management</h1>"
                + "</div>"
                + "<div class='content'>"
                + "<h2>Yêu Cầu Đặt Lại Mật Khẩu</h2>"
                + "<p>Xin chào,</p>"
                + "<p>Chúng tôi đã nhận được yêu cầu đặt lại mật khẩu cho tài khoản của bạn. Nếu đây là bạn, vui lòng nhấp vào nút bên dưới để tạo mật khẩu mới:</p>"
                + "<center>"
                + "<a href='" + resetLink + "' class='button'>Đặt Lại Mật Khẩu</a>"
                + "</center>"
                + "<div class='warning'>"
                + "<strong>⚠️ Lưu ý quan trọng:</strong>"
                + "<ul>"
                + "<li>Link này chỉ có hiệu lực trong <strong>2 giờ</strong></li>"
                + "<li>Chỉ có thể sử dụng <strong>một lần</strong></li>"
                + "<li>Nếu bạn không yêu cầu đặt lại mật khẩu, vui lòng bỏ qua email này</li>"
                + "</ul>"
                + "</div>"
                + "<p>Nếu nút không hoạt động, bạn có thể sao chép và dán link sau vào trình duyệt:</p>"
                + "<p style='word-break: break-all; color: #007bff;'>" + resetLink + "</p>"
                + "<p>Trân trọng,<br><strong>Coffee Shop Management Team</strong></p>"
                + "</div>"
                + "<div class='footer'>"
                + "<p>© 2025 Coffee Shop Management. All rights reserved.</p>"
                + "<p>Email này được gửi tự động, vui lòng không trả lời.</p>"
                + "</div>"
                + "</div>"
                + "</body>"
                + "</html>";
    }
}
