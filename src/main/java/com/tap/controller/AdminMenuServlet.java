package com.tap.controller;

import java.io.IOException;
import java.util.List;

import com.tap.DaoImpl.MenuDaoImpl;
import com.tap.DaoImpl.RestaurantDaoImpl;
import com.tap.model.Menu;
import com.tap.model.Restaurant;
import com.tap.model.User;

import jakarta.servlet.RequestDispatcher;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;


@WebServlet("/adminMenus")
public class AdminMenuServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;

    private MenuDaoImpl menuDao;
    private RestaurantDaoImpl restaurantDao;


    @Override
    public void init() throws ServletException {

        menuDao =
                new MenuDaoImpl();

        restaurantDao =
                new RestaurantDaoImpl();
    }


    @Override
    protected void doGet(
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
         * CHECK ADMIN
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
         * GET ALL RESTAURANTS
         *
         * Used for restaurant filter
         * and Add Menu Item button.
         */
        List<Restaurant> restaurants =
                restaurantDao
                        .getAllRestaurants();


        req.setAttribute(
                "restaurants",
                restaurants
        );


        req.setAttribute(
                "admin",
                admin
        );


        /*
         * CHECK WHETHER A PARTICULAR
         * RESTAURANT WAS SELECTED
         */
        String restaurantIdValue =
                req.getParameter(
                        "restaurantId"
                );


        List<Menu> menus;


        if (restaurantIdValue != null &&
            !restaurantIdValue
                    .trim()
                    .isEmpty()) {


            int restaurantId;


            try {

                restaurantId =
                        Integer.parseInt(
                                restaurantIdValue
                        );

            } catch (NumberFormatException e) {

                resp.sendRedirect(
                        req.getContextPath()
                        + "/adminMenus"
                );

                return;
            }


            /*
             * GET SELECTED RESTAURANT
             */
            Restaurant selectedRestaurant =
                    restaurantDao.getRestaurant(
                            restaurantId
                    );


            if (selectedRestaurant == null) {

                resp.sendRedirect(
                        req.getContextPath()
                        + "/adminMenus"
                );

                return;
            }


            /*
             * GET ONLY THIS RESTAURANT'S MENU
             */
            menus =
                    menuDao
                        .getMenusByRestaurant(
                                restaurantId
                        );


            req.setAttribute(
                    "selectedRestaurant",
                    selectedRestaurant
            );


            req.setAttribute(
                    "selectedRestaurantId",
                    restaurantId
            );

        } else {


            /*
             * NO RESTAURANT SELECTED
             *
             * SHOW ALL MENU ITEMS
             */
            menus =
                    menuDao
                        .getAllMenus();
        }


        /*
         * SEND MENU LIST TO JSP
         */
        req.setAttribute(
                "menus",
                menus
        );


        /*
         * OPEN ADMIN MENU PAGE
         */
        RequestDispatcher rd =
                req.getRequestDispatcher(
                        "/adminMenus.jsp"
                );


        rd.forward(
                req,
                resp
        );
    }
}