<!-- #include file="../../templates/headers/content.asp" -->
<%
    dim projec_id
    projec_id = viewstate_value("projec_id")
    
    if isnumeric(projec_id) then
        session("projec_id") = projec_id
        'response.redirect "projec/default.asp"
    end if 
    
	f_header getlabel("Kruisjeslijst") & " - " & dblookup("projec","id", session("projec_id"), "pronaa")
%>
<div style="padding: 15px 0px 15px 0px">
    <br /><br />
    Klik <a href='../../default.asp'>hier</a> om terug te gaan naar de projectlijst.
    <br /><br />
    Controle datum: <%=Now() %>
</div>



<%	
	dim sql, fields, orderby, rs
	
	fields = ""
	fields = fields & "$name:=keuzen_id;type:=hidden;$"
	fields = fields & "$name:=keuzen_keucod;type:=text;url:=#;title:=~keuzen_keubes~;label:=Keuze;width:=60px;$"
	fields = fields & "$name:=keuzen_keubes;type:=text;label:=Omschrijving;width:=400px;$"
	fields = fields & "$name:=keuzen_keuafd;type:=text;label:=Afdeling;width:=90px;$"
	fields = fields & "$name:=keuzen_prikop;type:=text;format:=d2;label:=Prijs;width:=60px;align:=right;$"
	orderby = "noorder"
	
	select case lcase(Session("APPLICATION"))
	 case "oude_status"
        sql = sql & " exec sp_projec_kruislijst " & session("projec_id") & ", 0"
        %>
        <style>
            * {font-family: Arial; font-size: 10px}
            .r_table {width: 100%; text-transform: lowercase}
            .r_field {border: solid 1px #a0a0a0; width: 15px; background-color: #fff}
            .r_head  {border: solid 1px #a0a0a0; width: 15px; background-color: #000; color: #fff; text-transform: uppercase}
        </style>
        <%
        r_list sql, fields, orderby
    case else
        sql = sql & " exec sp_projec_kruislijst_2 " & session("projec_id") & ""
        
        if instr(1,sec_roles(),"aa")=0 and instr(1,sec_roles(),"pr")=0 and instr(1,sec_roles(),"kb")=0 then
            sql = sql & ", 0" 'toon prijzen
        else
            sql = sql & ", 1" 'toon prijzen niet
        end if
        
        Response.Clear 
	    Response.ContentType = "application/vnd.ms-excel"
	    Response.AddHeader "Content-Disposition", "attachment;filename=CustomReport.xls"
        %>
        <html>
        <head>
        <style>
            * {font-family: Arial; font-size: 10px}
            .r_table {width: 100%; text-transform: lowercase}
            .r_field {border: solid 1px #a0a0a0; width: 15px; background-color: #fff}
            .r_head  {border: solid 1px #a0a0a0; width: 15px; background-color: #000; color: #fff; text-transform: uppercase}
        </style>
        </head>
        <body>
        <%
            rw dblookup("projec","id",session("projec_id"),"pronaa")& "<br>"
            rw "Kruisjeslijst: " & now & "<br>"
            skip_space = true
	        r_list sql, fields, orderby
        %>
        </body>
        </html>
        <%
        response.end
   end select
    
%>	
<!-- #include file="../../templates/footers/content.asp" -->
