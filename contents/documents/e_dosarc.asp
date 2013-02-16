<!-- #include file="../../templates/headers/content.asp" -->
<!-- #include file="functions.asp" -->
<%
	dim recordid, rs, sql, tablename
	
	viewstate = viewstate_value("viewstate")
	recordid  = viewstate_value("id")
	inreto  = viewstate_value("inreto")
	inreto_id  = viewstate_value("inreto_id")
	tablename = "dosarc"
		
	select case lcase(viewstate)
	case "view"
		sql = "select * from [" & tablename & "] where id = " & recordid
		set rs = getrecordset(sql,false)
	case "edit","save"
		sql = "select * from [" & tablename & "] where id = " & recordid
		set rs = getrecordset(sql,false)
		inreto = rs.fields("inreto")
		inreto_id = rs.fields("inreto_id")
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
			if not v_valid("^\w",false,fieldvalue(rs,"arcbes")) then v_addformerror "arcbes"
			if errorcount = 0 then 
				viewstate = "update"
			end if
		end if		
	end if
	
	'response.Write "formerrors : " & formerrors
	
	if viewstate = "update" then 
		save_rs rs
		recordid = rs.fields("id")		
		viewstate = "view"
		'response.Redirect REFURL
	end if
	
	if viewstate="edit" then viewstate = "save"
	if viewstate="new" then viewstate = "savenew"
	
	function save_rs(rs)
		with rs
			.fields("arcbes") = fieldvalue(rs,"arcbes")
			.fields("inreto") = inreto
			.fields("volgor") = fieldvalue(rs,"volgor")
			.fields("inreto_id") = inreto_id
			.fields("available") = checkboxvalue(fieldvalue(rs,"available"))
			
			if uploader.files.count = 1 then
				for each file in uploader.files.items
					if file.filesize <= MaxFileSize then
						
						.fields("arccon") = file.contenttype
	                    .fields("arcsiz") = file.filesize
	                    .fields("arcnaa") = file.filename
			            file.savetodatabase rs.fields("arcdat")
			            
					else
						'bestand is te groot
						Response.Write getlabel("error_maximum_filesize : " & MaxFileSize / 1024 & "Kb")				
					end if
				next
			end if
		end with
		sec_setsecurityinfo rs 
		putrecordset rs 
	end function
	
	header inreto_id
	f_form_hdr()
	f_hidden "inreto"
	f_hidden "inreto_id"
	
%>
<table style="" cellpadding=0 cellspacing=0 ID="Table1">
	<tr>
		<td valign="top" style="80%">
			<table style="width:100%" ID="Table2">
				<% 
					f_filebox rs,"arcdat", "arcdat", "100%"
					f_textarea rs,"arcbes","arcbes","100%","120"
					f_checkbox rs,"available","available"				    
					f_textbox rs,"volgor", "volgor", "20"
					
	    		 %>
			</table>
		</td>	
	</tr>
</table>
<%
	f_form_ftr()
%>
<!-- #include file="../../templates/footers/content.asp" -->
