Imports System.Data.SqlClient
Imports System.Text

Partial Class Search
    Inherits System.Web.UI.Page

    Protected Sub btnSearch_ServerClick(sender As Object, e As EventArgs)
        Dim keyword As String = txtSearch.Value.Trim()

        If keyword = "" Then
            results.InnerHtml = "<span style='color:red;'>Please enter a product name.</span>"
            Return
        End If

        Dim connStr As String = ConfigurationManager.ConnectionStrings("myconnstr").ConnectionString
        Dim query As String = "SELECT TOP 5 Product_Name, Price FROM Product WHERE Product_Name LIKE @name"

        Dim found As Boolean = False
        Dim sb As New StringBuilder()
        sb.Append("<table border='1' cellpadding='5'><tr><th>Name</th><th>Price</th></tr>")

        Using conn As New SqlConnection(connStr)
            Using cmd As New SqlCommand(query, conn)
                cmd.Parameters.AddWithValue("@name", "%" & keyword & "%")
                conn.Open()
                Dim reader As SqlDataReader = cmd.ExecuteReader()
                While reader.Read()
                    found = True
                    sb.Append("<tr>")
                    sb.Append("<td>" & reader("Product_Name").ToString() & "</td>")
                    sb.Append("<td>" & reader("Price").ToString() & "</td>")
                    sb.Append("</tr>")
                End While
            End Using
        End Using

        sb.Append("</table>")

        If found Then
            results.InnerHtml = sb.ToString()
        Else
            results.InnerHtml = "<span style='color:red;'>No matching product found.</span>"
        End If
    End Sub

End Class
