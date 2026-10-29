
package com.tap.controller;

import java.io.IOException;
import java.math.BigDecimal;
import java.math.RoundingMode;
import java.sql.Timestamp;
import java.util.UUID;

import com.tap.DaoImpl.OrderDaoImpl;
import com.tap.DaoImpl.OrderItemDaoImpl;
import com.tap.model.Cart;
import com.tap.model.CartItem;
import com.tap.model.Order;
import com.tap.model.OrderItem;
import com.tap.model.User;
import com.tap.util.PayUConfig;
import com.tap.util.PayUHashUtil;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet("/payuPayment")
public class PayUPaymentServlet extends HttpServlet {

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
        resp.setCharacterEncoding("UTF-8");

        HttpSession session = req.getSession(false);

        if (session == null) {
            resp.sendRedirect(req.getContextPath() + "/login.jsp");
            return;
        }

        User user = (User) session.getAttribute("user");
        Cart cart = (Cart) session.getAttribute("cart");

        if (user == null) {
            resp.sendRedirect(req.getContextPath() + "/login.jsp");
            return;
        }

        if (cart == null || cart.isEmpty()) {
            resp.sendRedirect(req.getContextPath() + "/restaurant");
            return;
        }

        String address = req.getParameter("address");

        if (address == null || address.trim().isEmpty()) {
            resp.sendRedirect(req.getContextPath() + "/checkout?error=address");
            return;
        }

        address = address.trim();

        if (address.length() > 500) {
            resp.sendRedirect(req.getContextPath() + "/checkout?error=address");
            return;
        }

        String firstName = user.getUsername();
        String email = user.getEmail();
        String phone = user.getPhone();

        if (firstName == null || firstName.trim().isEmpty()
                || email == null || email.trim().isEmpty()
                || phone == null || phone.trim().isEmpty()) {
            resp.sendRedirect(req.getContextPath() + "/checkout?error=profile");
            return;
        }

        String key;
        String salt;
        String paymentUrl;

        try {
            key = PayUConfig.getKey();
            salt = PayUConfig.getSalt();
            paymentUrl = PayUConfig.getPaymentUrl();
        } catch (IllegalStateException e) {
            log("PayU configuration is missing or invalid.", e);
            resp.sendError(
                    HttpServletResponse.SC_INTERNAL_SERVER_ERROR,
                    "Payment configuration is unavailable."
            );
            return;
        }

        BigDecimal amount = BigDecimal.valueOf(cart.getTotalAmount())
                .setScale(2, RoundingMode.HALF_UP);

        if (amount.compareTo(BigDecimal.ZERO) <= 0) {
            resp.sendRedirect(req.getContextPath() + "/checkout?error=amount");
            return;
        }

        CartItem firstItem = cart.getItems().iterator().next();
        int restaurantId = firstItem.getRestaurantId();

        String txnid = "FC" + UUID.randomUUID()
                .toString()
                .replace("-", "")
                .substring(0, 20);

        String amountString = amount.toPlainString();

        Order order = new Order();
        order.setUserId(user.getUserId());
        order.setRestaurantId(restaurantId);
        order.setOrderDate(new Timestamp(System.currentTimeMillis()));
        order.setTotalAmount(amount.doubleValue());
        order.setStatus("PENDING");
        order.setPaymentMode("PAYU");
        order.setDeliveryAddress(address);
        order.setPaymentStatus("PENDING");
        order.setPayuTxnId(txnid);

        int orderId = orderDao.addOrder(order);

        if (orderId <= 0) {
            resp.sendRedirect(req.getContextPath() + "/checkout?error=order");
            return;
        }

        for (CartItem cartItem : cart.getItems()) {
            OrderItem orderItem = new OrderItem();
            orderItem.setOrderId(orderId);
            orderItem.setMenuId(cartItem.getMenuId());
            orderItem.setQuantity(cartItem.getQuantity());
            orderItem.setTotalAmount(cartItem.getSubtotal());

            orderItemDao.addOrderItem(orderItem);
        }

        if (orderItemDao.getOrderItemsByOrder(orderId).size()
                != cart.getItems().size()) {

            order.setStatus("CANCELLED");
            order.setPaymentStatus("FAILED");
            orderDao.updateOrder(order);

            resp.sendRedirect(
                    req.getContextPath() + "/checkout?error=orderitems"
            );
            return;
        }

        String productInfo = "Foodcorner Order #" + orderId;
        String udf1 = String.valueOf(orderId);
        String udf2 = "";
        String udf3 = "";
        String udf4 = "";
        String udf5 = "";

        String hash = PayUHashUtil.generateRequestHash(
                key,
                txnid,
                amountString,
                productInfo,
                firstName.trim(),
                email.trim(),
                udf1,
                udf2,
                udf3,
                udf4,
                udf5,
                salt
        );

        String callbackUrl = getCallbackUrl(req);

        resp.setContentType("text/html;charset=UTF-8");

        StringBuilder html = new StringBuilder();

        html.append("<!DOCTYPE html><html><head>")
            .append("<meta charset=\"UTF-8\">")
            .append("<title>Redirecting to PayU</title>")
            .append("</head><body>")
            .append("<p>Redirecting securely to PayU...</p>")
            .append("<form id=\"payuForm\" method=\"post\" action=\"")
            .append(escapeHtml(paymentUrl))
            .append("\">");

        addField(html, "key", key);
        addField(html, "txnid", txnid);
        addField(html, "amount", amountString);
        addField(html, "productinfo", productInfo);
        addField(html, "firstname", firstName.trim());
        addField(html, "email", email.trim());
        addField(html, "phone", phone.trim());
        addField(html, "surl", callbackUrl);
        addField(html, "furl", callbackUrl);
        addField(html, "udf1", udf1);
        addField(html, "udf2", udf2);
        addField(html, "udf3", udf3);
        addField(html, "udf4", udf4);
        addField(html, "udf5", udf5);
        addField(html, "hash", hash);

        html.append("<button type=\"submit\">Continue to PayU</button>")
            .append("</form>")
            .append("<script>")
            .append("document.getElementById('payuForm').submit();")
            .append("</script>")
            .append("</body></html>");

        resp.getWriter().write(html.toString());
    }

    private String getCallbackUrl(HttpServletRequest req) {

        String scheme = req.getScheme();
        String host = req.getServerName();
        int port = req.getServerPort();

        boolean defaultPort =
                ("http".equalsIgnoreCase(scheme) && port == 80)
                || ("https".equalsIgnoreCase(scheme) && port == 443);

        StringBuilder url = new StringBuilder();
        url.append(scheme).append("://").append(host);

        if (!defaultPort) {
            url.append(":").append(port);
        }

        url.append(req.getContextPath()).append("/payuResponse");

        return url.toString();
    }

    private void addField(
            StringBuilder html,
            String name,
            String value) {

        html.append("<input type=\"hidden\" name=\"")
            .append(escapeHtml(name))
            .append("\" value=\"")
            .append(escapeHtml(value))
            .append("\">");
    }

    private String escapeHtml(String value) {

        if (value == null) {
            return "";
        }

        return value.replace("&", "&amp;")
                .replace("<", "&lt;")
                .replace(">", "&gt;")
                .replace("\"", "&quot;")
                .replace("'", "&#39;");
    }
}

