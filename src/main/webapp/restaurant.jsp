<%@ page language="java"
    contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<%@ page import="java.util.List" %>
<%@ page import="com.tap.model.Restaurant" %>
<%@ page import="com.tap.model.User" %>
<%@ page import="com.tap.model.Cart" %>


<%
List<Restaurant> restaurants =
        (List<Restaurant>)
        request.getAttribute("restaurants");


User loggedInUser =
        (User) session.getAttribute("user");


Cart cart =
        (Cart) session.getAttribute("cart");


int cartCount = 0;


if (cart != null) {

    cartCount =
            cart.getTotalQuantity();
}
%>


<!DOCTYPE html>

<html>

<head>

<meta charset="UTF-8">

<meta name="viewport"
      content="width=device-width, initial-scale=1.0">

<title>
    Foodcorner | Restaurants
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
}


/* ================================= */
/* NAVBAR */
/* ================================= */

.navbar {

    background: white;

    padding:
        15px 6%;

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

    font-size: 29px;

    font-weight: bold;

    color: #ff5200;

    text-decoration: none;
}


.logo span {

    color: #222;
}


/* NAV RIGHT */

.nav-right {

    display: flex;

    align-items: center;

    gap: 14px;
}


.nav-link {

    text-decoration: none;

    color: #444;

    font-size: 14px;

    font-weight: bold;

    padding:
        9px 12px;

    border-radius: 8px;

    transition: 0.2s;
}


.nav-link:hover {

    color: #ff5200;

    background: #fff3ed;
}


/* CART */

.cart-link {

    position: relative;

    text-decoration: none;

    color: #333;

    font-size: 14px;

    font-weight: bold;

    padding:
        9px 12px;

    border-radius: 8px;

    transition: 0.2s;
}


.cart-link:hover {

    color: #ff5200;

    background: #fff3ed;
}


.cart-count {

    display: inline-flex;

    justify-content: center;

    align-items: center;

    min-width: 20px;

    height: 20px;

    padding:
        0 5px;

    margin-left: 3px;

    background: #ff5200;

    color: white;

    border-radius: 20px;

    font-size: 10px;

    font-weight: bold;
}


/* ================================= */
/* PROFILE DROPDOWN */
/* ================================= */

.profile-menu {

    position: relative;
}


.profile-btn {

    border: none;

    background: #ff5200;

    color: white;

    padding:
        10px 14px;

    border-radius: 9px;

    font-size: 13px;

    font-weight: bold;

    cursor: pointer;

    display: flex;

    align-items: center;

    gap: 7px;
}


.profile-btn:hover {

    background: #e94a00;
}


.profile-arrow {

    font-size: 9px;
}


.profile-dropdown {

    display: none;

    position: absolute;

    top: 43px;

    right: 0;

    min-width: 200px;

    background: white;

    border:
        1px solid #eeeeee;

    border-radius: 10px;

    box-shadow:
        0 10px 30px
        rgba(0,0,0,0.15);

    overflow: hidden;

    z-index: 2000;
}


.profile-menu:hover
.profile-dropdown {

    display: block;
}


.profile-dropdown a {

    display: block;

    padding:
        12px 16px;

    text-decoration: none;

    color: #333;

    font-size: 13px;

    font-weight: bold;

    transition: 0.2s;
}


.profile-dropdown a:hover {

    background: #fff2eb;

    color: #ff5200;
}


.profile-dropdown
.admin-dashboard-option {

    color: #ff5200;

    border-bottom:
        1px solid #eeeeee;
}


.profile-dropdown
.logout-option {

    color: #d32f2f;

    border-top:
        1px solid #eeeeee;
}


.profile-dropdown
.logout-option:hover {

    background: #fff0f0;

    color: #d32f2f;
}


/* LOGIN */

.login-btn {

    text-decoration: none;

    color: #ff5200;

    font-size: 13px;

    font-weight: bold;

    border:
        1px solid #ff5200;

    padding:
        9px 14px;

    border-radius: 8px;

    transition: 0.2s;
}


.login-btn:hover {

    background: #ff5200;

    color: white;
}


/* REGISTER */

.register-btn {

    text-decoration: none;

    color: white;

    background: #ff5200;

    font-size: 13px;

    font-weight: bold;

    padding:
        10px 15px;

    border-radius: 8px;

    transition: 0.2s;
}


.register-btn:hover {

    background: #e94a00;
}


