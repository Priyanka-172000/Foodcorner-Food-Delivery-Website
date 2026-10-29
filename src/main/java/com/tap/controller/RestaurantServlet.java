
package com.tap.controller;

import java.io.IOException;
import java.util.List;

import com.tap.DaoImpl.RestaurantDaoImpl;
import com.tap.model.Restaurant;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet("/restaurant")
public class RestaurantServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        req.setCharacterEncoding("UTF-8");

        String searchQuery = req.getParameter("search");

        if (searchQuery == null) {
            searchQuery = "";
        }

        searchQuery = searchQuery.trim();

        RestaurantDaoImpl restaurantDao = new RestaurantDaoImpl();

        List<Restaurant> restaurants;

        if (searchQuery.isEmpty()) {
            restaurants = restaurantDao.getAllRestaurants();
        } else {
            restaurants = restaurantDao.searchRestaurants(searchQuery);
        }

        if (restaurants == null) {
            restaurants = java.util.Collections.emptyList();
        }

        if ("true".equalsIgnoreCase(req.getParameter("ajax"))) {
            resp.setCharacterEncoding("UTF-8");
            resp.setContentType("application/json;charset=UTF-8");
            resp.setHeader("Cache-Control", "no-store");
            resp.getWriter().write(toJson(restaurants));
            return;
        }

        req.setAttribute("restaurants", restaurants);
        req.setAttribute("searchQuery", searchQuery);

        req.getRequestDispatcher("/restaurant.jsp").forward(req, resp);
    }

    private String toJson(List<Restaurant> restaurants) {
        StringBuilder json = new StringBuilder("[");

        for (int i = 0; i < restaurants.size(); i++) {
            Restaurant restaurant = restaurants.get(i);

            if (i > 0) {
                json.append(',');
            }

            json.append('{')
                .append("\"restaurantId\":")
                .append(restaurant.getRestaurantId())
                .append(',')
                .append("\"name\":\"")
                .append(jsonEscape(restaurant.getName()))
                .append("\",")
                .append("\"cuisineType\":\"")
                .append(jsonEscape(restaurant.getCuisineType()))
                .append("\",")
                .append("\"deliveryTime\":\"")
                .append(jsonEscape(restaurant.getDeliveryTime()))
                .append("\",")
                .append("\"address\":\"")
                .append(jsonEscape(restaurant.getAddress()))
                .append("\",")
                .append("\"rating\":")
                .append(Double.isFinite(restaurant.getRating())
                        ? restaurant.getRating() : 0.0)
                .append(',')
                .append("\"isActive\":")
                .append(restaurant.isActive())
                .append(',')
                .append("\"imagePath\":\"")
                .append(jsonEscape(restaurant.getImagePath()))
                .append("\"")
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
