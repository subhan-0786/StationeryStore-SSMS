<%@ Page Language="VB" %>
<!DOCTYPE html>
<html>
<head>
    <title>Security Features Demo - Subhan Amjad</title>
</head>
<body>
    <h1>Security Features Demo</h1>
    <ol>
        <li><strong>Password Hashing with Salt (PBKDF2)</strong><br />
        <a href="AddUser.aspx">Go to Add User Page</a></li>
        > Create a user and verify hashed password + salt in DB.

        <li><strong>Session Timeout (5 minutes)</strong><br />
        <a href="Login.aspx">Go to Login Page</a></li>
        > Log in, stay idle for 5 mins, session will expire automatically.

        <li><strong>HttpOnly and Secure Cookies</strong><br />
        <a href="Login.aspx">Log in</a></li>
        > Check that cookies are marked `HttpOnly` and sent only on HTTPS.

        <li><strong>SQL Injection Protection</strong><br />
        <a href="Login.aspx">Go to Login Page</a></li>
        > → Try inputting `' OR '1'='1` ~ system blocks it.

        <li><strong>Audit Logging for Login Attempts</strong><br />
        <a href="Login.aspx">Go to Login Page</a></li>
        > Check your DB table (LoginAudit or similar) after login.

        <li><strong>Role-Based Access Control Foundation</strong><br />
        <a href="Login.aspx">Go to Login Page</a></li>
        > Use different role accounts (admin/user) ~ redirect varies.

        <li><strong>Username Uniqueness & User Validity</strong><br />
        <a href="AddUser.aspx">Go to Add User Page</a></li>
        > Try registering with an existing username → gets rejected.
    </ol>
</body>
</html>
