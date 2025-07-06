Partial Class Roles
    Inherits System.Web.UI.Page

    Protected Sub Page_Load(sender As Object, e As EventArgs) Handles Me.Load
        If Not IsPostBack Then
            ' Check if user is logged in and has Admin role (RoleID = 1)
            If Session("UserID") Is Nothing OrElse Session("RoleID") Is Nothing Then
                Response.Redirect("Login.aspx")
            ElseIf Convert.ToInt32(Session("RoleID")) <> 1 Then
                ' Redirect non-admins to dashboard
                Response.Redirect("Dashboard.aspx")
            Else
                ' Load roles for admin
                LoadRoles()
            End If
        End If
    End Sub

    Private Sub LoadRoles()
        Try
            ' Use your database connection string (update as per your configuration)
            Dim connectionString As String = ConfigurationManager.ConnectionStrings("myconnstr").ConnectionString
            Using conn As New System.Data.SqlClient.SqlConnection(connectionString)
                Dim query As String = "SELECT Role_ID, Role_Name FROM Role_t ORDER BY Role_ID"
                Using cmd As New System.Data.SqlClient.SqlCommand(query, conn)
                    conn.Open()
                    Using reader As System.Data.SqlClient.SqlDataReader = cmd.ExecuteReader()
                        Dim html As New StringBuilder()
                        html.Append("<table class='table table-bordered table-roles'>")
                        html.Append("<thead><tr><th>Role ID</th><th>Role Name</th></tr></thead>")
                        html.Append("<tbody>")
                        If reader.HasRows Then
                            While reader.Read()
                                html.Append("<tr>")
                                html.Append("<td>" & reader("Role_ID").ToString() & "</td>")
                                html.Append("<td>" & Server.HtmlEncode(reader("Role_Name").ToString()) & "</td>")
                                html.Append("</tr>")
                            End While
                        Else
                            html.Append("<tr><td colspan='2'>No roles found.</td></tr>")
                        End If
                        html.Append("</tbody>")
                        html.Append("</table>")
                        litRoles.Text = html.ToString()
                    End Using
                    conn.Close()
                End Using
            End Using
        Catch ex As Exception
            lblError.Text = "Error loading roles: " & Server.HtmlEncode(ex.Message)
            lblError.Visible = True
        End Try
    End Sub
End Class