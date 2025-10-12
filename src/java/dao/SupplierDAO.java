package dao;

import model.Supplier;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

/**
 * DAO for Supplier operations
 */
public class SupplierDAO extends BaseDAO {

    /**
     * Get all suppliers
     */
    public List<Supplier> getAllSuppliers() {
        List<Supplier> list = new ArrayList<>();
        String sql = "SELECT * FROM Suppliers WHERE IsActive = TRUE ORDER BY SupplierName";
        
        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ResultSet rs = ps.executeQuery();
            
            while (rs.next()) {
                Supplier supplier = new Supplier();
                supplier.setSupplierID(rs.getInt("SupplierID"));
                supplier.setSupplierName(rs.getString("SupplierName"));
                supplier.setContactName(rs.getString("ContactName"));
                supplier.setEmail(rs.getString("Email"));
                supplier.setPhone(rs.getString("Phone"));
                supplier.setAddress(rs.getString("Address"));
                supplier.setActive(rs.getBoolean("IsActive"));
                supplier.setCreatedAt(rs.getTimestamp("CreatedAt"));
                list.add(supplier);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    /**
     * Get supplier by ID
     */
    public Supplier getSupplierById(int supplierID) {
        String sql = "SELECT * FROM Suppliers WHERE SupplierID = ?";
        
        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setInt(1, supplierID);
            ResultSet rs = ps.executeQuery();
            
            if (rs.next()) {
                Supplier supplier = new Supplier();
                supplier.setSupplierID(rs.getInt("SupplierID"));
                supplier.setSupplierName(rs.getString("SupplierName"));
                supplier.setContactName(rs.getString("ContactName"));
                supplier.setEmail(rs.getString("Email"));
                supplier.setPhone(rs.getString("Phone"));
                supplier.setAddress(rs.getString("Address"));
                supplier.setActive(rs.getBoolean("IsActive"));
                supplier.setCreatedAt(rs.getTimestamp("CreatedAt"));
                return supplier;
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    /**
     * Insert new supplier
     */
    public int insertSupplier(Supplier supplier) {
        String sql = "INSERT INTO Suppliers (SupplierName, ContactName, Email, Phone, Address, IsActive) " +
                    "VALUES (?, ?, ?, ?, ?, ?) RETURNING SupplierID";
        
        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setString(1, supplier.getSupplierName());
            ps.setString(2, supplier.getContactName());
            ps.setString(3, supplier.getEmail());
            ps.setString(4, supplier.getPhone());
            ps.setString(5, supplier.getAddress());
            ps.setBoolean(6, supplier.isActive());
            
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return rs.getInt(1);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return -1;
    }

    /**
     * Update supplier
     */
    public boolean updateSupplier(Supplier supplier) {
        String sql = "UPDATE Suppliers SET SupplierName = ?, ContactName = ?, Email = ?, " +
                    "Phone = ?, Address = ?, IsActive = ? WHERE SupplierID = ?";
        
        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setString(1, supplier.getSupplierName());
            ps.setString(2, supplier.getContactName());
            ps.setString(3, supplier.getEmail());
            ps.setString(4, supplier.getPhone());
            ps.setString(5, supplier.getAddress());
            ps.setBoolean(6, supplier.isActive());
            ps.setInt(7, supplier.getSupplierID());
            
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    /**
     * Delete supplier (soft delete - set IsActive to false)
     */
    public boolean deleteSupplier(int supplierID) {
        String sql = "UPDATE Suppliers SET IsActive = FALSE WHERE SupplierID = ?";
        
        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setInt(1, supplierID);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }
}
