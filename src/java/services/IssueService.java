package services;

import dao.IssueDAO;
import model.Issue;
import java.util.List;

/**
 * Service layer for Issue management
 * @author DrDYNew
 */
public class IssueService {
    
    private IssueDAO issueDAO;
    
    public IssueService() {
        this.issueDAO = new IssueDAO();
    }
    
    /**
     * Result class to hold issues with pagination info
     */
    public static class IssueResult {
        private List<Issue> issues;
        private int totalPages;
        private int currentPage;
        private int totalCount;
        
        public IssueResult(List<Issue> issues, int totalPages, int currentPage, int totalCount) {
            this.issues = issues;
            this.totalPages = totalPages;
            this.currentPage = currentPage;
            this.totalCount = totalCount;
        }
        
        public List<Issue> getIssues() {
            return issues;
        }
        
        public int getTotalPages() {
            return totalPages;
        }
        
        public int getCurrentPage() {
            return currentPage;
        }
        
        public int getTotalCount() {
            return totalCount;
        }
    }
    
    /**
     * Get all issues with pagination and filtering
     */
    public IssueResult getAllIssues(int page, int pageSize, Integer statusFilter, 
                                    Integer ingredientFilter, Integer createdByFilter) {
        List<Issue> issues = issueDAO.getAllIssues(page, pageSize, statusFilter, ingredientFilter, createdByFilter);
        int totalCount = issueDAO.getTotalIssueCount(statusFilter, ingredientFilter, createdByFilter);
        int totalPages = (int) Math.ceil((double) totalCount / pageSize);
        
        return new IssueResult(issues, totalPages, page, totalCount);
    }
    
    /**
     * Get issue by ID
     */
    public Issue getIssueById(int issueID) {
        return issueDAO.getIssueById(issueID);
    }
    
    /**
     * Create new issue
     */
    public int createIssue(Issue issue) {
        return issueDAO.createIssue(issue);
    }
    
    /**
     * Update issue
     */
    public boolean updateIssue(Issue issue) {
        return issueDAO.updateIssue(issue);
    }
    
    /**
     * Delete issue
     */
    public boolean deleteIssue(int issueID) {
        return issueDAO.deleteIssue(issueID);
    }
    
    /**
     * Get issue statistics
     */
    public int[] getIssueStatsByStatus() {
        return issueDAO.getIssueStatsByStatus();
    }
    
    /**
     * Update issue status
     * @param issueID Issue ID
     * @param statusID New status ID
     * @return Error message if failed, null if successful
     */
    public String updateIssueStatus(int issueID, int statusID) {
        // Check if issue exists
        Issue existingIssue = issueDAO.getIssueById(issueID);
        if (existingIssue == null) {
            return "Không tìm thấy sự cố";
        }
        
        // Update status
        if (issueDAO.updateIssueStatus(issueID, statusID)) {
            return null; // Success
        } else {
            return "Lỗi hệ thống khi cập nhật trạng thái";
        }
    }
    
    /**
     * Resolve issue (set status to Resolved)
     * @param issueID Issue ID
     * @return Error message if failed, null if successful
     */
    public String resolveIssue(int issueID) {
        // Check if issue exists
        Issue existingIssue = issueDAO.getIssueById(issueID);
        if (existingIssue == null) {
            return "Không tìm thấy sự cố";
        }
        
        // Resolve the issue
        if (issueDAO.resolveIssue(issueID)) {
            return null; // Success
        } else {
            return "Lỗi hệ thống khi giải quyết sự cố";
        }
    }
    
    /**
     * Reject issue with reason
     * @param issueID Issue ID
     * @param rejectionReason Reason for rejection
     * @return Error message if failed, null if successful
     */
    public String rejectIssue(int issueID, String rejectionReason) {
        // Validate rejection reason
        if (rejectionReason == null || rejectionReason.trim().isEmpty()) {
            return "Vui lòng nhập lý do từ chối";
        }
        
        // Check if issue exists
        Issue existingIssue = issueDAO.getIssueById(issueID);
        if (existingIssue == null) {
            return "Không tìm thấy sự cố";
        }
        
        // Reject the issue
        if (issueDAO.rejectIssue(issueID, rejectionReason.trim())) {
            return null; // Success
        } else {
            return "Lỗi hệ thống khi từ chối sự cố";
        }
    }
    
    /**
     * Approve issue (set status to In Progress - StatusID = 26)
     * Used by Inventory Staff to approve Barista's issue request
     * @param issueID Issue ID
     * @return Error message if failed, null if successful
     */
    public String approveIssue(int issueID) {
        // Check if issue exists
        Issue existingIssue = issueDAO.getIssueById(issueID);
        if (existingIssue == null) {
            return "Không tìm thấy sự cố";
        }
        
        // Check if issue is in Pending status (StatusID = 25)
        if (existingIssue.getStatusID() != 25) {
            return "Chỉ có thể phê duyệt sự cố đang ở trạng thái Chờ xử lý";
        }
        
        // Approve the issue - change status to "In Progress" (StatusID = 26)
        if (issueDAO.updateIssueStatus(issueID, 26)) {
            return null; // Success
        } else {
            return "Lỗi hệ thống khi phê duyệt sự cố";
        }
    }
}
