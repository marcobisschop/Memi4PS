<!-- #include file="../../templates/headers/content.asp" -->
<style>
A.Knop {text-decoration:none; padding: 2px 5px 2px 5px; background: #ddd; color: black; border: 2px outset #555}
</style>
<%    
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

    f_header getlabel("woonwensen")
    
    sql = "sp_keuzen_lijst 'K'," & session("bounum_id")
    
   ' rw sql
    
    set rs = getrecordset(sql, true)
  
%>
<div style="padding: 15px 0px 15px 0px">
In de keuzelijst kunt u per keuze aangeven hoe vaak u deze wilt toevoegen. Zodra u klaar bent kunt u de 
gemaakte keuzen bevestigen op <a class="knop" href='bevestigen.asp'>keuzen bevestigen</a> te klikken. 
<br /><br />
De keuzelijst kan opgedeeld worden naar de ruimtes in uw woning of naar de sluitingsdata die gelden voor 
de keuzen. Dit zijn de uiterste data waarop een keuze bekend moet zijn.
<br /><br />
Bij sommige keuzen staat de opmerking; <img src="/images/actions/keuzen/voltek.gif" /> Aangeven op tekening!. Dit betekent dat u op de plattegrond met 
de keuzecode aan moet geven waar u de keuze wilt plaatsen. U vindt de plattegronden in het menu <a href='../documents'>documentatie</a>.
<p style="color: red">
Aan het beeldmateriaal kunnen geen rechten worden ontleend, prijswijzigingen zijn voorbehouden.
</p>
<%
select case lcase(Session("APPLICATION"))
case "moon"
    %>
    De bedragen worden online handig automatisch opgeteld tot een totaaloverzicht.<br />
    Er staat duidelijk aangegeven tot welke datum u bepaalde opties kunt kiezen in verband met de voortgang van de 
    bouw(voorbereiding). Tot deze datum kunt u onbeperkt wijzigingen maken.<br />
    Na deze datum wordengewenste wijzigingen door ons beoordeeld op technische uitvoerbaarheid t.o.v. de 
    bouwplanning, waarbij de prijs opnieuw bepaald wordt.
    <br /><br />
    Nadat de deadline is verlopen ontvangt u van ons een schriftelijke definitieve bevestiging die u dient te ondertekenen.<br />
    Pas dan zijn uw wensen juridisch bevestigd voor definitieve opdrachtverlening.
    <%        
end select
%>


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
        
        'rw sqlslucat
        
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
                        
            
            kosten_sum = 0
            
            dim kst_naam, kst_pk
            kst_naam = ""
                   
            do until .eof
               
                
                if cstr(.fields("keuafd_id")) = cstr(keuafd_id) or cstr(keuafd_id) = "-1" then
                if cstr(.fields("slucat_id")) = cstr(slucat_id) or cstr(slucat_id) = "-1" then
                
                if kst_pk <> .fields("keuset_id") then
                    kst_naam = .fields("kst_naam")
                    kst_pk = .fields("keuset_id")
                    if kst_pk = "-1" then 
                        kst_naam = "Overige keuzen en/of persoonlijke woonwensen" 
                        rw "<tr><td colspan='7'><hr><h1>"&kst_naam&"</h1>"
                        rw "</td></tr>"
                    else 
                        kst_naam = .fields("kst_naam")
                        kst_kop_titel = .fields("kst_kop_titel")
                        kst_kop_omschrijving = .fields("kst_kop_omschrijving")
                        if kst_kop_titel<>"" then
                            rw "<tr><td colspan='7' style='background-color: #e0e0e0'><h1>"&kst_kop_titel&"</h1>"
                            rw "<p style='padding: 10px 10px 10px 10px; background-color: #f8f0f0'>"&kst_kop_omschrijving&"</p>"
                            rw "</td></tr>"
                        end if
                        rw "<tr><td colspan='7'><hr><h1>"&kst_naam&"</h1>"
                        rw "<p style='padding: 10px 10px 10px 10px; background-color: #f8f0f0'>"&.fields("kst_omschrijving")&"</p>"
                        rw "</td></tr>"
                    end if
                    response.write "<tr>"
                    response.write "<td style='font-weight: bold'>" & getlabel("keucod") & "</td>"
                    response.write "<td style='font-weight: bold'>&nbsp;</td>"
                    response.write "<td style='font-weight: bold'>" & getlabel("keubes") & "</td>"
                    response.write "<td align='right' style='font-weight: bold'>" & getlabel("prijs") & "</td>"
                    response.write "<td align='right' style='font-weight: bold'>&nbsp;</td>"
                    response.write "<td align='right' style='font-weight: bold'>" & getlabel("aantal") & "</td>"
                    response.write "<td align='right' style='font-weight: bold'>" & getlabel("totaal") & "</td>"
                    response.write "</tr>"    
                end if 
               
                    
          
                
                    response.write vbCrLf
                    response.write vbcrlf & "<tr>"
                    response.write "<td class='keucod' valign='top' nowrap>"
                   ' response.write "<a href='e_keuzen.asp?viewstate=edit&id=" & .fields("keuzen_id") & "'>"
                    response.write "<span style='font-weight: 700; color: red'>" & .fields("keucod") & "</span>"
                    ' response.write " (" & .fields("keusoo_soonaa") & ")"
                   ' response.write "</a>"
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
                    
                    if rs.fields("aanmax")=0 then
                        rw "<td class='keubes' valign='top' align='right'>"
                        rw "standaard"
                        rw "<td colspan='3'>&nbsp;"
                        rw "</td>"
                    else
                    
                        response.write vbCrLf
                        response.write "<td class='keubes' valign='top' align='right' style='width: 75px'>"
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
                    end if
                    
                    response.write "</tr>"
                
                    kosten_sum = kosten_sum + .fields("kosten_sum")
                    
                    
                    dim sqlImages, rsImages
                
                    sqlImages = "select id, arcbes, inreto_id, arccon from dosarc where available=1 and inreto='memi_fotos' and inreto_id=" & .fields("keuzen_id")
                    sqlImages = "spKeuzen_Images " & .fields("keuzen_id")
                    
                    'rw sqlImages
                    set rsImages = getrecordset(sqlImages, true)
                    if not rsImages.eof then
                        rw "<tr><td colspan='2'>&nbsp;</td>"
                        rw "<td colspan='5'>" 
                        do until rsImages.eof
                            select case lcase(rsImages("arccon"))
                            case "application/pdf"
                                rw "<a href='/include/file.asp?table=dosarc&inreto=dosarc&inreto_id=" & rsImages.fields("id") & "'>"
                                rw  "<img style='cursor: hand;width: 60px; padding: 5px 5px 5px 5px' src='/images/icons/pdf-logo.jpg'"
                                rw " title='" & rs.fields("keucod") & " - " & rsImages.fields("arcbes") & " - " & .fields("keuzen_id") & "'"
                                rw "></a>"
                            case else
                                rw  "<img onclick='this.style.width == ""60px"" ? this.style.width = ""400px"" :  this.style.width = ""60px"";' style='cursor: hand;width: 60px; padding: 5px 5px 5px 5px' src='/include/image.asp?table=dosarc&inreto=dosarc&inreto_id=" & rsImages.fields("id") & "'"
                                rw " title='" & rs.fields("keucod") & " - " & rsImages.fields("arcbes") & " - " & .fields("keuzen_id") & "'"
                                rw ">"
                            end select
                            rsImages.movenext
                        loop
                        rw "</td></tr>"
                    end if
                    set rsImages = nothing
                
                
                    
                end if ' Check keuafd
                end if ' Check slucat
                
                
                
                .movenext
                
            loop
            
            response.write "<tr>"
            response.write "<td colspan='7'><hr></td>"
            response.write "</tr>"
            
            ' response.write "kosten_sum=" & kosten_sum & "<br>" 
            ' response.write "besteed=" & dblookup("vw_bounum_besteed","koppel_id",session("bounum_id"),"besteed") & "<br>" 
            
            
            besteed = dblookup("vw_bounum_besteed","koppel_id",session("bounum_id"),"besteed")
            
            
            
            
            
            
            if kosten_sum = "" then kosten_sum = 0
            
            response.write "<tr>"
            response.write "<td style='font-weight: bold'>&nbsp;</td>"
            
            response.write "<td style='font-weight: bold'>&nbsp;</td>"
            response.write "<td style='font-weight: bold'>&nbsp;</td>"
            response.write "<td colspan='3' style='font-weight: bold' align='right'><input type='submit' value='Totaal (bijwerken)'/></td>"
            response.write "<td style='font-weight: bold' align='right'>" & formatnumber(kosten_sum / (1+btw(now)),2) & "-</td>"
            response.write "</tr>"
            
            response.write "<tr>"
            response.write "<td style='font-weight: bold'>&nbsp;</td>"
            
            response.write "<td style='font-weight: bold'>&nbsp;</td>"
            response.write "<td style='font-weight: bold'>&nbsp;</td>"
            response.write "<td colspan='3' style='font-weight: bold' align='right'>B.t.w.</td>"
            response.write "<td style='font-weight: bold' align='right' nowrap>" & formatnumber(kosten_sum / (1+btw(now)) * btw(now), 2) & "</td>"
            response.write "</tr>"
            
            response.write "<tr>"
            response.write "<td style='font-weight: bold'>&nbsp;</td>"
            
            response.write "<td style='font-weight: bold'>&nbsp;</td>"
            response.write "<td style='font-weight: bold'>&nbsp;</td>"
            response.write "<td colspan='3' style='font-weight: bold' align='right'>Totaal incl. b.t.w.</td>"
            response.write "<td style='font-weight: bold; width: 70px' align='right'>" & formatnumber(kosten_sum, 2) & "</td>"
            response.write "</tr>"
            
            
            
            myBudget = dblookup("bounum","id",session("bounum_id"),"memi_budget") + 0
            if besteed="" then besteed=0
            besteed = cdbl(besteed) + 0
            if cdbl(myBudget) < cdbl(besteed) then color = "red" else color = "black"
            response.write "<tr>"
            response.write "<td style='font-weight: bold'>&nbsp;</td>"
                response.write "<td style='font-weight: bold'>&nbsp;</td>"
                response.write "<td style='font-weight: bold'>&nbsp;</td>"
                response.write "<td colspan='3' style='font-weight: bold' align='right'>Budget</td>"
                response.write "<td style='font-weight: bold; color:" & color & "' align='right' nowrap>" & formatnumber(myBudget - besteed, 2) & "</td>"
                response.write "</tr>"           
            response.write "</table>"
            response.write "</form>"
        else
        end if
    end with   
%>    
<a class="knop" href="bevestigen.asp"><%=getlabel("keuzen_bevestigen") %></a>
<p>
<table>
<tr><td style="width: 24px; text-align: center"><img style="width: 16px" src="/images/afbeeldingen.png" /></td><td><%=getlabel("heeft documentatie") %></td></tr>
<tr><td style="width: 24px; text-align: center"><img style="width: 16px" src="/images/no_afbeeldingen.png" /></td><td><%=getlabel("heeft geen documentatie") %></td></tr>
<tr><td style="width: 24px; text-align: center"><img style="width: 8px" src="/images/actions/keuzen/meerwerk.jpg" /></td><td><%=getlabel("meerwerk") %></td></tr>
<tr><td style="width: 24px; text-align: center"><img style="width: 8px" src="/images/actions/keuzen/minderwerk.jpg" /></td><td><%=getlabel("minderwerk") %></td></tr>
<tr><td style="width: 24px; text-align: center"><img style="width: 16px" src="/images/actions/keuzen/natebe.gif" /></td><td><%=getlabel("natebe") %></td></tr>
<tr><td style="width: 24px; text-align: center"><img style="width: 16px" src="/images/actions/keuzen/voltek.gif" /></td><td><%=getlabel("voltek") %></td></tr>
</table>
</p>
<!-- #include file="../../templates/footers/content.asp" -->


