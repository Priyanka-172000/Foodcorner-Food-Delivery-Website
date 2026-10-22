<%@ page language="java"
    contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<%@ page import="com.tap.model.Cart" %>
<%@ page import="com.tap.model.CartItem" %>

<!DOCTYPE html>
<html>

<head>

<meta charset="UTF-8">

<meta name="viewport"
      content="width=device-width, initial-scale=1.0">

<title>Foodcorner | Checkout</title>

<style>

* {
    margin: 0;
    padding: 0;
    box-sizing: border-box;
}

body {
    font-family: Arial, Helvetica, sans-serif;
    background: #f7f7f7;
    color: #222;
}


/* NAVBAR */

.navbar {
    background: white;

    padding: 18px 7%;

    display: flex;

    justify-content: space-between;

    align-items: center;

    box-shadow: 0 2px 12px rgba(0,0,0,0.08);
}

.logo {
    font-size: 28px;
    font-weight: bold;
    color: #ff5200;
}

.logo span {
    color: #222;
}

.back-link {
    text-decoration: none;
    color: #ff5200;
    font-weight: bold;
    font-size: 15px;
}

.back-link:hover {
    color: #d94400;
}


/* HERO */

.hero {
    padding: 45px 7%;

    background:
        linear-gradient(
            135deg,
            #fff1e9,
            #fff8f4
        );
}

.hero h1 {
    font-size: 38px;
    margin-bottom: 8px;
}

.hero h1 span {
    color: #ff5200;
}

.hero p {
    color: #666;
    font-size: 16px;
}


/* MAIN */

.container {
    width: 86%;

    margin: 40px auto;

    display: grid;

    grid-template-columns:
        1.6fr 1fr;

    gap: 30px;
}


/* CHECKOUT CARD */

.checkout-card {
    background: white;

    border-radius: 16px;

    padding: 28px;

    border: 1px solid #eeeeee;

    box-shadow:
        0 5px 20px rgba(0,0,0,0.05);
}

.checkout-card h2 {
    font-size: 23px;
    margin-bottom: 24px;
}


/* FORM */

.form-group {
    margin-bottom: 25px;
}

.form-group label {
    display: block;

    font-size: 15px;

    font-weight: bold;

    margin-bottom: 9px;
}

.address-input {
    width: 100%;

    min-height: 120px;

    resize: vertical;

    padding: 14px;

    border: 1px solid #dddddd;

    border-radius: 10px;

    outline: none;

    font-family: Arial, Helvetica, sans-serif;

    font-size: 15px;
}

.address-input:focus {
    border-color: #ff5200;
}


/* PAYMENT */

.payment-options {
    display: flex;

    flex-direction: column;

    gap: 12px;
}

.payment-option {
    border: 1px solid #dddddd;

    border-radius: 10px;

    padding: 15px;

    display: flex;

    align-items: center;

    gap: 12px;

    cursor: pointer;

    transition: 0.2s;
}

.payment-option:hover {
    border-color: #ff5200;

    background: #fff8f4;
}

.payment-option input {
    accent-color: #ff5200;
}

.payment-title {
    font-weight: bold;
}

.payment-description {
    color: #777;

    font-size: 13px;

    margin-top: 3px;
}


/* PLACE ORDER */

.place-order-btn {
    width: 100%;

    border: none;

    padding: 14px;

    background: #ff5200;

    color: white;

    border-radius: 9px;

    font-size: 15px;

    font-weight: bold;

    cursor: pointer;

    margin-top: 10px;
}

.place-order-btn:hover {
    background: #e94a00;
}


/* ORDER SUMMARY */

.summary {
    background: white;

    border-radius: 16px;

    padding: 25px;

    border: 1px solid #eeeeee;

    height: fit-content;

    position: sticky;

    top: 25px;
}

.summary h2 {
    font-size: 23px;

    margin-bottom: 22px;
}


/* ITEM */

.summary-item {
    display: flex;

    gap: 13px;

    padding: 14px 0;

    border-bottom: 1px solid #eeeeee;
}

.summary-image {
    width: 70px;

    height: 65px;

    border-radius: 9px;

    object-fit: cover;
}

.summary-details {
    flex: 1;
}

.summary-name {
    font-weight: bold;

    margin-bottom: 5px;
}

.summary-quantity {
    color: #777;

    font-size: 13px;
}

.summary-price {
    color: #ff5200;

    font-weight: bold;

    margin-top: 5px;
}


/* TOTALS */

.summary-row {
    display: flex;

    justify-content: space-between;

    margin-top: 17px;

    color: #555;
}

.summary-row span:last-child {
    color: #222;

    font-weight: bold;
}

