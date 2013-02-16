<!-- #include file="../../templates/headers/content.asp" -->
<!-- #include file="functions.asp" -->
<%
	dim recordid, rs, sql, tablename
	
	viewstate = viewstate_value("viewstate")
	recordid  = viewstate_value("id")
	bedrij_id = viewstate_value("bedrij_id")
	bounum_id = viewstate_value("bounum_id")
	
	tablename = "relati"
		
	select case lcase(viewstate)
	case "view"
		sql = "select * from [" & tablename & "] where id = " & recordid
		set rs = getrecordset(sql,false)
	case "edit","save"
		sql = "select * from [" & tablename & "] where id = " & recordid
		set rs = getrecordset(sql,false)
	case "new","savenew"
		sql = "select * from [" & tablename & "] where id = -1"
		recordid = -1
		set rs = getrecordset(sql,false)
		rs.addnew
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
	
	if viewstate = "update" then 
		save_rs rs
		recordid = rs.fields("id")		
		viewstate = "view"
		' response.Redirect viewstate_value("REFURL")
	end if
	
	if viewstate="edit" then viewstate = "save"
	if viewstate="new" then viewstate = "savenew"
	
	function save_rs(rs)
	 if recordid = -1 then
	        if not isnumeric(bedrij_id) then bedrij_id = 0
	        sql = ""
	        sql = sql & " sp_relati_insert_contact "
	        sql = sql & " ( "
		    sql = sql & " " & bedrij_id & ", "
	        sql = sql & " 	" & sec_currentuserid() & ", "
	        sql = sql & " 	'" & fieldvalue(rs,"bednaa") & "', "
	        sql = sql & " 	'" & fieldvalue(rs,"adrstr") & "', "
	        sql = sql & " 	'" & fieldvalue(rs,"adrnum") & "', "
	        sql = sql & " 	'" & fieldvalue(rs,"adrtoe") & "', "
	        sql = sql & " 	'" & fieldvalue(rs,"adrpos") & "', "
	        sql = sql & " 	'" & fieldvalue(rs,"adrpla") & "', "
	        sql = sql & " 	'" & fieldvalue(rs,"adrlan") & "', "
	        sql = sql & " 	'" & fieldvalue(rs,"adrtel") & "', "
	        sql = sql & " 	'" & fieldvalue(rs,"adrfax") & "', "
	        sql = sql & " 	'" & fieldvalue(rs,"adrema") & "', "
	        sql = sql & " 	'" & fieldvalue(rs,"adrwww") & "', "
	        sql = sql & " 	'" & fieldvalue(rs,"aanhef_id") & "', "
	        sql = sql & " 	'" & fieldvalue(rs,"voorle") & "', "
	        sql = sql & " 	'" & fieldvalue(rs,"tussen") & "', "
		    sql = sql & " '" & fieldvalue(rs,"achter") & "', "
		    sql = sql & " '" & convertdate(fieldvalue(rs,"gebdat")) & "', "
		    sql = sql & " '" & fieldvalue(rs,"geslac_gesnaa") & "', "
		    sql = sql & " '" & fieldvalue(rs,"telpri") & "', "
		    sql = sql & " '" & fieldvalue(rs,"telwer") & "', "
		    sql = sql & " '" & fieldvalue(rs,"telmob") & "', "
		    sql = sql & " '" & fieldvalue(rs,"faxwer") & "', "
		    sql = sql & " '" & fieldvalue(rs,"faxpri") & "', "
		    sql = sql & " '" & fieldvalue(rs,"emawer") & "', "
		    sql = sql & " '" & fieldvalue(rs,"emapri") & "', "
		    sql = sql & " '" & fieldvalue(rs,"banknr") & "', "
		    sql = sql & " '" & fieldvalue(rs,"btwnum") & "' "
	        sql = sql & " ) "
	        
	        ' response.Write sql
	        ' response.End 
	        set rs = getrecordset(sql, true)
	        
    		sql = "select * from [" & tablename & "] where id = " & rs.fields("insert_id")
	    	set rs = getrecordset(sql,false)
	        with rs
			    .fields("voorle") = fieldvalue(rs,"voorle")
			    .fields("voorna") = fieldvalue(rs,"voorna")
			    .fields("tussen") = fieldvalue(rs,"tussen")
			    .fields("achter") = fieldvalue(rs,"achter")
			    .fields("aanhef_id") = fieldvalue(rs,"aanhef_id")
			    .fields("geslac_gesnaa") = fieldvalue(rs,"geslac_gesnaa")
    						
			    .fields("adrtel") = fieldvalue(rs,"adrtel")
			    .fields("telmob") = fieldvalue(rs,"telmob")
			    .fields("adrema") = fieldvalue(rs,"adrema")
			    .fields("telwer") = fieldvalue(rs,"telwer")
			    .fields("faxwer") = fieldvalue(rs,"faxwer")
			    .fields("emawer") = fieldvalue(rs,"emawer")
    			
			    .fields("priadr") = checkboxvalue(fieldvalue(rs,"priadr"))			
			    .fields("formeel") = checkboxvalue(fieldvalue(rs,"formeel"))		
    			
			    .fields("adrstr") = fieldvalue(rs,"adrstr")
			    .fields("adrnum") = fieldvalue(rs,"adrnum")
			    .fields("adrtoe") = fieldvalue(rs,"adrtoe")
			    .fields("adrpos") = fieldvalue(rs,"adrpos")
			    .fields("adrpla") = fieldvalue(rs,"adrpla")
			    .fields("adrlan") = fieldvalue(rs,"adrlan")
    			
		    end with
		    'sec_setsecurityinfo rs 
		    putrecordset rs 
		    
		    if bounum_id = "" then 
		        bounum_id = -1
		    else
		        if not is_numeric(bounum_id) then bounum_id = -1
		    end if
		    
		    if bounum_id > 0 then
		        executesql "exec aspContact2Bounum " & rs.fields("id") & "," & bounum_id
		    end if
		    
		    response.Redirect "?viewstate=view&id=" & rs.fields("id")
	    else
		    with rs
			    .fields("voorle") = fieldvalue(rs,"voorle")
			    .fields("voorna") = fieldvalue(rs,"voorna")
			    .fields("tussen") = fieldvalue(rs,"tussen")
			    .fields("achter") = fieldvalue(rs,"achter")
			    .fields("aanhef_id") = fieldvalue(rs,"aanhef_id")
			    .fields("geslac_gesnaa") = fieldvalue(rs,"geslac_gesnaa")
    						
			    .fields("adrtel") = fieldvalue(rs,"adrtel")
			    .fields("telmob") = fieldvalue(rs,"telmob")
			    .fields("adrema") = fieldvalue(rs,"adrema")
			    .fields("telwer") = fieldvalue(rs,"telwer")
			    .fields("faxwer") = fieldvalue(rs,"faxwer")
			    .fields("emawer") = fieldvalue(rs,"emawer")
    			
			    .fields("priadr") = checkboxvalue(fieldvalue(rs,"priadr"))			
			    .fields("formeel") = checkboxvalue(fieldvalue(rs,"formeel"))		
    			
			    .fields("adrstr") = fieldvalue(rs,"adrstr")
			    .fields("adrnum") = fieldvalue(rs,"adrnum")
			    .fields("adrtoe") = fieldvalue(rs,"adrtoe")
			    .fields("adrpos") = fieldvalue(rs,"adrpos")
			    .fields("adrpla") = fieldvalue(rs,"adrpla")
			    .fields("adrlan") = fieldvalue(rs,"adrlan")
    			
		    end with
		    sec_setsecurityinfo rs 
		    putrecordset rs 
		end if
	end function

	'Hier wordt de titel van het formulier bepaalt
	contacts_header (recordid)	
	f_form_hdr()
