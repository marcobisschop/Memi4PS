<!-- #include file="../../templates/headers/content.asp" -->
<%
	dim recordid, rs, sql, tablename
	
	viewstate = viewstate_value("viewstate")
	recordid  = viewstate_value("id")
	tablename = "relsoo"
	
	if viewstate_value("action") = "menu" then
		sql = "select * from sec_rolemenus where relsoo_id=" & fieldvalue(rs,"id") & " and menuid=" & fieldvalue(rs,"menuid")
		set rs = getrecordset(sql,false)
		with rs
			if fieldvalue(rs,"checked") = "true" then
				.addnew
				.fields("relsoo_id") = fieldvalue(rs,"id")
				.fields("menuid") = fieldvalue(rs,"menuid")
			else
				.delete
			end if
		end with
		if rs.recordcount > 0 then sec_setsecurityinfo rs
		putrecordset rs
		set rs = nothing
	end if
		
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
			if not v_valid("^\w",true,fieldvalue(rs,"soonaa")) then v_addformerror "soonaa"
			if not v_valid("^\w",true,fieldvalue(rs,"soobes")) then v_addformerror "soobes"
			if errorcount = 0 then 
					viewstate = "update"
			end if
		end if		
	end if
	
	if viewstate = "update" then 
		save_rs rs
		recordid = rs.fields("id")		
		viewstate = "view"
		response.Redirect "l_sec_roles.asp"
	end if
	
	if viewstate="edit" then viewstate = "save"
	if viewstate="new" then viewstate = "savenew"
	
	function save_rs(rs)
		with rs
			.fields("soonaa") = fieldvalue(rs,"soonaa")
			.fields("soobes") = fieldvalue(rs,"soobes")
			
		end with
		sec_setsecurityinfo rs 
		putrecordset rs 
	end function
	
	f_header rs.fields("soonaa")
	f_form_hdr()
%>
<table style="" cellpadding=0 cellspacing=0 ID="Table1">
	<tr>
		<td valign="top">
			<table style="" ID="Table2">
				<%
					f_textbox rs,"soonaa","soonaa","300"
					f_textarea rs,"soobes","soobes","100%",500
					'f_checkbox rs,"GOD","GOD"
				%>
			</table>
		</td>
	</tr>
</table>
<%
f_form_ftr()
%>
<hr>
<form id="rolemenu" name="rolemenu" action="e_sec_roles.asp?viewstate=edit&id=<%=recordid%>&action=menu" method="post" ENCTYPE="multipart/form-data">
	<input type="hidden" id="postback" name="postback" value="change"> 
	<input type="hidden" id="viewstate" name="viewstate" value="edit">
	<input type="hidden" id="refurl" name="refurl" value="<%=REFURL%>">
	<input type="hidden" id="roleid" name="roleid" value="<%=recordid%>">
	<input type="hidden" id="menuid" name="menuid" value="<%=menuid%>">
	<input type="hidden" id="checked" name="checked" value="">
</form>
<SCRIPT LANGUAGE=javascript>
<!--
	function toggle(roleid, menuid, th) {
		document.all.roleid.value = roleid;
		document.all.menuid.value = menuid;
		document.all.checked.value = th.checked;
		document.all.rolemenu.submit();
	}
//-->
</SCRIPT>

<%
	f_header "Beschikbare menu opties"

	sql = "select * from sec_menus where parentid<=0 order by sec_applications_id, parentid, [order]"
	set rs = getrecordset(sql,true)
	
	with rs
		if .eof then
		else
			%>
			<table><tr>
			<%
				r_menu rs,0
			%>
			</table>
			<%
		end if
	end with
	
	function r_menu(rs,level)
		dim rssub
		if not rs.eof then
			%>
			<tr>
			<%
				for i = 1 to level
				%>
					<td colspan align="right">&nbsp;</td>
				<%				
				next
				%>
					<td colspan>
					<input <%=checked(recordid, rs.fields("id"))%> onclick="javascript:toggle(<%=recordid%>,<%=rs.fields("id")%>,this)" type="checkbox"><%=rs.fields("name")%>
					</td>
				</tr>
				<%				
				set rssub = getrecordset("select * from sec_menus where parentid=" & rs.fields("id") & "order by [order]",true)
				r_menu rssub,level + 1
				parentid = rs.fields("parentid")
				
				appid = rs.fields("sec_applications_id")
			rs.movenext
			if rs.eof then
			%>
				<tr>
			<%
			for i = 1 to level
			%>
				<td colspan align="right">&nbsp;</td>
			<%				
			next
			%>
			</tr>
			<%
			end if
			
			r_menu rs,level			
		end if
		set rssub = nothing
	end function
	
	function checked(roleid,menuid)
		dim rs
		set rs = getrecordset("select * from sec_rolemenus where relsoo_id=" & roleid & " and menuid=" & menuid,true)
		if rs.recordcount > 0 then
			checked = "checked"
		else
			checked = ""
		end if
		set rs = nothing
	end function
	
%>
<!-- #include file="../../templates/footers/content.asp" -->
