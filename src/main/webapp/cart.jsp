<%@ page language="java"
    contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<%@ page import="com.tap.model.Cart" %>
<%@ page import="com.tap.model.CartItem" %>
<%@ page import="com.tap.model.User" %>


<%
Cart cart =
        (Cart) session.getAttribute("cart");

User loggedInUser =
        (User) session.getAttribute("user");


int restaurantId = 0;

if (cart != null &&
    !cart.isEmpty() &&
    cart.getItems() != null &&
    !cart.getItems().isEmpty()) {

    CartItem firstItem =
            cart.getItems()
                .iterator()
                .next();

    restaurantId =
            firstItem.getRestaurantId();
}
%>


<!DOCTYPE html>

<html>

<head>

<meta charset="UTF-8">

<meta name="viewport"
      content="width=device-width, initial-scale=1.0">

<title>Foodcorner | Cart</title>


<style>

* {
    margin: 0;
    padding: 0;
    box-sizing: border-box;
}


body {
    font-family: Arial, Helvetica, sans-serif;
    background: #f7f7f7;
    color: #1f1f1f;
}


/* ======================================= */
/* NAVBAR */
/* ======================================= */

.navbar {
    width: 100%;
    height: 82px;

    display: flex;
    justify-content: space-between;
    align-items: center;

    padding: 0 7%;

    background: #ffffff;

    box-shadow: 0 2px 12px rgba(0,0,0,0.07);

    position: sticky;
    top: 0;
    z-index: 1000;
}


.logo {
    text-decoration: none;
    font-size: 29px;
    font-weight: 800;
    color: #ff5200;
}


.logo span {
    color: #222222;
}


.nav-right {
    display: flex;
    align-items: center;
    gap: 15px;
}


.add-more {
    text-decoration: none;
    color: #ff5200;
    font-size: 15px;
    font-weight: 700;

    padding: 10px 14px;

    border-radius: 8px;

    transition: 0.2s;
}


.add-more:hover {
    background: #fff0e8;
}


.profile-name {
    color: #444444;
    font-size: 14px;
    font-weight: bold;
}


/* ======================================= */
/* HERO */
/* ======================================= */

.cart-hero {
    width: 100%;

    padding: 42px 7%;

    background:
        linear-gradient(
            135deg,
            #fff0e8,
            #fffaf7
        );
}


.cart-hero h1 {
    font-size: 38px;
    margin-bottom: 10px;
    color: #151515;
}


.cart-hero h1 span {
    color: #ff5200;
}


.cart-hero p {
    color: #666666;
    font-size: 16px;
    line-height: 1.6;
}


/* ======================================= */
/* MAIN */
/* ======================================= */

.cart-container {
    width: 86%;
    max-width: 1450px;

    margin: 55px auto 80px auto;

    display: grid;

    grid-template-columns:
        minmax(0, 2fr)
        minmax(330px, 1fr);

    gap: 40px;

    align-items: start;
}


/* ======================================= */
/* CART ITEMS */
/* ======================================= */

.cart-items-section {
    width: 100%;

    display: flex;
    flex-direction: column;

    gap: 22px;
}


.cart-item {
    width: 100%;

    background: #ffffff;

    border: 1px solid #e9e9e9;

    border-radius: 20px;

    padding: 24px;

    display: flex;

    gap: 28px;

    align-items: center;

    box-shadow:
        0 4px 18px
        rgba(0,0,0,0.04);
}


/* ======================================= */
/* ITEM IMAGE */
/* ======================================= */

.item-image-container {
    width: 245px;
    height: 190px;

    flex-shrink: 0;

    border-radius: 15px;

    overflow: hidden;

    background: #eeeeee;
}


.item-image {
    width: 100%;
    height: 100%;

    object-fit: cover;

    display: block;
}


.image-placeholder {
    width: 100%;
    height: 100%;

    display: flex;

    justify-content: center;
    align-items: center;

    background:
        linear-gradient(
            135deg,
            #fff0e8,
            #eeeeee
        );

    font-size: 50px;
}


/* ======================================= */
/* ITEM INFO */
/* ======================================= */

.item-info {
    flex: 1;
    min-width: 0;
}


.item-name {
    font-size: 26px;
    font-weight: 800;

    color: #171717;

    margin-bottom: 10px;
}


.item-price {
    font-size: 22px;
    font-weight: 800;

    color: #ff5200;

    margin-bottom: 12px;
}


.item-subtotal {
    color: #555555;

    font-size: 16px;

    margin-bottom: 25px;
}


/* ======================================= */
/* QUANTITY AREA */
/* ======================================= */

.quantity-area {
    display: flex;
    align-items: center;

    flex-wrap: wrap;

    gap: 15px;
}


.quantity-label {
    font-size: 16px;
    font-weight: 700;

    color: #222222;
}


