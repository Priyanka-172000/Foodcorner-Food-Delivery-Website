<%@ page language="java"
    contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<%@ page import="java.util.List" %>
<%@ page import="java.util.Map" %>
<%@ page import="com.tap.model.Order" %>
<%@ page import="com.tap.model.User" %>

<!DOCTYPE html>
<html>

<head>

<meta charset="UTF-8">

<meta name="viewport"
      content="width=device-width, initial-scale=1.0">

<title>Foodcorner | My Orders</title>

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

    position: sticky;

    top: 0;

    z-index: 100;
}

.logo {
    font-size: 28px;

    font-weight: bold;

    color: #ff5200;
}

.logo span {
    color: #222;
}

.nav-links {
    display: flex;

    gap: 20px;

    align-items: center;
}

.nav-links a {
    text-decoration: none;

    color: #ff5200;

    font-weight: bold;

    font-size: 14px;
}

.nav-links a:hover {
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


/* CONTAINER */

.container {
    width: 86%;

    margin: 40px auto;
}


/* ORDER CARD */

.order-card {
    background: white;

    border-radius: 16px;

    border: 1px solid #eeeeee;

    margin-bottom: 22px;

    overflow: hidden;

    transition: 0.3s;
}

.order-card:hover {
    transform: translateY(-3px);

    box-shadow:
        0 10px 25px rgba(0,0,0,0.10);
}


/* ORDER HEADER */

.order-header {
    background: #fff8f4;

    padding: 18px 22px;

    display: flex;

    justify-content: space-between;

    align-items: center;

    gap: 15px;
}

.order-id {
    font-size: 18px;

    font-weight: bold;
}

.order-id span {
    color: #ff5200;
}


/* STATUS */

.status {
    padding: 7px 12px;

    border-radius: 20px;

    font-size: 12px;

    font-weight: bold;

    text-transform: uppercase;
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


/* ORDER BODY */

.order-body {
    padding: 22px;

    display: grid;

    grid-template-columns:
        repeat(2, minmax(0, 1fr));

    gap: 20px 30px;
}


/* DETAILS */

.detail {
    display: flex;

    flex-direction: column;

    gap: 6px;
}

.detail-label {
    font-size: 13px;

    color: #777;
}

.detail-value {
    font-size: 15px;

    font-weight: bold;

    color: #222;
}

.restaurant-name {
    color: #333;

    font-size: 16px;
}

.amount {
    color: #ff5200;

    font-size: 18px;
}


/* ACTION BUTTONS */

.order-actions {
    padding:
        0 22px 22px 22px;

    display: flex;

    align-items: center;

    gap: 12px;

    flex-wrap: wrap;
}


/* VIEW DETAILS */

.view-btn {
    display: inline-block;

    padding: 10px 16px;

    background: #ff5200;

    color: white;

    text-decoration: none;

    border-radius: 8px;

    font-size: 14px;

    font-weight: bold;

    transition: 0.2s;
}

.view-btn:hover {
    background: #e94a00;
}


/* CANCEL FORM */

.cancel-form {
    margin: 0;
}


/* CANCEL BUTTON */

.cancel-btn {
    border: 1px solid #d32f2f;

    background: white;

    color: #d32f2f;

    padding: 9px 16px;

    border-radius: 8px;

    font-size: 14px;

    font-weight: bold;

    cursor: pointer;

    transition: 0.2s;
}

.cancel-btn:hover {
    background: #d32f2f;

    color: white;
}


/* EMPTY */

.empty-orders {
    background: white;

    padding: 70px 20px;

    border-radius: 16px;

    border: 1px solid #eeeeee;

    text-align: center;
}

.empty-orders h2 {
    margin-bottom: 10px;

    font-size: 26px;
}

.empty-orders p {
    color: #777;

    margin-bottom: 25px;
}

.restaurant-btn {
    display: inline-block;

    text-decoration: none;

    background: #ff5200;

    color: white;

    padding: 12px 22px;

    border-radius: 9px;

    font-weight: bold;
}

.restaurant-btn:hover {
    background: #e94a00;
}


/* FOOTER */

footer {
    margin-top: 60px;

    padding: 28px;

    background: #181818;

    color: #cccccc;

    text-align: center;
}

footer span {
    color: #ff5200;
}


/* RESPONSIVE */

@media(max-width:700px) {

    .container {
        width: 92%;
    }

    .hero h1 {
        font-size: 30px;
    }

    .order-body {
        grid-template-columns: 1fr;
    }

    .order-header {
        flex-direction: column;

        align-items: flex-start;
    }

    .nav-links {
        gap: 12px;
    }

}

</style>

</head>


<body>


<%

List<Order> orders =
        (List<Order>) request.getAttribute("orders");


User user =
        (User) request.getAttribute("user");


Map<Integer, String> restaurantNames =
        (Map<Integer, String>)
        request.getAttribute("restaurantNames");

%>



<!-- NAVBAR -->

<nav class="navbar">

    <div class="logo">

        Food<span>corner</span>

    </div>


    <div class="nav-links">


        <a
            href="<%= request.getContextPath() %>/restaurant">

            Restaurants

        </a>


        <a
            href="<%= request.getContextPath() %>/cart">

            Cart

        </a>


        <a
            href="<%= request.getContextPath() %>/logout">

            Logout

        </a>


    </div>

</nav>



<!-- HERO -->

<section class="hero">


    <h1>

        My
        <span>Orders</span>

    </h1>


<%

if (user != null) {

%>


    <p>

        Hello <%= user.getUsername() %>,
        here are your previous orders.

    </p>


<%

} else {

%>


    <p>

        View your previous Foodcorner orders.

    </p>


<%

}

%>


</section>



<!-- ORDERS -->

<div class="container">


<%

if (orders != null &&
    !orders.isEmpty()) {


    for (Order order : orders) {


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


        String restaurantName =
                "Restaurant";


        if (restaurantNames != null) {


            String name =
                    restaurantNames.get(
                            order.getRestaurantId()
                    );


            if (name != null) {

                restaurantName =
                        name;
            }

        }

%>



    <div class="order-card">


        <!-- ORDER HEADER -->

        <div class="order-header">


            <div class="order-id">

                Order

                <span>

                    #<%= order.getOrderId() %>

                </span>

            </div>


            <div class="status <%= statusClass %>">

                <%= order.getStatus() %>

            </div>


        </div>



        <!-- ORDER BODY -->

        <div class="order-body">


            <!-- RESTAURANT -->

            <div class="detail">


                <span class="detail-label">

                    Restaurant

                </span>


                <span class="detail-value restaurant-name">

                    <%= restaurantName %>

                </span>


            </div>



            <!-- ORDER DATE -->

            <div class="detail">


                <span class="detail-label">

                    Order Date

                </span>


                <span class="detail-value">

                    <%= order.getOrderDate() %>

                </span>


            </div>



            <!-- PAYMENT -->

            <div class="detail">


                <span class="detail-label">

                    Payment Method

                </span>


                <span class="detail-value">

                    <%= order.getPaymentMode() %>

                </span>


            </div>



            <!-- TOTAL -->

            <div class="detail">


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


        </div>



        <!-- ACTIONS -->

        <div class="order-actions">


            <!-- VIEW DETAILS -->

            <a
                class="view-btn"

                href="<%= request.getContextPath() %>/orderDetails?orderId=<%= order.getOrderId() %>">

                View Details →

            </a>



            <!-- CANCEL ONLY PENDING -->

<%

        if ("PENDING".equalsIgnoreCase(
                order.getStatus())) {

%>


            <form
                class="cancel-form"

                action="<%= request.getContextPath() %>/cancelOrder"

                method="post"

                onsubmit="return confirm('Are you sure you want to cancel this order?');">


                <input
                    type="hidden"

                    name="orderId"

                    value="<%= order.getOrderId() %>">


                <button
                    type="submit"

                    class="cancel-btn">

                    Cancel Order

                </button>


            </form>


<%

        }

%>


        </div>


    </div>


<%

    }

} else {

%>



    <!-- EMPTY -->

    <div class="empty-orders">


        <h2>

            No Orders Yet

        </h2>


        <p>

            You haven't placed any orders yet.
            Start exploring restaurants and order something delicious.

        </p>


        <a
            class="restaurant-btn"

            href="<%= request.getContextPath() %>/restaurant">

            Browse Restaurants

        </a>


    </div>


<%

}

%>


</div>



<!-- FOOTER -->

<footer>

    © 2026
    <span>Foodcorner</span>

</footer>


</body>

</html>