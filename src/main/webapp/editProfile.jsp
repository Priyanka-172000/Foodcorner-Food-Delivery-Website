
<%@ page import="com.tap.model.User" %>
<%
    User user = (User) request.getAttribute("user");

    if (user == null) {
        response.sendRedirect(request.getContextPath() + "/login.jsp");
        return;
    }

    String contextPath = request.getContextPath();
    String updated = request.getParameter("updated");
    String error = request.getParameter("error");
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Edit Profile | Foodcorner</title>
    <style>
        * {
            box-sizing: border-box;
        }

        body {
            margin: 0;
            font-family: Arial, sans-serif;
            background: #fff7f0;
            color: #333;
        }

        .navbar {
            background: #ff6b00;
            color: white;
            padding: 18px 7%;
            display: flex;
            align-items: center;
            justify-content: space-between;
            gap: 15px;
            flex-wrap: wrap;
        }

        .logo {
            font-size: 25px;
            font-weight: bold;
            color: white;
            text-decoration: none;
        }

        .home-link {
            color: white;
            text-decoration: none;
            font-weight: bold;
        }

        .container {
            width: 90%;
            max-width: 560px;
            margin: 40px auto;
            padding: 30px;
            background: white;
            border-radius: 14px;
            box-shadow: 0 5px 22px rgba(0, 0, 0, 0.08);
        }

        h2 {
            margin-top: 0;
            margin-bottom: 8px;
            color: #ff6b00;
            text-align: center;
        }

        .subtitle {
            text-align: center;
            color: #777;
            margin-bottom: 25px;
        }

        .message {
            padding: 12px;
            border-radius: 7px;
            margin-bottom: 18px;
            text-align: center;
            font-size: 14px;
        }

        .success {
            color: #176b35;
            background: #e8f8ed;
        }

        .error {
            color: #a32121;
            background: #ffeded;
        }

        .form-group {
            margin-bottom: 18px;
        }

        label {
            display: block;
            margin-bottom: 7px;
            font-weight: bold;
            font-size: 14px;
        }

        .form-control {
            width: 100%;
            padding: 12px;
            border: 1px solid #ddd;
            border-radius: 7px;
            font-size: 15px;
            outline: none;
        }

        .form-control:focus {
            border-color: #ff6b00;
            box-shadow: 0 0 0 2px rgba(255, 107, 0, 0.12);
        }

        .form-control[readonly] {
            background: #f3f3f3;
            color: #666;
        }

        .btn {
            display: block;
            width: 100%;
            padding: 13px;
            border: none;
            border-radius: 7px;
            background: #ff6b00;
            color: white;
            font-size: 16px;
            font-weight: bold;
            cursor: pointer;
            text-align: center;
            text-decoration: none;
        }

        .btn:hover {
            background: #e85f00;
        }

        .secondary-links {
            margin-top: 20px;
            display: flex;
            flex-direction: column;
            gap: 13px;
            text-align: center;
        }

        .secondary-links a {
            color: #e85f00;
            text-decoration: none;
            font-weight: bold;
        }

        .secondary-links a:hover {
            text-decoration: underline;
        }

        @media (max-width: 480px) {
            .container {
                padding: 22px 18px;
                margin: 25px auto;
            }

            .navbar {
                padding: 16px 5%;
            }
        }
    </style>
</head>
<body>

    <nav class="navbar">
        <a class="logo" href="<%= contextPath %>/restaurant">Foodcorner</a>
        <a class="home-link" href="<%= contextPath %>/restaurant">Home</a>
    </nav>

    <main class="container">
        <h2>Edit Profile</h2>
        <p class="subtitle">Update your account information</p>

        <% if ("true".equals(updated)) { %>
            <div class="message success">
                Profile updated successfully.
            </div>
        <% } %>

        <% if ("true".equals(error)) { %>
            <div class="message error">
                Unable to update your profile. Please check your details and try again.
            </div>
        <% } %>

        <form action="<%= contextPath %>/updateProfile" method="post">
            <div class="form-group">
                <label for="username">Username</label>
                <input
                    id="username"
                    class="form-control"
                    type="text"
                    name="username"
                    value="<%= user.getUsername() == null ? "" : user.getUsername() %>"
                    required>
            </div>

            <div class="form-group">
                <label for="email">Email</label>
                <input
                    id="email"
                    class="form-control"
                    type="email"
                    name="email"
                    value="<%= user.getEmail() == null ? "" : user.getEmail() %>"
                    readonly>
            </div>

            <div class="form-group">
                <label for="phone">Phone</label>
                <input
                    id="phone"
                    class="form-control"
                    type="tel"
                    name="phone"
                    value="<%= user.getPhone() == null ? "" : user.getPhone() %>"
                    required>
            </div>

            <div class="form-group">
                <label for="address">Address</label>
                <textarea
                    id="address"
                    class="form-control"
                    name="address"
                    rows="3"
                    required><%= user.getAddress() == null ? "" : user.getAddress() %></textarea>
            </div>

            <button class="btn" type="submit">Save Changes</button>
        </form>

        <div class="secondary-links">
            <a href="<%= contextPath %>/changePassword">Change Password</a>
            <a href="<%= contextPath %>/restaurant">Cancel and Return Home</a>
        </div>
    </main>

</body>
</html>
