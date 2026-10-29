
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.util.List,java.util.Map,java.util.HashMap" %>
<%@ page import="com.tap.model.Menu,com.tap.model.Restaurant,com.tap.model.User" %>

<%!
    private String esc(Object value) {
        if (value == null) return "";
        return String.valueOf(value)
            .replace("&", "&amp;")
            .replace("<", "&lt;")
            .replace(">", "&gt;")
            .replace("\"", "&quot;")
            .replace("'", "&#39;");
    }
%>

<%
    User admin = (User) request.getAttribute("admin");

    if (admin == null) {
        admin = (User) session.getAttribute("user");
    }

    if (admin == null || admin.getRole() == null ||
        !"ADMIN".equalsIgnoreCase(admin.getRole())) {
        response.sendRedirect(request.getContextPath() + "/login.jsp");
        return;
    }

    List<Menu> menus = (List<Menu>) request.getAttribute("menus");
    List<Restaurant> restaurants = (List<Restaurant>) request.getAttribute("restaurants");

    Object selectedRestaurantValue = request.getAttribute("selectedRestaurantId");

    String selectedRestaurantId = selectedRestaurantValue == null
        ? request.getParameter("restaurantId")
        : String.valueOf(selectedRestaurantValue);

    if (selectedRestaurantId == null) {
        selectedRestaurantId = "";
    }

    String restaurantFilter = selectedRestaurantId;

    Map<Integer, String> restaurantNames = new HashMap<Integer, String>();

    if (restaurants != null) {
        for (Restaurant restaurant : restaurants) {
            restaurantNames.put(
                restaurant.getRestaurantId(),
                restaurant.getName()
            );
        }
    }

    String viewId = request.getParameter("viewId");
    Menu selectedMenu = null;

    if (menus != null && viewId != null) {
        for (Menu menu : menus) {
            if (String.valueOf(menu.getMenuId()).equals(viewId)) {
                selectedMenu = menu;
                break;
            }
        }
    }

    String added = request.getParameter("added");
    String updated = request.getParameter("updated");
    String deleted = request.getParameter("deleted");
    String error = request.getParameter("error");
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Manage Menus | Foodcorner</title>

    <style>
        * {
            box-sizing: border-box;
        }

        body {
            margin: 0;
            font-family: Arial, sans-serif;
            background: #fff8f1;
            color: #333;
        }

        .navbar {
            background: #f97316;
            color: white;
            padding: 16px 5%;
            display: flex;
            justify-content: space-between;
            align-items: center;
            flex-wrap: wrap;
            gap: 12px;
        }

        .brand {
            font-size: 23px;
            font-weight: bold;
        }

        .nav-links {
            display: flex;
            gap: 18px;
            flex-wrap: wrap;
        }

        .nav-links a {
            color: white;
            text-decoration: none;
            font-weight: bold;
        }

        .container {
            width: 92%;
            max-width: 1250px;
            margin: 28px auto;
        }

        .page-heading {
            display: flex;
            justify-content: space-between;
            align-items: center;
            flex-wrap: wrap;
            gap: 15px;
            margin-bottom: 22px;
        }

        h1 {
            margin: 0 0 7px;
            color: #9a3412;
            font-size: 28px;
        }

        .subtitle {
            color: #777;
            margin: 0;
        }

        .panel {
            background: white;
            border-radius: 12px;
            padding: 22px;
            margin-bottom: 24px;
            box-shadow: 0 3px 14px rgba(100, 50, 10, 0.08);
        }

        .filters {
            display: flex;
            align-items: end;
            flex-wrap: wrap;
            gap: 14px;
        }

        .filter-field,
        .search-field {
            flex: 1;
            min-width: 220px;
        }

        label {
            display: block;
            margin-bottom: 7px;
            font-weight: bold;
            font-size: 14px;
        }

        input,
        select {
            width: 100%;
            padding: 11px 12px;
            border: 1px solid #ddd;
            border-radius: 7px;
            font-size: 14px;
            background: white;
        }

        .btn {
            display: inline-block;
            padding: 10px 14px;
            border: none;
            border-radius: 7px;
            text-decoration: none;
            font-size: 13px;
            font-weight: bold;
            cursor: pointer;
            text-align: center;
            white-space: nowrap;
        }

        .btn-primary {
            background: #f97316;
            color: white;
        }

        .btn-secondary {
            background: #fff0e3;
            color: #9a3412;
        }

        .btn-success {
            background: #dcfce7;
            color: #166534;
        }

        .btn-danger {
            background: #fee2e2;
            color: #b91c1c;
        }

        .btn:hover {
            opacity: 0.88;
        }

        .table-heading {
            display: flex;
            justify-content: space-between;
            align-items: center;
            flex-wrap: wrap;
            gap: 15px;
            margin-bottom: 18px;
        }

        .table-heading h2,
        .detail-title {
            margin: 0;
            color: #9a3412;
        }

        .table-wrapper {
            overflow-x: auto;
        }

        table {
            width: 100%;
            border-collapse: collapse;
            min-width: 720px;
        }

        th,
        td {
            padding: 14px 12px;
            border-bottom: 1px solid #f0e5dc;
            text-align: left;
            font-size: 14px;
        }

        th {
            background: #fff1e6;
            color: #9a3412;
        }

        tbody tr:hover {
            background: #fffaf6;
        }

        .status {
            display: inline-block;
            padding: 6px 10px;
            border-radius: 20px;
            font-size: 12px;
            font-weight: bold;
        }

        .available {
            color: #166534;
            background: #dcfce7;
        }

        .unavailable {
            color: #991b1b;
            background: #fee2e2;
        }

        .detail-card {
            display: grid;
            grid-template-columns: minmax(200px, 320px) minmax(0, 1fr);
            gap: 25px;
            align-items: start;
        }

        .menu-image {
            width: 100%;
            height: 230px;
            object-fit: cover;
            border-radius: 10px;
            background: #fff1e6;
        }

        .image-placeholder {
            min-height: 180px;
            display: flex;
            align-items: center;
            justify-content: center;
            border-radius: 10px;
            background: #fff1e6;
            color: #9a3412;
        }

        .detail-info h2 {
            margin: 0 0 12px;
            color: #9a3412;
        }

        .detail-info p {
            line-height: 1.6;
            overflow-wrap: anywhere;
        }

        .detail-label {
            font-weight: bold;
            color: #555;
        }

        .actions {
            display: flex;
            flex-wrap: wrap;
            gap: 9px;
            margin-top: 20px;
        }

        .actions form {
            margin: 0;
        }

        .notice {
            padding: 12px 15px;
            border-radius: 8px;
            margin-bottom: 16px;
            font-size: 14px;
        }

        .notice-success {
            color: #166534;
            background: #dcfce7;
        }

        .notice-error {
            color: #991b1b;
            background: #fee2e2;
        }

        .empty-state {
            text-align: center;
            padding: 35px 15px;
            color: #777;
        }

        .empty-state h3 {
            color: #9a3412;
        }

        .count-text {
            color: #777;
            font-size: 13px;
        }

        @media (max-width: 700px) {
            .container {
                width: 95%;
            }

            .panel {
                padding: 16px;
            }

            .detail-card {
                grid-template-columns: 1fr;
            }

            .menu-image {
                height: 200px;
            }

            h1 {
                font-size: 24px;
            }
        }
    </style>
