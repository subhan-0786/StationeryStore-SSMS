<%@ Page Language="VB" AutoEventWireup="true" CodeFile="Suppliers.aspx.vb" Inherits="Suppliers" %>

<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Suppliers - Stationery Store</title>
</head>
<body>
    <form id="form1" runat="server">
        <h2>Supplier Information</h2>
        <asp:Literal ID="litSuppliers" runat="server"></asp:Literal>
        <asp:Label ID="lblError" runat="server" ForeColor="Red" Visible="false"></asp:Label>
        <br />
        <a href="Dashboard.aspx">Back to Dashboard</a>
    </form>
</body>
</html>
