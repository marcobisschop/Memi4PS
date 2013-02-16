<!-- #include file="../../templates/headers/content.asp" -->
<%
	dim recordid, rs, sql, tablename
	
	viewstate = viewstate_value("viewstate")
	myLetter = viewstate_value("myLetter")
	recordid  = viewstate_value("id")
	tablename = "institutes"
	
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
			if not v_valid("^\w",true,fieldvalue(rs,"name")) then v_addformerror "name"
			if not v_valid("^\w",true,fieldvalue(rs,"code")) then v_addformerror "code"
			if errorcount = 0 then 
					viewstate = "update"
			end if
		end if		
	end if
	
	if viewstate = "update" then 
		save_rs rs
		recordid = rs.fields("id")		
		viewstate = "view"
		response.Redirect viewstate_value("REFURL")
	end if
	
	if viewstate="edit" then viewstate = "save"
	if viewstate="new" then viewstate = "savenew"
	
	function save_rs(rs)
		with rs
			.fields("name") = fieldvalue(rs,"name")
			.fields("code") = fieldvalue(rs,"code")
		end with
		sec_setsecurityinfo rs 
		putrecordset rs 
	end function
	
	f_header rs.fields("name")
	f_form_hdr()
%>
<table style="" cellpadding=0 cellspacing=0 ID="Table1">
	<tr>
		<td valign="top">
			<table style="" ID="Table2">
				<%
					f_textbox rs,"name","name","300"
					f_textbox rs,"code","code","300"
				%>
			</table>
		</td>
	</tr>
</table>
<%
f_form_ftr()
%>
<!-- #include file="../../templates/footers/content.asp" -->
