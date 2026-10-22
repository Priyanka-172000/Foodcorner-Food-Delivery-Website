<%@ page language="java"
    contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<%@ page import="java.util.List" %>
<%@ page import="java.util.Map" %>

<%@ page import="com.tap.model.Order" %>
<%@ page import="com.tap.model.OrderItem" %>
<%@ page import="com.tap.model.Menu" %>
<%@ page import="com.tap.model.Restaurant" %>

<!DOCTYPE html>
<html>

<head>

<meta charset="UTF-8">

<meta name="viewport"
      content="width=device-width, initial-scale=1.0">

<title>Foodcorner | Order Details</title>

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

    box-shadow:
        0 2px 12px rgba(0,0,0,0.08);
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
    font-size: 14px;
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
}


/* CONTAINER */

.container {
    width: 86%;
    margin: 40px auto;
}


/* ORDER INFO */

.order-info {
    background: white;

    padding: 25px;

    border-radius: 16px;

    border: 1px solid #eeeeee;

    margin-bottom: 30px;

    display: grid;

    grid-template-columns:
        repeat(3, 1fr);

    gap: 20px;
}

.info-box {
    display: flex;

    flex-direction: column;

    gap: 6px;
}

.info-label {
    color: #777;

    font-size: 13px;
}

.info-value {
    font-weight: bold;

    font-size: 15px;
}

.restaurant-name {
    color: #ff5200;

    font-size: 17px;
}


/* STATUS */

.status {
    display: inline-block;

    width: fit-content;

    padding: 7px 12px;

    border-radius: 20px;

    font-size: 12px;

    font-weight: bold;
}

.status-pending {
    background: #fff3cd;
    color: #856404;
}

.status-confirmed {
    background: #d4edda;
    color: #155724;
}

.status-delivered {
    background: #d1ecf1;
    color: #0c5460;
}

.status-cancelled {
    background: #f8d7da;
    color: #721c24;
}


/* TITLE */

.section-title {
    font-size: 25px;

    margin-bottom: 20px;
}


/* ORDER ITEM */

.order-item {
    background: white;

    border-radius: 16px;

    border: 1px solid #eeeeee;

    padding: 17px;

    margin-bottom: 18px;

    display: flex;

    align-items: center;

    gap: 20px;

    transition: 0.3s;
}

.order-item:hover {
    transform: translateY(-3px);

    box-shadow:
        0 8px 22px rgba(0,0,0,0.08);
}

.item-image {
    width: 140px;

    height: 110px;

    object-fit: cover;

    border-radius: 12px;
}

.item-details {
    flex: 1;
}

.item-name {
    font-size: 20px;

    font-weight: bold;

    margin-bottom: 8px;
}

.item-price {
    color: #777;

    font-size: 14px;

    margin-bottom: 6px;
}

.item-quantity {
    color: #555;

    font-size: 14px;
}

.item-total {
    color: #ff5200;

    font-size: 19px;

    font-weight: bold;
}


/* SUMMARY */

.summary {
    background: white;

    border-radius: 16px;

    border: 1px solid #eeeeee;

    padding: 25px;

    margin-top: 30px;

    max-width: 450px;

    margin-left: auto;
}

.summary-row {
    display: flex;

    justify-content: space-between;

    margin-bottom: 14px;

    color: #555;
}

.total-row {
    display: flex;

    justify-content: space-between;

    border-top:
        1px solid #dddddd;

    margin-top: 18px;

    padding-top: 18px;

    font-size: 21px;

    font-weight: bold;
}

.total-price {
    color: #ff5200;
}


/* EMPTY */

