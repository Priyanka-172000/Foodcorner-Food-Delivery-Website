
package com.tap.controller;

import java.io.IOException;
import java.math.BigDecimal;
import java.math.RoundingMode;

import com.tap.DaoImpl.OrderDaoImpl;
import com.tap.model.Cart;
import com.tap.model.Order;
import com.tap.model.User;
import com.tap.util.PayUConfig;
import com.tap.util.PayUHashUtil;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet("/payuResponse")
public class PayUResponseServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;

    private final OrderDaoImpl orderDao = new OrderDaoImpl();

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        String key = req.getParameter("key");
        String txnid = req.getParameter("txnid");
        String amount = req.getParameter("amount");
        String productinfo = req.getParameter("productinfo");
        String firstname = req.getParameter("firstname");
        String email = req.getParameter("email");
        String status = req.getParameter("status");
        String receivedHash = req.getParameter("hash");

        String udf1 = req.getParameter("udf1");
        String udf2 = req.getParameter("udf2");
        String udf3 = req.getParameter("udf3");
        String udf4 = req.getParameter("udf4");
        String udf5 = req.getParameter("udf5");

        String additionalCharges = req.getParameter("additionalCharges");

        if (isBlank(additionalCharges)) {
            additionalCharges = req.getParameter("additional_charges");
        }

        if (isBlank(key) || isBlank(txnid) || isBlank(amount)
                || isBlank(productinfo) || isBlank(firstname)
                || isBlank(email) || isBlank(status)
                || isBlank(receivedHash) || isBlank(udf1)) {

            resp.sendError(HttpServletResponse.SC_BAD_REQUEST,
                    "Invalid payment response.");
            return;
        }

        String configuredKey = PayUConfig.getKey();
        String salt = PayUConfig.getSalt();

        if (isBlank(configuredKey) || isBlank(salt)
                || !configuredKey.equals(key)) {

            resp.sendError(HttpServletResponse.SC_BAD_REQUEST,
                    "Invalid payment key.");
            return;
        }

        String expectedHash;

        try {

            expectedHash = PayUHashUtil.generateResponseHash(
                    status,
                    udf1,
                    udf2,
                    udf3,
                    udf4,
                    udf5,
                    email,
                    firstname,
                    productinfo,
                    amount,
                    txnid,
                    key,
                    salt,
                    additionalCharges
            );

        } catch (Exception e) {

            e.printStackTrace();

            resp.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR,
                    "Unable to generate response hash.");
            return;
        }

        if (!PayUHashUtil.verifyResponseHash(
                expectedHash, receivedHash)) {

            resp.sendError(HttpServletResponse.SC_BAD_REQUEST,
                    "Payment hash verification failed.");
            return;
        }

        int orderId;

        try {

            orderId = Integer.parseInt(udf1);

        } catch (NumberFormatException e) {

            resp.sendError(HttpServletResponse.SC_BAD_REQUEST,
                    "Invalid order ID.");
            return;
        }

        Order order = orderDao.getOrder(orderId);

        if (order == null) {

            resp.sendError(HttpServletResponse.SC_NOT_FOUND,
                    "Order not found.");
            return;
        }

        if (!txnid.equals(order.getPayuTxnId())) {

            resp.sendError(HttpServletResponse.SC_BAD_REQUEST,
                    "Transaction ID does not match.");
            return;
        }

        if (!"PAYU".equalsIgnoreCase(order.getPaymentMode())) {

            resp.sendError(HttpServletResponse.SC_BAD_REQUEST,
                    "Invalid payment mode.");
            return;
        }

        if (!isAmountMatching(amount, order.getTotalAmount())) {

            resp.sendError(HttpServletResponse.SC_BAD_REQUEST,
                    "Payment amount does not match the order.");
            return;
        }

        if ("success".equalsIgnoreCase(status)) {

            if (!"SUCCESS".equalsIgnoreCase(order.getPaymentStatus())) {

                if (!"PENDING".equalsIgnoreCase(order.getPaymentStatus())) {

                    resp.sendError(HttpServletResponse.SC_BAD_REQUEST,
                            "Order payment is not pending.");
                    return;
                }

                order.setPaymentStatus("SUCCESS");

                orderDao.updateOrder(order);

                Order updatedOrder = orderDao.getOrder(orderId);

                if (updatedOrder == null
                        || !"SUCCESS".equalsIgnoreCase(
                                updatedOrder.getPaymentStatus())) {

                    resp.sendError(
                            HttpServletResponse.SC_INTERNAL_SERVER_ERROR,
                            "Unable to update payment status.");
                    return;
                }

                order = updatedOrder;
            }

            showOrderSuccess(req, resp, order);
            return;
        }

        if ("failure".equalsIgnoreCase(status)) {

            if (!"SUCCESS".equalsIgnoreCase(order.getPaymentStatus())) {

                order.setPaymentStatus("FAILED");
                orderDao.updateOrder(order);
            }

            resp.sendRedirect(
                    req.getContextPath() + "/checkout?payment=failed");
            return;
        }

        resp.sendError(HttpServletResponse.SC_BAD_REQUEST,
                "Unknown payment status.");
    }

    private void showOrderSuccess(
            HttpServletRequest req,
            HttpServletResponse resp,
            Order order
    ) throws IOException {

        HttpSession session = req.getSession(true);

        User user = (User) session.getAttribute("user");

        if (user != null && user.getUserId() != order.getUserId()) {

            resp.sendError(HttpServletResponse.SC_FORBIDDEN,
                    "You are not authorized to view this order.");
            return;
        }

        session.setAttribute("lastOrderId", order.getOrderId());
        session.setAttribute("lastOrderTotal", order.getTotalAmount());
        session.setAttribute("lastPaymentMode", "Online Payment");
        session.setAttribute("lastDeliveryAddress",
                order.getDeliveryAddress());

        Cart cart = (Cart) session.getAttribute("cart");

        if (cart != null) {
            cart.clear();
            session.setAttribute("cart", cart);
        }

        resp.sendRedirect(
                req.getContextPath() + "/orderSuccess.jsp");
    }

    private boolean isAmountMatching(
            String responseAmount, double orderAmount) {

        try {

            BigDecimal response = new BigDecimal(responseAmount)
                    .setScale(2, RoundingMode.HALF_UP);

            BigDecimal expected = BigDecimal.valueOf(orderAmount)
                    .setScale(2, RoundingMode.HALF_UP);

            return response.compareTo(expected) == 0;

        } catch (NumberFormatException e) {

            return false;
        }
    }

    private boolean isBlank(String value) {
        return value == null || value.trim().isEmpty();
    }

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        resp.sendError(HttpServletResponse.SC_METHOD_NOT_ALLOWED,
                "GET method is not supported.");
    }
}
