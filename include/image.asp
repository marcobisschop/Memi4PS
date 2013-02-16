<!-- #include file="../templates/headers/content.asp" -->
<%
	dim rs,id,table
	'on error resume next
	inreto_id = request.querystring ("inreto_id")
	table = request.querystring ("table")
	inreto = request.querystring ("inreto")
	
	if inreto="dosarc"then
	    sql = "select arcnaa, arccon, arcdat from " & table & " where id = " & inreto_id
	else
	    sql = "select arcnaa, arccon, arcdat from " & table & " where inreto = '" & inreto & "' and inreto_id = " & inreto_id
	end if
	
	'response.Write sql
	'response.end
	set rs = getrecordset (sql,true)
	response.clear 
	with rs
		response.contenttype = .fields("arccon")
		response.binarywrite .fields("arcdat")
		'.close
	end with
	set rs = nothing	
	response.end 
%>