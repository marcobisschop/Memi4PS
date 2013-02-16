<!-- #include file="../../templates/headers/content.asp" -->
<!-- #include file="functions.asp" -->
<div>
<%
	dim inreto, inreto_id
	dim sql, rs
	
	inreto = viewstate_value("inreto")
	inreto_id = viewstate_value("inreto_id")
	
	select case lcase(inreto)
	case "contacts"
	    session("reportsource") = "select * from vw_contacts_correspondence where id=" & inreto_id
	    inreto    = "relations"
	    'inreto_id = viewstate_value("id")
	    contacts_header(inreto_id)
	case "relations"
	    session("reportsource") = "select * from vw_relations_correspondence where id=" & inreto_id
	    relations_header(inreto_id)
	end select
	
	sql    = "select id,name,'template' as template from correspondence where reflects='" & inreto & "' and locked = 0"
	fields = fields & "$name:=id;type:=hidden;$"
	fields = fields & "$name:=name;type:=link;url:=../correspondence/correspondence.asp?inreto=" & inreto & "&inreto_id=" & inreto_id & "&templateid=~id~;label:=select_letter;$" 
	fields = fields & "$name:=template;target:=_blank;type:=link;url:=../correspondence/correspondence.asp?inreto=" & inreto & "&inreto_id=" & inreto_id & "&templateid=~id~&verbosemode=true;label:=view_template;$" 	

	
	r_list sql, fields, "name"
%>
<!-- #include file="../../templates/footers/content.asp" -->
