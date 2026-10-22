<%@ page language="java"
    contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<%@ page import="java.util.List" %>
<%@ page import="java.util.Map" %>
<%@ page import="java.util.HashMap" %>

<%@ page import="com.tap.model.Menu" %>
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
    !"ADMIN".equalsIgnoreCase(
            admin.getRole())) {

    response.sendRedirect(
            request.getContextPath()
            + "/login.jsp"
    );

    return;
}


List<Menu> menus =
        (List<Menu>)
        request.getAttribute("menus");


List<Restaurant> restaurants =
        (List<Restaurant>)
        request.getAttribute("restaurants");


Restaurant selectedRestaurant =
        (Restaurant)
        request.getAttribute(
                "selectedRestaurant"
        );


Integer selectedRestaurantId =
        (Integer)
        request.getAttribute(
                "selectedRestaurantId"
        );


Map<Integer, String> restaurantNames =
        new HashMap<>();


if (restaurants != null) {

    for (Restaurant restaurant :
            restaurants) {

        restaurantNames.put(
                restaurant.getRestaurantId(),
                restaurant.getName()
        );
    }
}


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
    Foodcorner | Manage Menu
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


.nav-links {

    display: flex;

    align-items: center;

    gap: 12px;
}


.nav-links a {

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
}


.dashboard-btn:hover {

    background: #ff5200;

    color: white;
}


.restaurant-btn {

    color: #444;

    border:
        1px solid #dddddd;
}