%>
<input type="hidden" id="bedrij_id" name="bedrij_id" value="<%=bedrij_id %>" />
<input type="hidden" id="bounum_id" name="bounum_id" value="<%=bounum_id %>" />

<table style="" cellpadding="0" cellspacing="0" ID="Table1">
	<tr>
		<td valign="top">
			<table style="" ID="Table2">
				<%
    				f_frm_divider getlabel("general")
    				f_listbox rs,"geslac_gesnaa","geslac_gesnaa","select name, value from variables where [group]='gender' order by name","value","name",200,""	
					f_person rs,"contact_name",""	
					f_address rs,"pri_adres","adr"
					f_checkbox rs,"priveadres","priadr"								
					f_checkbox rs,"formeel","formeel"		
				%>
			</table>
		</td>
		<td valign="top">
			<table style="" ID="Table3">
				<%
				    f_frm_divider getlabel("Prive")
    				f_textbox rs,"adrtel","adrtel","200"
					f_textbox rs,"telmob","telmob","200"
					f_emailbox rs,"adrema","adrema","200"	
					f_frm_divider getlabel("Zakelijk")
    				f_textbox rs,"telwer","telwer","200"
					f_textbox rs,"faxwer","faxwer","200"
					f_emailbox rs,"emawer","emawer","200"	
					
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
