<%@ Page Language="VB" AutoEventWireup="true" CodeFile="Dashboard.aspx.vb" Inherits="_Default" %>
<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Dashboard - Stationery Store</title>
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
        .card {
            border-color: #003300;
            margin-bottom: 1rem;
        }
        .card-header {
            background-color: #e6f0e6; /* Lighter green background for card headers */
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
            <h2 class="header text-center mb-4">Welcome to the Stationery Store Dashboard</h2>
            <div class="row">
                <!-- Admin Panel -->
                <asp:PlaceHolder ID="phAdmin" runat="server" Visible="false">
                    <div class="col-md-3">
                        <div class="card">
                            <div class="card-header"><h5>Manage Users</h5></div>
                            <div class="card-body">
                                <asp:Button ID="btnManageUsers" runat="server" Text="Go to Users" CssClass="btn btn-dark-green w-100" PostBackUrl="~/AddUser.aspx" />
                            </div>
                        </div>
                    </div>
                    <div class="col-md-3">
                        <div class="card">
                            <div class="card-header"><h5>Manage Employees</h5></div>
                            <div class="card-body">
                                <asp:Button ID="btnManageEmployees" runat="server" Text="Go to Employees" CssClass="btn btn-dark-green w-100" PostBackUrl="~/Employees.aspx" />
                            </div>
                        </div>
                    </div>
                    <div class="col-md-3">
                        <div class="card">
                            <div class="card-header"><h5>View System Roles</h5></div>
                            <div class="card-body">
                                <asp:Button ID="btnViewRoles" runat="server" Text="Go to Roles" CssClass="btn btn-dark-green w-100" PostBackUrl="~/Roles.aspx" />
                            </div>
                        </div>
                    </div>
                    <div class="col-md-3">
                        <div class="card">
                            <div class="card-header"><h5>Check Audit Logs</h5></div>
                            <div class="card-body">
                                <asp:Button ID="btnAuditLogs" runat="server" Text="Go to Audit Logs" CssClass="btn btn-dark-green w-100" PostBackUrl="~/LoginAudit.aspx" />
                            </div>
                        </div>
                    </div>
                </asp:PlaceHolder>
                <!-- Manager Panel -->
                <asp:PlaceHolder ID="phManager" runat="server" Visible="false">
                    <div class="col-md-4">
                        <div class="card">
                            <div class="card-header"><h5>Manage Products</h5></div>
                            <div class="card-body">
                                <asp:Button ID="btnManageProducts" runat="server" Text="Go to Products" CssClass="btn btn-dark-green w-100" PostBackUrl="~/ManageProducts.aspx" />
                            </div>
                        </div>
                    </div>
                    <div class="col-md-4">
                        <div class="card">
                            <div class="card-header"><h5>View Orders</h5></div>
                            <div class="card-body">
                                <asp:Button ID="btnViewOrders" runat="server" Text="Go to Orders" CssClass="btn btn-dark-green w-100" PostBackUrl="~/Orders.aspx" />
                            </div>
                        </div>
                    </div>
                    <div class="col-md-4">
                        <div class="card">
                            <div class="card-header"><h5>Inventory Summary</h5></div>
                            <div class="card-body">
                                <asp:Button ID="btnInventorySummary" runat="server" Text="Go to Summary" CssClass="btn btn-dark-green w-100" PostBackUrl="~/InventorySummary.aspx" />
                            </div>
                        </div>
                    </div>
                    <div class="col-md-4">
                        <div class="card">
                            <div class="card-header"><h5>Low Stock Report</h5></div>
                            <div class="card-body">
                                <asp:Button ID="btnLowStock" runat="server" Text="Go to Low Stock" CssClass="btn btn-dark-green w-100" PostBackUrl="~/LowStockReport.aspx" />
                            </div>
                        </div>
                    </div>
                    <div class="col-md-4">
                        <div class="card">
                            <div class="card-header"><h5>Inventory Transactions</h5></div>
                            <div class="card-body">
                                <asp:Button ID="btnInventoryTrans" runat="server" Text="Go to Transactions" CssClass="btn btn-dark-green w-100" PostBackUrl="~/InventoryTransactions.aspx" />
                            </div>
                        </div>
                    </div>
                    <div class="col-md-4">
                        <div class="card">
                            <div class="card-header"><h5>Supplier Info</h5></div>
                            <div class="card-body">
                                <asp:Button ID="btnSuppliers" runat="server" Text="Go to Suppliers" CssClass="btn btn-dark-green w-100" PostBackUrl="~/Suppliers.aspx" />
                            </div>
                        </div>
                    </div>
                </asp:PlaceHolder>
                <!-- Salesperson Panel -->
                <asp:PlaceHolder ID="phSalesperson" runat="server" Visible="false">
                    <div class="col-md-3">
                        <div class="card">
                            <div class="card-header"><h5>Place Orders</h5></div>
                            <div class="card-body">
                                <asp:Button ID="btnPlaceOrders" runat="server" Text="Go to Orders" CssClass="btn btn-dark-green w-100" PostBackUrl="~/PlaceOrder.aspx" />
                            </div>
                        </div>
                    </div>
                    <div class="col-md-3">
                        <div class="card">
                            <div class="card-header"><h5>Add Products</h5></div>
                            <div class="card-body">
                                <asp:Button ID="btnAddProducts" runat="server" Text="Go to Add Products" CssClass="btn btn-dark-green w-100" PostBackUrl="~/AddProduct.aspx" />
                            </div>
                        </div>
                    </div>
                    <div class="col-md-3">
                        <div class="card">
                            <div class="card-header"><h5>Customer Details</h5></div>
                            <div class="card-body">
                                <asp:Button ID="btnCustomers" runat="server" Text="Go to Customers" CssClass="btn btn-dark-green w-100" PostBackUrl="~/Customers.aspx" />
                            </div>
                        </div>
                    </div>
                    <div class="col-md-3">
                        <div class="card">
                            <div class="card-header"><h5>Search Products</h5></div>
                            <div class="card-body">
                                <asp:Button ID="btnSearchProducts" runat="server" Text="Go to Search" CssClass="btn btn-dark-green w-100" PostBackUrl="~/Search.aspx" />
                            </div>
                        </div>
                    </div>
                </asp:PlaceHolder>
                <!-- Unauthorized Role -->
                <asp:PlaceHolder ID="phUnauthorized" runat="server" Visible="false">
                    <div class="col-md-12">
                        <div class="card">
                            <div class="card-header"><h5>Unauthorized Role</h5></div>
                        </div>
                    </div>
                </asp:PlaceHolder>
            </div>
        </div>
    </form>
    <!-- Bootstrap JS CDN (optional, for card interactions) -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js" integrity="sha384-YvpcrYf0tY3lHB60NNkmXc5s9fDVZLESaAA55NDzOxhy9GkcIdslK1eN7N6jIeHz" crossorigin="anonymous"></script>
</body>
</html>