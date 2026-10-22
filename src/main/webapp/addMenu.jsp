<%@ page language="java"
    contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<%@ page import="java.util.List" %>
<%@ page import="com.tap.model.Restaurant" %>
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
    !"ADMIN".equalsIgnoreCase(admin.getRole())) {

    response.sendRedirect(
            request.getContextPath()
            + "/login.jsp"
    );

    return;
}


List<Restaurant> restaurants =
        (List<Restaurant>)
        request.getAttribute("restaurants");


Integer selectedRestaurantId =
        (Integer)
        request.getAttribute(
                "selectedRestaurantId"
        );


String error =
        request.getParameter("error");
%>


<!DOCTYPE html>

<html>

<head>

<meta charset="UTF-8">

<meta name="viewport"
      content="width=device-width, initial-scale=1.0">

<title>
    Foodcorner | Add Menu Item
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

    background:
        linear-gradient(
            135deg,
            #fff1e9,
            #fffaf7
        );

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


.nav-links {

    display: flex;

    align-items: center;

    gap: 12px;
}


.nav-links a {

    text-decoration: none;

    padding:
        9px 14px;

    border-radius: 8px;

    font-size: 13px;

    font-weight: bold;

    transition: 0.2s;
}


.back-btn {

    color: #ff5200;

    border:
        1px solid #ff5200;
}


.back-btn:hover {

    background: #ff5200;

    color: white;
}


.dashboard-btn {

    color: #444;

    border:
        1px solid #dddddd;
}


.dashboard-btn:hover {

    background: #f3f3f3;
}


/* ============================== */
/* PAGE */
/* ============================== */

.page-wrapper {

    width: 92%;

    max-width: 1080px;

    margin:
        45px auto
        70px auto;
}


.page-title {

    text-align: center;

    margin-bottom: 30px;
}


.page-title h1 {

    font-size: 35px;

    margin-bottom: 8px;
}


.page-title h1 span {

    color: #ff5200;
}


.page-title p {

    color: #777;

    font-size: 14px;

    line-height: 1.6;
}


/* ============================== */
/* CARD */
/* ============================== */

.form-card {

    background: white;

    border-radius: 18px;

    overflow: hidden;

    border:
        1px solid #eeeeee;

    box-shadow:
        0 10px 35px
        rgba(0,0,0,0.08);
}


.form-layout {

    display: grid;

    grid-template-columns:
        1fr 1.4fr;
}


/* ============================== */
/* IMAGE SIDE */
/* ============================== */

.image-section {

    background: #fff7f2;

    padding: 35px;

    border-right:
        1px solid #eeeeee;
}


.image-section h3 {

    font-size: 20px;

    margin-bottom: 8px;
}


.image-section p {

    color: #777;

    font-size: 13px;

    line-height: 1.6;

    margin-bottom: 22px;
}


.preview-wrapper {

    width: 100%;

    height: 280px;

    border-radius: 14px;

    overflow: hidden;

    background: #eeeeee;

    border:
        2px dashed #dddddd;

    display: flex;

    justify-content: center;

    align-items: center;
}


.preview-wrapper img {

    width: 100%;

    height: 100%;

    object-fit: cover;

    display: none;
}


.preview-placeholder {

    text-align: center;

    padding: 20px;

    color: #999;
}


.preview-placeholder .icon {

    font-size: 50px;

    margin-bottom: 10px;
}


.preview-placeholder p {

    margin: 0;

    color: #999;
}


.image-note {

    margin-top: 18px;

    padding: 14px;

    background: white;

    border:
        1px solid #eeeeee;

    border-radius: 9px;

    color: #666;

    font-size: 12px;

    line-height: 1.7;
}


.image-note strong {

    color: #ff5200;
}


/* ============================== */
/* FORM SIDE */
/* ============================== */

.form-section {

    padding: 35px;
}


.form-section h2 {

    font-size: 24px;

    margin-bottom: 6px;
}


.subtitle {

    color: #777;

    font-size: 13px;

    margin-bottom: 25px;
}


/* ============================== */
/* MESSAGE */
/* ============================== */

.message {

    margin-bottom: 20px;

    padding:
        12px 14px;

    border-radius: 8px;

    font-size: 13px;

    font-weight: bold;
}


.error {

    background: #ffe5e5;

    color: #b42318;

    border:
        1px solid #ffcaca;
}


/* ============================== */
/* FORM */
/* ============================== */

.form-group {

    margin-bottom: 18px;
}


.form-group label {

    display: block;

    margin-bottom: 7px;

    font-size: 13px;

    font-weight: bold;

    color: #333;
}


.required {

    color: #d32f2f;
}


.form-control {

    width: 100%;

    padding:
        12px 13px;

    border:
        1px solid #dddddd;

    border-radius: 8px;

    outline: none;

    font-size: 14px;

    background: white;

    transition: 0.2s;
}


.form-control:focus {

    border-color: #ff5200;

    box-shadow:
        0 0 0 2px
        rgba(255,82,0,0.08);
}


textarea.form-control {

    min-height: 110px;

    resize: vertical;

    font-family:
        Arial,
        Helvetica,
        sans-serif;
}