.quantity-box {
    display: flex;

    align-items: center;

    border: 1px solid #dddddd;

    border-radius: 12px;

    overflow: hidden;

    background: white;
}


.quantity-form {
    margin: 0;
    padding: 0;
}


.quantity-btn {
    width: 62px;
    height: 52px;

    border: none;

    background: white;

    color: #ff5200;

    font-size: 28px;

    font-weight: bold;

    cursor: pointer;

    transition: 0.2s;
}


.quantity-btn:hover {
    background: #fff1e9;
}


.quantity-value {
    width: 68px;
    height: 52px;

    display: flex;
    justify-content: center;
    align-items: center;

    border-left: 1px solid #eeeeee;
    border-right: 1px solid #eeeeee;

    font-size: 20px;

    font-weight: 700;

    color: #171717;
}


/* ======================================= */
/* REMOVE */
/* ======================================= */

.remove-form {
    margin: 0;
}


.remove-btn {
    border: none;

    background: transparent;

    color: #d32f2f;

    font-size: 14px;

    font-weight: 700;

    padding: 10px 14px;

    cursor: pointer;

    border-radius: 8px;
}


.remove-btn:hover {
    background: #fff0f0;
}


/* ======================================= */
/* ORDER SUMMARY */
/* ======================================= */

.order-summary {
    width: 100%;

    background: #ffffff;

    border: 1px solid #e9e9e9;

    border-radius: 20px;

    padding: 30px;

    box-shadow:
        0 4px 18px
        rgba(0,0,0,0.04);

    position: sticky;

    top: 105px;
}


.order-summary h2 {
    font-size: 27px;

    margin: 0 0 22px 0;

    color: #151515;
}


.summary-row {
    width: 100%;

    min-height: 48px;

    display: flex;

    justify-content: space-between;

    align-items: center;

    gap: 20px;

    font-size: 16px;

    color: #444444;
}


.summary-row strong {
    color: #151515;

    white-space: nowrap;
}


.summary-divider {
    width: 100%;
    height: 1px;

    background: #dddddd;

    margin: 13px 0;
}


.total-row {
    min-height: 62px;

    font-size: 22px;

    font-weight: 800;

    color: #151515;
}


.total-amount {
    color: #ff5200;

    font-size: 25px;

    font-weight: 800;

    white-space: nowrap;
}


/* ======================================= */
/* CHECKOUT BUTTON */
/* ======================================= */

.checkout-btn {
    width: 100%;

    min-height: 55px;

    margin-top: 18px;

    padding: 14px 18px;

    display: flex;

    justify-content: center;

    align-items: center;

    background: #ff5200;

    color: #ffffff;

    border: none;

    border-radius: 11px;

    text-decoration: none;

    text-align: center;

    font-size: 16px;

    font-weight: 800;

    cursor: pointer;

    box-sizing: border-box;

    position: static !important;

    float: none !important;

    transform: none !important;
}


.checkout-btn:hover {
    background: #e94a00;
}


/* ======================================= */
/* CLEAR CART */
/* ======================================= */

.clear-cart-form {
    width: 100%;

    margin: 12px 0 0 0;
}


.clear-cart-btn {
    width: 100%;

    min-height: 52px;

    border: 1px solid #dddddd;

    border-radius: 11px;

    background: #ffffff;

    color: #444444;

    font-size: 15px;

    font-weight: 700;

    cursor: pointer;

    transition: 0.2s;
}


.clear-cart-btn:hover {
    color: #ff5200;

    border-color: #ff5200;

    background: #fff4ee;
}


/* ======================================= */
/* CONTINUE SHOPPING */
/* ======================================= */

.continue-shopping {
    display: inline-flex;

    align-items: center;

    justify-content: center;

    margin-top: 12px;

    width: 100%;

    text-decoration: none;

    color: #ff5200;

    font-size: 14px;

    font-weight: 700;

    padding: 10px;
}


/* ======================================= */
/* EMPTY CART */
/* ======================================= */

.empty-cart {
    width: 86%;

    max-width: 950px;

    margin: 70px auto;

    background: white;

    border: 1px solid #eeeeee;

    border-radius: 20px;

    padding: 80px 30px;

    text-align: center;

    box-shadow:
        0 5px 20px
        rgba(0,0,0,0.05);
}


.empty-cart-icon {
    font-size: 70px;

    margin-bottom: 20px;
}


.empty-cart h2 {
    font-size: 30px;

    margin-bottom: 12px;
}


.empty-cart p {
    color: #777777;

    margin-bottom: 25px;

    line-height: 1.6;
}


.start-order-btn {
    display: inline-block;

    padding: 14px 25px;

    background: #ff5200;

    color: white;

    text-decoration: none;

    border-radius: 10px;

    font-weight: bold;
}


.start-order-btn:hover {
    background: #e94a00;
}


