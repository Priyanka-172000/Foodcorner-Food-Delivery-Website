package com.tap.controller;

import java.io.IOException;

import com.tap.model.Cart;
import com.tap.model.User;

import jakarta.servlet.RequestDispatcher;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;


@WebServlet("/checkout")
public class CheckoutServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;


    @Override
    protected void doGet(
            HttpServletRequest req,
            HttpServletResponse resp)

            throws ServletException,
                   IOException {


        HttpSession session =
                req.getSession(false);


        /*
         * If session does not exist,
         * user is not logged in.
         */
        if (session == null) {

            resp.sendRedirect(
                    req.getContextPath()
                    + "/login.jsp"
            );

            return;
        }


        /*
         * Get cart from session
         */
        Cart cart =
                (Cart) session
                        .getAttribute("cart");


        /*
         * Cart must contain items
         */
        if (cart == null ||
            cart.isEmpty()) {

            resp.sendRedirect(
                    req.getContextPath()
                    + "/restaurant"
            );

            return;
        }


        /*
         * Get logged-in user
         */
        User user =
                (User) session
                        .getAttribute("user");


        /*
         * User must login
         * before checkout.
         */
        if (user == null) {

            resp.sendRedirect(
                    req.getContextPath()
                    + "/login.jsp"
            );

            return;
        }


        /*
         * Send cart and user
         * to checkout.jsp
         */
        req.setAttribute(
                "cart",
                cart
        );


        req.setAttribute(
                "user",
                user
        );


        RequestDispatcher rd =
                req.getRequestDispatcher(
                        "/checkout.jsp"
                );


        rd.forward(
                req,
                resp
        );
    }
}