<!-- #include file="../../templates/headers/content.asp" -->
<%
'rw session("application")
if Session("APPLICATION")="moon" and session("projec_id") = 75 then 'De Hofstede - Moonen
    %>
        <div class="video" style="padding: 20px">
        <b>Live mee kijken! Het kan!</b><br />
        <p>
        Voor het bekijken van de beelden zult u een active-x control moeten installeren.
        </p>
        Camera: <a target='_blank' href='http://212.121.96.66'>Klik hier</a><br />
        User: zuidercarre<br />
        Password: 581zc
        </div>
    <%    
    end if
%>
<div id='eb-thumbc'>
<%
    dim projec_id
    projec_id = viewstate_value("projec_id")
    
    if isnumeric(projec_id) then
        session("projec_id") = projec_id
    end if

	f_header getlabel("bouwplaatsfotos")
	%><br /><%
	dim sql, fields, orderby, rs
	
    sql = sql & " select "
    sql = sql & " * from vwBouwplaatsFotos where inreto_id = " & session("projec_id") & ""
    sql = sql & " order by aandat desc" 
 
	myTemplate = "<div style='float: left; width: 200px; height:350px; padding: 5px 5px 5px 5px:'>"
	myTemplate = myTemplate & "<a href='/include/file.asp?table=dosarc&inreto=dosarc&inreto_id=$id$' rel='shadowbox[Klassiek]'>"
	myTemplate = myTemplate & "<img style='width: 190px;' src='/include/file.asp?table=dosarc&inreto=dosarc&inreto_id=$id$'/>"
	myTemplate = myTemplate & "</a>"
	myTemplate = myTemplate & "<p style='text-align: center;'>$arcbes$</br>$aandat$</p>"
	myTemplate = myTemplate & "</div>"
	
	set rs = getrecordset(sql, true)
	
	with rs
	do until .eof
	    mt = replace(myTemplate, "$id$", .fields("id"))
	    mt = replace(mt, "$arcbes$", .fields("arcbes"))
	    mt = replace(mt, "$aandat$", .fields("aandat"))
	    response.Write mt
	    response.Flush 
	    .movenext
	loop
	end with
	
	set rs = nothing
	
%>
    <div class='clear'></div>
</div>

<!-- #include file="../../templates/footers/content.asp" -->
