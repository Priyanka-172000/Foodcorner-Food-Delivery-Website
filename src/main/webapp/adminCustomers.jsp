<%@ page language="java"
    contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<%@ page import="java.util.List" %>
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


List<User> customers =
        (List<User>)
        request.getAttribute("customers");
%>


<!DOCTYPE html>

<html>

<head>

<meta charset="UTF-8">

<meta name="viewport"
      content="width=device-width, initial-scale=1.0">

<title>
    Foodcorner | Customers
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

    background: white;
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


/* ============================== */
/* HEADER */
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
/* SUMMARY */
/* ============================== */

.summary-bar {

    background: white;

    border:
        1px solid #eeeeee;

    border-radius: 14px;

    padding:
        18px 20px;

    margin-bottom: 25px;

    display: flex;

    justify-content: space-between;

    align-items: center;

    gap: 20px;

    flex-wrap: wrap;
}


.customer-count {

    color: #666;

    font-size: 14px;
}


.customer-count strong {

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


/* ============================== */
/* CUSTOMER GRID */
/* ============================== */

.customer-grid {

    display: grid;

    grid-template-columns:
        repeat(
            auto-fit,
            minmax(320px, 1fr)
        );

    gap: 22px;
}


/* ============================== */
/* CUSTOMER CARD */
/* ============================== */

.customer-card {

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


.customer-card:hover {

    transform:
        translateY(-4px);

    box-shadow:
        0 12px 28px
        rgba(0,0,0,0.10);
}


/* ============================== */
/* CUSTOMER HEADER */
/* ============================== */

.customer-header {

    background: #fff8f4;

    padding: 20px;

    display: flex;

    align-items: center;

    gap: 15px;

    border-bottom:
        1px solid #eeeeee;
}


.avatar {

    width: 52px;

    height: 52px;

    border-radius: 50%;

    background: #ff5200;

    color: white;

    display: flex;

    align-items: center;

    justify-content: center;

    font-size: 22px;

    font-weight: bold;

    flex-shrink: 0;
}


.customer-name {

    font-size: 19px;

    font-weight: bold;

    margin-bottom: 4px;
}


.customer-id {

    color: #888;

    font-size: 12px;
}


/* ============================== */
/* DETAILS */
/* ============================== */

.customer-body {

    padding: 20px;
}


.detail-row {

    display: flex;

    justify-content: space-between;

    align-items: flex-start;

    gap: 18px;

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

    min-width: 80px;
}


.detail-value {

    color: #333;

    font-size: 13px;

    font-weight: bold;

    text-align: right;

    word-break: break-word;
}


.email {

    color: #ff5200;
}


.role {

    display: inline-block;

    background: #e6f7eb;

    color: #147a35;

    padding:
        5px 9px;

    border-radius: 20px;

    font-size: 11px;

    font-weight: bold;
}


/* ============================== */
/* INFO NOTE */
/* ============================== */

.customer-note {

    margin:
        0 20px 20px 20px;

    padding: 11px;

    border-radius: 8px;

    background: #fafafa;

    border:
        1px solid #eeeeee;

    color: #777;

    font-size: 11px;

    line-height: 1.6;
}


/* ============================== */
/* EMPTY */
/* ============================== */

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


    .customer-grid {

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
<!-- HEADER -->
<!-- ============================== -->

<section class="page-header">


    <div class="header-content">


        <h1>

            View

            <span>

                Customers

            </span>

        </h1>


        <p>

            View registered Foodcorner customers,
            contact information and delivery
            addresses. Customer management is
            read-only for the administrator.

        </p>


    </div>


</section>



<!-- ============================== -->
<!-- MAIN -->
<!-- ============================== -->

<main class="container">



    <!-- SUMMARY -->

    <div class="summary-bar">


        <div class="customer-count">

            Total Customers:

            <strong>

                <%= customers != null
                        ? customers.size()
                        : 0 %>

            </strong>

        </div>


        <div class="read-only">

            VIEW ONLY

        </div>


    </div>



<!-- ============================== -->
<!-- CUSTOMERS -->
<!-- ============================== -->

<%

if (customers != null &&
    !customers.isEmpty()) {

%>


<div class="customer-grid">


<%

    for (User customer : customers) {


        String username =
                customer.getUsername();


        String initial = "C";


        if (username != null &&
            !username.trim().isEmpty()) {

            initial =
                username.substring(0, 1)
                        .toUpperCase();
        }

%>



<div class="customer-card">


    <!-- CUSTOMER HEADER -->

    <div class="customer-header">


        <div class="avatar">

            <%= initial %>

        </div>


        <div>


            <div class="customer-name">

                <%= customer.getUsername() %>

            </div>


            <div class="customer-id">

                Customer ID:
                <%= customer.getUserId() %>

            </div>


        </div>


    </div>



    <!-- DETAILS -->

    <div class="customer-body">



        <!-- EMAIL -->

        <div class="detail-row">


            <span class="detail-label">

                Email

            </span>


            <span class="detail-value email">

                <%= customer.getEmail() %>

            </span>


        </div>



        <!-- PHONE -->

        <div class="detail-row">


            <span class="detail-label">

                Phone

            </span>


            <span class="detail-value">

                <%= customer.getPhone() %>

            </span>


        </div>



        <!-- ADDRESS -->

        <div class="detail-row">


            <span class="detail-label">

                Address

            </span>


            <span class="detail-value">

                <%= customer.getAddress() %>

            </span>


        </div>



        <!-- ROLE -->

        <div class="detail-row">


            <span class="detail-label">

                Role

            </span>


            <span class="detail-value">


                <span class="role">

                    <%= customer.getRole() %>

                </span>


            </span>


        </div>


    </div>



    <!-- NOTE -->

    <div class="customer-note">

        Customer information is view-only.
        Account details can be updated only
        by the customer from their profile.

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
<!-- EMPTY -->
<!-- ============================== -->

<div class="empty-state">


    <div class="empty-icon">

        👥

    </div>


    <h2>

        No Customers Found

    </h2>


    <p>

        Registered Foodcorner customers
        will appear here.

    </p>


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