</head>

<body>

<nav class="navbar">
    <div class="brand">🍽 Foodcorner Admin</div>

    <div class="nav-links">
        <a href="<%= request.getContextPath() %>/adminDashboard">Dashboard</a>
        <a href="<%= request.getContextPath() %>/adminRestaurants">Restaurants</a>
        <a href="<%= request.getContextPath() %>/adminOrders">Orders</a>
        <a href="<%= request.getContextPath() %>/adminCustomers">Customers</a>
        <a href="<%= request.getContextPath() %>/restaurant">Website</a>
        <a href="<%= request.getContextPath() %>/logout">Logout</a>
    </div>
</nav>

<main class="container">

    <div class="page-heading">
        <div>
            <h1>Manage Menu Items</h1>
            <p class="subtitle">Search, view, edit and manage restaurant menu items.</p>
        </div>

        <a class="btn btn-primary"
           href="<%= request.getContextPath() %>/addMenu<%= !restaurantFilter.isEmpty() ? "?restaurantId=" + esc(restaurantFilter) : "" %>">
            + Add Menu Item
        </a>
    </div>

    <% if ("true".equalsIgnoreCase(added)) { %>
        <div class="notice notice-success">Menu item added successfully.</div>
    <% } %>

    <% if ("true".equalsIgnoreCase(updated)) { %>
        <div class="notice notice-success">Menu item updated successfully.</div>
    <% } %>

    <% if ("true".equalsIgnoreCase(deleted)) { %>
        <div class="notice notice-success">Menu item deleted successfully.</div>
    <% } %>

    <% if (error != null && !error.isEmpty()) { %>
        <div class="notice notice-error">The requested operation could not be completed. Please try again.</div>
    <% } %>

    <section class="panel">
        <form class="filters" method="get"
              action="<%= request.getContextPath() %>/adminMenus">

            <div class="filter-field">
                <label for="restaurantId">Filter by Restaurant</label>

                <select id="restaurantId" name="restaurantId">
                    <option value="">All Restaurants</option>

                    <%
                        if (restaurants != null) {
                            for (Restaurant restaurant : restaurants) {
                    %>
                                <option value="<%= restaurant.getRestaurantId() %>"
                                    <%= String.valueOf(restaurant.getRestaurantId()).equals(restaurantFilter)
                                        ? "selected" : "" %>>
                                    <%= esc(restaurant.getName()) %>
                                </option>
                    <%
                            }
                        }
                    %>
                </select>
            </div>

            <button type="submit" class="btn btn-primary">Apply Filter</button>

            <a class="btn btn-secondary"
               href="<%= request.getContextPath() %>/adminMenus">Show All</a>
        </form>
    </section>

    <section class="panel">
        <div class="table-heading">
            <div>
                <h2>Menu Items</h2>
                <p class="count-text">
                    <%= menus == null ? 0 : menus.size() %> item(s) loaded
                </p>
            </div>

            <div class="search-field">
                <label for="menuSearch">Search Menu Items</label>
                <input type="text" id="menuSearch"
                       placeholder="Search by ID, name, restaurant or description">
            </div>
        </div>

        <% if (menus != null && !menus.isEmpty()) { %>

            <div class="table-wrapper">
                <table id="menuTable">
                    <thead>
                        <tr>
                            <th>Menu ID</th>
                            <th>Item Name</th>
                            <th>Restaurant</th>
                            <th>Price</th>
                            <th>Status</th>
                            <th>Action</th>
                        </tr>
                    </thead>

                    <tbody>
                    <%
                        for (Menu menu : menus) {
                            String restaurantName =
                                restaurantNames.get(menu.getRestaurantId());

                            if (restaurantName == null) {
                                restaurantName =
                                    "Restaurant #" + menu.getRestaurantId();
                            }

                            String menuDescription = menu.getDescription() == null
                                ? ""
                                : menu.getDescription();

                            String searchText =
                                menu.getMenuId() + " " +
                                menu.getItemName() + " " +
                                restaurantName + " " +
                                menuDescription;
                    %>
                        <tr class="menu-row"
                            data-search="<%= esc(searchText) %>">

                            <td><%= menu.getMenuId() %></td>
                            <td><strong><%= esc(menu.getItemName()) %></strong></td>
                            <td><%= esc(restaurantName) %></td>
                            <td>₹<%= String.format("%.2f", menu.getPrice()) %></td>

                            <td>
                                <% if (menu.isAvailable()) { %>
                                    <span class="status available">Available</span>
                                <% } else { %>
                                    <span class="status unavailable">Unavailable</span>
                                <% } %>
                            </td>

                            <td>
                                <a class="btn btn-secondary"
                                   href="<%= request.getContextPath() %>/adminMenus?viewId=<%= menu.getMenuId() %><%= !restaurantFilter.isEmpty() ? "&restaurantId=" + esc(restaurantFilter) : "" %>">
                                    View Details
                                </a>
                            </td>
                        </tr>
                    <%
                        }
                    %>
                    </tbody>
                </table>
            </div>

            <div id="noSearchResults" class="empty-state" style="display:none;">
                No menu items match your search.
            </div>

        <% } else { %>

            <div class="empty-state">
                <h3>No Menu Items Found</h3>
                <p>There are no menu items for the selected restaurant.</p>

                <a class="btn btn-primary"
                   href="<%= request.getContextPath() %>/addMenu<%= !restaurantFilter.isEmpty() ? "?restaurantId=" + esc(restaurantFilter) : "" %>">
                    + Add Menu Item
                </a>
            </div>

        <% } %>
    </section>

    <%
        if (selectedMenu != null) {
            String selectedMenuRestaurant =
                restaurantNames.get(selectedMenu.getRestaurantId());

            if (selectedMenuRestaurant == null) {
                selectedMenuRestaurant =
                    "Restaurant #" + selectedMenu.getRestaurantId();
            }

            String imagePath = selectedMenu.getImagePath();
    %>

        <section class="panel" id="menuDetails">
            <div class="table-heading">
                <div>
                    <h2 class="detail-title">Menu Item Details</h2>
                    <p class="subtitle">
                        Menu ID: <%= selectedMenu.getMenuId() %>
                    </p>
                </div>

                <a class="btn btn-secondary"
                   href="<%= request.getContextPath() %>/adminMenus<%= !restaurantFilter.isEmpty() ? "?restaurantId=" + esc(restaurantFilter) : "" %>">
                    Back to List
                </a>
            </div>

            <div class="detail-card">
                <div>
                    <% if (imagePath != null && !imagePath.trim().isEmpty()) { %>
                        <img class="menu-image"
                             src="<%= esc(imagePath) %>"
                             alt="<%= esc(selectedMenu.getItemName()) %>"
                             onerror="this.style.display='none';this.nextElementSibling.style.display='flex';">

                        <div class="image-placeholder" style="display:none;">
                            Image unavailable
                        </div>
                    <% } else { %>
                        <div class="image-placeholder">No image available</div>
                    <% } %>
                </div>

                <div class="detail-info">
                    <h2><%= esc(selectedMenu.getItemName()) %></h2>

                    <p>
                        <span class="detail-label">Restaurant:</span>
                        <%= esc(selectedMenuRestaurant) %>
                    </p>

                    <p>
                        <span class="detail-label">Price:</span>
                        ₹<%= String.format("%.2f", selectedMenu.getPrice()) %>
                    </p>

                    <p>
                        <span class="detail-label">Availability:</span>

                        <% if (selectedMenu.isAvailable()) { %>
                            <span class="status available">Available</span>
                        <% } else { %>
                            <span class="status unavailable">Unavailable</span>
                        <% } %>
                    </p>

                    <p>
                        <span class="detail-label">Description:</span><br>
                        <%= selectedMenu.getDescription() == null ||
                            selectedMenu.getDescription().trim().isEmpty()
                            ? "No description available."
                            : esc(selectedMenu.getDescription()) %>
                    </p>

                    <p>
                        <span class="detail-label">Image Path:</span><br>
                        <%= imagePath == null || imagePath.trim().isEmpty()
                            ? "No image path provided."
                            : esc(imagePath) %>
                    </p>

                    <div class="actions">
                        <a class="btn btn-primary"
                           href="<%= request.getContextPath() %>/editMenu?menuId=<%= selectedMenu.getMenuId() %>">
                            Edit Menu Item
                        </a>

                        <form method="post"
                              action="<%= request.getContextPath() %>/toggleMenuAvailability"
                              onsubmit="return confirm('Change the availability of this menu item?');">

                            <input type="hidden" name="menuId"
                                   value="<%= selectedMenu.getMenuId() %>">

                            <input type="hidden" name="restaurantId"
                                   value="<%= selectedMenu.getRestaurantId() %>">

                            <button type="submit" class="btn btn-success">
                                <%= selectedMenu.isAvailable()
                                    ? "Make Unavailable"
                                    : "Make Available" %>
                            </button>
                        </form>

                        <form method="post"
                              action="<%= request.getContextPath() %>/deleteMenu"
                              onsubmit="return confirm('Are you sure you want to delete this menu item? This action cannot be undone.');">

                            <input type="hidden" name="menuId"
                                   value="<%= selectedMenu.getMenuId() %>">

                            <input type="hidden" name="restaurantId"
                                   value="<%= selectedMenu.getRestaurantId() %>">

                            <button type="submit" class="btn btn-danger">
                                Delete Menu Item
                            </button>
                        </form>
                    </div>
                </div>
            </div>
        </section>

    <% } else if (viewId != null) { %>

        <section class="panel">
            <div class="notice notice-error">
                The selected menu item was not found in the current list.
                Try changing the restaurant filter or returning to the menu list.
            </div>

            <a class="btn btn-secondary"
               href="<%= request.getContextPath() %>/adminMenus<%= !restaurantFilter.isEmpty() ? "?restaurantId=" + esc(restaurantFilter) : "" %>">
                Back to Menu List
            </a>
        </section>

    <% } %>

</main>

<script>
    const menuSearch = document.getElementById("menuSearch");
    const menuRows = document.querySelectorAll(".menu-row");
    const noSearchResults = document.getElementById("noSearchResults");

    if (menuSearch) {
        menuSearch.addEventListener("input", function () {
            const query = this.value.toLowerCase().trim();
            let visibleCount = 0;

            menuRows.forEach(function (row) {
                const searchableText =
                    (row.getAttribute("data-search") || "").toLowerCase();

                const matches = searchableText.includes(query);

                row.style.display = matches ? "" : "none";

                if (matches) {
                    visibleCount++;
                }
            });

            if (noSearchResults) {
                noSearchResults.style.display =
                    visibleCount === 0 ? "block" : "none";
            }
        });
    }

    const menuDetails = document.getElementById("menuDetails");

    if (menuDetails) {
        menuDetails.scrollIntoView({
            behavior: "smooth",
            block: "start"
        });
    }
</script>

</body>
</html>
