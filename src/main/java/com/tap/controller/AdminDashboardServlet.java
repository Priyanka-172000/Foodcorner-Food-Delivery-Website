package com.tap.controller;

import java.io.IOException;

import com.tap.model.User;

import jakarta.servlet.RequestDispatcher;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;


@WebServlet("/adminDashboard")
public class AdminDashboardServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;


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
         * USER NOT FOUND IN SESSION
         */
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


            /*
             * CUSTOMER CANNOT ACCESS
             * ADMIN DASHBOARD
             */
            resp.sendRedirect(
                    req.getContextPath()
                    + "/restaurant"
            );

            return;
        }


        /*
         * SEND ADMIN DATA
         * TO JSP
         */
        req.setAttribute(
                "admin",
                admin
        );


        /*
         * OPEN ADMIN DASHBOARD
         */
        RequestDispatcher rd =
                req.getRequestDispatcher(
                        "/adminDashboard.jsp"
                );


        rd.forward(
                req,
                resp
        );
    }
}