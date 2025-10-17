/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package dao;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;
/**
 *
 * @author DrDYNew
 */
    public class BaseDAO {

    private static final String URL = "jdbc:postgresql://localhost:5432/CoffeeDB_v2";
    private static final String USER = "postgres";
    private static final String PASSWORD = "123"; // thay bằng mật khẩu bạn đặt

    public static Connection getConnection() {
        try {
            Class.forName("org.postgresql.Driver"); // nạp driver
            return DriverManager.getConnection(URL, USER, PASSWORD);
        } catch (ClassNotFoundException e) {
            System.out.println("PostgreSQL JDBC Driver not found!");
            e.printStackTrace();
        } catch (SQLException e) {
            System.out.println("Connection Failed!");
            e.printStackTrace();
        }
        return null;
    }
     public static void main(String[] args) {
        Connection conn = BaseDAO.getConnection();
        if (conn != null) {
            System.out.println("✅ Kết nối PostgreSQL thành công!");
        } else {
            System.out.println("❌ Kết nối thất bại!");
        }
    }
}
