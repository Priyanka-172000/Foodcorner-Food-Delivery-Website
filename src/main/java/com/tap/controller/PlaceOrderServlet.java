
package com.tap.controller;

import java.io.IOException;
import java.sql.Timestamp;
import java.util.List;

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
            throws ServletException, IOException {

        req.setCharacterEncoding("UTF-8");

        HttpSession session = req.getSession(false);

        if (session == null) {
            resp.sendRedirect(req.getContextPath() + "/login.jsp");
            return;
        }

        User user = (User) session.getAttribute("user");

        if (user == null) {
            resp.sendRedirect(req.getContextPath() + "/login.jsp");
            return;
        }

        Cart cart = (Cart) session.getAttribute("cart");

        if (cart == null || cart.isEmpty()) {
            resp.sendRedirect(req.getContextPath() + "/restaurant");
            return;
        }

        String address = req.getParameter("address");
        String paymentMode = req.getParameter("paymentMode");

        if (address == null || address.trim().isEmpty()
                || address.trim().length() > 500) {
            resp.sendRedirect(
                    req.getContextPath() + "/checkout?error=address"
            );
            return;
        }

        if (paymentMode == null || !"COD".equals(paymentMode.trim())) {
            resp.sendRedirect(
                    req.getContextPath() + "/checkout?error=payment"
            );
            return;
        }

        address = address.trim();

        CartItem firstItem = cart.getItems().iterator().next();
        int restaurantId = firstItem.getRestaurantId();

        Order order = new Order();

        order.setUserId(user.getUserId());
        order.setRestaurantId(restaurantId);
        order.setOrderDate(new Timestamp(System.currentTimeMillis()));
        order.setTotalAmount(cart.getTotalAmount());
        order.setStatus("PENDING");
        order.setPaymentMode("COD");
        order.setDeliveryAddress(address);
        order.setPaymentStatus("NOT_REQUIRED");

        int orderId = orderDao.addOrder(order);

        if (orderId <= 0) {
            resp.sendRedirect(
                    req.getContextPath() + "/checkout?error=order"
            );
            return;
        }

        order.setOrderId(orderId);

        for (CartItem cartItem : cart.getItems()) {
            OrderItem orderItem = new OrderItem();

            orderItem.setOrderId(orderId);
            orderItem.setMenuId(cartItem.getMenuId());
            orderItem.setQuantity(cartItem.getQuantity());
            orderItem.setTotalAmount(cartItem.getSubtotal());

            orderItemDao.addOrderItem(orderItem);
        }

        List<OrderItem> savedItems =
                orderItemDao.getOrderItemsByOrder(orderId);

        if (savedItems == null
                || savedItems.size() != cart.getItems().size()) {

            order.setStatus("CANCELLED");
            orderDao.updateOrder(order);

            resp.sendRedirect(
                    req.getContextPath() + "/checkout?error=orderitems"
            );
            return;
        }

        session.setAttribute("lastOrderId", orderId);
        session.setAttribute("lastOrderTotal", cart.getTotalAmount());
        session.setAttribute("lastPaymentMode", "COD");
        session.setAttribute("lastDeliveryAddress", address);

        cart.clear();
        session.setAttribute("cart", cart);

        resp.sendRedirect(
                req.getContextPath() + "/orderSuccess.jsp"
        );
    }
}