.empty {
    background: white;

    padding: 50px;

    border-radius: 16px;

    text-align: center;

    color: #777;
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

@media(max-width:800px) {

    .order-info {
        grid-template-columns: 1fr;
    }

}

@media(max-width:600px) {

    .container {
        width: 92%;
    }

    .order-item {
        flex-direction: column;
        align-items: stretch;
    }

    .item-image {
        width: 100%;
        height: 200px;
    }

    .hero h1 {
        font-size: 30px;
    }

}

</style>

</head>


<body>


<%

Order order =
        (Order) request.getAttribute("order");


List<OrderItem> orderItems =
        (List<OrderItem>)
        request.getAttribute("orderItems");


Map<Integer, Menu> menuMap =
        (Map<Integer, Menu>)
        request.getAttribute("menuMap");


Restaurant restaurant =
        (Restaurant)
        request.getAttribute("restaurant");


String statusClass =
        "status-pending";


if (order != null) {

    if ("CONFIRMED".equalsIgnoreCase(
            order.getStatus())) {

        statusClass =
                "status-confirmed";
    }

    else if ("DELIVERED".equalsIgnoreCase(
            order.getStatus())) {

        statusClass =
                "status-delivered";
    }

    else if ("CANCELLED".equalsIgnoreCase(
            order.getStatus())) {

        statusClass =
                "status-cancelled";
    }
}

%>



<!-- NAVBAR -->

<nav class="navbar">

    <div class="logo">

        Food<span>corner</span>

    </div>


    <a
        class="back-link"

        href="<%= request.getContextPath() %>/myOrders">

        ← Back to My Orders

    </a>

</nav>



<!-- HERO -->

<section class="hero">

    <h1>

        Order
        <span>Details</span>

    </h1>


    <p>

        View complete details of your order.

    </p>

</section>



<div class="container">


<%

if (order != null) {

%>


    <!-- ORDER INFORMATION -->

    <div class="order-info">


        <div class="info-box">

            <span class="info-label">
                Order ID
            </span>

            <span class="info-value">

                #<%= order.getOrderId() %>

            </span>

        </div>



        <div class="info-box">

            <span class="info-label">
                Restaurant
            </span>

            <span class="info-value restaurant-name">

<%

if (restaurant != null) {

%>

                <%= restaurant.getName() %>

<%

} else {

%>

                Restaurant

<%

}

%>

            </span>

        </div>



        <div class="info-box">

            <span class="info-label">
                Order Date
            </span>

            <span class="info-value">

                <%= order.getOrderDate() %>

            </span>

        </div>



        <div class="info-box">

            <span class="info-label">
                Payment Method
            </span>

            <span class="info-value">

                <%= order.getPaymentMode() %>

            </span>

        </div>



        <div class="info-box">

            <span class="info-label">
                Status
            </span>

            <span class="status <%= statusClass %>">

                <%= order.getStatus() %>

            </span>

        </div>



        <div class="info-box">

            <span class="info-label">
                Total Amount
            </span>

            <span class="info-value restaurant-name">

                ₹<%= String.format(
                        "%.2f",
                        order.getTotalAmount()
                ) %>

            </span>

        </div>


    </div>



    <h2 class="section-title">

        Ordered Items

    </h2>



<%

if (orderItems != null &&
    !orderItems.isEmpty()) {


    for (OrderItem orderItem :
            orderItems) {


        Menu menu = null;


        if (menuMap != null) {

            menu =
                menuMap.get(
                    orderItem.getMenuId()
                );
        }

%>



    <div class="order-item">


<%

if (menu != null) {

%>


        <img
            class="item-image"

            src="<%= menu.getImagePath() %>"

            alt="<%= menu.getItemName() %>"

            onerror="this.src='https://images.unsplash.com/photo-1504674900247-0877df9cc836?w=500&h=400&fit=crop';">


        <div class="item-details">


            <div class="item-name">

                <%= menu.getItemName() %>

            </div>


            <div class="item-price">

                Price:
                ₹<%= String.format(
                        "%.2f",
                        menu.getPrice()
                ) %>

            </div>


            <div class="item-quantity">

                Quantity:
                <%= orderItem.getQuantity() %>

            </div>


        </div>


<%

} else {

%>


        <div class="item-details">


            <div class="item-name">

                Menu Item
                #<%= orderItem.getMenuId() %>

            </div>


            <div class="item-quantity">

                Quantity:
                <%= orderItem.getQuantity() %>

            </div>


        </div>


<%

}

%>



        <div class="item-total">

            ₹<%= String.format(
                    "%.2f",
                    orderItem.getTotalAmount()
            ) %>

        </div>


    </div>


<%

    }

} else {

%>


    <div class="empty">

        No items found for this order.

    </div>


<%

}

%>



    <!-- TOTAL SUMMARY -->

    <div class="summary">


        <div class="summary-row">

            <span>
                Payment
            </span>

            <span>
                <%= order.getPaymentMode() %>
            </span>

        </div>


        <div class="summary-row">

            <span>
                Status
            </span>

            <span>
                <%= order.getStatus() %>
            </span>

        </div>


        <div class="total-row">

            <span>
                Total
            </span>

            <span class="total-price">

                ₹<%= String.format(
                        "%.2f",
                        order.getTotalAmount()
                ) %>

            </span>

        </div>


    </div>


<%

}

%>


</div>



<footer>

    © 2026
    <span>Foodcorner</span>

</footer>


</body>

</html>