<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.util.List" %>
<%@ page import="com.tap.model.Restaurant" %>
<%@ page import="com.tap.model.User" %>
<%@ page import="com.tap.model.Cart" %>
<%
List<Restaurant> restaurants = (List<Restaurant>) request.getAttribute("restaurants");
User loggedInUser = (User) session.getAttribute("user");
Cart cart = (Cart) session.getAttribute("cart");
String searchQuery = (String) request.getAttribute("searchQuery");
if (searchQuery == null) searchQuery = "";
int cartCount = cart == null ? 0 : cart.getTotalQuantity();
String contextPath = request.getContextPath();
%>
<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>Foodcorner | Restaurants</title>
<style>
*{margin:0;padding:0;box-sizing:border-box}body{font-family:Arial,Helvetica,sans-serif;background:#f7f7f7;color:#222}.navbar{background:#fff;padding:15px 6%;display:flex;justify-content:space-between;align-items:center;gap:18px;box-shadow:0 2px 12px rgba(0,0,0,.08);position:sticky;top:0;z-index:1000}.logo{font-size:29px;font-weight:bold;color:#ff5200;text-decoration:none;white-space:nowrap}.logo span{color:#222}.nav-right{display:flex;align-items:center;gap:14px}.nav-link,.cart-link{display:inline-flex;align-items:center;text-decoration:none;color:#444;font-size:14px;font-weight:bold;padding:9px 12px;border-radius:8px}.nav-link:hover,.cart-link:hover{color:#ff5200;background:#fff3ed}.cart-count{display:inline-flex;justify-content:center;align-items:center;min-width:20px;height:20px;padding:0 5px;margin-left:4px;background:#ff5200;color:white;border-radius:20px;font-size:10px}.profile-menu{position:relative}.profile-btn{border:0;background:#ff5200;color:white;padding:10px 14px;border-radius:9px;font-size:13px;font-weight:bold;cursor:pointer;display:flex;align-items:center;gap:7px;max-width:200px}.profile-btn:hover{background:#e94a00}.profile-dropdown{display:none;position:absolute;top:43px;right:0;min-width:200px;background:#fff;border:1px solid #eee;border-radius:10px;box-shadow:0 10px 30px rgba(0,0,0,.15);overflow:hidden;z-index:2000}.profile-menu:hover .profile-dropdown,.profile-menu:focus-within .profile-dropdown{display:block}.profile-dropdown a{display:block;padding:12px 16px;text-decoration:none;color:#333;font-size:13px;font-weight:bold}.profile-dropdown a:hover{background:#fff2eb;color:#ff5200}.profile-dropdown .admin-dashboard-option{color:#ff5200;border-bottom:1px solid #eee}.profile-dropdown .logout-option{color:#d32f2f;border-top:1px solid #eee}.login-btn,.register-btn{display:inline-block;text-decoration:none;font-size:13px;font-weight:bold;padding:9px 14px;border-radius:8px;white-space:nowrap}.login-btn{color:#ff5200;border:1px solid #ff5200}.login-btn:hover{background:#ff5200;color:white}.register-btn{color:white;background:#ff5200}.register-btn:hover{background:#e94a00}.hero{background:linear-gradient(135deg,#fff0e8,#fffaf7);padding:55px 7%}.hero-content{max-width:850px}.hero-badge{display:inline-block;padding:7px 12px;margin-bottom:15px;background:#ff5200;color:white;border-radius:20px;font-size:11px;font-weight:bold}.hero h1{font-size:42px;line-height:1.2;margin-bottom:12px}.hero h1 span{color:#ff5200}.hero p{color:#666;line-height:1.7;font-size:15px;max-width:650px}.container{width:88%;max-width:1350px;margin:40px auto 70px}.section-header{display:flex;justify-content:space-between;align-items:center;gap:20px;margin-bottom:22px}.section-header h2{font-size:28px;margin-bottom:5px}.section-header p{color:#777;font-size:14px}.search-form{display:flex;gap:8px;width:min(100%,520px);margin:0 0 26px}.search-input-wrap{position:relative;flex:1;min-width:0}.search-input{width:100%;height:48px;border:1px solid #ddd;border-radius:10px;padding:0 44px 0 15px;font-size:14px;background:#fff;outline:none}.search-input:focus{border-color:#ff5200;box-shadow:0 0 0 3px rgba(255,82,0,.12)}.clear-search{position:absolute;right:9px;top:50%;transform:translateY(-50%);width:30px;height:30px;border:0;border-radius:50%;background:transparent;color:#777;font-size:20px;cursor:pointer}.clear-search:hover{background:#f3f3f3;color:#ff5200}.search-button{border:0;border-radius:10px;background:#ff5200;color:#fff;padding:0 19px;font-weight:bold;font-size:14px;cursor:pointer}.search-button:hover{background:#e94a00}.search-status{min-height:20px;margin:-15px 0 18px;color:#777;font-size:13px}.restaurant-grid{display:grid;grid-template-columns:repeat(auto-fit,minmax(300px,1fr));gap:25px}.restaurant-card{background:#fff;border:1px solid #eee;border-radius:16px;overflow:hidden;box-shadow:0 4px 15px rgba(0,0,0,.05);transition:transform .25s,box-shadow .25s}.restaurant-card:hover{transform:translateY(-5px);box-shadow:0 12px 30px rgba(0,0,0,.11)}.image-container{width:100%;height:210px;position:relative;background:#eee;overflow:hidden}.restaurant-image{width:100%;height:100%;object-fit:cover;display:block}.image-placeholder{width:100%;height:100%;display:flex;flex-direction:column;justify-content:center;align-items:center;background:linear-gradient(135deg,#fff1e9,#eee);color:#888;gap:8px}.placeholder-icon{font-size:45px}.open-status{position:absolute;top:12px;left:12px;padding:7px 11px;border-radius:20px;font-size:10px;font-weight:bold}.status-open{background:#dff5e5;color:#147a35}.status-closed{background:#ffe2e2;color:#b42318}.rating-badge{position:absolute;top:12px;right:12px;background:rgba(0,0,0,.78);color:white;padding:7px 10px;border-radius:7px;font-size:12px;font-weight:bold}.card-body{padding:20px}.restaurant-name{font-size:21px;font-weight:bold;margin-bottom:7px;overflow-wrap:anywhere}.cuisine{color:#ff5200;font-size:13px;font-weight:bold;margin-bottom:13px}.restaurant-details{display:flex;flex-direction:column;gap:9px;margin-bottom:18px}.detail{display:flex;align-items:flex-start;gap:8px;color:#666;font-size:13px;line-height:1.5}.detail-icon{min-width:18px}.view-menu-btn,.closed-btn{display:block;width:100%;text-align:center;padding:12px 15px;border-radius:9px;font-size:14px;font-weight:bold}.view-menu-btn{text-decoration:none;background:#ff5200;color:white;transition:background .2s}.view-menu-btn:hover{background:#e94a00}.closed-btn{background:#eee;color:#999;cursor:not-allowed}.empty-state{background:white;border:1px solid #eee;border-radius:16px;padding:70px 25px;text-align:center}.empty-icon{font-size:55px;margin-bottom:15px}.empty-state h2{margin-bottom:9px}.empty-state p{color:#777;line-height:1.6}.reset-search{display:inline-block;margin-top:18px;color:#ff5200;font-weight:bold;text-decoration:none}.reset-search:hover{text-decoration:underline}footer{background:#181818;color:#ccc;text-align:center;padding:28px;font-size:13px}footer span{color:#ff5200}.loading{opacity:.6;pointer-events:none}@media(max-width:850px){.hero h1{font-size:34px}.section-header{flex-direction:column;align-items:flex-start}}@media(max-width:700px){.navbar{padding:13px 4%;gap:8px}.logo{font-size:23px}.nav-right{gap:5px}.nav-link{display:none}.login-btn,.register-btn{padding:8px 9px}.profile-btn{padding:9px 10px;max-width:130px;overflow:hidden;white-space:nowrap}.hero{padding:40px 5%}.hero h1{font-size:30px}.container{width:92%}.restaurant-grid{grid-template-columns:1fr}.search-form{gap:6px}.search-button{padding:0 13px}.section-header h2{font-size:25px}}@media(max-width:420px){.cart-link{padding:8px 5px}.profile-btn{max-width:100px}.register-btn{display:none}.search-button{font-size:13px;padding:0 10px}}
</style>
</head>
<body>
<nav class="navbar">
<a href="<%= contextPath %>/restaurant" class="logo">Food<span>corner</span></a>
<div class="nav-right">
<a href="<%= contextPath %>/restaurant" class="nav-link">Restaurants</a>
<a href="<%= contextPath %>/cart" class="cart-link">🛒 Cart <% if (cartCount > 0) { %><span class="cart-count"><%= cartCount %></span><% } %></a>
<% if (loggedInUser != null) { %>
<div class="profile-menu">
<button type="button" class="profile-btn">👤 <%= loggedInUser.getUsername() %> <span>▼</span></button>
<div class="profile-dropdown">
<% if (loggedInUser.getRole() != null && "ADMIN".equalsIgnoreCase(loggedInUser.getRole())) { %><a href="<%= contextPath %>/adminDashboard" class="admin-dashboard-option">⚙ Admin Dashboard</a><% } %>
<a href="<%= contextPath %>/myOrders">📦 My Orders</a>
<a href="<%= contextPath %>/editProfile">👤 Edit Profile</a>
<a href="<%= contextPath %>/logout" class="logout-option">Logout</a>
</div>
</div>
<% } else { %>
<a href="<%= contextPath %>/login.jsp" class="login-btn">Login</a>
<a href="<%= contextPath %>/register.jsp" class="register-btn">Register</a>
<% } %>
</div>
</nav>
<section class="hero">
<div class="hero-content">
<div class="hero-badge">FOODCORNER</div>
<% if (loggedInUser != null) { %>
<h1>Hello, <span><%= loggedInUser.getUsername() %></span> 👋</h1>
<p>Discover your favourite restaurants, explore delicious menus and order food directly from Foodcorner.</p>
<% } else { %>
<h1>Delicious food, <span>delivered to you.</span></h1>
<p>Browse restaurants, discover your favourite meals and enjoy a simple Foodcorner ordering experience.</p>
<% } %>
</div>
</section>
<main class="container">
<div class="section-header">
<div><h2>Popular Restaurants</h2><p>Search for a restaurant or a dish to find your next meal.</p></div>
</div>
<form class="search-form" id="restaurantSearchForm" action="<%= contextPath %>/restaurant" method="get" role="search">
<div class="search-input-wrap">
<input class="search-input" id="searchInput" type="search" name="search" value="<%= searchQuery.replace("&", "&amp;").replace("\"", "&quot;").replace("<", "&lt;").replace(">", "&gt;") %>" placeholder="Search restaurants or dishes..." autocomplete="off" aria-label="Search restaurants or dishes">
<button class="clear-search" id="clearSearch" type="button" aria-label="Clear search" title="Clear search">×</button>
</div>
<button class="search-button" type="submit">Search</button>
</form>
<div class="search-status" id="searchStatus" aria-live="polite"><% if (!searchQuery.isEmpty()) { %>Search results for “<%= searchQuery.replace("&", "&amp;").replace("\"", "&quot;").replace("<", "&lt;").replace(">", "&gt;") %>”<% } %></div>
<div id="restaurantResults">
<% if (restaurants != null && !restaurants.isEmpty()) { %>
<div class="restaurant-grid" id="restaurantGrid">
<% for (Restaurant restaurant : restaurants) {
String imagePath = restaurant.getImagePath();
String imageUrl = null;
if (imagePath != null && !imagePath.trim().isEmpty()) {
imagePath = imagePath.trim();
if (imagePath.startsWith("http://") || imagePath.startsWith("https://") || imagePath.startsWith("//")) {
imageUrl = imagePath;
} else if (imagePath.startsWith(contextPath + "/")) {
imageUrl = imagePath;
} else if (imagePath.startsWith("/")) {
imageUrl = contextPath + imagePath;
} else {
imageUrl = contextPath + "/" + imagePath;
}
}
String safeName = restaurant.getName() == null ? "Restaurant" : restaurant.getName().replace("&", "&amp;").replace("\"", "&quot;").replace("<", "&lt;").replace(">", "&gt;");
%>
<div class="restaurant-card">
<div class="image-container">
<% if (imageUrl != null) { %>
<img src="<%= imageUrl.replace("&", "&amp;").replace("\"", "&quot;").replace("<", "&lt;").replace(">", "&gt;") %>" alt="<%= safeName %>" class="restaurant-image" onerror="this.style.display='none';this.nextElementSibling.style.display='flex';">
<div class="image-placeholder" style="display:none"><div class="placeholder-icon">🍽️</div><div>Image not available</div></div>
<% } else { %>
<div class="image-placeholder"><div class="placeholder-icon">🍽️</div><div>Restaurant Image</div></div>
<% } %>
<span class="open-status <%= restaurant.isActive() ? "status-open" : "status-closed" %>"><%= restaurant.isActive() ? "OPEN" : "CLOSED" %></span>
<span class="rating-badge">⭐ <%= restaurant.getRating() %></span>
</div>
<div class="card-body">
<div class="restaurant-name"><%= safeName %></div>
<div class="cuisine"><%= restaurant.getCuisineType() == null ? "Cuisine" : restaurant.getCuisineType() %></div>
<div class="restaurant-details">
<div class="detail"><span class="detail-icon">🕒</span><span>Delivery: <%= restaurant.getDeliveryTime() == null ? "Not specified" : restaurant.getDeliveryTime() %></span></div>
<div class="detail"><span class="detail-icon">📍</span><span><%= restaurant.getAddress() == null ? "Address not available" : restaurant.getAddress() %></span></div>
</div>
<% if (restaurant.isActive()) { %>
<a href="<%= contextPath %>/menu?restaurantId=<%= restaurant.getRestaurantId() %>" class="view-menu-btn">View Menu →</a>
<% } else { %>
<div class="closed-btn">Restaurant Currently Closed</div>
<% } %>
</div>
</div>
<% } %>
</div>
<% } else { %>
<div class="empty-state" id="emptyState"><div class="empty-icon">🍽️</div><h2><%= searchQuery.isEmpty() ? "No Restaurants Available" : "No Matching Restaurants" %></h2><p><%= searchQuery.isEmpty() ? "Restaurants will appear here when they are added to Foodcorner." : "Try another restaurant name or dish." %></p><% if (!searchQuery.isEmpty()) { %><a class="reset-search" href="<%= contextPath %>/restaurant">Clear search</a><% } %></div>
<% } %>
</div>
</main>
<footer>© 2026 <span>Foodcorner</span> — Food Delivery Website</footer>
<script>
(function () {
    const contextPath = '<%= contextPath.replace("\\", "\\\\").replace("'", "\\'") %>';
    const form = document.getElementById('restaurantSearchForm');
    const input = document.getElementById('searchInput');
    const clearButton = document.getElementById('clearSearch');
    const results = document.getElementById('restaurantResults');
    const status = document.getElementById('searchStatus');
    let debounceTimer;
    let activeController;
    let latestRequest = 0;

    function makeElement(tag, className, text) {
        const element = document.createElement(tag);
        if (className) element.className = className;
        if (text !== undefined && text !== null) element.textContent = text;
        return element;
    }

    function buildImageUrl(path) {
        if (!path) return '';
        const value = String(path).trim();
        if (!value) return '';
        if (/^(https?:)?\/\//i.test(value)) return value;
        if (value.startsWith(contextPath + '/')) return value;
        if (value.startsWith('/')) return contextPath + value;
        return contextPath + '/' + value;
    }

    function makeCard(restaurant) {
        const card = makeElement('article', 'restaurant-card');
        const imageContainer = makeElement('div', 'image-container');
        const imageUrl = buildImageUrl(restaurant.imagePath);
        if (imageUrl) {
            const image = makeElement('img', 'restaurant-image');
            image.src = imageUrl;
            image.alt = restaurant.name || 'Restaurant';
            image.addEventListener('error', function () {
                image.style.display = 'none';
                const placeholder = makeElement('div', 'image-placeholder');
                placeholder.append(makeElement('div', 'placeholder-icon', '🍽️'));
                placeholder.append(makeElement('div', '', 'Image not available'));
                imageContainer.insertBefore(placeholder, imageContainer.firstChild);
            }, { once: true });
            imageContainer.append(image);
        } else {
            const placeholder = makeElement('div', 'image-placeholder');
            placeholder.append(makeElement('div', 'placeholder-icon', '🍽️'));
            placeholder.append(makeElement('div', '', 'Restaurant Image'));
            imageContainer.append(placeholder);
        }

        const isActive = restaurant.isActive === true || restaurant.isActive === 'true';
        imageContainer.append(makeElement('span', 'open-status ' + (isActive ? 'status-open' : 'status-closed'), isActive ? 'OPEN' : 'CLOSED'));
        const rating = Number(restaurant.rating);
        imageContainer.append(makeElement('span', 'rating-badge', '⭐ ' + (Number.isFinite(rating) ? rating : '0')));
        card.append(imageContainer);

        const body = makeElement('div', 'card-body');
        body.append(makeElement('div', 'restaurant-name', restaurant.name || 'Restaurant'));
        body.append(makeElement('div', 'cuisine', restaurant.cuisineType || 'Cuisine'));
        const details = makeElement('div', 'restaurant-details');
        const delivery = makeElement('div', 'detail');
        delivery.append(makeElement('span', 'detail-icon', '🕒'));
        delivery.append(makeElement('span', '', 'Delivery: ' + (restaurant.deliveryTime || 'Not specified')));
        details.append(delivery);
        const address = makeElement('div', 'detail');
        address.append(makeElement('span', 'detail-icon', '📍'));
        address.append(makeElement('span', '', restaurant.address || 'Address not available'));
        details.append(address);
        body.append(details);

        if (isActive) {
            const menuLink = makeElement('a', 'view-menu-btn', 'View Menu →');
            menuLink.href = contextPath + '/menu?restaurantId=' + encodeURIComponent(restaurant.restaurantId);
            body.append(menuLink);
        } else {
            body.append(makeElement('div', 'closed-btn', 'Restaurant Currently Closed'));
        }
        card.append(body);
        return card;
    }

    function renderRestaurants(list, query) {
        results.replaceChildren();
        if (Array.isArray(list) && list.length > 0) {
            const grid = makeElement('div', 'restaurant-grid');
            grid.id = 'restaurantGrid';
            list.forEach(function (restaurant) { grid.append(makeCard(restaurant)); });
            results.append(grid);
            status.textContent = query ? 'Found ' + list.length + ' matching restaurant' + (list.length === 1 ? '' : 's') + ' for “' + query + '”.' : 'Showing all restaurants.';
        } else {
            const empty = makeElement('div', 'empty-state');
            empty.append(makeElement('div', 'empty-icon', '🍽️'));
            empty.append(makeElement('h2', '', query ? 'No Matching Restaurants' : 'No Restaurants Available'));
            empty.append(makeElement('p', '', query ? 'Try another restaurant name or dish.' : 'Restaurants will appear here when they are added to Foodcorner.'));
            if (query) {
                const reset = makeElement('a', 'reset-search', 'Clear search');
                reset.href = contextPath + '/restaurant';
                reset.addEventListener('click', function (event) { event.preventDefault(); input.value = ''; searchRestaurants(''); input.focus(); });
                empty.append(reset);
            }
            results.append(empty);
            status.textContent = query ? 'No results for “' + query + '”.' : 'No restaurants to display.';
        }
    }

    async function searchRestaurants(rawQuery) {
        const query = rawQuery.trim();
        const requestId = ++latestRequest;
        if (activeController) activeController.abort();
        activeController = new AbortController();
        results.classList.add('loading');
        status.textContent = query ? 'Searching restaurants and dishes…' : 'Loading restaurants…';
        try {
            const url = contextPath + '/restaurant?search=' + encodeURIComponent(query) + '&ajax=true';
            const response = await fetch(url, { headers: { 'Accept': 'application/json' }, signal: activeController.signal });
            if (!response.ok) throw new Error('Search request failed');
            const data = await response.json();
            if (requestId !== latestRequest) return;
            if (!Array.isArray(data)) throw new Error('Unexpected search response');
            renderRestaurants(data, query);
            const nextUrl = contextPath + '/restaurant' + (query ? '?search=' + encodeURIComponent(query) : '');
            window.history.replaceState({}, '', nextUrl);
        } catch (error) {
            if (error.name !== 'AbortError' && requestId === latestRequest) {
                status.textContent = 'Search could not be completed. Press Enter to retry.';
            }
        } finally {
            if (requestId === latestRequest) results.classList.remove('loading');
        }
    }

    form.addEventListener('submit', function (event) {
        event.preventDefault();
        clearTimeout(debounceTimer);
        searchRestaurants(input.value);
    });

    input.addEventListener('input', function () {
        clearTimeout(debounceTimer);
        debounceTimer = setTimeout(function () { searchRestaurants(input.value); }, 300);
    });

    clearButton.addEventListener('click', function () {
        input.value = '';
        clearTimeout(debounceTimer);
        searchRestaurants('');
        input.focus();
    });
})();
</script>
</body>
</html>
