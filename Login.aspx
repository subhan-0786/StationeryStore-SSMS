<%@ Page Language="VB" AutoEventWireup="true" CodeFile="Login.aspx.vb" Inherits="Login" %>
<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Subhan Stationery Store</title>
    <!-- Bootstrap CSS CDN -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet" integrity="sha384-QWTKZyjpPEjISv5WaRU9OFeRpok6YctnYmDr5pNlyT2bRjXh0JMhjY6hW+ALEwIH" crossorigin="anonymous">
    <style>
        /* Minimal dark green styling */
        .btn-dark-green {
            background-color: #006400;
            border-color: #006400;
            color: white;
        }
        .header {
            color: #006400;
        }
        .table-credentials {
            border-color: #006400;
        }
    </style>
</head>
<body>
    <form id="form1" runat="server">
        <div class="container">
        <br />
        <br />
        <br />
            <h2 class="header">Welcome to Subhan's Stationery Store</h2>
            <div>
                <asp:Label ID="lblUsername" runat="server" Text="Username"></asp:Label><br />
                <asp:TextBox ID="txtUsername" runat="server" CssClass="form-control"></asp:TextBox>
            </div>
            <br />
            <div>
                <asp:Label ID="lblPassword" runat="server" Text="Password"></asp:Label><br />
                <asp:TextBox ID="txtPassword" runat="server" TextMode="Password" CssClass="form-control"></asp:TextBox>
            </div>
            <br />
            <div>
                <asp:Button ID="btnLogin" runat="server" Text="Login" CssClass="btn btn-dark-green" OnClick="btnLogin_Click" />
            </div>
            <br />
            <div>
                <asp:Label ID="lblError" runat="server" CssClass="text-danger" Visible="false"></asp:Label>
            </div>
            <!-- Credentials Table -->
            <div>
        <br />
        <br />
                <table class="table table-bordered table-credentials">
                    <thead>
                        <tr>
                            <th>Username</th>
                            <th>Password</th>
                        </tr>
                    </thead>
                    <tbody>
                        <tr>
                            <td>admin</td>
                            <td>admin123</td>
                        </tr>
                        <tr>
                            <td>manager</td>
                            <td>manager123</td>
                        </tr>
                        <tr>
                            <td>sales</td>
                            <td>sales123</td>
                        </tr>
                    </tbody>
                </table>
            </div>
        </div>
    </form>
</body>
</html>