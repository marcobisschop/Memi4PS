<!-- #include file="../../templates/headers/content.asp" -->
<!-- #include file="functions.asp" -->
<%
	dim recordid
	
	viewstate = viewstate_value("viewstate")
	recordid  = viewstate_value("id")
		
	projects_header (recordid)	
	r_notes "", "projec", recordid
%>
<!-- #include file="../../templates/footers/content.asp" -->
