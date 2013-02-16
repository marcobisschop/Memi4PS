<!-- #include file="../../templates/headers/content.asp" -->
<!-- #include file="functions.asp" -->
<%
	dim recordid, rs, sql, tablename
	
	viewstate = viewstate_value("viewstate")
	recordid  = viewstate_value("id")
	tablename = "prorel"
		
	select case lcase(viewstate)
	case "view"
		sql = "select * from [" & tablename & "] where id = " & recordid
		set rs = getrecordset(sql,false)
	case "edit","save"
		sql = "select * from [" & tablename & "] where id = " & recordid
		set rs = getrecordset(sql,false)
	case "new","savenew"
		sql = "select * from [" & tablename & "] where id = -1"
		recordid=-1
		set rs = getrecordset(sql,false)
		rs.addnew
		sec_setsecurityinfo (rs)
	case else
		response.Write "invalid viewstate !!"
		response.end
	end select
	
	if viewstate = "save" or viewstate = "savenew" then	
		if ispostback() then
			if errorcount = 0 then 
					viewstate = "update"
			end if
		end if		
	end if
	
	'response.Write formerrors
	
	if viewstate = "update" then 
		save_rs rs
		recordid = rs.fields("id")		
		viewstate = "view"
		response.Redirect refurl
	end if
	
	if viewstate="edit" then viewstate = "save"
	if viewstate="new" then viewstate = "savenew"
	
	function save_rs(rs)
        sql = "select * from [" & tablename & "] where id = " & recordid
	    set rs = getrecordset(sql,false)
        with rs
		    .fields("adrstr") = fieldvalue(rs,"adrstr")
		    .fields("adrnum") = fieldvalue(rs,"adrnum")
		    .fields("adrtoe") = fieldvalue(rs,"adrtoe")
		    .fields("adrpos") = fieldvalue(rs,"adrpos")
		    .fields("adrpla") = fieldvalue(rs,"adrpla")
		    .fields("adrtel") = fieldvalue(rs,"adrtel")
		    .fields("adrfax") = fieldvalue(rs,"adrfax")
		    .fields("adrema") = fieldvalue(rs,"adrema")
	    end with
	    sec_setsecurityinfo rs 
	    putrecordset rs 
	end function

	'Hier wordt de titel van het formulier bepaalt
	projects_header(rs.fields("projec_id"))

	f_form_hdr()
	f_header "Project specifieke contactgegevens:"
%>
<table style="" cellpadding="0" cellspacing="0" ID="Table1">
	<tr>
		<td valign="top">
			<table style="" ID="Table2">
				<%
					f_address rs,"zak_adres","adr"
				%>
			</table>
		</td>
		<td valign="top">
			<table style="" ID="Table3">
				<%
					f_textbox rs,"adrtel","adrtel","200"
					f_textbox rs,"adrfax","adrfax","200"
					f_emailbox rs,"adrema","adrema","200"
				%>
			</table>
		</td>
	</tr>
</table>
<%
	f_form_ftr()
%>
</form> 
<!-- #include file="../../templates/footers/content.asp" -->
