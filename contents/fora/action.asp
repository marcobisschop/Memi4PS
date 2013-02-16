<!-- #include file="../../templates/headers/content.asp" -->
<%
    action = viewstate_value("action")
    inreto_fk = viewstate_value("inreto_fk")

    select case lcase(action)
    case "delete"
        fora_id = dblookup("forum","id",inreto_fk,"fora_id")
        inreto_fk = viewstate_value("inreto_fk")
        sql = sql & "exec sp_object_delete 'forum', " & inreto_fk
        executesql sql        
        refurl = "forum.asp?viewstate=new&fora_id=" & fora_id
    case else
    end select
    
    response.redirect refurl
%>
<!-- #include file="../../templates/footers/content.asp" -->
