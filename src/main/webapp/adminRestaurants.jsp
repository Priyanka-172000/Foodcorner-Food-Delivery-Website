
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List" %>
<%@ page import="com.tap.model.Restaurant" %>
<%@ page import="com.tap.model.User" %>

<%
User admin = (User) request.getAttribute("admin");
if (admin == null) {
    admin = (User) session.getAttribute("user");
}

if (admin == null || admin.getRole() == null || !"ADMIN".equalsIgnoreCase(admin.getRole())) {
    response.sendRedirect(request.getContextPath() + "/login.jsp");
    return;
}

List<Restaurant> restaurants = (List<Restaurant>) request.getAttribute("restaurants");

String added = request.getParameter("added");
String updated = request.getParameter("updated");
String deleted = request.getParameter("deleted");
String error = request.getParameter("error");
String viewIdParam = request.getParameter("viewId");

Restaurant selectedRestaurant = null;
boolean detailMode = viewIdParam != null;

if (detailMode && restaurants != null) {
    try {
        int selectedId = Integer.parseInt(viewIdParam);
        for (Restaurant r : restaurants) {
            if (r.getRestaurantId() == selectedId) {
                selectedRestaurant = r;
                break;
            }
        }
    } catch (NumberFormatException e) {
        selectedRestaurant = null;
    }
}

String contextPath = request.getContextPath();
%>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>Foodcorner | Manage Restaurants</title>

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
    min-height: 100vh;
}

.navbar {
    background: white;
    padding: 16px 6%;
    display: flex;
    justify-content: space-between;
    align-items: center;
    gap: 15px;
    box-shadow: 0 2px 12px rgba(0,0,0,.08);
    position: sticky;
    top: 0;
    z-index: 10;
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
    gap: 10px;
    flex-wrap: wrap;
}

.admin-name {
    color: #555;
    font-size: 13px;
    font-weight: bold;
}

.nav-btn {
    text-decoration: none;
    padding: 9px 13px;
    border-radius: 8px;
    font-size: 13px;
    font-weight: bold;
}

.dashboard-btn {
    color: #ff5200;
    border: 1px solid #ff5200;
    background: white;
}

.dashboard-btn:hover {
    background: #ff5200;
    color: white;
}

.website-btn {
    color: #444;
    border: 1px solid #ddd;
}

.logout-btn {
    background: #222;
    color: white;
}

