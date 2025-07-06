Partial Class LoginAudit
    Inherits System.Web.UI.Page

    Protected Sub Page_Load(sender As Object, e As EventArgs) Handles Me.Load
        If Not IsPostBack Then
            ' Security check: user must be logged in and have Admin role (RoleID = 1)
            If Session("UserID") Is Nothing OrElse Session("RoleID") Is Nothing Then
                Response.Redirect("Login.aspx")
            ElseIf Convert.ToInt32(Session("RoleID")) <> 1 Then
                ' Redirect non-admins to dashboard
                Response.Redirect("Dashboard.aspx")
            Else
                LoadAuditLogs()
            End If
        End If
    End Sub

    Private Sub LoadAuditLogs()
        Try
            Dim connectionString As String = ConfigurationManager.ConnectionStrings("myconnstr").ConnectionString

            Using conn As New System.Data.SqlClient.SqlConnection(connectionString)
                Dim query As String = "SELECT Audit_ID, User_ID, Login_Time, Logout_Time, Status FROM Login_Audit ORDER BY Login_Time DESC"
                Using cmd As New System.Data.SqlClient.SqlCommand(query, conn)
                    conn.Open()
                    Using reader As System.Data.SqlClient.SqlDataReader = cmd.ExecuteReader()
                        Dim html As New System.Text.StringBuilder()
                        html.Append("<table class='table table-bordered table-audit'>")
                        html.Append("<thead><tr>")
                        html.Append("<th>Audit ID</th>")
                        html.Append("<th>User ID</th>")
                        html.Append("<th>Login Time</th>")
                        html.Append("<th>Logout Time</th>")
                        html.Append("<th>Status</th>")
                        html.Append("</tr></thead><tbody>")

                        If reader.HasRows Then
                            While reader.Read()
                                html.Append("<tr>")
                                html.Append("<td>" & reader("Audit_ID").ToString() & "</td>")
                                html.Append("<td>" & If(IsDBNull(reader("User_ID")), "--", reader("User_ID").ToString()) & "</td>")
                                html.Append("<td>" & Convert.ToDateTime(reader("Login_Time")).ToString("yyyy-MM-dd HH:mm:ss") & "</td>")
                                html.Append("<td>" & If(IsDBNull(reader("Logout_Time")), "--", Convert.ToDateTime(reader("Logout_Time")).ToString("yyyy-MM-dd HH:mm:ss")) & "</td>")
                                html.Append("<td>" & Server.HtmlEncode(reader("Status").ToString()) & "</td>")
                                html.Append("</tr>")
                            End While
                        Else
                            html.Append("<tr><td colspan='5'>No audit logs found.</td></tr>")
                        End If
                        html.Append("</tbody></table>")

                        litAudit.Text = html.ToString()
                    End Using
                End Using
            End Using

        Catch ex As Exception
            lblError.Text = "Error loading audit logs: " & Server.HtmlEncode(ex.Message)
            lblError.Visible = True
        End Try
    End Sub
End Class