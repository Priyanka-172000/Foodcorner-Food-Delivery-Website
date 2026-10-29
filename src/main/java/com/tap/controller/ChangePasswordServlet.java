
package com.tap.controller;

import java.io.IOException;

import com.tap.DaoImpl.UserDaoImpl;
import com.tap.model.User;
import com.tap.util.PasswordUtil;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet("/changePassword")
public class ChangePasswordServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;

    private UserDaoImpl userDao;

    @Override
    public void init() throws ServletException {
        userDao = new UserDaoImpl();
    }

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        HttpSession session = req.getSession(false);

        if (session == null || session.getAttribute("user") == null) {
            resp.sendRedirect(req.getContextPath() + "/login.jsp");
            return;
        }

        req.getRequestDispatcher("/changePassword.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        HttpSession session = req.getSession(false);

        if (session == null || session.getAttribute("user") == null) {
            resp.sendRedirect(req.getContextPath() + "/login.jsp");
            return;
        }

        User user = (User) session.getAttribute("user");

        String oldPassword = req.getParameter("oldPassword");
        String newPassword = req.getParameter("newPassword");
        String confirmPassword = req.getParameter("confirmPassword");

        if (oldPassword == null || oldPassword.isEmpty()
                || newPassword == null || newPassword.isEmpty()
                || confirmPassword == null || confirmPassword.isEmpty()) {
            resp.sendRedirect(req.getContextPath()
                    + "/changePassword?error=empty");
            return;
        }

        if (!PasswordUtil.matches(oldPassword, user.getPassword())) {
            resp.sendRedirect(req.getContextPath()
                    + "/changePassword?error=oldPassword");
            return;
        }

        if (newPassword.length() < 8) {
            resp.sendRedirect(req.getContextPath()
                    + "/changePassword?error=weak");
            return;
        }

        if (!newPassword.equals(confirmPassword)) {
            resp.sendRedirect(req.getContextPath()
                    + "/changePassword?error=mismatch");
            return;
        }

        if (PasswordUtil.matches(newPassword, user.getPassword())) {
            resp.sendRedirect(req.getContextPath()
                    + "/changePassword?error=same");
            return;
        }

        String hashedPassword = PasswordUtil.hashIfNeeded(newPassword);

        boolean updated = userDao.updatePassword(
                user.getUserId(),
                hashedPassword
        );

        if (!updated) {
            resp.sendRedirect(req.getContextPath()
                    + "/changePassword?error=updateFailed");
            return;
        }

        user.setPassword(hashedPassword);
        session.setAttribute("user", user);

        resp.sendRedirect(req.getContextPath()
                + "/changePassword?success=updated");
    }
}
