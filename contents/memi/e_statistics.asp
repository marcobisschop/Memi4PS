<!-- #include file="../../templates/headers/content.asp" -->
<!-- #include file="functions.asp" -->
<%
	dim recordid
	
	viewstate = viewstate_value("viewstate")
	recordid  = viewstate_value("id")
		
	keuzen_header (recordid)	
	'r_notes "", "keuzen", recordid
%>
Statistieken
<!-- #include file="../../templates/footers/content.asp" -->
