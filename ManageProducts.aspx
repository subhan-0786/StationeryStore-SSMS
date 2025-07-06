<%@ Page Language="VB" AutoEventWireup="false" CodeFile="ManageProducts.aspx.vb" Inherits="ManageProducts" %>
<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Manage Products - Stationery Store</title>
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
        .table-products {
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
            <h2 class="header text-center mb-4">Manage Products</h2>
            <div class="row justify-content-center">
                <div class="col-md-10">
                    <asp:GridView ID="gvProducts" runat="server" AutoGenerateColumns="False" DataKeyNames="Product_ID"
                        OnRowEditing="gvProducts_RowEditing" OnRowUpdating="gvProducts_RowUpdating"
                        OnRowCancelingEdit="gvProducts_RowCancelingEdit" OnRowDeleting="gvProducts_RowDeleting"
                        CssClass="table table-bordered table-products">
                        <Columns>
                            <asp:BoundField DataField="Product_ID" HeaderText="Product ID" ReadOnly="True" />
                            <asp:BoundField DataField="Product_Name" HeaderText="Product Name" />
                            <asp:BoundField DataField="Price" HeaderText="Price" DataFormatString="{0:C}" />
                            <asp:BoundField DataField="Stock_Quantity" HeaderText="Stock" />
                            <asp:CommandField ShowEditButton="True" ShowDeleteButton="True" ButtonType="Button" ControlStyle-CssClass="btn btn-dark-green btn-sm" />
                        </Columns>
                    </asp:GridView>
                    <hr class="my-4" />
                    <h3 class="header mb-3">Add New Product</h3>
                    <asp:Label ID="lblMessage" runat="server" CssClass="text-danger mb-3 d-block" />
                    <div class="row">
                        <div class="col-md-6">
                            <div class="mb-3">
                                <asp:Label ID="lblName" runat="server" Text="Product Name" CssClass="form-label"></asp:Label>
                                <asp:TextBox ID="txtName" runat="server" CssClass="form-control" />
                            </div>
                            <div class="mb-3">
                                <asp:Label ID="lblPrice" runat="server" Text="Price" CssClass="form-label"></asp:Label>
                                <asp:TextBox ID="txtPrice" runat="server" CssClass="form-control" />
                            </div>
                            <div class="mb-3">
                                <asp:Label ID="lblStock" runat="server" Text="Stock Quantity" CssClass="form-label"></asp:Label>
                                <asp:TextBox ID="txtStock" runat="server" CssClass="form-control" />
                            </div>
                            <div class="mb-3">
                                <asp:Label ID="lblCategory" runat="server" Text="Category" CssClass="form-label"></asp:Label>
                                <asp:DropDownList ID="ddlCategory" runat="server" CssClass="form-select">
                                    <asp:ListItem Text="-- Select Category --" Value="" />
                                </asp:DropDownList>
                            </div>
                            <div class="mb-3">
                                <asp:Label ID="lblSupplier" runat="server" Text="Supplier" CssClass="form-label"></asp:Label>
                                <asp:DropDownList ID="ddlSupplier" runat="server" CssClass="form-select">
                                    <asp:ListItem Text="-- Select Supplier --" Value="" />
                                </asp:DropDownList>
                            </div>
                            <div class="text-center">
                                <asp:Button ID="btnAdd" runat="server" Text="Add Product" CssClass="btn btn-dark-green" OnClick="btnAdd_Click" />
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </form>
</body>
</html>