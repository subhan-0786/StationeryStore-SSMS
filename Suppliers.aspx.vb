Imports System.Configuration
Imports System.Data.SqlClient
Imports System.Text

Partial Class Suppliers
    Inherits System.Web.UI.Page

    Protected Sub Page_Load(sender As Object, e As EventArgs) Handles Me.Load
        If Not IsPostBack Then
            ' Check if user is logged in
            If Session("UserID") Is Nothing Then
                Response.Redirect("Login.aspx")
            Else
                LoadSuppliers()
            End If
        End If
    End Sub

    Private Sub LoadSuppliers()
        Try
            Dim connectionString As String = ConfigurationManager.ConnectionStrings("myconnstr").ConnectionString

            Using conn As New SqlConnection(connectionString)
                Dim query As String = "SELECT Supplier_ID, Supplier_Name, Phone, Email, Address, City, State, Postal_Code FROM Supplier ORDER BY Supplier_Name"
                Using cmd As New SqlCommand(query, conn)
                    conn.Open()
                    Using reader As SqlDataReader = cmd.ExecuteReader()
                        Dim html As New StringBuilder()
                        html.Append("<table border='1' cellpadding='5' cellspacing='0'>")
                        html.Append("<tr>")
                        html.Append("<th>Supplier ID</th>")
                        html.Append("<th>Supplier Name</th>")
                        html.Append("<th>Phone</th>")
                        html.Append("<th>Email</th>")
                        html.Append("<th>Address</th>")
                        html.Append("<th>City</th>")
                        html.Append("<th>State</th>")
                        html.Append("<th>Postal Code</th>")
                        html.Append("</tr>")

                        If reader.HasRows Then
                            While reader.Read()
                                html.Append("<tr>")
                                html.Append("<td>" & reader("Supplier_ID").ToString() & "</td>")
                                html.Append("<td>" & Server.HtmlEncode(reader("Supplier_Name").ToString()) & "</td>")
                                html.Append("<td>" & If(IsDBNull(reader("Phone")), "", Server.HtmlEncode(reader("Phone").ToString())) & "</td>")
                                html.Append("<td>" & If(IsDBNull(reader("Email")), "", Server.HtmlEncode(reader("Email").ToString())) & "</td>")
                                html.Append("<td>" & If(IsDBNull(reader("Address")), "", Server.HtmlEncode(reader("Address").ToString())) & "</td>")
                                html.Append("<td>" & If(IsDBNull(reader("City")), "", Server.HtmlEncode(reader("City").ToString())) & "</td>")
                                html.Append("<td>" & If(IsDBNull(reader("State")), "", Server.HtmlEncode(reader("State").ToString())) & "</td>")
                                html.Append("<td>" & If(IsDBNull(reader("Postal_Code")), "", Server.HtmlEncode(reader("Postal_Code").ToString())) & "</td>")
                                html.Append("</tr>")
                            End While
                        Else
                            html.Append("<tr><td colspan='8'>No suppliers found.</td></tr>")
                        End If

                        html.Append("</table>")
                        litSuppliers.Text = html.ToString()
                    End Using
                End Using
            End Using
        Catch ex As Exception
            lblError.Text = "Error loading suppliers: " & Server.HtmlEncode(ex.Message)
            lblError.Visible = True
        End Try
    End Sub
End Class
