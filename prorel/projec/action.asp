<!-- #include file="../../templates/headers/content.asp" -->
<!-- #include file="../../include/email.asp" -->
<%
    action = viewstate_value("action")
   
    select case lcase(action)
    case "oa_afronden"
        keuzen_id = viewstate_value("keuzen_id")
        sql = "exec asp_keuzen_inreto " & keuzen_id & ",'oa_afronden'," & sec_currentuserid()
        executesql sql
    case else
    end select
    
    response.redirect refurl

%>
<!-- #include file="../../templates/footers/content.asp" -->