.restaurant-btn:hover {

    background: #f2f2f2;
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


/* ============================= */
/* PAGE HEADER */
/* ============================= */

.page-header {

    background:
        linear-gradient(
            135deg,
            #fff0e8,
            #fff9f6
        );

    padding:
        42px 7%;
}


.header-container {

    max-width: 1350px;

    margin: auto;

    display: flex;

    justify-content: space-between;

    align-items: center;

    gap: 20px;
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

    background: #ff5200;

    color: white;

    padding:
        13px 20px;

    border-radius: 9px;

    text-decoration: none;

    font-size: 14px;

    font-weight: bold;

    white-space: nowrap;

    transition: 0.2s;
}


.add-btn:hover {

    background: #e94a00;
}


/* ============================= */
/* MAIN */
/* ============================= */

.container {

    width: 88%;

    max-width: 1350px;

    margin:
        35px auto
        70px auto;
}


/* ============================= */
/* MESSAGE */
/* ============================= */

.message {

    padding:
        13px 16px;

    border-radius: 9px;

    margin-bottom: 20px;

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


/* ============================= */
/* FILTER */
/* ============================= */

.filter-card {

    background: white;

    padding: 20px;

    border-radius: 14px;

    border:
        1px solid #eeeeee;

    margin-bottom: 25px;

    display: flex;

    justify-content: space-between;

    align-items: center;

    gap: 20px;

    flex-wrap: wrap;
}


.filter-left {

    flex: 1;

    min-width: 250px;
}


.filter-left h3 {

    margin-bottom: 6px;

    font-size: 18px;
}


.filter-left p {

    color: #777;

    font-size: 13px;

    line-height: 1.5;
}


.filter-form {

    display: flex;

    align-items: center;

    gap: 10px;

    flex-wrap: wrap;
}


.filter-select {

    min-width: 230px;

    padding:
        11px 12px;

    border:
        1px solid #dddddd;

    border-radius: 8px;

    outline: none;

    background: white;

    font-size: 13px;
}


.filter-select:focus {

    border-color: #ff5200;
}


.filter-btn {

    border: none;

    background: #222;

    color: white;

    padding:
        11px 17px;

    border-radius: 8px;

    font-size: 13px;

    font-weight: bold;

    cursor: pointer;
}


.filter-btn:hover {

    background: #000;
}


.clear-btn {

    text-decoration: none;

    border:
        1px solid #dddddd;

    color: #555;

    padding:
        10px 15px;

    border-radius: 8px;

    font-size: 13px;

    font-weight: bold;
}


.clear-btn:hover {

    background: #f5f5f5;
}


/* ============================= */
/* SELECTED RESTAURANT */
/* ============================= */

.selected-info {

    background: #fff6f0;

    border:
        1px solid #ffd9c7;

    padding:
        15px 18px;

    border-radius: 10px;

    margin-bottom: 22px;

    font-size: 14px;

    color: #555;
}


.selected-info strong {

    color: #ff5200;
}


/* ============================= */
/* TOP BAR */
/* ============================= */

.top-bar {

    display: flex;

    justify-content: space-between;

    align-items: center;

    gap: 20px;

    margin-bottom: 20px;
}


.item-count {

    color: #666;

    font-size: 14px;
}


.item-count strong {

    color: #ff5200;

    font-size: 18px;
}


.admin-info {

    color: #777;

    font-size: 13px;
}


.admin-info strong {

    color: #333;
}


/* ============================= */
/* MENU GRID */
/* ============================= */

.menu-grid {

    display: grid;

    grid-template-columns:
        repeat(
            auto-fit,
            minmax(300px, 1fr)
        );

    gap: 24px;
}


/* ============================= */
/* MENU CARD */
/* ============================= */

.menu-card {

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


.menu-card:hover {

    transform:
        translateY(-4px);

    box-shadow:
        0 12px 28px
        rgba(0,0,0,0.10);
}


/* ============================= */
/* IMAGE */
/* ============================= */

.image-container {

    width: 100%;

    height: 205px;

    position: relative;

    background: #eeeeee;

    overflow: hidden;
}


.menu-image {

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

    font-size: 45px;
}


.menu-id {

    position: absolute;

    top: 12px;

    left: 12px;

    padding:
        6px 9px;

    border-radius: 6px;

    background:
        rgba(0,0,0,0.72);

    color: white;

    font-size: 11px;

    font-weight: bold;
}


.availability {

    position: absolute;

    top: 12px;

    right: 12px;

    padding:
        6px 10px;

    border-radius: 20px;

    font-size: 11px;

    font-weight: bold;
}


.available {

    background: #dff5e5;

    color: #147a35;
}


.unavailable {

    background: #ffe2e2;

    color: #b42318;
}


/* ============================= */
/* CARD BODY */
/* ============================= */

.card-body {

    padding: 20px;
}


.item-name {

    font-size: 21px;

    font-weight: bold;

    margin-bottom: 6px;

    line-height: 1.3;
}


.restaurant-name {

    color: #ff5200;

    font-size: 13px;

    font-weight: bold;

    margin-bottom: 14px;
}


.description {

    color: #666;

    font-size: 13px;

    line-height: 1.6;

    min-height: 42px;

    margin-bottom: 15px;
}


.price-row {

    display: flex;

    align-items: center;

    justify-content: space-between;

    border-top:
        1px solid #eeeeee;

    border-bottom:
        1px solid #eeeeee;

    padding:
        13px 0;

    margin-bottom: 13px;
}


.price-label {

    color: #888;

    font-size: 12px;
}


.price {

    color: #ff5200;

    font-size: 20px;

    font-weight: bold;
}


/* ============================= */
/* IMAGE PATH */
/* ============================= */

.image-path {

    background: #fafafa;

    border:
        1px solid #eeeeee;

    border-radius: 8px;

    padding: 10px;

    margin-bottom: 16px;
}


.image-path-label {

    color: #999;

    font-size: 11px;

    display: block;

    margin-bottom: 5px;
}


.image-path-value {

    color: #555;

    font-size: 11px;

    line-height: 1.5;

    word-break: break-all;

    display: block;
}


/* ============================= */
/* ACTIONS */
/* ============================= */

.actions {

    display: flex;

    gap: 8px;

    flex-wrap: wrap;

    padding-top: 16px;

    border-top:
        1px solid #eeeeee;
}


.action-form {

    margin: 0;
}


.action-btn {

    display: inline-block;

    padding:
        9px 12px;

    border-radius: 7px;

    font-size: 12px;

    font-weight: bold;

    cursor: pointer;

    text-decoration: none;

    font-family:
        Arial,
        Helvetica,
        sans-serif;

    transition: 0.2s;
}


.edit-btn {

    background: #ff5200;

    color: white;

    border: none;
}


.edit-btn:hover {

    background: #e94a00;
}


.availability-btn {

    background: white;

    color: #555;

    border:
        1px solid #cccccc;
}


.availability-btn:hover {

    background: #f3f3f3;
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


/* ============================= */
/* EMPTY */
/* ============================= */

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

    margin-bottom: 25px;
}


/* ============================= */
/* FOOTER */
/* ============================= */

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


/* ============================= */
/* RESPONSIVE */
/* ============================= */

@media(max-width: 800px) {

    .header-container {

        flex-direction: column;

        align-items: flex-start;
    }


    .filter-card {

        flex-direction: column;

        align-items: flex-start;
    }


    .filter-form {

        width: 100%;
    }


    .filter-select {

        flex: 1;
    }


    .top-bar {

        flex-direction: column;

        align-items: flex-start;
    }

}


@media(max-width: 650px) {

    .navbar {

        padding:
            14px 4%;
    }


    .logo {

        font-size: 22px;
    }


    .website-btn,
    .restaurant-btn {

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


    .menu-grid {

        grid-template-columns: 1fr;
    }


    .filter-form {

        flex-direction: column;

        align-items: stretch;
    }


    .filter-select {

        width: 100%;
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


<!-- ============================= -->
<!-- NAVBAR -->
<!-- ============================= -->

<nav class="navbar">


    <div class="logo">

        Food<span>corner</span>

    </div>


    <div class="nav-links">


        <a
            href="<%= request.getContextPath() %>/adminDashboard"

            class="dashboard-btn">

            Dashboard

        </a>


        <a
            href="<%= request.getContextPath() %>/adminRestaurants"

            class="restaurant-btn">

            Restaurants

        </a>


        <a
            href="<%= request.getContextPath() %>/restaurant"

            class="website-btn">

            🌐 Visit Website

        </a>


        <a
            href="<%= request.getContextPath() %>/logout"

            class="logout-btn">

            Logout

        </a>


    </div>


</nav>



<!-- ============================= -->
<!-- HEADER -->
<!-- ============================= -->

<section class="page-header">


    <div class="header-container">


        <div>


            <h1>

                Manage

                <span>

                    Menu

                </span>

            </h1>


            <p>

                Add food items, update prices,
                edit descriptions and images,
                manage availability and remove
                menu items from Foodcorner.

            </p>


        </div>


        <%
        if (selectedRestaurantId != null) {
        %>

        <a
            href="<%= request.getContextPath() %>/addMenu?restaurantId=<%= selectedRestaurantId %>"

            class="add-btn">

            + Add Menu Item

        </a>

        <%
        } else {
        %>

        <a
            href="<%= request.getContextPath() %>/addMenu"

            class="add-btn">

            + Add Menu Item

        </a>

        <%
        }
        %>


    </div>


</section>



<!-- ============================= -->
<!-- MAIN -->
<!-- ============================= -->

<main class="container">


<!-- ============================= -->
<!-- MESSAGES -->
<!-- ============================= -->

<%
if ("true".equals(added)) {
%>

<div class="message success">

    ✓ Menu item added successfully.

</div>

<%
}
%>


<%
if ("true".equals(updated)) {
%>

<div class="message success">

    ✓ Menu item updated successfully.

</div>

<%
}
%>


<%
if ("true".equals(deleted)) {
%>

<div class="message success">

    ✓ Menu item deleted successfully.

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

    This menu item cannot be deleted because
    it is linked to an existing order.
    Please mark the item as unavailable instead.

</div>

<%
}
%>



<!-- ============================= -->
<!-- FILTER -->
<!-- ============================= -->

<div class="filter-card">


    <div class="filter-left">


        <h3>

            Filter by Restaurant

        </h3>


        <p>

            Select a restaurant to view
            and manage only its menu items.

        </p>


    </div>



    <form
        action="<%= request.getContextPath() %>/adminMenus"

        method="get"

        class="filter-form">


        <select
            name="restaurantId"

            class="filter-select"

            required>


            <option value="">

                Select Restaurant

            </option>


<%

if (restaurants != null) {

    for (Restaurant restaurant :
            restaurants) {

%>


            <option
                value="<%= restaurant.getRestaurantId() %>"

                <%= selectedRestaurantId != null &&
                    selectedRestaurantId.intValue()
                    == restaurant.getRestaurantId()
                    ? "selected"
                    : "" %>>


                <%= restaurant.getName() %>

            </option>


<%

    }
}

%>


        </select>


        <button
            type="submit"

            class="filter-btn">

            Filter

        </button>


        <a
            href="<%= request.getContextPath() %>/adminMenus"

            class="clear-btn">

            Show All

        </a>


    </form>


</div>



<!-- ============================= -->
<!-- SELECTED RESTAURANT -->
<!-- ============================= -->

<%

if (selectedRestaurant != null) {

%>


<div class="selected-info">

    Showing menu items for

    <strong>

        <%= selectedRestaurant.getName() %>

    </strong>

    &nbsp; | &nbsp;

    Restaurant ID:

    <strong>

        <%= selectedRestaurant.getRestaurantId() %>

    </strong>

</div>


<%

}

%>



<!-- ============================= -->
<!-- TOP BAR -->
<!-- ============================= -->

<div class="top-bar">


    <div class="item-count">

        Total Menu Items:

        <strong>

            <%= menus != null
                    ? menus.size()
                    : 0 %>

        </strong>

    </div>


    <div class="admin-info">

        Logged in as

        <strong>

            <%= admin.getUsername() %>

        </strong>

    </div>


</div>



<!-- ============================= -->
<!-- MENU LIST -->
<!-- ============================= -->

<%

if (menus != null &&
    !menus.isEmpty()) {

%>


<div class="menu-grid">


<%

    for (Menu menu : menus) {


        String imagePath =
                menu.getImagePath();


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


        String restaurantName =
                restaurantNames.get(
                        menu.getRestaurantId()
                );


        if (restaurantName == null) {

            restaurantName =
                    "Restaurant #"
                    + menu.getRestaurantId();
        }

%>



<!-- ============================= -->
<!-- MENU CARD -->
<!-- ============================= -->

<div class="menu-card">



    <!-- IMAGE -->

    <div class="image-container">


        <%
        if (imageUrl != null) {
        %>


        <img
            src="<%= imageUrl %>"

            alt="<%= menu.getItemName() %>"

            class="menu-image"

            onerror="
                this.style.display='none';
                this.nextElementSibling.style.display='flex';
            ">


        <div
            class="image-placeholder"

            style="display:none;">


            <div class="placeholder-icon">

                🍜

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

                🍜

            </div>


            <div>

                No Menu Image

            </div>


        </div>


        <%
        }
        %>



        <div class="menu-id">

            Menu #<%= menu.getMenuId() %>

        </div>


        <div
            class="availability
            <%= menu.isAvailable()
                    ? "available"
                    : "unavailable" %>">


            <%= menu.isAvailable()
                    ? "AVAILABLE"
                    : "UNAVAILABLE" %>


        </div>


    </div>



    <!-- BODY -->

    <div class="card-body">



        <!-- ITEM NAME -->

        <div class="item-name">

            <%= menu.getItemName() %>

        </div>



        <!-- RESTAURANT -->

        <div class="restaurant-name">

            🍽 <%= restaurantName %>

        </div>



        <!-- DESCRIPTION -->

        <div class="description">


            <%

            if (menu.getDescription() == null ||
                menu.getDescription()
                    .trim()
                    .isEmpty()) {

            %>

                No description available.

            <%

            } else {

            %>

                <%= menu.getDescription() %>

            <%

            }

            %>


        </div>



        <!-- PRICE -->

        <div class="price-row">


            <span class="price-label">

                Price

            </span>


            <span class="price">

                ₹<%= String.format(
                        "%.2f",
                        menu.getPrice()
                ) %>

            </span>


        </div>



        <!-- IMAGE PATH -->

        <div class="image-path">


            <span class="image-path-label">

                Menu Image Path

            </span>


            <span class="image-path-value">


                <%

                if (menu.getImagePath() == null ||
                    menu.getImagePath()
                        .trim()
                        .isEmpty()) {

                %>

                    No image path provided

                <%

                } else {

                %>

                    <%= menu.getImagePath() %>

                <%

                }

                %>


            </span>


        </div>



        <!-- ============================= -->
        <!-- ACTIONS -->
        <!-- ============================= -->

        <div class="actions">



            <!-- EDIT -->

            <a
                href="<%= request.getContextPath() %>/editMenu?menuId=<%= menu.getMenuId() %>"

                class="action-btn edit-btn">

                Edit

            </a>



            <!-- AVAILABILITY -->

            <form
                action="<%= request.getContextPath() %>/toggleMenuAvailability"

                method="post"

                class="action-form"

                onsubmit="
                    return confirm(
                        '<%= menu.isAvailable()
                                ? "Make this menu item unavailable?"
                                : "Make this menu item available?" %>'
                    );
                ">


                <input
                    type="hidden"

                    name="menuId"

                    value="<%= menu.getMenuId() %>">


                <input
                    type="hidden"

                    name="restaurantId"

                    value="<%= menu.getRestaurantId() %>">


                <button
                    type="submit"

                    class="action-btn availability-btn">


                    <%= menu.isAvailable()
                            ? "Make Unavailable"
                            : "Make Available" %>


                </button>


            </form>



            <!-- DELETE -->

            <form
                action="<%= request.getContextPath() %>/deleteMenu"

                method="post"

                class="action-form"

                onsubmit="
                    return confirm(
                        'Are you sure you want to permanently delete this menu item?'
                    );
                ">


                <input
                    type="hidden"

                    name="menuId"

                    value="<%= menu.getMenuId() %>">


                <input
                    type="hidden"

                    name="restaurantId"

                    value="<%= menu.getRestaurantId() %>">


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



<!-- ============================= -->
<!-- EMPTY -->
<!-- ============================= -->

<div class="empty-state">


    <div class="empty-icon">

        🍜

    </div>


    <h2>

        No Menu Items Found

    </h2>


    <p>

        There are currently no menu items
        available for this selection.

    </p>


    <%

    if (selectedRestaurantId != null) {

    %>


    <a
        href="<%= request.getContextPath() %>/addMenu?restaurantId=<%= selectedRestaurantId %>"

        class="add-btn">

        + Add Menu Item

    </a>


    <%

    } else {

    %>


    <a
        href="<%= request.getContextPath() %>/addMenu"

        class="add-btn">

        + Add Menu Item

    </a>


    <%

    }

    %>


</div>


<%

}

%>


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