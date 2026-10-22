<%@ page language="java"
    contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

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


Restaurant restaurant =
        (Restaurant)
        request.getAttribute("restaurant");


if (restaurant == null) {

    response.sendRedirect(
            request.getContextPath()
            + "/adminRestaurants"
    );

    return;
}


String error =
        request.getParameter("error");


String imagePath =
        restaurant.getImagePath();


String currentImageUrl;


if (imagePath == null ||
    imagePath.trim().isEmpty()) {

    currentImageUrl =
        "https://placehold.co/600x400?text=Foodcorner";

}
else if (
    imagePath.startsWith("http://") ||
    imagePath.startsWith("https://")) {

    currentImageUrl =
        imagePath;

}
else {

    String cleanedPath =
            imagePath;

    if (cleanedPath.startsWith("/")) {

        cleanedPath =
            cleanedPath.substring(1);
    }

    currentImageUrl =
            request.getContextPath()
            + "/"
            + cleanedPath;
}
%>

<!DOCTYPE html>

<html>

<head>

<meta charset="UTF-8">

<meta name="viewport"
      content="width=device-width, initial-scale=1.0">

<title>
    Foodcorner | Edit Restaurant
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


/* NAVBAR */

.navbar {

    background: white;

    padding: 16px 6%;

    display: flex;

    justify-content: space-between;

    align-items: center;

    box-shadow:
        0 2px 12px
        rgba(0,0,0,0.08);
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


/* PAGE */

.page-wrapper {

    width: 92%;

    max-width: 1050px;

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


/* CARD */

.form-card {

    background: white;

    border-radius: 18px;

    border:
        1px solid #eeeeee;

    box-shadow:
        0 10px 35px
        rgba(0,0,0,0.08);

    overflow: hidden;
}


.form-layout {

    display: grid;

    grid-template-columns:
        1fr 1.4fr;
}


/* IMAGE SECTION */

.image-section {

    background: #fff7f2;

    padding: 35px;

    border-right:
        1px solid #eeeeee;
}


.image-section h3 {

    margin-bottom: 8px;

    font-size: 20px;
}


.image-section p {

    color: #777;

    font-size: 13px;

    line-height: 1.6;

    margin-bottom: 22px;
}


.preview-wrapper {

    width: 100%;

    height: 270px;

    border-radius: 14px;

    overflow: hidden;

    background: #eeeeee;

    border:
        2px dashed #dddddd;
}


.preview-wrapper img {

    width: 100%;

    height: 100%;

    object-fit: cover;

    display: block;
}


.image-note {

    margin-top: 18px;

    background: white;

    padding: 14px;

    border-radius: 9px;

    border:
        1px solid #eeeeee;

    font-size: 12px;

    line-height: 1.7;

    color: #666;
}


.image-note strong {

    color: #ff5200;
}


/* FORM SECTION */

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


/* MESSAGE */

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
}


/* FORM */

.form-row {

    display: grid;

    grid-template-columns:
        1fr 1fr;

    gap: 18px;
}


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


.readonly {

    background: #f5f5f5;

    color: #777;

    cursor: not-allowed;
}


textarea.form-control {

    resize: vertical;

    min-height: 95px;

    font-family:
        Arial,
        Helvetica,
        sans-serif;
}


.help-text {

    color: #888;

    font-size: 11px;

    margin-top: 6px;

    line-height: 1.5;
}


/* STATUS */

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

    margin: 0;

    display: block;

    padding: 12px;

    text-align: center;

    border:
        1px solid #dddddd;

    border-radius: 8px;

    cursor: pointer;

    transition: 0.2s;

    font-size: 13px;
}


.status-option input:checked
+ label {

    border-color: #ff5200;

    background: #fff2eb;

    color: #ff5200;
}


/* BUTTONS */

.form-actions {

    display: flex;

    gap: 12px;

    margin-top: 10px;
}


