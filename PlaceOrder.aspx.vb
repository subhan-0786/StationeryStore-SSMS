Imports System.Data.SqlClient

Partial Class PlaceOrder
    Inherits System.Web.UI.Page

    Protected Sub Page_Load(sender As Object, e As EventArgs)
        If Not IsPostBack Then
            LoadCustomers()
            LoadProducts()
        End If
    End Sub

    Private Sub LoadCustomers()
        Dim connStr As String = ConfigurationManager.ConnectionStrings("myconnstr").ConnectionString
        Dim query As String = "SELECT Customer_ID, Customer_Name FROM Customer"

        Using conn As New SqlConnection(connStr)
            Using cmd As New SqlCommand(query, conn)
                conn.Open()
                ddlCustomer.DataSource = cmd.ExecuteReader()
                ddlCustomer.DataTextField = "Customer_Name"
                ddlCustomer.DataValueField = "Customer_ID"
                ddlCustomer.DataBind()
                ddlCustomer.Items.Insert(0, New ListItem("-- Select Customer --", ""))
            End Using
        End Using
    End Sub

    Private Sub LoadProducts()
        Dim connStr As String = ConfigurationManager.ConnectionStrings("myconnstr").ConnectionString
        Dim query As String = "SELECT Product_ID, Product_Name FROM Product"

        Using conn As New SqlConnection(connStr)
            Using cmd As New SqlCommand(query, conn)
                conn.Open()
                ddlProduct.DataSource = cmd.ExecuteReader()
                ddlProduct.DataTextField = "Product_Name"
                ddlProduct.DataValueField = "Product_ID"
                ddlProduct.DataBind()
                ddlProduct.Items.Insert(0, New ListItem("-- Select Product --", ""))
            End Using
        End Using
    End Sub

    Protected Sub btnPlaceOrder_Click(sender As Object, e As EventArgs)
        Dim customerId As Integer = Convert.ToInt32(ddlCustomer.SelectedValue)
        Dim productId As Integer = Convert.ToInt32(ddlProduct.SelectedValue)
        Dim quantity As Integer = Convert.ToInt32(txtQuantity.Text)

        If customerId = 0 Or productId = 0 Or quantity <= 0 Then
            lblMessage.Text = "Please fill in all the fields correctly."
            Return
        End If

        ' Insert order logic goes here (e.g., into an "Orders" table)
        ' Assuming successful insertion:
        lblMessage.Text = "Order placed successfully!"
    End Sub
End Class
