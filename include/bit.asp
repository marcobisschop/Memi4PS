<!-- #include file="../templates/headers/content.asp" -->
<%
	
	' Deze pagina zet een waarde van true naar false en andersom
	
	dim class_, field_, id
	dim sql_exec
	dim rs
	
	class_		= viewstate_value("class")
	field_			= viewstate_value("field")
	id			= viewstate_value("id")
	
	sql_exec = "update [" & class_ & "] set [" & field_ & "] = abs([" & field_ & "] -1) where id=" & id
	executesql sql_exec
	response.Redirect refurl 
	
%>	
<!-- #include file="../templates/footers/include.asp" -->

