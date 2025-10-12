package dao;

import model.Order;
import model.OrderDetail;
import model.Product;
import java.sql.*;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.math.BigDecimal;

/**
 * DAO for Order operations
 * @author DrDYNew
 */
public class OrderDAO extends BaseDAO {

    /**
     * Get all orders with pagination
     * @param page Page number (starting from 1)
     * @param pageSize Number of records per page
     * @return List of orders
     */
    public List<Order> getAllOrders(int page, int pageSize) {
        List<Order> list = new ArrayList<>();
        String sql = "SELECT * FROM Orders ORDER BY CreatedAt DESC LIMIT ? OFFSET ?";
        
        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setInt(1, pageSize);
            ps.setInt(2, (page - 1) * pageSize);
            ResultSet rs = ps.executeQuery();
            
            while (rs.next()) {
                Order order = new Order();
                order.setOrderID(rs.getInt("OrderID"));
                order.setShopID(rs.getInt("ShopID"));
                order.setCreatedBy(rs.getInt("CreatedBy"));
                order.setStatusID(rs.getInt("StatusID"));
                order.setCreatedAt(rs.getTimestamp("CreatedAt"));
                list.add(order);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    /**
     * Get all orders without pagination
     * @return List of all orders
     */
    public List<Order> getAllOrders() {
        List<Order> list = new ArrayList<>();
        String sql = "SELECT * FROM Orders ORDER BY CreatedAt DESC";
        
        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ResultSet rs = ps.executeQuery();
            
            while (rs.next()) {
                Order order = new Order();
                order.setOrderID(rs.getInt("OrderID"));
                order.setShopID(rs.getInt("ShopID"));
                order.setCreatedBy(rs.getInt("CreatedBy"));
                order.setStatusID(rs.getInt("StatusID"));
                order.setCreatedAt(rs.getTimestamp("CreatedAt"));
                list.add(order);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }
    
    /**
     * Get orders with detailed information (joined with Setting, Shop, User)
     * @param page Page number
     * @param pageSize Page size
     * @param statusFilter Status filter (null for all)
     * @param shopFilter Shop filter (null for all)
     * @return List of orders with detailed info
     */
    public List<Map<String, Object>> getOrdersWithDetails(int page, int pageSize, 
                                                           Integer statusFilter, Integer shopFilter) {
        List<Map<String, Object>> orders = new ArrayList<>();
        StringBuilder sql = new StringBuilder();
        sql.append("SELECT o.OrderID, o.ShopID, o.CreatedBy, o.StatusID, o.CreatedAt, ");
        sql.append("sh.ShopName, u.FullName as CreatedByName, st.Value as StatusName ");
        sql.append("FROM Orders o ");
        sql.append("LEFT JOIN Shops sh ON o.ShopID = sh.ShopID ");
        sql.append("LEFT JOIN Users u ON o.CreatedBy = u.UserID ");
        sql.append("LEFT JOIN Setting st ON o.StatusID = st.SettingID ");
        sql.append("WHERE 1=1 ");
        
        List<Object> params = new ArrayList<>();
        if (statusFilter != null) {
            sql.append("AND o.StatusID = ? ");
            params.add(statusFilter);
        }
        if (shopFilter != null) {
            sql.append("AND o.ShopID = ? ");
            params.add(shopFilter);
        }
        
        sql.append("ORDER BY o.CreatedAt DESC LIMIT ? OFFSET ?");
        params.add(pageSize);
        params.add((page - 1) * pageSize);
        
        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql.toString())) {
            
            for (int i = 0; i < params.size(); i++) {
                ps.setObject(i + 1, params.get(i));
            }
            
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                Map<String, Object> order = new HashMap<>();
                order.put("orderID", rs.getInt("OrderID"));
                order.put("shopID", rs.getInt("ShopID"));
                order.put("createdBy", rs.getInt("CreatedBy"));
                order.put("statusID", rs.getInt("StatusID"));
                order.put("createdAt", rs.getTimestamp("CreatedAt"));
                order.put("shopName", rs.getString("ShopName"));
                order.put("createdByName", rs.getString("CreatedByName"));
                order.put("statusName", rs.getString("StatusName"));
                orders.add(order);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return orders;
    }

    /**
     * Get total count of orders
     * @param statusFilter Status filter
     * @param shopFilter Shop filter
     * @return Total count
     */
    public int getTotalOrderCount(Integer statusFilter, Integer shopFilter) {
        StringBuilder sql = new StringBuilder("SELECT COUNT(*) FROM Orders WHERE 1=1 ");
        
        List<Object> params = new ArrayList<>();
        if (statusFilter != null) {
            sql.append("AND StatusID = ? ");
            params.add(statusFilter);
        }
        if (shopFilter != null) {
            sql.append("AND ShopID = ? ");
            params.add(shopFilter);
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
     * Get order by ID
     * @param orderID Order ID
     * @return Order object or null
     */
    public Order getOrderById(int orderID) {
        String sql = "SELECT * FROM Orders WHERE OrderID = ?";
        
        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setInt(1, orderID);
            ResultSet rs = ps.executeQuery();
            
            if (rs.next()) {
                Order order = new Order();
                order.setOrderID(rs.getInt("OrderID"));
                order.setShopID(rs.getInt("ShopID"));
                order.setCreatedBy(rs.getInt("CreatedBy"));
                order.setStatusID(rs.getInt("StatusID"));
                order.setCreatedAt(rs.getTimestamp("CreatedAt"));
                return order;
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }
    
    /**
     * Get order with detailed information by ID
     * @param orderID Order ID
     * @return Map with order details
     */
    public Map<String, Object> getOrderWithDetailsById(int orderID) {
        String sql = "SELECT o.OrderID, o.ShopID, o.CreatedBy, o.StatusID, o.CreatedAt, " +
                    "sh.ShopName, u.FullName as CreatedByName, st.Value as StatusName " +
                    "FROM Orders o " +
                    "LEFT JOIN Shops sh ON o.ShopID = sh.ShopID " +
                    "LEFT JOIN Users u ON o.CreatedBy = u.UserID " +
                    "LEFT JOIN Setting st ON o.StatusID = st.SettingID " +
                    "WHERE o.OrderID = ?";
        
        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setInt(1, orderID);
            ResultSet rs = ps.executeQuery();
            
            if (rs.next()) {
                Map<String, Object> order = new HashMap<>();
                order.put("orderID", rs.getInt("OrderID"));
                order.put("shopID", rs.getInt("ShopID"));
                order.put("createdBy", rs.getInt("CreatedBy"));
                order.put("statusID", rs.getInt("StatusID"));
                order.put("createdAt", rs.getTimestamp("CreatedAt"));
                order.put("shopName", rs.getString("ShopName"));
                order.put("createdByName", rs.getString("CreatedByName"));
                order.put("statusName", rs.getString("StatusName"));
                return order;
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    /**
     * Insert new order
     * @param order Order object
     * @return Generated order ID or -1 if failed
     */
    public int insertOrder(Order order) {
        String sql = "INSERT INTO Orders (ShopID, CreatedBy, StatusID) VALUES (?, ?, ?) RETURNING OrderID";
        
        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setInt(1, order.getShopID());
            ps.setInt(2, order.getCreatedBy());
            ps.setInt(3, order.getStatusID());
            
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
     * Update order
     * @param order Order object
     * @return true if successful
     */
    public boolean updateOrder(Order order) {
        String sql = "UPDATE Orders SET ShopID = ?, StatusID = ? WHERE OrderID = ?";
        
        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setInt(1, order.getShopID());
            ps.setInt(2, order.getStatusID());
            ps.setInt(3, order.getOrderID());
            
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    /**
     * Update order status only
     * @param orderID Order ID
     * @param statusID Status ID
     * @return true if successful
     */
    public boolean updateOrderStatus(int orderID, int statusID) {
        String sql = "UPDATE Orders SET StatusID = ? WHERE OrderID = ?";
        
        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setInt(1, statusID);
            ps.setInt(2, orderID);
            
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    /**
     * Cancel order with reason
     * @param orderID Order ID
     * @param statusID Cancelled status ID
     * @param cancellationReason Reason for cancellation
     * @return true if successful
     */
    public boolean cancelOrder(int orderID, int statusID, String cancellationReason) {
        String sql = "UPDATE Orders SET StatusID = ?, CancellationReason = ? WHERE OrderID = ?";
        
        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setInt(1, statusID);
            ps.setString(2, cancellationReason);
            ps.setInt(3, orderID);
            
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    /**
     * Delete order (and its details via cascade)
     * @param orderID Order ID
     * @return true if successful
     */
    public boolean deleteOrder(int orderID) {
        String sql = "DELETE FROM Orders WHERE OrderID = ?";
        
        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setInt(1, orderID);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    // ============== Order Details Methods ==============

    /**
     * Get all details of an order
     * @param orderID Order ID
     * @return List of order details
     */
    public List<OrderDetail> getOrderDetails(int orderID) {
        List<OrderDetail> list = new ArrayList<>();
        String sql = "SELECT * FROM OrderDetails WHERE OrderID = ?";
        
        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setInt(1, orderID);
            ResultSet rs = ps.executeQuery();
            
            while (rs.next()) {
                OrderDetail detail = new OrderDetail();
                detail.setOrderDetailID(rs.getInt("OrderDetailID"));
                detail.setOrderID(rs.getInt("OrderID"));
                detail.setProductID(rs.getInt("ProductID"));
                detail.setQuantity(rs.getInt("Quantity"));
                detail.setPrice(rs.getBigDecimal("Price"));
                list.add(detail);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }
    
    /**
     * Get order details with product information
     * @param orderID Order ID
     * @return List of maps with order detail and product info
     */
    public List<Map<String, Object>> getOrderDetailsWithProduct(int orderID) {
        List<Map<String, Object>> details = new ArrayList<>();
        String sql = "SELECT od.OrderDetailID, od.OrderID, od.ProductID, od.Quantity, od.Price, " +
                    "p.ProductName, p.Description, c.Value as CategoryName " +
                    "FROM OrderDetails od " +
                    "LEFT JOIN Products p ON od.ProductID = p.ProductID " +
                    "LEFT JOIN Setting c ON p.CategoryID = c.SettingID " +
                    "WHERE od.OrderID = ?";
        
        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setInt(1, orderID);
            ResultSet rs = ps.executeQuery();
            
            while (rs.next()) {
                Map<String, Object> detail = new HashMap<>();
                detail.put("orderDetailID", rs.getInt("OrderDetailID"));
                detail.put("orderID", rs.getInt("OrderID"));
                detail.put("productID", rs.getInt("ProductID"));
                detail.put("quantity", rs.getInt("Quantity"));
                detail.put("price", rs.getBigDecimal("Price"));
                detail.put("productName", rs.getString("ProductName"));
                detail.put("description", rs.getString("Description"));
                detail.put("categoryName", rs.getString("CategoryName"));
                
                // Calculate subtotal
                BigDecimal subtotal = rs.getBigDecimal("Price")
                                       .multiply(BigDecimal.valueOf(rs.getInt("Quantity")));
                detail.put("subtotal", subtotal);
                
                details.add(detail);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return details;
    }

    /**
     * Insert order detail
     * @param detail OrderDetail object
     * @return true if successful
     */
    public boolean insertOrderDetail(OrderDetail detail) {
        String sql = "INSERT INTO OrderDetails (OrderID, ProductID, Quantity, Price) VALUES (?, ?, ?, ?)";
        
        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setInt(1, detail.getOrderID());
            ps.setInt(2, detail.getProductID());
            ps.setInt(3, detail.getQuantity());
            ps.setBigDecimal(4, detail.getPrice());
            
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    /**
     * Update order detail
     * @param detail OrderDetail object
     * @return true if successful
     */
    public boolean updateOrderDetail(OrderDetail detail) {
        String sql = "UPDATE OrderDetails SET ProductID = ?, Quantity = ?, Price = ? WHERE OrderDetailID = ?";
        
        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setInt(1, detail.getProductID());
            ps.setInt(2, detail.getQuantity());
            ps.setBigDecimal(3, detail.getPrice());
            ps.setInt(4, detail.getOrderDetailID());
            
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    /**
     * Delete order detail
     * @param orderDetailID Order Detail ID
     * @return true if successful
     */
    public boolean deleteOrderDetail(int orderDetailID) {
        String sql = "DELETE FROM OrderDetails WHERE OrderDetailID = ?";
        
        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setInt(1, orderDetailID);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }
    
    /**
     * Calculate total amount for an order
     * @param orderID Order ID
     * @return Total amount
     */
    public BigDecimal calculateOrderTotal(int orderID) {
        String sql = "SELECT SUM(Quantity * Price) as Total FROM OrderDetails WHERE OrderID = ?";
        
        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setInt(1, orderID);
            ResultSet rs = ps.executeQuery();
            
            if (rs.next()) {
                BigDecimal total = rs.getBigDecimal("Total");
                return total != null ? total : BigDecimal.ZERO;
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return BigDecimal.ZERO;
    }
}
