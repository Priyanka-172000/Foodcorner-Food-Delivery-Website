<%@ page language="java"
    contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<!DOCTYPE html>
<html>

<head>

<meta charset="UTF-8">

<meta name="viewport"
      content="width=device-width, initial-scale=1.0">

<title>Foodcorner | Register</title>

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

.register-wrapper {
    min-height:
        calc(100vh - 75px);

    display: flex;

    justify-content: center;

    align-items: center;

    padding: 45px 20px;
}


/* CARD */

.register-card {
    width: 100%;

    max-width: 520px;

    background: white;

    border-radius: 18px;

    padding: 35px;

    border:
        1px solid #eeeeee;

    box-shadow:
        0 12px 35px
        rgba(0,0,0,0.10);
}


.register-card h1 {
    font-size: 31px;

    margin-bottom: 8px;

    text-align: center;
}

.register-card h1 span {
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
    min-height: 90px;

    resize: vertical;

    font-family:
        Arial,
        Helvetica,
        sans-serif;
}


/* REGISTER BUTTON */

.register-btn {
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

.register-btn:hover {
    background: #e94a00;
}


/* LOGIN LINK */

.login-text {
    text-align: center;

    margin-top: 22px;

    color: #666;

    font-size: 14px;
}

.login-text a {
    color: #ff5200;

    text-decoration: none;

    font-weight: bold;
}


/* MESSAGE */

.message {
    padding: 11px;

    margin-bottom: 18px;

    border-radius: 8px;

    text-align: center;

    font-size: 14px;
}

.error {
    background: #ffe5e5;

    color: #c62828;
}

.success {
    background: #e5f7ea;

    color: #16883e;
}


/* MOBILE */

@media(max-width:600px) {

    .register-card {
        padding: 25px;
    }

    .register-card h1 {
        font-size: 27px;
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


    <a
        class="back-link"

        href="<%= request.getContextPath() %>/restaurant">

        ← Restaurants

    </a>

</nav>



<div class="register-wrapper">


    <div class="register-card">


        <h1>

            Create
            <span>Account</span>

        </h1>


        <div class="subtitle">

            Register to order your favourite food.

        </div>



        <!-- ERROR MESSAGE -->

<%

String error =
        request.getParameter("error");

if ("emailExists".equals(error)) {

%>

        <div class="message error">

            Email already registered.

        </div>

<%

}

%>



        <!-- REGISTRATION FORM -->

        <form
            action="<%= request.getContextPath() %>/register"

            method="post">


            <!-- USERNAME -->

            <div class="form-group">

                <label for="username">

                    Full Name

                </label>


                <input
                    id="username"

                    class="form-control"

                    type="text"

                    name="username"

                    placeholder="Enter your full name"

                    required>

            </div>



            <!-- EMAIL -->

            <div class="form-group">

                <label for="email">

                    Email

                </label>


                <input
                    id="email"

                    class="form-control"

                    type="email"

                    name="email"

                    placeholder="Enter your email"

                    required>

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

                    placeholder="Enter your phone number"

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

                    placeholder="Enter your delivery address"

                    required></textarea>

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

                    placeholder="Create a password"

                    required>

            </div>



            <!-- ROLE -->

            <input
                type="hidden"

                name="role"

                value="CUSTOMER">



            <!-- BUTTON -->

            <button
                type="submit"

                class="register-btn">

                Create Account

            </button>


        </form>



        <div class="login-text">

            Already have an account?

            <a
                href="<%= request.getContextPath() %>/login.jsp">

                Login

            </a>

        </div>


    </div>


</div>


</body>

</html>