.form-row {

    display: grid;

    grid-template-columns:
        1fr 1fr;

    gap: 18px;
}


.help-text {

    margin-top: 6px;

    color: #888;

    font-size: 11px;

    line-height: 1.5;
}


/* ============================== */
/* AVAILABILITY */
/* ============================== */

.status-options {

    display: flex;

    gap: 12px;
}


.status-option {

    flex: 1;

    position: relative;
}


.status-option input {

    position: absolute;

    opacity: 0;
}


.status-option label {

    display: block;

    margin: 0;

    padding: 12px;

    border:
        1px solid #dddddd;

    border-radius: 8px;

    text-align: center;

    cursor: pointer;

    font-size: 13px;

    transition: 0.2s;
}


.status-option input:checked
+ label {

    border-color: #ff5200;

    background: #fff2eb;

    color: #ff5200;
}


/* ============================== */
/* BUTTONS */
/* ============================== */

.form-actions {

    display: flex;

    gap: 12px;

    margin-top: 12px;
}


.submit-btn {

    flex: 1;

    border: none;

    background: #ff5200;

    color: white;

    padding:
        13px 18px;

    border-radius: 8px;

    font-size: 14px;

    font-weight: bold;

    cursor: pointer;

    transition: 0.2s;
}


.submit-btn:hover {

    background: #e94a00;
}


.cancel-btn {

    flex: 1;

    text-decoration: none;

    background: white;

    color: #555;

    border:
        1px solid #dddddd;

    padding:
        12px 18px;

    border-radius: 8px;

    text-align: center;

    font-size: 14px;

    font-weight: bold;

    transition: 0.2s;
}


.cancel-btn:hover {

    background: #f5f5f5;
}


/* ============================== */
/* FOOTER */
/* ============================== */

footer {

    background: #181818;

    color: #cccccc;

    text-align: center;

    padding: 25px;

    font-size: 13px;
}


footer span {

    color: #ff5200;
}


/* ============================== */
/* RESPONSIVE */
/* ============================== */

@media(max-width: 850px) {

    .form-layout {

        grid-template-columns: 1fr;
    }


    .image-section {

        border-right: none;

        border-bottom:
            1px solid #eeeeee;
    }

}


