
package com.tap.controller;

import java.io.IOException;

import com.tap.DaoImpl.UserDaoImpl;
import com.tap.model.Cart;
import com.tap.model.User;
import com.tap.util.PasswordUtil;

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
        userDao = new UserDaoImpl();
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        String email = req.getParameter("email");
        String password = req.getParameter("password");

        if (email == null || email.trim().isEmpty()
                || password == null || password.trim().isEmpty()) {

            resp.sendRedirect(
                    req.getContextPath() + "/login.jsp?error=invalid");
            return;
        }

        User user = userDao.getUserByEmail(email.trim());

        if (user == null ||
                !PasswordUtil.matches(password, user.getPassword())) {

            resp.sendRedirect(
                    req.getContextPath() + "/login.jsp?error=invalid");
            return;
        }

        if (!PasswordUtil.isHashed(user.getPassword())) {
            user.setPassword(PasswordUtil.hashIfNeeded(password));
            userDao.updateUser(user);
        }

        HttpSession existingSession = req.getSession(false);

        Cart cart = null;

        if (existingSession != null) {
            cart = (Cart) existingSession.getAttribute("cart");
            existingSession.invalidate();
        }

        HttpSession session = req.getSession(true);

        session.setAttribute("user", user);

        if (user.getRole() != null &&
                "ADMIN".equalsIgnoreCase(user.getRole())) {

            resp.sendRedirect(
                    req.getContextPath() + "/adminDashboard");
            return;
        }

        if (cart != null && !cart.isEmpty()) {
            session.setAttribute("cart", cart);

            resp.sendRedirect(
                    req.getContextPath() + "/checkout");
            return;
        }

        resp.sendRedirect(
                req.getContextPath() + "/restaurant");
    }
}
