package com.tap.controller;

import java.io.IOException;
import java.util.ArrayList;
import java.util.List;

import com.tap.DaoImpl.UserDaoImpl;
import com.tap.model.User;

import jakarta.servlet.RequestDispatcher;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;


@WebServlet("/adminCustomers")
public class AdminCustomersServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;

    private UserDaoImpl userDao;


    @Override
    public void init() throws ServletException {

        userDao =
                new UserDaoImpl();
    }


    @Override
    protected void doGet(
            HttpServletRequest req,
            HttpServletResponse resp)

            throws ServletException,
                   IOException {


        /*
         * GET EXISTING SESSION
         */
        HttpSession session =
                req.getSession(false);


        /*
         * USER NOT LOGGED IN
         */
        if (session == null) {

            resp.sendRedirect(
                    req.getContextPath()
                    + "/login.jsp"
            );

            return;
        }


        /*
         * GET LOGGED-IN USER
         */
        User admin =
                (User) session.getAttribute(
                        "user"
                );


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
         * GET ALL USERS
         */
        List<User> allUsers =
                userDao.getAllUsers();


        /*
         * STORE ONLY CUSTOMERS
         */
        List<User> customers =
                new ArrayList<>();


        if (allUsers != null) {

            for (User user : allUsers) {


                if (user != null &&
                    user.getRole() != null &&
                    "CUSTOMER".equalsIgnoreCase(
                            user.getRole())) {


                    customers.add(
                            user
                    );
                }
            }
        }


        /*
         * SEND CUSTOMERS TO JSP
         */
        req.setAttribute(
                "customers",
                customers
        );


        /*
         * SEND ADMIN TO JSP
         */
        req.setAttribute(
                "admin",
                admin
        );


        /*
         * OPEN ADMIN CUSTOMERS PAGE
         */
        RequestDispatcher rd =
                req.getRequestDispatcher(
                        "/adminCustomers.jsp"
                );


        rd.forward(
                req,
                resp
        );
    }
}