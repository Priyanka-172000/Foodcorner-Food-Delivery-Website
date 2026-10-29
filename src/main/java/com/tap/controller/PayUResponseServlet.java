
package com.tap.controller;

import java.io.IOException;
import java.math.BigDecimal;
import java.math.RoundingMode;
import java.nio.charset.StandardCharsets;
import java.security.MessageDigest;

import com.tap.DaoImpl.OrderDaoImpl;
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

    private OrderDaoImpl orderDao;

    @Override
    public void init() throws ServletException {
        orderDao = new OrderDaoImpl();
    }

    @Override
    protected void doPost(
            HttpServletRequest req,
            HttpServletResponse resp)
            throws ServletException, IOException {

        req.setCharacterEncoding("UTF-8");

        String key = req.getParameter("key");
        String txnid = req.getParameter("txnid");
        String amountValue = req.getParameter("amount");
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

        if (additionalCharges == null) {
            additionalCharges = req.getParameter("additional_charges");
        }

        if (isBlank(key) || isBlank(txnid) || isBlank(amountValue)
                || isBlank(productinfo) || isBlank(firstname)
                || isBlank(email) || isBlank(status)
                || isBlank(receivedHash) || isBlank(udf1)) {
            resp.sendError(
                    HttpServletResponse.SC_BAD_REQUEST,
                    "Incomplete payment response."
            );
            return;
        }

        String configuredKey;
        String salt;

        try {
            configuredKey = PayUConfig.getKey();
            salt = PayUConfig.getSalt();
        } catch (IllegalStateException e) {
            log("PayU configuration is missing or invalid.", e);
            resp.sendError(
                    HttpServletResponse.SC_INTERNAL_SERVER_ERROR,
                    "Payment verification is unavailable."
            );
            return;
        }

        if (!constantTimeEquals(configuredKey, key)) {
            resp.sendError(
                    HttpServletResponse.SC_BAD_REQUEST,
                    "Invalid payment response."
            );
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
                    amountValue,
                    txnid,
                    key,
                    salt,
                    additionalCharges
            );
        } catch (IllegalArgumentException e) {
            resp.sendError(
                    HttpServletResponse.SC_BAD_REQUEST,
                    "Invalid payment response."
            );
            return;
        }

        if (!PayUHashUtil.verifyResponseHash(expectedHash, receivedHash)) {
            log("PayU response hash verification failed.");
            resp.sendError(
                    HttpServletResponse.SC_BAD_REQUEST,
                    "Payment verification failed."
            );
            return;
        }

        int orderId;

        try {
            orderId = Integer.parseInt(udf1);
        } catch (NumberFormatException e) {
            resp.sendError(
                    HttpServletResponse.SC_BAD_REQUEST,
                    "Invalid order reference."
            );
            return;
        }

        Order order = orderDao.getOrder(orderId);

        if (order == null
                || order.getPayuTxnId() == null
                || !constantTimeEquals(order.getPayuTxnId(), txnid)) {
            resp.sendError(
                    HttpServletResponse.SC_BAD_REQUEST,
                    "Order verification failed."
            );
            return;
        }

        BigDecimal responseAmount;
        BigDecimal orderAmount;

        try {
            responseAmount = new BigDecimal(amountValue)
                    .setScale(2, RoundingMode.UNNECESSARY);

            orderAmount = BigDecimal.valueOf(order.getTotalAmount())
                    .setScale(2, RoundingMode.HALF_UP);
        } catch (NumberFormatException | ArithmeticException e) {
            resp.sendError(
                    HttpServletResponse.SC_BAD_REQUEST,
                    "Invalid payment amount."
            );
            return;
        }

        if (responseAmount.compareTo(orderAmount) != 0) {
            log("PayU amount mismatch for order " + orderId);
            resp.sendError(
                    HttpServletResponse.SC_BAD_REQUEST,
                    "Payment amount verification failed."
            );
            return;
        }

        HttpSession session = req.getSession(false);

        if ("SUCCESS".equalsIgnoreCase(order.getPaymentStatus())) {
            if (session != null) {
                User user = (User) session.getAttribute("user");

                if (user != null && user.getUserId() == order.getUserId()) {
                    session.setAttribute("lastOrderId", orderId);
                    session.setAttribute("lastOrderTotal", order.getTotalAmount());
                    session.setAttribute("lastPaymentMode", "PAYU");
                    session.setAttribute(
                            "lastDeliveryAddress",
                            order.getDeliveryAddress()
                    );
                    session.removeAttribute("cart");
                }
            }

            resp.sendRedirect(req.getContextPath() + "/orderSuccess.jsp");
            return;
        }

        if ("success".equalsIgnoreCase(status)) {
            order.setPaymentStatus("SUCCESS");
            orderDao.updateOrder(order);

            if (session != null) {
                User user = (User) session.getAttribute("user");

                if (user != null && user.getUserId() == order.getUserId()) {
                    session.setAttribute("lastOrderId", orderId);
                    session.setAttribute("lastOrderTotal", order.getTotalAmount());
                    session.setAttribute("lastPaymentMode", "PAYU");
                    session.setAttribute(
                            "lastDeliveryAddress",
                            order.getDeliveryAddress()
                    );
                    session.removeAttribute("cart");
                }
            }

            resp.sendRedirect(req.getContextPath() + "/orderSuccess.jsp");
            return;
        }

        if ("failure".equalsIgnoreCase(status)) {
            order.setPaymentStatus("FAILED");
            orderDao.updateOrder(order);

            resp.sendRedirect(
                    req.getContextPath() + "/checkout?payment=failed"
            );
            return;
        }

        resp.sendRedirect(
                req.getContextPath() + "/checkout?payment=verification_failed"
        );
    }

    @Override
    protected void doGet(
            HttpServletRequest req,
            HttpServletResponse resp)
            throws ServletException, IOException {

        resp.sendError(
                HttpServletResponse.SC_METHOD_NOT_ALLOWED,
                "Payment response must use POST."
        );
    }

    private boolean constantTimeEquals(String first, String second) {
        if (first == null || second == null) {
            return false;
        }

        return MessageDigest.isEqual(
                first.getBytes(StandardCharsets.UTF_8),
                second.getBytes(StandardCharsets.UTF_8)
        );
    }

    private boolean isBlank(String value) {
        return value == null || value.trim().isEmpty();
    }
}
