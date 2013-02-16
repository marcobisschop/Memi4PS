<!-- #include file="../../templates/headers/content.asp" -->
<%
	dim recordid, rs, sql, tablename, application_id
	
	viewstate = viewstate_value("viewstate")
	recordid  = viewstate_value("id")
	application_id  = viewstate_value("application_id")
	parentid = viewstate_value("parentid")
	tablename = "sec_menus"
	
	select case lcase(viewstate)
	case "view"
		sql = "select * from [" & tablename & "] where id = " & recordid
		set rs = getrecordset(sql,false)
	case "edit","save"
		sql = "select * from [" & tablename & "] where id = " & recordid
		set rs = getrecordset(sql,false)
		parentid = rs.fields("parentid")
	case "new","savenew"
		sql = "select * from [" & tablename & "] where id = -1"
		set rs = getrecordset(sql,false)
		
		rs.addnew
		rs.fields("sec_applications_id") = application_id
		sec_setsecurityinfo (rs)
	case else
		response.Write "invalid viewstate !!"
		response.end
	end select
	
	if viewstate = "save" or viewstate = "savenew" then	
		if ispostback() then
			if not v_valid("^\w",true,fieldvalue(rs,"name")) then v_addformerror "name"
			if not v_valid("^\d+$",true,fieldvalue(rs,"order")) then v_addformerror "order"
			if errorcount = 0 then 
					viewstate = "update"
			end if
		end if		
	end if
	
	if viewstate = "update" then 
		save_rs rs
		recordid = rs.fields("id")		
		viewstate = "view"
		response.Redirect "l_sec_menus.asp?application_id=" & rs.fields("sec_applications_id")
	end if
	
	if viewstate="edit" then viewstate = "save"
	if viewstate="new" then viewstate = "savenew"
	
	function save_rs(rs)
		with rs
			.fields("name") = fieldvalue(rs,"name")
			.fields("href") = fieldvalue(rs,"href")
			.fields("parentid") = fieldvalue(rs,"parentid")
			if isnumeric(fieldvalue(rs,"application_id")) then .fields("sec_applications_id") = fieldvalue(rs,"application_id")
			.fields("target") = fieldvalue(rs,"target")			
			.fields("order") = fieldvalue(rs,"order")			
			.fields("enabled") = checkboxvalue(fieldvalue(rs,"enabled"))
			if .fields("image") = "" then
			    .fields("image") = vbnull		
			else
			    .fields("image") = fieldvalue(rs,"image")		
			end if
		end with
		sec_setsecurityinfo rs 
		putrecordset rs 
	end function
	
	f_header rs.fields("name")
	f_form_hdr()
	
%>
<input type="hidden" id="application_id" name="application_id" value="<%=application_id %>" />
<table style="" cellpadding=0 cellspacing=0 ID="Table1">
	<tr>
		<td valign="top">
			<table style="" ID="Table2">
				<%
					f_textbox rs,"name","name","300"
					f_textbox rs,"href","href","300"
					f_listbox rs,"parentmenu","parentid","select id,name from sec_menus where parentid <=0 and sec_applications_id=" & rs.fields("sec_applications_id") & " order by name","id","name","300",""
					f_listbox rs,"target","target","select name, value from variables where [group]='targets' order by name","value","name","100",""
					f_textbox rs,"image","image","300"				
					f_textbox rs,"order","order","40"				
					f_checkbox rs,"enabled","enabled"	
				%>
			</table>
		</td>
	</tr>
</table>
<%
f_form_ftr()
%>
<!-- #include file="../../templates/footers/content.asp" -->
