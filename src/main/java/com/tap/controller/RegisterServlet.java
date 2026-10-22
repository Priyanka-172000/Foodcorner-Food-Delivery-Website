package com.tap.controller;

import java.io.IOException;

import com.tap.DaoImpl.UserDaoImpl;
import com.tap.model.User;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet("/register")
public class RegisterServlet extends HttpServlet {

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


        String username =
                req.getParameter("username");

        String email =
                req.getParameter("email");

        String phone =
                req.getParameter("phone");

        String address =
                req.getParameter("address");

        String password =
                req.getParameter("password");


        /*
         * Check whether email
         * already exists.
         */
        User existingUser =
                userDao.getUserByEmail(email);


        if (existingUser != null) {

            resp.sendRedirect(
                    req.getContextPath()
                    + "/register.jsp?error=emailExists"
            );

            return;
        }


        /*
         * Create new customer
         */
        User user = new User();


        user.setUsername(username);

        user.setEmail(email);

        user.setPhone(phone);

        user.setAddress(address);

        user.setPassword(password);

        user.setRole("CUSTOMER");


        /*
         * Save customer in database
         */
        userDao.addUser(user);


        /*
         * Registration successful
         */
        resp.sendRedirect(
                req.getContextPath()
                + "/login.jsp?registered=true"
        );
    }
}