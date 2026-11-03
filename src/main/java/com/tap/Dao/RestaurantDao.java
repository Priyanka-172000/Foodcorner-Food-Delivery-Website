package com.tap.Dao;

import java.util.List;

import com.tap.model.FoodCategory;
import com.tap.model.PopularRestaurant;
import com.tap.model.Restaurant;

public interface RestaurantDao {

    void addRestaurant(Restaurant restaurant);

    Restaurant getRestaurant(int restaurantId);

    List<Restaurant> getAllRestaurants();

    List<Restaurant> getActiveRestaurants();

    List<Restaurant> getAvailableRestaurants(String searchQuery, int categoryId);

    List<FoodCategory> getAvailableCategories();

    List<PopularRestaurant> getPopularRestaurants();

    void updateRestaurant(Restaurant restaurant);

    void deleteRestaurant(int restaurantId);
}