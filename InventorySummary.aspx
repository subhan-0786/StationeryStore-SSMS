<%@ Page Language="VB" AutoEventWireup="false" CodeFile="InventorySummary.aspx.vb" Inherits="InventorySummary" %>
<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Inventory Summary - Stationery Store</title>
    <!-- Bootstrap CSS CDN -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet" integrity="sha384-QWTKZyjpPEjISv5WaRU9OFeRpok6YctnYmDr5pNlyT2bRjXh0JMhjY6hW+ALEwIH" crossorigin="anonymous">
    <style>
        /* Minimal darker green styling */
        .btn-dark-green {
            background-color: #003300;
            border-color: #003300;
            color: white;
        }
        .header {
            color: #003300;
        }
        .table-inventory {
            border-color: #003300;
        }
    </style>
</head>
<body>
    <form id="form1" runat="server">
        <div class="container mt-3">
            <!-- Navigation Buttons -->
            <div class="d-flex justify-content-between mb-3">
                <asp:Button ID="btnBack" runat="server" Text="Back" CssClass="btn btn-dark-green" OnClientClick="history.back(); return false;" />
                <asp:Button ID="btnLogout" runat="server" Text="Logout" CssClass="btn btn-dark-green" PostBackUrl="~/Logout.aspx" />
            </div>
            <!-- Page Content -->
            <h2 class="header text-center mb-4">Inventory Summary</h2>
            <div class="row justify-content-center">
                <div class="col-md-10">
                    <asp:Label ID="lblError" runat="server" CssClass="text-danger mb-3 d-block" Visible="False" />
                    <asp:GridView ID="GridViewInventory" runat="server" AutoGenerateColumns="False"
                        CssClass="table table-bordered table-inventory" GridLines="None" CellPadding="5">
                        <Columns>
                            <asp:BoundField DataField="Product_Name" HeaderText="Product Name" />
                            <asp:BoundField DataField="Stock_Quantity" HeaderText="Stock Quantity" />
                            <asp:BoundField DataField="Supplier_Name" HeaderText="Supplier" />
                            <asp:BoundField DataField="Category_Name" HeaderText="Category" />
                        </Columns>
                    </asp:GridView>
                </div>
            </div>
        </div>
    </form>
</body>
</html>