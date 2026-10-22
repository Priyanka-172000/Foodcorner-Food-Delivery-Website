<%@ page language="java"
    contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<%@ page import="com.tap.model.User" %>

<!DOCTYPE html>
<html>

<head>

<meta charset="UTF-8">

<meta name="viewport"
      content="width=device-width, initial-scale=1.0">

<title>Foodcorner | Edit Profile</title>

<style>

* {
    margin: 0;
    padding: 0;
    box-sizing: border-box;
}

body {
    font-family: Arial, Helvetica, sans-serif;

    background:
        linear-gradient(
            135deg,
            #fff1e9,
            #fff8f4
        );

    color: #222;

    min-height: 100vh;
}


/* NAVBAR */

.navbar {
    background: white;

    padding: 18px 7%;

    display: flex;

    justify-content: space-between;

    align-items: center;

    box-shadow:
        0 2px 12px rgba(0,0,0,0.08);
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

    font-size: 15px;

    font-weight: bold;
}


/* MAIN */

.profile-wrapper {
    min-height:
        calc(100vh - 75px);

    display: flex;

    justify-content: center;

    align-items: center;

    padding: 45px 20px;
}


/* CARD */

.profile-card {
    width: 100%;

    max-width: 540px;

    background: white;

    border-radius: 18px;

    padding: 35px;

    border:
        1px solid #eeeeee;

    box-shadow:
        0 12px 35px
        rgba(0,0,0,0.10);
}

.profile-card h1 {
    font-size: 31px;

    text-align: center;

    margin-bottom: 8px;
}

.profile-card h1 span {
    color: #ff5200;
}

.subtitle {
    text-align: center;

    color: #777;

    font-size: 14px;

    margin-bottom: 30px;
}


/* FORM */

.form-group {
    margin-bottom: 18px;
}

.form-group label {
    display: block;

    margin-bottom: 7px;

    font-size: 14px;

    font-weight: bold;
}

.form-control {
    width: 100%;

    padding: 12px 13px;

    border:
        1px solid #dddddd;

    border-radius: 9px;

    outline: none;

    font-size: 14px;

    transition: 0.2s;
}

.form-control:focus {
    border-color: #ff5200;

    box-shadow:
        0 0 0 2px
        rgba(255,82,0,0.08);
}

textarea.form-control {
    min-height: 95px;

    resize: vertical;

    font-family:
        Arial,
        Helvetica,
        sans-serif;
}


/* EMAIL READONLY */

.readonly {
    background: #f5f5f5;

    color: #777;

    cursor: not-allowed;
}


/* BUTTONS */

.update-btn {
    width: 100%;

    margin-top: 8px;

    padding: 13px;

    border: none;

    border-radius: 9px;

    background: #ff5200;

    color: white;

    font-size: 15px;

    font-weight: bold;

    cursor: pointer;

    transition: 0.2s;
}

.update-btn:hover {
    background: #e94a00;
}

.cancel-btn {
    display: block;

    width: 100%;

    margin-top: 10px;

    padding: 12px;

    border:
        1px solid #dddddd;

    border-radius: 9px;

    background: white;

    color: #555;

    text-align: center;

    text-decoration: none;

    font-size: 14px;

    font-weight: bold;
}

.cancel-btn:hover {
    background: #f7f7f7;
}


/* MESSAGE */

.message {
    padding: 11px;

    margin-bottom: 18px;

    border-radius: 8px;

    text-align: center;

    font-size: 14px;
}

.success {
    background: #e5f7ea;

    color: #16883e;
}

.error {
    background: #ffe5e5;

    color: #c62828;
}


/* MOBILE */

@media(max-width:600px) {

    .profile-card {
        padding: 25px;
    }

    .profile-card h1 {
        font-size: 27px;
    }

}

</style>

</head>


<body>


<%

User user =
        (User) request.getAttribute("user");


if (user == null) {

    response.sendRedirect(
            request.getContextPath()
            + "/login.jsp"
    );

    return;
}

%>



<!-- NAVBAR -->

<nav class="navbar">


    <div class="logo">

        Food<span>corner</span>

    </div>


    <a
        class="back-link"

        href="<%= request.getContextPath() %>/restaurant">

        ← Home

    </a>


</nav>



<!-- EDIT PROFILE -->

<div class="profile-wrapper">


    <div class="profile-card">


        <h1>

            Edit
            <span>Profile</span>

        </h1>


        <div class="subtitle">

            Update your Foodcorner account details.

        </div>



        <!-- SUCCESS MESSAGE -->

<%

String updated =
        request.getParameter("updated");


if ("true".equals(updated)) {

%>


        <div class="message success">

            Profile updated successfully.

        </div>


<%

}

%>



        <!-- ERROR MESSAGE -->

<%

String error =
        request.getParameter("error");


if ("true".equals(error)) {

%>


        <div class="message error">

            Unable to update profile.
            Please try again.

        </div>


<%

}

%>



        <form
            action="<%= request.getContextPath() %>/updateProfile"

            method="post">


            <!-- USER ID -->

            <input
                type="hidden"

                name="userId"

                value="<%= user.getUserId() %>">



            <!-- NAME -->

            <div class="form-group">


                <label for="username">

                    Full Name

                </label>


                <input
                    id="username"

                    class="form-control"

                    type="text"

                    name="username"

                    value="<%= user.getUsername() %>"

                    required>


            </div>



            <!-- EMAIL -->

            <div class="form-group">


                <label for="email">

                    Email

                </label>


                <input
                    id="email"

                    class="form-control readonly"

                    type="email"

                    name="email"

                    value="<%= user.getEmail() %>"

                    readonly>


            </div>



            <!-- PHONE -->

            <div class="form-group">


                <label for="phone">

                    Phone Number

                </label>


                <input
                    id="phone"

                    class="form-control"

                    type="tel"

                    name="phone"

                    value="<%= user.getPhone() %>"

                    required>


            </div>



            <!-- ADDRESS -->

            <div class="form-group">


                <label for="address">

                    Address

                </label>


                <textarea
                    id="address"

                    class="form-control"

                    name="address"

                    required><%= user.getAddress() %></textarea>


            </div>



            <!-- PASSWORD -->

            <div class="form-group">


                <label for="password">

                    Password

                </label>


                <input
                    id="password"

                    class="form-control"

                    type="password"

                    name="password"

                    value="<%= user.getPassword() %>"

                    required>


            </div>



            <!-- UPDATE -->

            <button
                type="submit"

                class="update-btn">

                Update Profile

            </button>



            <!-- CANCEL -->

            <a
                class="cancel-btn"

                href="<%= request.getContextPath() %>/restaurant">

                Cancel

            </a>


        </form>


    </div>


</div>


</body>

</html>