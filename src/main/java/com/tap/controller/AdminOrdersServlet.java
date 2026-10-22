package com.tap.controller;

import java.io.IOException;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import com.tap.DaoImpl.OrderDaoImpl;
import com.tap.DaoImpl.RestaurantDaoImpl;
import com.tap.DaoImpl.UserDaoImpl;
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


@WebServlet("/adminOrders")
public class AdminOrdersServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;

    private OrderDaoImpl orderDao;
    private UserDaoImpl userDao;
    private RestaurantDaoImpl restaurantDao;


    @Override
    public void init() throws ServletException {

        orderDao =
                new OrderDaoImpl();

        userDao =
                new UserDaoImpl();

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
         * GET ALL ORDERS
         */
        List<Order> orders =
                orderDao.getAllOrders();


        /*
         * AUTOMATIC ORDER STATUS
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
         * CUSTOMER NAME MAP
         */
        Map<Integer, String> customerNames =
                new HashMap<>();


        /*
         * RESTAURANT NAME MAP
         */
        Map<Integer, String> restaurantNames =
                new HashMap<>();


        if (orders != null) {

            for (Order order : orders) {


                /*
                 * CUSTOMER NAME
                 */
                int userId =
                        order.getUserId();


                if (!customerNames
                        .containsKey(userId)) {


                    User customer =
                            userDao.getUser(
                                    userId
                            );


                    if (customer != null) {

                        customerNames.put(
                                userId,
                                customer.getUsername()
                        );

                    } else {

                        customerNames.put(
                                userId,
                                "Customer"
                        );
                    }
                }


                /*
                 * RESTAURANT NAME
                 */
                int restaurantId =
                        order.getRestaurantId();


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
         * SEND DATA TO JSP
         */
        req.setAttribute(
                "orders",
                orders
        );


        req.setAttribute(
                "customerNames",
                customerNames
        );


        req.setAttribute(
                "restaurantNames",
                restaurantNames
        );


        req.setAttribute(
                "admin",
                admin
        );


        /*
         * OPEN ADMIN ORDERS PAGE
         */
        RequestDispatcher rd =
                req.getRequestDispatcher(
                        "/adminOrders.jsp"
                );


        rd.forward(
                req,
                resp
        );
    }
}