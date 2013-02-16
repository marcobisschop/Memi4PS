<!-- #include file="../templates/headers/content.asp" -->
<%
	
	' Deze pagina zet een waarde van true naar false en andersom
	
	dim class_, field_, id, direction_
	dim sql_exec
	dim rs
	
	class_		= viewstate_value("class")
	field_			= viewstate_value("field")
	id			    = viewstate_value("id")
	direction_	= viewstate_value("direction")
	
	select case direction_
	case "up"
	    sql_exec = "if exists(select id from [" & class_ & "] where [" & field_ & "] < (select [" & field_ & "] from [" & class_ & "] where id=" & id & ")) begin "
	    sql_exec =  sql_exec & " update [" & class_ & "] set [" & field_ & "] = abs([" & field_ & "] +1) where [" & field_ & "] in (select [" & field_ & "]-1 from [" & class_ & "] where id = " & id & ")"
	    sql_exec =  sql_exec & " update [" & class_ & "] set [" & field_ & "] = abs([" & field_ & "] -1) where id=" & id	    
	    sql_exec =  sql_exec & " end "
	case "down"
	    sql_exec = "if exists(select id from [" & class_ & "] where [" & field_ & "] > (select [" & field_ & "] from [" & class_ & "] where id=" & id & ")) begin "
	    sql_exec =  sql_exec & " update [" & class_ & "] set [" & field_ & "] = abs([" & field_ & "] -1) where [" & field_ & "] in (select [" & field_ & "]+1 from [" & class_ & "] where id = " & id & ")"
	    sql_exec =  sql_exec & " update [" & class_ & "] set [" & field_ & "] = abs([" & field_ & "] +1) where id=" & id	    
	    sql_exec =  sql_exec & " end "
	end select
	
	executesql sql_exec
	' response.Write  sql_exec
	' response.end
	response.Redirect refurl 
	
%>	
<!-- #include file="../templates/footers/include.asp" -->

