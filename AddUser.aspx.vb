Imports System.Data
Imports System.Data.SqlClient
Imports System.Security.Cryptography
Imports System.Text

Partial Class AddUser
    Inherits System.Web.UI.Page

    Dim connStr As String = ConfigurationManager.ConnectionStrings("myconnstr").ConnectionString

    Protected Sub Page_Load(sender As Object, e As EventArgs) Handles Me.Load
        If Not IsPostBack Then
            ' Check if user is logged in
            If Session("UserID") Is Nothing OrElse Session("RoleID") Is Nothing Then
                Response.Redirect("~/Login.aspx")
            End If
            LoadEmployees()
            LoadRoles()
        End If
    End Sub

    Private Sub LoadEmployees()
        Using conn As New SqlConnection(connStr)
            Dim cmd As New SqlCommand("SELECT Employee_ID, Employee_Name FROM Employee", conn)
            conn.Open()
            ddlEmployee.DataSource = cmd.ExecuteReader()
            ddlEmployee.DataTextField = "Employee_Name"
            ddlEmployee.DataValueField = "Employee_ID"
            ddlEmployee.DataBind()
        End Using
    End Sub

    Private Sub LoadRoles()
        Using conn As New SqlConnection(connStr)
            Dim cmd As New SqlCommand("SELECT Role_ID, Role_Name FROM Role_t", conn)
            conn.Open()
            ddlRole.DataSource = cmd.ExecuteReader()
            ddlRole.DataTextField = "Role_Name"
            ddlRole.DataValueField = "Role_ID"
            ddlRole.DataBind()
        End Using
    End Sub

    Protected Sub btnAddUser_Click(sender As Object, e As EventArgs)
        Dim username As String = txtUsername.Text.Trim()
        Dim password As String = txtPassword.Text
        Dim empId As Integer = Convert.ToInt32(ddlEmployee.SelectedValue)
        Dim roleId As Integer = Convert.ToInt32(ddlRole.SelectedValue)
        Dim hash As String = ComputeHash(password)

        Using conn As New SqlConnection(connStr)
            conn.Open()

            ' Check if username already exists
            Dim checkCmd As New SqlCommand("SELECT COUNT(*) FROM User_t WHERE Username = @username", conn)
            checkCmd.Parameters.AddWithValue("@username", username)

            Dim count As Integer = Convert.ToInt32(checkCmd.ExecuteScalar())
            If count > 0 Then
                lblMessage.ForeColor = Drawing.Color.Red
                lblMessage.Text = "Username already exists. Please choose another one."
                Return
            End If

            ' Insert new user
            Dim insertCmd As New SqlCommand("INSERT INTO User_t (Employee_ID, Username, Password_Hash, Role_ID) VALUES (@empId, @username, @passHash, @roleId)", conn)
            insertCmd.Parameters.AddWithValue("@empId", empId)
            insertCmd.Parameters.AddWithValue("@username", username)
            insertCmd.Parameters.AddWithValue("@passHash", hash)
            insertCmd.Parameters.AddWithValue("@roleId", roleId)

            Try
                insertCmd.ExecuteNonQuery()
                lblMessage.ForeColor = Drawing.Color.Green
                lblMessage.Text = "User added successfully!"
            Catch ex As SqlException
                lblMessage.ForeColor = Drawing.Color.Red
                lblMessage.Text = "Error: " & ex.Message
            End Try
        End Using
    End Sub

    Private Function ComputeHash(password As String) As String
        Using sha256 As SHA256 = SHA256.Create()
            Dim bytes As Byte() = Encoding.UTF8.GetBytes(password)
            Dim hashBytes As Byte() = sha256.ComputeHash(bytes)
            Return BitConverter.ToString(hashBytes).Replace("-", "").ToLower()
        End Using
    End Function
End Class