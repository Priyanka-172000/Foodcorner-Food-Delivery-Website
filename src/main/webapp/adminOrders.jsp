<%@ page language="java"
    contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<%@ page import="java.util.List" %>
<%@ page import="java.util.Map" %>

<%@ page import="com.tap.model.Order" %>
<%@ page import="com.tap.model.User" %>

<%
User admin =
        (User) request.getAttribute("admin");

if (admin == null) {

    admin =
        (User) session.getAttribute("user");
}


if (admin == null ||
    admin.getRole() == null ||
    !"ADMIN".equalsIgnoreCase(
            admin.getRole())) {

    response.sendRedirect(
            request.getContextPath()
            + "/login.jsp"
    );

    return;
}


List<Order> orders =
        (List<Order>)
        request.getAttribute("orders");


Map<Integer, String> customerNames =
        (Map<Integer, String>)
        request.getAttribute(
                "customerNames"
        );


Map<Integer, String> restaurantNames =
        (Map<Integer, String>)
        request.getAttribute(
                "restaurantNames"
        );
%>


<!DOCTYPE html>

<html>

<head>

<meta charset="UTF-8">

<meta name="viewport"
      content="width=device-width, initial-scale=1.0">

<title>
    Foodcorner | View Orders
</title>


<style>

* {
    margin: 0;
    padding: 0;
    box-sizing: border-box;
}


body {

    font-family:
        Arial,
        Helvetica,
        sans-serif;

    background: #f7f7f7;

    color: #222;

    min-height: 100vh;
}


/* ================================= */
/* NAVBAR */
/* ================================= */

.navbar {

    background: white;

    padding: 16px 6%;

    display: flex;

    justify-content: space-between;

    align-items: center;

    box-shadow:
        0 2px 12px
        rgba(0,0,0,0.08);

    position: sticky;

    top: 0;

    z-index: 1000;
}


.logo {

    font-size: 28px;

    font-weight: bold;

    color: #ff5200;
}


.logo span {

    color: #222;
}


.nav-right {

    display: flex;

    align-items: center;

    gap: 12px;
}


.admin-name {

    color: #555;

    font-size: 13px;

    font-weight: bold;
}


.nav-btn {

    text-decoration: none;

    padding:
        9px 14px;

    border-radius: 8px;

    font-size: 13px;

    font-weight: bold;

    transition: 0.2s;
}


.dashboard-btn {

    color: #ff5200;

    background: white;

    border:
        1px solid #ff5200;
}


.dashboard-btn:hover {

    background: #ff5200;

    color: white;
}


.website-btn {

    color: #444;

    border:
        1px solid #dddddd;
}


.website-btn:hover {

    background: #f2f2f2;
}


.logout-btn {

    color: white;

    background: #222;
}


.logout-btn:hover {

    background: #000;
}


/* ================================= */
/* HEADER */
/* ================================= */

.page-header {

    padding:
        42px 7%;

    background:
        linear-gradient(
            135deg,
            #fff0e8,
            #fff9f6
        );
}


.header-content {

    max-width: 1350px;

    margin: auto;
}


.page-header h1 {

    font-size: 36px;

    margin-bottom: 8px;
}


.page-header h1 span {

    color: #ff5200;
}


.page-header p {

    color: #666;

    font-size: 14px;

    line-height: 1.7;

    max-width: 700px;
}


/* ================================= */
/* MAIN */
/* ================================= */

.container {

    width: 88%;

    max-width: 1350px;

    margin:
        35px auto
        70px auto;
}


/* ================================= */
/* TOP SUMMARY */
/* ================================= */

.summary-bar {

    background: white;

    border:
        1px solid #eeeeee;

    border-radius: 14px;

    padding: 18px 20px;

    margin-bottom: 25px;

    display: flex;

    justify-content: space-between;

    align-items: center;

    gap: 20px;

    flex-wrap: wrap;
}


.order-count {

    color: #666;

    font-size: 14px;
}


.order-count strong {

    color: #ff5200;

    font-size: 18px;
}


.read-only {

    background: #edf7ff;

    color: #1769aa;

    padding:
        7px 12px;

    border-radius: 20px;

    font-size: 11px;

    font-weight: bold;
}


/* ================================= */
/* ORDER GRID */
/* ================================= */

.order-grid {

    display: grid;

    grid-template-columns:
        repeat(
            auto-fit,
            minmax(350px, 1fr)
        );

    gap: 22px;
}


/* ================================= */
/* ORDER CARD */
/* ================================= */

