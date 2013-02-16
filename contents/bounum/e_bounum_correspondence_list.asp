<!-- #include file="../../templates/headers/content.asp" -->
<!-- #include file="functions.asp" -->
<div>
<%
	dim inreto, inreto_id
	dim sql, rs
	
	inreto = viewstate_value("inreto")
	inreto_id = viewstate_value("inreto_id")
	
	session("reportsource") = "select *,'' as keuzelijst,'' as meterkastbrief from VW_BOUNUM_CORRESP where bounum_id=" & inreto_id
	
	sql    = "select id,name,'template' as template from correspondence where reflects='" & inreto & "' and locked = 0"
	fields = fields & "$name:=id;type:=hidden;$"
	fields = fields & "$name:=name;type:=link;url:=../correspondence/correspondence.asp?inreto=" & inreto & "&inreto_id=" & inreto_id & "&templateid=~id~;label:=select_letter;$" 
	fields = fields & "$name:=template;target:=_blank;type:=link;url:=../correspondence/correspondence.asp?inreto=" & inreto & "&inreto_id=" & inreto_id & "&templateid=~id~&verbosemode=true;label:=view_template;$" 	

	bounum_header(inreto_id)
	r_list sql, fields, "arcnaa"
%>
<!-- #include file="../../templates/footers/content.asp" -->
