package dao;

import model.Issue;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.List;
import java.math.BigDecimal;

/**
 * DAO class for Issue management
 * @author DrDYNew
 */
public class IssueDAO extends BaseDAO {
    
    /**
     * Get all issues with pagination, filtering, and detailed information
     * @param page Page number (starting from 1)
     * @param pageSize Number of records per page
     * @param statusFilter Status filter (null for all statuses)
     * @param ingredientFilter Ingredient filter (null for all ingredients)
     * @param createdByFilter CreatedBy filter (null for all creators)
     * @return List of issues with detailed information
     */
    public List<Issue> getAllIssues(int page, int pageSize, Integer statusFilter, 
                                   Integer ingredientFilter, Integer createdByFilter) {
        List<Issue> issues = new ArrayList<>();
        StringBuilder sql = new StringBuilder();
        sql.append("SELECT i.IssueID, i.IngredientID, i.Description, i.Quantity, ");
        sql.append("i.StatusID, i.CreatedBy, i.ConfirmedBy, i.CreatedAt, ");
        sql.append("ing.Name as IngredientName, ");
        sql.append("u.Value as UnitName, ");
        sql.append("st.Value as StatusName, ");
        sql.append("uc.FullName as CreatedByName, ");
        sql.append("uconf.FullName as ConfirmedByName ");
        sql.append("FROM Issues i ");
        sql.append("LEFT JOIN Ingredients ing ON i.IngredientID = ing.IngredientID ");
        sql.append("LEFT JOIN Setting u ON ing.UnitID = u.SettingID ");
        sql.append("LEFT JOIN Setting st ON i.StatusID = st.SettingID ");
        sql.append("LEFT JOIN Users uc ON i.CreatedBy = uc.UserID ");
        sql.append("LEFT JOIN Users uconf ON i.ConfirmedBy = uconf.UserID ");
        sql.append("WHERE 1=1 ");
        
        // Add filters
        List<Object> params = new ArrayList<>();
        if (statusFilter != null) {
            sql.append("AND i.StatusID = ? ");
            params.add(statusFilter);
        }
        if (ingredientFilter != null) {
            sql.append("AND i.IngredientID = ? ");
            params.add(ingredientFilter);
        }
        if (createdByFilter != null) {
            sql.append("AND i.CreatedBy = ? ");
            params.add(createdByFilter);
        }
        
        // Add ordering and pagination
        sql.append("ORDER BY i.CreatedAt DESC ");
        sql.append("LIMIT ? OFFSET ?");
        params.add(pageSize);
        params.add((page - 1) * pageSize);
        
        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql.toString())) {
            
            // Set parameters
            for (int i = 0; i < params.size(); i++) {
                ps.setObject(i + 1, params.get(i));
            }
            
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                Issue issue = new Issue();
                issue.setIssueID(rs.getInt("IssueID"));
                issue.setIngredientID(rs.getInt("IngredientID"));
                issue.setDescription(rs.getString("Description"));
                issue.setQuantity(rs.getBigDecimal("Quantity"));
                issue.setStatusID(rs.getInt("StatusID"));
                issue.setCreatedBy(rs.getInt("CreatedBy"));
                issue.setConfirmedBy((Integer) rs.getObject("ConfirmedBy"));
                issue.setCreatedAt(rs.getTimestamp("CreatedAt"));
                
                // Set additional display fields
                issue.setIngredientName(rs.getString("IngredientName"));
                issue.setUnitName(rs.getString("UnitName"));
                issue.setStatusName(rs.getString("StatusName"));
                issue.setCreatedByName(rs.getString("CreatedByName"));
                issue.setConfirmedByName(rs.getString("ConfirmedByName"));
                
                issues.add(issue);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return issues;
    }
    
    /**
     * Get total count of issues with filters
     * @param statusFilter Status filter (null for all statuses)
     * @param ingredientFilter Ingredient filter (null for all ingredients)
     * @param createdByFilter CreatedBy filter (null for all creators)
     * @return Total count
     */
    public int getTotalIssueCount(Integer statusFilter, Integer ingredientFilter, Integer createdByFilter) {
        StringBuilder sql = new StringBuilder();
        sql.append("SELECT COUNT(*) FROM Issues WHERE 1=1 ");
        
        List<Object> params = new ArrayList<>();
        if (statusFilter != null) {
            sql.append("AND StatusID = ? ");
            params.add(statusFilter);
        }
        if (ingredientFilter != null) {
            sql.append("AND IngredientID = ? ");
            params.add(ingredientFilter);
        }
        if (createdByFilter != null) {
            sql.append("AND CreatedBy = ? ");
            params.add(createdByFilter);
        }
        
        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql.toString())) {
            
            for (int i = 0; i < params.size(); i++) {
                ps.setObject(i + 1, params.get(i));
            }
            
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return rs.getInt(1);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return 0;
    }
    
    /**
     * Get issue by ID with detailed information
     * @param issueID Issue ID
     * @return Issue object or null if not found
     */
    public Issue getIssueById(int issueID) {
        String sql = "SELECT i.IssueID, i.IngredientID, i.Description, i.Quantity, " +
                    "i.StatusID, i.CreatedBy, i.ConfirmedBy, i.CreatedAt, " +
                    "ing.Name as IngredientName, " +
                    "u.Value as UnitName, " +
                    "st.Value as StatusName, " +
                    "uc.FullName as CreatedByName, " +
                    "uconf.FullName as ConfirmedByName " +
                    "FROM Issues i " +
                    "LEFT JOIN Ingredients ing ON i.IngredientID = ing.IngredientID " +
                    "LEFT JOIN Setting u ON ing.UnitID = u.SettingID " +
                    "LEFT JOIN Setting st ON i.StatusID = st.SettingID " +
                    "LEFT JOIN Users uc ON i.CreatedBy = uc.UserID " +
                    "LEFT JOIN Users uconf ON i.ConfirmedBy = uconf.UserID " +
                    "WHERE i.IssueID = ?";
        
        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setInt(1, issueID);
            ResultSet rs = ps.executeQuery();
            
            if (rs.next()) {
                Issue issue = new Issue();
                issue.setIssueID(rs.getInt("IssueID"));
                issue.setIngredientID(rs.getInt("IngredientID"));
                issue.setDescription(rs.getString("Description"));
                issue.setQuantity(rs.getBigDecimal("Quantity"));
                issue.setStatusID(rs.getInt("StatusID"));
                issue.setCreatedBy(rs.getInt("CreatedBy"));
                issue.setConfirmedBy((Integer) rs.getObject("ConfirmedBy"));
                issue.setCreatedAt(rs.getTimestamp("CreatedAt"));
                
                // Set additional display fields
                issue.setIngredientName(rs.getString("IngredientName"));
                issue.setUnitName(rs.getString("UnitName"));
                issue.setStatusName(rs.getString("StatusName"));
                issue.setCreatedByName(rs.getString("CreatedByName"));
                issue.setConfirmedByName(rs.getString("ConfirmedByName"));
                
                return issue;
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }
    
    /**
     * Create new issue
     * @param issue Issue object
     * @return Generated issue ID, or -1 if failed
     */
    public int createIssue(Issue issue) {
        String sql = "INSERT INTO Issues (IngredientID, Description, Quantity, StatusID, CreatedBy, ConfirmedBy) " +
                    "VALUES (?, ?, ?, ?, ?, ?)";
        
        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            
            ps.setInt(1, issue.getIngredientID());
            ps.setString(2, issue.getDescription());
            ps.setBigDecimal(3, issue.getQuantity());
            ps.setInt(4, issue.getStatusID());
            ps.setInt(5, issue.getCreatedBy());
            if (issue.getConfirmedBy() != null) {
                ps.setInt(6, issue.getConfirmedBy());
            } else {
                ps.setNull(6, java.sql.Types.INTEGER);
            }
            
            int affectedRows = ps.executeUpdate();
            if (affectedRows > 0) {
                ResultSet rs = ps.getGeneratedKeys();
                if (rs.next()) {
                    return rs.getInt(1);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return -1;
    }
    
    /**
     * Update issue
     * @param issue Issue object with updated information
     * @return true if successful, false otherwise
     */
    public boolean updateIssue(Issue issue) {
        String sql = "UPDATE Issues SET IngredientID = ?, Description = ?, Quantity = ?, " +
                    "StatusID = ?, ConfirmedBy = ? WHERE IssueID = ?";
        
        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setInt(1, issue.getIngredientID());
            ps.setString(2, issue.getDescription());
            ps.setBigDecimal(3, issue.getQuantity());
            ps.setInt(4, issue.getStatusID());
            if (issue.getConfirmedBy() != null) {
                ps.setInt(5, issue.getConfirmedBy());
            } else {
                ps.setNull(5, java.sql.Types.INTEGER);
            }
            ps.setInt(6, issue.getIssueID());
            
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }
    
    /**
     * Delete issue by ID
     * @param issueID Issue ID
     * @return true if successful, false otherwise
     */
    public boolean deleteIssue(int issueID) {
        String sql = "DELETE FROM Issues WHERE IssueID = ?";
        
        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setInt(1, issueID);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }
    
    /**
     * Update issue status
     * @param issueID Issue ID
     * @param statusID New status ID
     * @return true if successful
     */
    public boolean updateIssueStatus(int issueID, int statusID) {
        String sql = "UPDATE Issues SET StatusID = ? WHERE IssueID = ?";
        
        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setInt(1, statusID);
            ps.setInt(2, issueID);
            
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }
    
    /**
     * Resolve issue (set status to Resolved)
     * @param issueID Issue ID
     * @return true if successful
     */
    public boolean resolveIssue(int issueID) {
        String getStatusSQL = "SELECT SettingID FROM Setting WHERE Type = 'IssueStatus' AND Value = 'Resolved'";
        String updateSQL = "UPDATE Issues SET StatusID = ? WHERE IssueID = ?";
        
        try (Connection conn = getConnection();
             PreparedStatement psStatus = conn.prepareStatement(getStatusSQL);
             PreparedStatement psUpdate = conn.prepareStatement(updateSQL)) {
            
            // Get Resolved status ID
            ResultSet rs = psStatus.executeQuery();
            if (rs.next()) {
                int resolvedStatusID = rs.getInt("SettingID");
                
                // Update issue
                psUpdate.setInt(1, resolvedStatusID);
                psUpdate.setInt(2, issueID);
                
                return psUpdate.executeUpdate() > 0;
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }
    
    /**
     * Reject issue with reason
     * @param issueID Issue ID
     * @param rejectionReason Reason for rejection
     * @return true if successful
     */
    public boolean rejectIssue(int issueID, String rejectionReason) {
        String getStatusSQL = "SELECT SettingID FROM Setting WHERE Type = 'IssueStatus' AND Value = 'Rejected'";
        String updateSQL = "UPDATE Issues SET StatusID = ?, RejectionReason = ? WHERE IssueID = ?";
        
        try (Connection conn = getConnection();
             PreparedStatement psStatus = conn.prepareStatement(getStatusSQL);
             PreparedStatement psUpdate = conn.prepareStatement(updateSQL)) {
            
            // Get Rejected status ID
            ResultSet rs = psStatus.executeQuery();
            if (rs.next()) {
                int rejectedStatusID = rs.getInt("SettingID");
                
                // Update issue
                psUpdate.setInt(1, rejectedStatusID);
                psUpdate.setString(2, rejectionReason);
                psUpdate.setInt(3, issueID);
                
                return psUpdate.executeUpdate() > 0;
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }
    
    /**
     * Get issue statistics by status
     * @return Array of counts [Reported, Under Investigation, Resolved, Rejected]
     */
    public int[] getIssueStatsByStatus() {
        int[] stats = new int[4]; // [Reported, Under Investigation, Resolved, Rejected]
        String sql = "SELECT st.Value as StatusName, COUNT(*) as Count " +
                    "FROM Issues i " +
                    "JOIN Setting st ON i.StatusID = st.SettingID " +
                    "WHERE st.Type = 'IssueStatus' " +
                    "GROUP BY st.Value";
        
        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                String statusName = rs.getString("StatusName");
                int count = rs.getInt("Count");
                
                switch (statusName) {
                    case "Reported":
                        stats[0] = count;
                        break;
                    case "Under Investigation":
                        stats[1] = count;
                        break;
                    case "Resolved":
                        stats[2] = count;
                        break;
                    case "Rejected":
                        stats[3] = count;
                        break;
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return stats;
    }
}