@media(max-width: 600px) {

    .navbar {

        padding:
            14px 4%;
    }


    .logo {

        font-size: 23px;
    }


    .dashboard-btn {

        display: none;
    }


    .page-title h1 {

        font-size: 29px;
    }


    .form-row {

        grid-template-columns: 1fr;

        gap: 0;
    }


    .form-section,
    .image-section {

        padding: 24px;
    }


    .form-actions {

        flex-direction: column;
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


    <div class="nav-links">


        <%
        if (selectedRestaurantId != null) {
        %>

        <a
            href="<%= request.getContextPath() %>/adminMenus?restaurantId=<%= selectedRestaurantId %>"

            class="back-btn">

            ← Menu

        </a>

        <%
        } else {
        %>

        <a
            href="<%= request.getContextPath() %>/adminMenus"

            class="back-btn">

            ← Menu

        </a>

        <%
        }
        %>


        <a
            href="<%= request.getContextPath() %>/adminDashboard"

            class="dashboard-btn">

            Dashboard

        </a>


    </div>


</nav>



<!-- ============================== -->
<!-- PAGE -->
<!-- ============================== -->

<main class="page-wrapper">


    <div class="page-title">


        <h1>

            Add

            <span>

                Menu Item

            </span>

        </h1>


        <p>

            Add a food item to a restaurant
            with its description, price,
            availability and image.

        </p>


    </div>



    <div class="form-card">


        <div class="form-layout">



            <!-- ============================== -->
            <!-- IMAGE -->
            <!-- ============================== -->

            <div class="image-section">


                <h3>

                    Menu Item Image

                </h3>


                <p>

                    Enter an internet image URL
                    or an image path from your
                    Foodcorner project.

                </p>



                <div class="preview-wrapper">


                    <img
                        id="imagePreview"

                        alt="Menu Item Preview"

                        onerror="showImageError();">


                    <div
                        id="previewPlaceholder"

                        class="preview-placeholder">


                        <div class="icon">

                            🍜

                        </div>


                        <p>

                            Food image preview
                            will appear here.

                        </p>


                    </div>


                </div>



                <div class="image-note">


                    <strong>
                        Internet image:
                    </strong>

                    <br>

                    https://images.unsplash.com/...

                    <br><br>


                    <strong>
                        Project image:
                    </strong>

                    <br>

                    images/menu/masala-dosa.jpg


                </div>


            </div>



            <!-- ============================== -->
            <!-- FORM -->
            <!-- ============================== -->

            <div class="form-section">


                <h2>

                    Menu Item Details

                </h2>


                <div class="subtitle">

                    Fields marked with * are required.

                </div>



                <!-- ERROR -->

<%

if ("invalid".equals(error)) {

%>

                <div class="message error">

                    Please enter all required fields.

                </div>

<%

}


if ("price".equals(error)) {

%>

                <div class="message error">

                    Please enter a valid price
                    greater than ₹0.

                </div>

<%

}


if ("restaurant".equals(error)) {

%>

                <div class="message error">

                    Please select a valid restaurant.

                </div>

<%

}

%>



                <form
                    action="<%= request.getContextPath() %>/addMenu"

                    method="post">



                    <!-- RESTAURANT -->

                    <div class="form-group">


                        <label for="restaurantId">

                            Restaurant

                            <span class="required">
                                *
                            </span>

                        </label>


                        <select
                            id="restaurantId"

                            name="restaurantId"

                            class="form-control"

                            required>


                            <option value="">

                                Select Restaurant

                            </option>


<%

if (restaurants != null) {

    for (Restaurant restaurant :
            restaurants) {

%>


                            <option
                                value="<%= restaurant.getRestaurantId() %>"

                                <%= selectedRestaurantId != null &&
                                    selectedRestaurantId.intValue()
                                    == restaurant.getRestaurantId()
                                    ? "selected"
                                    : "" %>>


                                <%= restaurant.getName() %>

                                -
                                <%= restaurant.getCuisineType() %>


                            </option>


<%

    }
}

%>


                        </select>


                    </div>



                    <!-- ITEM NAME -->

                    <div class="form-group">


                        <label for="itemName">

                            Item Name

                            <span class="required">
                                *
                            </span>

                        </label>


                        <input
                            type="text"

                            id="itemName"

                            name="itemName"

                            class="form-control"

                            placeholder="Example: Masala Dosa"

                            required>


                    </div>



                    <!-- DESCRIPTION -->

                    <div class="form-group">


                        <label for="description">

                            Description

                        </label>


                        <textarea
                            id="description"

                            name="description"

                            class="form-control"

                            placeholder="Example: Crispy dosa served with sambar and coconut chutney."></textarea>


                    </div>



                    <!-- PRICE -->

                    <div class="form-group">


                        <label for="price">

                            Price

                            <span class="required">
                                *
                            </span>

                        </label>


                        <input
                            type="number"

                            id="price"

                            name="price"

                            class="form-control"

                            min="0.01"

                            step="0.01"

                            placeholder="Example: 120.00"

                            required>


                        <div class="help-text">

                            Enter the menu item price in INR.

                        </div>


                    </div>



                    <!-- IMAGE PATH -->

                    <div class="form-group">


                        <label for="imagePath">

                            Menu Image Path

                        </label>


                        <input
                            type="text"

                            id="imagePath"

                            name="imagePath"

                            class="form-control"

                            placeholder="https://... or images/menu/item.jpg"

                            oninput="previewImage()">


                        <div class="help-text">

                            Image URLs and local project
                            image paths are supported.

                        </div>


                    </div>



                    <!-- AVAILABILITY -->

                    <div class="form-group">


                        <label>

                            Availability

                        </label>


                        <div class="status-options">



                            <div class="status-option">


                                <input
                                    type="radio"

                                    id="available"

                                    name="isAvailable"

                                    value="true"

                                    checked>


                                <label for="available">

                                    ✓ Available

                                </label>


                            </div>



                            <div class="status-option">


                                <input
                                    type="radio"

                                    id="unavailable"

                                    name="isAvailable"

                                    value="false">


                                <label for="unavailable">

                                    ✕ Unavailable

                                </label>


                            </div>


                        </div>


                    </div>



                    <!-- ACTIONS -->

                    <div class="form-actions">


                        <button
                            type="submit"

                            class="submit-btn">

                            + Add Menu Item

                        </button>


                        <%
                        if (selectedRestaurantId != null) {
                        %>

                        <a
                            href="<%= request.getContextPath() %>/adminMenus?restaurantId=<%= selectedRestaurantId %>"

                            class="cancel-btn">

                            Cancel

                        </a>

                        <%
                        } else {
                        %>

                        <a
                            href="<%= request.getContextPath() %>/adminMenus"

                            class="cancel-btn">

                            Cancel

                        </a>

                        <%
                        }
                        %>


                    </div>


                </form>


            </div>


        </div>


    </div>


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



<script>

function previewImage() {

    let path =
        document
        .getElementById("imagePath")
        .value
        .trim();


    const preview =
        document
        .getElementById("imagePreview");


    const placeholder =
        document
        .getElementById("previewPlaceholder");


    if (path === "") {

        preview.style.display =
            "none";

        placeholder.style.display =
            "block";

        return;
    }


    if (
        path.startsWith("http://")
        ||
        path.startsWith("https://")
    ) {

        preview.src =
            path;

    } else {


        if (path.startsWith("/")) {

            path =
                path.substring(1);
        }


        preview.src =
            "<%= request.getContextPath() %>/"
            + path;
    }


    preview.style.display =
        "block";


    placeholder.style.display =
        "none";
}



function showImageError() {

    const preview =
        document
        .getElementById("imagePreview");


    const placeholder =
        document
        .getElementById("previewPlaceholder");


    preview.style.display =
        "none";


    placeholder.style.display =
        "block";
}

</script>


</body>

</html>