<%@ Page Language="VB" AutoEventWireup="true" CodeFile="Users.aspx.vb" Inherits="Users" %>

<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Manage Users</title>
</head>
<body>
    <form id="form1" runat="server">
        <!-- Main section for managing users -->
        <div>
            <h2>Manage Users</h2>

            <!-- Button to add a new user -->
            <asp:Button ID="btnAddUser" runat="server" Text="Add New User" OnClick="btnAddUser_Click" />

            <br /><br />

            <!-- GridView to display and manage users -->
            <asp:GridView ID="gvUsers" runat="server" AutoGenerateColumns="False"
                DataKeyNames="User_ID" OnRowEditing="gvUsers_RowEditing"
                OnRowCancelingEdit="gvUsers_RowCancelingEdit" OnRowUpdating="gvUsers_RowUpdating"
                OnRowDeleting="gvUsers_RowDeleting">

                <%-- Columns: displaying user details and actions --%>
                <Columns>
                    <asp:BoundField DataField="User_ID" HeaderText="User ID" ReadOnly="True" />
                    <asp:BoundField DataField="Username" HeaderText="Username" />
                    <asp:BoundField DataField="RoleName" HeaderText="Role" />
                    <asp:BoundField DataField="EmployeeName" HeaderText="Employee" />

                    <asp:TemplateField>
                        <ItemTemplate>
                            <asp:LinkButton ID="lnkEdit" runat="server" CommandName="Edit">Edit</asp:LinkButton>
                            <asp:LinkButton ID="lnkDelete" runat="server" CommandName="Delete"
                                OnClientClick="return confirm('Are you sure you want to delete this user?');">Delete</asp:LinkButton>
                        </ItemTemplate>
                        <EditItemTemplate>
                            <asp:LinkButton ID="lnkUpdate" runat="server" CommandName="Update">Update</asp:LinkButton>
                            <asp:LinkButton ID="lnkCancel" runat="server" CommandName="Cancel">Cancel</asp:LinkButton>
                        </EditItemTemplate>
                    </asp:TemplateField>
                </Columns>
            </asp:GridView>
            <!-- Back Button -->
            <div>
                <button onclick="window.history.back()">Go Back</button>
            </div>
        </div>
    </form>
</body>
</html>
