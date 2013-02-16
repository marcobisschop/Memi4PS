<!-- #include file="../../templates/headers/content.asp" -->

<%

    'session("bounum_id") = 20
    
    'response.write session("bounum_id")

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
    
    sql = "sp_keuzen_lijst 'K'," & session("bounum_id")
    set rs = getrecordset(sql, true)
  

%>
<div style="padding: 15px 0px 15px 0px">
In de keuzelijst kunt u per keuze aangeven hoe vaak u deze wilt toevoegen. Zodra u klaar bent kunt u de 
gemaakte keuzen bevestigen door onderaan de pagina op <a href='bevestigen.asp'>keuzen bevestigen</a> te klikken. 
<br /><br />
De keuzelijst kan opgedeeld worden naar de ruimtes in uw woning of naar de sluitingsdata die gelden voor 
de keuzen. Dit zijn de uiterste data waarop een keuze bekend moet zijn.
<br /><br />
Bij sommige keuzen staat de opmerking; <img src="/images/actions/keuzen/voltek.gif" /> Aangeven op tekening!. Dit betekent dat u op de plattegrond met 
de keuzecode aan moet geven waar u de keuze wilt plaatsen. U vindt de plattegronden in het menu <a href='../documents'>documentatie</a>
</div>
<%f_form_hdr_name "filter" %>
<table style="border: solid 1px #aoaoao">
<tr>
    <td>
        <%=getlabel("keuafd") %>:&nbsp;
        <select id="keuafd_id" name="keuafd_id" onchange="filter.submit()">
        <option value="-1">-- Alles Tonen --</option>
        <%
        keuafd_ids = ""
        keuafd_id = viewstate_value("keuafd_id")
        if keuafd_id="" then keuafd_id="-1"
        with rs
            do until .eof
                if not instr(keuafd_ids, "," & .fields("keuafd_id")) then
                    keuafd_ids = keuafd_ids & "," & .fields("keuafd_id")
                end if
                .movenext
            loop
            .movefirst            
        end with
        sqlKeuafd = "select * from vw_keuafd where id in (" & mid(keuafd_ids,2) & ")"
        set rsKeuafd = getrecordset(sqlKeuafd, true)
        with rsKeuafd
            do until .eof
                response.write "<option value='" & .fields("id") & "'"
                if cstr(keuafd_id) = cstr(.fields("id")) then response.write " selected"
                response.write ">" & .fields("afdnaa") & "</option>"
                .movenext                
            loop
        end with
        set rsKeuafd = nothing
        %>        
        </select>
    </td>
    <td>
        <%=getlabel("slucat") %>:&nbsp;
        <select id="slucat_id" name="slucat_id" onchange="filter.submit()">
        <option value="-1">-- Alles Tonen --</option>
        <%
        slucat_ids = ""
        slucat_id = viewstate_value("slucat_id")
        if slucat_id="" then slucat_id="-1"
        with rs
            do until .eof
                if not instr(slucat_ids, "," & .fields("slucat_id")) then
                    slucat_ids = slucat_ids & "," & .fields("slucat_id")
                end if
                .movenext
            loop
            .movefirst            
        end with
        sqlslucat = "select * from vw_bounum_bouslu where bounum_id in (" & session("bounum_id") & ")"
        ' if len(keucat_id) > 0 then sqlslucat = sqlslucat & " and slucat"
        set rsslucat = getrecordset(sqlslucat, true)
        with rsslucat
            do until .eof
                response.write "<option value='" & .fields("slucat_id") & "'"
                if cstr(slucat_id) = cstr(.fields("slucat_id")&"") then response.write " selected"
                response.write ">" & .fields("slunaa") & " (" & .fields("datum") & ")</option>"
                .movenext                
            loop
        end with
        set rsslucat = nothing
        %>        
        </select>
    </td>
</tr>
</table>
</form>

