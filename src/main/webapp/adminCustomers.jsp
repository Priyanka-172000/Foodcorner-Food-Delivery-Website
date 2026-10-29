
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List" %>
<%@ page import="com.tap.model.User" %>

<%!
private String escapeHtml(Object value) {
    if (value == null) {
        return "";
    }

    String text = String.valueOf(value);
    return text.replace("&", "&amp;")
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

if (admin == null || admin.getRole() == null
        || !"ADMIN".equalsIgnoreCase(admin.getRole())) {
    response.sendRedirect(request.getContextPath() + "/login.jsp");
    return;
}

List<User> customers = (List<User>) request.getAttribute("customers");

String viewId = request.getParameter("viewId");
User selectedCustomer = null;

if (viewId != null && customers != null) {
    try {
        int selectedId = Integer.parseInt(viewId);

        for (User customer : customers) {
            if (customer.getUserId() == selectedId) {
                selectedCustomer = customer;
                break;
            }
        }
    } catch (NumberFormatException e) {
        selectedCustomer = null;
    }
}
%>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>Foodcorner | Manage Customers</title>

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
    box-shadow: 0 2px 12px rgba(0,0,0,0.08);
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
    padding: 9px 14px;
    border-radius: 8px;
    font-size: 13px;
    font-weight: bold;
    transition: 0.2s;
}

.dashboard-btn {
    color: #ff5200;
    background: white;
    border: 1px solid #ff5200;
}

.dashboard-btn:hover {
    background: #ff5200;
    color: white;
}

