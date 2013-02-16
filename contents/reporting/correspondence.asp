<!-- #include file="../../templates/headers/content.asp" -->
<div>
<%
	dim inreto, inreto_id
	dim sql, rs
	
	inreto = viewstate_value("inreto")
	inreto_id = viewstate_value("inreto_id")
	
	select case inreto
	case "relations"
	    	session("reportsource") = "select * where vw_relations_correspondence where id in (" & inreto_id & ")"
	case "contacts"
	    	session("reportsource") = "select * where vw_contacts_correspondence where id in (" & inreto_id & ")"
	    	inreto = "relations"
	case "deelnemers"
	    	session("reportsource") = "select * from vw_prodee where id in (" & inreto_id & ")"
	    	inreto = "deelnemers"
	end select
		
	sql    = "select id,name,'template' as template from correspondence where reflects='" & inreto & "' and locked = 0"
	fields = fields & "$name:=id;type:=hidden;$"
	fields = fields & "$name:=name;type:=link;url:=../correspondence/correspondence.asp?inreto=" & inreto & "&inreto_id=" & inreto_id & "&templateid=~id~;label:=select_letter;$" 
	fields = fields & "$name:=template;type:=link;target:=_blank;url:=../correspondence/correspondence.asp?verbosemode=true&inreto=" & inreto & "&inreto_id=" & inreto_id & "&templateid=~id~;label:=select_letter;$" 

	f_header("correspondence")
	r_list sql, fields, "name"
%>
<!-- #include file="../../templates/footers/content.asp" -->
