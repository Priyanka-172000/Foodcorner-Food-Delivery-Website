
package com.tap.model;

public class PopularRestaurant {

    private int restaurantId;
    private String restaurantName;
    private String cuisine;
    private double rating;
    private String imageUrl;
    private int totalItemsOrdered;

    public PopularRestaurant() {
    }

    public PopularRestaurant(int restaurantId, String restaurantName,
            String cuisine, double rating, String imageUrl,
            int totalItemsOrdered) {

        this.restaurantId = restaurantId;
        this.restaurantName = restaurantName;
        this.cuisine = cuisine;
        this.rating = rating;
        this.imageUrl = imageUrl;
        this.totalItemsOrdered = totalItemsOrdered;
    }

    public int getRestaurantId() {
        return restaurantId;
    }

    public String getRestaurantName() {
        return restaurantName;
    }

    public String getCuisine() {
        return cuisine;
    }

    public double getRating() {
        return rating;
    }

    public String getImageUrl() {
        return imageUrl;
    }

    public int getTotalItemsOrdered() {
        return totalItemsOrdered;
    }

    @Override
    public String toString() {
        return "PopularRestaurant [restaurantId=" + restaurantId
                + ", restaurantName=" + restaurantName
                + ", cuisine=" + cuisine
                + ", rating=" + rating
                + ", imageUrl=" + imageUrl + "]";
    }
}
