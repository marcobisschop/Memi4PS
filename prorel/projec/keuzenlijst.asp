<!-- #include file="../../templates/headers/content.asp" -->
<%
    dim projec_id
    projec_id = viewstate_value("projec_id")
    
    if isnumeric(projec_id) then
        session("projec_id") = projec_id
        'response.redirect "projec/default.asp"
    end if 
    
	f_header getlabel("Keuzenlijst") & " - " & dblookup("projec","id", session("projec_id"), "pronaa")
%>
<style>
    .r_field { border-top: solid 1px #a0a0a0; background-color: #fff}
</style>


<%	
	dim sql, fields, orderby, rs
	
    sql = sql & " exec sp_projec_keuzenlijst " & session("projec_id") & ""
    
	fields = ""
	fields = fields & "$name:=keuzen_id;type:=hidden;$"
	fields = fields & "$name:=keuzen_keucod;type:=text;width:=50px;$"
	fields = fields & "$name:=keuzen_keubes;type:=text;$"
	fields = fields & "$name:=keuzen_prikop;type:=text;format:=d2;width:=80px;align:=right;$"
	orderby = "noorder"
	
	session("translation_off") = 1
	r_list sql, fields, orderby
	session("translation_off") = 0
%>
<!-- #include file="../../templates/footers/content.asp" -->
