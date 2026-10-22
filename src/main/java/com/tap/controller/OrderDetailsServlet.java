package com.tap.controller;

import java.io.IOException;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import com.tap.DaoImpl.MenuDaoImpl;
import com.tap.DaoImpl.OrderDaoImpl;
import com.tap.DaoImpl.OrderItemDaoImpl;
import com.tap.DaoImpl.RestaurantDaoImpl;
import com.tap.model.Menu;
import com.tap.model.Order;
import com.tap.model.OrderItem;
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


@WebServlet("/orderDetails")
public class OrderDetailsServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;

    private OrderDaoImpl orderDao;
    private OrderItemDaoImpl orderItemDao;
    private MenuDaoImpl menuDao;
    private RestaurantDaoImpl restaurantDao;


    @Override
    public void init() throws ServletException {

        orderDao =
                new OrderDaoImpl();

        orderItemDao =
                new OrderItemDaoImpl();

        menuDao =
                new MenuDaoImpl();

        restaurantDao =
                new RestaurantDaoImpl();
    }


    @Override
    protected void doGet(
            HttpServletRequest req,
            HttpServletResponse resp)

            throws ServletException,
                   IOException {


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
         * CUSTOMER CAN VIEW
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
         * AUTOMATIC STATUS UPDATE
         */
        OrderStatusUtil
            .updateAutomaticStatus(
                    order,
                    orderDao
            );


        /*
         * GET ORDER ITEMS
         */
        List<OrderItem> orderItems =
                orderItemDao
                    .getOrderItemsByOrder(
                            orderId
                    );


        /*
         * MENU MAP
         *
         * menuId -> Menu object
         */
        Map<Integer, Menu> menuMap =
                new HashMap<>();


        if (orderItems != null) {

            for (OrderItem orderItem :
                    orderItems) {


                int menuId =
                        orderItem.getMenuId();


                if (!menuMap
                        .containsKey(menuId)) {


                    Menu menu =
                            menuDao.getMenu(
                                    menuId
                            );


                    if (menu != null) {

                        menuMap.put(
                                menuId,
                                menu
                        );
                    }
                }
            }
        }


        /*
         * GET RESTAURANT
         */
        Restaurant restaurant =
                restaurantDao.getRestaurant(
                        order.getRestaurantId()
                );


        /*
         * SEND DATA TO JSP
         */
        req.setAttribute(
                "order",
                order
        );


        req.setAttribute(
                "orderItems",
                orderItems
        );


        req.setAttribute(
                "menuMap",
                menuMap
        );


        req.setAttribute(
                "restaurant",
                restaurant
        );


        /*
         * OPEN ORDER DETAILS PAGE
         */
        RequestDispatcher rd =
                req.getRequestDispatcher(
                        "/orderDetails.jsp"
                );


        rd.forward(
                req,
                resp
        );
    }
}