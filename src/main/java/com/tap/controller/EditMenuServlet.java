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


@WebServlet("/editMenu")
public class EditMenuServlet extends HttpServlet {

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
     * OPEN EDIT MENU PAGE
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
         * GET MENU ID
         */
        String menuIdValue =
                req.getParameter("menuId");


        if (menuIdValue == null ||
            menuIdValue.trim().isEmpty()) {

            resp.sendRedirect(
                    req.getContextPath()
                    + "/adminMenus"
            );

            return;
        }


        int menuId;


        try {

            menuId =
                    Integer.parseInt(
                            menuIdValue
                    );

        } catch (NumberFormatException e) {

            resp.sendRedirect(
                    req.getContextPath()
                    + "/adminMenus"
            );

            return;
        }


        /*
         * GET MENU ITEM
         */
        Menu menu =
                menuDao.getMenu(
                        menuId
                );


        if (menu == null) {

            resp.sendRedirect(
                    req.getContextPath()
                    + "/adminMenus"
            );

            return;
        }


        /*
         * GET RESTAURANTS FOR DROPDOWN
         */
        List<Restaurant> restaurants =
                restaurantDao
                        .getAllRestaurants();


        /*
         * SEND DATA TO JSP
         */
        req.setAttribute(
                "menu",
                menu
        );


        req.setAttribute(
                "restaurants",
                restaurants
        );


        req.setAttribute(
                "admin",
                admin
        );


        RequestDispatcher rd =
                req.getRequestDispatcher(
                        "/editMenu.jsp"
                );


        rd.forward(
                req,
                resp
        );
    }


    /*
     * UPDATE MENU ITEM
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
         * ONLY ADMIN CAN UPDATE MENU
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
         * GET VALUES
         */
        String menuIdValue =
                req.getParameter("menuId");

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
         * REQUIRED VALIDATION
         */
        if (menuIdValue == null ||
            menuIdValue.trim().isEmpty() ||

            restaurantIdValue == null ||
            restaurantIdValue.trim().isEmpty() ||

            itemName == null ||
            itemName.trim().isEmpty() ||

            priceValue == null ||
            priceValue.trim().isEmpty()) {


            resp.sendRedirect(
                    req.getContextPath()
                    + "/adminMenus?error=true"
            );

            return;
        }


        int menuId;
        int restaurantId;


        /*
         * PARSE IDS
         */
        try {

            menuId =
                    Integer.parseInt(
                            menuIdValue
                    );


            restaurantId =
                    Integer.parseInt(
                            restaurantIdValue
                    );


        } catch (NumberFormatException e) {

            resp.sendRedirect(
                    req.getContextPath()
                    + "/adminMenus?error=true"
            );

            return;
        }


        /*
         * GET EXISTING MENU
         */
        Menu menu =
                menuDao.getMenu(
                        menuId
                );


        if (menu == null) {

            resp.sendRedirect(
                    req.getContextPath()
                    + "/adminMenus?error=true"
            );

            return;
        }


        /*
         * CHECK RESTAURANT
         */
        Restaurant restaurant =
                restaurantDao.getRestaurant(
                        restaurantId
                );


        if (restaurant == null) {

            resp.sendRedirect(
                    req.getContextPath()
                    + "/editMenu"
                    + "?menuId="
                    + menuId
                    + "&error=restaurant"
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
                    + "/editMenu"
                    + "?menuId="
                    + menuId
                    + "&error=price"
            );

            return;
        }


        if (price <= 0) {

            resp.sendRedirect(
                    req.getContextPath()
                    + "/editMenu"
                    + "?menuId="
                    + menuId
                    + "&error=price"
            );

            return;
        }


        /*
         * AVAILABILITY
         */
        boolean isAvailable =
                Boolean.parseBoolean(
                        availableValue
                );


        /*
         * UPDATE MENU OBJECT
         */
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
         * UPDATE DATABASE
         */
        menuDao.updateMenu(
                menu
        );


        /*
         * RETURN TO THAT RESTAURANT MENU
         */
        resp.sendRedirect(
                req.getContextPath()
                + "/adminMenus"
                + "?restaurantId="
                + restaurantId
                + "&updated=true"
        );
    }
}