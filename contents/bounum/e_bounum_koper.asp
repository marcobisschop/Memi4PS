<!-- #include file="../../templates/headers/content.asp" -->
<!-- #include file="functions.asp" -->
<%
	dim recordid, rs, sql, tablename, bounum_id
	
	viewstate = viewstate_value("viewstate")
	recordid  = viewstate_value("id")
	bounum_id = viewstate_value("bounum_id")
	tablename = "relati"
		
		
    select case lcase(viewstate)
	case "view"
		sql = "select *, " & bounum_id & " as bounum_id from [" & tablename & "] where id = " & recordid
		set rs = getrecordset(sql,false)
	case "edit","save"
		sql = "select *, " & bounum_id & " as bounum_id from [" & tablename & "] where id = " & recordid
		set rs = getrecordset(sql,false)
	case "new","savenew"
		sql = "select *, " & bounum_id & " as bounum_id from [" & tablename & "] where id = -1"
		set rs = getrecordset(sql,false)
		rs.addnew
		'rs.fields("bounum_id") = bounum_id
		sec_setsecurityinfo (rs)
	case else
		response.Write "invalid viewstate !!"
		response.end
	end select
	
	if viewstate = "save" or viewstate = "savenew" then	
		if ispostback() then
			if not v_valid("^\w+",true,fieldvalue(rs,"achter")) then v_addformerror "achter"
	
			if errorcount = 0 then 
					viewstate = "update"
			end if
		end if		
	end if
	
	response.Write formerrors
	
	if viewstate = "update" then 
		save_rs rs
		recordid = rs.fields("id")		
		viewstate = "view"
		' response.Redirect viewstate_value("REFURL")
	end if
	
	if viewstate="edit" then viewstate = "save"
	if viewstate="new" then viewstate = "savenew"
	
	function save_rs(rs)
		with rs
			.fields("voorle") = fieldvalue(rs,"voorle")
			.fields("voorna") = fieldvalue(rs,"voorna")
			.fields("tussen") = fieldvalue(rs,"tussen")
			.fields("achter") = fieldvalue(rs,"achter")
			.fields("aanhef_id") = fieldvalue(rs,"aanhef_id")
			.fields("geslac_gesnaa") = fieldvalue(rs,"geslac_gesnaa")
			
			.fields("adrstr") = fieldvalue(rs,"adrstr")
			.fields("adrnum") = fieldvalue(rs,"adrnum")
			.fields("adrtoe") = fieldvalue(rs,"adrtoe")
			.fields("adrpos") = fieldvalue(rs,"adrpos")
			.fields("adrpla") = fieldvalue(rs,"adrpla")
			.fields("adrlan") = fieldvalue(rs,"adrlan")
			
			.fields("telpri") = fieldvalue(rs,"telpri")
			.fields("telmob") = fieldvalue(rs,"telmob")
			.fields("faxpri") = fieldvalue(rs,"faxpri")
			.fields("emapri") = fieldvalue(rs,"emapri")
			
			.fields("telwer") = fieldvalue(rs,"telwer")
			.fields("faxwer") = fieldvalue(rs,"faxwer")
			.fields("adrema") = fieldvalue(rs,"adrema")			

			.fields("banknr") = fieldvalue(rs,"banknr")			
			.fields("gebdat") = convertdate(fieldvalue(rs,"gebdat"))
		end with
		sec_setsecurityinfo rs 
		putrecordset rs 
	end function

	'Hier wordt de titel van het formulier bepaalt
	bounum_header (bounum_id)	
	f_form_hdr()
	
%>
<input type=hidden id="bounum_id" name="bounum_id" value="<%=bounum_id %>" />

<table style="" cellpadding="0" cellspacing="0" ID="Table1">
	<tr>
		<td valign="top">
			<table style="" ID="Table2">
				<%
    				f_frm_divider(getlabel("algemeen"))
		            f_person rs,"contact_name",""			
					f_address rs,"adres","adr"			
					f_listbox rs,"v_m","geslac_gesnaa","select name, value from variables where [group]='gender' order by name","value","name",100,""	
					f_datebox rs,"gebdat","gebdat","100"
					f_frm_divider(getlabel("prive"))
		            f_textbox rs,"telpri","telpri","200"
					f_textbox rs,"telmob","telmob","200"
					f_textbox rs,"faxpri","faxpri","200"
					f_emailbox rs,"emapri","emapri","200"			
				%>
			</table>
		</td>
		<td valign="top">
		    <table style="" ID="Table3">
				<%
    				f_frm_divider(getlabel("zakelijk"))
		            f_textbox rs,"telwer","telwer","200"
					f_textbox rs,"faxwer","faxwer","200"
					f_emailbox rs,"adrema","adrema","200"			
					f_frm_divider(getlabel("overig"))
		            f_textbox rs,"banknr","banknr","200"					
				%>
			</table>
		</td>
	</tr>
</table>
<%
	f_form_ftr()
%>
</form> 
<!-- #include file="../../templates/footers/content.asp" -->
