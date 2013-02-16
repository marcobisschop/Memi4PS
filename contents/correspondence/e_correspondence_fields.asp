<!-- #include file="../../templates/headers/content.asp" -->
<%
	dim recordid, rs, sql, tablename
	
	viewstate = viewstate_value("viewstate")
	recordid  = viewstate_value("id")
	tablename = "correspondence_fields"
		
	select case lcase(viewstate)
	case "view"
		sql = "select * from [" & tablename & "] where id = " & recordid
		set rs = getrecordset(sql,false)
	case "edit","save"
		sql = "select * from [" & tablename & "] where id = " & recordid
		set rs = getrecordset(sql,false)
	case "new","savenew"
		sql = "select * from [" & tablename & "] where id = -1"
		set rs = getrecordset(sql,false)
		rs.addnew
		sec_setsecurityinfo (rs)
	case else
		response.Write "invalid viewstate !!"
		response.end
	end select
	
	if viewstate = "save" or viewstate = "savenew" then	
		if ispostback() then
			if not v_valid("^\w",true,fieldvalue(rs,"field")) then v_addformerror "field"
			if not v_valid("^\w",true,fieldvalue(rs,"value")) then v_addformerror "value"
			if errorcount = 0 then 
					viewstate = "update"
			end if
		end if		
	end if
	
	if viewstate = "update" then 
		save_rs rs
		recordid = rs.fields("id")		
		viewstate = "view"
		response.Redirect "l_correspondence_fields.asp"
	end if
	
	if viewstate="edit" then viewstate = "save"
	if viewstate="new" then viewstate = "savenew"
	
	function save_rs(rs)
		with rs
			.fields("field") = fieldvalue(rs,"field")
			.fields("value") = fieldvalue(rs,"value")
		end with
		sec_setsecurityinfo rs 
		putrecordset rs 
	end function
	
	f_header ("Veld")
	f_form_hdr()
%>
<table style="" cellpadding=0 cellspacing=0 ID="Table1">
	<tr>
		<td valign="top">
			<table style="" ID="Table2">
				<%
					f_textbox rs,"Veldnaam","field","100%"
					f_textarea rs,"Veldwaarde","value","100%","100"
				%>
			</table>
		</td>
	</tr>
	
</table>
<%
	f_form_ftr()
%>
<!-- #include file="../../templates/footers/content.asp" -->