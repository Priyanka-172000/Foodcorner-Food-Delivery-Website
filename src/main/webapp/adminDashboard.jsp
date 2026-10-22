<%@ page language="java"
    contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

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
    !"ADMIN".equalsIgnoreCase(admin.getRole())) {

    response.sendRedirect(
        request.getContextPath()
        + "/login.jsp"
    );

    return;
}
%>

<!DOCTYPE html>

<html>

<head>

<meta charset="UTF-8">

<meta name="viewport"
      content="width=device-width, initial-scale=1.0">

<title>Foodcorner | Admin Dashboard</title>


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


/* ============================= */
/* NAVBAR */
/* ============================= */

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

    z-index: 100;
}


.logo {

    font-size: 29px;

    font-weight: bold;

    color: #ff5200;
}


.logo span {

    color: #222;
}


.nav-right {

    display: flex;

    align-items: center;

    gap: 16px;
}


.admin-name {

    font-size: 14px;

    font-weight: bold;

    color: #444;
}


.website-link {

    text-decoration: none;

    color: #ff5200;

    border:
        1px solid #ff5200;

    padding:
        9px 15px;

    border-radius: 8px;

    font-size: 13px;

    font-weight: bold;

    transition: 0.2s;
}


.website-link:hover {

    background: #ff5200;

    color: white;
}


.logout-link {

    text-decoration: none;

    background: #222;

    color: white;

    padding:
        10px 16px;

    border-radius: 8px;

    font-size: 13px;

    font-weight: bold;

    transition: 0.2s;
}


.logout-link:hover {

    background: #000;
}


/* ============================= */
/* HERO */
/* ============================= */

.hero {

    padding:
        48px 7%;

    background:
        linear-gradient(
            135deg,
            #fff0e8,
            #fff9f6
        );
}


.hero-content {

    max-width: 900px;
}


.admin-badge {

    display: inline-block;

    background: #ff5200;

    color: white;

    font-size: 12px;

    font-weight: bold;

    padding:
        7px 12px;

    border-radius: 20px;

    margin-bottom: 15px;
}


.hero h1 {

    font-size: 38px;

    margin-bottom: 10px;
}


.hero h1 span {

    color: #ff5200;
}


.hero p {

    color: #666;

    line-height: 1.7;

    font-size: 15px;
}


/* ============================= */
/* DASHBOARD */
/* ============================= */

.dashboard-container {

    width: 86%;

    max-width: 1200px;

    margin:
        42px auto
        70px auto;
}


.section-title {

    margin-bottom: 25px;
}


.section-title h2 {

    font-size: 26px;

    margin-bottom: 6px;
}


.section-title p {

    color: #777;

    font-size: 14px;
}


/* ============================= */
/* CARDS */
/* ============================= */

.dashboard-grid {

    display: grid;

    grid-template-columns:
        repeat(
            auto-fit,
            minmax(260px, 1fr)
        );

    gap: 24px;
}


.dashboard-card {

    background: white;

    border-radius: 16px;

    padding: 27px;

    border:
        1px solid #eeeeee;

    box-shadow:
        0 5px 18px
        rgba(0,0,0,0.05);

    transition:
        transform 0.25s,
        box-shadow 0.25s;
}


.dashboard-card:hover {

    transform:
        translateY(-5px);

    box-shadow:
        0 12px 30px
        rgba(0,0,0,0.10);
}


.card-icon {

    width: 55px;

    height: 55px;

    border-radius: 14px;

    background: #fff0e8;

    display: flex;

    justify-content: center;

    align-items: center;

    font-size: 28px;

    margin-bottom: 18px;
}


.dashboard-card h3 {

    font-size: 20px;

    margin-bottom: 9px;
}


.dashboard-card p {

    color: #777;

    font-size: 14px;

    line-height: 1.6;

    min-height: 66px;
}


.card-btn {

    display: inline-block;

    margin-top: 18px;

    background: #ff5200;

    color: white;

    text-decoration: none;

    padding:
        11px 17px;

    border-radius: 8px;

    font-size: 13px;

    font-weight: bold;

    transition: 0.2s;
}


.card-btn:hover {

    background: #e94a00;
}


/* ============================= */
/* WEBSITE CARD */
/* ============================= */

.visit-card {

    border:
        2px solid
        #ff5200;
}


.visit-card .card-icon {

    background: #ff5200;

    color: white;
}


.visit-card .card-btn {

    background: #222;
}


.visit-card .card-btn:hover {

    background: #000;
}


/* ============================= */
/* QUICK INFORMATION */
/* ============================= */

.admin-info {

    margin-top: 40px;

    background: white;

    border-radius: 16px;

    padding: 25px;

    border:
        1px solid #eeeeee;
}


.admin-info h3 {

    margin-bottom: 18px;
}


.info-row {

    display: flex;

    justify-content: space-between;

    align-items: center;

    padding:
        12px 0;

    border-bottom:
        1px solid #eeeeee;

    gap: 20px;
}


.info-row:last-child {

    border-bottom: none;
}


.info-label {

    color: #777;

    font-size: 14px;
}


.info-value {

    font-weight: bold;

    font-size: 14px;

    text-align: right;
}


.role-value {

    color: #ff5200;
}


/* ============================= */
/* FOOTER */
/* ============================= */

footer {

    background: #181818;

    color: #cccccc;

    text-align: center;

    padding: 26px;

    margin-top: 50px;

    font-size: 13px;
}


footer span {

    color: #ff5200;
}


/* ============================= */
/* RESPONSIVE */
/* ============================= */

