<!-- #include file="../../templates/headers/content.asp" -->
<!-- #include file="../../include/email.asp" -->
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
        if len(keuzen_ids)=0 then  response.redirect refurl
        sql = "update keuzen set control=1, wijdat=getdate() where id in (" & keuzen_ids & ") and defini=1"
        executesql sql
        sql = "update bounum set lacoda=getdate() where id in (select koppel_id from keuzen where id in (" & keuzen_ids & ") and defini=1)"
        executesql sql        
        
        bounum_id = viewstate_value("koppel_id")
        projec_id = dblookup("bounum","id",bounum_id,"projec_id")
        informRelations bounum_id, projec_id
        
    case "inform_relations"
        bounum_id = viewstate_value("koppel_id")
        projec_id = dblookup("bounum","id",bounum_id,"projec_id")
        informRelations bounum_id, projec_id
        
        
    case "invoice_on"
        keuzen_ids = viewstate_value("checkbox_id")
        koppel_id = viewstate_value("koppel_id")
        sql = "update keuzen set factur=1, wijdat=getdate() where keusoo_soonaa='B' and koppel_id in (" & koppel_id & ") and defini=1 and control=1"
        executesql sql        
    case "invoice_off"
        keuzen_ids = viewstate_value("checkbox_id")
        koppel_id = viewstate_value("koppel_id")
        sql = "update keuzen set factur=0, wijdat=getdate() where keusoo_soonaa='B' and koppel_id in (" & koppel_id & ") and defini=1 and control=1"
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
        'response.end
    case "new_kosten"
        inreto_id = viewstate_value("inreto_id")
        sql = "exec sp_kosten_nieuw '000_NIEUW'," & inreto_id & "," & sec_currentuserid()
        executesql sql    
    case "new"
        sql = "exec sp_keuzen_nieuw '000_NIEUW','" & keusoo_soonaa & "'," & koppel_id & "," & sec_currentuserid()
        dim rsNew, keuzen_id
        set rsNew = getrecordset(sql, true)
        on error resume next
        keuzen_id = rsNew("keuzen_id")
        
        
        if err.number = 0 then
            response.Redirect "e_keuzen.asp?viewstate=edit&id=" & keuzen_id
        else
            
        end if
        on error goto 0
        set rsNew = Nothing
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
                    sql = sql & "exec sp_keuzen_kopieer2 " & ki(i) & "," & koppel_id & ";"               
                next
                executesql sql
            else
                sql = "sp_keuzen_kopieer2 " & keuzen_ids & "," & koppel_id
                executesql sql
                
            end if
        elseif (keusoo_soonaa = "P" and session("keusoo_soonaa") = "S") or (keusoo_soonaa = "W" and session("keusoo_soonaa") = "P") or keusoo_soonaa = "B" and session("keusoo_soonaa") = "W" Then
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
            'rw sql
            'response.end
        end if
    case "release"
        keuzen_ids = viewstate_value("checkbox_id")
        sql = "update keuzen set defini=0, control=0 where id in (" & keuzen_ids & ") and control=1"
        executesql sql
    case else
    end select
    
    ' response.write "action="  & action & "<br>"
    ' response.write "ids=" & keuzen_ids
    
    'response.Write sql
    'response.end
    
    response.redirect refurl



    function informRelations(bounum_id, projec_id)
            
            sqlPRO = "select * from vw_prorel where projec_id=" & projec_id
            msg = "Bouwnummer #extnum# van project #pronaa# heeft wijzigingen"
            sqlBNR = "select * from vw_bounum where bounum_id = " & bounum_id
            set rsBNR = getrecordset(sqlBNR, true)
            with rsBNR
                for each fld in .fields
                    msg = replace(msg,"#" & fld.name & "#", fld.value & "")
                next
            end with
            set rsBNR = nothing
            set rsPRO = getrecordset(sqlPRO, true)
            with rsPRO
                do until .eof
                    if len(.fields("adrema")) then
                        mBcc = mBcc & .fields("adrema") & ","
                    end if
                    .movenext
                loop
            end with
            mBcc = mid(mBcc,1,len(mBcc)-1)
            mBcc = replace(mBcc,",,",",")
            mFrom = "memi3@telaterrae.com"
            mTo  = "marco@telaterrae.com"
            mCc  = ""
            mSubject = "Kopersbegeleiding.nl"
            mBody = msg
            Attachments = ""
            mail mFrom, mTo, mCc, mBcc, mSubject, mBody, Attachments
            
            'mail2 "memi3@telaterrae.com","marco@telaterrae.com","","","test","body",""
                    
            set rsPRO = nothing        
        end function
%>
<!-- #include file="../../templates/footers/content.asp" -->
