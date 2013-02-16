<!-- #include file="../../templates/headers/content.asp" -->
<%
	dim recordid, rs, sql, tablename
	
	viewstate = viewstate_value("viewstate")
	recordid  = viewstate_value("id")
	tablename = "sec_users"
		
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
		if not v_valid("^\w",true,fieldvalue(rs,"fullname")) then v_addformerror "fullname"
		if not v_valid("^\w",true,fieldvalue(rs,"username")) then v_addformerror "username"
		if not v_valid("^\w",true,fieldvalue(rs,"password")) then v_addformerror "password"
		if not v_valid(isvalidemail,true,fieldvalue(rs,"email")) then v_addformerror "email"
		
		
		if not v_valid("^\d+$",true,fieldvalue(rs,"roleid")) then v_addformerror "roleid"
			if errorcount = 0 then 
					viewstate = "update"
			end if
		end if		
	end if
	
	if viewstate = "update" then 
		save_rs rs
		recordid = rs.fields("id")		
		viewstate = "view"
		response.Redirect "l_sec_users.asp"
	end if
	
	if viewstate="edit" then viewstate = "save"
	if viewstate="new" then viewstate = "savenew"
	
	function save_rs(rs)
		with rs
			.fields("fullname") = fieldvalue(rs,"fullname")
			'.fields("naammettitel") = fieldvalue(rs,"naammettitel")
			'.fields("naamzondertitel") = fieldvalue(rs,"naamzondertitel")
			.fields("username") = fieldvalue(rs,"username")
			.fields("password") = fieldvalue(rs,"password")
			.fields("phone1") = fieldvalue(rs,"phone1")
			.fields("phone2") = fieldvalue(rs,"phone2")
			.fields("email") = fieldvalue(rs,"email")
			.fields("locked") = checkboxvalue(fieldvalue(rs,"locked"))
			.fields("readonly") = checkboxvalue(fieldvalue(rs,"readonly"))
			.fields("roleid") = fieldvalue(rs,"roleid")
		end with
		sec_setsecurityinfo rs 
		putrecordset rs 
	end function

	'Hier wordt de titel van het formulier bepaalt
	f_header (rs.fields("fullname"))	
	f_form_hdr()
%>
<table style="" cellpadding="0" cellspacing="0" ID="Table1">
	<tr>
		<td valign="top">
			<table style="" ID="Table2">
				<%
					f_textbox rs,"Fullname","fullname","300"
					f_textbox rs,"Username","username","120"
					f_textbox rs,"Password","password","120"
					f_textbox rs,"Phone","phone1","120"
					f_textbox rs,"Mobile","phone2","120"
					f_emailbox rs,"Email", "email", "300"
				%>
			</table>
		</td>
		<td valign="top">
			<table style="" ID="Table3">
				<%
					f_listbox rs, "userrole", "roleid", "select id,name from sec_roles order by name", "id", "name", 150, ""
					f_checkbox rs, "Locked out", "locked"
					f_checkbox rs, "user_readonly", "readonly"
				%>
			</table>
		</td>
	</tr>
</table>
<hr>
<table style="" cellpadding="0" cellspacing="0" ID="Table4">
	<tr>
		<td valign="top">
			<table style="" ID="Table5">
				<%
					'f_textbox rs,"In brief met titel","NAAMMETTITEL","300"
					'f_textbox rs,"In brief zonder titel","NAAMZONDERTITEL","300"
				%>
			</table>
		</td>
		<td valign="top">&nbsp;</td>
	</tr>
</table>
<%
	f_form_ftr()
%>
</form> 
<!-- #include file="../../templates/footers/content.asp" -->
