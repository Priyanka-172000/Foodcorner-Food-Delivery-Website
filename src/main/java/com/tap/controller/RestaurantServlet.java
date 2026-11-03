
package com.tap.controller;

import java.io.IOException;
import java.util.Collections;
import java.util.List;

import com.tap.DaoImpl.RestaurantDaoImpl;
import com.tap.model.FoodCategory;
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
        String categoryIdParam = req.getParameter("categoryId");

        searchQuery = searchQuery == null ? "" : searchQuery.trim();

        int categoryId = 0;

        if (categoryIdParam != null && !categoryIdParam.trim().isEmpty()) {
            try {
                categoryId = Integer.parseInt(categoryIdParam.trim());

                if (categoryId < 0) {
                    categoryId = 0;
                }

            } catch (NumberFormatException e) {
                categoryId = 0;
            }
        }

        RestaurantDaoImpl restaurantDao = new RestaurantDaoImpl();

        if ("categories".equalsIgnoreCase(req.getParameter("ajax"))) {

            List<FoodCategory> categories =
                    restaurantDao.getAvailableCategories();

            if (categories == null) {
                categories = Collections.emptyList();
            }

            resp.setCharacterEncoding("UTF-8");
            resp.setContentType("application/json;charset=UTF-8");
            resp.setHeader("Cache-Control", "no-store");

            resp.getWriter().write(categoriesToJson(categories));
            return;
        }

        List<Restaurant> restaurants =
                restaurantDao.getAvailableRestaurants(searchQuery, categoryId);

        if (restaurants == null) {
            restaurants = Collections.emptyList();
        }

        if ("true".equalsIgnoreCase(req.getParameter("ajax"))) {

            resp.setCharacterEncoding("UTF-8");
            resp.setContentType("application/json;charset=UTF-8");
            resp.setHeader("Cache-Control", "no-store");

            resp.getWriter().write(restaurantsToJson(restaurants));
            return;
        }

        req.setAttribute("restaurants", restaurants);
        req.setAttribute("searchQuery", searchQuery);
        req.setAttribute("selectedCategory", categoryId);

        req.getRequestDispatcher("/restaurant.jsp").forward(req, resp);
    }

    private String restaurantsToJson(List<Restaurant> restaurants) {

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
                .append("\"}");
        }

        return json.append(']').toString();
    }

    private String categoriesToJson(List<FoodCategory> categories) {

        StringBuilder json = new StringBuilder("[");

        for (int i = 0; i < categories.size(); i++) {

            FoodCategory category = categories.get(i);

            if (i > 0) {
                json.append(',');
            }

            json.append('{')
                .append("\"categoryId\":")
                .append(category.getCategoryId())
                .append(',')
                .append("\"categoryName\":\"")
                .append(jsonEscape(category.getCategoryName()))
                .append("\",")
                .append("\"imagePath\":\"")
                .append(jsonEscape(category.getImagePath()))
                .append("\"}");
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
