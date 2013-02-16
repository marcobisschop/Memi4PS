<!-- #include file="../../templates/headers/content.asp" -->
<!-- #include file="functions.asp" -->
<%
	dim recordid
	
	viewstate = viewstate_value("viewstate")
	recordid  = viewstate_value("id")
		
	projec_id = DBLookup ("boutyp", "id", recordid, "projec_id")
	boutyp_header recordid, projec_id

	r_notes "", "boutyp", recordid
%>
<!-- #include file="../../templates/footers/content.asp" -->
