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
	projec_id = viewstate_value("projec_id")

	projects_header projec_id
	
	f_header getlabel("factureren")
	
	rw "<h1>" & dblookup("factur","id",factur_id,"facnaa") & "</h1>"
	
	
	rowHeader = "<table>"
	rowHeader = rowHeader & "<tr><td>##BNR##</td><tr>"
	rowFooter = "</table>"
	
	rowTemplate = "<tr><td><input type='checkbox' name='bounum_id' value=$id$>&nbsp;$extnum$</td></tr>"
	
	
	sql = "select * from bounum where projec_id = " & projec_id
	set rs = getrecordset(sql, true)
	with rs
	    rw rowHeader
	    do until .eof
	        myTemplate = rowTemplate
	        TemplateParseRS myTemplate, RS
	        rw myTemplate
	        .movenext
	    loop
	    rw rowFooter
	end with	
	set rs = nothing
	
%>	
.....
<!-- #include file="../../templates/footers/content.asp" -->
