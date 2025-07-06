
Imports System.Data.SqlClient
Imports System.Security.Cryptography

Partial Class Logout
    Inherits System.Web.UI.Page
    Protected Sub Page_Load(sender As Object, e As EventArgs)
        Dim userId = Session("UserID")
        If userId IsNot Nothing Then
            Dim connStr As String = ConfigurationManager.ConnectionStrings("myconnstr").ConnectionString
            Using conn As New SqlConnection(connStr)
                Dim cmd As New SqlCommand("UPDATE TOP (1) Login_Audit SET Logout_Time = GETDATE() WHERE User_ID = @uid AND Logout_Time IS NULL ORDER BY Login_Time DESC", conn)
                cmd.Parameters.AddWithValue("@uid", userId)
                conn.Open()
                cmd.ExecuteNonQuery()
            End Using
        End If
        Session.Clear()
        Response.Redirect("Login.aspx")
    End Sub

End Class