@media(max-width: 750px) {

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


    .website-link {

        display: none;
    }


    .hero {

        padding:
            35px 6%;
    }


    .hero h1 {

        font-size: 30px;
    }


    .dashboard-container {

        width: 92%;
    }


    .info-row {

        flex-direction: column;

        align-items: flex-start;
    }


    .info-value {

        text-align: left;
    }

}

</style>

</head>



<body>



<!-- ============================= -->
<!-- NAVBAR -->
<!-- ============================= -->

<nav class="navbar">


    <div class="logo">

        Food<span>corner</span>

    </div>


    <div class="nav-right">


        <div class="admin-name">

            👤 <%= admin.getUsername() %>

        </div>


        <a
            href="<%= request.getContextPath() %>/restaurant"

            class="website-link">

            🌐 Visit Website

        </a>


        <a
            href="<%= request.getContextPath() %>/logout"

            class="logout-link">

            Logout

        </a>


    </div>


</nav>



<!-- ============================= -->
<!-- HERO -->
<!-- ============================= -->

<section class="hero">


    <div class="hero-content">


        <div class="admin-badge">

            ADMIN PANEL

        </div>


        <h1>

            Welcome,

            <span>

                <%= admin.getUsername() %>

            </span>

        </h1>


        <p>

            Manage Foodcorner restaurants,
            menu items, customer orders and
            registered customers from your
            admin dashboard.

        </p>


    </div>


</section>



<!-- ============================= -->
<!-- DASHBOARD -->
<!-- ============================= -->

<main class="dashboard-container">


    <div class="section-title">

        <h2>

            Management Dashboard

        </h2>


        <p>

            Select a module to manage your
            Foodcorner application.

        </p>

    </div>



    <div class="dashboard-grid">



        <!-- ============================= -->
        <!-- RESTAURANTS -->
        <!-- ============================= -->

        <div class="dashboard-card">


            <div class="card-icon">

                🍽️

            </div>


            <h3>

                Manage Restaurants

            </h3>


            <p>

                Add new restaurants,
                edit restaurant information,
                manage restaurant images,
                status and other details.

            </p>


            <a
                href="<%= request.getContextPath() %>/adminRestaurants"

                class="card-btn">

                Manage Restaurants →

            </a>


        </div>



        <!-- ============================= -->
        <!-- MENU -->
        <!-- ============================= -->

        <div class="dashboard-card">


            <div class="card-icon">

                📋

            </div>


            <h3>

                Manage Menu

            </h3>


            <p>

                Add menu items,
                edit food details,
                set prices,
                availability and
                menu item image paths.

            </p>


            <a
                href="<%= request.getContextPath() %>/adminMenus"

                class="card-btn">

                Manage Menu →

            </a>


        </div>



        <!-- ============================= -->
        <!-- ORDERS -->
        <!-- ============================= -->

        <div class="dashboard-card">


            <div class="card-icon">

                📦

            </div>


            <h3>

                Manage Orders

            </h3>


           <p>

    View all customer orders,
    payment information,
    order details and the
    current order status.

</p>


            <a
                href="<%= request.getContextPath() %>/adminOrders"

                class="card-btn">

                View Orders →

            </a>


        </div>



        <!-- ============================= -->
        <!-- CUSTOMERS -->
        <!-- ============================= -->

        <div class="dashboard-card">


            <div class="card-icon">

                👥

            </div>


            <h3>

                Manage Customers

            </h3>


            <p>

                View registered customers,
                contact information,
                addresses and customer
                account details.

            </p>


            <a
                href="<%= request.getContextPath() %>/adminCustomers"

                class="card-btn">

                View Customers →

            </a>


        </div>



        <!-- ============================= -->
        <!-- VISIT WEBSITE -->
        <!-- ============================= -->

        <div class="dashboard-card visit-card">


            <div class="card-icon">

                🌐

            </div>


            <h3>

                Visit Website

            </h3>


            <p>

                Browse the normal Foodcorner
                website as an administrator.
                Your admin session will remain
                active while browsing.

            </p>


            <a
                href="<%= request.getContextPath() %>/restaurant"

                class="card-btn">

                Open Website →

            </a>


        </div>



        <!-- ============================= -->
        <!-- PROFILE -->
        <!-- ============================= -->

        <div class="dashboard-card">


            <div class="card-icon">

                👤

            </div>


            <h3>

                My Profile

            </h3>


            <p>

                View or update your admin
                profile information including
                name, phone number,
                address and password.

            </p>


            <a
                href="<%= request.getContextPath() %>/editProfile"

                class="card-btn">

                Edit Profile →

            </a>


        </div>


    </div>



    <!-- ============================= -->
    <!-- ADMIN INFORMATION -->
    <!-- ============================= -->

    <div class="admin-info">


        <h3>

            Admin Information

        </h3>


        <div class="info-row">


            <span class="info-label">

                Name

            </span>


            <span class="info-value">

                <%= admin.getUsername() %>

            </span>


        </div>



        <div class="info-row">


            <span class="info-label">

                Email

            </span>


            <span class="info-value">

                <%= admin.getEmail() %>

            </span>


        </div>



        <div class="info-row">


            <span class="info-label">

                Role

            </span>


            <span class="info-value role-value">

                <%= admin.getRole() %>

            </span>


        </div>


    </div>


</main>



<!-- ============================= -->
<!-- FOOTER -->
<!-- ============================= -->

<footer>

    © 2026

    <span>

        Foodcorner

    </span>

    Admin Panel

</footer>



</body>

</html>