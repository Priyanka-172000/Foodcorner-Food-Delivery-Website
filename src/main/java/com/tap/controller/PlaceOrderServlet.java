package com.tap.controller;

import java.io.IOException;

import java.sql.Timestamp;

import com.tap.DaoImpl.OrderDaoImpl;
import com.tap.DaoImpl.OrderItemDaoImpl;
import com.tap.model.Cart;
import com.tap.model.CartItem;
import com.tap.model.Order;
import com.tap.model.OrderItem;
import com.tap.model.User;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;


@WebServlet("/placeOrder")
public class PlaceOrderServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;

    private OrderDaoImpl orderDao;
    private OrderItemDaoImpl orderItemDao;


    @Override
    public void init() throws ServletException {

        orderDao = new OrderDaoImpl();

        orderItemDao = new OrderItemDaoImpl();
    }


    @Override
    protected void doPost(
            HttpServletRequest req,
            HttpServletResponse resp)

            throws ServletException,
                   IOException {


        HttpSession session =
                req.getSession(false);


        // CHECK SESSION

        if (session == null) {

            resp.sendRedirect(
                    req.getContextPath()
                    + "/login.jsp"
            );

            return;
        }


        // GET LOGGED-IN USER

        User user =
                (User) session
                        .getAttribute("user");


        if (user == null) {

            resp.sendRedirect(
                    req.getContextPath()
                    + "/login.jsp"
            );

            return;
        }


        // GET CART

        Cart cart =
                (Cart) session
                        .getAttribute("cart");


        if (cart == null ||
            cart.isEmpty()) {

            resp.sendRedirect(
                    req.getContextPath()
                    + "/restaurant"
            );

            return;
        }


        // GET CHECKOUT DETAILS

        String address =
                req.getParameter("address");

        String paymentMode =
                req.getParameter("paymentMode");


        if (address == null ||
            address.trim().isEmpty()) {

            resp.sendRedirect(
                    req.getContextPath()
                    + "/checkout"
            );

            return;
        }


        if (paymentMode == null ||
            paymentMode.trim().isEmpty()) {

            paymentMode = "COD";
        }


        // GET RESTAURANT ID

        CartItem firstItem =
                cart.getItems()
                    .iterator()
                    .next();


        int restaurantId =
                firstItem.getRestaurantId();


        // CREATE ORDER

        Order order = new Order();


        order.setUserId(
                user.getUserId()
        );


        order.setRestaurantId(
                restaurantId
        );


        order.setOrderDate(
                new Timestamp(
                        System.currentTimeMillis()
                )
        );


        order.setTotalAmount(
                cart.getTotalAmount()
        );


        order.setStatus(
                "PENDING"
        );


        order.setPaymentMode(
                paymentMode
        );


        // INSERT ORDER AND GET ORDER ID

        int orderId =
                orderDao.addOrder(order);


        if (orderId <= 0) {

            resp.sendRedirect(
                    req.getContextPath()
                    + "/checkout?error=order"
            );

            return;
        }


        // INSERT ORDER ITEMS

        for (CartItem cartItem :
                cart.getItems()) {


            OrderItem orderItem =
                    new OrderItem();


            orderItem.setOrderId(
                    orderId
            );


            orderItem.setMenuId(
                    cartItem.getMenuId()
            );


            orderItem.setQuantity(
                    cartItem.getQuantity()
            );


            orderItem.setTotalAmount(
                    cartItem.getSubtotal()
            );


            orderItemDao.addOrderItem(
                    orderItem
            );
        }


        // SAVE DETAILS FOR SUCCESS PAGE

        session.setAttribute(
                "lastOrderId",
                orderId
        );


        session.setAttribute(
                "lastOrderTotal",
                cart.getTotalAmount()
        );


        session.setAttribute(
                "lastPaymentMode",
                paymentMode
        );


        session.setAttribute(
                "lastDeliveryAddress",
                address
        );


        // CLEAR CART AFTER SUCCESS

        cart.clear();


        session.setAttribute(
                "cart",
                cart
        );


        // GO TO SUCCESS PAGE

        resp.sendRedirect(
                req.getContextPath()
                + "/orderSuccess.jsp"
        );
    }
}