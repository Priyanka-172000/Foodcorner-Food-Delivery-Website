package com.tap.controller;

import java.io.IOException;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import com.tap.DaoImpl.OrderDaoImpl;
import com.tap.DaoImpl.RestaurantDaoImpl;
import com.tap.model.Order;
import com.tap.model.Restaurant;
import com.tap.model.User;
import com.tap.util.OrderStatusUtil;

import jakarta.servlet.RequestDispatcher;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;


@WebServlet("/myOrders")
public class OrderHistoryServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;

    private OrderDaoImpl orderDao;
    private RestaurantDaoImpl restaurantDao;


    @Override
    public void init() throws ServletException {

        orderDao =
                new OrderDaoImpl();

        restaurantDao =
                new RestaurantDaoImpl();
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
         * CHECK LOGIN
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
         * GET USER ORDERS
         */
        List<Order> orders =
                orderDao.getOrdersByUser(
                        user.getUserId()
                );


        /*
         * AUTOMATICALLY UPDATE
         * ORDER STATUS
         */
        if (orders != null) {

            for (Order order : orders) {

                OrderStatusUtil
                    .updateAutomaticStatus(
                            order,
                            orderDao
                    );
            }
        }


        /*
         * RESTAURANT NAME MAP
         */
        Map<Integer, String> restaurantNames =
                new HashMap<>();


        if (orders != null) {

            for (Order order : orders) {


                int restaurantId =
                        order.getRestaurantId();


                /*
                 * AVOID FETCHING SAME
                 * RESTAURANT REPEATEDLY
                 */
                if (!restaurantNames
                        .containsKey(
                                restaurantId)) {


                    Restaurant restaurant =
                            restaurantDao
                                .getRestaurant(
                                    restaurantId
                                );


                    if (restaurant != null) {

                        restaurantNames.put(
                                restaurantId,
                                restaurant.getName()
                        );

                    } else {

                        restaurantNames.put(
                                restaurantId,
                                "Restaurant"
                        );
                    }
                }
            }
        }


        /*
         * SEND ORDERS TO JSP
         */
        req.setAttribute(
                "orders",
                orders
        );


        /*
         * SEND USER TO JSP
         */
        req.setAttribute(
                "user",
                user
        );


        /*
         * SEND RESTAURANT NAMES
         */
        req.setAttribute(
                "restaurantNames",
                restaurantNames
        );


        /*
         * OPEN MY ORDERS PAGE
         */
        RequestDispatcher rd =
                req.getRequestDispatcher(
                        "/myOrders.jsp"
                );


        rd.forward(
                req,
                resp
        );
    }
}