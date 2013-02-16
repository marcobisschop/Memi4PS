<!-- #include file="../../templates/headers/content.asp" -->
<%
f_header getlabel("basis_tabellen")
%>
<table cellpadding="10">
    <tr>
        <td>
            <b>
                <%=getlabel("Projectgegevens") %></b>
            <br />
            <a href="l_disclaimer.asp">
                <%=getlabel("disclaimer") %></a><br />
            
        </td>
    </tr>
</table>
<table cellpadding="10">
    <tr>
        <td>
            <b>
                <%=getlabel("claims") %></b>
            <br />
            <a href="l_clatyp.asp">
                <%=getlabel("clatyp") %></a><br />
            <a href="l_clasta.asp">
                <%=getlabel("clasta") %></a><br />
            <a href="l_clacat.asp">
                <%=getlabel("clacat") %></a><br />
        </td>
    </tr>
</table>
<table cellpadding="10">
    <tr>
        <td>
            <b>
                <%=getlabel("stabu") %></b>
            <br />
            <a href="l_stabu.asp">
                <%=getlabel("coderingen") %></a><br />
        </td>
    </tr>
</table>


<!-- #include file="../../templates/footers/content.asp" -->
