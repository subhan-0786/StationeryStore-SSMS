<%@ Page Language="vb" AutoEventWireup="false" CodeFile="PlaceOrder.aspx.vb" Inherits="PlaceOrder" %>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>Place Order</title>
</head>
<body>
    <form id="formPlaceOrder" runat="server">
        <h2>Place Order</h2>

        <div>
            <label for="ddlCustomer">Select Customer:</label><br />
            <asp:DropDownList ID="ddlCustomer" runat="server" AutoPostBack="false" AppendDataBoundItems="True">
                <asp:ListItem Text="-- Select Customer --" Value="" />
            </asp:DropDownList>
        </div>
        <br />

        <div>
            <label for="ddlProduct">Select Product:</label><br />
            <asp:DropDownList ID="ddlProduct" runat="server" AutoPostBack="false" AppendDataBoundItems="True">
                <asp:ListItem Text="-- Select Product --" Value="" />
            </asp:DropDownList>
        </div>
        <br />

        <div>
            <label for="txtQuantity">Quantity:</label><br />
            <asp:TextBox ID="txtQuantity" runat="server" TextMode="Number" />
        </div>
        <br />

        <div>
            <asp:Button ID="btnPlaceOrder" runat="server" Text="Place Order" OnClick="btnPlaceOrder_Click" />
        </div>
        <br />

        <div>
            <asp:Label ID="lblMessage" runat="server"></asp:Label>
        </div>
    </form>
</body>
</html>
