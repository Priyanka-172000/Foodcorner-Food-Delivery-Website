
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
            "SELECT * FROM restaurant ORDER BY isActive DESC, rating DESC, name ASC";

    private static final String GET_ACTIVE_RESTAURANTS =
            "SELECT * FROM restaurant WHERE isActive = TRUE ORDER BY rating DESC, name ASC";

    private static final String SEARCH_RESTAURANTS =
            "SELECT r.* FROM restaurant r "
            + "WHERE LOWER(r.name) LIKE LOWER(?) "
            + "OR LOWER(r.cuisineType) LIKE LOWER(?) "
            + "OR LOWER(r.address) LIKE LOWER(?) "
            + "OR EXISTS ("
            + "SELECT 1 FROM menu m "
            + "WHERE m.restaurantId = r.restaurantId "
            + "AND LOWER(m.itemName) LIKE LOWER(?)"
            + ") "
            + "ORDER BY r.isActive DESC, r.rating DESC, r.name ASC";

    private static final String UPDATE_RESTAURANT =
            "UPDATE restaurant SET name = ?, cuisineType = ?, deliveryTime = ?, "
            + "address = ?, adminUserId = ?, rating = ?, isActive = ?, imagePath = ? "
            + "WHERE restaurantId = ?";

    private static final String DELETE_RESTAURANT =
            "DELETE FROM restaurant WHERE restaurantId = ?";

    @Override
    public void addRestaurant(Restaurant restaurant) {
        try (Connection con = DBConnection.getConnection();
             PreparedStatement pstmt = con.prepareStatement(INSERT_RESTAURANT)) {

            pstmt.setString(1, restaurant.getName());
            pstmt.setString(2, restaurant.getCuisineType());
            pstmt.setString(3, restaurant.getDeliveryTime());
            pstmt.setString(4, restaurant.getAddress());
            pstmt.setInt(5, restaurant.getAdminUserId());
            pstmt.setDouble(6, restaurant.getRating());
            pstmt.setBoolean(7, restaurant.isActive());
            pstmt.setString(8, restaurant.getImagePath());

            pstmt.executeUpdate();

        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    @Override
    public Restaurant getRestaurant(int restaurantId) {
        try (Connection con = DBConnection.getConnection();
             PreparedStatement pstmt = con.prepareStatement(GET_RESTAURANT_BY_ID)) {

            pstmt.setInt(1, restaurantId);

            try (ResultSet res = pstmt.executeQuery()) {
                if (res.next()) {
                    return extractRestaurant(res);
                }
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }

        return null;
    }

    @Override
    public List<Restaurant> getAllRestaurants() {
        return executeRestaurantQuery(GET_ALL_RESTAURANTS);
    }

    @Override
    public List<Restaurant> getActiveRestaurants() {
        return executeRestaurantQuery(GET_ACTIVE_RESTAURANTS);
    }

    public List<Restaurant> searchRestaurants(String searchQuery) {
        List<Restaurant> restaurants = new ArrayList<>();

        if (searchQuery == null || searchQuery.trim().isEmpty()) {
            return getAllRestaurants();
        }

        String pattern = "%" + searchQuery.trim() + "%";

        try (Connection con = DBConnection.getConnection();
             PreparedStatement pstmt = con.prepareStatement(SEARCH_RESTAURANTS)) {

            pstmt.setString(1, pattern);
            pstmt.setString(2, pattern);
            pstmt.setString(3, pattern);
            pstmt.setString(4, pattern);

            try (ResultSet res = pstmt.executeQuery()) {
                while (res.next()) {
                    restaurants.add(extractRestaurant(res));
                }
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }

        return restaurants;
    }

    @Override
    public void updateRestaurant(Restaurant restaurant) {
        try (Connection con = DBConnection.getConnection();
             PreparedStatement pstmt = con.prepareStatement(UPDATE_RESTAURANT)) {

            pstmt.setString(1, restaurant.getName());
            pstmt.setString(2, restaurant.getCuisineType());
            pstmt.setString(3, restaurant.getDeliveryTime());
            pstmt.setString(4, restaurant.getAddress());
            pstmt.setInt(5, restaurant.getAdminUserId());
            pstmt.setDouble(6, restaurant.getRating());
            pstmt.setBoolean(7, restaurant.isActive());
            pstmt.setString(8, restaurant.getImagePath());
            pstmt.setInt(9, restaurant.getRestaurantId());

            pstmt.executeUpdate();

        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    @Override
    public void deleteRestaurant(int restaurantId) {
        try (Connection con = DBConnection.getConnection();
             PreparedStatement pstmt = con.prepareStatement(DELETE_RESTAURANT)) {

            pstmt.setInt(1, restaurantId);
            pstmt.executeUpdate();

        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    private List<Restaurant> executeRestaurantQuery(String sql) {
        List<Restaurant> restaurants = new ArrayList<>();

        try (Connection con = DBConnection.getConnection();
             PreparedStatement pstmt = con.prepareStatement(sql);
             ResultSet res = pstmt.executeQuery()) {

            while (res.next()) {
                restaurants.add(extractRestaurant(res));
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }

        return restaurants;
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
