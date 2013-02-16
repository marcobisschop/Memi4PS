<!-- #include file="../../templates/headers/content.asp" -->
<!-- #include file="functions.asp" -->
<%
	dim recordid	
	viewstate = viewstate_value("viewstate")
	recordid  = viewstate_value("id")		
	header recordid
	r_notes "", "docum", recordid
%>
<!-- #include file="../../templates/footers/content.asp" -->
