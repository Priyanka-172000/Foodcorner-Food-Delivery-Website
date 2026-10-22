package com.tap.controller;

import java.io.IOException;

import com.tap.DaoImpl.UserDaoImpl;
import com.tap.model.User;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;


@WebServlet("/updateProfile")
public class UpdateProfileServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;

    private UserDaoImpl userDao;


    @Override
    public void init() throws ServletException {

        userDao = new UserDaoImpl();
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
         * USER MUST BE LOGGED IN
         */
        if (session == null) {

            resp.sendRedirect(
                    req.getContextPath()
                    + "/login.jsp"
            );

            return;
        }


        User loggedInUser =
                (User) session.getAttribute("user");


        if (loggedInUser == null) {

            resp.sendRedirect(
                    req.getContextPath()
                    + "/login.jsp"
            );

            return;
        }


        /*
         * GET UPDATED VALUES
         */
        String username =
                req.getParameter("username");

        String phone =
                req.getParameter("phone");

        String address =
                req.getParameter("address");

        String password =
                req.getParameter("password");


        /*
         * BASIC VALIDATION
         */
        if (username == null ||
            username.trim().isEmpty() ||

            phone == null ||
            phone.trim().isEmpty() ||

            address == null ||
            address.trim().isEmpty() ||

            password == null ||
            password.trim().isEmpty()) {


            resp.sendRedirect(
                    req.getContextPath()
                    + "/editProfile?error=true"
            );

            return;
        }


        /*
         * UPDATE CURRENT LOGGED-IN USER
         *
         * We use the userId from SESSION,
         * not from hidden HTML input.
         */
        loggedInUser.setUsername(
                username.trim()
        );


        loggedInUser.setPhone(
                phone.trim()
        );


        loggedInUser.setAddress(
                address.trim()
        );


        loggedInUser.setPassword(
                password
        );


        /*
         * Keep existing values:
         *
         * userId
         * email
         * role
         *
         * unchanged.
         */


        /*
         * UPDATE DATABASE
         */
        userDao.updateUser(
                loggedInUser
        );


        /*
         * GET UPDATED USER AGAIN
         * FROM DATABASE
         */
        User updatedUser =
                userDao.getUser(
                        loggedInUser.getUserId()
                );


        if (updatedUser != null) {


            /*
             * UPDATE SESSION
             *
             * This is important because
             * restaurant.jsp profile dropdown
             * reads user from session.
             */
            session.setAttribute(
                    "user",
                    updatedUser
            );


            resp.sendRedirect(
                    req.getContextPath()
                    + "/editProfile?updated=true"
            );


        } else {


            resp.sendRedirect(
                    req.getContextPath()
                    + "/editProfile?error=true"
            );
        }
    }
}