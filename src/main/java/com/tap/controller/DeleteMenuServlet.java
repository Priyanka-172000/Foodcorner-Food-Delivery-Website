package com.tap.controller;

import java.io.IOException;

import com.tap.DaoImpl.MenuDaoImpl;
import com.tap.model.Menu;
import com.tap.model.User;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;


@WebServlet("/deleteMenu")
public class DeleteMenuServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;

    private MenuDaoImpl menuDao;


    @Override
    public void init() throws ServletException {

        menuDao =
                new MenuDaoImpl();
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
         * GET MENU ID
         */
        String menuIdValue =
                req.getParameter("menuId");


        if (menuIdValue == null ||
            menuIdValue.trim().isEmpty()) {

            resp.sendRedirect(
                    req.getContextPath()
                    + "/adminMenus?error=true"
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
                    + "/adminMenus?error=true"
            );

            return;
        }


        /*
         * GET MENU ITEM FIRST
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
         * SAVE RESTAURANT ID
         *
         * We need this after deletion
         * to return to the same restaurant.
         */
        int restaurantId =
                menu.getRestaurantId();


        /*
         * DELETE MENU ITEM
         */
        menuDao.deleteMenu(
                menuId
        );


        /*
         * CHECK WHETHER DELETE
         * SUCCEEDED
         */
        Menu deletedMenu =
                menuDao.getMenu(
                        menuId
                );


        if (deletedMenu == null) {


            /*
             * SUCCESS
             */
            resp.sendRedirect(
                    req.getContextPath()
                    + "/adminMenus"
                    + "?restaurantId="
                    + restaurantId
                    + "&deleted=true"
            );


        } else {


            /*
             * DELETE FAILED
             *
             * This may happen if an
             * order_item record references
             * this menu item.
             */
            resp.sendRedirect(
                    req.getContextPath()
                    + "/adminMenus"
                    + "?restaurantId="
                    + restaurantId
                    + "&error=delete"
            );
        }
    }
}