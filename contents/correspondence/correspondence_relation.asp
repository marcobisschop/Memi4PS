<!-- #include file="header.asp" -->
<%
	Dim sql, fields, inreto, inreto_id
	inreto = viewstate_value("inreto")
	inreto_id = viewstate_value("inreto_id")
	templateid = viewstate_value("templateid")
	reltype = viewstate_value("reltype")
	
	sql = ""
	sql = sql & " select "
	sql = sql & " 	relati.id as relati_id, "
	sql = sql & " 	reltyp.typcod as typcod, "
	sql = sql & " 	relati.bednaa, "
	sql = sql & " 	relati.adres_1, "
	sql = sql & " 	relati.adres_2, "
	sql = sql & " 	relati.adres_3, "
	sql = sql & " 	relati.adres_4, "
	sql = sql & " 	relati.adrtel as telefoon, "
	sql = sql & " 	relati.adrfax as fax "
	sql = sql & " from relati "
	sql = sql & " 	left join reltyp on relati.reltyp_id = reltyp.id " 
	sql = sql & " where reltyp.typcod='" & reltype & "'"

	fields = ""
	fields = fields & "$name:=relati_id;type:=hidden;$"
	fields = fields & "$name:=reltyp_id;type:=hidden;$"
	fields = fields & "$name:=typnaa;type:=hidden;$"
	fields = fields & "$name:=typcod;type:=text;label:=T;align=center;$"
	fields = fields & "$name:=adrtel;type:=text;label:=Tel;$"
	fields = fields & "$name:=adrfax;type:=text;label:=Fax;$"

	fields = fields & "$name:=bednaa;type:=link;url:=correspondence.asp?templateid=" & templateid & "&inreto=" & inreto & "&inreto_id=" & inreto_id & "&relati_id=~relati_id~&;label:=Naam;$" 
	r_list sql, fields, "bednaa"


%>