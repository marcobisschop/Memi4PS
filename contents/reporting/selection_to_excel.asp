<!-- #include file="../../templates/headers/content.asp" -->
<!-- #include file="excel.asp" -->
<DIV STYLE="MARGIN:15PX;WIDTH:100%;BORDER:1PX SOLID #21497A;">
<%
	Dim ids, obj
		
	ids = viewstate_value("inreto_id")
	obj = viewstate_value("inreto")
	
	dim rs, sql
	
	select case lcase(obj)
	case "deelnemers"
		sql = "select * from vw_deelnemers where relati_id in (" & ids & ")"
		'set rs = getrecordset(sql, true)
	case "relations"
		sql = "select * from vw_relations where id in (" & ids & ")"
		'set rs = getrecordset(sql, true)
	case "relations_contacts"
		sql = "select * from vw_relations_contacts2 where contacts_id in (" & ids & ")"
		'set rs = getrecordset(sql, true)
	case else
	end select
	
	toExcel2 (sql)
	
%>	
<!-- #include file="../../templates/footers/content.asp" -->
