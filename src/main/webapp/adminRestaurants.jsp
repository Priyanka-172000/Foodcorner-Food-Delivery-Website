<%@ page language="java"
    contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<%@ page import="java.util.List" %>
<%@ page import="com.tap.model.Restaurant" %>
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


List<Restaurant> restaurants =
        (List<Restaurant>)
        request.getAttribute("restaurants");


String added =
        request.getParameter("added");

String updated =
        request.getParameter("updated");

String deleted =
        request.getParameter("deleted");

String error =
        request.getParameter("error");
%>

<!DOCTYPE html>

<html>

<head>

<meta charset="UTF-8">

<meta name="viewport"
      content="width=device-width, initial-scale=1.0">

<title>
    Foodcorner | Manage Restaurants
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


/* ============================== */
/* NAVBAR */
/* ============================== */

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

    margin-right: 5px;
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

    border:
        1px solid #ff5200;

    background: white;
}


.dashboard-btn:hover {

    background: #ff5200;

    color: white;
}


.website-btn {

    color: #444;

    border:
        1px solid #dddddd;

    background: white;
}


.website-btn:hover {

    background: #f2f2f2;
}


.logout-btn {

    background: #222;

    color: white;
}


.logout-btn:hover {

    background: #000;
}


/* ============================== */
/* PAGE HEADER */
/* ============================== */

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


.header-container {

    max-width: 1350px;

    margin: auto;

    display: flex;

    justify-content: space-between;

    align-items: center;

    gap: 25px;
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

    max-width: 650px;
}


.add-btn {

    display: inline-block;

    text-decoration: none;

    background: #ff5200;

    color: white;

    padding:
        13px 20px;

    border-radius: 9px;

    font-size: 14px;

    font-weight: bold;

    white-space: nowrap;

    transition: 0.2s;
}


.add-btn:hover {

    background: #e94a00;
}


/* ============================== */
/* MAIN */
/* ============================== */

.container {

    width: 88%;

    max-width: 1350px;

    margin:
        35px auto
        70px auto;
}


/* ============================== */
/* MESSAGE */
/* ============================== */

.message {

    padding:
        13px 16px;

    border-radius: 9px;

    margin-bottom: 22px;

    font-size: 14px;

    font-weight: bold;
}


.success {

    background: #e6f7eb;

    color: #1b7d3e;

    border:
        1px solid #bde8c9;
}


.error {

    background: #ffe7e7;

    color: #b42318;

    border:
        1px solid #ffc9c9;
}


/* ============================== */
/* TOP BAR */
/* ============================== */

.top-bar {

    display: flex;

    justify-content: space-between;

    align-items: center;

    gap: 20px;

    margin-bottom: 22px;
}


.restaurant-count {

    color: #666;

    font-size: 14px;
}


.restaurant-count strong {

    color: #ff5200;

    font-size: 18px;
}


.logged-admin {

    color: #777;

    font-size: 13px;
}


.logged-admin strong {

    color: #333;
}


/* ============================== */
/* GRID */
/* ============================== */

.restaurant-grid {

    display: grid;

    grid-template-columns:
        repeat(
            auto-fit,
            minmax(330px, 1fr)
        );

    gap: 24px;
}


/* ============================== */
/* CARD */
/* ============================== */

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
        translateY(-4px);

    box-shadow:
        0 12px 28px
        rgba(0,0,0,0.10);
}


/* ============================== */
/* IMAGE */
/* ============================== */

.image-container {

    width: 100%;

    height: 215px;

    position: relative;

    overflow: hidden;

    background:
        linear-gradient(
            135deg,
            #eeeeee,
            #dddddd
        );
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

    gap: 8px;

    color: #888;

    font-size: 13px;
}


.placeholder-icon {

    font-size: 42px;
}


.restaurant-number {

    position: absolute;

    top: 12px;

    left: 12px;

    background:
        rgba(0,0,0,0.72);

    color: white;

    border-radius: 6px;

    padding:
        6px 9px;

    font-size: 11px;

    font-weight: bold;
}


