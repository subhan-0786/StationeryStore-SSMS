<%@ Page Language="VB" AutoEventWireup="true" CodeFile="AddEmployee.aspx.vb" Inherits="AddEmployee" %>
<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Add Employee</title>
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
            <h2 class="header text-center mb-4">Add Employee</h2>
            <div class="row justify-content-center">
                <div class="col-md-6">
                    <asp:Label ID="lblMessage" runat="server" CssClass="text-danger mb-3 d-block" />
                    <div class="mb-3">
                        <asp:Label ID="lblEmployeeID" runat="server" Text="Employee ID" CssClass="form-label"></asp:Label>
                        <asp:TextBox ID="txtEmployeeID" runat="server" TextMode="Number" CssClass="form-control" />
                    </div>
                    <div class="mb-3">
                        <asp:Label ID="lblName" runat="server" Text="Name" CssClass="form-label"></asp:Label>
                        <asp:TextBox ID="txtName" runat="server" CssClass="form-control" />
                    </div>
                    <div class="mb-3">
                        <asp:Label ID="lblPhone" runat="server" Text="Phone" CssClass="form-label"></asp:Label>
                        <asp:TextBox ID="txtPhone" runat="server" CssClass="form-control" />
                    </div>
                    <div class="mb-3">
                        <asp:Label ID="lblEmail" runat="server" Text="Email" CssClass="form-label"></asp:Label>
                        <asp:TextBox ID="txtEmail" runat="server" TextMode="Email" CssClass="form-control" />
                    </div>
                    <div class="mb-3">
                        <asp:Label ID="lblAddress" runat="server" Text="Address" CssClass="form-label"></asp:Label>
                        <asp:TextBox ID="txtAddress" runat="server" CssClass="form-control" />
                    </div>
                    <div class="mb-3">
                        <asp:Label ID="lblCity" runat="server" Text="City" CssClass="form-label"></asp:Label>
                        <asp:TextBox ID="txtCity" runat="server" CssClass="form-control" />
                    </div>
                    <div class="mb-3">
                        <asp:Label ID="lblHireDate" runat="server" Text="Hire Date" CssClass="form-label"></asp:Label>
                        <asp:TextBox ID="txtHireDate" runat="server" TextMode="Date" CssClass="form-control" />
                    </div>
                    <div class="mb-3">
                        <asp:Label ID="lblSalary" runat="server" Text="Salary" CssClass="form-label"></asp:Label>
                        <asp:TextBox ID="txtSalary" runat="server" TextMode="Number" CssClass="form-control" />
                    </div>
                    <div class="text-center">
                        <asp:Button ID="btnAdd" runat="server" Text="Add Employee" CssClass="btn btn-dark-green" OnClick="btnAdd_Click" />
                    </div>
                </div>
            </div>
        </div>
    </form>
</body>
</html>