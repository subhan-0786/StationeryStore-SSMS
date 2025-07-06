Imports System.Data
Imports System.Data.SqlClient
Imports System.Configuration

Partial Class AddEmployee
    Inherits System.Web.UI.Page

    Private connStr As String = ConfigurationManager.ConnectionStrings("myconnstr").ConnectionString

    Protected Sub Page_Load(sender As Object, e As EventArgs) Handles Me.Load
        If Not IsPostBack Then
            ' Check if user is logged in
            If Session("UserID") Is Nothing OrElse Session("RoleID") Is Nothing Then
                Response.Redirect("~/Login.aspx")
            End If
        End If
    End Sub

    Protected Sub btnAdd_Click(sender As Object, e As EventArgs)
        Dim empId As Integer
        If Not Integer.TryParse(txtEmployeeID.Text.Trim(), empId) Then
            lblMessage.Text = "Invalid Employee ID."
            lblMessage.ForeColor = Drawing.Color.Red
            Return
        End If

        Dim name As String = txtName.Text.Trim()
        Dim phone As String = txtPhone.Text.Trim()
        Dim email As String = txtEmail.Text.Trim()
        Dim address As String = txtAddress.Text.Trim()
        Dim city As String = txtCity.Text.Trim()
        Dim hireDate As DateTime
        Dim salary As Decimal

        If Not DateTime.TryParse(txtHireDate.Text, hireDate) OrElse Not Decimal.TryParse(txtSalary.Text, salary) Then
            lblMessage.Text = "Invalid Hire Date or Salary."
            lblMessage.ForeColor = Drawing.Color.Red
            Return
        End If

        Using conn As New SqlConnection(connStr)
            conn.Open()

            ' Check if Employee_ID already exists
            Dim checkCmd As New SqlCommand("SELECT COUNT(*) FROM Employee WHERE Employee_ID = @EmpID", conn)
            checkCmd.Parameters.AddWithValue("@EmpID", empId)
            Dim exists As Integer = Convert.ToInt32(checkCmd.ExecuteScalar())

            If exists > 0 Then
                lblMessage.Text = "Employee with this ID already exists."
                lblMessage.ForeColor = Drawing.Color.Red
                Return
            End If

            ' Insert new employee
            Dim cmd As New SqlCommand("INSERT INTO Employee (Employee_ID, Employee_Name, Phone, Email, Address, City, Hire_Date, Salary)" &
                                       " VALUES (@EmpID, @Name, @Phone, @Email, @Address, @City, @HireDate, @Salary)", conn)
            cmd.Parameters.AddWithValue("@EmpID", empId)
            cmd.Parameters.AddWithValue("@Name", name)
            cmd.Parameters.AddWithValue("@Phone", phone)
            cmd.Parameters.AddWithValue("@Email", email)
            cmd.Parameters.AddWithValue("@Address", address)
            cmd.Parameters.AddWithValue("@City", city)
            cmd.Parameters.AddWithValue("@HireDate", hireDate)
            cmd.Parameters.AddWithValue("@Salary", salary)

            Try
                cmd.ExecuteNonQuery()
                lblMessage.Text = "Employee added successfully!"
                lblMessage.ForeColor = Drawing.Color.Green
            Catch ex As Exception
                lblMessage.Text = "Error: " & ex.Message
                lblMessage.ForeColor = Drawing.Color.Red
            End Try
        End Using
    End Sub
End Class