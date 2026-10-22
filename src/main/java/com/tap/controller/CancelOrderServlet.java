package com.tap.controller;

import java.io.IOException;

import com.tap.DaoImpl.OrderDaoImpl;
import com.tap.model.Order;
import com.tap.model.User;
import com.tap.util.OrderStatusUtil;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;


@WebServlet("/cancelOrder")
public class CancelOrderServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;

    private OrderDaoImpl orderDao;


    @Override
    public void init() throws ServletException {

        orderDao =
                new OrderDaoImpl();
    }


    @Override
    protected void doPost(
            HttpServletRequest req,
            HttpServletResponse resp)

            throws ServletException,
                   IOException {


        /*
         * CHECK SESSION
         */
        HttpSession session =
                req.getSession(false);


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
        User user =
                (User) session.getAttribute(
                        "user"
                );


        if (user == null) {

            resp.sendRedirect(
                    req.getContextPath()
                    + "/login.jsp"
            );

            return;
        }


        /*
         * GET ORDER ID
         */
        String orderIdValue =
                req.getParameter(
                        "orderId"
                );


        if (orderIdValue == null ||
            orderIdValue.trim().isEmpty()) {

            resp.sendRedirect(
                    req.getContextPath()
                    + "/myOrders"
            );

            return;
        }


        int orderId;


        try {

            orderId =
                    Integer.parseInt(
                            orderIdValue
                    );

        } catch (NumberFormatException e) {

            resp.sendRedirect(
                    req.getContextPath()
                    + "/myOrders"
            );

            return;
        }


        /*
         * GET ORDER
         */
        Order order =
                orderDao.getOrder(
                        orderId
                );


        if (order == null) {

            resp.sendRedirect(
                    req.getContextPath()
                    + "/myOrders"
            );

            return;
        }


        /*
         * SECURITY CHECK
         *
         * CUSTOMER CAN CANCEL
         * ONLY THEIR OWN ORDER.
         */
        if (order.getUserId()
                != user.getUserId()) {

            resp.sendRedirect(
                    req.getContextPath()
                    + "/myOrders"
            );

            return;
        }


        /*
         * FIRST UPDATE THE
         * AUTOMATIC STATUS
         *
         * This prevents an old order
         * from being cancelled just
         * because the database still
         * says PENDING.
         */
        OrderStatusUtil
            .updateAutomaticStatus(
                    order,
                    orderDao
            );


        /*
         * ONLY PENDING ORDER
         * CAN BE CANCELLED
         */
        if ("PENDING".equalsIgnoreCase(
                order.getStatus())) {


            order.setStatus(
                    "CANCELLED"
            );


            orderDao.updateOrder(
                    order
            );


            resp.sendRedirect(
                    req.getContextPath()
                    + "/myOrders"
                    + "?cancelled=true"
            );


        } else {


            /*
             * ORDER ALREADY CONFIRMED
             * OR DELIVERED
             */
            resp.sendRedirect(
                    req.getContextPath()
                    + "/myOrders"
                    + "?cancelError=status"
            );
        }
    }
}