<!-- #include file="../../templates/headers/content.asp" -->
<%
	dim recordid, rs, sql, tablename
	
	viewstate = viewstate_value("viewstate")
	recordid  = viewstate_value("dsc_pk")
	tablename = "disclaimer"
	
	select case lcase(viewstate)
	case "view"
		sql = "select * from [" & tablename & "] where dsc_pk = " & recordid
		set rs = getrecordset(sql,false)
	case "edit","save"
		sql = "select * from [" & tablename & "] where dsc_pk = " & recordid
		set rs = getrecordset(sql,false)
	case "new","savenew"
		sql = "select * from [" & tablename & "] where dsc_pk = -1"
		set rs = getrecordset(sql,false)
		rs.addnew
		sec_setsecurityinfo (rs)
	case else
		response.Write "invalid viewstate !!"
		response.end
	end select
	
	if viewstate = "save" or viewstate = "savenew" then	
		if ispostback() then
			if not v_valid("^\w+",true,fieldvalue(rs,"dsc_name")) then v_addformerror "dsc_name"
			if errorcount = 0 then 
					viewstate = "update"
			end if
		end if		
	end if
	
	if viewstate = "update" then 
		save_rs rs
		recordid = rs.fields("dsc_pk")		
		viewstate = "view"
		'response.Redirect refurl
	end if
	
	if viewstate="edit" then viewstate = "save"
	if viewstate="new" then viewstate = "savenew"
	
	function save_rs(byref rs)
		with rs
			.fields("dsc_name") = fieldvalue(rs,"dsc_name")			
			.fields("dsc_body") = "" & fieldvalue(rs,"dsc_body") & ""
			.fields("dsc_available") = checkboxvalue(fieldvalue(rs,"dsc_available"))			
		end with
		'sec_setsecurityinfo rs 
		putrecordset rs 
	end function
	
	f_header rs.fields("dsc_name")
	f_form_hdr()
	
%>
<input type="hidden" id="dsc_pk" name="dsc_pk" value="<%=recordid %>" />
<table style="" cellpadding=0 cellspacing=0 ID="Table1">
	<tr>
		<td valign="top">
			<table style="" ID="Table2">
				<%
					f_textbox rs,"dsc_name","dsc_name","300"
					f_htmlarea rs,"dsc_body","dsc_body","500px", "500px"
					f_checkbox rs,"dsc_available","dsc_available"
				%>
			</table>
		</td>
	</tr>
</table>
<%
f_form_ftr()
%>
<!-- #include file="../../templates/footers/content.asp" -->
