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


@WebServlet("/addMenu")
public class AddMenuServlet extends HttpServlet {

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


    /*
     * OPEN ADD MENU PAGE
     */
    @Override
    protected void doGet(
            HttpServletRequest req,
            HttpServletResponse resp)

            throws ServletException,
                   IOException {


        HttpSession session =
                req.getSession(false);


        /*
         * CHECK LOGIN
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
         * GET ALL RESTAURANTS
         *
         * Used in restaurant dropdown.
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
         * IF RESTAURANT ID COMES FROM
         * ADMIN RESTAURANT / MENU PAGE,
         * PRESELECT IT.
         */
        String restaurantIdValue =
                req.getParameter(
                        "restaurantId"
                );


        if (restaurantIdValue != null &&
            !restaurantIdValue
                    .trim()
                    .isEmpty()) {

            try {

                int restaurantId =
                        Integer.parseInt(
                                restaurantIdValue
                        );


                Restaurant selectedRestaurant =
                        restaurantDao.getRestaurant(
                                restaurantId
                        );


                if (selectedRestaurant != null) {

                    req.setAttribute(
                            "selectedRestaurantId",
                            restaurantId
                    );
                }


            } catch (NumberFormatException e) {

                // Ignore invalid restaurant ID.
            }
        }


        RequestDispatcher rd =
                req.getRequestDispatcher(
                        "/addMenu.jsp"
                );


        rd.forward(
                req,
                resp
        );
    }


    /*
     * SAVE NEW MENU ITEM
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


        /*
         * ONLY ADMIN CAN ADD MENU ITEMS
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
         * GET FORM VALUES
         */
        String restaurantIdValue =
                req.getParameter(
                        "restaurantId"
                );

        String itemName =
                req.getParameter(
                        "itemName"
                );

        String description =
                req.getParameter(
                        "description"
                );

        String priceValue =
                req.getParameter(
                        "price"
                );

        String availableValue =
                req.getParameter(
                        "isAvailable"
                );

        String imagePath =
                req.getParameter(
                        "imagePath"
                );


        /*
         * REQUIRED FIELD VALIDATION
         */
        if (restaurantIdValue == null ||
            restaurantIdValue.trim().isEmpty() ||

            itemName == null ||
            itemName.trim().isEmpty() ||

            priceValue == null ||
            priceValue.trim().isEmpty()) {


            resp.sendRedirect(
                    req.getContextPath()
                    + "/addMenu?error=invalid"
            );

            return;
        }


        int restaurantId;


        /*
         * PARSE RESTAURANT ID
         */
        try {

            restaurantId =
                    Integer.parseInt(
                            restaurantIdValue
                    );

        } catch (NumberFormatException e) {

            resp.sendRedirect(
                    req.getContextPath()
                    + "/addMenu?error=restaurant"
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
                    + "/addMenu?error=restaurant"
            );

            return;
        }


        /*
         * PARSE PRICE
         */
        double price;


        try {

            price =
                    Double.parseDouble(
                            priceValue
                    );

        } catch (NumberFormatException e) {

            resp.sendRedirect(
                    req.getContextPath()
                    + "/addMenu"
                    + "?restaurantId="
                    + restaurantId
                    + "&error=price"
            );

            return;
        }


        /*
         * PRICE MUST BE POSITIVE
         */
        if (price <= 0) {

            resp.sendRedirect(
                    req.getContextPath()
                    + "/addMenu"
                    + "?restaurantId="
                    + restaurantId
                    + "&error=price"
            );

            return;
        }


        /*
         * AVAILABLE STATUS
         *
         * Default = true
         */
        boolean isAvailable = true;


        if (availableValue != null) {

            isAvailable =
                    Boolean.parseBoolean(
                            availableValue
                    );
        }


        /*
         * CREATE MENU OBJECT
         */
        Menu menu =
                new Menu();


        menu.setRestaurantId(
                restaurantId
        );


        menu.setItemName(
                itemName.trim()
        );


        if (description != null) {

            menu.setDescription(
                    description.trim()
            );

        } else {

            menu.setDescription("");
        }


        menu.setPrice(
                price
        );


        menu.setAvailable(
                isAvailable
        );


        if (imagePath != null) {

            menu.setImagePath(
                    imagePath.trim()
            );

        } else {

            menu.setImagePath("");
        }


        /*
         * INSERT MENU ITEM
         */
        menuDao.addMenu(
                menu
        );


        /*
         * RETURN TO SAME RESTAURANT'S
         * MENU MANAGEMENT PAGE
         */
        resp.sendRedirect(
                req.getContextPath()
                + "/adminMenus"
                + "?restaurantId="
                + restaurantId
                + "&added=true"
        );
    }
}