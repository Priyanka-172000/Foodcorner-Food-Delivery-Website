<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.util.List" %>
<%@ page import="java.util.Locale" %>
<%@ page import="com.tap.model.Menu" %>
<%@ page import="com.tap.model.Cart" %>
<%@ page import="com.tap.model.CartItem" %>
<%!
    private String html(String value) {
        if (value == null) return "";
        return value.replace("&", "&amp;")
                    .replace("<", "&lt;")
                    .replace(">", "&gt;")
                    .replace("\"", "&quot;")
                    .replace("'", "&#39;");
    }
%>
<%
    List<Menu> menuList = (List<Menu>) request.getAttribute("allMenu");
    Cart cart = (Cart) session.getAttribute("cart");
    int cartCount = cart == null ? 0 : cart.getTotalQuantity();
    double cartTotal = cart == null ? 0 : cart.getTotalAmount();
    String context = request.getContextPath();
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Foodcorner | Menu</title>
    <style>
        * { margin: 0; padding: 0; box-sizing: border-box; }
        [hidden] { display: none !important; }
        body { font-family: Arial, Helvetica, sans-serif; background: #f7f7f7; color: #222; padding-bottom: 100px; }
        .navbar { background: white; padding: 18px 7%; display: flex; justify-content: space-between; align-items: center; gap: 12px; box-shadow: 0 2px 12px rgba(0,0,0,.08); position: sticky; top: 0; z-index: 100; }
        .logo { font-size: 28px; font-weight: bold; color: #ff5200; }
        .logo span { color: #222; }
        .back-link { text-decoration: none; color: #ff5200; font-weight: bold; font-size: 15px; }
        .back-link:hover { color: #d94400; }
        .hero { padding: 45px 7%; background: linear-gradient(135deg, #fff1e9, #fff8f4); }
        .hero h1 { font-size: 38px; margin-bottom: 8px; }
        .hero h1 span { color: #ff5200; }
        .hero p { color: #666; font-size: 16px; }
        .container { width: 86%; margin: 40px auto; }
        .menu-grid { display: grid; grid-template-columns: repeat(auto-fill, minmax(280px, 1fr)); gap: 28px; }
        .menu-card { background: white; border-radius: 16px; overflow: hidden; border: 1px solid #eee; transition: transform .25s, box-shadow .25s; }
        .menu-card:hover { transform: translateY(-5px); box-shadow: 0 12px 30px rgba(0,0,0,.13); }
        .image-container { height: 200px; overflow: hidden; background: #eee; }
        .image-container img { width: 100%; height: 100%; object-fit: cover; transition: transform .3s; }
        .menu-card:hover img { transform: scale(1.04); }
        .card-content { padding: 19px; }
        .item-name { font-size: 21px; font-weight: bold; margin-bottom: 8px; }
        .price { color: #ff5200; font-size: 20px; font-weight: bold; margin-bottom: 12px; }
        .description { color: #666; font-size: 14px; line-height: 1.6; min-height: 68px; }
        .cart-controls { margin-top: 18px; min-height: 44px; }
        .add-btn { display: block; width: 100%; border: 0; padding: 12px; background: #ff5200; color: white; font-size: 14px; font-weight: bold; border-radius: 9px; cursor: pointer; min-height: 44px; }
        .add-btn:hover { background: #e94a00; }
        .qty-controls { display: flex; align-items: center; justify-content: space-between; border: 1px solid #ff5200; border-radius: 9px; background: #fff7f2; overflow: hidden; min-height: 44px; }
        .qty-btn { border: 0; color: #ff5200; background: transparent; font-size: 25px; font-weight: bold; width: 52px; min-height: 44px; cursor: pointer; }
        .qty-btn:hover { background: #ffe6d9; }
        .qty-value { font-size: 17px; font-weight: bold; min-width: 36px; text-align: center; }
        button:disabled { cursor: wait; opacity: .6; }
        .disabled-btn { margin-top: 18px; width: 100%; min-height: 44px; border: 0; background: #ddd; color: #666; border-radius: 9px; font-weight: bold; cursor: not-allowed !important; opacity: 1 !important; }
        .empty { grid-column: 1 / -1; background: white; padding: 60px 20px; border-radius: 16px; text-align: center; color: #777; }
        .toast { position: fixed; bottom: 105px; left: 50%; transform: translateX(-50%); max-width: min(90vw, 520px); width: max-content; background: #16883e; color: white; padding: 12px 20px; border-radius: 9px; font-size: 14px; font-weight: bold; box-shadow: 0 6px 20px rgba(0,0,0,.18); z-index: 1001; text-align: center; }
        .toast.error { background: #c62828; }
        .cart-bar { position: fixed; left: 50%; bottom: 18px; transform: translateX(-50%); width: 86%; max-width: 900px; background: white; padding: 15px 20px; border-radius: 15px; display: flex; align-items: center; justify-content: space-between; gap: 14px; border: 1px solid #eee; box-shadow: 0 8px 30px rgba(0,0,0,.2); z-index: 1000; }
        .cart-info { display: flex; flex-direction: column; gap: 4px; }
        .cart-count { font-size: 15px; font-weight: bold; }
        .cart-total { color: #666; font-size: 14px; }
        .go-cart-btn { text-decoration: none; background: #ff5200; color: white; padding: 11px 19px; border-radius: 9px; font-size: 14px; font-weight: bold; white-space: nowrap; }
        .go-cart-btn:hover { background: #e94a00; }
        footer { margin-top: 60px; padding: 28px; text-align: center; background: #181818; color: #ccc; }
        footer span { color: #ff5200; }
        .modal-backdrop { position: fixed; inset: 0; background: rgba(0,0,0,.55); z-index: 2000; display: flex; justify-content: center; align-items: center; padding: 18px; }
        .modal-box { width: 100%; max-width: 430px; background: white; padding: 26px; border-radius: 16px; box-shadow: 0 15px 45px rgba(0,0,0,.25); }
        .modal-box h2 { font-size: 22px; margin-bottom: 12px; }
        .modal-box p { color: #555; line-height: 1.6; margin-bottom: 22px; }
        .modal-actions { display: flex; gap: 10px; flex-wrap: wrap; }
        .modal-actions button, .modal-actions a { flex: 1; text-align: center; text-decoration: none; border-radius: 8px; padding: 12px; font-size: 14px; font-weight: bold; cursor: pointer; min-width: 120px; }
        .modal-cancel { border: 1px solid #ddd; color: #333; background: white; }
        .modal-confirm { border: 0; background: #ff5200; color: white; }
        @media (max-width: 700px) {
            .container { width: 92%; }
            .hero h1 { font-size: 30px; }
            .cart-bar { width: 92%; }
            .navbar { padding: 16px 4%; }
            .logo { font-size: 23px; }
            .back-link { font-size: 13px; }
        }
    </style>
</head>
<body>
<nav class="navbar">
    <div class="logo">Food<span>corner</span></div>
    <a class="back-link" href="<%= context %>/restaurant">&larr; Back to Restaurants</a>
</nav>

<section class="hero">
    <h1>Explore our <span>Menu</span></h1>
    <p>Discover your next favourite dish.</p>
</section>

<main class="container">
    <div class="menu-grid">
        <% if (menuList != null && !menuList.isEmpty()) {
               for (Menu menu : menuList) {
                   int currentQuantity = 0;
                   if (cart != null) {
                       for (CartItem item : cart.getItems()) {
                           if (item.getMenuId() == menu.getMenuId()) {
                               currentQuantity = item.getQuantity();
                               break;
                           }
                       }
                   }
        %>
        <article class="menu-card">
            <div class="image-container">
                <img src="<%= context %>/<%= html(menu.getImagePath()) %>"
                     alt="<%= html(menu.getItemName()) %>"
                     loading="lazy"
                     onerror="this.onerror=null;this.src='https://images.unsplash.com/photo-1504674900247-0877df9cc836?w=800&amp;h=500&amp;fit=crop';">
            </div>
            <div class="card-content">
                <div class="item-name"><%= html(menu.getItemName()) %></div>
                <div class="price">₹<%= String.format(Locale.US, "%.2f", menu.getPrice()) %></div>
                <div class="description"><%= html(menu.getDescription()) %></div>
                <% if (menu.isAvailable()) { %>
                <div class="cart-controls" data-menu-id="<%= menu.getMenuId() %>" data-quantity="<%= currentQuantity %>">
                    <button type="button" class="add-btn" <%= currentQuantity > 0 ? "hidden" : "" %>>Add to Cart +</button>
                    <div class="qty-controls" <%= currentQuantity == 0 ? "hidden" : "" %>>
                        <button type="button" class="qty-btn minus-btn" aria-label="Decrease <%= html(menu.getItemName()) %> quantity">−</button>
                        <span class="qty-value" aria-live="polite"><%= currentQuantity %></span>
                        <button type="button" class="qty-btn plus-btn" aria-label="Increase <%= html(menu.getItemName()) %> quantity">+</button>
                    </div>
                </div>
                <% } else { %>
                <button type="button" class="disabled-btn" disabled>Currently Unavailable</button>
                <% } %>
            </div>
        </article>
        <%     }
           } else { %>
        <div class="empty"><h2>No Menu Items Available</h2></div>
        <% } %>
    </div>
</main>

<div id="toast" class="toast" role="status" aria-live="polite" hidden></div>

<div id="cartBar" class="cart-bar" <%= cartCount == 0 ? "hidden" : "" %>>
    <div class="cart-info">
        <div id="cartCount" class="cart-count"><%= cartCount %> <%= cartCount == 1 ? "item" : "items" %> in your cart</div>
        <div id="cartTotal" class="cart-total">₹<%= String.format(Locale.US, "%.2f", cartTotal) %></div>
    </div>
    <a class="go-cart-btn" href="<%= context %>/cart">Go to Cart &rarr;</a>
</div>

<div id="switchModal" class="modal-backdrop" hidden>
    <div class="modal-box" role="dialog" aria-modal="true" aria-labelledby="switchTitle" aria-describedby="switchDescription">
        <h2 id="switchTitle">Your cart has another restaurant's food</h2>
        <p id="switchDescription">You can keep your current order, or clear the cart and add this item from the new restaurant.</p>
        <div class="modal-actions">
            <button type="button" id="keepCart" class="modal-cancel">Keep current cart</button>
            <button type="button" id="clearAndAdd" class="modal-confirm">Clear &amp; add item</button>
        </div>
    </div>
</div>

<footer>© 2026 <span>Foodcorner</span></footer>

<script>
(() => {
    const cartUrl = '<%= context %>/cart';
    const controls = document.querySelectorAll('.cart-controls');
    const cartBar = document.getElementById('cartBar');
    const cartCount = document.getElementById('cartCount');
    const cartTotal = document.getElementById('cartTotal');
    const toast = document.getElementById('toast');
    const modal = document.getElementById('switchModal');
    const keepCart = document.getElementById('keepCart');
    const clearAndAdd = document.getElementById('clearAndAdd');
    let toastTimer;
    let pendingAdd = null;

    function showToast(message, error = false) {
        toast.textContent = message;
        toast.classList.toggle('error', error);
        toast.hidden = false;
        clearTimeout(toastTimer);
        toastTimer = setTimeout(() => { toast.hidden = true; }, 2600);
    }

    function updateCartBar(data) {
        const count = Number(data.cartQuantity) || 0;
        const total = Number(data.cartTotal) || 0;
        cartBar.hidden = count === 0;
        cartCount.textContent = count + (count === 1 ? ' item' : ' items') + ' in your cart';
        cartTotal.textContent = '₹' + total.toFixed(2);
    }

    function updateButtons(control, quantity) {
        const count = Math.max(0, Number(quantity) || 0);
        control.dataset.quantity = String(count);
        control.querySelector('.add-btn').hidden = count > 0;
        control.querySelector('.qty-controls').hidden = count === 0;
        control.querySelector('.qty-value').textContent = count;
    }

    function setBusy(control, busy) {
        control.querySelectorAll('button').forEach(button => {
            button.disabled = busy;
        });
    }

    async function cartRequest(action, menuId, quantity) {
        const params = new URLSearchParams();
        params.set('action', action);
        params.set('ajax', 'true');
        if (menuId !== null) params.set('menuId', String(menuId));
        if (quantity !== null) params.set('quantity', String(quantity));

        const response = await fetch(cartUrl, {
            method: 'POST',
            credentials: 'same-origin',
            headers: {
                'Content-Type': 'application/x-www-form-urlencoded;charset=UTF-8',
                'X-Requested-With': 'XMLHttpRequest'
            },
            body: params.toString()
        });

        const data = await response.json();
        if (!response.ok || !data.success) {
            const error = new Error(data.message || 'Could not update your cart');
            error.status = response.status;
            throw error;
        }
        return data;
    }

    async function changeQuantity(control, nextQuantity) {
        if (control.dataset.busy === 'true') return;
        const menuId = Number(control.dataset.menuId);
        const current = Number(control.dataset.quantity) || 0;
        const action = current === 0 ? 'add' : 'update';
        const quantity = Math.max(0, nextQuantity);

        control.dataset.busy = 'true';
        setBusy(control, true);
        try {
            const data = await cartRequest(action, menuId, quantity);
            updateButtons(control, data.itemQuantity);
            updateCartBar(data);
        } catch (error) {
            if (error.status === 409 && action === 'add') {
                pendingAdd = { control, menuId, quantity };
                modal.hidden = false;
                keepCart.focus();
            } else {
                showToast(error.message || 'Network error. Please try again.', true);
            }
        } finally {
            control.dataset.busy = 'false';
            setBusy(control, false);
        }
    }

    controls.forEach(control => {
        control.querySelector('.add-btn').addEventListener('click', () => {
            changeQuantity(control, 1);
        });
        control.querySelector('.plus-btn').addEventListener('click', () => {
            changeQuantity(control, (Number(control.dataset.quantity) || 0) + 1);
        });
        control.querySelector('.minus-btn').addEventListener('click', () => {
            changeQuantity(control, (Number(control.dataset.quantity) || 0) - 1);
        });
    });

    keepCart.addEventListener('click', () => {
        modal.hidden = true;
        pendingAdd = null;
    });

    clearAndAdd.addEventListener('click', async () => {
        if (!pendingAdd) return;
        const requested = pendingAdd;
        clearAndAdd.disabled = true;
        keepCart.disabled = true;
        try {
            await cartRequest('clear', null, null);
            controls.forEach(control => updateButtons(control, 0));
            const data = await cartRequest('add', requested.menuId, requested.quantity);
            updateButtons(requested.control, data.itemQuantity);
            updateCartBar(data);
            modal.hidden = true;
            pendingAdd = null;
            showToast('Cart updated for the new restaurant');
        } catch (error) {
            try {
                const latest = await fetch(cartUrl + '?ajax=true', {
                    headers: { 'X-Requested-With': 'XMLHttpRequest' },
                    credentials: 'same-origin'
                });
                if (latest.ok) updateCartBar(await latest.json());
            } catch (ignored) {}
            showToast(error.message || 'Could not switch restaurants', true);
            modal.hidden = true;
            pendingAdd = null;
        } finally {
            clearAndAdd.disabled = false;
            keepCart.disabled = false;
        }
    });

    modal.addEventListener('click', event => {
        if (event.target === modal && !clearAndAdd.disabled) {
            modal.hidden = true;
            pendingAdd = null;
        }
    });

    document.addEventListener('keydown', event => {
        if (event.key === 'Escape' && !modal.hidden && !clearAndAdd.disabled) {
            modal.hidden = true;
            pendingAdd = null;
        }
    });
})();
</script>
</body>
</html>
