<%@ Page Language="VB" AutoEventWireup="false" CodeFile="AddUser.aspx.vb" Inherits="AddUser" %>
<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Add New User</title>
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
            <h2 class="header text-center mb-4">Add New User</h2>
            <div class="row justify-content-center">
                <div class="col-md-6">
                    <asp:Label ID="lblMessage" runat="server" CssClass="text-danger mb-3 d-block"></asp:Label>
                    <div class="mb-3">
                        <asp:Label ID="lblUsername" runat="server" Text="Username" CssClass="form-label"></asp:Label>
                        <asp:TextBox ID="txtUsername" runat="server" CssClass="form-control" />
                    </div>
                    <div class="mb-3">
                        <asp:Label ID="lblPassword" runat="server" Text="Password" CssClass="form-label"></asp:Label>
                        <asp:TextBox ID="txtPassword" runat="server" TextMode="Password" CssClass="form-control" />
                    </div>
                    <div class="mb-3">
                        <asp:Label ID="lblEmployee" runat="server" Text="Employee" CssClass="form-label"></asp:Label>
                        <asp:DropDownList ID="ddlEmployee" runat="server" CssClass="form-select" />
                    </div>
                    <div class="mb-3">
                        <asp:Label ID="lblRole" runat="server" Text="Role" CssClass="form-label"></asp:Label>
                        <asp:DropDownList ID="ddlRole" runat="server" CssClass="form-select" />
                    </div>
                    <div class="text-center">
                        <asp:Button ID="btnAddUser" runat="server" Text="Add User" CssClass="btn btn-dark-green" OnClick="btnAddUser_Click" />
                    </div>
                </div>
            </div>
        </div>
    </form>
</body>
</html>