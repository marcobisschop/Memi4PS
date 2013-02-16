<!-- #include file="../../templates/headers/content.asp" -->

<%
	dim recordid, rs, sql, tablename
	
	viewstate = viewstate_value("viewstate")
	recordid  = viewstate_value("id")
	tablename = "correspondence"
		
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
			'deze if functie plaatsen
			if not v_valid("^\w",true,fieldvalue(rs,"name")) then v_addformerror "name"
			if not v_valid("^\w",true,fieldvalue(rs,"reflects")) then v_addformerror "reflects"
			if not v_valid("^\w",false,fieldvalue(rs,"description")) then v_addformerror "description"
			if errorcount = 0 then 
				viewstate = "update"
			end if
		end if		
	end if
	
	if viewstate = "update" then 
		save_rs rs
		recordid = rs.fields("id")		
		viewstate = "view"
		response.Redirect "l_correspondence.asp"
	end if
	
	if viewstate="edit" then viewstate = "save"
	if viewstate="new" then viewstate = "savenew"
	
	function save_rs(rs)
		with rs
			.fields("name") = fieldvalue(rs,"name")
			.fields("description") = fieldvalue(rs,"description")
			.fields("reflects") = fieldvalue(rs,"reflects")
			.fields("locked") = checkboxvalue(fieldvalue(rs,"locked"))
			
			if uploader.files.count = 1 then
				for each file in uploader.files.items
					if file.filesize <= MaxFileSize then
						Dim FileString, HeaderEndPos, FooterBeginPos
						Dim RTFHeader
						Dim RTFBody
						Dim RTFFooter
						
						FileString = file.ToString()
						
						' response.Write filestring
						' response.end
						
						HeaderEndPos   = InstrRev(ucase(FileString),"#BEGIN#")
						FooterBeginPos = Instr(ucase(FileString),"#END#")
						
						If headerendpos <=0 or footerbeginpos <=0 then
							Response.Write  "Let erop dat in het document gebruik wordt gemaakt van #BEGIN# en #END#!"
							Response.End 
						end if
						
						RTFHeader = Left(FileString,HeaderEndPos-2) 
						RTFBody   = Mid(FileString,HeaderENDPos + 7,FooterBeginPos - HeaderEndPos - 7) 
						RTFFooter = Mid(FileString,FooterBeginPos + 5)

						dim hdr, ftr
												
						.fields("rtfheader") = RTFHeader
						.fields("rtfbody") = RTFBody
						.fields("rtffooter") = RTFFooter
						.fields("contenttype") = "application/msword"
	
					else
						'bestand is te groot
						Response.Write "Let op: maximale bestandsgrootte is 1.000.000 bytes!"				
					end if
				next
			end if
		end with
		sec_setsecurityinfo rs 
		putrecordset rs 
	end function
	
	f_header ("Brief")
	f_form_hdr()
%>
<table style="" cellpadding=0 cellspacing=0 ID="Table1">
	<tr>
		<td valign="top" style="80%">
			<table style="width:100%" ID="Table2">
				<% 
					f_textbox rs,"Naam brief","name","100%"
					f_textarea rs,"Omschrijving","description","100%","120"
					f_filebox rs,"Bestand", "rtfbody_u", "100%"
					f_textbox rs,"Reflecteerd","reflects","100%"
					f_checkbox rs,"Geblokkeerd","locked"
				    
				    if viewstate="view" then
				        f_readonly "", "<a href='s_correspondence.asp?id=" & recordid & "'>" & getlabel("correspondence_viewcurrentletter") & "</a>" 
	    		    end if
	    		 %>
			</table>
		</td>	
	</tr>
</table>
<%
	f_form_ftr()
%>
<!-- #include file="../../templates/footers/content.asp" -->
