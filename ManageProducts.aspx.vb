Imports System.Data
Imports System.Data.SqlClient
Imports System.Configuration

Partial Class ManageProducts
    Inherits System.Web.UI.Page

    Dim connectionString As String = ConfigurationManager.ConnectionStrings("myconnstr").ConnectionString

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        If Not IsPostBack Then
            ' Check if user is logged in and has Manager role (RoleID = 2)
            If Session("UserID") Is Nothing OrElse Session("RoleID") Is Nothing Then
                Response.Redirect("Login.aspx")
            ElseIf Convert.ToInt32(Session("RoleID")) <> 2 Then
                Response.Redirect("Dashboard.aspx")
            Else
                LoadProducts()
                LoadSuppliers()
                LoadCategories()
            End If
        End If
    End Sub

    Private Sub LoadCategories()
        Using conn As New SqlConnection(connectionString)
            Dim cmd As New SqlCommand("SELECT Category_ID, Category_Name FROM Category", conn)
            conn.Open()
            ddlCategory.DataSource = cmd.ExecuteReader()
            ddlCategory.DataTextField = "Category_Name"
            ddlCategory.DataValueField = "Category_ID"
            ddlCategory.DataBind()
            ddlCategory.Items.Insert(0, New ListItem("-- Select Category --", ""))
        End Using
    End Sub

    Private Sub LoadSuppliers()
        Using conn As New SqlConnection(connectionString)
            Dim cmd As New SqlCommand("SELECT Supplier_ID, Supplier_Name FROM Supplier", conn)
            conn.Open()
            ddlSupplier.DataSource = cmd.ExecuteReader()
            ddlSupplier.DataTextField = "Supplier_Name"
            ddlSupplier.DataValueField = "Supplier_ID"
            ddlSupplier.DataBind()
            ddlSupplier.Items.Insert(0, New ListItem("-- Select Supplier --", ""))
        End Using
    End Sub

    Private Sub LoadProducts()
        Using conn As New SqlConnection(connectionString)
            Dim query As String = "SELECT Product_ID, Product_Name, Price, Stock_Quantity FROM Product"
            Dim adapter As New SqlDataAdapter(query, conn)
            Dim dt As New DataTable()
            adapter.Fill(dt)
            gvProducts.DataSource = dt
            gvProducts.DataBind()
        End Using
    End Sub

    Protected Sub btnAdd_Click(sender As Object, e As EventArgs)
        If String.IsNullOrEmpty(txtName.Text) OrElse String.IsNullOrEmpty(txtPrice.Text) OrElse
           String.IsNullOrEmpty(txtStock.Text) OrElse ddlCategory.SelectedIndex = 0 OrElse
           ddlSupplier.SelectedIndex = 0 Then
            lblMessage.Text = "Please fill all fields and select a category and supplier."
            lblMessage.ForeColor = System.Drawing.Color.Red
            Return
        End If

        ' Validate numeric inputs
        Dim price As Decimal
        Dim stock As Integer
        If Not Decimal.TryParse(txtPrice.Text, price) OrElse Not Integer.TryParse(txtStock.Text, stock) Then
            lblMessage.Text = "Price and Stock Quantity must be valid numbers."
            lblMessage.ForeColor = System.Drawing.Color.Red
            Return
        End If

        Try
            Using conn As New SqlConnection(connectionString)
                Dim query As String = "INSERT INTO Product (Product_Name, Price, Stock_Quantity, Category_ID, Supplier_ID) " &
                                      "VALUES (@name, @price, @stock, @category, @supplier)"

                Using cmd As New SqlCommand(query, conn)
                    cmd.Parameters.AddWithValue("@name", txtName.Text.Trim())
                    cmd.Parameters.AddWithValue("@price", price)
                    cmd.Parameters.AddWithValue("@stock", stock)
                    cmd.Parameters.AddWithValue("@category", ddlCategory.SelectedValue)
                    cmd.Parameters.AddWithValue("@supplier", ddlSupplier.SelectedValue)

                    conn.Open()
                    cmd.ExecuteNonQuery()
                End Using
            End Using

            lblMessage.Text = "Product added successfully."
            lblMessage.ForeColor = System.Drawing.Color.Green
            LoadProducts()

            ' Clear form
            txtName.Text = ""
            txtPrice.Text = ""
            txtStock.Text = ""
            ddlCategory.SelectedIndex = 0
            ddlSupplier.SelectedIndex = 0
        Catch ex As SqlException
            lblMessage.Text = "Error adding product: " & ex.Message
            lblMessage.ForeColor = System.Drawing.Color.Red
        End Try
    End Sub

    Protected Sub gvProducts_RowEditing(sender As Object, e As GridViewEditEventArgs)
        gvProducts.EditIndex = e.NewEditIndex
        LoadProducts()
    End Sub

    Protected Sub gvProducts_RowCancelingEdit(sender As Object, e As GridViewCancelEditEventArgs)
        gvProducts.EditIndex = -1
        LoadProducts()
    End Sub

    Protected Sub gvProducts_RowUpdating(sender As Object, e As GridViewUpdateEventArgs)
        Try
            Dim row As GridViewRow = gvProducts.Rows(e.RowIndex)
            Dim id As String = gvProducts.DataKeys(e.RowIndex).Value.ToString()
            Dim name As String = CType(row.Cells(1).Controls(0), TextBox).Text
            Dim priceText As String = CType(row.Cells(2).Controls(0), TextBox).Text
            Dim stockText As String = CType(row.Cells(3).Controls(0), TextBox).Text

            ' Validate inputs
            Dim price As Decimal
            Dim stock As Integer
            If Not Decimal.TryParse(priceText, price) OrElse Not Integer.TryParse(stockText, stock) Then
                lblMessage.Text = "Price and Stock Quantity must be valid numbers."
                lblMessage.ForeColor = System.Drawing.Color.Red
                Return
            End If

            Using conn As New SqlConnection(connectionString)
                Dim query As String = "UPDATE Product SET Product_Name = @name, Price = @price, Stock_Quantity = @stock WHERE Product_ID = @id"
                Using cmd As New SqlCommand(query, conn)
                    cmd.Parameters.AddWithValue("@name", name.Trim())
                    cmd.Parameters.AddWithValue("@price", price)
                    cmd.Parameters.AddWithValue("@stock", stock)
                    cmd.Parameters.AddWithValue("@id", id)

                    conn.Open()
                    cmd.ExecuteNonQuery()
                End Using
            End Using

            lblMessage.Text = "Product updated successfully."
            lblMessage.ForeColor = System.Drawing.Color.Green
            gvProducts.EditIndex = -1
            LoadProducts()
        Catch ex As SqlException
            lblMessage.Text = "Error updating product: " & ex.Message
            lblMessage.ForeColor = System.Drawing.Color.Red
        End Try
    End Sub

    Protected Sub gvProducts_RowDeleting(sender As Object, e As GridViewDeleteEventArgs)
        Try
            Dim id As String = gvProducts.DataKeys(e.RowIndex).Value.ToString()
            Using conn As New SqlConnection(connectionString)
                Dim query As String = "DELETE FROM Product WHERE Product_ID = @id"
                Using cmd As New SqlCommand(query, conn)
                    cmd.Parameters.AddWithValue("@id", id)
                    conn.Open()
                    cmd.ExecuteNonQuery()
                End Using
            End Using

            lblMessage.Text = "Product deleted successfully."
            lblMessage.ForeColor = System.Drawing.Color.Green
            LoadProducts()
        Catch ex As SqlException
            lblMessage.Text = "Error deleting product: " & ex.Message
            lblMessage.ForeColor = System.Drawing.Color.Red
        End Try
    End Sub
End Class