<%@ page language="java"
    contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<%@ page import="java.util.List" %>
<%@ page import="com.tap.model.Menu" %>
<%@ page import="com.tap.model.Cart" %>

<!DOCTYPE html>
<html>

<head>

<meta charset="UTF-8">

<meta name="viewport"
      content="width=device-width, initial-scale=1.0">

<title>Foodcorner | Menu</title>

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

    padding-bottom: 100px;
}


/* NAVBAR */

.navbar {
    background: white;

    padding: 18px 7%;

    display: flex;

    justify-content: space-between;

    align-items: center;

    box-shadow: 0 2px 12px rgba(0,0,0,0.08);

    position: sticky;

    top: 0;

    z-index: 100;
}

.logo {
    font-size: 28px;

    font-weight: bold;

    color: #ff5200;
}

.logo span {
    color: #222;
}

.back-link {
    text-decoration: none;

    color: #ff5200;

    font-weight: bold;

    font-size: 15px;
}

.back-link:hover {
    color: #d94400;
}


/* HERO */

.hero {
    padding: 45px 7%;

    background:
        linear-gradient(
            135deg,
            #fff1e9,
            #fff8f4
        );
}

.hero h1 {
    font-size: 38px;

    margin-bottom: 8px;
}

.hero h1 span {
    color: #ff5200;
}

.hero p {
    color: #666;

    font-size: 16px;
}


/* CONTAINER */

.container {
    width: 86%;

    margin: 40px auto;
}


/* MENU GRID */

.menu-grid {
    display: grid;

    grid-template-columns:
        repeat(auto-fill, minmax(280px, 1fr));

    gap: 28px;
}


/* MENU CARD */

.menu-card {
    background: white;

    border-radius: 16px;

    overflow: hidden;

    border: 1px solid #eeeeee;

    transition: 0.3s;
}

.menu-card:hover {
    transform: translateY(-7px);

    box-shadow:
        0 12px 30px rgba(0,0,0,0.13);
}


/* IMAGE */

.image-container {
    height: 200px;

    position: relative;

    overflow: hidden;

    background: #eeeeee;
}

.image-container img {
    width: 100%;

    height: 100%;

    object-fit: cover;

    transition: 0.4s;
}

.menu-card:hover img {
    transform: scale(1.07);
}


/* AVAILABILITY */

.availability {
    position: absolute;

    top: 12px;

    right: 12px;

    padding: 7px 11px;

    border-radius: 8px;

    color: white;

    font-size: 12px;

    font-weight: bold;
}

.available {
    background: #16883e;
}

.unavailable {
    background: #d32f2f;
}


/* CONTENT */

.card-content {
    padding: 19px;
}

.item-name {
    font-size: 21px;

    font-weight: bold;

    margin-bottom: 8px;
}


/* PRICE */

.price {
    color: #ff5200;

    font-size: 20px;

    font-weight: bold;

    margin-bottom: 12px;
}


/* DESCRIPTION */

.description {
    color: #666;

    font-size: 14px;

    line-height: 1.6;

    min-height: 68px;
}


/* ADD BUTTON */

.add-form {
    margin-top: 18px;
}

.add-btn {
    width: 100%;

    border: none;

    padding: 12px;

    background: #ff5200;

    color: white;

    font-size: 14px;

    font-weight: bold;

    border-radius: 9px;

    cursor: pointer;

    transition: 0.2s;
}

.add-btn:hover {
    background: #e94a00;
}

.add-btn:active {
    transform: scale(0.98);
}


/* UNAVAILABLE */

.disabled-btn {
    width: 100%;

    margin-top: 18px;

    border: none;

    padding: 12px;

    background: #cccccc;

    color: #666;

    border-radius: 9px;

    font-weight: bold;

    cursor: not-allowed;
}


/* EMPTY MENU */

.empty {
    grid-column: 1 / -1;

    background: white;

    padding: 60px;

    border-radius: 16px;

    text-align: center;

    color: #777;
}


/* ADDED MESSAGE */

.added-message {
    position: fixed;

    bottom: 105px;

    left: 50%;

    transform: translateX(-50%);

    background: #16883e;

    color: white;

    padding: 11px 20px;

    border-radius: 9px;

    font-size: 14px;

    font-weight: bold;

    box-shadow:
        0 6px 20px rgba(0,0,0,0.18);

    z-index: 1001;
}


/* ERROR MESSAGE */

.error-message {
    position: fixed;

    bottom: 105px;

    left: 50%;

    transform: translateX(-50%);

    background: #d32f2f;

    color: white;

    padding: 11px 20px;

    border-radius: 9px;

    font-size: 14px;

    font-weight: bold;

    box-shadow:
        0 6px 20px rgba(0,0,0,0.18);

    z-index: 1001;
}


/* CART BOTTOM BAR */

.cart-bar {
    position: fixed;

    left: 50%;

    bottom: 18px;

    transform: translateX(-50%);

    width: 86%;

    max-width: 900px;

    background: white;

    padding: 15px 20px;

    border-radius: 15px;

    display: flex;

    align-items: center;

    justify-content: space-between;

    border: 1px solid #eeeeee;

    box-shadow:
        0 8px 30px rgba(0,0,0,0.20);

    z-index: 1000;
}

