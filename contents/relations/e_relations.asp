<!-- #include file="../../templates/headers/content.asp" -->
<!-- #include file="functions.asp" -->
<%
	dim recordid, rs, sql, tablename
	
	viewstate = viewstate_value("viewstate")
	recordid  = viewstate_value("id")
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
		recordid=-1
		set rs = getrecordset(sql,false)
		rs.addnew
		sec_setsecurityinfo (rs)
	case else
		response.Write "invalid viewstate !!"
		response.end
	end select
	
	if viewstate = "save" or viewstate = "savenew" then	
		if ispostback() then
			if not v_valid("^\w+",true,fieldvalue(rs,"bednaa")) then v_addformerror "bednaa"
			if errorcount = 0 then 
					viewstate = "update"
			end if
		end if		
	end if
	
	'response.Write formerrors
	
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
	        sql = ""
	        sql = sql & " sp_relati_insert_bedrijf "
	        sql = sql & " ( "
		    sql = sql & " 1, "
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
	        
	     '   response.Write sql
	        
	        set rs = getrecordset(sql, true)
	        sql = "select * from [" & tablename & "] where id = " & rs.fields("insert_id")
		    set rs = getrecordset(sql,false)
	        with rs
			    .fields("bednaa") = fieldvalue(rs,"bednaa")
			    if len(fieldvalue(rs,"zoekco"))=0 then
			        .fields("zoekco") = left(fieldvalue(rs,"bednaa") ,10)
			    else
			        .fields("zoekco") = fieldvalue(rs,"zoekco")
			    end if  
			    .fields("adrstr") = fieldvalue(rs,"adrstr")
			    .fields("adrnum") = fieldvalue(rs,"adrnum")
			    .fields("adrtoe") = fieldvalue(rs,"adrtoe")
			    .fields("adrpos") = fieldvalue(rs,"adrpos")
			    .fields("adrpla") = fieldvalue(rs,"adrpla")
			    .fields("adrlan") = fieldvalue(rs,"adrlan")
			    .fields("posstr") = fieldvalue(rs,"posstr")
			    .fields("posnum") = fieldvalue(rs,"posnum")
			    .fields("postoe") = fieldvalue(rs,"postoe")
			    .fields("pospla") = fieldvalue(rs,"pospla")
			    .fields("pospos") = fieldvalue(rs,"pospos")
			    .fields("poslan") = fieldvalue(rs,"poslan")
			    .fields("adrtel") = fieldvalue(rs,"adrtel")
			    .fields("adrfax") = fieldvalue(rs,"adrfax")
			    .fields("adrema") = fieldvalue(rs,"adrema")
			    .fields("adrwww") = fieldvalue(rs,"adrwww")
		    end with
		    sec_setsecurityinfo rs 
		    putrecordset rs 
		    
		    response.Redirect "?viewstate=view&id=" & rs.fields("id")
	        
	    else
	        with rs
			    .fields("bednaa") = fieldvalue(rs,"bednaa")
			    if len(fieldvalue(rs,"zoekco"))=0 then
			        .fields("zoekco") = left(fieldvalue(rs,"bednaa") ,10)
			    else
			        .fields("zoekco") = fieldvalue(rs,"zoekco")
			    end if  
			    .fields("adrstr") = fieldvalue(rs,"adrstr")
			    .fields("adrnum") = fieldvalue(rs,"adrnum")
			    .fields("adrtoe") = fieldvalue(rs,"adrtoe")
			    .fields("adrpos") = fieldvalue(rs,"adrpos")
			    .fields("adrpla") = fieldvalue(rs,"adrpla")
			    .fields("adrlan") = fieldvalue(rs,"adrlan")
			    .fields("posstr") = fieldvalue(rs,"posstr")
			    .fields("posnum") = fieldvalue(rs,"posnum")
			    .fields("postoe") = fieldvalue(rs,"postoe")
			    .fields("pospla") = fieldvalue(rs,"pospla")
			    .fields("pospos") = fieldvalue(rs,"pospos")
			    .fields("poslan") = fieldvalue(rs,"poslan")
			    .fields("adrtel") = fieldvalue(rs,"adrtel")
			    .fields("adrfax") = fieldvalue(rs,"adrfax")
			    .fields("adrema") = fieldvalue(rs,"adrema")
			    .fields("adrwww") = fieldvalue(rs,"adrwww")
		    end with
		    sec_setsecurityinfo rs 
		    putrecordset rs 
	    end if
	
	
		
	end function

	'Hier wordt de titel van het formulier bepaalt
	relations_header (recordid)	
	f_form_hdr()
%>
<table style="" cellpadding="0" cellspacing="0" ID="Table1">
	<tr>
		<td valign="top">
			<table style="" ID="Table2">
				<%
					f_textbox rs,"bednaa","bednaa","250"
					f_textbox rs,"zoekco","zoekco","60"
					f_address rs,"zak_adres","adr"
					f_address rs,"post_adres","pos"					
				%>
			</table>
		</td>
		<td valign="top">
			<table style="" ID="Table3">
				<%
					f_textbox rs,"adrtel","adrtel","200"
					f_textbox rs,"adrfax","adrfax","200"
					f_emailbox rs,"adrema","adrema","200"
					f_textbox rs,"adrwww","adrwww","200"
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
