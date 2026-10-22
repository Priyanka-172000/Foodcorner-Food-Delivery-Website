<%@ page language="java"
    contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

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
    !"ADMIN".equalsIgnoreCase(
            admin.getRole())) {

    response.sendRedirect(
            request.getContextPath()
            + "/login.jsp"
    );

    return;
}


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
    Foodcorner | Add Restaurant
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

    background: #f2f2f2;
}


/* ============================== */
/* PAGE */
/* ============================== */

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


/* ============================== */
/* MAIN CARD */
/* ============================== */

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

    height: 260px;

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

    color: #999;

    padding: 20px;
}


.preview-placeholder .icon {

    font-size: 42px;

    margin-bottom: 10px;
}


.preview-placeholder p {

    margin: 0;

    color: #999;
}


.image-note {

    margin-top: 18px;

    background: white;

    padding: 14px;

    border-radius: 9px;

    border:
        1px solid #eeeeee;

    font-size: 12px;

    line-height: 1.6;

    color: #666;
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


.form-section-subtitle {

    color: #777;

    font-size: 13px;

    margin-bottom: 25px;
}


/* ============================== */
/* ERROR */
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
}


/* ============================== */
/* FORM */
/* ============================== */

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


/* ============================== */
/* STATUS */
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


/* ============================== */
/* BUTTONS */
/* ============================== */

.form-actions {

    display: flex;

    gap: 12px;

    margin-top: 10px;
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


    .preview-wrapper {

        max-width: 500px;

        margin: auto;
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



<!-- ============================== -->
<!-- PAGE -->
<!-- ============================== -->

<main class="page-wrapper">


    <div class="page-title">


        <h1>

            Add

            <span>

                Restaurant

            </span>

        </h1>


        <p>

            Add a new restaurant to Foodcorner
            along with its cuisine, delivery details,
            rating and restaurant image.

        </p>


    </div>



    <div class="form-card">


        <div class="form-layout">



            <!-- ============================== -->
            <!-- IMAGE PREVIEW -->
            <!-- ============================== -->

            <div class="image-section">


                <h3>

                    Restaurant Image

                </h3>


                <p>

                    Enter an image URL or a path
                    to an image stored inside
                    your Foodcorner project.

                </p>



                <div class="preview-wrapper">


                    <img
                        id="imagePreview"

                        alt="Restaurant Preview"

                        onerror="showImageError();">


                    <div
                        id="previewPlaceholder"

                        class="preview-placeholder">


                        <div class="icon">

                            🍽️

                        </div>


                        <p>

                            Restaurant image
                            preview will appear here.

                        </p>


                    </div>


                </div>



                <div class="image-note">


                    <strong>

                        Internet image example:

                    </strong>

                    <br>

                    https://images.unsplash.com/...

                    <br><br>


                    <strong>

                        Project image example:

                    </strong>

                    <br>

                    images/restaurants/restaurant1.jpg


                </div>


            </div>



            <!-- ============================== -->
            <!-- FORM -->
            <!-- ============================== -->

            <div class="form-section">


                <h2>

                    Restaurant Details

                </h2>


                <div class="form-section-subtitle">

                    Fields marked with * are required.

                </div>



                <!-- ERROR MESSAGE -->

<%

if ("invalid".equals(error)) {

%>


                <div class="message error">

                    Please enter all required
                    restaurant details.

                </div>


<%

}


if ("rating".equals(error)) {

%>


                <div class="message error">

                    Rating must be a number
                    between 0 and 5.

                </div>


<%

}

%>



                <form

                    action="<%= request.getContextPath() %>/addRestaurant"

                    method="post">



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

                            placeholder="Example: Spice Garden"

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

                                placeholder="North Indian"

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

                                placeholder="30-40 mins"

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

                            placeholder="Enter complete restaurant address"

                            required></textarea>


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

                            value="0.0"

                            placeholder="Example: 4.5">


                        <div class="help-text">

                            Enter a rating from
                            0.0 to 5.0.

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

                            placeholder="https://... or images/restaurants/restaurant.jpg"

                            oninput="previewImage()">


                        <div class="help-text">

                            You can enter an internet image URL
                            or an image path from your project.

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

                                    checked>


                                <label for="active">

                                    ✓ Active

                                </label>


                            </div>



                            <div class="status-option">


                                <input
                                    type="radio"

                                    id="inactive"

                                    name="isActive"

                                    value="false">


                                <label for="inactive">

                                    ✕ Inactive

                                </label>


                            </div>


                        </div>


                    </div>



                    <!-- ADMIN INFORMATION -->

                    <div class="form-group">


                        <label>

                            Restaurant Admin

                        </label>


                        <input
                            type="text"

                            class="form-control"

                            value="<%= admin.getUsername() %>"

                            readonly>


                        <div class="help-text">

                            Admin ID will be assigned automatically
                            from your logged-in admin account.

                        </div>


                    </div>



                    <!-- BUTTONS -->

                    <div class="form-actions">


                        <button
                            type="submit"

                            class="submit-btn">

                            + Add Restaurant

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

    const input =
        document.getElementById(
            "imagePath"
        );


    const preview =
        document.getElementById(
            "imagePreview"
        );


    const placeholder =
        document.getElementById(
            "previewPlaceholder"
        );


    let path =
        input.value.trim();


    if (path === "") {

        preview.style.display =
            "none";

        placeholder.style.display =
            "block";

        return;
    }


    /*
     * INTERNET URL
     */
    if (
        path.startsWith("http://")
        ||
        path.startsWith("https://")
    ) {

        preview.src =
            path;

    }

    /*
     * PROJECT IMAGE PATH
     */
    else {

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
        document.getElementById(
            "imagePreview"
        );


    const placeholder =
        document.getElementById(
            "previewPlaceholder"
        );


    preview.style.display =
        "none";


    placeholder.style.display =
        "block";
}

</script>



</body>

</html>