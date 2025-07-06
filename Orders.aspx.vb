Imports System.Data
Imports System.Data.SqlClient
Imports System.Configuration

Partial Class Orders
    Inherits System.Web.UI.Page

    Dim connectionString As String = ConfigurationManager.ConnectionStrings("myconnstr").ConnectionString

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        If Not IsPostBack Then
            ' Check if user is logged in and has appropriate role (Manager = 2)
            If Session("UserID") Is Nothing OrElse Session("RoleID") Is Nothing OrElse Convert.ToInt32(Session("RoleID")) <> 2 Then
                Response.Redirect("Login.aspx")
            Else
                LoadOrders()
                LoadCustomers()
            End If
        End If
    End Sub

    Private Sub LoadCustomers()
        Using conn As New SqlConnection(connectionString)
            Dim cmd As New SqlCommand("SELECT Customer_ID, Customer_Name FROM Customer", conn)
            conn.Open()
            ddlCustomer.DataSource = cmd.ExecuteReader()
            ddlCustomer.DataTextField = "Customer_Name"
            ddlCustomer.DataValueField = "Customer_ID"
            ddlCustomer.DataBind()
            ddlCustomer.Items.Insert(0, New ListItem("-- Select Customer --", ""))
        End Using
    End Sub

    Private Sub LoadOrders()
        Using conn As New SqlConnection(connectionString)
            Dim query As String = "SELECT o.Order_ID, c.Customer_Name, o.Customer_ID, o.Order_Date " &
                                  "FROM Order_T o INNER JOIN Customer c ON o.Customer_ID = c.Customer_ID"
            Dim adapter As New SqlDataAdapter(query, conn)
            Dim dt As New DataTable()
            adapter.Fill(dt)
            gvOrders.DataSource = dt
            gvOrders.DataBind()
        End Using
    End Sub

    Protected Sub btnAdd_Click(sender As Object, e As EventArgs)
        If String.IsNullOrEmpty(txtOrderID.Text) OrElse ddlCustomer.SelectedIndex = 0 Then
            lblMessage.Text = "Please fill Order ID and select a customer."
            lblMessage.ForeColor = System.Drawing.Color.Red
            Return
        End If

        ' Validate numeric input for Order_ID
        Dim orderId As Integer
        If Not Integer.TryParse(txtOrderID.Text, orderId) Then
            lblMessage.Text = "Order ID must be a valid number."
            lblMessage.ForeColor = System.Drawing.Color.Red
            Return
        End If

        ' Validate Order_Date if provided
        Dim orderDate As Nullable(Of DateTime) = Nothing
        If Not String.IsNullOrEmpty(txtOrderDate.Text) Then
            Dim parsedDate As DateTime
            If DateTime.TryParse(txtOrderDate.Text, parsedDate) Then
                orderDate = parsedDate
            Else
                lblMessage.Text = "Order Date must be a valid date."
                lblMessage.ForeColor = System.Drawing.Color.Red
                Return
            End If
        End If

        Try
            Using conn As New SqlConnection(connectionString)
                Dim query As String = "INSERT INTO Order_T (Order_ID, Customer_ID, Order_Date) " &
                                  "VALUES (@orderId, @customerId, @orderDate)"

                Using cmd As New SqlCommand(query, conn)
                    cmd.Parameters.AddWithValue("@orderId", orderId)
                    cmd.Parameters.AddWithValue("@customerId", ddlCustomer.SelectedValue)
                    If orderDate.HasValue Then
                        cmd.Parameters.AddWithValue("@orderDate", orderDate.Value)
                    Else
                        cmd.Parameters.AddWithValue("@orderDate", DBNull.Value)
                    End If

                    conn.Open()
                    cmd.ExecuteNonQuery()
                End Using
            End Using

            lblMessage.Text = "Order added successfully."
            lblMessage.ForeColor = System.Drawing.Color.Green
            LoadOrders()

            ' Clear form
            txtOrderID.Text = ""
            txtOrderDate.Text = ""
            ddlCustomer.SelectedIndex = 0
        Catch ex As SqlException
            lblMessage.Text = "Error adding order: " & ex.Message
            lblMessage.ForeColor = System.Drawing.Color.Red
        End Try
    End Sub

    Protected Sub gvOrders_RowEditing(sender As Object, e As GridViewEditEventArgs)
        gvOrders.EditIndex = e.NewEditIndex
        LoadOrders()
    End Sub

    Protected Sub gvOrders_RowCancelingEdit(sender As Object, e As GridViewCancelEditEventArgs)
        gvOrders.EditIndex = -1
        LoadOrders()
    End Sub

    Protected Sub gvOrders_RowUpdating(sender As Object, e As GridViewUpdateEventArgs)
        Try
            Dim row As GridViewRow = gvOrders.Rows(e.RowIndex)
            Dim orderId As String = gvOrders.DataKeys(e.RowIndex).Value.ToString()

            ' Correctly get the Order_Date from the current row
            Dim orderDateText As String = CType(row.Cells(3).Controls(0), TextBox).Text

            Dim orderDate As DateTime?
            If Not String.IsNullOrEmpty(orderDateText) Then
                Dim parsedDate As DateTime
                If DateTime.TryParse(orderDateText, parsedDate) Then
                    orderDate = parsedDate
                Else
                    lblMessage.Text = "Order Date must be a valid date."
                    lblMessage.ForeColor = System.Drawing.Color.Red
                    Return
                End If
            Else
                orderDate = Nothing
            End If

            Using conn As New SqlConnection(connectionString)
                Dim query As String = "UPDATE Order_T SET Order_Date = @orderDate WHERE Order_ID = @orderId"
                Using cmd As New SqlCommand(query, conn)
                    If orderDate.HasValue Then
                        cmd.Parameters.AddWithValue("@orderDate", orderDate.Value)
                    Else
                        cmd.Parameters.AddWithValue("@orderDate", DBNull.Value)
                    End If
                    cmd.Parameters.AddWithValue("@orderId", orderId)

                    conn.Open()
                    cmd.ExecuteNonQuery()
                End Using
            End Using

            lblMessage.Text = "Order updated successfully."
            lblMessage.ForeColor = System.Drawing.Color.Green
            gvOrders.EditIndex = -1
            LoadOrders()
        Catch ex As SqlException
            lblMessage.Text = "Error updating order: " & ex.Message
            lblMessage.ForeColor = System.Drawing.Color.Red
        End Try
    End Sub

    Protected Sub gvOrders_RowDeleting(sender As Object, e As GridViewDeleteEventArgs)
        Try
            Dim orderId As String = gvOrders.DataKeys(e.RowIndex).Value.ToString()

            Using conn As New SqlConnection(connectionString)
                conn.Open()

                ' Check if any related items exist
                Dim checkCmd As New SqlCommand("SELECT COUNT(*) FROM Order_Item WHERE Order_ID = @orderId", conn)
                checkCmd.Parameters.AddWithValue("@orderId", orderId)

                Dim count As Integer = Convert.ToInt32(checkCmd.ExecuteScalar())
                If count > 0 Then
                    lblMessage.Text = "Cannot delete order. It has related items."
                    lblMessage.ForeColor = System.Drawing.Color.Red
                    Return
                End If

                ' Proceed to delete
                Dim query As String = "DELETE FROM Order_T WHERE Order_ID = @orderId"
                Using cmd As New SqlCommand(query, conn)
                    cmd.Parameters.AddWithValue("@orderId", orderId)
                    cmd.ExecuteNonQuery()
                End Using
            End Using

            lblMessage.Text = "Order deleted successfully."
            lblMessage.ForeColor = System.Drawing.Color.Green
            LoadOrders()
        Catch ex As SqlException
            lblMessage.Text = "Error deleting order: " & ex.Message
            lblMessage.ForeColor = System.Drawing.Color.Red
        End Try
    End Sub
End Class