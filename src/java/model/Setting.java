package models;

import java.sql.Timestamp;

public class Setting {
    private int settingID;
    private String type;
    private String value;
    private String description;
    private boolean isActive;

    // Default constructor
    public Setting() {
    }

    // Constructor with all fields
    public Setting(int settingID, String type, String value, String description, boolean isActive) {
        this.settingID = settingID;
        this.type = type;
        this.value = value;
        this.description = description;
        this.isActive = isActive;
    }

    // Constructor without ID (for insert operations)
    public Setting(String type, String value, String description, boolean isActive) {
        this.type = type;
        this.value = value;
        this.description = description;
        this.isActive = isActive;
    }

    // Getters and Setters
    public int getSettingID() {
        return settingID;
    }

    public void setSettingID(int settingID) {
        this.settingID = settingID;
    }

    public String getType() {
        return type;
    }

    public void setType(String type) {
        this.type = type;
    }

    public String getValue() {
        return value;
    }

    public void setValue(String value) {
        this.value = value;
    }

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }

    public boolean isActive() {
        return isActive;
    }

    public void setActive(boolean active) {
        isActive = active;
    }

    public String toString() {
        return "Setting{" +
                "settingID=" + settingID +
                ", type='" + type + '\'' +
                ", value='" + value + '\'' +
                ", description='" + description + '\'' +
                ", isActive=" + isActive +
                '}';
    }
}