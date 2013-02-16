<!-- #include file="../../templates/headers/content.asp" -->
<%
    inreto_ids = viewstate_value("checkbox_id")
    
    action = viewstate_value("action")
    inreto = viewstate_value("inreto")
    inreto_id = viewstate_value("inreto_id")

    session("prev_action") = session("action")
    session("action") = action
    
    select case lcase(action)
    case "empty_buffer"
        session(inreto & "_ids") = ""
        session("inreto") = ""        
    case "delete"
        inreto_ids = viewstate_value("checkbox_id")
        sql = ""
        sql = sql & "delete from dosarc where id in (" & inreto_ids & "); "
        executesql sql
    case "new"
        sql = "sp_docum_new '" & inreto & "', " & inreto_id
        executesql sql
        'response.write sql
        'response.end
    case "new_dosarc"
        response.redirect "/contents/documents/e_dosarc.asp?viewstate=new&id=-1&inreto=" & inreto & "&inreto_id=" & inreto_id
    case "cut"
        inreto_ids = viewstate_value("checkbox_id")
        session("inreto") = inreto
        session(inreto & "_ids") = inreto_ids
    case "copy"
        inreto_ids = viewstate_value("checkbox_id")
        session("inreto") = inreto
        session(inreto & "_ids") = inreto_ids
    case "paste"
        inreto_ids = session(inreto & "_ids")
        
        ' response.write "prev_action=" & session("prev_action") & "<br>"
        ' response.end
        
        select case session("prev_action")
        case "cut"
            
            sql = "update dosarc set inreto_id=" & inreto_id & " where id in (" & session(inreto & "_ids") & ")"
            executesql sql
            
            ' buffer leegmaken. na cut kun je maar 1 keer plakken
            session(inreto & "_ids") = ""
        case "copy"
            ' copy documents...
            ' zodat de prev action volgende keer weer op copy staat
            session("action") = "copy" 
        end select
    case else
    end select
    
    response.write "action="  & action & "<br>"
    response.write "inreto=" & inreto & "<br>"
    response.write "ids=" & inreto_ids
    
    response.redirect refurl

%>
<!-- #include file="../../templates/footers/content.asp" -->