/* ================================= */
/* HERO */
/* ================================= */

.hero {

    background:
        linear-gradient(
            135deg,
            #fff0e8,
            #fffaf7
        );

    padding:
        55px 7%;
}


.hero-content {

    max-width: 850px;
}


.hero-badge {

    display: inline-block;

    padding:
        7px 12px;

    margin-bottom: 15px;

    background: #ff5200;

    color: white;

    border-radius: 20px;

    font-size: 11px;

    font-weight: bold;
}


.hero h1 {

    font-size: 42px;

    line-height: 1.2;

    margin-bottom: 12px;
}


.hero h1 span {

    color: #ff5200;
}


.hero p {

    color: #666;

    line-height: 1.7;

    font-size: 15px;

    max-width: 650px;
}


/* ================================= */
/* MAIN */
/* ================================= */

.container {

    width: 88%;

    max-width: 1350px;

    margin:
        40px auto
        70px auto;
}


/* ================================= */
/* SECTION HEADER */
/* ================================= */

.section-header {

    display: flex;

    justify-content: space-between;

    align-items: center;

    gap: 20px;

    margin-bottom: 25px;
}


.section-header h2 {

    font-size: 28px;

    margin-bottom: 5px;
}


.section-header p {

    color: #777;

    font-size: 14px;
}


.restaurant-count {

    color: #666;

    font-size: 13px;

    white-space: nowrap;
}


.restaurant-count strong {

    color: #ff5200;

    font-size: 17px;
}


/* ================================= */
/* RESTAURANT GRID */
/* ================================= */

.restaurant-grid {

    display: grid;

    grid-template-columns:
        repeat(
            auto-fit,
            minmax(300px, 1fr)
        );

    gap: 25px;
}


/* ================================= */
/* RESTAURANT CARD */
/* ================================= */

.restaurant-card {

    background: white;

    border:
        1px solid #eeeeee;

    border-radius: 16px;

    overflow: hidden;

    box-shadow:
        0 4px 15px
        rgba(0,0,0,0.05);

    transition:
        transform 0.25s,
        box-shadow 0.25s;
}


.restaurant-card:hover {

    transform:
        translateY(-5px);

    box-shadow:
        0 12px 30px
        rgba(0,0,0,0.11);
}


/* ================================= */
/* RESTAURANT IMAGE */
/* ================================= */

.image-container {

    width: 100%;

    height: 210px;

    position: relative;

    background: #eeeeee;

    overflow: hidden;
}


.restaurant-image {

    width: 100%;

    height: 100%;

    object-fit: cover;

    display: block;
}


.image-placeholder {

    width: 100%;

    height: 100%;

    display: flex;

    flex-direction: column;

    justify-content: center;

    align-items: center;

    background:
        linear-gradient(
            135deg,
            #fff1e9,
            #eeeeee
        );

    color: #888;

    gap: 8px;
}


.placeholder-icon {

    font-size: 45px;
}


/* STATUS */

.open-status {

    position: absolute;

    top: 12px;

    left: 12px;

    padding:
        7px 11px;

    border-radius: 20px;

    font-size: 10px;

    font-weight: bold;
}


.status-open {

    background: #dff5e5;

    color: #147a35;
}


.status-closed {

    background: #ffe2e2;

    color: #b42318;
}


/* RATING */

.rating-badge {

    position: absolute;

    top: 12px;

    right: 12px;

    background:
        rgba(0,0,0,0.78);

    color: white;

    padding:
        7px 10px;

    border-radius: 7px;

    font-size: 12px;

    font-weight: bold;
}


/* ================================= */
/* CARD CONTENT */
/* ================================= */

.card-body {

    padding: 20px;
}


.restaurant-name {

    font-size: 21px;

    font-weight: bold;

    margin-bottom: 7px;
}


.cuisine {

    color: #ff5200;

    font-size: 13px;

    font-weight: bold;

    margin-bottom: 13px;
}


.restaurant-details {

    display: flex;

    flex-direction: column;

    gap: 9px;

    margin-bottom: 18px;
}


.detail {

    display: flex;

    align-items: flex-start;

    gap: 8px;

    color: #666;

    font-size: 13px;

    line-height: 1.5;
}


.detail-icon {

    min-width: 18px;
}


/* ================================= */
/* VIEW MENU BUTTON */
/* ================================= */

