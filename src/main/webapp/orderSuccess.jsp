<%@ page language="java"
    contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<!DOCTYPE html>
<html>

<head>

<meta charset="UTF-8">

<meta name="viewport"
      content="width=device-width, initial-scale=1.0">

<title>Foodcorner | Order Success</title>

<style>

* {
    margin: 0;
    padding: 0;
    box-sizing: border-box;
}

body {
    font-family: Arial, Helvetica, sans-serif;

    background:
        linear-gradient(
            135deg,
            #fff1e9,
            #fff8f4
        );

    min-height: 100vh;

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


/* MAIN */

.success-wrapper {
    min-height:
        calc(100vh - 75px);

    display: flex;

    justify-content: center;

    align-items: center;

    padding: 40px 20px;
}


/* CARD */

.success-card {
    width: 100%;

    max-width: 520px;

    background: white;

    border-radius: 20px;

    padding: 38px;

    text-align: center;

    border:
        1px solid #eeeeee;

    box-shadow:
        0 12px 35px
        rgba(0,0,0,0.10);
}


/* SUCCESS ICON */

.success-icon {
    width: 85px;

    height: 85px;

    margin:
        0 auto 20px;

    border-radius: 50%;

    background: #e7f8ec;

    color: #16883e;

    display: flex;

    justify-content: center;

    align-items: center;

    font-size: 42px;

    font-weight: bold;
}


/* TITLE */

.success-card h1 {
    font-size: 30px;

    margin-bottom: 10px;
}

.success-card h1 span {
    color: #ff5200;
}

.success-message {
    color: #666;

    font-size: 15px;

    line-height: 1.6;

    margin-bottom: 28px;
}


/* DETAILS */

.order-details {
    background: #fafafa;

    border-radius: 14px;

    padding: 20px;

    text-align: left;

    margin-bottom: 25px;

    border:
        1px solid #eeeeee;
}

.detail-row {
    display: flex;

    justify-content: space-between;

    gap: 20px;

    padding: 11px 0;

    border-bottom:
        1px solid #eeeeee;
}

.detail-row:last-child {
    border-bottom: none;
}

.detail-label {
    color: #666;

    font-size: 14px;
}

.detail-value {
    color: #222;

    font-size: 14px;

    font-weight: bold;

    text-align: right;
}

.total-value {
    color: #ff5200;

    font-size: 18px;
}


/* BUTTON */

.home-btn {
    display: block;

    width: 100%;

    padding: 13px;

    background: #ff5200;

    color: white;

    text-decoration: none;

    border-radius: 9px;

    font-weight: bold;

    font-size: 15px;

    transition: 0.2s;
}

.home-btn:hover {
    background: #e94a00;
}


/* SECOND BUTTON */

.order-btn {
    display: block;

    width: 100%;

    padding: 12px;

    margin-top: 10px;

    background: white;

    color: #ff5200;

    text-decoration: none;

    border:
        1px solid #ff5200;

    border-radius: 9px;

    font-weight: bold;

    font-size: 15px;
}

.order-btn:hover {
    background: #fff4ee;
}


/* MOBILE */

@media(max-width:600px) {

    .success-card {
        padding: 28px 20px;
    }

    .success-card h1 {
        font-size: 26px;
    }

}

</style>

</head>


<body>


<%

Integer orderId =
        (Integer) session.getAttribute(
                "lastOrderId"
        );


Double orderTotal =
        (Double) session.getAttribute(
                "lastOrderTotal"
        );


String paymentMode =
        (String) session.getAttribute(
                "lastPaymentMode"
        );


String deliveryAddress =
        (String) session.getAttribute(
                "lastDeliveryAddress"
        );


if (orderId == null) {

    response.sendRedirect(
            request.getContextPath()
            + "/restaurant"
    );

    return;
}

%>



<!-- NAVBAR -->

<nav class="navbar">

    <div class="logo">

        Food<span>corner</span>

    </div>

</nav>



<!-- SUCCESS -->

<div class="success-wrapper">


    <div class="success-card">


        <div class="success-icon">

            ✓

        </div>


        <h1>

            Order
            <span>Placed!</span>

        </h1>


        <div class="success-message">

            Your order has been placed successfully.
            Thank you for ordering with Foodcorner.

        </div>



        <!-- ORDER DETAILS -->

        <div class="order-details">


            <div class="detail-row">

                <span class="detail-label">

                    Order ID

                </span>

                <span class="detail-value">

                    #<%= orderId %>

                </span>

            </div>



            <div class="detail-row">

                <span class="detail-label">

                    Payment Method

                </span>

                <span class="detail-value">

                    <%= paymentMode %>

                </span>

            </div>



            <div class="detail-row">

                <span class="detail-label">

                    Delivery Address

                </span>

                <span class="detail-value">

                    <%= deliveryAddress %>

                </span>

            </div>



            <div class="detail-row">

                <span class="detail-label">

                    Total Amount

                </span>

                <span class="detail-value total-value">

                    ₹<%= String.format(
                            "%.2f",
                            orderTotal
                    ) %>

                </span>

            </div>


        </div>



        <!-- RESTAURANTS -->

        <a
            class="home-btn"

            href="<%= request.getContextPath() %>/restaurant">

            Continue Ordering

        </a>


    </div>


</div>


</body>

</html>