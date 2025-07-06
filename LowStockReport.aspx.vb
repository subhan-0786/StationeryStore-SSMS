
Imports System.Data.SqlClient
Imports System.Configuration
Imports System.Data

Partial Class LowStockReport
    Inherits System.Web.UI.Page

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As EventArgs) Handles Me.Load
        If Not IsPostBack Then
            ' Check if user is logged in and has Manager role (RoleID = 2)
            If Session("UserID") Is Nothing OrElse Session("RoleID") Is Nothing Then
                Response.Redirect("Login.aspx")
            ElseIf Convert.ToInt32(Session("RoleID")) <> 2 Then
                Response.Redirect("Dashboard.aspx")
            Else
                LoadLowStockReport()
            End If
        End If
    End Sub

    Private Sub LoadLowStockReport()
        ' Placeholder: Page is under development
        lblMessage.Text = "This page is under development and will be available soon with a detailed low stock report."
        lblMessage.Visible = True
        gvLowStock.Visible = False

        ' Commented out for future implementation when ReorderLevel is added to Product table
        'Dim conStr As String = ConfigurationManager.ConnectionStrings("myconnstr").ConnectionString
        'Using con As New SqlConnection(conStr)
        '    Dim query As String = "SELECT Product_ID, Product_Name, Stock_Quantity, ReorderLevel " &
        '                          "FROM Product WHERE Stock_Quantity <= ReorderLevel"
        '    Dim cmd As New SqlCommand(query, con)
        '    Dim da As New SqlDataAdapter(cmd)
        '    Dim dt As New DataTable()
        '    Try
        '        con.Open()
        '        da.Fill(dt)
        '        gvLowStock.DataSource = dt
        '        gvLowStock.DataBind()
        '        lblMessage.Visible = False
        '    Catch ex As Exception
        '        lblMessage.Text = "Error loading low stock report: " & Server.HtmlEncode(ex.Message)
        '        lblMessage.CssClass = "text-danger mb-3 d-block"
        '        lblMessage.Visible = True
        '    End Try
        'End Using
    End Sub
End Class