.page-header {
    padding: 35px 6%;
    background: linear-gradient(135deg, #fff0e8, #fff9f6);
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
    font-size: 32px;
    margin-bottom: 8px;
}

.page-header h1 span {
    color: #ff5200;
}

.page-header p {
    color: #666;
    font-size: 14px;
    line-height: 1.7;
}

.add-btn {
    display: inline-block;
    text-decoration: none;
    background: #ff5200;
    color: white;
    padding: 12px 17px;
    border: none;
    border-radius: 8px;
    font-size: 13px;
    font-weight: bold;
    cursor: pointer;
    white-space: nowrap;
}

.add-btn:hover {
    background: #e94a00;
}

.container {
    width: 90%;
    max-width: 1350px;
    margin: 30px auto 60px;
}

.message {
    padding: 13px 16px;
    border-radius: 8px;
    margin-bottom: 18px;
    font-size: 14px;
    font-weight: bold;
}

.success {
    background: #e6f7eb;
    color: #1b7d3e;
    border: 1px solid #bde8c9;
}

.error {
    background: #ffe7e7;
    color: #b42318;
    border: 1px solid #ffc9c9;
}

.toolbar {
    display: flex;
    justify-content: space-between;
    align-items: center;
    gap: 18px;
    margin-bottom: 20px;
    flex-wrap: wrap;
}

.count {
    font-size: 14px;
    color: #666;
}

.count strong {
    color: #ff5200;
    font-size: 19px;
}

.search-box {
    width: min(100%, 380px);
    padding: 12px 14px;
    border: 1px solid #ddd;
    border-radius: 9px;
    font-size: 14px;
    outline: none;
    background: white;
}

.search-box:focus {
    border-color: #ff5200;
    box-shadow: 0 0 0 3px rgba(255,82,0,.10);
}

.table-wrap {
    background: white;
    border: 1px solid #eee;
    border-radius: 12px;
    overflow-x: auto;
    box-shadow: 0 4px 15px rgba(0,0,0,.04);
}

table {
    width: 100%;
    border-collapse: collapse;
    min-width: 720px;
}

thead {
    background: #fff3ed;
}

th {
    color: #555;
    font-size: 12px;
    text-align: left;
    padding: 16px 15px;
    white-space: nowrap;
}

td {
    padding: 15px;
    border-top: 1px solid #eee;
    font-size: 13px;
    vertical-align: middle;
}

tbody tr:hover {
    background: #fffaf7;
}

.restaurant-title {
    font-weight: bold;
    color: #222;
}

.muted {
    color: #888;
    font-size: 12px;
    margin-top: 4px;
}

.status {
    display: inline-block;
    padding: 6px 10px;
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

.view-btn {
    display: inline-block;
    text-decoration: none;
    background: #ff5200;
    color: white;
    padding: 9px 13px;
    border-radius: 7px;
    font-size: 12px;
    font-weight: bold;
    white-space: nowrap;
}

.view-btn:hover {
    background: #e94a00;
}

.no-results {
    display: none;
    text-align: center;
    padding: 30px;
    color: #777;
    background: white;
    border-radius: 10px;
    margin-top: 12px;
}

.back-link {
    display: inline-block;
    color: #ff5200;
    text-decoration: none;
    font-weight: bold;
    font-size: 14px;
    margin-bottom: 20px;
}

.back-link:hover {
    text-decoration: underline;
}

.detail-card {
    background: white;
    border: 1px solid #eee;
    border-radius: 15px;
    overflow: hidden;
    box-shadow: 0 5px 20px rgba(0,0,0,.05);
}

.detail-layout {
    display: grid;
    grid-template-columns: minmax(250px, 38%) 1fr;
}

.detail-image {
    min-height: 300px;
    background: #eee;
    position: relative;
}

.detail-image img {
    width: 100%;
    height: 100%;
    min-height: 300px;
    object-fit: cover;
    display: block;
}

.image-placeholder {
    min-height: 300px;
    display: flex;
    align-items: center;
    justify-content: center;
    flex-direction: column;
    gap: 10px;
    color: #888;
    padding: 20px;
    text-align: center;
}

.placeholder-icon {
    font-size: 50px;
}

.detail-content {
    padding: 25px;
    min-width: 0;
}

.detail-heading {
    display: flex;
    justify-content: space-between;
    align-items: flex-start;
    gap: 15px;
    margin-bottom: 22px;
    flex-wrap: wrap;
}

.detail-heading h2 {
    font-size: 25px;
    margin-bottom: 7px;
    overflow-wrap: anywhere;
}

.detail-id {
    font-size: 12px;
    color: #888;
}

.detail-grid {
    display: grid;
    grid-template-columns: repeat(2, minmax(0, 1fr));
    gap: 16px;
}

.detail-item {
    border: 1px solid #eee;
    background: #fcfcfc;
    padding: 13px;
    border-radius: 9px;
    min-width: 0;
}

.detail-label {
    display: block;
    font-size: 11px;
    color: #888;
    margin-bottom: 7px;
}

.detail-value {
    font-size: 14px;
    font-weight: bold;
    overflow-wrap: anywhere;
    line-height: 1.5;
}

.image-path {
    margin-top: 16px;
    padding: 13px;
    border-radius: 8px;
    background: #fafafa;
    border: 1px solid #eee;
    overflow-wrap: anywhere;
    font-size: 12px;
    color: #555;
    line-height: 1.6;
}

.actions {
    display: flex;
    gap: 9px;
    flex-wrap: wrap;
    padding-top: 20px;
    margin-top: 20px;
    border-top: 1px solid #eee;
}

.action-form {
    margin: 0;
}

.action-btn {
    display: inline-block;
    border: none;
    text-decoration: none;
    padding: 10px 13px;
    border-radius: 7px;
    font-size: 12px;
    font-weight: bold;
    cursor: pointer;
    font-family: Arial, Helvetica, sans-serif;
}

.edit-btn {
    background: #ff5200;
    color: white;
}

.menu-btn {
    background: #222;
    color: white;
}

.status-btn {
    background: white;
    color: #555;
    border: 1px solid #ccc;
}

.delete-btn {
    background: white;
    color: #d32f2f;
    border: 1px solid #d32f2f;
}

.delete-btn:hover {
    background: #d32f2f;
    color: white;
}

.empty-state {
    background: white;
    border: 1px solid #eee;
    border-radius: 12px;
    padding: 55px 25px;
    text-align: center;
}

.empty-icon {
    font-size: 48px;
    margin-bottom: 15px;
}

.empty-state h2 {
    margin-bottom: 10px;
}

.empty-state p {
    color: #777;
    margin-bottom: 22px;
    line-height: 1.6;
}

footer {
    background: #181818;
    color: #ccc;
    text-align: center;
    padding: 25px;
    font-size: 13px;
}

footer span {
    color: #ff5200;
}

@media(max-width: 750px) {
    .navbar {
        padding: 14px 4%;
    }

    .admin-name,
    .website-btn {
        display: none;
    }

    .page-header {
        padding: 28px 5%;
    }

    .header-container {
        align-items: flex-start;
        flex-direction: column;
    }

    .page-header h1 {
        font-size: 27px;
    }

    .container {
        width: 94%;
    }

    .detail-layout {
        grid-template-columns: 1fr;
    }

    .detail-image,
    .detail-image img,
    .image-placeholder {
        min-height: 220px;
        max-height: 280px;
    }

    .detail-grid {
        grid-template-columns: 1fr;
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

<nav class="navbar">
    <div class="logo">Food<span>corner</span></div>

    <div class="nav-right">
        <span class="admin-name">👤 <%= admin.getUsername() %></span>

        <a href="<%= contextPath %>/adminDashboard" class="nav-btn dashboard-btn">Dashboard</a>
        <a href="<%= contextPath %>/restaurant" class="nav-btn website-btn">🌐 Visit Website</a>
        <a href="<%= contextPath %>/logout" class="nav-btn logout-btn">Logout</a>
    </div>
</nav>

<section class="page-header">
    <div class="header-container">
        <div>
            <h1>Manage <span>Restaurants</span></h1>
            <p>
                Search restaurants, view their details, edit information,
                manage menus, change status or delete a restaurant.
            </p>
        </div>

        <a href="<%= contextPath %>/addRestaurant" class="add-btn">+ Add Restaurant</a>
    </div>
</section>

<main class="container">

    <% if ("true".equals(added)) { %>
        <div class="message success">✓ Restaurant added successfully.</div>
    <% } %>

    <% if ("true".equals(updated)) { %>
        <div class="message success">✓ Restaurant updated successfully.</div>
    <% } %>

    <% if ("true".equals(deleted)) { %>
        <div class="message success">✓ Restaurant deleted successfully.</div>
    <% } %>

    <% if ("true".equals(error)) { %>
        <div class="message error">Something went wrong. Please try again.</div>
    <% } %>

    <% if ("delete".equals(error)) { %>
        <div class="message error">
            This restaurant cannot be deleted because menu items or orders are linked to it.
            Please deactivate the restaurant instead.
        </div>
    <% } %>

    <% if (!detailMode) { %>

        <div class="toolbar">
            <div class="count">
                Total Restaurants:
                <strong><%= restaurants != null ? restaurants.size() : 0 %></strong>
            </div>

            <input
                type="search"
                id="restaurantSearch"
                class="search-box"
                placeholder="Search by ID, name, cuisine or address..."
                aria-label="Search restaurants">
        </div>

        <% if (restaurants != null && !restaurants.isEmpty()) { %>

            <div class="table-wrap">
                <table id="restaurantTable">
                    <thead>
                        <tr>
                            <th>Restaurant</th>
                            <th>Cuisine</th>
                            <th>Address</th>
                            <th>Rating</th>
                            <th>Status</th>
                            <th>Action</th>
                        </tr>
                    </thead>

                    <tbody>
                    <% for (Restaurant restaurant : restaurants) { %>
                        <tr class="restaurant-row"
                            data-search="<%= restaurant.getRestaurantId() %> <%= restaurant.getName() %> <%= restaurant.getCuisineType() %> <%= restaurant.getAddress() %> <%= restaurant.isActive() ? "active" : "inactive" %>">

                            <td>
                                <div class="restaurant-title"><%= restaurant.getName() %></div>
                                <div class="muted">ID: <%= restaurant.getRestaurantId() %></div>
                            </td>

                            <td><%= restaurant.getCuisineType() %></td>

                            <td><%= restaurant.getAddress() %></td>

                            <td>⭐ <%= restaurant.getRating() %></td>

                            <td>
                                <span class="status <%= restaurant.isActive() ? "active" : "inactive" %>">
                                    <%= restaurant.isActive() ? "ACTIVE" : "INACTIVE" %>
                                </span>
                            </td>

                            <td>
                                <a class="view-btn"
                                   href="<%= contextPath %>/adminRestaurants?viewId=<%= restaurant.getRestaurantId() %>">
                                    View Details →
                                </a>
                            </td>
                        </tr>
                    <% } %>
                    </tbody>
                </table>
            </div>

            <div id="noResults" class="no-results">
                No restaurants match your search.
            </div>

        <% } else { %>

            <div class="empty-state">
                <div class="empty-icon">🍽️</div>
                <h2>No Restaurants Found</h2>
                <p>There are currently no restaurants available in Foodcorner.</p>
                <a href="<%= contextPath %>/addRestaurant" class="add-btn">+ Add Restaurant</a>
            </div>

        <% } %>

    <% } else if (selectedRestaurant != null) { %>

        <a href="<%= contextPath %>/adminRestaurants" class="back-link">← Back to Restaurant List</a>

        <div class="detail-card">
            <div class="detail-layout">

                <div class="detail-image">
                    <%
                    String imagePath = selectedRestaurant.getImagePath();
                    String imageUrl = null;

                    if (imagePath != null && !imagePath.trim().isEmpty()) {
                        imagePath = imagePath.trim();

                        if (imagePath.startsWith("http://") || imagePath.startsWith("https://")) {
                            imageUrl = imagePath;
                        } else {
                            if (imagePath.startsWith("/")) {
                                imagePath = imagePath.substring(1);
                            }
                            imageUrl = contextPath + "/" + imagePath;
                        }
                    }
                    %>

                    <% if (imageUrl != null) { %>
                        <img
                            src="<%= imageUrl %>"
                            alt="<%= selectedRestaurant.getName() %>"
                            onerror="this.style.display='none';this.nextElementSibling.style.display='flex';">

                        <div class="image-placeholder" style="display:none;">
                            <div class="placeholder-icon">🍽️</div>
                            Image not available
                        </div>
                    <% } else { %>
                        <div class="image-placeholder">
                            <div class="placeholder-icon">🍽️</div>
                            No restaurant image
                        </div>
                    <% } %>
                </div>

                <div class="detail-content">

                    <div class="detail-heading">
                        <div>
                            <h2><%= selectedRestaurant.getName() %></h2>
                            <div class="detail-id">
                                Restaurant ID: <%= selectedRestaurant.getRestaurantId() %>
                            </div>
                        </div>

                        <span class="status <%= selectedRestaurant.isActive() ? "active" : "inactive" %>">
                            <%= selectedRestaurant.isActive() ? "ACTIVE" : "INACTIVE" %>
                        </span>
                    </div>

                    <div class="detail-grid">
                        <div class="detail-item">
                            <span class="detail-label">Cuisine</span>
                            <div class="detail-value"><%= selectedRestaurant.getCuisineType() %></div>
                        </div>

                        <div class="detail-item">
                            <span class="detail-label">Delivery Time</span>
                            <div class="detail-value"><%= selectedRestaurant.getDeliveryTime() %></div>
                        </div>

                        <div class="detail-item">
                            <span class="detail-label">Rating</span>
                            <div class="detail-value">⭐ <%= selectedRestaurant.getRating() %></div>
                        </div>

                        <div class="detail-item">
                            <span class="detail-label">Admin User ID</span>
                            <div class="detail-value"><%= selectedRestaurant.getAdminUserId() %></div>
                        </div>

                        <div class="detail-item" style="grid-column:1/-1;">
                            <span class="detail-label">Address</span>
                            <div class="detail-value"><%= selectedRestaurant.getAddress() %></div>
                        </div>
                    </div>

                    <div class="image-path">
                        <strong>Restaurant Image Path</strong><br>
                        <%= selectedRestaurant.getImagePath() != null && !selectedRestaurant.getImagePath().trim().isEmpty()
                            ? selectedRestaurant.getImagePath()
                            : "No image path provided" %>
                    </div>

                    <div class="actions">

                        <a
                            href="<%= contextPath %>/editRestaurant?restaurantId=<%= selectedRestaurant.getRestaurantId() %>"
                            class="action-btn edit-btn">
                            Edit Restaurant
                        </a>

                        <a
                            href="<%= contextPath %>/adminMenus?restaurantId=<%= selectedRestaurant.getRestaurantId() %>"
                            class="action-btn menu-btn">
                            Manage Menu
                        </a>

                        <form
                            action="<%= contextPath %>/toggleRestaurantStatus"
                            method="post"
                            class="action-form"
                            onsubmit="return confirm('<%= selectedRestaurant.isActive()
                                ? "Are you sure you want to deactivate this restaurant?"
                                : "Are you sure you want to activate this restaurant?" %>');">

                            <input
                                type="hidden"
                                name="restaurantId"
                                value="<%= selectedRestaurant.getRestaurantId() %>">

                            <button type="submit" class="action-btn status-btn">
                                <%= selectedRestaurant.isActive() ? "Deactivate Restaurant" : "Activate Restaurant" %>
                            </button>
                        </form>

                        <form
                            action="<%= contextPath %>/deleteRestaurant"
                            method="post"
                            class="action-form"
                            onsubmit="return confirm('Are you sure you want to permanently delete this restaurant?');">

                            <input
                                type="hidden"
                                name="restaurantId"
                                value="<%= selectedRestaurant.getRestaurantId() %>">

                            <button type="submit" class="action-btn delete-btn">
                                Delete Restaurant
                            </button>
                        </form>

                    </div>
                </div>
            </div>
        </div>

    <% } else { %>

        <a href="<%= contextPath %>/adminRestaurants" class="back-link">← Back to Restaurant List</a>

        <div class="empty-state">
            <div class="empty-icon">🔎</div>
            <h2>Restaurant Not Found</h2>
            <p>The restaurant may have been deleted or the ID is invalid.</p>
            <a href="<%= contextPath %>/adminRestaurants" class="add-btn">Return to Restaurant List</a>
        </div>

    <% } %>

</main>

<footer>
    © 2026 <span>Foodcorner</span> Admin Panel
</footer>

<script>
const searchInput = document.getElementById("restaurantSearch");

if (searchInput) {
    searchInput.addEventListener("input", function () {
        const query = this.value.trim().toLowerCase();
        const rows = document.querySelectorAll(".restaurant-row");
        let visibleCount = 0;

        rows.forEach(function (row) {
            const text = (row.getAttribute("data-search") || "").toLowerCase();
            const matches = text.includes(query);

            row.style.display = matches ? "" : "none";

            if (matches) {
                visibleCount++;
            }
        });

        const noResults = document.getElementById("noResults");

        if (noResults) {
            noResults.style.display = visibleCount === 0 ? "block" : "none";
        }
    });
}
</script>

</body>
</html>
