<%@ Page Language="VB" AutoEventWireup="true" CodeFile="Employees.aspx.vb" Inherits="Employees" %>
<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Manage Employees</title>
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
        .table-employees {
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
            <h2 class="header text-center mb-4">Manage Employees</h2>
            <div class="row justify-content-center">
                <div class="col-md-10">
                    <div class="mb-3 text-center">
                        <asp:Button ID="btnAddEmployee" runat="server" Text="Add New Employee" CssClass="btn btn-dark-green" OnClick="btnAddEmployee_Click" />
                    </div>
                    <asp:GridView ID="gvEmployees" runat="server" AutoGenerateColumns="False"
                        DataKeyNames="Employee_ID"
                        OnRowEditing="gvEmployees_RowEditing"
                        OnRowCancelingEdit="gvEmployees_RowCancelingEdit"
                        OnRowUpdating="gvEmployees_RowUpdating"
                        OnRowDeleting="gvEmployees_RowDeleting"
                        CssClass="table table-bordered table-employees">
                        <Columns>
                            <asp:BoundField DataField="Employee_ID" HeaderText="Employee ID" ReadOnly="True" />
                            <asp:BoundField DataField="Employee_Name" HeaderText="Employee Name" />
                            <asp:BoundField DataField="Phone" HeaderText="Phone" />
                            <asp:BoundField DataField="Email" HeaderText="Email" />
                            <asp:BoundField DataField="Address" HeaderText="Address" />
                            <asp:BoundField DataField="City" HeaderText="City" />
                            <asp:BoundField DataField="Hire_Date" HeaderText="Hire Date" DataFormatString="{0:yyyy-MM-dd}" />
                            <asp:BoundField DataField="Salary" HeaderText="Salary" DataFormatString="{0:C2}" />
                            <asp:CommandField ShowEditButton="True" ShowDeleteButton="True" ButtonType="Button" ControlStyle-CssClass="btn btn-dark-green btn-sm" />
                        </Columns>
                    </asp:GridView>
                    <asp:Label ID="lblConfirmationMessage" runat="server" Text="" Visible="False" CssClass="text-danger mt-3 d-block" />
                    <asp:Panel ID="confirmDelete" runat="server" Visible="False" CssClass="mt-3 text-center">
                        <p><strong>Are you sure you want to delete this employee?</strong></p>
                        <asp:Button ID="btnConfirmDelete" runat="server" Text="Yes" CssClass="btn btn-dark-green btn-sm me-2" OnClick="btnConfirmDelete_Click" />
                        <asp:Button ID="btnCancelDelete" runat="server" Text="No" CssClass="btn btn-dark-green btn-sm" OnClick="btnCancelDelete_Click" />
                    </asp:Panel>
                </div>
            </div>
        </div>
    </form>
</body>
</html>