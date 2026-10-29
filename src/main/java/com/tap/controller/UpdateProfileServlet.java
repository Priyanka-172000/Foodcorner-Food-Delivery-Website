
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
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        HttpSession session = req.getSession(false);

        if (session == null || session.getAttribute("user") == null) {
            resp.sendRedirect(req.getContextPath() + "/login.jsp");
            return;
        }

        User loggedInUser = (User) session.getAttribute("user");

        String username = req.getParameter("username");
        String phone = req.getParameter("phone");
        String address = req.getParameter("address");

        if (username == null || username.trim().isEmpty()
                || phone == null || phone.trim().isEmpty()
                || address == null || address.trim().isEmpty()) {

            resp.sendRedirect(
                    req.getContextPath() + "/editProfile?error=true");
            return;
        }

        loggedInUser.setUsername(username.trim());
        loggedInUser.setPhone(phone.trim());
        loggedInUser.setAddress(address.trim());

        userDao.updateUser(loggedInUser);

        User updatedUser = userDao.getUser(loggedInUser.getUserId());

        if (updatedUser != null) {
            session.setAttribute("user", updatedUser);

            resp.sendRedirect(
                    req.getContextPath() + "/editProfile?updated=true");
        } else {
            resp.sendRedirect(
                    req.getContextPath() + "/editProfile?error=true");
        }
    }
}