/* ======================================= */
/* FOOTER */
/* ======================================= */

footer {
    width: 100%;

    background: #171717;

    color: #cccccc;

    padding: 28px;

    text-align: center;

    font-size: 13px;
}


footer span {
    color: #ff5200;
}


/* ======================================= */
/* RESPONSIVE */
/* ======================================= */

@media(max-width: 1000px) {

    .cart-container {
        width: 92%;

        grid-template-columns: 1fr;
    }


    .order-summary {
        position: static;
    }

}


@media(max-width: 750px) {

    .navbar {
        height: auto;

        min-height: 72px;

        padding: 14px 4%;
    }


    .logo {
        font-size: 23px;
    }


    .profile-name {
        display: none;
    }


    .add-more {
        font-size: 13px;

        padding: 8px;
    }


    .cart-hero {
        padding: 35px 5%;
    }


    .cart-hero h1 {
        font-size: 30px;
    }


    .cart-item {
        flex-direction: column;

        align-items: stretch;

        padding: 18px;
    }


    .item-image-container {
        width: 100%;

        height: 230px;
    }


    .item-name {
        font-size: 23px;
    }


    .quantity-area {
        justify-content: flex-start;
    }


    .order-summary {
        padding: 24px;
    }

}


@media(max-width: 450px) {

    .item-image-container {
        height: 200px;
    }


    .quantity-btn {
        width: 52px;
    }


    .quantity-value {
        width: 58px;
    }


    .order-summary h2 {
        font-size: 24px;
    }


    .total-row {
        font-size: 19px;
    }


    .total-amount {
        font-size: 22px;
    }

}

</style>

</head>


<body>


<!-- ======================================= -->
<!-- NAVBAR -->
<!-- ======================================= -->

<nav class="navbar">

    <a
        href="<%= request.getContextPath() %>/restaurant"
        class="logo">

        Food<span>corner</span>

    </a>


    <div class="nav-right">


        <%
        if (loggedInUser != null) {
        %>

        <span class="profile-name">

            👤
            <%= loggedInUser.getUsername() %>

        </span>

        <%
        }
        %>


        <%
        if (restaurantId > 0) {
        %>

        <a
            href="<%= request.getContextPath() %>/menu?restaurantId=<%= restaurantId %>"
            class="add-more">

            ← Add More Items

        </a>

        <%
        } else {
        %>

        <a
            href="<%= request.getContextPath() %>/restaurant"
            class="add-more">

            ← Restaurants

        </a>

        <%
        }
        %>


    </div>

</nav>



<!-- ======================================= -->
<!-- HERO -->
<!-- ======================================= -->

<section class="cart-hero">

    <h1>

        Your <span>Cart</span>

    </h1>


    <p>

        Review your selected dishes before
        placing your order.

    </p>

</section>



