
package com.tap.DaoImpl;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

import com.tap.Dao.RestaurantDao;
import com.tap.model.FoodCategory;
import com.tap.model.PopularRestaurant;
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
        "SELECT DISTINCT r.* FROM restaurant r "
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

    private static final String GET_AVAILABLE_RESTAURANTS =
        "SELECT DISTINCT r.* FROM restaurant r "
        + "WHERE r.isActive = TRUE "
        + "AND EXISTS ("
        + "SELECT 1 FROM menu am "
        + "WHERE am.restaurantId = r.restaurantId "
        + "AND am.isAvailable = TRUE) "
        + "AND (? = '' "
        + "OR LOWER(r.name) LIKE LOWER(?) "
        + "OR LOWER(COALESCE(r.cuisineType, '')) LIKE LOWER(?) "
        + "OR LOWER(COALESCE(r.address, '')) LIKE LOWER(?) "
        + "OR EXISTS ("
        + "SELECT 1 FROM menu sm "
        + "WHERE sm.restaurantId = r.restaurantId "
        + "AND sm.isAvailable = TRUE "
        + "AND LOWER(sm.itemName) LIKE LOWER(?))) "
        + "AND (? = 0 OR EXISTS ("
        + "SELECT 1 FROM menu cm "
        + "WHERE cm.restaurantId = r.restaurantId "
        + "AND cm.isAvailable = TRUE "
        + "AND cm.categoryId = ?)) "
        + "ORDER BY r.rating DESC, r.name ASC";

    private static final String GET_AVAILABLE_CATEGORIES =
        "SELECT fc.categoryId, fc.categoryName, "
        + "MIN(NULLIF(TRIM(m.imagePath), '')) AS imagePath "
        + "FROM food_category fc "
        + "INNER JOIN menu m ON m.categoryId = fc.categoryId "
        + "INNER JOIN restaurant r ON r.restaurantId = m.restaurantId "
        + "WHERE fc.isActive = TRUE "
        + "AND m.isAvailable = TRUE "
        + "AND r.isActive = TRUE "
        + "GROUP BY fc.categoryId, fc.categoryName "
        + "ORDER BY fc.categoryName ASC";

    private static final String GET_POPULAR_RESTAURANTS =
        "SELECT r.restaurantId, r.name, r.cuisineType, r.rating, r.imagePath, "
        + "COALESCE(p.totalCustomersOrdered, 0) AS totalCustomersOrdered "
        + "FROM restaurant r "
        + "LEFT JOIN ( "
        + "    SELECT m.restaurantId, COUNT(DISTINCT o.userId) AS totalCustomersOrdered "
        + "    FROM menu m "
        + "    INNER JOIN order_item oi ON m.menuId = oi.menuId "
        + "    INNER JOIN orders o ON oi.orderId = o.orderId "
        + "    WHERE UPPER(COALESCE(o.status, '')) <> 'CANCELLED' "
        + "    GROUP BY m.restaurantId "
        + ") p ON r.restaurantId = p.restaurantId "
        + "WHERE r.isActive = TRUE "
        + "ORDER BY COALESCE(p.totalCustomersOrdered, 0) DESC, r.name ASC "
        + "LIMIT 6";

    @Override
    public void addRestaurant(Restaurant restaurant) {

        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(INSERT_RESTAURANT)) {

            ps.setString(1, restaurant.getName());
            ps.setString(2, restaurant.getCuisineType());
            ps.setString(3, restaurant.getDeliveryTime());
            ps.setString(4, restaurant.getAddress());
            ps.setInt(5, restaurant.getAdminUserId());
            ps.setDouble(6, restaurant.getRating());
            ps.setBoolean(7, restaurant.isActive());
            ps.setString(8, restaurant.getImagePath());

            ps.executeUpdate();

        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    @Override
    public Restaurant getRestaurant(int restaurantId) {

        Restaurant restaurant = null;

        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(GET_RESTAURANT_BY_ID)) {

            ps.setInt(1, restaurantId);

            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    restaurant = extractRestaurant(rs);
                }
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }

        return restaurant;
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
             PreparedStatement ps = con.prepareStatement(SEARCH_RESTAURANTS)) {

            ps.setString(1, pattern);
            ps.setString(2, pattern);
            ps.setString(3, pattern);
            ps.setString(4, pattern);

            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    restaurants.add(extractRestaurant(rs));
                }
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }

        return restaurants;
    }

    @Override
    public List<Restaurant> getAvailableRestaurants(String searchQuery, int categoryId) {

        List<Restaurant> restaurants = new ArrayList<>();

        String search = searchQuery == null ? "" : searchQuery.trim();
        String pattern = "%" + search + "%";

        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(GET_AVAILABLE_RESTAURANTS)) {

            ps.setString(1, search);
            ps.setString(2, pattern);
            ps.setString(3, pattern);
            ps.setString(4, pattern);
            ps.setString(5, pattern);
            ps.setInt(6, categoryId);
            ps.setInt(7, categoryId);

            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    restaurants.add(extractRestaurant(rs));
                }
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }

        return restaurants;
    }

    @Override
    public List<FoodCategory> getAvailableCategories() {

        List<FoodCategory> categories = new ArrayList<>();

        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(GET_AVAILABLE_CATEGORIES);
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {

                FoodCategory category = new FoodCategory();

                category.setCategoryId(rs.getInt("categoryId"));
                category.setCategoryName(rs.getString("categoryName"));
                category.setImagePath(rs.getString("imagePath"));

                categories.add(category);
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }

        return categories;
    }

    @Override
    public List<PopularRestaurant> getPopularRestaurants() {

        List<PopularRestaurant> restaurants = new ArrayList<>();

        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(GET_POPULAR_RESTAURANTS);
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {

                PopularRestaurant restaurant = new PopularRestaurant(
                    rs.getInt("restaurantId"),
                    rs.getString("name"),
                    rs.getString("cuisineType"),
                    rs.getDouble("rating"),
                    rs.getString("imagePath"),
                    rs.getInt("totalCustomersOrdered")
                );

                restaurants.add(restaurant);
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }

        return restaurants;
    }

    @Override
    public void updateRestaurant(Restaurant restaurant) {

        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(UPDATE_RESTAURANT)) {

            ps.setString(1, restaurant.getName());
            ps.setString(2, restaurant.getCuisineType());
            ps.setString(3, restaurant.getDeliveryTime());
            ps.setString(4, restaurant.getAddress());
            ps.setInt(5, restaurant.getAdminUserId());
            ps.setDouble(6, restaurant.getRating());
            ps.setBoolean(7, restaurant.isActive());
            ps.setString(8, restaurant.getImagePath());
            ps.setInt(9, restaurant.getRestaurantId());

            ps.executeUpdate();

        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    @Override
    public void deleteRestaurant(int restaurantId) {

        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(DELETE_RESTAURANT)) {

            ps.setInt(1, restaurantId);
            ps.executeUpdate();

        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    private List<Restaurant> executeRestaurantQuery(String query) {

        List<Restaurant> restaurants = new ArrayList<>();

        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(query);
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                restaurants.add(extractRestaurant(rs));
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
