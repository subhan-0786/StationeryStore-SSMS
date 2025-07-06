<%@ Page Language="VB" AutoEventWireup="true" CodeFile="AddProduct.aspx.vb" Inherits="AddProduct" %>

<!DOCTYPE html>
<html>
<head>
    <title>Add Product</title>
</head>
<body>
    <form id="form1" runat="server">
        <h2>Add Product</h2>

        <div>
            <label for="txtProductID">Product ID:</label><br />
            <asp:TextBox ID="txtProductID" runat="server" />
        </div>
        <br />

        <div>
            <label for="txtProductName">Product Name:</label><br />
            <asp:TextBox ID="txtProductName" runat="server" />
        </div>
        <br />

        <div>
            <label for="txtPrice">Price:</label><br />
            <asp:TextBox ID="txtPrice" runat="server" TextMode="Number" />
        </div>
        <br />

        <div>
            <label for="txtStock">Stock Quantity:</label><br />
            <asp:TextBox ID="txtStock" runat="server" TextMode="Number" />
        </div>
        <br />

        <div>
            <label for="ddlCategory">Category:</label><br />
            <asp:DropDownList ID="ddlCategory" runat="server" />
        </div>
        <br />

        <div>
            <label for="ddlSupplier">Supplier:</label><br />
            <asp:DropDownList ID="ddlSupplier" runat="server" />
        </div>
        <br />

        <div>
            <asp:Button ID="btnAdd" runat="server" Text="Add Product" OnClick="btnAdd_Click" />
        </div>
        <br />

        <div>
            <asp:Label ID="lblMessage" runat="server" />
        </div>
    </form>
</body>
</html>
