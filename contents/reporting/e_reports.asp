<!-- #include file="../../templates/headers/content.asp" -->
<%
	dim recordid, rs, sql, tablename, ageState
	
	viewstate = viewstate_value("viewstate")
	recordid  = viewstate_value("id")
	tablename = "rappor"
		
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
		'rs.fields("relati_id") = relati_id
		sec_setsecurityinfo (rs)
	case else
		response.Write "invalid viewstate !!"
		response.end
	end select
	
	relati_id  = fieldvalue(rs,"relati_id")
	
	if viewstate = "save" or viewstate = "savenew" then	
		if ispostback() then
			If Not v_valid("^\w",True,fieldvalue(rs,"rapnaa")) then v_addformerror "rapnaa"
			If Not v_valid("^\w",True,fieldvalue(rs,"rapgro")) then v_addformerror "rapgro"
			If Not v_valid("^\w",True,fieldvalue(rs,"rapsql")) then v_addformerror "rapsql"			
			if errorcount = 0 then 
					viewstate = "update"
			end if
		end if		
	end if
	
	if viewstate = "update" then 
		save_rs rs
		recordid = rs.fields("id")		
		viewstate = "view"
		response.Redirect "le_reports.asp?rapgro=" & rs.fields("rapgro")
	end if
	
	if viewstate="edit" then viewstate = "save"
	if viewstate="new" then viewstate = "savenew"
	
	function save_rs(rs)
		with rs
			.fields("rapnaa") = fieldvalue(rs,"rapnaa")
			.fields("rapgro") = fieldvalue(rs,"rapgro")
			.fields("inreto") = fieldvalue(rs,"inreto")
			.fields("rapbes") = fieldvalue(rs,"rapbes")
			.fields("rapsql") = fieldvalue(rs,"rapsql")
			.fields("links") = fieldvalue(rs,"links")
			.fields("zichtb") = checkboxvalue(fieldvalue(rs,"zichtb"))
			.fields("zoekme") = checkboxvalue(fieldvalue(rs,"zoekme"))
			.fields("nolabel") = checkboxvalue(fieldvalue(rs,"nolabel"))
		end with
		sec_setsecurityinfo rs 
		putrecordset rs 
	end function
	
	f_header getlabel("hdr_report")
	f_form_hdr()
%>
<table style="" cellpadding=0 cellspacing=0 ID="Table1">
	<tr>
		<td valign="top">
			<table style="" ID="Table2">
				<%
					f_textbox rs,"Report","rapnaa","100%"
					f_textbox rs,"Group","rapgro","200"
					f_textbox rs,"Correspondence_inreto","inreto","200"
					f_textarea rs, "Description", "rapbes", "100%", 60
					f_textarea rs, "Query", "rapsql", "100%", 300
					f_textarea rs, "Links", "links", "100%", 300
					f_CheckBox rs, "Visible","zichtb"
					f_CheckBox rs, "Searchmethod","zoekme"
					f_CheckBox rs, "nolabel","nolabel"
				%>
			</table>
		</td>
	</tr>	
</table>
<%
	f_form_ftr()
%>
<!-- #include file="../../templates/footers/content.asp" -->