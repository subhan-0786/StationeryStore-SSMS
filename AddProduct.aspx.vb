Imports System.Data.SqlClient
Imports System.Configuration
Imports System.Data

Partial Class AddProduct
    Inherits System.Web.UI.Page

    Private connStr As String = ConfigurationManager.ConnectionStrings("myconnstr").ConnectionString
    Protected Sub Page_Load(sender As Object, e As EventArgs)
        If Not IsPostBack Then
            LoadCategories()
            LoadSuppliers()
        End If
    End Sub

    Private Sub LoadCategories()
        Dim query As String = "SELECT Category_ID, Category_Name FROM Category"
        Try
            Using conn As New SqlConnection(connStr)
                Using cmd As New SqlCommand(query, conn)
                    conn.Open()
                    Using reader As SqlDataReader = cmd.ExecuteReader()
                        ddlCategory.Items.Clear()
                        While reader.Read()

                            Dim item As New ListItem(reader("Category_Name").ToString(), reader("Category_ID").ToString())
                            ddlCategory.Items.Add(item)
                        End While
                    End Using
                End Using
            End Using
        Catch ex As Exception
            lblMessage.Text = "<span class='error'>Error loading categories: " & ex.Message & "</span>"
        End Try
    End Sub


    Private Sub LoadSuppliers()
        Dim query As String = "SELECT Supplier_ID, Supplier_Name FROM Supplier"
        Try
            Using conn As New SqlConnection(connStr)
                Using cmd As New SqlCommand(query, conn)
                    conn.Open()
                    Using reader As SqlDataReader = cmd.ExecuteReader()
                        ddlSupplier.Items.Clear()
                        While reader.Read()
                            Dim item As New ListItem(reader("Supplier_Name").ToString(), reader("Supplier_ID").ToString())
                            ddlSupplier.Items.Add(item)
                        End While
                    End Using
                End Using
            End Using
        Catch ex As Exception
            lblMessage.Text = "<span class='error'>Error loading categories: " & ex.Message & "</span>"
        End Try
    End Sub


    Protected Sub btnAdd_Click(sender As Object, e As EventArgs)
        Dim prodId As Integer
        Dim price As Decimal
        Dim stock As Integer

        If Not Integer.TryParse(txtProductID.Text.Trim(), prodId) OrElse
           Not Decimal.TryParse(txtPrice.Text.Trim(), price) OrElse
           Not Integer.TryParse(txtStock.Text.Trim(), stock) Then
            lblMessage.Text = "<span class='error'>Please enter valid numeric values.</span>"
            Return
        End If

        Dim name As String = txtProductName.Text.Trim()
        If name = "" Then
            lblMessage.Text = "<span class='error'>Product name is required.</span>"
            Return
        End If

        Dim categoryId As Integer = Convert.ToInt32(ddlCategory.SelectedValue)
        Dim supplierId As Integer = Convert.ToInt32(ddlSupplier.SelectedValue)

        Dim checkQuery As String = "SELECT COUNT(*) FROM Product WHERE Product_ID = @id"
        Dim insertQuery As String = "INSERT INTO Product (Product_ID, Product_Name, Unit_Price, Stock_Quantity, Category_ID, Supplier_ID) " &
                                    "VALUES (@id, @name, @price, @stock, @category, @supplier)"

        Using conn As New SqlConnection(connStr)
            conn.Open()

            ' Check for duplicate Product_ID
            Using checkCmd As New SqlCommand(checkQuery, conn)
                checkCmd.Parameters.AddWithValue("@id", prodId)
                If Convert.ToInt32(checkCmd.ExecuteScalar()) > 0 Then
                    lblMessage.Text = "<span class='error'>Product ID already exists.</span>"
                    Return
                End If
            End Using

            ' Insert the product
            Using insertCmd As New SqlCommand(insertQuery, conn)
                insertCmd.Parameters.AddWithValue("@id", prodId)
                insertCmd.Parameters.AddWithValue("@name", name)
                insertCmd.Parameters.AddWithValue("@price", price)
                insertCmd.Parameters.AddWithValue("@stock", stock)
                insertCmd.Parameters.AddWithValue("@category", categoryId)
                insertCmd.Parameters.AddWithValue("@supplier", supplierId)
                insertCmd.ExecuteNonQuery()
            End Using
        End Using

        lblMessage.Text = "<span class='success'>Product added successfully.</span>"
        txtProductID.Text = ""
        txtProductName.Text = ""
        txtPrice.Text = ""
        txtStock.Text = ""
    End Sub
End Class
