<!-- #include file="../../templates/headers/content.asp" -->
<%

    dim sql, rs, stabuh_id
    
    stabuh_id = viewstate_value("stabuh_id")
    if len(stabuh_id)=0 then stabuh_id=0
    
    function show_stabu(stabuh_id, level, write_table)
        dim sql, rs
        sql = "select stabuh.id as stabu_id,* from stabuh left join nacalc on stabuh.nacalc_id=nacalc.id where stabuh_id=" & stabuh_id & " order by volgor"
        set rs = getrecordset(sql, true)
        with rs
            if write_table then 
                rw "<table class='stabu' cellpadding='0' cellspacing='0'>"
                rw "<tr><th>" & getlabel("stacod") & "</th>"
                rw "<th>&nbsp;</th>"
                rw "<th>" & getlabel("stabes") & "</th>"
                rw "<th>" & getlabel("naccod") & "</th>"
                rw "<th>&nbsp;</th></tr>"
            end if
            if .eof then
            else
                rw "<tr>"
                do until .eof
                    rw "<td class='stabu_level_" & level & "'>" 
                    for i = 0 to level
                        rw "&nbsp;"
                    next
                    rw .fields("hoocod") 
                    rw "</td>"
                    rw "<td class='stabu_actions'><a title='" & getlabel("bewerken") & "' href='e_stabu.asp?viewstate=edit&id=" & .fields("stabu_id") & "'>e</a></td>"
                    
                    rw "<td class='stabu_level stabu_level_" & level & "'>" & .fields("hoobes") & "</td>" 
                    
                    rw "<td class='stabu_nacalc'><a title='" & .fields("nacbes") & "'>" & .fields("naccod") & ":" & .fields("nacbes") & "</a></td>"
                    
                    rw "<td class='stabu_actions'><a title='" & getlabel("new") & "'href='e_stabu.asp?viewstate=new&id=-1&stabuh_id=" & .fields("stabu_id") & "'>+</a></td>"
                    
                    
                    show_stabu .fields("stabu_id"),level+1, false
                    rw "</tr>"
                    .movenext
                loop
            end if
            if write_table then rw "</table>"
        end with
        set rs = nothing
    end function   
    
    f_header getlabel("stabu_codering")
    
%>
bestektekeningen. De gebruikelijke systematiek in de Nederlandse ontwikkeling is de stabu systematiek voor de bouw als uitgegeven door de Stichting STABU of de RAW-systematiek voor de grond-, weg- en waterbouw door de CROW (beide te Ede)
<a href='http://nl.wikipedia.org/wiki/Bestek'>http://nl.wikipedia.org/wiki/Bestek</a> (plan)
<p>
<b>STABU-systematiek</b>
<br />
De besteksystemathiek van STABU bestaat uit 88 hoofdstukken. Elk hoofdstuk kent weer diverse paragrafen en subparagrafen. De STABU bevat een algemeen deel voor administratieve bepalingen. Hierin liggen de algemene, administratieve en juridische bepalingen vast. Dit zijn de hoofdstukken 01 t/m 04. De hoofdstukken 05-88 bevatten de standaard technische bepalingen.
</p>
<%    
    
    
    show_stabu -1,0,true

%>	
<!-- #include file="../../templates/footers/content.asp" -->
