<!-- #include file="../../templates/headers/content.asp" -->
<!-- #include file="functions.asp" -->
<%
	dim recordid, rs, sql, tablename
	
	viewstate = viewstate_value("viewstate")
	recordid  = viewstate_value("id")
	tablename = "projec"
		
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
			if not v_valid("^\w+",true,fieldvalue(rs,"pronaa")) then v_addformerror "pronaa"
			if not v_valid("^\w+",true,fieldvalue(rs,"pronum")) then v_addformerror "pronum"
			if not v_valid("^\d+",true,fieldvalue(rs,"kavels")) then v_addformerror "kavels"
			if not v_valid("^\d+",true,fieldvalue(rs,"provin_id")) then v_addformerror "provin_id"
			if not v_valid("^\d+",true,fieldvalue(rs,"status_id")) then v_addformerror "status_id"
			if not v_valid("^\d+",true,fieldvalue(rs,"pro_disclaimer_fk")) then v_addformerror "pro_disclaimer_fk"
			if not v_isdate(true,fieldvalue(rs,"startd")) then v_addformerror "startd"
			if not v_isdate(true,fieldvalue(rs,"eindda")) then v_addformerror "eindda"
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
		'response.Redirect viewstate_value("REFURL")
	end if
	
	if viewstate="edit" then viewstate = "save"
	if viewstate="new" then viewstate = "savenew"
	
	function save_rs(rs)
		with rs
			.fields("pronaa") = fieldvalue(rs,"pronaa")
			.fields("pronum") = fieldvalue(rs,"pronum")
			.fields("startd") = datetoiso(fieldvalue(rs,"startd"))
			.fields("eindda") = datetoiso(fieldvalue(rs,"eindda"))	
			.fields("stabou") = datetoiso(fieldvalue(rs,"stabou"))	
			'.fields("INTREF") = fieldvalue(rs,"INTREF")
			.fields("PROVIN_ID") = fieldvalue(rs,"PROVIN_ID")
			.fields("PRIVAN") = convertvalue(fieldvalue(rs,"PRIVAN"))
			.fields("PRITOT") = convertvalue(fieldvalue(rs,"PRITOT"))
			.fields("KAVELS") = fieldvalue(rs,"KAVELS")
			.fields("oplvan") = datetoiso(fieldvalue(rs,"oplvan"))
			.fields("KAVELS") = fieldvalue(rs,"KAVELS")
			.fields("WEBSIT") = fieldvalue(rs,"WEBSIT")
			.fields("ADRPLA") = fieldvalue(rs,"ADRPLA")
			.fields("ADRSTR") = fieldvalue(rs,"ADRSTR")
			.fields("status_id") = fieldvalue(rs,"status_id")
			.fields("ZICHTB") = checkboxvalue(fieldvalue(rs,"ZICHTB"))
			.fields("is_cpo") = checkboxvalue(fieldvalue(rs,"is_cpo"))
			.fields("adrcor1") = fieldvalue(rs,"adrcor1")
			.fields("adrcor2") = fieldvalue(rs,"adrcor2")
			.fields("adrcor3") = fieldvalue(rs,"adrcor3")
			.fields("adrcor4") = fieldvalue(rs,"adrcor4")
			.fields("tekcor1") = fieldvalue(rs,"tekcor1")
			.fields("tekcor2") = fieldvalue(rs,"tekcor2")
			.fields("tekcor3") = fieldvalue(rs,"tekcor3")
			.fields("tekcor4") = fieldvalue(rs,"tekcor4")
			.fields("pro_disclaimer_fk") = fieldvalue(rs,"pro_disclaimer_fk")
		end with
		sec_setsecurityinfo rs 
		putrecordset rs 
	end function

	'Hier wordt de titel van het formulier bepaalt
	projects_header(recordid)
	f_form_hdr()
%>
<table style="" cellpadding="0" cellspacing="0" ID="Table1">
	<tr>
		<td valign="top">
			<table style="" ID="Table2">
				<%
				    f_frm_divider(getlabel("algemeen"))
                    f_textbox rs,"PRONAA","PRONAA","200"
                    f_label rs,"INTREF","INTREF"
                    f_textbox rs,"PRONUM","PRONUM","200"
                    f_checkbox rs,"is_cpo","is_cpo"
                    f_frm_divider(getlabel("Data"))
                    f_datebox rs,"STARTD","STARTD","200"
                    f_datebox rs,"STABOU","STABOU","200"
                    f_datebox rs,"OPLVAN","OPLVAN","200"
                    f_datebox rs,"EINDDA","EINDDA","200"
                    f_frm_divider(getlabel("prijzen"))
                    f_textbox rs,"PRIVAN","PRIVAN","200"
                    f_textbox rs,"PRITOT","PRITOT","200"
                    f_textbox rs,"KAVELS","KAVELS","200"
                    f_textbox rs,"WEBSIT","WEBSIT","200"
                    f_listbox rs,"pro_disclaimer_fk","pro_disclaimer_fk","select dsc_pk,dsc_name from disclaimer order by dsc_name","dsc_pk","dsc_name","200",""
                    
                %>
             </table>					
         </td>
         <td valign="top">
			<table style="" ID="Table3">
				<%
                    f_frm_divider(getlabel("Plaats"))
                    f_listbox rs,"PROVIN_ID","PROVIN_ID","select id,prvnaa from provin order by prvnaa","id","prvnaa","200",""
                    f_textbox rs,"ADRPLA","ADRPLA","200"
                    f_textbox rs,"ADRSTR","ADRSTR","200"
		            f_frm_divider(getlabel("adrcor"))
                    f_textbox rs,"adrcor1","adrcor1","200"
                    f_textbox rs,"adrcor2","adrcor2","200"
                    f_textbox rs,"adrcor3","adrcor3","200"
                    f_textbox rs,"adrcor4","adrcor4","200"
                    f_frm_divider(getlabel("tekcor"))
                    f_textbox rs,"tekcor1","tekcor1","200"
                    f_textbox rs,"tekcor2","tekcor2","200"
                    f_textbox rs,"tekcor3","tekcor3","200"
                    f_textbox rs,"tekcor4","tekcor4","200"
                    f_frm_divider(getlabel("status"))
                    f_listbox rs,"status_id","status_id","select id,stanaa from status where inreto='projec' order by stanaa","id","stanaa","200",""
		            f_checkbox rs,"ZICHTB","ZICHTB"
		            
                    
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
