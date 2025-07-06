<%@ Page Language="VB" AutoEventWireup="false" CodeFile="Search.aspx.vb" Inherits="Search" %>

<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
    <title>Search Products</title>
</head>

<body>
    <form id="form1" runat="server">
        <h2>Search Products</h2>

        <label for="txtSearch">Enter product name: </label>
        <input type="text" id="txtSearch" runat="server" required /><br /><br />

        <button id="btnSearch" type="submit" runat="server" onserverclick="btnSearch_ServerClick">Search</button><br /><br />

        <div id="results" runat="server"></div>
    </form>
</body>
</html>
