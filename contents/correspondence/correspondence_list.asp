<!-- #include file="header.asp" -->
<%
	Dim sql, fields, inreto, inreto_id
	inreto = viewstate_value("inreto")
	inreto_id = viewstate_value("inreto_id")
	
	sql    = "select id,name,'template' as template "
	
	dim sqlReltyp, rsReltyp
	sqlReltyp = "select * from reltyp order by typcod"
	set rsReltyp = getrecordset(sqlReltyp,true)
	with rsReltyp
		do until .eof
			sql = sql & ",'" & .fields("typcod") & "' as [" & .fields("typcod") & "]"
			.movenext
		loop
	end with
	sql = sql & " from correspondence where locked=0"
	with rsReltyp
		.movefirst
		do until .eof
			fields = fields & "$name:=" & .fields("typcod") & ";type:=link;url:=correspondence_relation.asp?reltype=" & .fields("typcod") & "&inreto=" & inreto & "&inreto_id=" & inreto_id & "&templateid=~id~;label:=;$" 
			.movenext
		loop
	end with
	set rsReltyp = nothing
	
	fields = fields & "$name:=id;type:=hidden;$"
	fields = fields & "$name:=name;type:=link;url:=correspondence.asp?inreto=" & inreto & "&inreto_id=" & inreto_id & "&templateid=~id~;label:=Selecteer brief;$" 
	'fields = fields & "$name:=notaris;type:=link;url:=correspondence_relation.asp?reltype=N&inreto=" & inreto & "&inreto_id=" & inreto_id & "&templateid=~id~;label:=;$" 
	IF SEC_ROLENAME = "ADMINISTRATOR" THEN
		fields = fields & "$name:=template;type:=link;url:=correspondence.asp?inreto=" & inreto & "&inreto_id=" & inreto_id & "&templateid=~id~&verbosemode=true;label:=Template;$" 	
	ELSE
		fields = fields & "$name:=template;type:=hidden;"
	END IF 
	r_list sql, fields, "name"


%>