<!-- #include file="../../templates/headers/content.asp" -->
<!-- #include file="functions.asp" -->
<%
	dim recordid, rs, sql, tablename
	
	viewstate = viewstate_value("viewstate")
	myLetter = viewstate_value("myLetter")
	page = viewstate_value("page")
	recordid  = viewstate_value("id")
	keuzen_id  = viewstate_value("keuzen_id")
	
	tablename = "kosten"
	
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
			if not v_valid("^\w+",true,fieldvalue(rs,"spebes")) then v_addformerror "spebes"
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
			.fields("spebes") = fieldvalue(rs,"spebes")
			.fields("aantal") = fieldvalue(rs,"aantal")
			.fields("eenhei_id") = fieldvalue(rs,"eenhei_id")
			.fields("bedrag") = convertvalue(fieldvalue(rs,"bedrag"))
			.fields("stabuh_id") = fieldvalue(rs,"stabuh_id")
			.fields("norm") = convertvalue(fieldvalue(rs,"norm"))
			.fields("materiaal") = convertvalue(fieldvalue(rs,"materiaal"))
			.fields("materieel") = convertvalue(fieldvalue(rs,"materieel"))
			.fields("onderaan") = convertvalue(fieldvalue(rs,"onderaan"))
		end with
		sec_setsecurityinfo rs 
		putrecordset rs 
	end function
	
	
	keuzen_header keuzen_id
	f_form_hdr()
	f_hidden "page"
%>

<table style="" cellpadding=0 cellspacing=0 ID="Table1">
	<tr>
		<td valign="top">
			<table style="" ID="Table2">
				<%
					f_textbox rs,"spebes","spebes","500"
					f_textbox rs,"aantal","aantal","70"
					f_listbox rs,"eenhei_id", "eenhei_id", "select id, eennaa from eenhei order by eennaa", "id", "eennaa", "80", ""
					f_textbox rs,"norm","norm","80"
				    f_textbox rs,"materiaal","materiaal","80"
				    f_textbox rs,"materieel","materieel","80"
				    f_textbox rs,"onderaan","onderaan","80"
				    
					f_listbox rs,"stabuh_id", "stabuh_id", "select id, hoocod +' - '+hoobes as hoobes from stabuh order by hoocod", "id", "hoobes", "400", ""
					
				%>
			</table>
		</td>
	</tr>
</table>	
<%
f_form_ftr()
%>
<!-- #include file="../../templates/footers/content.asp" -->