.view-menu-btn {

    display: block;

    width: 100%;

    text-align: center;

    text-decoration: none;

    background: #ff5200;

    color: white;

    padding:
        12px 15px;

    border-radius: 9px;

    font-size: 14px;

    font-weight: bold;

    transition: 0.2s;
}


.view-menu-btn:hover {

    background: #e94a00;
}


.closed-btn {

    display: block;

    width: 100%;

    text-align: center;

    padding:
        12px 15px;

    border-radius: 9px;

    font-size: 14px;

    font-weight: bold;

    background: #eeeeee;

    color: #999;

    cursor: not-allowed;
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
        80px 30px;

    text-align: center;
}


.empty-icon {

    font-size: 60px;

    margin-bottom: 15px;
}


.empty-state h2 {

    margin-bottom: 9px;
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

    padding: 28px;

    font-size: 13px;
}


footer span {

    color: #ff5200;
}


/* ================================= */
/* RESPONSIVE */
/* ================================= */

@media(max-width: 850px) {

    .hero h1 {

        font-size: 34px;
    }


    .section-header {

        flex-direction: column;

        align-items: flex-start;
    }

}


@media(max-width: 700px) {

    .navbar {

        padding:
            13px 4%;
    }


    .logo {

        font-size: 23px;
    }


    .nav-right {

        gap: 5px;
    }


    .nav-link {

        display: none;
    }


    .login-btn {

        padding:
            8px 10px;
    }


    .register-btn {

        padding:
            9px 10px;
    }


    .profile-btn {

        padding:
            9px 10px;

        max-width: 150px;

        overflow: hidden;

        white-space: nowrap;
    }


    .hero {

        padding:
            40px 5%;
    }


    .hero h1 {

        font-size: 30px;
    }


    .container {

        width: 92%;
    }


    .restaurant-grid {

        grid-template-columns: 1fr;
    }

}

</style>

</head>


<body>


<!-- ================================= -->
<!-- NAVBAR -->
<!-- ================================= -->

<nav class="navbar">


    <a
        href="<%= request.getContextPath() %>/restaurant"

        class="logo">

        Food<span>corner</span>

    </a>



    <div class="nav-right">


        <!-- HOME / RESTAURANTS -->

        <a
            href="<%= request.getContextPath() %>/restaurant"

            class="nav-link">

            Restaurants

        </a>



        <!-- CART -->

        <a
            href="<%= request.getContextPath() %>/cart"

            class="cart-link">

            🛒 Cart


            <%
            if (cartCount > 0) {
            %>


            <span class="cart-count">

                <%= cartCount %>

            </span>


            <%
            }
            %>


        </a>



        <!-- ================================= -->
        <!-- LOGGED-IN USER -->
        <!-- ================================= -->

        <%

        if (loggedInUser != null) {

        %>


        <div class="profile-menu">


            <button
                type="button"

                class="profile-btn">

                👤
                <%= loggedInUser.getUsername() %>

                <span class="profile-arrow">

                    ▼

                </span>

            </button>



            <div class="profile-dropdown">



                <!-- ADMIN ONLY -->

                <%

                if (loggedInUser.getRole() != null &&
                    "ADMIN".equalsIgnoreCase(
                            loggedInUser.getRole())) {

                %>


                <a
                    href="<%= request.getContextPath() %>/adminDashboard"

                    class="admin-dashboard-option">

                    ⚙ Admin Dashboard

                </a>


                <%

                }

                %>



                <!-- MY ORDERS -->

                <a
                    href="<%= request.getContextPath() %>/myOrders">

                    📦 My Orders

                </a>



                <!-- EDIT PROFILE -->

                <a
                    href="<%= request.getContextPath() %>/editProfile">

                    👤 Edit Profile

                </a>



                <!-- LOGOUT -->

                <a
                    href="<%= request.getContextPath() %>/logout"

                    class="logout-option">

                    Logout

                </a>


            </div>


        </div>


        <%

        } else {

        %>



        <!-- ================================= -->
        <!-- NOT LOGGED IN -->
        <!-- ================================= -->

        <a
            href="<%= request.getContextPath() %>/login.jsp"

            class="login-btn">

            Login

        </a>


        <a
            href="<%= request.getContextPath() %>/register.jsp"

            class="register-btn">

            Register

        </a>


        <%

        }

        %>


    </div>


</nav>



<!-- ================================= -->
<!-- HERO -->
<!-- ================================= -->

