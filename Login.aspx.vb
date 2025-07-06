Imports System.Data.SqlClient
Imports System.Security.Cryptography
Imports System.Text

Partial Class Login
    Inherits System.Web.UI.Page
    Protected Sub btnLogin_Click(sender As Object, e As EventArgs)
        Dim connStr As String = ConfigurationManager.ConnectionStrings("myconnStr").ConnectionString
        Dim username As String = txtUsername.Text.Trim()
        Dim password As String = txtPassword.Text.Trim()
        Dim hashedPwd As String = GetHash(password)

        Using conn As New SqlConnection(connStr)
            Dim cmd As New SqlCommand("SELECT User_ID, Role_ID FROM User_t WHERE Username=@uname AND Password_Hash=@pwd", conn)
            cmd.Parameters.AddWithValue("@uname", username)
            cmd.Parameters.AddWithValue("@pwd", hashedPwd)

            conn.Open()
            Dim reader As SqlDataReader = cmd.ExecuteReader()
            If reader.Read() Then
                Dim userId = reader("User_ID")
                Dim roleId = reader("Role_ID")
                Session("UserID") = userId
                Session("RoleID") = roleId
                RecordLogin(userId, "Success")
                Response.Redirect("Dashboard.aspx")
            Else
                lblError.Text = "Invalid credentials."
                lblError.Visible = True
            End If
        End Using
    End Sub

    Private Function GetHash(input As String) As String
        Using sha As SHA256 = SHA256.Create()
            Dim bytes = Encoding.UTF8.GetBytes(input)
            Dim hash = sha.ComputeHash(bytes)
            Return Convert.ToBase64String(hash)
        End Using
    End Function

    Private Sub RecordLogin(userId As Object, status As String)
        Dim connStr As String = ConfigurationManager.ConnectionStrings("myconnstr").ConnectionString
        Using conn As New SqlConnection(connStr)
            Dim cmd As New SqlCommand("INSERT INTO Login_Audit (User_ID, Login_Time, Status) VALUES (@uid, GETDATE(), @status)", conn)
            cmd.Parameters.AddWithValue("@uid", If(userId, DBNull.Value))
            cmd.Parameters.AddWithValue("@status", status)
            conn.Open()
            cmd.ExecuteNonQuery()
        End Using
    End Sub
End Class