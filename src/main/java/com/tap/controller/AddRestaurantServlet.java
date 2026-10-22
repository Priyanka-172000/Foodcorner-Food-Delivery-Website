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


@WebServlet("/addRestaurant")
public class AddRestaurantServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;

    private RestaurantDaoImpl restaurantDao;


    @Override
    public void init() throws ServletException {

        restaurantDao =
                new RestaurantDaoImpl();
    }


    /*
     * OPEN ADD RESTAURANT PAGE
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


        if (admin == null) {

            resp.sendRedirect(
                    req.getContextPath()
                    + "/login.jsp"
            );

            return;
        }


        if (admin.getRole() == null ||
            !"ADMIN".equalsIgnoreCase(
                    admin.getRole())) {

            resp.sendRedirect(
                    req.getContextPath()
                    + "/restaurant"
            );

            return;
        }


        req.setAttribute(
                "admin",
                admin
        );


        RequestDispatcher rd =
                req.getRequestDispatcher(
                        "/addRestaurant.jsp"
                );


        rd.forward(
                req,
                resp
        );
    }


    /*
     * SAVE NEW RESTAURANT
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


        if (admin == null) {

            resp.sendRedirect(
                    req.getContextPath()
                    + "/login.jsp"
            );

            return;
        }


        /*
         * ONLY ADMIN CAN ADD RESTAURANT
         */
        if (admin.getRole() == null ||
            !"ADMIN".equalsIgnoreCase(
                    admin.getRole())) {

            resp.sendRedirect(
                    req.getContextPath()
                    + "/restaurant"
            );

            return;
        }


        /*
         * GET FORM VALUES
         */
        String name =
                req.getParameter("name");

        String cuisineType =
                req.getParameter("cuisineType");

        String deliveryTime =
                req.getParameter("deliveryTime");

        String address =
                req.getParameter("address");

        String ratingValue =
                req.getParameter("rating");

        String activeValue =
                req.getParameter("isActive");

        String imagePath =
                req.getParameter("imagePath");


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
                    + "/addRestaurant?error=invalid"
            );

            return;
        }


        /*
         * RATING
         */
        double rating = 0.0;


        if (ratingValue != null &&
            !ratingValue.trim().isEmpty()) {

            try {

                rating =
                        Double.parseDouble(
                                ratingValue
                        );

            } catch (NumberFormatException e) {

                resp.sendRedirect(
                        req.getContextPath()
                        + "/addRestaurant?error=rating"
                );

                return;
            }
        }


        /*
         * RATING RANGE
         */
        if (rating < 0 ||
            rating > 5) {

            resp.sendRedirect(
                    req.getContextPath()
                    + "/addRestaurant?error=rating"
            );

            return;
        }


        /*
         * ACTIVE STATUS
         *
         * Default = true
         */
        boolean isActive = true;


        if (activeValue != null) {

            isActive =
                    Boolean.parseBoolean(
                            activeValue
                    );
        }


        /*
         * CREATE RESTAURANT OBJECT
         */
        Restaurant restaurant =
                new Restaurant();


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


        /*
         * IMPORTANT:
         * ADMIN ID COMES FROM SESSION.
         * WE DO NOT TAKE ADMIN ID
         * FROM THE FORM.
         */
        restaurant.setAdminUserId(
                admin.getUserId()
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
         * INSERT INTO DATABASE
         */
        restaurantDao.addRestaurant(
                restaurant
        );


        /*
         * RETURN TO ADMIN RESTAURANTS
         */
        resp.sendRedirect(
                req.getContextPath()
                + "/adminRestaurants?added=true"
        );
    }
}