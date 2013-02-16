<!-- #include file="../templates/headers/content.asp" -->
<%
	dim recordid, rs, sql, tablename
	
	viewstate = viewstate_value("viewstate")
	recordid  = viewstate_value("id")
	inreto = viewstate_value("inreto")
	inreto_id = viewstate_value("inreto_id")
	
	
	intro = viewstate_value("intro")	
	
	tablename = "notes"
		
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
	case else
		response.Write "invalid viewstate !!"
		response.end
	end select
	
	if viewstate = "save" or viewstate = "savenew" then	
		if ispostback() then
			if not v_valid("^\w+",true,fieldvalue(rs,"subject")) then v_addformerror "subject"
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
			.fields("subject") = fieldvalue(rs,"subject")
			if len(intro)>0 then
			    .fields("body") = "<div class='notes_intro'>" & intro & "<div>" & fieldvalue(rs,"body")
			else
			    .fields("body") = fieldvalue(rs,"body")
			end if 
		end with
		sec_setsecurityinfo rs 
		putrecordset rs 
	end function

	f_form_hdr()
	f_hidden "inreto"
	f_hidden "inreto_id"
	f_hidden "intro"
%>
<table style="" cellpadding="0" cellspacing="0" ID="Table1">
	<tr>
		<td valign="top">
			<table style="" ID="Table2">
				<%
					f_textbox rs,"notes_subject","subject","100%"
                    f_htmlarea rs,"notes_body","body","100%","300"
				%>
			</table>
		</td>
	</tr>
</table>
<%
	f_form_ftr()
%>
</form> 
<!-- #include file="../templates/footers/content.asp" -->
