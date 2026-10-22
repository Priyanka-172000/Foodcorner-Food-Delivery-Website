package com.tap.controller;

import java.io.IOException;

import com.tap.DaoImpl.RestaurantDaoImpl;
import com.tap.model.Restaurant;
import com.tap.model.User;

import jakarta.servlet.RequestDispatcher;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;


@WebServlet("/editRestaurant")
public class EditRestaurantServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;

    private RestaurantDaoImpl restaurantDao;


    @Override
    public void init() throws ServletException {

        restaurantDao =
                new RestaurantDaoImpl();
    }


    /*
     * OPEN EDIT RESTAURANT PAGE
     */
    @Override
    protected void doGet(
            HttpServletRequest req,
            HttpServletResponse resp)

            throws ServletException,
                   IOException {


        HttpSession session =
                req.getSession(false);


        if (session == null) {

            resp.sendRedirect(
                    req.getContextPath()
                    + "/login.jsp"
            );

            return;
        }


        User admin =
                (User) session.getAttribute("user");


        if (admin == null ||
            admin.getRole() == null ||
            !"ADMIN".equalsIgnoreCase(
                    admin.getRole())) {

            resp.sendRedirect(
                    req.getContextPath()
                    + "/restaurant"
            );

            return;
        }


        String restaurantIdValue =
                req.getParameter(
                        "restaurantId"
                );


        if (restaurantIdValue == null ||
            restaurantIdValue.trim().isEmpty()) {

            resp.sendRedirect(
                    req.getContextPath()
                    + "/adminRestaurants"
            );

            return;
        }


        int restaurantId;


        try {

            restaurantId =
                    Integer.parseInt(
                            restaurantIdValue
                    );

        } catch (NumberFormatException e) {

            resp.sendRedirect(
                    req.getContextPath()
                    + "/adminRestaurants"
            );

            return;
        }


        Restaurant restaurant =
                restaurantDao.getRestaurant(
                        restaurantId
                );


        if (restaurant == null) {

            resp.sendRedirect(
                    req.getContextPath()
                    + "/adminRestaurants"
            );

            return;
        }


        req.setAttribute(
                "restaurant",
                restaurant
        );


        req.setAttribute(
                "admin",
                admin
        );


        RequestDispatcher rd =
                req.getRequestDispatcher(
                        "/editRestaurant.jsp"
                );


        rd.forward(
                req,
                resp
        );
    }


    /*
     * UPDATE RESTAURANT
     */
    @Override
    protected void doPost(
            HttpServletRequest req,
            HttpServletResponse resp)

            throws ServletException,
                   IOException {


        HttpSession session =
                req.getSession(false);


        if (session == null) {

            resp.sendRedirect(
                    req.getContextPath()
                    + "/login.jsp"
            );

            return;
        }


        User admin =
                (User) session.getAttribute("user");


        if (admin == null ||
            admin.getRole() == null ||
            !"ADMIN".equalsIgnoreCase(
                    admin.getRole())) {

            resp.sendRedirect(
                    req.getContextPath()
                    + "/restaurant"
            );

            return;
        }


        /*
         * GET RESTAURANT ID
         */
        String restaurantIdValue =
                req.getParameter(
                        "restaurantId"
                );


        int restaurantId;


        try {

            restaurantId =
                    Integer.parseInt(
                            restaurantIdValue
                    );

        } catch (Exception e) {

            resp.sendRedirect(
                    req.getContextPath()
                    + "/adminRestaurants?error=true"
            );

            return;
        }


        /*
         * GET EXISTING RESTAURANT
         */
        Restaurant restaurant =
                restaurantDao.getRestaurant(
                        restaurantId
                );


        if (restaurant == null) {

            resp.sendRedirect(
                    req.getContextPath()
                    + "/adminRestaurants?error=true"
            );

            return;
        }


        /*
         * GET UPDATED FORM VALUES
         */
        String name =
                req.getParameter("name");

        String cuisineType =
                req.getParameter(
                        "cuisineType"
                );

        String deliveryTime =
                req.getParameter(
                        "deliveryTime"
                );

        String address =
                req.getParameter("address");

        String ratingValue =
                req.getParameter("rating");

        String activeValue =
                req.getParameter("isActive");

        String imagePath =
                req.getParameter(
                        "imagePath"
                );


        /*
         * VALIDATION
         */
        if (name == null ||
            name.trim().isEmpty() ||

            cuisineType == null ||
            cuisineType.trim().isEmpty() ||

            deliveryTime == null ||
            deliveryTime.trim().isEmpty() ||

            address == null ||
            address.trim().isEmpty()) {


            resp.sendRedirect(
                    req.getContextPath()
                    + "/editRestaurant"
                    + "?restaurantId="
                    + restaurantId
                    + "&error=invalid"
            );

            return;
        }


        /*
         * RATING
         */
        double rating = 0.0;


        try {

            if (ratingValue != null &&
                !ratingValue.trim().isEmpty()) {

                rating =
                        Double.parseDouble(
                                ratingValue
                        );
            }

        } catch (NumberFormatException e) {

            resp.sendRedirect(
                    req.getContextPath()
                    + "/editRestaurant"
                    + "?restaurantId="
                    + restaurantId
                    + "&error=rating"
            );

            return;
        }


        if (rating < 0 ||
            rating > 5) {

            resp.sendRedirect(
                    req.getContextPath()
                    + "/editRestaurant"
                    + "?restaurantId="
                    + restaurantId
                    + "&error=rating"
            );

            return;
        }


        boolean isActive =
                Boolean.parseBoolean(
                        activeValue
                );


        /*
         * UPDATE RESTAURANT OBJECT
         */
        restaurant.setName(
                name.trim()
        );


        restaurant.setCuisineType(
                cuisineType.trim()
        );


        restaurant.setDeliveryTime(
                deliveryTime.trim()
        );


        restaurant.setAddress(
                address.trim()
        );


        restaurant.setRating(
                rating
        );


        restaurant.setActive(
                isActive
        );


        if (imagePath != null) {

            restaurant.setImagePath(
                    imagePath.trim()
            );

        } else {

            restaurant.setImagePath("");
        }


        /*
         * restaurantId and adminUserId
         * remain unchanged.
         */


        /*
         * UPDATE DATABASE
         */
        restaurantDao.updateRestaurant(
                restaurant
        );


        /*
         * RETURN TO RESTAURANT MANAGEMENT
         */
        resp.sendRedirect(
                req.getContextPath()
                + "/adminRestaurants"
                + "?updated=true"
        );
    }
}