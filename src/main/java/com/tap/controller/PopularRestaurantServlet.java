package com.tap.controller;

import java.io.IOException;
import java.util.Collections;
import java.util.List;

import com.tap.DaoImpl.RestaurantDaoImpl;
import com.tap.model.PopularRestaurant;

import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet("/popular-restaurants")
public class PopularRestaurantServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws IOException {

        resp.setCharacterEncoding("UTF-8");
        resp.setContentType("application/json;charset=UTF-8");
        resp.setHeader("Cache-Control", "no-store");

        List<PopularRestaurant> restaurants =
                new RestaurantDaoImpl().getPopularRestaurants();

        if (restaurants == null) {
            restaurants = Collections.emptyList();
        }

        resp.getWriter().write(toJson(restaurants));
    }

    private String toJson(List<PopularRestaurant> restaurants) {

        StringBuilder json = new StringBuilder("[");

        for (int i = 0; i < restaurants.size(); i++) {

            PopularRestaurant restaurant = restaurants.get(i);

            if (i > 0) {
                json.append(',');
            }

            double rating = restaurant.getRating();

            if (!Double.isFinite(rating)) {
                rating = 0.0;
            }

            json.append('{')
                .append("\"restaurantId\":")
                .append(restaurant.getRestaurantId())
                .append(',')
                .append("\"restaurantName\":\"")
                .append(jsonEscape(restaurant.getRestaurantName()))
                .append("\",")
                .append("\"cuisine\":\"")
                .append(jsonEscape(restaurant.getCuisine()))
                .append("\",")
                .append("\"rating\":")
                .append(rating)
                .append(',')
                .append("\"imageUrl\":\"")
                .append(jsonEscape(restaurant.getImageUrl()))
                .append("\",")
                .append("\"totalItemsOrdered\":")
                .append(restaurant.getTotalItemsOrdered())
                .append('}');
        }

        return json.append(']').toString();
    }

    private String jsonEscape(String value) {

        if (value == null) {
            return "";
        }

        StringBuilder escaped = new StringBuilder(value.length() + 16);

        for (int i = 0; i < value.length(); i++) {

            char c = value.charAt(i);

            switch (c) {
                case '"':
                    escaped.append("\\\"");
                    break;
                case '\\':
                    escaped.append("\\\\");
                    break;
                case '\b':
                    escaped.append("\\b");
                    break;
                case '\f':
                    escaped.append("\\f");
                    break;
                case '\n':
                    escaped.append("\\n");
                    break;
                case '\r':
                    escaped.append("\\r");
                    break;
                case '\t':
                    escaped.append("\\t");
                    break;
                default:
                    if (c < 0x20) {
                        escaped.append(String.format("\\u%04x", (int) c));
                    } else {
                        escaped.append(c);
                    }
            }
        }

        return escaped.toString();
    }
}