.website-btn {
    color: #444;
    border: 1px solid #ddd;
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

.page-header {
    padding: 38px 7%;
    background: linear-gradient(135deg, #fff0e8, #fff9f6);
}

.header-content {
    max-width: 1350px;
    margin: auto;
}

.page-header h1 {
    font-size: 34px;
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

.container {
    width: 88%;
    max-width: 1350px;
    margin: 32px auto 65px;
}

.summary-bar {
    background: white;
    border: 1px solid #eee;
    border-radius: 12px;
    padding: 18px 20px;
    margin-bottom: 20px;
    display: flex;
    justify-content: space-between;
    align-items: center;
    gap: 15px;
    flex-wrap: wrap;
}

.customer-count {
    color: #666;
    font-size: 14px;
}

.customer-count strong {
    color: #ff5200;
    font-size: 19px;
}

.read-only {
    background: #edf7ff;
    color: #1769aa;
    padding: 7px 12px;
    border-radius: 20px;
    font-size: 11px;
    font-weight: bold;
}

.search-panel {
    display: flex;
    gap: 12px;
    margin-bottom: 18px;
}

.search-input {
    flex: 1;
    min-width: 0;
    padding: 13px 15px;
    border: 1px solid #ddd;
    border-radius: 9px;
    background: white;
    font-size: 14px;
    outline: none;
}

.search-input:focus {
    border-color: #ff5200;
    box-shadow: 0 0 0 3px rgba(255,82,0,0.1);
}

.clear-btn {
    border: 1px solid #ddd;
    background: white;
    color: #444;
    padding: 0 17px;
    border-radius: 9px;
    font-weight: bold;
    cursor: pointer;
}

.clear-btn:hover {
    background: #f2f2f2;
}

.table-wrapper {
    background: white;
    border: 1px solid #eee;
    border-radius: 13px;
    overflow-x: auto;
    box-shadow: 0 4px 15px rgba(0,0,0,0.04);
}

table {
    width: 100%;
    border-collapse: collapse;
    min-width: 760px;
}

thead {
    background: #fff5ef;
}

th {
    color: #555;
    font-size: 12px;
    text-transform: uppercase;
    letter-spacing: 0.4px;
    text-align: left;
    padding: 16px 18px;
    white-space: nowrap;
}

td {
    padding: 16px 18px;
    border-top: 1px solid #f0f0f0;
    font-size: 13px;
    color: #444;
}

tbody tr:hover {
    background: #fffaf7;
}

.customer-name {
    color: #222;
    font-weight: bold;
}

.customer-id {
    color: #888;
    font-size: 12px;
}

.view-btn {
    display: inline-block;
    background: #ff5200;
    color: white;
    text-decoration: none;
    padding: 9px 13px;
    border-radius: 7px;
    font-size: 12px;
    font-weight: bold;
    white-space: nowrap;
}

.view-btn:hover {
    background: #e84900;
}

.empty-state {
    background: white;
    border: 1px solid #eee;
    border-radius: 14px;
    padding: 55px 25px;
    text-align: center;
}

.empty-icon {
    font-size: 45px;
    margin-bottom: 12px;
}

.empty-state h2 {
    font-size: 22px;
    margin-bottom: 9px;
}

.empty-state p {
    color: #777;
    font-size: 14px;
    line-height: 1.6;
}

.detail-card {
    background: white;
    border: 1px solid #eee;
    border-radius: 15px;
    overflow: hidden;
    box-shadow: 0 4px 18px rgba(0,0,0,0.05);
}

.detail-top {
    padding: 24px;
    background: #fff5ef;
    display: flex;
    align-items: center;
    gap: 17px;
    border-bottom: 1px solid #eee;
}

.avatar {
    width: 58px;
    height: 58px;
    flex-shrink: 0;
    border-radius: 50%;
    display: flex;
    align-items: center;
    justify-content: center;
    background: #ff5200;
    color: white;
    font-size: 23px;
    font-weight: bold;
}

.detail-top h2 {
    font-size: 22px;
    margin-bottom: 5px;
    overflow-wrap: anywhere;
}

.detail-top p {
    color: #777;
    font-size: 13px;
}

.detail-body {
    padding: 20px 25px;
}

.detail-row {
    display: flex;
    justify-content: space-between;
    align-items: flex-start;
    gap: 20px;
    padding: 15px 0;
    border-bottom: 1px solid #f0f0f0;
}

.detail-row:last-child {
    border-bottom: none;
}

.detail-label {
    color: #888;
    font-size: 13px;
}

.detail-value {
    max-width: 65%;
    text-align: right;
    color: #333;
    font-size: 14px;
    font-weight: bold;
    overflow-wrap: anywhere;
}

.email {
    color: #ff5200;
}

.role {
    display: inline-block;
    background: #e6f7eb;
    color: #147a35;
    padding: 6px 10px;
    border-radius: 20px;
    font-size: 11px;
}

.detail-note {
    margin: 0 25px 22px;
    padding: 13px;
    border: 1px solid #eee;
    border-radius: 8px;
    background: #fafafa;
    color: #777;
    font-size: 12px;
    line-height: 1.6;
}

.detail-actions {
    display: flex;
    gap: 10px;
    flex-wrap: wrap;
    margin-bottom: 20px;
}

.back-btn {
    display: inline-block;
    text-decoration: none;
    padding: 11px 15px;
    border-radius: 8px;
    background: white;
    border: 1px solid #ddd;
    color: #444;
    font-size: 13px;
    font-weight: bold;
}

.back-btn:hover {
    background: #f2f2f2;
}

.result-count {
    color: #777;
    font-size: 12px;
    margin: 0 0 12px 2px;
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

@media (max-width: 700px) {
    .navbar {
        padding: 14px 4%;
    }

    .logo {
        font-size: 23px;
    }

    .admin-name,
    .website-btn {
        display: none;
    }

    .nav-right {
        gap: 7px;
    }

    .nav-btn {
        padding: 9px 10px;
    }

    .page-header {
        padding: 30px 5%;
    }

    .page-header h1 {
        font-size: 28px;
    }

    .container {
        width: 92%;
    }

    .detail-body {
        padding: 15px 20px;
    }

    .detail-row {
        flex-direction: column;
        gap: 7px;
    }

    .detail-value {
        max-width: 100%;
        text-align: left;
    }

    .detail-note {
        margin: 0 20px 20px;
    }
}
</style>
</head>

<body>

<nav class="navbar">
    <div class="logo">Food<span>corner</span></div>

    <div class="nav-right">
        <span class="admin-name">👤 <%= escapeHtml(admin.getUsername()) %></span>

        <a href="<%= request.getContextPath() %>/adminDashboard"
           class="nav-btn dashboard-btn">Dashboard</a>

        <a href="<%= request.getContextPath() %>/restaurant"
           class="nav-btn website-btn">Visit Website</a>

        <a href="<%= request.getContextPath() %>/logout"
           class="nav-btn logout-btn">Logout</a>
    </div>
</nav>

<section class="page-header">
    <div class="header-content">
        <h1>Manage <span>Customers</span></h1>
        <p>Search registered customers and open an individual profile to view their contact and delivery information.</p>
    </div>
</section>

<main class="container">

    <% if (selectedCustomer != null) {
        String username = selectedCustomer.getUsername();
        String initial = (username != null && !username.trim().isEmpty())
                ? username.trim().substring(0, 1).toUpperCase()
                : "C";
    %>

    <div class="detail-actions">
        <a class="back-btn" href="<%= request.getContextPath() %>/adminCustomers">← Back to Customer List</a>
    </div>

    <section class="detail-card">
        <div class="detail-top">
            <div class="avatar"><%= escapeHtml(initial) %></div>
            <div>
                <h2><%= escapeHtml(selectedCustomer.getUsername()) %></h2>
                <p>Customer ID: <%= selectedCustomer.getUserId() %></p>
            </div>
        </div>

        <div class="detail-body">
            <div class="detail-row">
                <span class="detail-label">Customer ID</span>
                <span class="detail-value"><%= selectedCustomer.getUserId() %></span>
            </div>

            <div class="detail-row">
                <span class="detail-label">Full Name</span>
                <span class="detail-value"><%= escapeHtml(selectedCustomer.getUsername()) %></span>
            </div>

            <div class="detail-row">
                <span class="detail-label">Email Address</span>
                <span class="detail-value email"><%= escapeHtml(selectedCustomer.getEmail()) %></span>
            </div>

            <div class="detail-row">
                <span class="detail-label">Phone Number</span>
                <span class="detail-value"><%= escapeHtml(selectedCustomer.getPhone()) %></span>
            </div>

            <div class="detail-row">
                <span class="detail-label">Delivery Address</span>
                <span class="detail-value"><%= escapeHtml(selectedCustomer.getAddress()) %></span>
            </div>

            <div class="detail-row">
                <span class="detail-label">Account Role</span>
                <span class="detail-value"><span class="role"><%= escapeHtml(selectedCustomer.getRole()) %></span></span>
            </div>
        </div>

        <div class="detail-note">
            Customer profile details are displayed in read-only mode. Customers can update their own profile from their account.
        </div>
    </section>

    <% } else { %>

    <div class="summary-bar">
        <div class="customer-count">
            Total Customers:
            <strong><%= customers != null ? customers.size() : 0 %></strong>
        </div>
        <div class="read-only">VIEW ONLY</div>
    </div>

    <div class="search-panel">
        <input type="text" id="customerSearch" class="search-input"
               placeholder="Search by customer ID, name, email or phone..."
               aria-label="Search customers">
        <button type="button" class="clear-btn" onclick="clearSearch()">Clear</button>
    </div>

    <% if (customers != null && !customers.isEmpty()) { %>

    <div class="result-count" id="resultCount"></div>

    <div class="table-wrapper">
        <table>
            <thead>
                <tr>
                    <th>Customer ID</th>
                    <th>Name</th>
                    <th>Email</th>
                    <th>Phone</th>
                    <th>Action</th>
                </tr>
            </thead>

            <tbody id="customerTableBody">
                <% for (User customer : customers) {
                    String searchText =
                            String.valueOf(customer.getUserId()) + " " +
                            (customer.getUsername() == null ? "" : customer.getUsername()) + " " +
                            (customer.getEmail() == null ? "" : customer.getEmail()) + " " +
                            (customer.getPhone() == null ? "" : customer.getPhone());
                %>

                <tr class="customer-row"
                    data-search="<%= escapeHtml(searchText).toLowerCase() %>">
                    <td><span class="customer-id">#<%= customer.getUserId() %></span></td>

                    <td>
                        <span class="customer-name"><%= escapeHtml(customer.getUsername()) %></span>
                    </td>

                    <td><%= escapeHtml(customer.getEmail()) %></td>

                    <td><%= escapeHtml(customer.getPhone()) %></td>

                    <td>
                        <a class="view-btn"
                           href="<%= request.getContextPath() %>/adminCustomers?viewId=<%= customer.getUserId() %>">
                            View Details
                        </a>
                    </td>
                </tr>

                <% } %>
            </tbody>
        </table>
    </div>

    <div class="empty-state" id="noSearchResults" style="display:none; margin-top:18px;">
        <div class="empty-icon">🔎</div>
        <h2>No Matching Customers</h2>
        <p>Try searching with a different ID, name, email or phone number.</p>
    </div>

    <% } else { %>

    <div class="empty-state">
        <div class="empty-icon">👥</div>
        <h2>No Customers Found</h2>
        <p>Registered customers will appear here once available.</p>
    </div>

    <% } %>

    <% } %>

</main>

<footer>
    © 2026 <span>Foodcorner</span> Admin Panel
</footer>

<script>
const searchInput = document.getElementById("customerSearch");

if (searchInput) {
    const rows = Array.from(document.querySelectorAll(".customer-row"));
    const resultCount = document.getElementById("resultCount");
    const noResults = document.getElementById("noSearchResults");

    function filterCustomers() {
        const query = searchInput.value.trim().toLowerCase();
        let visibleCount = 0;

        rows.forEach(function(row) {
            const matches = row.dataset.search.includes(query);
            row.style.display = matches ? "" : "none";

            if (matches) {
                visibleCount++;
            }
        });

        resultCount.textContent =
            "Showing " + visibleCount + " of " + rows.length + " customers";

        noResults.style.display = visibleCount === 0 ? "block" : "none";
    }

    searchInput.addEventListener("input", filterCustomers);
    filterCustomers();
}

function clearSearch() {
    if (searchInput) {
        searchInput.value = "";
        searchInput.dispatchEvent(new Event("input"));
        searchInput.focus();
    }
}
</script>

</body>
</html>
