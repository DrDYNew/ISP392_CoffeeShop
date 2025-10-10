/*
 * Test Email Service
 */
package test;

import services.EmailService;

/**
 * Test class to verify email sending
 * @author DrDYNew
 */
public class TestEmailService {
    
    public static void main(String[] args) {
        System.out.println("========================================");
        System.out.println("Testing Email Service");
        System.out.println("========================================\n");
        
        EmailService emailService = new EmailService();
        String testEmail = "dungbd07@gmail.com";
        String testLink = "http://localhost:8080/ISP392_CoffeeShop/reset-password?token=TEST-TOKEN-123";
        
        System.out.println("Sending test email to: " + testEmail);
        System.out.println("Please wait...\n");
        
        boolean result = emailService.sendPasswordResetEmail(testEmail, testLink);
        
        System.out.println("\n========================================");
        if (result) {
            System.out.println("✓ Email sent successfully!");
            System.out.println("\nPlease check:");
            System.out.println("1. Inbox of " + testEmail);
            System.out.println("2. Spam/Junk folder");
            System.out.println("3. Promotions tab (if using Gmail)");
        } else {
            System.out.println("✗ Failed to send email");
            System.out.println("\nCheck:");
            System.out.println("1. Email credentials in EmailService.java");
            System.out.println("2. Internet connection");
            System.out.println("3. Gmail App Password");
            System.out.println("4. Firewall settings (port 587)");
        }
        System.out.println("========================================");
    }
}
