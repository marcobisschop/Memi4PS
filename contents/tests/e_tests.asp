<!-- #include file="../../templates/headers/content.asp" -->
<%
	dim recordid, rs, sql, tablename
	
	viewstate = viewstate_value("viewstate")
	myLetter = viewstate_value("myLetter")
	recordid  = viewstate_value("id")
	tablename = "toetsen"
	
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
			if not v_valid("^\w+",true,fieldvalue(rs,"code")) then v_addformerror "code"
            if not v_isdate(true, fieldvalue(rs,"dattoets")) then v_addformerror "dattoets"
            if not v_valid("^\w+",true,fieldvalue(rs,"blok")) then v_addformerror "blok"
            if not v_valid("^\d+$",true,fieldvalue(rs,"years_id")) then v_addformerror "years_id"
            if not v_valid("^\d+$",true,fieldvalue(rs,"maxects")) then v_addformerror "maxects"
            
            
			if not v_valid("^\w+$",true,fieldvalue(rs,"toetsen_type")) then v_addformerror "toetsen_type"
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
		dim codetot
		
		with rs
		    .fields("code") = fieldvalue(rs,"code")
			.fields("blok") = fieldvalue(rs,"blok")
			.fields("dattoets") = convertdate(fieldvalue(rs,"dattoets"))
		    
		    codetot = fieldvalue(rs, "codetot")        
	        if viewstate = "savenew" or codetot = "" then
                codetot = year(.fields("dattoets")) & "." & right( "00" & month(.fields("dattoets")),2) & "." & right("00" & day(.fields("dattoets")),2) 	        
                codetot = codetot & "/ "
                codetot = codetot & left(.fields("code"),8)
                codetot = codetot & "/ "
                codetot = codetot & .fields("blok")
	        end if
	
			.fields("codetot") = codetot
			.fields("hertoets") = checkboxvalue(fieldvalue(rs,"hertoets"))
			.fields("maxects") = fieldvalue(rs,"maxects")
			.fields("omschrijvi") = fieldvalue(rs,"omschrijvi")
			.fields("toetsen_type") = fieldvalue(rs,"toetsen_type")
			.fields("years_id") = fieldvalue(rs,"years_id")			
		end with
		sec_setsecurityinfo rs 
		putrecordset rs 
	end function
	
	f_header rs.fields("codetot")
	f_form_hdr()
%>
<table style="" cellpadding=0 cellspacing=0 ID="Table1">
	<tr>
		<td valign="top">
			<table style="" ID="Table2">
				<%
					f_textbox rs,"codetot","codetot","300"
					f_listbox rs,"test_code","code",getvariablegroup("test_codes"),"value","name","120",""
					f_datebox rs,"dattoets","dattoets","120"
					f_listbox rs,"test_block","blok",getvariablegroup("test_blocks"),"value","name","120",""
					f_checkbox rs,"hertoets","hertoets"
					f_textbox rs,"maxects","maxects","300"
					f_textbox rs,"description","omschrijvi","300"
					f_listbox rs,"toetsen_type","toetsen_type",getvariablegroup("toetsen_type"),"value","name","120",""
					f_listbox rs,"years_id","years_id","select id,year from years order by year","id","year",200,""
				%>
			</table>
		</td>
	</tr>
</table>
<%
f_form_ftr()
%>
<!-- #include file="../../templates/footers/content.asp" -->
