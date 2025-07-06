Partial Class _Default
    Inherits System.Web.UI.Page

    ' Page Load event: It checks if the user is logged in and redirects to Login page if not
    Protected Sub Page_Load(sender As Object, e As EventArgs) Handles Me.Load
        If Not IsPostBack Then
            ' Check if session values for UserID and RoleID exist
            If Session("UserID") Is Nothing OrElse Session("RoleID") Is Nothing Then
                ' Redirect to Login if the session is invalid
                Response.Redirect("Login.aspx")
            Else
                ' Get the RoleID from the session
                Dim roleId As Integer = Convert.ToInt32(Session("RoleID"))
                ' Show the appropriate panel based on the role
                Select Case roleId
                    Case 1 ' Admin
                        phAdmin.Visible = True
                    Case 2 ' Manager
                        phManager.Visible = True
                    Case 3 ' Salesperson
                        phSalesperson.Visible = True
                    Case Else
                        phUnauthorized.Visible = True
                End Select
            End If
        End If
    End Sub
End Class