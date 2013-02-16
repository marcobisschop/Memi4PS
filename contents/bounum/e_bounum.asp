<!-- #include file="../../templates/headers/content.asp" -->
<!-- #include file="functions.asp" -->
<%
	dim recordid, rs, sql, tablename
	
	viewstate = viewstate_value("viewstate")
	recordid  = viewstate_value("id")
	projec_id  = viewstate_value("projec_id")
	boutyp_id  = viewstate_value("boutyp_id")
	tablename = "bounum"
		
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
		rs.fields("projec_id") = projec_id
		rs.fields("boutyp_id") = boutyp_id
		sec_setsecurityinfo (rs)
	case else
		response.Write "invalid viewstate !!"
		response.end
	end select
	
	if viewstate = "save" or viewstate = "savenew" then	
		if ispostback() then
			if not v_valid("^\d+",true,fieldvalue(rs,"extnum")) then v_addformerror "extnum"
			if not v_valid("^\d+$",true,fieldvalue(rs,"boutyp_id")) then v_addformerror "boutyp_id"
			'if not v_valid("^\d+$",true,fieldvalue(rs,"projec_id")) then v_addformerror "projec_id"
			if not v_valid("^\d+$",true,fieldvalue(rs,"status_id")) then v_addformerror "status_id"
			if not v_valid("^\d+$",true,convertvalue(fieldvalue(rs,"memi_budget"))) then v_addformerror "memi_budget"
			
			
			if errorcount = 0 then 
			    if viewstate = "savenew" then bounum_initialize = true
				viewstate = "update"
			end if
		end if		
	end if
	
	if viewstate = "update" then 
		save_rs rs
		recordid = rs.fields("id")		
		viewstate = "view"
		if bounum_initialize then executesql "exec spBounum_Initialize " & recordid
	end if
	
	if viewstate="edit" then viewstate = "save"
	if viewstate="new" then viewstate = "savenew"
	
	'response.write formerrors
	
	function save_rs(rs)
		with rs
			.fields("extnum") = fieldvalue(rs,"extnum")
			.fields("exttoe") = fieldvalue(rs,"exttoe")
			.fields("boutyp_id") = fieldvalue(rs,"boutyp_id")
			.fields("subtyp") = fieldvalue(rs,"subtyp")
			.fields("adrstr") = fieldvalue(rs,"adrstr")
			.fields("adrnum") = fieldvalue(rs,"adrnum")
			.fields("adrtoe") = fieldvalue(rs,"adrtoe")
			.fields("adrpos") = fieldvalue(rs,"adrpos")
			.fields("adrpla") = fieldvalue(rs,"adrpla")
			.fields("adrlan") = fieldvalue(rs,"adrlan")
			if len(fieldvalue(rs,"koosom"))=0 then
			    .fields("koosom") = 0
			else 
			    .fields("koosom") = fieldvalue(rs,"koosom")
			end if 
			if len(fieldvalue(rs,"aansom"))=0 then
			    .fields("aansom") = 0
			else 
			    .fields("aansom") = fieldvalue(rs,"aansom")
			end if 
			if len(fieldvalue(rs,"grokos"))=0 then
			    .fields("grokos") = 0
			else 
			    .fields("grokos") = fieldvalue(rs,"grokos")
			end if 
			.fields("factur") = checkboxvalue(fieldvalue(rs,"factur"))
			
			.fields("status_id") = fieldvalue(rs,"status_id")
			.fields("kavopp") = convertvalue(fieldvalue(rs,"kavopp"))
			.fields("eancode_elektra") = fieldvalue(rs,"eancode_elektra")
			.fields("eancode_gas") = fieldvalue(rs,"eancode_gas")
			.fields("memi_budget") = convertvalue(fieldvalue(rs,"memi_budget"))
			if len(fieldvalue(rs, "voorschouw")) = 0 then
			    
			else
			    .fields("voorschouw") = datetoiso(fieldvalue(rs,"voorschouw"))
			end if 
			if len(fieldvalue(rs, "oplevering")) = 0 then
			    
			else
			    .fields("oplevering") = datetoiso(fieldvalue(rs,"oplevering"))
			end if 
			.fields("koopvo_id") = fieldvalue(rs,"koopvo_id")
			
		end with
		sec_setsecurityinfo rs 
		putrecordset rs 
		
	end function

	'Hier wordt de titel van het formulier bepaalt
	bounum_header(rs.fields("id"))
	f_form_hdr()
	f_hidden "projec_id"
%>
<table style="" cellpadding="0" cellspacing="0" ID="Table1">
	<tr>
		<td valign="top">
			<table style="" ID="Table2">
				<%
				    f_frm_divider(getlabel("algemeen"))
		            f_textbox rs,"extnum","extnum",100
		            f_textbox rs,"exttoe","exttoe",120
		            f_listbox rs,"boutyp", "boutyp_id", "select * from boutyp where projec_id=" & rs.fields("projec_id") & " order by typnaa", "id", "typnaa", "200", ""
		            f_textbox rs,"subtyp","subtyp",120
   		            
   		            f_frm_divider(getlabel("adres"))
		            f_address rs,"bounum_adres","adr"
		            
		            f_frm_divider(getlabel("kosten"))
		            f_textbox rs,"koosom","koosom",120
   		            f_textbox rs,"aansom","aansom",120
                    f_textbox rs,"kavopp","kavopp",120
   		            f_textbox rs,"grokos","grokos",120
                    
                    f_frm_divider(getlabel("facturatie"))
		            f_checkbox rs,"opnemen_factur","factur"
   		            
		            
                %>
             </table>					
         </td>
         <td valign="top">
			<table style="" ID="Table3">
				<%
		            f_frm_divider(getlabel("datums"))
		            f_datebox rs,"voorschouw","voorschouw",120
		            f_datebox rs,"oplevering","oplevering",120
		            
		            f_frm_divider(getlabel("overig"))
		            f_textbox rs,"eancode_elektra","eancode_elektra",120
		            f_textbox rs,"eancode_gas","eancode_gas",120
		            f_listbox rs,"status","status_id","select * from status where inreto='BOUNUM' order by stanaa","id","stanaa","200",""
		            f_textbox rs,"memi_budget","memi_budget",120
		            f_listbox rs,"koopvo", "koopvo_id", "select * from koopvo order by koobes", "id", "koobes", "200", ""
		            
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