.update-btn {

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


.update-btn:hover {

    background: #e94a00;
}


.cancel-btn {

    flex: 1;

    text-decoration: none;

    border:
        1px solid #dddddd;

    background: white;

    color: #555;

    padding:
        12px 18px;

    border-radius: 8px;

    font-size: 14px;

    font-weight: bold;

    text-align: center;

    transition: 0.2s;
}


.cancel-btn:hover {

    background: #f6f6f6;
}


/* FOOTER */

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


/* RESPONSIVE */

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



<!-- NAVBAR -->

<nav class="navbar">


    <div class="logo">

        Food<span>corner</span>

    </div>


    <div class="nav-links">


        <a
            href="<%= request.getContextPath() %>/adminRestaurants"

            class="back-btn">

            ← Restaurants

        </a>


        <a
            href="<%= request.getContextPath() %>/adminDashboard"

            class="dashboard-btn">

            Dashboard

        </a>


    </div>


</nav>



<!-- PAGE -->

<main class="page-wrapper">


    <div class="page-title">


        <h1>

            Edit

            <span>

                Restaurant

            </span>

        </h1>


        <p>

            Update restaurant information,
            image, rating and availability.

        </p>


    </div>



    <div class="form-card">


        <div class="form-layout">



            <!-- IMAGE SECTION -->

            <div class="image-section">


                <h3>

                    Restaurant Image

                </h3>


                <p>

                    Current restaurant image.
                    Change the image path below
                    to update it.

                </p>


                <div class="preview-wrapper">


                    <img
                        id="imagePreview"

                        src="<%= currentImageUrl %>"

                        alt="<%= restaurant.getName() %>"

                        onerror="
                            this.onerror=null;
                            this.src='https://placehold.co/600x400?text=Foodcorner';
                        ">


                </div>



                <div class="image-note">


                    <strong>

                        Restaurant ID:

                    </strong>

                    <%= restaurant.getRestaurantId() %>

                    <br><br>


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

                    images/restaurants/restaurant.jpg


                </div>


            </div>



            <!-- FORM SECTION -->

            <div class="form-section">


                <h2>

                    Restaurant Details

                </h2>


                <div class="subtitle">

                    Update the information below.

                </div>



<%

if ("invalid".equals(error)) {

%>


                <div class="message error">

                    Please enter all required fields.

                </div>


<%

}


if ("rating".equals(error)) {

%>


                <div class="message error">

                    Rating must be between
                    0 and 5.

                </div>


<%

}

%>



                <form

                    action="<%= request.getContextPath() %>/editRestaurant"

                    method="post">



                    <!-- RESTAURANT ID -->

                    <input
                        type="hidden"

                        name="restaurantId"

                        value="<%= restaurant.getRestaurantId() %>">



                    <!-- NAME -->

                    <div class="form-group">


                        <label for="name">

                            Restaurant Name

                            <span class="required">
                                *
                            </span>

                        </label>


                        <input
                            type="text"

                            id="name"

                            name="name"

                            class="form-control"

                            value="<%= restaurant.getName() %>"

                            required>


                    </div>



                    <!-- CUISINE + DELIVERY -->

                    <div class="form-row">


                        <div class="form-group">


                            <label for="cuisineType">

                                Cuisine Type

                                <span class="required">
                                    *
                                </span>

                            </label>


                            <input
                                type="text"

                                id="cuisineType"

                                name="cuisineType"

                                class="form-control"

                                value="<%= restaurant.getCuisineType() %>"

                                required>


                        </div>



                        <div class="form-group">


                            <label for="deliveryTime">

                                Delivery Time

                                <span class="required">
                                    *
                                </span>

                            </label>


                            <input
                                type="text"

                                id="deliveryTime"

                                name="deliveryTime"

                                class="form-control"

                                value="<%= restaurant.getDeliveryTime() %>"

                                required>


                        </div>


                    </div>



                    <!-- ADDRESS -->

                    <div class="form-group">


                        <label for="address">

                            Restaurant Address

                            <span class="required">
                                *
                            </span>

                        </label>


                        <textarea
                            id="address"

                            name="address"

                            class="form-control"

                            required><%= restaurant.getAddress() %></textarea>


                    </div>



                    <!-- RATING -->

                    <div class="form-group">


                        <label for="rating">

                            Rating

                        </label>


                        <input
                            type="number"

                            id="rating"

                            name="rating"

                            class="form-control"

                            min="0"

                            max="5"

                            step="0.1"

                            value="<%= restaurant.getRating() %>">


                        <div class="help-text">

                            Enter a rating between
                            0.0 and 5.0.

                        </div>


                    </div>



                    <!-- IMAGE PATH -->

                    <div class="form-group">


                        <label for="imagePath">

                            Restaurant Image Path

                        </label>


                        <input
                            type="text"

                            id="imagePath"

                            name="imagePath"

                            class="form-control"

                            value="<%= restaurant.getImagePath() == null
                                    ? ""
                                    : restaurant.getImagePath() %>"

                            oninput="previewImage()">


                        <div class="help-text">

                            Change the URL or project
                            image path to update the image.

                        </div>


                    </div>



                    <!-- STATUS -->

                    <div class="form-group">


                        <label>

                            Restaurant Status

                        </label>


                        <div class="status-options">


                            <div class="status-option">


                                <input
                                    type="radio"

                                    id="active"

                                    name="isActive"

                                    value="true"

                                    <%= restaurant.isActive()
                                            ? "checked"
                                            : "" %>>


                                <label for="active">

                                    ✓ Active

                                </label>


                            </div>



                            <div class="status-option">


                                <input
                                    type="radio"

                                    id="inactive"

                                    name="isActive"

                                    value="false"

                                    <%= !restaurant.isActive()
                                            ? "checked"
                                            : "" %>>


                                <label for="inactive">

                                    ✕ Inactive

                                </label>


                            </div>


                        </div>


                    </div>



                    <!-- ADMIN -->

                    <div class="form-group">


                        <label>

                            Restaurant Admin

                        </label>


                        <input
                            type="text"

                            class="form-control readonly"

                            value="Admin ID: <%= restaurant.getAdminUserId() %>"

                            readonly>


                        <div class="help-text">

                            Restaurant administrator
                            is not changed while editing.

                        </div>


                    </div>



                    <!-- BUTTONS -->

                    <div class="form-actions">


                        <button
                            type="submit"

                            class="update-btn">

                            Save Changes

                        </button>


                        <a
                            href="<%= request.getContextPath() %>/adminRestaurants"

                            class="cancel-btn">

                            Cancel

                        </a>


                    </div>


                </form>


            </div>


        </div>


    </div>


</main>



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


    if (path === "") {

        preview.src =
            "https://placehold.co/600x400?text=Foodcorner";

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
}

</script>



</body>

</html>