<%    
    
    with rs
        if not .eof then
            f_form_hdr()
            
            f_hidden "keuafd_id"
            f_hidden "slucat_id"
            
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
            
               ' response.write keuafd_id & ":" & .fields("keuafd_id") & "<br>"
               ' response.write slucat_id & ":" & .fields("slucat_id") & "<br>"
            
                if cstr(.fields("keuafd_id")) = cstr(keuafd_id) or cstr(keuafd_id) = "-1" then
                if cstr(.fields("slucat_id")) = cstr(slucat_id) or cstr(slucat_id) = "-1" then
                
                    response.write vbCrLf
                    response.write vbcrlf & "<tr>"
                    response.write "<td class='keuzen_images' valign='top'>"
                    if .fields("no_images") > 0 then
                        response.write "<a title='" & getlabel("afbeeldingen") & "' href='e_docum.asp?viewstate=view&id=" & .fields("keuzen_id") & "'>"
                        response.write "<img style='border: none' src='/images/afbeeldingen.png'/>"
                        response.write "</a>"
                    end if
                    response.write "</td>"
        
                    response.write "<td class='keucod' valign='top' nowrap>"
                    response.write "<a href='e_keuzen.asp?viewstate=edit&id=" & .fields("keuzen_id") & "'>"
                    response.write .fields("keucod")
                    ' response.write " (" & .fields("keusoo_soonaa") & ")"
                    response.write "</a>"
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
                    if cbool(.fields("defini")) then response.write " disabled title='" & getlabel("defini") & "'"
                    if datediff("d",Now(),.fields("slucat_datum")) < 0 then response.write " disabled title='" & .fields("slucat_datum") & "'"
                    if not isdate(.fields("slucat_datum")) then 
                        response.write " disabled title='no_sludat'" 
                    else
                        response.write " title='" & .fields("slucat_datum") & "'"
                    end if
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
                    
                end if ' Check keuafd
                end if ' Check slucat
                .movenext
            loop
            
            response.write "<tr>"
            response.write "<td colspan='8'><hr></td>"
            response.write "</tr>"
            
            ' response.write "kosten_sum=" & kosten_sum & "<br>" 
            ' response.write "besteed=" & dblookup("vw_bounum_besteed","koppel_id",session("bounum_id"),"besteed") & "<br>" 
            
            
            besteed = dblookup("vw_bounum_besteed","koppel_id",session("bounum_id"),"besteed")
            
            
            
            if kosten_sum = "" then kosten_sum = 0
            
            response.write "<tr>"
            response.write "<td style='font-weight: bold'>&nbsp;</td>"
            
            response.write "<td style='font-weight: bold'>&nbsp;</td>"
            response.write "<td style='font-weight: bold'>&nbsp;</td>"
            response.write "<td style='font-weight: bold'>&nbsp;</td>"
            response.write "<td colspan='3' style='font-weight: bold' align='right'><input type='submit' value='Totaal (bijwerken)'/></td>"
            response.write "<td style='font-weight: bold' align='right'>" & formatnumber(kosten_sum,2) & "</td>"
            response.write "</tr>"
            
            response.write "<tr>"
            response.write "<td style='font-weight: bold'>&nbsp;</td>"
            
            response.write "<td style='font-weight: bold'>&nbsp;</td>"
            response.write "<td style='font-weight: bold'>&nbsp;</td>"
            response.write "<td style='font-weight: bold'>&nbsp;</td>"
            response.write "<td colspan='3' style='font-weight: bold' align='right'>B.t.w.</td>"
            response.write "<td style='font-weight: bold' align='right'>" & formatnumber(kosten_sum * 0.19,2) & "</td>"
            response.write "</tr>"
            
            response.write "<tr>"
            response.write "<td style='font-weight: bold'>&nbsp;</td>"
            
            response.write "<td style='font-weight: bold'>&nbsp;</td>"
            response.write "<td style='font-weight: bold'>&nbsp;</td>"
            response.write "<td colspan='4' style='font-weight: bold' align='right'>Totaal incl. b.t.w.</td>"
            response.write "<td style='font-weight: bold' align='right'>" & formatnumber(kosten_sum * 1.19,2) & "</td>"
            response.write "</tr>"
            
            
            
            myBudget = dblookup("bounum","id",session("bounum_id"),"memi_budget") + 0
            if besteed="" then besteed=0
            besteed = cdbl(besteed) + 0
            if cdbl(myBudget) < cdbl(besteed) * 1.19 then color = "red" else color = "black"
            response.write "<tr>"
            response.write "<td style='font-weight: bold'>&nbsp;</td>"
                response.write "<td style='font-weight: bold'>&nbsp;</td>"
                response.write "<td style='font-weight: bold'>&nbsp;</td>"
                response.write "<td colspan='4' style='font-weight: bold' align='right'>Budget</td>"
                response.write "<td style='font-weight: bold; color:" & color & "' align='right' nowrap>" & formatnumber(myBudget - besteed * 1.19,2) & "</td>"
                response.write "</tr>"           
            response.write "</table>"
            response.write "</form>"
        else
        end if
    end with   
%>    
<a href="bevestigen.asp"><%=getlabel("keuzen_bevestigen") %></a>
<!-- #include file="../../templates/footers/content.asp" -->