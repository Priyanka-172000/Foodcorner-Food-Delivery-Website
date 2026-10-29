
package com.tap.controller;

import java.io.IOException;

import com.tap.DaoImpl.MenuDaoImpl;
import com.tap.model.Cart;
import com.tap.model.CartItem;
import com.tap.model.Menu;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet("/cart")
public class CartController extends HttpServlet {

    private static final long serialVersionUID = 1L;

    private MenuDaoImpl menuDao;

    @Override
    public void init() throws ServletException {
        menuDao = new MenuDaoImpl();
    }

    @Override
    protected void doGet(
            HttpServletRequest req,
            HttpServletResponse resp)
            throws ServletException, IOException {

        HttpSession session = req.getSession();

        Cart cart = getCart(session);

        if (isAjax(req)) {
            sendJson(resp, 200, true, "Cart loaded",
                    0, cart);
            return;
        }

        req.setAttribute("cart", cart);

        req.getRequestDispatcher("/cart.jsp")
                .forward(req, resp);
    }

    @Override
    protected void doPost(
            HttpServletRequest req,
            HttpServletResponse resp)
            throws ServletException, IOException {

        HttpSession session = req.getSession();

        Cart cart = getCart(session);

        String action = req.getParameter("action");

        if (action == null || action.isBlank()) {
            sendError(req, resp, cart, 400,
                    "Invalid cart action");
            return;
        }

        int menuId = 0;
        int itemQuantity = 0;
        int restaurantId = 0;

        if ("add".equals(action)) {

            menuId = parsePositiveInt(
                    req.getParameter("menuId"));

            int quantity = parsePositiveInt(
                    req.getParameter("quantity"));

            if (menuId == 0 || quantity == 0) {
                sendError(req, resp, cart, 400,
                        "Invalid menu item or quantity");
                return;
            }

            Menu menu = menuDao.getMenu(menuId);

            if (menu == null || !menu.isAvailable()) {
                sendError(req, resp, cart, 404,
                        "This menu item is unavailable");
                return;
            }

            restaurantId = menu.getRestaurantId();

            synchronized (cart) {

                if (!cart.isEmpty()) {

                    CartItem firstItem =
                            cart.getItems()
                                    .iterator()
                                    .next();

                    if (firstItem.getRestaurantId()
                            != restaurantId) {

                        if (isAjax(req)) {
                            sendJson(resp, 409, false,
                                    "Your cart contains items from another restaurant",
                                    0, cart);
                        } else {
                            resp.sendRedirect(
                                    req.getContextPath()
                                    + "/menu?restaurantId="
                                    + restaurantId
                                    + "&cartError=restaurant");
                        }

                        return;
                    }
                }

                CartItem cartItem = new CartItem(
                        menu.getMenuId(),
                        menu.getRestaurantId(),
                        menu.getItemName(),
                        menu.getPrice(),
                        quantity,
                        menu.getImagePath()
                );

                cart.addItem(cartItem);

                itemQuantity = getItemQuantity(cart, menuId);
            }

        } else if ("update".equals(action)) {

            menuId = parsePositiveInt(
                    req.getParameter("menuId"));

            Integer quantity = parseNonNegativeInt(
                    req.getParameter("quantity"));

            if (menuId == 0 || quantity == null) {
                sendError(req, resp, cart, 400,
                        "Invalid menu item or quantity");
                return;
            }

            synchronized (cart) {

                CartItem existing = findItem(cart, menuId);

                if (existing == null) {
                    sendError(req, resp, cart, 404,
                            "Item not found in cart");
                    return;
                }

                if (quantity == 0) {
                    cart.removeItem(menuId);
                } else {
                    cart.updateItem(menuId, quantity);
                }

                itemQuantity = getItemQuantity(cart, menuId);
            }

        } else if ("remove".equals(action)) {

            menuId = parsePositiveInt(
                    req.getParameter("menuId"));

            if (menuId == 0) {
                sendError(req, resp, cart, 400,
                        "Invalid menu item");
                return;
            }

            synchronized (cart) {
                cart.removeItem(menuId);
            }

            itemQuantity = 0;

        } else if ("clear".equals(action)) {

            synchronized (cart) {
                cart.clear();
            }

            itemQuantity = 0;

        } else {

            sendError(req, resp, cart, 400,
                    "Unsupported cart action");
            return;
        }

        session.setAttribute("cart", cart);

        if (isAjax(req)) {

            sendJson(resp, 200, true,
                    "Cart updated successfully",
                    itemQuantity, cart);

            return;
        }

        if ("add".equals(action)) {

            resp.sendRedirect(
                    req.getContextPath()
                    + "/menu?restaurantId="
                    + restaurantId);

        } else {

            resp.sendRedirect(
                    req.getContextPath() + "/cart");
        }
    }

    private Cart getCart(HttpSession session) {

        synchronized (session) {

            Cart cart = (Cart) session.getAttribute("cart");

            if (cart == null) {
                cart = new Cart();
                session.setAttribute("cart", cart);
            }

            return cart;
        }
    }

    private CartItem findItem(Cart cart, int menuId) {

        for (CartItem item : cart.getItems()) {

            if (item.getMenuId() == menuId) {
                return item;
            }
        }

        return null;
    }

    private int getItemQuantity(Cart cart, int menuId) {

        CartItem item = findItem(cart, menuId);

        return item == null ? 0 : item.getQuantity();
    }

    private int parsePositiveInt(String value) {

        Integer number = parseNonNegativeInt(value);

        if (number == null || number == 0) {
            return 0;
        }

        return number;
    }

    private Integer parseNonNegativeInt(String value) {

        if (value == null || value.isBlank()) {
            return null;
        }

        try {

            int number = Integer.parseInt(value.trim());

            return number >= 0 ? number : null;

        } catch (NumberFormatException e) {

            return null;
        }
    }

    private boolean isAjax(HttpServletRequest req) {

        return "true".equalsIgnoreCase(
                    req.getParameter("ajax"))
                || "XMLHttpRequest".equalsIgnoreCase(
                    req.getHeader("X-Requested-With"));
    }

    private void sendError(
            HttpServletRequest req,
            HttpServletResponse resp,
            Cart cart,
            int status,
            String message) throws IOException {

        if (isAjax(req)) {

            sendJson(resp, status, false,
                    message, 0, cart);

        } else {

            resp.sendError(status, message);
        }
    }

    private void sendJson(
            HttpServletResponse resp,
            int status,
            boolean success,
            String message,
            int itemQuantity,
            Cart cart) throws IOException {

        resp.setStatus(status);
        resp.setContentType("application/json");
        resp.setCharacterEncoding("UTF-8");
        resp.setHeader("Cache-Control", "no-store");

        synchronized (cart) {

            String json =
                    "{"
                    + "\"success\":" + success + ","
                    + "\"message\":\"" + message + "\","
                    + "\"itemQuantity\":" + itemQuantity + ","
                    + "\"cartQuantity\":"
                    + cart.getTotalQuantity() + ","
                    + "\"cartTotal\":"
                    + cart.getTotalAmount()
                    + "}";

            resp.getWriter().write(json);
        }
    }
}
