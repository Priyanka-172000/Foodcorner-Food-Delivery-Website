package com.tap.controller;

import java.io.IOException;

import com.tap.DaoImpl.UserDaoImpl;
import com.tap.model.Cart;
import com.tap.model.User;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;


@WebServlet("/login")
public class LoginServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;

    private UserDaoImpl userDao;


    @Override
    public void init() throws ServletException {

        userDao =
                new UserDaoImpl();
    }


    @Override
    protected void doPost(
            HttpServletRequest req,
            HttpServletResponse resp)

            throws ServletException,
                   IOException {


        /*
         * GET LOGIN DETAILS
         */
        String email =
                req.getParameter("email");

        String password =
                req.getParameter("password");


        /*
         * BASIC VALIDATION
         */
        if (email == null ||
            email.trim().isEmpty() ||
            password == null ||
            password.trim().isEmpty()) {


            resp.sendRedirect(
                    req.getContextPath()
                    + "/login.jsp?error=invalid"
            );

            return;
        }


        /*
         * FIND USER USING EMAIL
         */
        User user =
                userDao.getUserByEmail(
                        email.trim()
                );


        /*
         * CHECK EMAIL AND PASSWORD
         */
        if (user != null &&
            user.getPassword() != null &&
            user.getPassword()
                .equals(password)) {


            /*
             * CREATE / GET SESSION
             */
            HttpSession session =
                    req.getSession();


            /*
             * STORE LOGGED-IN USER
             */
            session.setAttribute(
                    "user",
                    user
            );


            /*
             * ============================
             * ADMIN LOGIN
             * ============================
             */
            if (user.getRole() != null &&
                "ADMIN".equalsIgnoreCase(
                        user.getRole())) {


                resp.sendRedirect(
                        req.getContextPath()
                        + "/adminDashboard"
                );

                return;
            }


            /*
             * ============================
             * CUSTOMER LOGIN
             * ============================
             *
             * Check whether customer
             * already added items to cart
             * before logging in.
             */
            Cart cart =
                    (Cart) session
                            .getAttribute(
                                    "cart"
                            );


            /*
             * CUSTOMER HAS CART
             *
             * Continue directly to checkout.
             */
            if (cart != null &&
                !cart.isEmpty()) {


                resp.sendRedirect(
                        req.getContextPath()
                        + "/checkout"
                );

                return;
            }


            /*
             * NORMAL CUSTOMER LOGIN
             *
             * Open restaurant website.
             */
            resp.sendRedirect(
                    req.getContextPath()
                    + "/restaurant"
            );


        } else {


            /*
             * INVALID EMAIL / PASSWORD
             */
            resp.sendRedirect(
                    req.getContextPath()
                    + "/login.jsp?error=invalid"
            );
        }
    }
}