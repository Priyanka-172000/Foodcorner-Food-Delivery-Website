package com.tap.controller;

import java.io.IOException;

import com.tap.DaoImpl.RestaurantDaoImpl;
import com.tap.model.Restaurant;
import com.tap.model.User;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;


@WebServlet("/deleteRestaurant")
public class DeleteRestaurantServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;

    private RestaurantDaoImpl restaurantDao;


    @Override
    public void init() throws ServletException {

        restaurantDao =
                new RestaurantDaoImpl();
    }


    @Override
    protected void doPost(
            HttpServletRequest req,
            HttpServletResponse resp)

            throws ServletException,
                   IOException {


        HttpSession session =
                req.getSession(false);


        /*
         * CHECK SESSION
         */
        if (session == null) {

            resp.sendRedirect(
                    req.getContextPath()
                    + "/login.jsp"
            );

            return;
        }


        User admin =
                (User) session.getAttribute("user");


        /*
         * CHECK ADMIN ROLE
         */
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


        if (restaurantIdValue == null ||
            restaurantIdValue.trim().isEmpty()) {

            resp.sendRedirect(
                    req.getContextPath()
                    + "/adminRestaurants"
                    + "?error=true"
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
                    + "?error=true"
            );

            return;
        }


        /*
         * CHECK RESTAURANT EXISTS
         */
        Restaurant restaurant =
                restaurantDao.getRestaurant(
                        restaurantId
                );


        if (restaurant == null) {

            resp.sendRedirect(
                    req.getContextPath()
                    + "/adminRestaurants"
                    + "?error=true"
            );

            return;
        }


        /*
         * TRY TO DELETE RESTAURANT
         */
        restaurantDao.deleteRestaurant(
                restaurantId
        );


        /*
         * CHECK WHETHER DELETE
         * ACTUALLY SUCCEEDED
         */
        Restaurant deletedRestaurant =
                restaurantDao.getRestaurant(
                        restaurantId
                );


        if (deletedRestaurant == null) {


            /*
             * SUCCESS
             */
            resp.sendRedirect(
                    req.getContextPath()
                    + "/adminRestaurants"
                    + "?deleted=true"
            );


        } else {


            /*
             * DELETE FAILED
             *
             * Usually because menu items
             * or orders are connected to
             * this restaurant.
             */
            resp.sendRedirect(
                    req.getContextPath()
                    + "/adminRestaurants"
                    + "?error=delete"
            );
        }
    }
}