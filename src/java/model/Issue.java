package model;

import java.math.BigDecimal;
import java.sql.Timestamp;

public class Issue {
    private int issueID;
    private int ingredientID;
    private BigDecimal quantity;
    private int statusID;
    private int createdBy;
    private Integer confirmedBy;
    private Timestamp createdAt;

    // Default constructor
    public Issue() {
    }

    // Constructor with all fields
    public Issue(int issueID, int ingredientID, BigDecimal quantity, int statusID, 
                int createdBy, Integer confirmedBy, Timestamp createdAt) {
        this.issueID = issueID;
        this.ingredientID = ingredientID;
        this.quantity = quantity;
        this.statusID = statusID;
        this.createdBy = createdBy;
        this.confirmedBy = confirmedBy;
        this.createdAt = createdAt;
    }

    // Constructor without ID and timestamp (for insert operations)
    public Issue(int ingredientID, BigDecimal quantity, int statusID, 
                int createdBy, Integer confirmedBy) {
        this.ingredientID = ingredientID;
        this.quantity = quantity;
        this.statusID = statusID;
        this.createdBy = createdBy;
        this.confirmedBy = confirmedBy;
    }

    // Getters and Setters
    public int getIssueID() {
        return issueID;
    }

    public void setIssueID(int issueID) {
        this.issueID = issueID;
    }

    public int getIngredientID() {
        return ingredientID;
    }

    public void setIngredientID(int ingredientID) {
        this.ingredientID = ingredientID;
    }

    public BigDecimal getQuantity() {
        return quantity;
    }

    public void setQuantity(BigDecimal quantity) {
        this.quantity = quantity;
    }

    public int getStatusID() {
        return statusID;
    }

    public void setStatusID(int statusID) {
        this.statusID = statusID;
    }

    public int getCreatedBy() {
        return createdBy;
    }

    public void setCreatedBy(int createdBy) {
        this.createdBy = createdBy;
    }

    public Integer getConfirmedBy() {
        return confirmedBy;
    }

    public void setConfirmedBy(Integer confirmedBy) {
        this.confirmedBy = confirmedBy;
    }

    public Timestamp getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(Timestamp createdAt) {
        this.createdAt = createdAt;
    }

    public String toString() {
        return "Issue{" +
                "issueID=" + issueID +
                ", ingredientID=" + ingredientID +
                ", quantity=" + quantity +
                ", statusID=" + statusID +
                ", createdBy=" + createdBy +
                ", confirmedBy=" + confirmedBy +
                ", createdAt=" + createdAt +
                '}';
    }
}