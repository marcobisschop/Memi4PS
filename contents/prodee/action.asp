<!-- #include file="../../templates/headers/content.asp" -->
<%
    ids = viewstate_value("checkbox_id")
    
    action = viewstate_value("action")
    keusoo_soonaa = viewstate_value("keusoo_soonaa")
    koppel_id = viewstate_value("koppel_id")

    select case lcase(action)
    case "d2k"
    case else
    end select
    
    ' response.write "action="  & action & "<br>"
    ' response.write "ids=" & keuzen_ids
    
    response.redirect refurl

%>
<!-- #include file="../../templates/footers/content.asp" -->
