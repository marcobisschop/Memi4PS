<!-- #include file="../../templates/headers/content.asp" -->
<!-- #include file="../projects/functions.asp" -->
<!-- #include file="../boutyp/functions.asp" -->
<!-- #include file="../bounum/functions.asp" -->
<%
	

	dim rs, sql, myLetter, myLetters, provin_id
    	
	dim page_size, page	
	page = viewstate_value ("page")
	page_size = viewstate_value ("page_size")
	factur_id = viewstate_value ("factur_id")
	bounum_id = viewstate_value("bounum_id")

	bounum_header bounum_id
	
	f_header getlabel("Facturatie")
	
%>	
....
<!-- #include file="../../templates/footers/content.asp" -->
