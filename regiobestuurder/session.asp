<!-- #include file="../templates/headers/content.asp" -->
<%
f_header "Session Contents"
%>
<table>
<%
for each obj in session.Contents
    response.Write "<tr><td>" & obj & "</td><td>" & session(obj) & "</td></tr>"
next
%>
</table>
<!-- #include file="../templates/footers/content.asp" -->
