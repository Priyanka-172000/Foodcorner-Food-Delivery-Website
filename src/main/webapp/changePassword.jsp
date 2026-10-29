
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%
    String error = request.getParameter("error");
    String success = request.getParameter("success");
    String contextPath = request.getContextPath();
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Change Password | Foodcorner</title>
    <style>
        * {
            box-sizing: border-box;
        }

        body {
            margin: 0;
            min-height: 100vh;
            display: flex;
            align-items: center;
            justify-content: center;
            padding: 24px;
            background: #fff7f1;
            font-family: Arial, sans-serif;
            color: #292929;
        }

        .password-container {
            width: 100%;
            max-width: 440px;
            padding: 32px;
            background: #ffffff;
            border-radius: 16px;
            box-shadow: 0 8px 30px rgba(0, 0, 0, 0.09);
        }

        .brand {
            margin-bottom: 8px;
            text-align: center;
            color: #ff5200;
            font-size: 30px;
            font-weight: 800;
        }

        h1 {
            margin: 12px 0 8px;
            text-align: center;
            font-size: 24px;
        }

        .subtitle {
            margin: 0 0 24px;
            text-align: center;
            color: #777;
            font-size: 14px;
            line-height: 1.5;
        }

        .message {
            padding: 12px;
            margin-bottom: 18px;
            border-radius: 8px;
            font-size: 14px;
            line-height: 1.5;
        }

        .error {
            color: #a61b1b;
            background: #fff0f0;
            border: 1px solid #ffd0d0;
        }

        .success {
            color: #176b35;
            background: #edfff2;
            border: 1px solid #bde8c9;
        }

        .form-group {
            margin-bottom: 18px;
        }

        label {
            display: block;
            margin-bottom: 8px;
            font-size: 14px;
            font-weight: 600;
        }

        input {
            width: 100%;
            min-height: 46px;
            padding: 12px;
            border: 1px solid #d7d7d7;
            border-radius: 8px;
            outline: none;
            font-size: 15px;
        }

        input:focus {
            border-color: #ff5200;
            box-shadow: 0 0 0 3px rgba(255, 82, 0, 0.12);
        }

        .password-hint {
            display: block;
            margin-top: 6px;
            color: #777;
            font-size: 12px;
        }

        button {
            width: 100%;
            min-height: 48px;
            margin-top: 6px;
            border: none;
            border-radius: 8px;
            background: #ff5200;
            color: #ffffff;
            font-size: 16px;
            font-weight: 700;
            cursor: pointer;
        }

        button:hover {
            background: #e84900;
        }

        .back-link {
            display: block;
            margin-top: 20px;
            text-align: center;
            color: #ff5200;
            text-decoration: none;
            font-size: 14px;
        }

        .back-link:hover {
            text-decoration: underline;
        }

        @media (max-width: 480px) {
            .password-container {
                padding: 24px 20px;
            }
        }
    </style>
</head>
<body>

    <main class="password-container">
        <div class="brand">Foodcorner</div>
        <h1>Change Password</h1>
        <p class="subtitle">Verify your current password and choose a new one.</p>

        <% if ("empty".equals(error)) { %>
            <div class="message error">Please fill in all password fields.</div>
        <% } else if ("oldPassword".equals(error)) { %>
            <div class="message error">Your current password is incorrect.</div>
        <% } else if ("weak".equals(error)) { %>
            <div class="message error">Your new password must contain at least 8 characters.</div>
        <% } else if ("mismatch".equals(error)) { %>
            <div class="message error">The new password and confirmation do not match.</div>
        <% } else if ("same".equals(error)) { %>
            <div class="message error">Your new password must differ from your current password.</div>
        <% } else if ("updateFailed".equals(error)) { %>
            <div class="message error">Password could not be updated. Please try again.</div>
        <% } %>

        <% if ("updated".equals(success)) { %>
            <div class="message success">Your password has been changed successfully.</div>
        <% } %>

        <form action="<%= contextPath %>/changePassword" method="post">
            <div class="form-group">
                <label for="oldPassword">Current Password</label>
                <input
                    type="password"
                    id="oldPassword"
                    name="oldPassword"
                    autocomplete="current-password"
                    required>
            </div>

            <div class="form-group">
                <label for="newPassword">New Password</label>
                <input
                    type="password"
                    id="newPassword"
                    name="newPassword"
                    minlength="8"
                    autocomplete="new-password"
                    required>
                <span class="password-hint">Use at least 8 characters.</span>
            </div>

            <div class="form-group">
                <label for="confirmPassword">Confirm New Password</label>
                <input
                    type="password"
                    id="confirmPassword"
                    name="confirmPassword"
                    minlength="8"
                    autocomplete="new-password"
                    required>
            </div>

            <button type="submit">Update Password</button>
        </form>

        <a class="back-link" href="<%= contextPath %>/editProfile">Back to Profile</a>
    </main>

</body>
</html>