<%
if (cart != null &&
    !cart.isEmpty()) {
%>


<!-- ======================================= -->
<!-- CART -->
<!-- ======================================= -->

<main class="cart-container">


    <!-- =================================== -->
    <!-- LEFT SIDE -->
    <!-- =================================== -->

    <section class="cart-items-section">


        <%
        for (CartItem item :
                cart.getItems()) {


            String imagePath =
                    item.getImagePath();


            String imageUrl = null;


            if (imagePath != null &&
                !imagePath.trim().isEmpty()) {


                if (imagePath.startsWith("http://") ||
                    imagePath.startsWith("https://")) {


                    imageUrl =
                            imagePath.trim();


                } else {


                    String cleanedPath =
                            imagePath.trim();


                    if (cleanedPath.startsWith("/")) {

                        cleanedPath =
                                cleanedPath.substring(1);
                    }


                    imageUrl =
                            request.getContextPath()
                            + "/"
                            + cleanedPath;
                }
            }
        %>


        <!-- ================================= -->
        <!-- CART ITEM -->
        <!-- ================================= -->

        <div class="cart-item">


            <!-- IMAGE -->

            <div class="item-image-container">


                <%
                if (imageUrl != null) {
                %>


                <img
                    src="<%= imageUrl %>"

                    alt="<%= item.getItemName() %>"

                    class="item-image"

                    onerror="
                        this.style.display='none';
                        this.nextElementSibling.style.display='flex';
                    ">


                <div
                    class="image-placeholder"
                    style="display:none;">

                    🍽️

                </div>


                <%
                } else {
                %>


                <div class="image-placeholder">

                    🍽️

                </div>


                <%
                }
                %>


            </div>



            <!-- ITEM INFO -->

            <div class="item-info">


                <div class="item-name">

                    <%= item.getItemName() %>

                </div>


                <div class="item-price">

                    ₹<%= String.format(
                            "%.2f",
                            item.getPrice()
                    ) %>

                </div>


                <div class="item-subtotal">

                    Subtotal:

                    ₹<%= String.format(
                            "%.2f",
                            item.getSubtotal()
                    ) %>

                </div>



                <!-- ========================= -->
                <!-- QUANTITY -->
                <!-- ========================= -->

                <div class="quantity-area">


                    <span class="quantity-label">

                        Quantity:

                    </span>



                    <div class="quantity-box">


                        <!-- MINUS -->

                        <form
                            action="<%= request.getContextPath() %>/cart"
                            method="post"
                            class="quantity-form">


                            <input
                                type="hidden"
                                name="action"
                                value="update">


                            <input
                                type="hidden"
                                name="menuId"
                                value="<%= item.getMenuId() %>">


                            <input
                                type="hidden"
                                name="quantity"
                                value="<%= item.getQuantity() - 1 %>">


                            <button
                                type="submit"
                                class="quantity-btn">

                                −

                            </button>


                        </form>



                        <!-- CURRENT QUANTITY -->

                        <div class="quantity-value">

                            <%= item.getQuantity() %>

                        </div>



                        <!-- PLUS -->

                        <form
                            action="<%= request.getContextPath() %>/cart"
                            method="post"
                            class="quantity-form">


                            <input
                                type="hidden"
                                name="action"
                                value="update">


                            <input
                                type="hidden"
                                name="menuId"
                                value="<%= item.getMenuId() %>">


                            <input
                                type="hidden"
                                name="quantity"
                                value="<%= item.getQuantity() + 1 %>">


                            <button
                                type="submit"
                                class="quantity-btn">

                                +

                            </button>


                        </form>


                    </div>



                    <!-- REMOVE -->

                    <form
                        action="<%= request.getContextPath() %>/cart"
                        method="post"
                        class="remove-form">


                        <input
                            type="hidden"
                            name="action"
                            value="remove">


                        <input
                            type="hidden"
                            name="menuId"
                            value="<%= item.getMenuId() %>">


                        <button
                            type="submit"
                            class="remove-btn">

                            Remove

                        </button>


                    </form>


                </div>


            </div>


        </div>


        <%
        }
        %>


    </section>



    <!-- =================================== -->
    <!-- ORDER SUMMARY -->
    <!-- =================================== -->

    <aside class="order-summary">


        <h2>

            Order Summary

        </h2>



        <div class="summary-row">

            <span>

                Total Items

            </span>


            <strong>

                <%= cart.getTotalQuantity() %>

            </strong>

        </div>



        <div class="summary-row">

            <span>

                Subtotal

            </span>


            <strong>

                ₹<%= String.format(
                        "%.2f",
                        cart.getTotalAmount()
                ) %>

            </strong>

        </div>



        <div class="summary-row">

            <span>

                Delivery Fee

            </span>


            <strong>

                FREE

            </strong>

        </div>



        <div class="summary-divider">

        </div>



        <div class="summary-row total-row">

            <span>

                Total

            </span>


            <span class="total-amount">

                ₹<%= String.format(
                        "%.2f",
                        cart.getTotalAmount()
                ) %>

            </span>

        </div>



        <!-- ================================= -->
        <!-- PROCEED TO CHECKOUT -->
        <!-- ================================= -->

        <a
            href="<%= request.getContextPath() %>/checkout"
            class="checkout-btn">

            Proceed to Checkout →

        </a>



        <!-- ================================= -->
        <!-- CLEAR CART -->
        <!-- ================================= -->

        <form
            action="<%= request.getContextPath() %>/cart"
            method="post"
            class="clear-cart-form">


            <input
                type="hidden"
                name="action"
                value="clear">


            <button
                type="submit"
                class="clear-cart-btn">

                Clear Cart

            </button>


        </form>



        <!-- ================================= -->
        <!-- CONTINUE SHOPPING -->
        <!-- ================================= -->

        <%
        if (restaurantId > 0) {
        %>


        <a
            href="<%= request.getContextPath() %>/menu?restaurantId=<%= restaurantId %>"
            class="continue-shopping">

            ← Continue Shopping

        </a>


        <%
        }
        %>


    </aside>


</main>


<%
} else {
%>


<!-- ======================================= -->
<!-- EMPTY CART -->
<!-- ======================================= -->

<div class="empty-cart">


    <div class="empty-cart-icon">

        🛒

    </div>


    <h2>

        Your cart is empty

    </h2>


    <p>

        You haven't added any food yet.
        Explore restaurants and add your
        favourite dishes.

    </p>


    <a
        href="<%= request.getContextPath() %>/restaurant"
        class="start-order-btn">

        Browse Restaurants →

    </a>


</div>


<%
}
%>



<!-- ======================================= -->
<!-- FOOTER -->
<!-- ======================================= -->

<footer>

    © 2026

    <span>

        Foodcorner

    </span>

    — Food Delivery Website

</footer>


</body>

</html>