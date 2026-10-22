package com.tap.controller;

import java.io.IOException;
import java.util.List;

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


@WebServlet("/adminRestaurants")
public class AdminRestaurantServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;

    private RestaurantDaoImpl restaurantDao;


    @Override
    public void init() throws ServletException {

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
                (User) session
                        .getAttribute("user");


        if (admin == null) {

            resp.sendRedirect(
                    req.getContextPath()
                    + "/login.jsp"
            );

            return;
        }


        /*
         * CHECK ADMIN ROLE
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
         * GET ALL RESTAURANTS
         */
        List<Restaurant> restaurants =
                restaurantDao
                        .getAllRestaurants();


        /*
         * SEND DATA TO JSP
         */
        req.setAttribute(
                "restaurants",
                restaurants
        );


        req.setAttribute(
                "admin",
                admin
        );


        /*
         * OPEN ADMIN RESTAURANT PAGE
         */
        RequestDispatcher rd =
                req.getRequestDispatcher(
                        "/adminRestaurants.jsp"
                );


        rd.forward(
                req,
                resp
        );
    }
}