.order-card {

    background: white;

    border:
        1px solid #eeeeee;

    border-radius: 16px;

    overflow: hidden;

    box-shadow:
        0 4px 16px
        rgba(0,0,0,0.05);

    transition:
        transform 0.25s,
        box-shadow 0.25s;
}


.order-card:hover {

    transform:
        translateY(-3px);

    box-shadow:
        0 10px 25px
        rgba(0,0,0,0.09);
}


/* ================================= */
/* ORDER HEADER */
/* ================================= */

.order-header {

    background: #fff8f4;

    padding:
        17px 20px;

    display: flex;

    justify-content: space-between;

    align-items: center;

    gap: 12px;

    border-bottom:
        1px solid #eeeeee;
}


.order-number {

    font-size: 18px;

    font-weight: bold;
}


.order-number span {

    color: #ff5200;
}


/* ================================= */
/* STATUS */
/* ================================= */

.status {

    display: inline-block;

    padding:
        7px 11px;

    border-radius: 20px;

    font-size: 11px;

    font-weight: bold;

    text-transform: uppercase;

    white-space: nowrap;
}


.status-pending {

    background: #fff3cd;

    color: #856404;
}


.status-confirmed {

    background: #dff5e5;

    color: #147a35;
}


.status-delivered {

    background: #dff0ff;

    color: #1769aa;
}


.status-cancelled {

    background: #ffe2e2;

    color: #b42318;
}


/* ================================= */
/* ORDER BODY */
/* ================================= */

.order-body {

    padding: 20px;
}


.detail-row {

    display: flex;

    justify-content: space-between;

    align-items: flex-start;

    gap: 20px;

    padding:
        11px 0;

    border-bottom:
        1px solid #f1f1f1;
}


.detail-row:last-child {

    border-bottom: none;
}


.detail-label {

    color: #888;

    font-size: 13px;

    min-width: 110px;
}


.detail-value {

    color: #333;

    font-size: 13px;

    font-weight: bold;

    text-align: right;

    word-break: break-word;
}


.customer-name {

    color: #222;
}


.restaurant-name {

    color: #ff5200;
}


.amount {

    color: #ff5200;

    font-size: 18px;
}


/* ================================= */
/* STATUS INFO */
/* ================================= */

.status-note {

    margin:
        0 20px 20px 20px;

    padding: 12px;

    background: #fafafa;

    border-radius: 8px;

    border:
        1px solid #eeeeee;

    color: #777;

    font-size: 11px;

    line-height: 1.6;
}


/* ================================= */
/* EMPTY */
/* ================================= */

.empty-state {

    background: white;

    border:
        1px solid #eeeeee;

    border-radius: 16px;

    padding:
        70px 30px;

    text-align: center;
}


.empty-icon {

    font-size: 55px;

    margin-bottom: 15px;
}


.empty-state h2 {

    margin-bottom: 10px;
}


.empty-state p {

    color: #777;
}


/* ================================= */
/* FOOTER */
/* ================================= */

footer {

    background: #181818;

    color: #cccccc;

    text-align: center;

    padding: 26px;

    font-size: 13px;
}


footer span {

    color: #ff5200;
}


/* ================================= */
/* RESPONSIVE */
/* ================================= */

@media(max-width: 700px) {

    .navbar {

        padding:
            14px 4%;
    }


    .logo {

        font-size: 23px;
    }


    .admin-name {

        display: none;
    }


    .website-btn {

        display: none;
    }


    .page-header {

        padding:
            32px 5%;
    }


    .page-header h1 {

        font-size: 29px;
    }


    .container {

        width: 92%;
    }


    .order-grid {

        grid-template-columns: 1fr;
    }


    .detail-row {

        flex-direction: column;

        gap: 4px;
    }


    .detail-value {

        text-align: left;
    }

}

</style>

</head>


<body>


<!-- ================================= -->
<!-- NAVBAR -->
<!-- ================================= -->

<nav class="navbar">


    <div class="logo">

        Food<span>corner</span>

    </div>


    <div class="nav-right">


        <span class="admin-name">

            👤 <%= admin.getUsername() %>

        </span>


        <a
            href="<%= request.getContextPath() %>/adminDashboard"

            class="nav-btn dashboard-btn">

            Dashboard

        </a>


        <a
            href="<%= request.getContextPath() %>/restaurant"

            class="nav-btn website-btn">

            🌐 Visit Website

        </a>


        <a
            href="<%= request.getContextPath() %>/logout"

            class="nav-btn logout-btn">

            Logout

        </a>


    </div>


