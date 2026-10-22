package com.tap.controller;

import java.io.IOException;

import com.tap.DaoImpl.MenuDaoImpl;
import com.tap.model.Cart;
import com.tap.model.CartItem;
import com.tap.model.Menu;

import jakarta.servlet.RequestDispatcher;
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
    public void init()
            throws ServletException {

        menuDao =
                new MenuDaoImpl();
    }



    @Override
    protected void doGet(
            HttpServletRequest req,
            HttpServletResponse resp)

            throws ServletException,
                   IOException {


        HttpSession session =
                req.getSession();


        Cart cart =
                (Cart) session
                        .getAttribute("cart");


        if (cart == null) {

            cart =
                    new Cart();


            session.setAttribute(
                    "cart",
                    cart
            );
        }


        req.setAttribute(
                "cart",
                cart
        );


        RequestDispatcher rd =
                req.getRequestDispatcher(
                        "/cart.jsp"
                );


        rd.forward(
                req,
                resp
        );
    }



    @Override
    protected void doPost(
            HttpServletRequest req,
            HttpServletResponse resp)

            throws ServletException,
                   IOException {


        HttpSession session =
                req.getSession();


        Cart cart =
                (Cart) session
                        .getAttribute("cart");


        if (cart == null) {

            cart =
                    new Cart();


            session.setAttribute(
                    "cart",
                    cart
            );
        }


        String action =
                req.getParameter(
                        "action"
                );



        /*
         * ADD
         */
        if ("add".equals(action)) {


            int menuId =
                    Integer.parseInt(
                            req.getParameter(
                                    "menuId"
                            )
                    );


            int quantity =
                    Integer.parseInt(
                            req.getParameter(
                                    "quantity"
                            )
                    );


            Menu menu =
                    menuDao.getMenu(
                            menuId
                    );


            if (menu != null &&
                menu.isAvailable()) {


                /*
                 * Allow items from only
                 * one restaurant.
                 */

                if (!cart.isEmpty()) {


                    CartItem existingItem =
                            cart.getItems()
                                .iterator()
                                .next();


                    if (existingItem
                            .getRestaurantId()
                            !=
                            menu.getRestaurantId()) {


                        resp.sendRedirect(

                                req.getContextPath()

                                + "/menu?restaurantId="

                                + menu.getRestaurantId()

                                + "&cartError=restaurant"
                        );


                        return;
                    }
                }



                CartItem cartItem =
                        new CartItem(

                                menu.getMenuId(),

                                menu.getRestaurantId(),

                                menu.getItemName(),

                                menu.getPrice(),

                                quantity,

                                menu.getImagePath()
                        );



                cart.addItem(
                        cartItem
                );


                session.setAttribute(
                        "cart",
                        cart
                );



                /*
                 * IMPORTANT:
                 *
                 * Return to same menu.
                 */

                resp.sendRedirect(

                        req.getContextPath()

                        + "/menu?restaurantId="

                        + menu.getRestaurantId()

                        + "&added=true"
                );


                return;
            }
        }



        /*
         * UPDATE
         */
        else if ("update".equals(action)) {


            int menuId =
                    Integer.parseInt(
                            req.getParameter(
                                    "menuId"
                            )
                    );


            int quantity =
                    Integer.parseInt(
                            req.getParameter(
                                    "quantity"
                            )
                    );


            cart.updateItem(
                    menuId,
                    quantity
            );
        }



        /*
         * REMOVE
         */
        else if ("remove".equals(action)) {


            int menuId =
                    Integer.parseInt(
                            req.getParameter(
                                    "menuId"
                            )
                    );


            cart.removeItem(
                    menuId
            );
        }



        /*
         * CLEAR
         */
        else if ("clear".equals(action)) {


            cart.clear();
        }



        session.setAttribute(
                "cart",
                cart
        );



        /*
         * Update / remove / clear
         * return to cart.jsp.
         */

        resp.sendRedirect(

                req.getContextPath()
                + "/cart"
        );
    }
}