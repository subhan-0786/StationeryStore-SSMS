<%@ Page Language="VB" AutoEventWireup="false" CodeFile="Orders.aspx.vb" Inherits="Orders" %>
<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Manage Orders - Stationery Store</title>
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
        .table-orders {
            border-color: #003300;
        }
        .form-label {
            color: #003300;
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
            <h2 class="header text-center mb-4">Manage Orders</h2>
            <div class="row justify-content-center">
                <div class="col-md-10">
                    <asp:GridView ID="gvOrders" runat="server" AutoGenerateColumns="False" DataKeyNames="Order_ID"
                        OnRowEditing="gvOrders_RowEditing" OnRowUpdating="gvOrders_RowUpdating"
                        OnRowCancelingEdit="gvOrders_RowCancelingEdit" OnRowDeleting="gvOrders_RowDeleting"
                        CssClass="table table-bordered table-orders">
                        <Columns>
                            <asp:BoundField DataField="Order_ID" HeaderText="Order ID" ReadOnly="True" />
                            <asp:BoundField DataField="Customer_Name" HeaderText="Customer Name" ReadOnly="True" />
                            <asp:BoundField DataField="Customer_ID" HeaderText="Customer ID" ReadOnly="True" />
                            <asp:BoundField DataField="Order_Date" HeaderText="Order Date" DataFormatString="{0:yyyy-MM-dd}" />
                            <asp:CommandField ShowEditButton="True" ShowDeleteButton="True" ButtonType="Button" ControlStyle-CssClass="btn btn-dark-green btn-sm" />
                        </Columns>
                    </asp:GridView>
                    <hr class="my-4" />
                    <h3 class="header mb-3">Add New Order</h3>
                    <asp:Label ID="lblMessage" runat="server" CssClass="text-danger mb-3 d-block" />
                    <div class="row">
                        <div class="col-md-6">
                            <div class="mb-3">
                                <asp:Label ID="lblOrderID" runat="server" Text="Order ID" CssClass="form-label"></asp:Label>
                                <asp:TextBox ID="txtOrderID" runat="server" CssClass="form-control" />
                            </div>
                            <div class="mb-3">
                                <asp:Label ID="lblCustomer" runat="server" Text="Customer" CssClass="form-label"></asp:Label>
                                <asp:DropDownList ID="ddlCustomer" runat="server" CssClass="form-select">
                                    <asp:ListItem Text="-- Select Customer --" Value="" />
                                </asp:DropDownList>
                            </div>
                            <div class="mb-3">
                                <asp:Label ID="lblOrderDate" runat="server" Text="Order Date" CssClass="form-label"></asp:Label>
                                <asp:TextBox ID="txtOrderDate" runat="server" TextMode="Date" CssClass="form-control" />
                            </div>
                            <div class="text-center">
                                <asp:Button ID="btnAdd" runat="server" Text="Add Order" CssClass="btn btn-dark-green" OnClick="btnAdd_Click" />
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </form>
</body>
</html>