<section class="hero">


    <div class="hero-content">


        <div class="hero-badge">

            FOODCORNER

        </div>


        <%

        if (loggedInUser != null) {

        %>


        <h1>

            Hello,

            <span>

                <%= loggedInUser.getUsername() %>

            </span>

            👋

        </h1>


        <p>

            Discover your favourite restaurants,
            explore delicious menus and order
            food directly from Foodcorner.

        </p>


        <%

        } else {

        %>


        <h1>

            Delicious food,

            <span>

                delivered to you.

            </span>

        </h1>


        <p>

            Browse restaurants, discover your
            favourite meals and enjoy a simple
            Foodcorner ordering experience.

        </p>


        <%

        }

        %>


    </div>


</section>



<!-- ================================= -->
<!-- RESTAURANTS -->
<!-- ================================= -->

<main class="container">


    <div class="section-header">


        <div>


            <h2>

                Popular Restaurants

            </h2>


            <p>

                Choose a restaurant and explore
                its menu.

            </p>


        </div>


        <div class="restaurant-count">

            Restaurants:

            <strong>

                <%= restaurants != null
                        ? restaurants.size()
                        : 0 %>

            </strong>

        </div>


    </div>



<%

if (restaurants != null &&
    !restaurants.isEmpty()) {

%>


<div class="restaurant-grid">


<%

    for (Restaurant restaurant :
            restaurants) {


        String imagePath =
                restaurant.getImagePath();


        String imageUrl = null;


        if (imagePath != null &&
            !imagePath.trim().isEmpty()) {


            if (
                imagePath.startsWith("http://")
                ||
                imagePath.startsWith("https://")
            ) {

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
<!-- RESTAURANT CARD -->
<!-- ================================= -->

<div class="restaurant-card">



    <!-- IMAGE -->

    <div class="image-container">


        <%

        if (imageUrl != null) {

        %>


        <img
            src="<%= imageUrl %>"

            alt="<%= restaurant.getName() %>"

            class="restaurant-image"

            onerror="
                this.style.display='none';
                this.nextElementSibling.style.display='flex';
            ">


        <div
            class="image-placeholder"

            style="display:none;">


            <div class="placeholder-icon">

                🍽️

            </div>


            <div>

                Image not available

            </div>


        </div>


        <%

        } else {

        %>


        <div class="image-placeholder">


            <div class="placeholder-icon">

                🍽️

            </div>


            <div>

                Restaurant Image

            </div>


        </div>


        <%

        }

        %>



        <!-- OPEN / CLOSED -->

        <span
            class="open-status
            <%= restaurant.isActive()
                    ? "status-open"
                    : "status-closed" %>">


            <%= restaurant.isActive()
                    ? "OPEN"
                    : "CLOSED" %>


        </span>



        <!-- RATING -->

        <span class="rating-badge">

            ⭐ <%= restaurant.getRating() %>

        </span>


    </div>



    <!-- CARD BODY -->

    <div class="card-body">



        <!-- NAME -->

        <div class="restaurant-name">

            <%= restaurant.getName() %>

        </div>



        <!-- CUISINE -->

        <div class="cuisine">

            <%= restaurant.getCuisineType() %>

        </div>



        <!-- DETAILS -->

        <div class="restaurant-details">



            <!-- DELIVERY -->

            <div class="detail">


                <span class="detail-icon">

                    🕒

                </span>


                <span>

                    Delivery:
                    <%= restaurant.getDeliveryTime() %>

                </span>


            </div>



            <!-- ADDRESS -->

            <div class="detail">


                <span class="detail-icon">

                    📍

                </span>


                <span>

                    <%= restaurant.getAddress() %>

                </span>


            </div>


        </div>



        <!-- VIEW MENU -->

        <%

        if (restaurant.isActive()) {

        %>


        <a
            href="<%= request.getContextPath() %>/menu?restaurantId=<%= restaurant.getRestaurantId() %>"

            class="view-menu-btn">

            View Menu →

        </a>


        <%

        } else {

        %>


        <div class="closed-btn">

            Restaurant Currently Closed

        </div>


        <%

        }

        %>


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
<!-- EMPTY STATE -->
<!-- ================================= -->

<div class="empty-state">


    <div class="empty-icon">

        🍽️

    </div>


    <h2>

        No Restaurants Available

    </h2>


    <p>

        Restaurants will appear here
        when they are added to Foodcorner.

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

    — Food Delivery Website

</footer>


</body>

</html>