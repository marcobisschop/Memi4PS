<!-- #include file="../../templates/headers/content.asp" -->
<!-- #include file="functions.asp" -->
<%
	dim recordid
	
	viewstate = viewstate_value("viewstate")
	recordid  = viewstate_value("id")
		
	bounum_header (recordid)	
	r_notes "", "bounum", recordid
%>
<!-- #include file="../../templates/footers/content.asp" -->
