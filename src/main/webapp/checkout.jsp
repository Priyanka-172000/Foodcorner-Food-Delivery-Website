
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="com.tap.model.Cart" %>
<%@ page import="com.tap.model.CartItem" %>
<%@ page import="java.util.Locale" %>

<%!
    private String escapeHtml(String value) {
        if (value == null) {
            return "";
        }
        return value.replace("&", "&amp;")
                    .replace("<", "&lt;")
                    .replace(">", "&gt;")
                    .replace("\"", "&quot;")
                    .replace("'", "&#39;");
    }
%>

<%
    Cart cart = (Cart) request.getAttribute("cart");

    if (cart == null) {
        cart = (Cart) session.getAttribute("cart");
    }

    boolean hasItems = cart != null && !cart.isEmpty();
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Foodcorner | Checkout</title>

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
        }

        .navbar {
            background: #fff;
            padding: 18px 7%;
            display: flex;
            justify-content: space-between;
            align-items: center;
            gap: 15px;
            box-shadow: 0 2px 12px rgba(0,0,0,.08);
        }

        .logo {
            font-size: 28px;
            font-weight: bold;
            color: #ff5200;
            text-decoration: none;
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

        .hero {
            padding: 38px 7%;
            background: linear-gradient(135deg, #fff1e9, #fff8f4);
        }

        .hero h1 {
            font-size: 36px;
            margin-bottom: 8px;
        }

        .hero h1 span {
            color: #ff5200;
        }

        .hero p {
            color: #666;
            font-size: 15px;
            line-height: 1.5;
        }

        .container {
            width: 86%;
            max-width: 1300px;
            margin: 34px auto;
            display: grid;
            grid-template-columns: minmax(0, 1.6fr) minmax(300px, 1fr);
            gap: 26px;
            align-items: start;
        }

        .checkout-card,
        .summary {
            background: #fff;
            border-radius: 16px;
            border: 1px solid #eee;
            padding: 26px;
            box-shadow: 0 5px 20px rgba(0,0,0,.05);
            min-width: 0;
        }

        .checkout-card h2,
        .summary h2 {
            font-size: 22px;
            margin-bottom: 22px;
        }

        .form-group {
            margin-bottom: 24px;
        }

        .form-group > label {
            display: block;
            font-size: 15px;
            font-weight: bold;
            margin-bottom: 10px;
        }

        .address-input {
            width: 100%;
            min-height: 115px;
            resize: vertical;
            padding: 14px;
            border: 1px solid #ddd;
            border-radius: 10px;
            outline: none;
            font: 15px Arial, Helvetica, sans-serif;
        }

        .address-input:focus {
            border-color: #ff5200;
        }

        .payment-options {
            display: flex;
            flex-direction: column;
            gap: 12px;
        }

        .payment-option {
            border: 1px solid #ddd;
            border-radius: 10px;
            padding: 15px;
            display: flex;
            align-items: center;
            gap: 12px;
            cursor: pointer;
            transition: .2s;
        }

        .payment-option:hover,
        .payment-option:has(input:checked) {
            border-color: #ff5200;
            background: #fff8f4;
        }

        .payment-option input {
            accent-color: #ff5200;
            flex-shrink: 0;
        }

        .payment-title {
            font-weight: bold;
            font-size: 15px;
        }

        .payment-description {
            color: #777;
            font-size: 13px;
            margin-top: 4px;
            line-height: 1.4;
        }

        .place-order-btn {
            width: 100%;
            border: 0;
            padding: 15px;
            background: #ff5200;
            color: #fff;
            border-radius: 9px;
            font-size: 15px;
            font-weight: bold;
            cursor: pointer;
        }

        .place-order-btn:hover {
            background: #e94a00;
        }

        .place-order-btn:disabled {
            opacity: .65;
            cursor: wait;
        }

        .summary {
            position: sticky;
            top: 20px;
        }

        .summary-items {
            margin-bottom: 18px;
        }

        .summary-item {
            display: flex;
            justify-content: space-between;
            align-items: flex-start;
            gap: 14px;
            padding: 12px 0;
            border-bottom: 1px solid #eee;
        }

        .summary-details {
            flex: 1;
            min-width: 0;
        }

        .summary-name {
            font-size: 14px;
            font-weight: bold;
            line-height: 1.4;
            overflow-wrap: anywhere;
        }

        .summary-quantity {
            color: #777;
            font-size: 12px;
            margin-top: 4px;
        }

        .summary-price {
            color: #ff5200;
            font-size: 14px;
            font-weight: bold;
            white-space: nowrap;
        }

        .summary-row {
            display: flex;
            justify-content: space-between;
            gap: 16px;
            margin-top: 16px;
            color: #555;
            font-size: 14px;
        }

        .summary-row span:last-child {
            color: #222;
            font-weight: bold;
        }

        .total-row {
            margin-top: 19px;
            padding-top: 18px;
            border-top: 1px solid #ddd;
            display: flex;
            justify-content: space-between;
            gap: 16px;
            font-size: 20px;
            font-weight: bold;
        }

        .total-price {
            color: #ff5200;
        }

        .empty-checkout {
            width: 86%;
            max-width: 700px;
            margin: 55px auto;
            background: #fff;
            border: 1px solid #eee;
            border-radius: 16px;
            padding: 45px 25px;
            text-align: center;
        }

        .empty-checkout h2 {
            margin-bottom: 12px;
        }

        .empty-checkout p {
            color: #666;
            margin-bottom: 22px;
        }

        .browse-btn {
            display: inline-block;
            padding: 12px 20px;
            background: #ff5200;
            color: #fff;
            border-radius: 9px;
            text-decoration: none;
            font-weight: bold;
        }

        footer {
            margin-top: 55px;
            padding: 28px;
            background: #181818;
            color: #ccc;
            text-align: center;
            font-size: 14px;
        }

        footer span {
            color: #ff5200;
        }

        @media (max-width: 850px) {
            .container {
                width: 92%;
                grid-template-columns: 1fr;
            }

            .summary {
                position: static;
            }
        }

        @media (max-width: 600px) {
            .navbar {
                padding: 16px 5%;
            }

            .logo {
                font-size: 24px;
            }

            .back-link {
                font-size: 13px;
            }

            .hero {
                padding: 32px 5%;
            }

            .hero h1 {
                font-size: 29px;
            }

            .checkout-card,
            .summary {
                padding: 20px;
            }
        }
    </style>
</head>

<body>

    <nav class="navbar">
        <a class="logo" href="<%= request.getContextPath() %>/restaurant">Food<span>corner</span></a>
        <a class="back-link" href="<%= request.getContextPath() %>/cart">← Back to Cart</a>
    </nav>

    <section class="hero">
        <h1>Complete your <span>Checkout</span></h1>
        <p>Confirm your delivery details and payment method.</p>
    </section>

    <% if (hasItems) { %>

        <main class="container">

            <section class="checkout-card">
                <h2>Delivery Details</h2>

                <form
                    id="checkoutForm"
                    action="<%= request.getContextPath() %>/placeOrder"
                    data-cod-action="<%= request.getContextPath() %>/placeOrder"
                    data-payu-action="<%= request.getContextPath() %>/payuPayment"
                    method="post">

                    <div class="form-group">
                        <label for="address">Delivery Address</label>
                        <textarea
                            id="address"
                            name="address"
                            class="address-input"
                            maxlength="500"
                            placeholder="Enter your complete delivery address..."
                            required></textarea>
                    </div>

                    <div class="form-group">
                        <label>Payment Method</label>

                        <div class="payment-options">

                            <label class="payment-option">
                                <input
                                    type="radio"
                                    name="paymentMode"
                                    value="COD"
                                    checked>

                                <span>
                                    <span class="payment-title">Cash on Delivery</span>
                                    <span class="payment-description" style="display:block;">
                                        Pay when your food is delivered.
                                    </span>
                                </span>
                            </label>

                            <label class="payment-option">
                                <input
                                    type="radio"
                                    name="paymentMode"
                                    value="PAYU">

                                <span>
                                    <span class="payment-title">Pay Online</span>
                                    <span class="payment-description" style="display:block;">
                                        Pay securely through PayU using the payment options available at checkout.
                                    </span>
                                </span>
                            </label>

                        </div>
                    </div>

                    <button
                        id="placeOrderButton"
                        type="submit"
                        class="place-order-btn">
                        Place Order →
                    </button>

                </form>
            </section>

            <aside class="summary">
                <h2>Order Summary</h2>

                <div class="summary-items">

                    <% for (CartItem item : cart.getItems()) { %>

                        <div class="summary-item">

                            <div class="summary-details">
                                <div class="summary-name"><%= escapeHtml(item.getItemName()) %></div>

                                <div class="summary-quantity">
                                    Quantity: <%= item.getQuantity() %> × ₹<%= String.format(Locale.US, "%.2f", item.getPrice()) %>
                                </div>
                            </div>

                            <div class="summary-price">
                                ₹<%= String.format(Locale.US, "%.2f", item.getSubtotal()) %>
                            </div>

                        </div>

                    <% } %>

                </div>

                <div class="summary-row">
                    <span>Total Items</span>
                    <span><%= cart.getTotalQuantity() %></span>
                </div>

                <div class="summary-row">
                    <span>Subtotal</span>
                    <span>₹<%= String.format(Locale.US, "%.2f", cart.getTotalAmount()) %></span>
                </div>

                <div class="summary-row">
                    <span>Delivery Fee</span>
                    <span>FREE</span>
                </div>

                <div class="total-row">
                    <span>Total</span>
                    <span class="total-price">₹<%= String.format(Locale.US, "%.2f", cart.getTotalAmount()) %></span>
                </div>
            </aside>

        </main>

    <% } else { %>

        <div class="empty-checkout">
            <h2>Your cart is empty</h2>
            <p>Add some dishes before proceeding to checkout.</p>
            <a class="browse-btn" href="<%= request.getContextPath() %>/restaurant">Browse Restaurants →</a>
        </div>

    <% } %>

    <footer>© 2026 <span>Foodcorner</span></footer>

    <script>
        const checkoutForm = document.getElementById("checkoutForm");

        if (checkoutForm) {
            checkoutForm.addEventListener("submit", function (event) {
                const selectedPayment = checkoutForm.querySelector(
                    'input[name="paymentMode"]:checked'
                );

                const button = document.getElementById("placeOrderButton");

                if (!selectedPayment || !button) {
                    event.preventDefault();
                    return;
                }

                if (selectedPayment.value === "PAYU") {
                    checkoutForm.action = checkoutForm.dataset.payuAction;
                    button.textContent = "Redirecting to PayU...";
                } else {
                    checkoutForm.action = checkoutForm.dataset.codAction;
                    button.textContent = "Placing Order...";
                }

                button.disabled = true;
            });
        }
    </script>

</body>
</html>
