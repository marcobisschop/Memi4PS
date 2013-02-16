<!-- #include file="../../templates/headers/content.asp" -->
<div>
<%
	dim inreto, inreto_id
	dim sql, rs
	
	inreto = viewstate_value("inreto")
	inreto_id = viewstate_value("inreto_id")
	
	select case inreto
	case "students"
	    	session("reportsource") = "select *,'' as STUDENTS_TESTSOVERVIEW from vw_students_correspondence where id in (" & inreto_id & ")"
	case "relations"
	case "relations_contacts"
	end select
	
	
	sql    = "select id,name,'template' as template from correspondence where reflects='" & inreto & "' and locked = 0"
	fields = fields & "$name:=id;type:=hidden;$"
	fields = fields & "$name:=name;type:=link;url:=../correspondence/correspondence.asp?inreto=" & inreto & "&inreto_id=" & inreto_id & "&templateid=~id~;label:=select_letter;$" 
	fields = fields & "$name:=template;type:=hidden;$" 	

	f_header("correspondence")
	r_list sql, fields, "name"
%>
<!-- #include file="../../templates/footers/content.asp" -->
