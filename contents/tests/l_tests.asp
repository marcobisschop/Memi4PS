<!-- #include file="../../templates/headers/content.asp" -->
<%
	f_header getlabel("hdr_tests")
	dim sql, fields, orderby, rs
	
	sql = "select distinct name, value from variables where [group]='toetsen_type' order by name"
	set rs = getrecordset(sql, true)
	with rs
		response.Write "<div style='width:100%' align=right>"
		do until .eof
			response.Write "<a href='?tests_type=" & .fields("value") &  "'>" & .fields("name") & "</a>&nbsp;"
			.movenext
		loop
		response.Write "</div>"
	end with
	set rs = nothing
%>
<hr>
<%	
	dim tests_type, years_id
	tests_type = viewstate_value("tests_type")	
	if len(tests_type)=0 then tests_type="HF"
	sql = "select id,year from years where id in (select years_id from toetsen)"
	set rs = getrecordset(sql, true)
	with rs
		response.Write "<div style='width:100%' align=right>"
		do until .eof
			response.Write "<a href='?tests_type=" & tests_type & "&years_id=" & .fields("id") &  "'>" & .fields("year") & "</a>&nbsp;"
			.movenext
		loop
		response.Write "</div>"
	end with
	set rs = nothing
%>
<hr>
<%		
	years_id = viewstate_value("years_id")
	if len(years_id)=0 then years_id = 7
	if len(tests_type)>0 then
		sql = "select id,codetot,hertoets,maxects from toetsen where years_id=" & years_id & " and toetsen_type='" & tests_type & "'"
		fields = ""
		fields = fields & "$name:=id;type:=hidden;$"
		fields = fields & "$name:=hertoets;type:=text;$"
		fields = fields & "$name:=maxects;type:=text;$"
		fields = fields & "$name:=codetot;type:=link;url:=e_tests.asp?viewstate=edit&id=~id~;$"
		orderby = ""
		r_list sql, fields, orderby
	end if
%>
<!-- #include file="../../templates/footers/content.asp" -->
