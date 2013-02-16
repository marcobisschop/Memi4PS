<!-- #include file="../../templates/headers/content.asp" -->
<%
	dim sql
	factur_id = viewstate_value ("factur_id")
	projec_id = viewstate_value("projec_id")
    action = viewstate_value("action")
    
    select case lcase(action)
    case "indienen"
        sql = "exec aspFactur_doorvoeren " & projec_id & "," & factur_id
        executesql sql
    case "doorvoeren"
        sql = "update factur_regels set status_id=31 where projec_id=" & projec_id & " and factur_id=" & factur_id
        executesql sql
        'response.end
    end select
    response.redirect REFURL
    'rw sql
%>	
<!-- #include file="../../templates/footers/content.asp" -->
