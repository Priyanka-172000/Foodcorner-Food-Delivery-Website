
package com.tap.DaoImpl;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.List;

import com.tap.Dao.OrderDao;
import com.tap.model.Order;
import com.tap.util.DBConnection;

public class OrderDaoImpl implements OrderDao {

    private static final String INSERT_ORDER =
            "INSERT INTO orders(userId, restaurantId, orderDate, totalAmount, status, paymentMode, deliveryAddress, paymentStatus, payuTxnId) "
          + "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?)";

    private static final String GET_ORDER_BY_ID =
            "SELECT * FROM orders WHERE orderId = ?";

    private static final String GET_ALL_ORDERS =
            "SELECT * FROM orders";

    private static final String GET_ORDERS_BY_USER =
            "SELECT * FROM orders WHERE userId = ?";

    private static final String GET_ORDERS_BY_RESTAURANT =
            "SELECT * FROM orders WHERE restaurantId = ?";

    private static final String UPDATE_ORDER =
            "UPDATE orders SET userId = ?, restaurantId = ?, orderDate = ?, "
          + "totalAmount = ?, status = ?, paymentMode = ?, deliveryAddress = ?, "
          + "paymentStatus = ?, payuTxnId = ? WHERE orderId = ?";

    private static final String DELETE_ORDER =
            "DELETE FROM orders WHERE orderId = ?";

    @Override
    public int addOrder(Order order) {

        int orderId = 0;

        String paymentStatus = order.getPaymentStatus();

        if (paymentStatus == null || paymentStatus.trim().isEmpty()) {
            paymentStatus = "PAYU".equalsIgnoreCase(order.getPaymentMode())
                    ? "PENDING"
                    : "NOT_REQUIRED";
        }

        try (
            Connection con = DBConnection.getConnection();
            PreparedStatement pstmt = con.prepareStatement(
                    INSERT_ORDER, Statement.RETURN_GENERATED_KEYS)
        ) {
            pstmt.setInt(1, order.getUserId());
            pstmt.setInt(2, order.getRestaurantId());
            pstmt.setTimestamp(3, order.getOrderDate());
            pstmt.setDouble(4, order.getTotalAmount());
            pstmt.setString(5, order.getStatus());
            pstmt.setString(6, order.getPaymentMode());
            pstmt.setString(7, order.getDeliveryAddress());
            pstmt.setString(8, paymentStatus);
            pstmt.setString(9, order.getPayuTxnId());

            int rows = pstmt.executeUpdate();

            if (rows > 0) {
                try (ResultSet res = pstmt.getGeneratedKeys()) {
                    if (res.next()) {
                        orderId = res.getInt(1);
                    }
                }
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }

        return orderId;
    }

    @Override
    public Order getOrder(int orderId) {

        Order order = null;

        try (
            Connection con = DBConnection.getConnection();
            PreparedStatement pstmt = con.prepareStatement(GET_ORDER_BY_ID)
        ) {
            pstmt.setInt(1, orderId);

            try (ResultSet res = pstmt.executeQuery()) {
                if (res.next()) {
                    order = extractOrder(res);
                }
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }

        return order;
    }

    @Override
    public List<Order> getAllOrders() {

        List<Order> orders = new ArrayList<>();

        try (
            Connection con = DBConnection.getConnection();
            PreparedStatement pstmt = con.prepareStatement(GET_ALL_ORDERS);
            ResultSet res = pstmt.executeQuery()
        ) {
            while (res.next()) {
                orders.add(extractOrder(res));
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }

        return orders;
    }

    @Override
    public List<Order> getOrdersByUser(int userId) {

        List<Order> orders = new ArrayList<>();

        try (
            Connection con = DBConnection.getConnection();
            PreparedStatement pstmt = con.prepareStatement(GET_ORDERS_BY_USER)
        ) {
            pstmt.setInt(1, userId);

            try (ResultSet res = pstmt.executeQuery()) {
                while (res.next()) {
                    orders.add(extractOrder(res));
                }
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }

        return orders;
    }

    @Override
    public List<Order> getOrdersByRestaurant(int restaurantId) {

        List<Order> orders = new ArrayList<>();

        try (
            Connection con = DBConnection.getConnection();
            PreparedStatement pstmt =
                    con.prepareStatement(GET_ORDERS_BY_RESTAURANT)
        ) {
            pstmt.setInt(1, restaurantId);

            try (ResultSet res = pstmt.executeQuery()) {
                while (res.next()) {
                    orders.add(extractOrder(res));
                }
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }

        return orders;
    }

    @Override
    public void updateOrder(Order order) {

        String paymentStatus = order.getPaymentStatus();

        if (paymentStatus == null || paymentStatus.trim().isEmpty()) {
            paymentStatus = "NOT_REQUIRED";
        }

        try (
            Connection con = DBConnection.getConnection();
            PreparedStatement pstmt = con.prepareStatement(UPDATE_ORDER)
        ) {
            pstmt.setInt(1, order.getUserId());
            pstmt.setInt(2, order.getRestaurantId());
            pstmt.setTimestamp(3, order.getOrderDate());
            pstmt.setDouble(4, order.getTotalAmount());
            pstmt.setString(5, order.getStatus());
            pstmt.setString(6, order.getPaymentMode());
            pstmt.setString(7, order.getDeliveryAddress());
            pstmt.setString(8, paymentStatus);
            pstmt.setString(9, order.getPayuTxnId());
            pstmt.setInt(10, order.getOrderId());

            pstmt.executeUpdate();

        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    @Override
    public void deleteOrder(int orderId) {

        try (
            Connection con = DBConnection.getConnection();
            PreparedStatement pstmt = con.prepareStatement(DELETE_ORDER)
        ) {
            pstmt.setInt(1, orderId);
            pstmt.executeUpdate();

        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    private Order extractOrder(ResultSet res) throws SQLException {

        Order order = new Order();

        order.setOrderId(res.getInt("orderId"));
        order.setUserId(res.getInt("userId"));
        order.setRestaurantId(res.getInt("restaurantId"));
        order.setOrderDate(res.getTimestamp("orderDate"));
        order.setTotalAmount(res.getDouble("totalAmount"));
        order.setStatus(res.getString("status"));
        order.setPaymentMode(res.getString("paymentMode"));
        order.setDeliveryAddress(res.getString("deliveryAddress"));
        order.setPaymentStatus(res.getString("paymentStatus"));
        order.setPayuTxnId(res.getString("payuTxnId"));

        return order;
    }
}
