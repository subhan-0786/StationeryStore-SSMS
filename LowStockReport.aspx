<%@ Page Language="VB" AutoEventWireup="false" CodeFile="LowStockReport.aspx.vb" Inherits="LowStockReport" %>
<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Low Stock Report - Stationery Store</title>
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
        .table-lowstock {
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
            <h2 class="header text-center mb-4">Low Stock Report</h2>
            <div class="row justify-content-center">
                <div class="col-md-10">
                    <asp:Label ID="lblMessage" runat="server" CssClass="text-info mb-3 d-block" 
                        Text="This page is under development and will be available soon with a detailed low stock report." />
                    <!-- Placeholder GridView; ReorderLevel column included but not in Product schema yet -->
                    <asp:GridView ID="gvLowStock" runat="server" AutoGenerateColumns="False" 
                        CssClass="table table-bordered table-lowstock" Visible="False">
                        <Columns>
                            <asp:BoundField DataField="Product_ID" HeaderText="Product ID" />
                            <asp:BoundField DataField="Product_Name" HeaderText="Product Name" />
                            <asp:BoundField DataField="Stock_Quantity" HeaderText="Stock Quantity" />
                            <asp:BoundField DataField="ReorderLevel" HeaderText="Reorder Level" />
                        </Columns>
                    </asp:GridView>
                </div>
            </div>
        </div>
    </form>
</body>
</html>