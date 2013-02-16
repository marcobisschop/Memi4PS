<!-- #include file="../../templates/headers/content.asp" -->
<!-- #include file="functions.asp" -->
<%
	dim recordid, rs, sql, tablename
	
	viewstate = viewstate_value("viewstate")
	recordid  = viewstate_value("id")
	inreto  = viewstate_value("inreto")
	inreto_id  = viewstate_value("inreto_id")
	tablename = "docum"
		
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
		rs.fields("inreto") = inreto
		rs.fields("inreto_id") = inreto_id
		sec_setsecurityinfo (rs)
	case else
		response.Write "invalid viewstate !!"
		response.end
	end select
	
	if viewstate = "save" or viewstate = "savenew" then	
		if ispostback() then
			'deze if functie plaatsen
			if not v_valid("^\w",true,fieldvalue(rs,"docnaa")) then v_addformerror "docnaa"
			if not v_valid("^\w",true,fieldvalue(rs,"docnum")) then v_addformerror "docnum"
			if not v_valid("^\w",false,fieldvalue(rs,"docbes")) then v_addformerror "docbes"
			if errorcount = 0 then 
				viewstate = "update"
			end if
		end if		
	end if
	
	if viewstate = "update" then 
		save_rs rs
		recordid = rs.fields("id")		
		viewstate = "view"
		response.Redirect refurl
	end if
	
	if viewstate="edit" then viewstate = "save"
	if viewstate="new" then viewstate = "savenew"
	
	function save_rs(rs)
		with rs
			.fields("docnaa") = fieldvalue(rs,"docnaa")
			.fields("docnum") = fieldvalue(rs,"docnum")
			.fields("docbes") = fieldvalue(rs,"docbes")
			.fields("available") = checkboxvalue(fieldvalue(rs,"available"))		
			.fields("stuurgroep") = checkboxvalue(fieldvalue(rs,"stuurgroep"))		
		end with
		sec_setsecurityinfo rs 
		putrecordset rs 
	end function
	
	header recordid
	f_form_hdr()
%>
<input type="hidden" id="inreto" name="inreto" value="<%=inreto %>" />
<input type="hidden" id="inreto_id" name="inreto_id" value="<%=inreto_id %>" />
<table style="" cellpadding=0 cellspacing=0 ID="Table1">
	<tr>
		<td valign="top" style="80%">
			<table style="width:100%" ID="Table2">
				<% 
					f_textbox rs,"docnaa","docnaa","100%"
					f_textarea rs,"docbes","docbes","100%","120"
					f_textbox rs,"docnum", "docnum", "200"
					f_checkbox rs,"available","available"
					f_checkbox rs,"stuurgroep","stuurgroep"
	    		 %>
			</table>
		</td>	
	</tr>
</table>
<%
	f_form_ftr()    
%>
<!-- #include file="../../templates/footers/content.asp" -->