.cart-info {
    display: flex;

    flex-direction: column;

    gap: 4px;
}

.cart-count {
    color: #222;

    font-size: 15px;

    font-weight: bold;
}

.cart-total {
    color: #666;

    font-size: 14px;
}

.go-cart-btn {
    text-decoration: none;

    background: #ff5200;

    color: white;

    padding: 11px 19px;

    border-radius: 9px;

    font-size: 14px;

    font-weight: bold;
}

.go-cart-btn:hover {
    background: #e94a00;
}


/* FOOTER */

footer {
    margin-top: 60px;

    padding: 28px;

    text-align: center;

    background: #181818;

    color: #ccc;
}

footer span {
    color: #ff5200;
}


/* MOBILE */

@media(max-width:700px) {

    .container {
        width: 92%;
    }

    .hero h1 {
        font-size: 30px;
    }

    .cart-bar {
        width: 92%;
    }

}

</style>

</head>


<body>


<%

List<Menu> menuList =
        (List<Menu>) request.getAttribute("allMenu");


Cart cart =
        (Cart) session.getAttribute("cart");


int cartCount = 0;

double cartTotal = 0;


if (cart != null) {

    cartCount =
            cart.getTotalQuantity();

    cartTotal =
            cart.getTotalAmount();
}

%>



<!-- NAVBAR -->

<nav class="navbar">

    <div class="logo">

        Food<span>corner</span>

    </div>


    <a class="back-link"
       href="<%= request.getContextPath() %>/restaurant">

        ← Back to Restaurants

    </a>

</nav>



<!-- HERO -->

<section class="hero">

    <h1>

        Explore our
        <span>Menu</span>

    </h1>

    <p>

        Freshly prepared dishes made just for you.

    </p>

</section>



<!-- MENU -->

<div class="container">

    <div class="menu-grid">


<%

if (menuList != null &&
    !menuList.isEmpty()) {

    for (Menu menu : menuList) {

%>


        <div class="menu-card">


            <div class="image-container">


                <img
                    src="<%= menu.getImagePath() %>"

                    alt="<%= menu.getItemName() %>"

                    loading="lazy"

                    onerror="this.src='https://images.unsplash.com/photo-1504674900247-0877df9cc836?w=800&h=500&fit=crop';">


<%

        if (menu.isAvailable()) {

%>

                <span class="availability available">

                    ● Available

                </span>

<%

        } else {

%>

                <span class="availability unavailable">

                    Unavailable

                </span>

<%

        }

%>


            </div>



            <div class="card-content">


                <div class="item-name">

                    <%= menu.getItemName() %>

                </div>



                <div class="price">

                    ₹<%= String.format(
                            "%.2f",
                            menu.getPrice()
                    ) %>

                </div>



                <div class="description">

                    <%= menu.getDescription() %>

                </div>



<%

        if (menu.isAvailable()) {

%>


                <form
                    class="add-form"

                    action="<%= request.getContextPath() %>/cart"

                    method="post">


                    <input
                        type="hidden"

                        name="action"

                        value="add">


                    <input
                        type="hidden"

                        name="menuId"

                        value="<%= menu.getMenuId() %>">


                    <input
                        type="hidden"

                        name="quantity"

                        value="1">


                    <button
                        type="submit"

                        class="add-btn">

                        Add to Cart +

                    </button>


                </form>


<%

        } else {

%>


                <button
                    type="button"

                    class="disabled-btn"

                    disabled>

                    Currently Unavailable

                </button>


<%

        }

%>


            </div>

        </div>


<%

    }

} else {

%>


        <div class="empty">

            <h2>
                No Menu Items Available
            </h2>

        </div>


<%

}

%>


    </div>

</div>



<!-- ADDED MESSAGE -->

<%

String added =
        request.getParameter("added");


if ("true".equals(added)) {

%>


<div
    id="statusMessage"

    class="added-message">

    ✓ Item added to cart

</div>


<%

}

%>



<!-- DIFFERENT RESTAURANT ERROR -->

<%

String cartError =
        request.getParameter("cartError");


if ("restaurant".equals(cartError)) {

%>


<div
    id="errorMessage"

    class="error-message">

    Please complete or clear your current restaurant cart first.

</div>


<%

}

%>



<!-- CART BOTTOM BAR -->

<%

if (cartCount > 0) {

%>


<div class="cart-bar">


    <div class="cart-info">


        <div class="cart-count">

            <%= cartCount %>

            <%= cartCount == 1
                    ? "item"
                    : "items" %>

            in your cart

        </div>


        <div class="cart-total">

            ₹<%= String.format(
                    "%.2f",
                    cartTotal
            ) %>

        </div>


    </div>


    <a
        class="go-cart-btn"

        href="<%= request.getContextPath() %>/cart">

        Go to Cart →

    </a>


</div>


<%

}

%>



<footer>

    © 2026
    <span>Foodcorner</span>

</footer>



<script>

setTimeout(function() {

    const statusMessage =
        document.getElementById(
            "statusMessage"
        );

    if (statusMessage) {

        statusMessage.style.display =
            "none";
    }


    const errorMessage =
        document.getElementById(
            "errorMessage"
        );

    if (errorMessage) {

        errorMessage.style.display =
            "none";
    }

}, 1800);

</script>


</body>

</html>