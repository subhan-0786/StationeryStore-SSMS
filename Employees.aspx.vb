
Imports System.Data
Imports System.Data.SqlClient
Imports System.Configuration

Partial Class Employees
    Inherits System.Web.UI.Page

    Private connStr As String = ConfigurationManager.ConnectionStrings("myconnstr").ConnectionString

    Protected Sub Page_Load(sender As Object, e As EventArgs) Handles Me.Load
        If Not IsPostBack Then
            ' Check if user is logged in
            If Session("UserID") Is Nothing OrElse Session("RoleID") Is Nothing Then
                Response.Redirect("~/Login.aspx")
            End If
            LoadEmployees()
        End If
    End Sub

    Private Sub LoadEmployees()
        Using conn As New SqlConnection(connStr)
            Dim query As String = "SELECT Employee_ID, Employee_Name, Phone, Email, Address, City, Hire_Date, Salary FROM Employee"
            Dim cmd As New SqlCommand(query, conn)
            Dim adapter As New SqlDataAdapter(cmd)
            Dim dt As New DataTable()
            adapter.Fill(dt)
            gvEmployees.DataSource = dt
            gvEmployees.DataBind()
        End Using
    End Sub

    Protected Sub btnAddEmployee_Click(sender As Object, e As EventArgs)
        Response.Redirect("AddEmployee.aspx")
    End Sub

    Protected Sub gvEmployees_RowEditing(sender As Object, e As GridViewEditEventArgs)
        gvEmployees.EditIndex = e.NewEditIndex
        LoadEmployees()
    End Sub

    Protected Sub gvEmployees_RowCancelingEdit(sender As Object, e As GridViewCancelEditEventArgs)
        gvEmployees.EditIndex = -1
        LoadEmployees()
    End Sub

    Protected Sub gvEmployees_RowUpdating(sender As Object, e As GridViewUpdateEventArgs)
        Dim empId As Integer = Convert.ToInt32(gvEmployees.DataKeys(e.RowIndex).Value)
        Dim row As GridViewRow = gvEmployees.Rows(e.RowIndex)
        Dim empName As String = CType(row.Cells(1).Controls(0), TextBox).Text.Trim()
        Dim phone As String = CType(row.Cells(2).Controls(0), TextBox).Text.Trim()
        Dim email As String = CType(row.Cells(3).Controls(0), TextBox).Text.Trim()
        Dim address As String = CType(row.Cells(4).Controls(0), TextBox).Text.Trim()
        Dim city As String = CType(row.Cells(5).Controls(0), TextBox).Text.Trim()
        Dim salary As Decimal = Convert.ToDecimal(CType(row.Cells(7).Controls(0), TextBox).Text.Trim())

        Using conn As New SqlConnection(connStr)
            Dim cmd As New SqlCommand("UPDATE Employee SET Employee_Name = @empName, Phone = @phone, Email = @email, " &
                                      "Address = @address, City = @city, Salary = @salary WHERE Employee_ID = @empId", conn)
            cmd.Parameters.AddWithValue("@empName", empName)
            cmd.Parameters.AddWithValue("@phone", phone)
            cmd.Parameters.AddWithValue("@email", email)
            cmd.Parameters.AddWithValue("@address", address)
            cmd.Parameters.AddWithValue("@city", city)
            cmd.Parameters.AddWithValue("@salary", salary)
            cmd.Parameters.AddWithValue("@empId", empId)
            conn.Open()
            cmd.ExecuteNonQuery()
        End Using

        gvEmployees.EditIndex = -1
        LoadEmployees()
    End Sub

    Protected Sub gvEmployees_RowDeleting(sender As Object, e As GridViewDeleteEventArgs)
        Dim empId As Integer = Convert.ToInt32(gvEmployees.DataKeys(e.RowIndex).Value)

        ' Show a confirmation dialog with a Button to proceed with the deletion
        Dim confirmationMessage As String = "Are you sure you want to delete this employee?"
        lblConfirmationMessage.Text = confirmationMessage
        confirmDelete.Visible = True
        ViewState("empIdToDelete") = empId
    End Sub

    Protected Sub btnConfirmDelete_Click(sender As Object, e As EventArgs)
        If ViewState("empIdToDelete") IsNot Nothing Then
            Dim empId As Integer = Convert.ToInt32(ViewState("empIdToDelete"))

            Using conn As New SqlConnection(connStr)
                Dim cmd As New SqlCommand("DELETE FROM Employee WHERE Employee_ID = @empId", conn)
                cmd.Parameters.AddWithValue("@empId", empId)
                conn.Open()
                cmd.ExecuteNonQuery()
            End Using

            LoadEmployees()

            ' Hide the confirmation panel after deletion
            confirmDelete.Visible = False
        End If
    End Sub

    Protected Sub btnCancelDelete_Click(sender As Object, e As EventArgs)
        ' Hide the confirmation panel without deleting
        confirmDelete.Visible = False
    End Sub
End Class