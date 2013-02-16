<!-- #include file="../../templates/headers/content.asp" -->
<%
    dim id, sql
    id = viewstate_value("id")
    if isnumeric(id) then
        sql = "update prorel set zichtb = abs(zichtb - 1) where id=" & id
        executesql sql
    end if
    response.Redirect refurl
%>
<!-- #include file="../../templates/footers/content.asp" -->