</nav>



<!-- ================================= -->
<!-- HEADER -->
<!-- ================================= -->

<section class="page-header">


    <div class="header-content">


        <h1>

            View

            <span>

                Orders

            </span>

        </h1>


        <p>

            View all customer orders,
            restaurant information,
            payment details, order totals
            and the current order status.

        </p>


    </div>


</section>



<!-- ================================= -->
<!-- MAIN -->
<!-- ================================= -->

<main class="container">



    <!-- SUMMARY -->

    <div class="summary-bar">


        <div class="order-count">

            Total Orders:

            <strong>

                <%= orders != null
                        ? orders.size()
                        : 0 %>

            </strong>

        </div>


        <div class="read-only">

            VIEW ONLY

        </div>


    </div>



<!-- ================================= -->
<!-- ORDERS -->
<!-- ================================= -->

<%

if (orders != null &&
    !orders.isEmpty()) {

%>


<div class="order-grid">


<%

    for (Order order : orders) {


        String customerName =
                "Customer";


        if (customerNames != null &&
            customerNames.get(
                    order.getUserId()
            ) != null) {

            customerName =
                    customerNames.get(
                            order.getUserId()
                    );
        }


        String restaurantName =
                "Restaurant";


        if (restaurantNames != null &&
            restaurantNames.get(
                    order.getRestaurantId()
            ) != null) {

            restaurantName =
                    restaurantNames.get(
                            order.getRestaurantId()
                    );
        }


        String statusClass =
                "status-pending";


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

%>



<div class="order-card">


    <!-- ORDER HEADER -->

    <div class="order-header">


        <div class="order-number">

            Order

            <span>

                #<%= order.getOrderId() %>

            </span>

        </div>


        <span
            class="status <%= statusClass %>">

            <%= order.getStatus() %>

        </span>


    </div>



    <!-- ORDER BODY -->

    <div class="order-body">



        <!-- CUSTOMER -->

        <div class="detail-row">


            <span class="detail-label">

                Customer

            </span>


            <span class="detail-value customer-name">

                <%= customerName %>

            </span>


        </div>



        <!-- CUSTOMER ID -->

        <div class="detail-row">


            <span class="detail-label">

                Customer ID

            </span>


            <span class="detail-value">

                <%= order.getUserId() %>

            </span>


        </div>



        <!-- RESTAURANT -->

        <div class="detail-row">


            <span class="detail-label">

                Restaurant

            </span>


            <span class="detail-value restaurant-name">

                <%= restaurantName %>

            </span>


        </div>



        <!-- RESTAURANT ID -->

        <div class="detail-row">


            <span class="detail-label">

                Restaurant ID

            </span>


            <span class="detail-value">

                <%= order.getRestaurantId() %>

            </span>


        </div>



        <!-- DATE -->

        <div class="detail-row">


            <span class="detail-label">

                Order Date

            </span>


            <span class="detail-value">

                <%= order.getOrderDate() %>

            </span>


        </div>



        <!-- PAYMENT -->

        <div class="detail-row">


            <span class="detail-label">

                Payment

            </span>


            <span class="detail-value">

                <%= order.getPaymentMode() %>

            </span>


        </div>



        <!-- TOTAL -->

        <div class="detail-row">


            <span class="detail-label">

                Total Amount

            </span>


            <span class="detail-value amount">

                ₹<%= String.format(
                        "%.2f",
                        order.getTotalAmount()
                ) %>

            </span>


        </div>



        <!-- STATUS -->

        <div class="detail-row">


            <span class="detail-label">

                Current Status

            </span>


            <span class="detail-value">

                <%= order.getStatus() %>

            </span>


        </div>


    </div>



    <!-- READ ONLY INFO -->

    <div class="status-note">

        Order status is managed automatically
        by Foodcorner. Admin access to this
        order is view-only.

    </div>


</div>


<%

    }

%>


</div>


<%

} else {

%>



<!-- ================================= -->
<!-- EMPTY -->
<!-- ================================= -->

<div class="empty-state">


    <div class="empty-icon">

        📦

    </div>


    <h2>

        No Orders Found

    </h2>


    <p>

        Customer orders will appear here
        after an order is placed.

    </p>


</div>


<%

}

%>


</main>



<!-- ================================= -->
<!-- FOOTER -->
<!-- ================================= -->

<footer>

    © 2026

    <span>

        Foodcorner

    </span>

    Admin Panel

</footer>


</body>

</html>