/* ============================== */
/* CARD BODY */
/* ============================== */

.card-body {

    padding: 20px;
}


.restaurant-top {

    display: flex;

    justify-content: space-between;

    align-items: flex-start;

    gap: 12px;

    margin-bottom: 15px;
}


.restaurant-name {

    font-size: 20px;

    font-weight: bold;

    line-height: 1.3;
}


.restaurant-id {

    color: #999;

    font-size: 12px;

    margin-top: 5px;
}


/* ============================== */
/* STATUS */
/* ============================== */

.status {

    padding:
        6px 10px;

    border-radius: 20px;

    font-size: 11px;

    font-weight: bold;

    white-space: nowrap;
}


.active {

    background: #dff5e5;

    color: #147a35;
}


.inactive {

    background: #ffe2e2;

    color: #b42318;
}


/* ============================== */
/* DETAILS */
/* ============================== */

.details {

    display: flex;

    flex-direction: column;

    gap: 10px;
}


.detail-row {

    display: flex;

    justify-content: space-between;

    align-items: flex-start;

    gap: 15px;

    padding-bottom: 9px;

    border-bottom:
        1px solid #f1f1f1;
}


.detail-row:last-child {

    border-bottom: none;
}


.detail-label {

    color: #888;

    font-size: 13px;

    min-width: 100px;
}


.detail-value {

    color: #333;

    font-size: 13px;

    font-weight: bold;

    text-align: right;

    word-break: break-word;
}


.rating {

    color: #ff5200;
}


/* ============================== */
/* IMAGE PATH */
/* ============================== */

.image-path-box {

    margin-top: 15px;

    padding: 11px;

    background: #fafafa;

    border:
        1px solid #eeeeee;

    border-radius: 8px;
}


.image-path-label {

    display: block;

    color: #999;

    font-size: 11px;

    margin-bottom: 5px;
}


.image-path-value {

    display: block;

    color: #555;

    font-size: 11px;

    line-height: 1.5;

    word-break: break-all;
}


/* ============================== */
/* ACTIONS */
/* ============================== */

.actions {

    display: flex;

    flex-wrap: wrap;

    gap: 8px;

    margin-top: 20px;

    padding-top: 17px;

    border-top:
        1px solid #eeeeee;
}


.action-form {

    margin: 0;
}


.action-btn {

    display: inline-block;

    text-decoration: none;

    padding:
        9px 12px;

    border-radius: 7px;

    font-size: 12px;

    font-weight: bold;

    cursor: pointer;

    transition: 0.2s;

    font-family:
        Arial,
        Helvetica,
        sans-serif;
}


.edit-btn {

    border: none;

    background: #ff5200;

    color: white;
}


.edit-btn:hover {

    background: #e94a00;
}


.menu-btn {

    border: none;

    background: #222;

    color: white;
}


.menu-btn:hover {

    background: #000;
}


.status-btn {

    background: white;

    color: #555;

    border:
        1px solid #cccccc;
}


.status-btn:hover {

    background: #f2f2f2;
}


.delete-btn {

    background: white;

    color: #d32f2f;

    border:
        1px solid #d32f2f;
}


.delete-btn:hover {

    background: #d32f2f;

    color: white;
}


/* ============================== */
/* EMPTY STATE */
/* ============================== */

.empty-state {

    background: white;

    border:
        1px solid #eeeeee;

    border-radius: 16px;

    padding:
        70px 30px;

    text-align: center;

    box-shadow:
        0 5px 20px
        rgba(0,0,0,0.04);
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

    margin-bottom: 25px;
}


/* ============================== */
/* FOOTER */
/* ============================== */

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


/* ============================== */
/* RESPONSIVE */
/* ============================== */

@media(max-width: 850px) {

    .header-container {

        flex-direction: column;

        align-items: flex-start;
    }


    .top-bar {

        flex-direction: column;

        align-items: flex-start;
    }

}


