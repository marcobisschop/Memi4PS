<!-- #include file="header.asp" -->
<%

Response.Buffer = TRUE
Response.ContentType = "application/vnd.msword"

 %>
<table style="width:80%">
    <tr>
        <td style="font-weight:bold">Blok</td>
        <td style="font-weight:bold">Omschrijving</td>
        <td style="font-weight:bold">Her</td>
        <td style="font-weight:bold">Resultaat</td>
        <td style="font-weight:bold">Beh.ECTS</td>
    </tr>
<%
    For i = 1 to 10
    %>
    <tr>
        <td style="font-weigth:bold">1.<%=i %></td>
        <td style="font-weigth:bold">Omschrijving <%=i %></td>
        <td style="font-weigth:bold">Nee</td>
        <td style="font-weigth:bold">7.4</td>
        <td style="font-weigth:bold">3</td>
    </tr>        
    <%
    Next
%>
</table>


<!-- #include file="footer.asp" -->