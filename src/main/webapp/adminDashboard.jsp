
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8" %>
<%@ page import="com.tap.model.User" %>

<%
    User admin = (User) session.getAttribute("admin");

    if (admin == null) {
        admin = (User) session.getAttribute("user");
    }

    if (admin == null || admin.getRole() == null
            || !"ADMIN".equalsIgnoreCase(admin.getRole())) {
        response.sendRedirect(request.getContextPath() + "/login.jsp");
        return;
    }

    String contextPath = request.getContextPath();
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">

    <title>Admin Dashboard | Foodcorner</title>

    <style>
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }

        :root {
            --orange: #ff6b00;
            --orange-dark: #e85d00;
            --black: #171717;
            --background: #fff8f2;
            --white: #ffffff;
            --text: #292929;
            --muted: #777777;
            --border: #eeeeee;
        }

        body {
            font-family: Arial, Helvetica, sans-serif;
            background: var(--background);
            color: var(--text);
            min-height: 100vh;
            display: flex;
            flex-direction: column;
        }

        a {
            text-decoration: none;
        }

        .navbar {
            background: var(--black);
            color: var(--white);
            padding: 19px 7%;
            display: flex;
            justify-content: space-between;
            align-items: center;
            gap: 16px;
        }

        .brand {
            color: var(--orange);
            font-size: 27px;
            font-weight: 800;
            letter-spacing: -0.7px;
        }

        .brand span {
            color: var(--white);
        }

        .logout {
            background: var(--orange);
            color: var(--white);
            padding: 11px 19px;
            border-radius: 7px;
            font-size: 14px;
            font-weight: 700;
            transition: background 0.2s ease;
        }

        .logout:hover {
            background: var(--orange-dark);
        }

        .container {
            width: 88%;
            max-width: 1180px;
            margin: 0 auto;
            flex: 1;
        }

        .welcome {
            margin-top: 38px;
            padding: 35px 38px;
            border-radius: 16px;
            background: linear-gradient(120deg, #191919, #39312c);
            color: var(--white);
        }

        .welcome-label {
            color: #ff9a55;
            background: rgba(255, 107, 0, 0.15);
            border: 1px solid rgba(255, 107, 0, 0.3);
            border-radius: 20px;
            padding: 7px 12px;
            display: inline-block;
            font-size: 11px;
            font-weight: 700;
            letter-spacing: 1px;
            margin-bottom: 16px;
        }

        .welcome h1 {
            font-size: 32px;
            margin-bottom: 12px;
            line-height: 1.3;
        }

        .welcome h1 span {
            color: var(--orange);
        }

        .welcome p {
            color: #d3d3d3;
            font-size: 14px;
            line-height: 1.8;
            max-width: 650px;
        }

        .section {
            margin-top: 36px;
            margin-bottom: 42px;
        }

        .section-heading {
            margin-bottom: 22px;
        }

        .section-heading h2 {
            font-size: 24px;
            margin-bottom: 8px;
            color: var(--black);
        }

        .section-heading p {
            color: var(--muted);
            font-size: 14px;
            line-height: 1.6;
        }

        .management-grid {
            display: grid;
            grid-template-columns: repeat(3, minmax(0, 1fr));
            gap: 20px;
        }

        .management-card {
            background: var(--white);
            border: 1px solid var(--border);
            border-radius: 13px;
            padding: 25px;
            min-height: 225px;
            display: flex;
            flex-direction: column;
            transition: transform 0.2s ease, box-shadow 0.2s ease;
        }

        .management-card:hover {
            transform: translateY(-4px);
            box-shadow: 0 10px 25px rgba(0, 0, 0, 0.07);
            border-color: #ffd4b8;
        }

        .card-icon {
            width: 49px;
            height: 49px;
            border-radius: 12px;
            background: #fff0e5;
            color: var(--orange);
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 25px;
            margin-bottom: 19px;
        }

        .management-card h3 {
            font-size: 17px;
            color: var(--black);
            margin-bottom: 10px;
        }

        .management-card p {
            font-size: 13px;
            color: var(--muted);
            line-height: 1.7;
            margin-bottom: 20px;
            flex: 1;
        }

        .card-action {
            display: flex;
            justify-content: space-between;
            align-items: center;
            color: var(--orange);
            font-size: 13px;
            font-weight: 700;
            padding-top: 14px;
            border-top: 1px solid #f3f3f3;
        }

        .arrow {
            font-size: 19px;
            transition: transform 0.2s ease;
        }

        .management-card:hover .arrow {
            transform: translateX(4px);
        }

        .footer {
            text-align: center;
            background: var(--black);
            color: #bdbdbd;
            padding: 21px 15px;
            font-size: 13px;
            line-height: 1.7;
        }

        .footer span {
            color: var(--orange);
            font-weight: 700;
        }

        @media (max-width: 900px) {
            .management-grid {
                grid-template-columns: repeat(2, minmax(0, 1fr));
            }

            .container {
                width: 92%;
            }
        }

        @media (max-width: 580px) {
            .navbar {
                padding: 17px 5%;
            }

            .brand {
                font-size: 24px;
            }

            .container {
                width: 92%;
            }

            .welcome {
                margin-top: 23px;
                padding: 28px 23px;
            }

            .welcome h1 {
                font-size: 26px;
            }

            .section-heading h2 {
                font-size: 22px;
            }

            .management-grid {
                grid-template-columns: 1fr;
                gap: 15px;
            }

            .management-card {
                min-height: 205px;
            }
        }
    </style>
</head>

<body>

    <nav class="navbar">
        <a href="<%= contextPath %>/adminDashboard.jsp" class="brand">
            Food<span>corner</span>
        </a>

        <a href="<%= contextPath %>/logout" class="logout">Logout</a>
    </nav>

    <main class="container">

        <section class="welcome">
            <div class="welcome-label">ADMIN CONTROL PANEL</div>

            <h1>Welcome to <span>Foodcorner!</span></h1>

            <p>
                Manage your food delivery platform from one place.
                Select a section below to manage restaurants, menus,
                customer accounts, orders, or your administrator profile.
            </p>
        </section>

        <section class="section">

            <div class="section-heading">
                <h2>Dashboard</h2>
                <p>Everything you need, organized in one simple workspace.</p>
            </div>

            <div class="management-grid">

                <a href="<%= contextPath %>/adminRestaurants"
                   class="management-card">

                    <div class="card-icon">&#127860;</div>

                    <h3>Manage Restaurants</h3>

                    <p>
                        View restaurant details, update restaurant information,
                        and manage restaurant status and menus.
                    </p>

                    <div class="card-action">
                        <span>Manage Restaurants</span>
                        <span class="arrow">&#8594;</span>
                    </div>
                </a>

                <a href="<%= contextPath %>/adminMenus"
                   class="management-card">

                    <div class="card-icon">&#127828;</div>

                    <h3>Manage Menus</h3>

                    <p>
                        View menu items, update prices and descriptions,
                        and manage item availability.
                    </p>

                    <div class="card-action">
                        <span>Manage Menus</span>
                        <span class="arrow">&#8594;</span>
                    </div>
                </a>

                <a href="<%= contextPath %>/adminOrders"
                   class="management-card">

                    <div class="card-icon">&#128722;</div>

                    <h3>View Orders</h3>

                    <p>
                        Review customer orders, inspect order details,
                        and monitor order status.
                    </p>

                    <div class="card-action">
                        <span>View Orders</span>
                        <span class="arrow">&#8594;</span>
                    </div>
                </a>

                <a href="<%= contextPath %>/adminCustomers"
                   class="management-card">

                    <div class="card-icon">&#128101;</div>

                    <h3>Manage Customers</h3>

                    <p>
                        Search registered customers and view their
                        account information.
                    </p>

                    <div class="card-action">
                        <span>Manage Customers</span>
                        <span class="arrow">&#8594;</span>
                    </div>
                </a>

                <a href="<%= contextPath %>/editProfile"
                   class="management-card">

                    <div class="card-icon">&#128100;</div>

                    <h3>Admin Profile</h3>

                    <p>
                        View and update your administrator account
                        information and personal details.
                    </p>

                    <div class="card-action">
                        <span>Edit Profile</span>
                        <span class="arrow">&#8594;</span>
                    </div>
                </a>

                <a href="<%= contextPath %>/restaurant"
                   class="management-card">

                    <div class="card-icon">&#127968;</div>

                    <h3>Visit Website</h3>

                    <p>
                        Open the customer-facing Foodcorner website
                        to explore restaurants and the food ordering pages.
                    </p>

                    <div class="card-action">
                        <span>Go to Website</span>
                        <span class="arrow">&#8594;</span>
                    </div>
                </a>

            </div>
        </section>

    </main>

    <footer class="footer">
        &copy; 2026 <span>Foodcorner</span> Admin Panel. All rights reserved.
    </footer>

</body>
</html>