@media(max-width: 700px) {

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


    .restaurant-grid {

        grid-template-columns: 1fr;
    }


    .detail-row {

        flex-direction: column;

        gap: 4px;
    }


    .detail-value {

        text-align: left;
    }


    .actions {

        flex-direction: column;
    }


    .action-btn,
    .action-form,
    .action-form button {

        width: 100%;

        text-align: center;
    }

}

</style>

</head>


<body>


<!-- ============================== -->
<!-- NAVBAR -->
<!-- ============================== -->

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



<!-- ============================== -->
<!-- PAGE HEADER -->
<!-- ============================== -->

<section class="page-header">


    <div class="header-container">


        <div>


            <h1>

                Manage

                <span>

                    Restaurants

                </span>

            </h1>


            <p>

                Add restaurants, update restaurant
                information, manage images,
                activate or deactivate restaurants
                and manage restaurant menu items.

            </p>


        </div>


        <a
            href="<%= request.getContextPath() %>/addRestaurant"

            class="add-btn">

            + Add Restaurant

        </a>


    </div>


</section>



<!-- ============================== -->
<!-- MAIN -->
<!-- ============================== -->

<main class="container">


<!-- ============================== -->
<!-- SUCCESS / ERROR MESSAGES -->
<!-- ============================== -->

<%

if ("true".equals(added)) {

%>

<div class="message success">

    ✓ Restaurant added successfully.

</div>

<%

}

%>


<%

if ("true".equals(updated)) {

%>

<div class="message success">

    ✓ Restaurant updated successfully.

</div>

<%

}

%>


<%

if ("true".equals(deleted)) {

%>

<div class="message success">

    ✓ Restaurant deleted successfully.

</div>

<%

}

%>


<%

if ("true".equals(error)) {

%>

<div class="message error">

    Something went wrong.
    Please try again.

</div>

<%

}

%>


<%

if ("delete".equals(error)) {

%>

<div class="message error">

    This restaurant cannot be deleted because
    menu items or orders are linked to it.
    Please deactivate the restaurant instead.

</div>

<%

}

%>



<!-- ============================== -->
<!-- TOP BAR -->
<!-- ============================== -->

<div class="top-bar">


    <div class="restaurant-count">

        Total Restaurants:

        <strong>

            <%= restaurants != null
                    ? restaurants.size()
                    : 0 %>

        </strong>

    </div>


    <div class="logged-admin">

        Logged in as

        <strong>

            <%= admin.getUsername() %>

        </strong>

    </div>


</div>



<!-- ============================== -->
<!-- RESTAURANTS -->
<!-- ============================== -->

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



