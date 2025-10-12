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
}
