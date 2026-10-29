
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.util.Locale" %>
<%@ page import="com.tap.model.Cart" %>
<%@ page import="com.tap.model.CartItem" %>
<%@ page import="com.tap.model.User" %>

<%!
    private String escapeHtml(String value) {
        if (value == null) return "";
        return value.replace("&", "&amp;")
                    .replace("<", "&lt;")
                    .replace(">", "&gt;")
                    .replace("\"", "&quot;")
                    .replace("'", "&#39;");
    }

    private String imageUrl(String imagePath, String contextPath) {
        if (imagePath == null || imagePath.trim().isEmpty()) return null;

        String path = imagePath.trim();

        if (path.startsWith("https://") || path.startsWith("http://")) return path;

        if (path.startsWith("//") || path.contains(":") || path.contains("..")) return null;

        while (path.startsWith("/")) {
            path = path.substring(1);
        }

        if (path.isEmpty()) return null;

        if (!contextPath.isEmpty() &&
                path.startsWith(contextPath.substring(1) + "/")) {
            path = path.substring(contextPath.length());
        }

        return contextPath + "/" + path;
    }
%>

<%
    Cart cart = (Cart) session.getAttribute("cart");
    User loggedInUser = (User) session.getAttribute("user");

    String context = request.getContextPath();

    boolean hasItems = cart != null && !cart.isEmpty();

    int restaurantId = 0;
    int totalItems = hasItems ? cart.getTotalQuantity() : 0;
    double totalAmount = hasItems ? cart.getTotalAmount() : 0;

    if (hasItems) {
        CartItem first = cart.getItems().iterator().next();
        restaurantId = first.getRestaurantId();
    }
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">

    <title>Foodcorner | Cart</title>

    <style>
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }

        [hidden] {
            display: none !important;
        }

        body {
            font-family: Arial, Helvetica, sans-serif;
            background: #f7f7f7;
            color: #1f1f1f;
        }

        .navbar {
            width: 100%;
            min-height: 82px;
            display: flex;
            justify-content: space-between;
            align-items: center;
            gap: 14px;
            padding: 15px 7%;
            background: #fff;
            box-shadow: 0 2px 12px rgba(0,0,0,.07);
            position: sticky;
            top: 0;
            z-index: 1000;
        }

        .logo {
            text-decoration: none;
            font-size: 29px;
            font-weight: 800;
            color: #ff5200;
        }

        .logo span {
            color: #222;
        }

        .nav-right {
            display: flex;
            align-items: center;
            gap: 15px;
        }

        .profile-name {
            color: #444;
            font-size: 14px;
            font-weight: bold;
        }

        .cart-hero {
            padding: 42px 7%;
            background: linear-gradient(135deg, #fff0e8, #fffaf7);
        }

        .cart-hero h1 {
            font-size: 38px;
            margin-bottom: 10px;
        }

        .cart-hero h1 span {
            color: #ff5200;
        }

        .cart-hero p {
            color: #666;
            font-size: 16px;
            line-height: 1.6;
        }

        .cart-container {
            width: 86%;
            max-width: 1450px;
            margin: 55px auto 80px;
            display: grid;
            grid-template-columns: minmax(0,2fr) minmax(310px,1fr);
            gap: 40px;
            align-items: start;
        }

        .cart-items-section {
            display: flex;
            flex-direction: column;
            gap: 20px;
            min-width: 0;
        }

        .cart-item {
            background: #fff;
            border: 1px solid #e9e9e9;
            border-radius: 20px;
            padding: 22px;
            display: flex;
            gap: 24px;
            align-items: center;
            box-shadow: 0 4px 18px rgba(0,0,0,.04);
            min-width: 0;
        }

        .item-image-container {
            width: 180px;
            height: 150px;
            flex-shrink: 0;
            border-radius: 15px;
            overflow: hidden;
            background: #eee;
        }

        .item-image {
            width: 100%;
            height: 100%;
            object-fit: cover;
            display: block;
        }

        .image-placeholder {
            width: 100%;
            height: 100%;
            display: flex;
            justify-content: center;
            align-items: center;
            background: linear-gradient(135deg,#fff0e8,#eee);
            font-size: 44px;
        }

        .item-info {
            flex: 1;
            min-width: 0;
        }

        .item-name {
            font-size: 23px;
            font-weight: 800;
            color: #171717;
            margin-bottom: 9px;
            overflow-wrap: anywhere;
        }

        .item-price {
            font-size: 20px;
            font-weight: 800;
            color: #ff5200;
            margin-bottom: 10px;
        }

        .item-subtotal {
            color: #555;
            font-size: 15px;
            margin-bottom: 18px;
        }

        .quantity-area {
            display: flex;
            align-items: center;
            flex-wrap: wrap;
            gap: 12px;
        }

        .quantity-label {
            font-size: 15px;
            font-weight: 700;
            color: #222;
        }

        .quantity-box {
            display: flex;
            align-items: center;
            border: 1px solid #ddd;
            border-radius: 12px;
            overflow: hidden;
            background: #fff;
        }

        .quantity-btn {
            width: 48px;
            height: 46px;
            border: 0;
            background: #fff;
            color: #ff5200;
            font-size: 26px;
            font-weight: bold;
            cursor: pointer;
        }

        .quantity-btn:hover {
            background: #fff1e9;
        }

        .quantity-value {
            min-width: 48px;
            height: 46px;
            display: flex;
            justify-content: center;
            align-items: center;
            border-left: 1px solid #eee;
            border-right: 1px solid #eee;
            font-size: 18px;
            font-weight: 700;
        }

        .remove-btn {
            border: 0;
            background: transparent;
            color: #c62828;
            font-size: 14px;
            font-weight: 700;
            padding: 10px 12px;
            cursor: pointer;
            border-radius: 8px;
        }

        .remove-btn:hover {
            background: #fff0f0;
        }

        button:disabled {
            opacity: .55;
            cursor: wait;
        }

        .order-summary {
            background: #fff;
            border: 1px solid #e9e9e9;
            border-radius: 20px;
            padding: 30px;
            box-shadow: 0 4px 18px rgba(0,0,0,.04);
            position: sticky;
            top: 105px;
        }

        .order-summary h2 {
            font-size: 27px;
            margin-bottom: 22px;
        }

        .summary-row {
            min-height: 48px;
            display: flex;
            justify-content: space-between;
            align-items: center;
            gap: 20px;
            font-size: 16px;
            color: #444;
        }

        .summary-row strong {
            color: #151515;
            white-space: nowrap;
        }

        .summary-divider {
            height: 1px;
            background: #ddd;
            margin: 13px 0;
        }

        .total-row {
            min-height: 62px;
            font-size: 22px;
            font-weight: 800;
            color: #151515;
        }

        .total-amount {
            color: #ff5200;
            font-size: 25px;
            font-weight: 800;
            white-space: nowrap;
        }

        .checkout-btn {
            width: 100%;
            min-height: 55px;
            margin-top: 18px;
            padding: 14px 18px;
            display: flex;
            justify-content: center;
            align-items: center;
            background: #ff5200;
            color: #fff;
            border: 0;
            border-radius: 11px;
            text-decoration: none;
            text-align: center;
            font-size: 16px;
            font-weight: 800;
        }

        .checkout-btn:hover {
            background: #e94a00;
        }

        .clear-cart-btn {
            width: 100%;
            min-height: 52px;
            margin-top: 12px;
            border: 1px solid #ddd;
            border-radius: 11px;
            background: #fff;
            color: #444;
            font-size: 15px;
            font-weight: 700;
            cursor: pointer;
        }

        .clear-cart-btn:hover {
            color: #ff5200;
            border-color: #ff5200;
            background: #fff4ee;
        }

        .continue-shopping {
            display: flex;
            align-items: center;
            justify-content: center;
            margin-top: 12px;
            width: 100%;
            text-decoration: none;
            color: #ff5200;
            font-size: 14px;
            font-weight: 700;
            padding: 12px;
            border-radius: 9px;
        }

        .continue-shopping:hover {
            background: #fff0e8;
        }

        .empty-cart {
            width: 86%;
            max-width: 950px;
            margin: 70px auto;
            background: #fff;
            border: 1px solid #eee;
            border-radius: 20px;
            padding: 80px 30px;
            text-align: center;
            box-shadow: 0 5px 20px rgba(0,0,0,.05);
        }

        .empty-cart-icon {
            font-size: 70px;
            margin-bottom: 20px;
        }

        .empty-cart h2 {
            font-size: 30px;
            margin-bottom: 12px;
        }

        .empty-cart p {
            color: #777;
            margin-bottom: 25px;
            line-height: 1.6;
        }

        .start-order-btn {
            display: inline-block;
            padding: 14px 25px;
            background: #ff5200;
            color: #fff;
            text-decoration: none;
            border-radius: 10px;
            font-weight: bold;
        }

        .start-order-btn:hover {
            background: #e94a00;
        }

        .toast {
            position: fixed;
            left: 50%;
            bottom: 25px;
            transform: translateX(-50%);
            max-width: min(92vw,480px);
            background: #16883e;
            color: #fff;
            border-radius: 9px;
            padding: 12px 20px;
            font-weight: bold;
            box-shadow: 0 6px 20px rgba(0,0,0,.18);
            z-index: 2000;
            text-align: center;
        }

        .toast.error {
            background: #c62828;
        }

        footer {
            background: #171717;
            color: #ccc;
            padding: 28px;
            text-align: center;
            font-size: 13px;
        }

        footer span {
            color: #ff5200;
        }

        @media(max-width:1000px) {
            .cart-container {
                width: 92%;
                grid-template-columns: 1fr;
            }

            .order-summary {
                position: static;
            }
        }

        @media(max-width:750px) {
            .navbar {
                min-height: 72px;
                padding: 14px 4%;
            }

            .logo {
                font-size: 23px;
            }

            .profile-name {
                display: none;
            }

            .cart-hero {
                padding: 35px 5%;
            }

            .cart-hero h1 {
                font-size: 30px;
            }

            .cart-item {
                flex-direction: column;
                align-items: stretch;
                padding: 18px;
            }

            .item-image-container {
                width: 100%;
                height: 210px;
            }

            .item-name {
                font-size: 23px;
            }

            .order-summary {
                padding: 24px;
            }
        }

        @media(max-width:450px) {
            .quantity-btn {
                width: 46px;
            }

            .quantity-value {
                min-width: 44px;
            }

            .order-summary h2 {
                font-size: 24px;
            }

            .total-row {
                font-size: 19px;
            }

            .total-amount {
                font-size: 22px;
            }
        }
    </style>
</head>

<body>

<nav class="navbar">
    <a href="<%= context %>/restaurant" class="logo">
        Food<span>corner</span>
    </a>

    <div class="nav-right">
        <% if (loggedInUser != null) { %>
            <span class="profile-name">
                👤 <%= escapeHtml(loggedInUser.getUsername()) %>
            </span>
        <% } %>
    </div>
</nav>

<section class="cart-hero">
    <h1>Your <span>Cart</span></h1>
    <p>Review your selected dishes before placing your order.</p>
</section>

<main id="cartContainer" class="cart-container" <%= hasItems ? "" : "hidden" %>>

    <section id="cartItems" class="cart-items-section">

        <% if (hasItems) {
            for (CartItem item : cart.getItems()) {
                String url = imageUrl(item.getImagePath(), context);
        %>

        <article class="cart-item"
                 data-menu-id="<%= item.getMenuId() %>"
                 data-quantity="<%= item.getQuantity() %>"
                 data-price="<%= item.getPrice() %>">

            <div class="item-image-container">

                <% if (url != null) { %>
                    <img src="<%= escapeHtml(url) %>"
                         alt="<%= escapeHtml(item.getItemName()) %>"
                         class="item-image"
                         loading="lazy"
                         onerror="this.hidden=true;this.nextElementSibling.hidden=false;">

                    <div class="image-placeholder" hidden>🍽️</div>
                <% } else { %>
                    <div class="image-placeholder">🍽️</div>
                <% } %>

            </div>

            <div class="item-info">

                <div class="item-name">
                    <%= escapeHtml(item.getItemName()) %>
                </div>

                <div class="item-price">
                    ₹<%= String.format(Locale.US, "%.2f", item.getPrice()) %>
                </div>

                <div class="item-subtotal">
                    Subtotal:
                    <strong class="line-total">
                        ₹<%= String.format(Locale.US, "%.2f", item.getSubtotal()) %>
                    </strong>
                </div>

                <div class="quantity-area">

                    <span class="quantity-label">Quantity:</span>

                    <div class="quantity-box">

                        <button type="button"
                                class="quantity-btn minus-btn"
                                aria-label="Decrease <%= escapeHtml(item.getItemName()) %> quantity">
                            −
                        </button>

                        <span class="quantity-value" aria-live="polite">
                            <%= item.getQuantity() %>
                        </span>

                        <button type="button"
                                class="quantity-btn plus-btn"
                                aria-label="Increase <%= escapeHtml(item.getItemName()) %> quantity">
                            +
                        </button>

                    </div>

                    <button type="button" class="remove-btn">
                        Remove
                    </button>

                </div>
            </div>
        </article>

        <% }
        } %>

    </section>

    <aside class="order-summary">

        <h2>Order Summary</h2>

        <div class="summary-row">
            <span>Total Items</span>
            <strong id="summaryCount"><%= totalItems %></strong>
        </div>

        <div class="summary-row">
            <span>Subtotal</span>
            <strong id="summarySubtotal">
                ₹<%= String.format(Locale.US, "%.2f", totalAmount) %>
            </strong>
        </div>

        <div class="summary-row">
            <span>Delivery Fee</span>
            <strong>FREE</strong>
        </div>

        <div class="summary-divider"></div>

        <div class="summary-row total-row">
            <span>Total</span>
            <span id="summaryTotal" class="total-amount">
                ₹<%= String.format(Locale.US, "%.2f", totalAmount) %>
            </span>
        </div>

        <a href="<%= context %>/checkout" class="checkout-btn">
            Proceed to Checkout →
        </a>

        <button id="clearCartBtn" type="button" class="clear-cart-btn">
            Clear Cart
        </button>

        <a href="<%= context %><%= restaurantId > 0 ? "/menu?restaurantId=" + restaurantId : "/restaurant" %>"
           class="continue-shopping">
            ← Continue Shopping
        </a>

    </aside>

</main>

<section id="emptyCart" class="empty-cart" <%= hasItems ? "hidden" : "" %>>

    <div class="empty-cart-icon">🛒</div>

    <h2>Your cart is empty</h2>

    <p>
        You haven't added any food yet.
        Explore restaurants and add your favourite dishes.
    </p>

    <a href="<%= context %>/restaurant" class="start-order-btn">
        Browse Restaurants →
    </a>

</section>

<div id="toast" class="toast" role="status" aria-live="polite" hidden></div>

<footer>
    © 2026 <span>Foodcorner</span> — Food Delivery Website
</footer>

<script>
(() => {
    const cartUrl = '<%= context %>/cart';

    const items = document.getElementById('cartItems');
    const container = document.getElementById('cartContainer');
    const empty = document.getElementById('emptyCart');

    const count = document.getElementById('summaryCount');
    const subtotal = document.getElementById('summarySubtotal');
    const total = document.getElementById('summaryTotal');

    const clearBtn = document.getElementById('clearCartBtn');
    const toast = document.getElementById('toast');

    let toastTimer;
    let requestInProgress = false;

    function money(value) {
        return '₹' + (Number(value) || 0).toFixed(2);
    }

    function showToast(message, isError = false) {
        toast.textContent = message;
        toast.classList.toggle('error', isError);
        toast.hidden = false;

        clearTimeout(toastTimer);

        toastTimer = setTimeout(() => {
            toast.hidden = true;
        }, 2600);
    }

    function setBusy(busy) {
        requestInProgress = busy;

        document.querySelectorAll(
            '.quantity-btn, .remove-btn, .clear-cart-btn'
        ).forEach(button => {
            button.disabled = busy;
        });
    }

    async function requestCart(action, menuId, quantity) {
        const body = new URLSearchParams();

        body.set('action', action);
        body.set('ajax', 'true');

        if (menuId !== null) {
            body.set('menuId', String(menuId));
        }

        if (quantity !== null) {
            body.set('quantity', String(quantity));
        }

        const response = await fetch(cartUrl, {
            method: 'POST',
            credentials: 'same-origin',
            headers: {
                'Content-Type': 'application/x-www-form-urlencoded;charset=UTF-8',
                'X-Requested-With': 'XMLHttpRequest'
            },
            body: body.toString()
        });

        const data = await response.json();

        if (!response.ok || !data.success) {
            throw new Error(data.message || 'Could not update your cart');
        }

        return data;
    }

    function updateSummary(data) {
        const quantity = Number(data.cartQuantity) || 0;
        const amount = Number(data.cartTotal) || 0;

        count.textContent = String(quantity);
        subtotal.textContent = money(amount);
        total.textContent = money(amount);

        if (quantity === 0) {
            container.hidden = true;
            empty.hidden = false;
        }
    }

    async function changeItem(card, action, nextQuantity) {
        if (requestInProgress) return;

        setBusy(true);

        try {
            const menuId = Number(card.dataset.menuId);

            const data = await requestCart(
                action,
                menuId,
                nextQuantity
            );

            const updatedQuantity = Number(data.itemQuantity) || 0;

            if (updatedQuantity === 0 || action === 'remove') {
                card.remove();
            } else {
                card.dataset.quantity = String(updatedQuantity);

                card.querySelector('.quantity-value').textContent =
                    String(updatedQuantity);

                const price = Number(card.dataset.price) || 0;

                card.querySelector('.line-total').textContent =
                    money(price * updatedQuantity);
            }

            updateSummary(data);

        } catch (error) {
            showToast(
                error.message || 'Network error. Please try again.',
                true
            );

        } finally {
            setBusy(false);
        }
    }

    items.addEventListener('click', event => {
        const button = event.target.closest('button');

        if (!button || requestInProgress) return;

        const card = button.closest('.cart-item');

        if (!card) return;

        const quantity = Number(card.dataset.quantity) || 0;

        if (button.classList.contains('plus-btn')) {
            changeItem(card, 'update', quantity + 1);

        } else if (button.classList.contains('minus-btn')) {
            changeItem(card, 'update', Math.max(0, quantity - 1));

        } else if (button.classList.contains('remove-btn')) {
            changeItem(card, 'remove', null);
        }
    });

    clearBtn.addEventListener('click', async () => {
        if (requestInProgress ||
                !window.confirm('Remove all items from your cart?')) {
            return;
        }

        setBusy(true);

        try {
            const data = await requestCart('clear', null, null);

            items.replaceChildren();
            updateSummary(data);

            showToast('Your cart has been cleared');

        } catch (error) {
            showToast(
                error.message || 'Could not clear your cart',
                true
            );

        } finally {
            setBusy(false);
        }
    });
})();
</script>

</body>
</html>