.total-row {
    margin-top: 20px;

    padding-top: 18px;

    border-top: 1px solid #dddddd;

    display: flex;

    justify-content: space-between;

    font-size: 21px;

    font-weight: bold;
}

.total-price {
    color: #ff5200;
}


/* FOOTER */

footer {
    margin-top: 60px;

    padding: 28px;

    background: #181818;

    color: #ccc;

    text-align: center;
}

footer span {
    color: #ff5200;
}


/* RESPONSIVE */

@media(max-width:850px) {

    .container {
        width: 92%;

        grid-template-columns: 1fr;
    }

    .summary {
        position: static;
    }

}

@media(max-width:600px) {

    .hero h1 {
        font-size: 30px;
    }

}

</style>

</head>


<body>


<%

Cart cart =
        (Cart) request.getAttribute("cart");

%>



<!-- NAVBAR -->

<nav class="navbar">

    <div class="logo">

        Food<span>corner</span>

    </div>


    <a
        class="back-link"

        href="<%= request.getContextPath() %>/cart">

        ← Back to Cart

    </a>

</nav>



<!-- HERO -->

<section class="hero">

    <h1>

        Complete your
        <span>Checkout</span>

    </h1>

    <p>

        Confirm your delivery details
        and payment method.

    </p>

</section>



<!-- MAIN -->

<div class="container">


    <!-- LEFT SIDE -->

    <div class="checkout-card">


        <h2>
            Delivery Details
        </h2>


        <form
            action="<%= request.getContextPath() %>/placeOrder"

            method="post">


            <!-- ADDRESS -->

            <div class="form-group">

                <label for="address">

                    Delivery Address

                </label>


                <textarea
                    id="address"

                    name="address"

                    class="address-input"

                    placeholder="Enter your complete delivery address..."

                    required></textarea>

            </div>



            <!-- PAYMENT -->

            <div class="form-group">


                <label>
                    Payment Method
                </label>


                <div class="payment-options">


                    <!-- COD -->

                    <label class="payment-option">


                        <input
                            type="radio"

                            name="paymentMode"

                            value="COD"

                            checked>


                        <div>

                            <div class="payment-title">

                                Cash on Delivery

                            </div>

                            <div class="payment-description">

                                Pay when your food is delivered.

                            </div>

                        </div>


                    </label>



                    <!-- UPI -->

                    <label class="payment-option">


                        <input
                            type="radio"

                            name="paymentMode"

                            value="UPI">


                        <div>

                            <div class="payment-title">

                                UPI

                            </div>

                            <div class="payment-description">

                                Pay using Google Pay,
                                PhonePe, Paytm or other UPI apps.

                            </div>

                        </div>


                    </label>


                </div>

            </div>



            <!-- PLACE ORDER -->

            <button
                type="submit"

                class="place-order-btn">

                Place Order →

            </button>


        </form>


    </div>



    <!-- RIGHT SIDE -->

    <div class="summary">


        <h2>
            Order Summary
        </h2>


<%

if (cart != null &&
    !cart.isEmpty()) {

    for (CartItem item :
            cart.getItems()) {

%>


        <div class="summary-item">


            <img
                class="summary-image"

                src="<%= item.getImagePath() %>"

                alt="<%= item.getItemName() %>"

                onerror="this.src='https://images.unsplash.com/photo-1504674900247-0877df9cc836?w=300&h=300&fit=crop';">


            <div class="summary-details">


                <div class="summary-name">

                    <%= item.getItemName() %>

                </div>


                <div class="summary-quantity">

                    Quantity:
                    <%= item.getQuantity() %>

                </div>


                <div class="summary-price">

                    ₹<%= String.format(
                            "%.2f",
                            item.getSubtotal()
                    ) %>

                </div>


            </div>


        </div>


<%

    }

%>



        <div class="summary-row">

            <span>

                Total Items

            </span>

            <span>

                <%= cart.getTotalQuantity() %>

            </span>

        </div>



        <div class="summary-row">

            <span>

                Subtotal

            </span>

            <span>

                ₹<%= String.format(
                        "%.2f",
                        cart.getTotalAmount()
                ) %>

            </span>

        </div>



        <div class="summary-row">

            <span>

                Delivery Fee

            </span>

            <span>

                FREE

            </span>

        </div>



        <div class="total-row">

            <span>

                Total

            </span>

            <span class="total-price">

                ₹<%= String.format(
                        "%.2f",
                        cart.getTotalAmount()
                ) %>

            </span>

        </div>


<%

}

%>


    </div>


</div>



<footer>

    © 2026
    <span>Foodcorner</span>

</footer>


</body>

</html>