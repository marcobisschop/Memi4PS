<!-- #include file="../../templates/headers/content.asp" -->

<%

    'session("bounum_id") = 20

    viewstate = viewstate_value("viewstate")

    if viewstate = "update" then
    
       sql = ""
       for each fld in uploader.FormElements
        if left(fld,5) = "keuze" then
            keuzen_id = split(uploader.form(fld),"-")(0)
            aantal = split(uploader.form(fld),"-")(1)
            koppel_id = session("bounum_id")
            sql = sql & "exec sp_keuzen_kopieer3 " & keuzen_id & "," & koppel_id & "," & aantal & ";"            
        else
            
        end if
       next
       if len(sql) > 0 then executesql sql
    end if    
    
    viewstate = "update"
    

    f_header ("woonwensen")
%>
<div class="rolodex">

</div>
<%    
    sql = "sp_keuzen_lijst 'K'," & session("bounum_id")
    
    set rs = getrecordset(sql, true)
    
    with rs
        if not .eof then
            f_form_hdr()
            
            
            response.write "<table cellpadding='5' class='keuzen'>"
            response.write "<tr>"
            response.write "<td style='font-weight: bold'>&nbsp;</td>"
            response.write "<td style='font-weight: bold'>" & getlabel("keucod") & "</td>"
            response.write "<td style='font-weight: bold'>&nbsp;</td>"
            response.write "<td style='font-weight: bold'>" & getlabel("keubes") & "</td>"
            response.write "<td style='font-weight: bold'>" & getlabel("prijs") & "</td>"
            response.write "<td style='font-weight: bold'>&nbsp;</td>"
            response.write "<td style='font-weight: bold'>" & getlabel("aantal") & "</td>"
            response.write "<td style='font-weight: bold'>" & getlabel("totaal") & "</td>"
            response.write "</tr>"         
            
            response.write "<tr>"
            response.write "<td colspan='8'><hr></td>"
            response.write "</tr>"
            
            kosten_sum = 0
                   
            do until .eof
            
                
                ''response.write "<td class='keuzen_id' valign='top'>"
                ''response.write "<input type='checkbox' id='keuzen_id' value='" & .fields("keuzen_id") & "'/>"
                ''response.write "</td>"
    
                response.write vbCrLf
                response.write vbcrlf & "<tr>"
                response.write "<td class='keuzen_images' valign='top'>"
                if .fields("no_images") > 0 then
                    response.write "<a title='" & getlabel("afbeeldingen") & "' href='afbeeldingen.asp?keuzen_id=" & .fields("keuzen_id") & "'>"
                    response.write "<img style='border: none' src='/images/afbeeldingen.png'/>"
                    response.write "</a>"
                end if
                response.write "</td>"
    
                response.write "<td class='keucod' valign='top' nowrap>"
                response.write .fields("keucod")
                response.write " (" & .fields("keusoo_soonaa") & ")"
                response.write "</td>"
            
                response.write vbCrLf
                response.write "<td class='keuzen_images' valign='top'>"
                if cbool(.fields("voltek")) then
                    response.write "<img title='" & getlabel("voltek") & "' src='/images/actions/keuzen/voltek.gif'/>"
                end if
                response.write "</td>"
                
                response.write vbCrLf
                response.write "<td class='keubes' valign='top'>"
                response.write .fields("keubes")
                response.write "</td>"
                
                response.write vbCrLf
                response.write "<td class='keubes' valign='top' align='right'>"
                response.write formatnumber(.fields("prikop"),2)
                response.write "</td>"
                
                response.write vbCrLf
                response.write "<td class='keuzen_images' valign='top'>"
                if cbool(.fields("natebe")) then
                    response.write "<img title='" & getlabel("natebe") & "' src='/images/actions/keuzen/natebe.gif'/>"
                end if
                response.write "</td>"
                
                response.write vbCrLf
                response.write "<td class='keuzen_code' valign='top' align='right'>"
                response.write "<select id='keuze" & .fields("keuzen_id") & "' name='keuze" & .fields("keuzen_id") & "' "
                if .fields("defini")>0 then response.write " disabled"
                'response.write " onchange='keuze_changed()'"
                response.write ">"
                for i = rs.fields("aanmin") to rs.fields("aanmax")
                    response.write "<option value='" & .fields("keuzen_id") & "-" & i & "' "
                    if i = .fields("aantal") then response.write "selected"
                    response.write ">"
                    response.write i
                    response.write "</option>"                    
                next
                response.write "</select>"
                response.write "</td>"
                
                response.write "<td class='keubes' valign='top' align='right'>"
                response.write formatnumber(.fields("kosten_sum"),2)
                response.write "</td>"
                
                response.write "</tr>"
            
                kosten_sum = kosten_sum + .fields("kosten_sum")
                .movenext
            loop
            
            response.write "<tr>"
            response.write "<td colspan='8'><hr></td>"
            response.write "</tr>"
            
            response.write "<tr>"
            response.write "<td style='font-weight: bold'>&nbsp;</td>"
            
            response.write "<td style='font-weight: bold'>&nbsp;</td>"
            response.write "<td style='font-weight: bold'>&nbsp;</td>"
            response.write "<td style='font-weight: bold'>&nbsp;</td>"
            response.write "<td colspan='3' style='font-weight: bold' align='right'><input type='submit' value='Bijwerken'/></td>"
            response.write "<td style='font-weight: bold' align='right'>" & formatnumber(kosten_sum,2) & "</td>"
            response.write "</tr>"
            response.write "</table>"
            response.write "</form>"
        else
        end if
    end with   
%>    
<!-- #include file="../../templates/footers/content.asp" -->