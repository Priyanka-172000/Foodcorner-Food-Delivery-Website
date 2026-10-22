package com.tap.DaoImpl;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

import com.tap.Dao.RestaurantDao;
import com.tap.model.Restaurant;
import com.tap.util.DBConnection;

public class RestaurantDaoImpl implements RestaurantDao {

    private static final String INSERT_RESTAURANT =
            "INSERT INTO restaurant(name, cuisineType, deliveryTime, address, adminUserId, rating, isActive, imagePath) "
          + "VALUES (?, ?, ?, ?, ?, ?, ?, ?)";

    private static final String GET_RESTAURANT_BY_ID =
            "SELECT * FROM restaurant WHERE restaurantId = ?";

    private static final String GET_ALL_RESTAURANTS =
            "SELECT * FROM restaurant";

    private static final String GET_ACTIVE_RESTAURANTS =
            "SELECT * FROM restaurant WHERE isActive = true";

    private static final String UPDATE_RESTAURANT =
            "UPDATE restaurant SET name = ?, cuisineType = ?, deliveryTime = ?, "
          + "address = ?, adminUserId = ?, rating = ?, isActive = ?, imagePath = ? "
          + "WHERE restaurantId = ?";

    private static final String DELETE_RESTAURANT =
            "DELETE FROM restaurant WHERE restaurantId = ?";


    @Override
    public void addRestaurant(Restaurant restaurant) {

        try (
            Connection con = DBConnection.getConnection();
            PreparedStatement pstmt = con.prepareStatement(INSERT_RESTAURANT);
        ) {

            pstmt.setString(1, restaurant.getName());
            pstmt.setString(2, restaurant.getCuisineType());
            pstmt.setString(3, restaurant.getDeliveryTime());
            pstmt.setString(4, restaurant.getAddress());
            pstmt.setInt(5, restaurant.getAdminUserId());
            pstmt.setDouble(6, restaurant.getRating());
            pstmt.setBoolean(7, restaurant.isActive());
            pstmt.setString(8, restaurant.getImagePath());

            int rows = pstmt.executeUpdate();

            System.out.println(rows + " restaurant added successfully");

        } catch (SQLException e) {
            e.printStackTrace();
        }
    }


    @Override
    public Restaurant getRestaurant(int restaurantId) {

        Restaurant restaurant = null;

        try (
            Connection con = DBConnection.getConnection();
            PreparedStatement pstmt = con.prepareStatement(GET_RESTAURANT_BY_ID);
        ) {

            pstmt.setInt(1, restaurantId);

            try (ResultSet res = pstmt.executeQuery()) {

                if (res.next()) {
                    restaurant = extractRestaurant(res);
                }
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }

        return restaurant;
    }


    @Override
    public List<Restaurant> getAllRestaurants() {

        List<Restaurant> restaurants = new ArrayList<>();

        try (
            Connection con = DBConnection.getConnection();
            PreparedStatement pstmt = con.prepareStatement(GET_ALL_RESTAURANTS);
            ResultSet res = pstmt.executeQuery();
        ) {

            while (res.next()) {
                restaurants.add(extractRestaurant(res));
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }

        return restaurants;
    }


    @Override
    public List<Restaurant> getActiveRestaurants() {

        List<Restaurant> restaurants = new ArrayList<>();

        try (
            Connection con = DBConnection.getConnection();
            PreparedStatement pstmt = con.prepareStatement(GET_ACTIVE_RESTAURANTS);
            ResultSet res = pstmt.executeQuery();
        ) {

            while (res.next()) {
                restaurants.add(extractRestaurant(res));
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }

        return restaurants;
    }


    @Override
    public void updateRestaurant(Restaurant restaurant) {

        try (
            Connection con = DBConnection.getConnection();
            PreparedStatement pstmt = con.prepareStatement(UPDATE_RESTAURANT);
        ) {

            pstmt.setString(1, restaurant.getName());
            pstmt.setString(2, restaurant.getCuisineType());
            pstmt.setString(3, restaurant.getDeliveryTime());
            pstmt.setString(4, restaurant.getAddress());
            pstmt.setInt(5, restaurant.getAdminUserId());
            pstmt.setDouble(6, restaurant.getRating());
            pstmt.setBoolean(7, restaurant.isActive());
            pstmt.setString(8, restaurant.getImagePath());

            pstmt.setInt(9, restaurant.getRestaurantId());

            int rows = pstmt.executeUpdate();

            System.out.println(rows + " restaurant updated successfully");

        } catch (SQLException e) {
            e.printStackTrace();
        }
    }


    @Override
    public void deleteRestaurant(int restaurantId) {

        try (
            Connection con = DBConnection.getConnection();
            PreparedStatement pstmt = con.prepareStatement(DELETE_RESTAURANT);
        ) {

            pstmt.setInt(1, restaurantId);

            int rows = pstmt.executeUpdate();

            System.out.println(rows + " restaurant deleted successfully");

        } catch (SQLException e) {
            e.printStackTrace();
        }
    }


    private Restaurant extractRestaurant(ResultSet res) throws SQLException {

        Restaurant restaurant = new Restaurant();

        restaurant.setRestaurantId(res.getInt("restaurantId"));
        restaurant.setName(res.getString("name"));
        restaurant.setCuisineType(res.getString("cuisineType"));
        restaurant.setDeliveryTime(res.getString("deliveryTime"));
        restaurant.setAddress(res.getString("address"));
        restaurant.setAdminUserId(res.getInt("adminUserId"));
        restaurant.setRating(res.getDouble("rating"));
        restaurant.setActive(res.getBoolean("isActive"));
        restaurant.setImagePath(res.getString("imagePath"));

        return restaurant;
    }
}