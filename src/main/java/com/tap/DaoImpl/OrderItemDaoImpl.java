package com.tap.DaoImpl;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

import com.tap.Dao.OrderItemDao;
import com.tap.model.OrderItem;
import com.tap.util.DBConnection;

public class OrderItemDaoImpl implements OrderItemDao {

    private static final String INSERT_ORDER_ITEM =
            "INSERT INTO order_item(orderId, menuId, quantity, totalAmount) "
          + "VALUES (?, ?, ?, ?)";

    private static final String GET_ORDER_ITEM =
            "SELECT * FROM order_item WHERE orderItemId = ?";

    private static final String GET_ALL_ORDER_ITEMS =
            "SELECT * FROM order_item";

    private static final String GET_ITEMS_BY_ORDER =
            "SELECT * FROM order_item WHERE orderId = ?";

    private static final String UPDATE_ORDER_ITEM =
            "UPDATE order_item SET orderId = ?, menuId = ?, quantity = ?, "
          + "totalAmount = ? WHERE orderItemId = ?";

    private static final String DELETE_ORDER_ITEM =
            "DELETE FROM order_item WHERE orderItemId = ?";


    @Override
    public void addOrderItem(OrderItem orderItem) {

        try (
            Connection con = DBConnection.getConnection();
            PreparedStatement pstmt =
                    con.prepareStatement(INSERT_ORDER_ITEM);
        ) {

            pstmt.setInt(1, orderItem.getOrderId());
            pstmt.setInt(2, orderItem.getMenuId());
            pstmt.setInt(3, orderItem.getQuantity());
            pstmt.setDouble(4, orderItem.getTotalAmount());

            int rows = pstmt.executeUpdate();

            System.out.println(rows + " order item added successfully");

        } catch (SQLException e) {
            e.printStackTrace();
        }
    }


    @Override
    public OrderItem getOrderItem(int orderItemId) {

        OrderItem orderItem = null;

        try (
            Connection con = DBConnection.getConnection();
            PreparedStatement pstmt =
                    con.prepareStatement(GET_ORDER_ITEM);
        ) {

            pstmt.setInt(1, orderItemId);

            try (ResultSet res = pstmt.executeQuery()) {

                if (res.next()) {
                    orderItem = extractOrderItem(res);
                }
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }

        return orderItem;
    }


    @Override
    public List<OrderItem> getAllOrderItems() {

        List<OrderItem> orderItems = new ArrayList<>();

        try (
            Connection con = DBConnection.getConnection();
            PreparedStatement pstmt =
                    con.prepareStatement(GET_ALL_ORDER_ITEMS);

            ResultSet res = pstmt.executeQuery();
        ) {

            while (res.next()) {
                orderItems.add(extractOrderItem(res));
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }

        return orderItems;
    }


    @Override
    public List<OrderItem> getOrderItemsByOrder(int orderId) {

        List<OrderItem> orderItems = new ArrayList<>();

        try (
            Connection con = DBConnection.getConnection();
            PreparedStatement pstmt =
                    con.prepareStatement(GET_ITEMS_BY_ORDER);
        ) {

            pstmt.setInt(1, orderId);

            try (ResultSet res = pstmt.executeQuery()) {

                while (res.next()) {
                    orderItems.add(extractOrderItem(res));
                }
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }

        return orderItems;
    }


    @Override
    public void updateOrderItem(OrderItem orderItem) {

        try (
            Connection con = DBConnection.getConnection();
            PreparedStatement pstmt =
                    con.prepareStatement(UPDATE_ORDER_ITEM);
        ) {

            pstmt.setInt(1, orderItem.getOrderId());
            pstmt.setInt(2, orderItem.getMenuId());
            pstmt.setInt(3, orderItem.getQuantity());
            pstmt.setDouble(4, orderItem.getTotalAmount());
            pstmt.setInt(5, orderItem.getOrderItemId());

            int rows = pstmt.executeUpdate();

            System.out.println(
                rows + " order item updated successfully"
            );

        } catch (SQLException e) {
            e.printStackTrace();
        }
    }


    @Override
    public void deleteOrderItem(int orderItemId) {

        try (
            Connection con = DBConnection.getConnection();
            PreparedStatement pstmt =
                    con.prepareStatement(DELETE_ORDER_ITEM);
        ) {

            pstmt.setInt(1, orderItemId);

            int rows = pstmt.executeUpdate();

            System.out.println(
                rows + " order item deleted successfully"
            );

        } catch (SQLException e) {
            e.printStackTrace();
        }
    }


    private OrderItem extractOrderItem(ResultSet res)
            throws SQLException {

        OrderItem orderItem = new OrderItem();

        orderItem.setOrderItemId(
            res.getInt("orderItemId")
        );

        orderItem.setOrderId(
            res.getInt("orderId")
        );

        orderItem.setMenuId(
            res.getInt("menuId")
        );

        orderItem.setQuantity(
            res.getInt("quantity")
        );

        orderItem.setTotalAmount(
            res.getDouble("totalAmount")
        );

        return orderItem;
    }
}