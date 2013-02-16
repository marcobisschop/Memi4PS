<!-- #include file="../../templates/headers/content.asp" -->
<!-- #include file="functions.asp" -->
<%
	dim recordid, rs, sql, tablename
	
	viewstate = viewstate_value("viewstate")
	recordid  = viewstate_value("id")
	tablename = "relations"
		
	relations_header (recordid)	
	r_notes "", "relations", recordid
%>
<!-- #include file="../../templates/footers/content.asp" -->
