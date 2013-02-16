<!-- #include file="../../templates/headers/content.asp" -->
<%
    keuzen_ids = viewstate_value("checkbox_id")
    
    action = viewstate_value("action")
    keusoo_soonaa = viewstate_value("keusoo_soonaa")
    koppel_id = viewstate_value("koppel_id")

    select case lcase(action)
    case "empty_buffer"
        session("keuzen_ids") = ""
        session("keusoo_soonaa") = ""
    case "check"
        keuzen_ids = viewstate_value("checkbox_id")
        sql = "update keuzen set control=1, wijdat=getdate() where id in (" & keuzen_ids & ") and defini=1"
        executesql sql
        sql = "update bounum set lacoda=getdate() where id in (select koppel_id from keuzen where id in (" & keuzen_ids & ") and defini=1)"
        executesql sql        
    case "delete"
        keuzen_ids = viewstate_value("checkbox_id")
        if instr(keuzen_ids,",")>0 then
            sql = ""
            ki = split(keuzen_ids,",")
            for i = lbound(ki) to ubound(ki)
                sql = sql & "exec sp_keuzen_delete " & ki(i) & ";"
            next
            executesql sql
        else                
            sql = "sp_keuzen_delete " & keuzen_ids 
            executesql sql
        end if
    case "new"
        'create procedure sp_keuzen_nieuw 
        '(	
	    '    @keucod varchar(255),
	    '    @keusoo_soonaa char(1),
	    '    @koppel_id int,
	    '    @wijgeb int
        ') as
        sql = "exec sp_keuzen_nieuw '000_NIEUW','" & keusoo_soonaa & "'," & koppel_id & "," & sec_currentuserid()
        executesql sql
    case "copy"
        keuzen_ids = viewstate_value("checkbox_id")
        if keusoo_soonaa = session("keusoo_soonaa") then
            session("keuzen_ids") = session("keuzen_ids") & "," & keuzen_ids
        else
            session("keusoo_soonaa") = keusoo_soonaa
            session("keuzen_ids") = keuzen_ids
        end if
    case "paste"
        keuzen_ids = session("keuzen_ids")
        if keusoo_soonaa = session("keusoo_soonaa") then
            if instr(keuzen_ids,",")>0 then
                sql = ""
                ki = split(keuzen_ids,",")
                for i = lbound(ki) to ubound(ki)
                    sql = sql & "exec sp_keuzen_kopieer2 " & ki(i) & ";"               
                next
                executesql sql
            else
                sql = "sp_keuzen_kopieer2 " & keuzen_ids 
                executesql sql
            end if
        elseif keusoo_soonaa = "P" and session("keusoo_soonaa") = "S" or keusoo_soonaa = "W" and session("keusoo_soonaa") = "P" or keusoo_soonaa = "B" and session("keusoo_soonaa") = "W" Then
            if instr(keuzen_ids,",")>0 then
                sql = ""
                ki = split(keuzen_ids,",")
                for i = lbound(ki) to ubound(ki)
                    sql = sql & "exec sp_keuzen_kopieer " & ki(i) & "," & koppel_id & ";"               
                next
                executesql sql
            else                
                sql = "sp_keuzen_kopieer " & keuzen_ids & "," & koppel_id
                executesql sql
            end if
        end if
    case "release"
        keuzen_ids = viewstate_value("checkbox_id")
        sql = "update keuzen set defini=0, control=0 where id in (" & keuzen_ids & ") and control=1"
        executesql sql
    case else
    end select
    
    ' response.write "action="  & action & "<br>"
    ' response.write "ids=" & keuzen_ids
    
    response.redirect refurl

%>
<!-- #include file="../../templates/footers/content.asp" -->
