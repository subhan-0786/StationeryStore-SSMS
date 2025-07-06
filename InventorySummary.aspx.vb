
Imports System
Imports System.Data
Imports System.Data.SqlClient
Imports System.Configuration

Partial Public Class InventorySummary
    Inherits System.Web.UI.Page

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As EventArgs) Handles Me.Load
        If Not IsPostBack Then
            ' Check if user is logged in and has Manager role (RoleID = 2)
            If Session("UserID") Is Nothing OrElse Session("RoleID") Is Nothing Then
                Response.Redirect("Login.aspx")
            ElseIf Convert.ToInt32(Session("RoleID")) <> 2 Then
                Response.Redirect("Dashboard.aspx")
            Else
                LoadInventorySummary()
            End If
        End If
    End Sub

    Private Sub LoadInventorySummary()
        Dim connStr As String = ConfigurationManager.ConnectionStrings("myconnstr").ConnectionString

        Dim query As String = "SELECT " &
                              "P.Product_Name, " &
                              "P.Stock_Quantity, " &
                              "S.Supplier_Name, " &
                              "C.Category_Name " &
                              "FROM Product P " &
                              "LEFT JOIN Supplier S ON P.Supplier_ID = S.Supplier_ID " &
                              "LEFT JOIN Category C ON P.Category_ID = C.Category_ID"

        Using conn As New SqlConnection(connStr)
            Using cmd As New SqlCommand(query, conn)
                Dim dt As New DataTable()
                Try
                    conn.Open()
                    Dim da As New SqlDataAdapter(cmd)
                    da.Fill(dt)
                    GridViewInventory.DataSource = dt
                    GridViewInventory.DataBind()
                Catch ex As Exception
                    lblError.Text = "Error loading inventory: " & Server.HtmlEncode(ex.Message)
                    lblError.Visible = True
                End Try
            End Using
        End Using
    End Sub
End Class