<!-- ============================== -->
<!-- RESTAURANT CARD -->
<!-- ============================== -->

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

                No Restaurant Image

            </div>


        </div>


        <%
        }
        %>


        <div class="restaurant-number">

            #<%= restaurant.getRestaurantId() %>

        </div>


    </div>



    <!-- CARD BODY -->

    <div class="card-body">



        <!-- RESTAURANT TOP -->

        <div class="restaurant-top">


            <div>


                <div class="restaurant-name">

                    <%= restaurant.getName() %>

                </div>


                <div class="restaurant-id">

                    Restaurant ID:

                    <%= restaurant.getRestaurantId() %>

                </div>


            </div>



            <span
                class="status
                <%= restaurant.isActive()
                        ? "active"
                        : "inactive" %>">


                <%= restaurant.isActive()
                        ? "ACTIVE"
                        : "INACTIVE" %>


            </span>


        </div>



        <!-- DETAILS -->

        <div class="details">



            <!-- CUISINE -->

            <div class="detail-row">


                <span class="detail-label">

                    Cuisine

                </span>


                <span class="detail-value">

                    <%= restaurant.getCuisineType() %>

                </span>


            </div>



            <!-- DELIVERY TIME -->

            <div class="detail-row">


                <span class="detail-label">

                    Delivery Time

                </span>


                <span class="detail-value">

                    <%= restaurant.getDeliveryTime() %>

                </span>


            </div>



            <!-- RATING -->

            <div class="detail-row">


                <span class="detail-label">

                    Rating

                </span>


                <span class="detail-value rating">

                    ⭐ <%= restaurant.getRating() %>

                </span>


            </div>



            <!-- ADDRESS -->

            <div class="detail-row">


                <span class="detail-label">

                    Address

                </span>


                <span class="detail-value">

                    <%= restaurant.getAddress() %>

                </span>


            </div>



            <!-- ADMIN -->

            <div class="detail-row">


                <span class="detail-label">

                    Admin ID

                </span>


                <span class="detail-value">

                    <%= restaurant.getAdminUserId() %>

                </span>


            </div>


        </div>



        <!-- IMAGE PATH -->

        <div class="image-path-box">


            <span class="image-path-label">

                Restaurant Image Path

            </span>


            <span class="image-path-value">


                <%

                if (restaurant.getImagePath() == null ||
                    restaurant.getImagePath()
                              .trim()
                              .isEmpty()) {

                %>

                    No image path provided

                <%

                } else {

                %>

                    <%= restaurant.getImagePath() %>

                <%

                }

                %>


            </span>


        </div>



        <!-- ============================== -->
        <!-- ACTIONS -->
        <!-- ============================== -->

        <div class="actions">



            <!-- EDIT RESTAURANT -->

            <a
                href="<%= request.getContextPath() %>/editRestaurant?restaurantId=<%= restaurant.getRestaurantId() %>"

                class="action-btn edit-btn">

                Edit

            </a>



            <!-- MANAGE MENU -->

            <a
                href="<%= request.getContextPath() %>/adminMenus?restaurantId=<%= restaurant.getRestaurantId() %>"

                class="action-btn menu-btn">

                Manage Menu

            </a>



            <!-- ACTIVATE / DEACTIVATE -->

            <form
                action="<%= request.getContextPath() %>/toggleRestaurantStatus"

                method="post"

                class="action-form"

                onsubmit="
                    return confirm(
                        '<%= restaurant.isActive()
                                ? "Are you sure you want to deactivate this restaurant?"
                                : "Are you sure you want to activate this restaurant?" %>'
                    );
                ">


                <input
                    type="hidden"

                    name="restaurantId"

                    value="<%= restaurant.getRestaurantId() %>">


                <button
                    type="submit"

                    class="action-btn status-btn">


                    <%= restaurant.isActive()
                            ? "Deactivate"
                            : "Activate" %>


                </button>


            </form>



            <!-- DELETE RESTAURANT -->

            <form
                action="<%= request.getContextPath() %>/deleteRestaurant"

                method="post"

                class="action-form"

                onsubmit="
                    return confirm(
                        'Are you sure you want to permanently delete this restaurant?'
                    );
                ">


                <input
                    type="hidden"

                    name="restaurantId"

                    value="<%= restaurant.getRestaurantId() %>">


                <button
                    type="submit"

                    class="action-btn delete-btn">

                    Delete

                </button>


            </form>


        </div>


    </div>


</div>


<%

    }

%>


</div>


<%

} else {

%>



<!-- ============================== -->
<!-- EMPTY STATE -->
<!-- ============================== -->

<div class="empty-state">


    <div class="empty-icon">

        🍽️

    </div>


    <h2>

        No Restaurants Found

    </h2>


    <p>

        There are currently no restaurants
        available in Foodcorner.

    </p>


    <a
        href="<%= request.getContextPath() %>/addRestaurant"

        class="add-btn">

        + Add Restaurant

    </a>


</div>


<%

}

%>


</main>



<!-- ============================== -->
<!-- FOOTER -->
<!-- ============================== -->

<footer>

    © 2026

    <span>

        Foodcorner

    </span>

    Admin Panel

</footer>


</body>

</html>