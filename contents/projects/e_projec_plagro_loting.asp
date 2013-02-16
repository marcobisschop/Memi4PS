<!-- #include file="../../templates/headers/content.asp" -->
<!-- #include file="functions.asp" -->
<%
	dim recordid, rs, sql, tablename
	
	viewstate = viewstate_value("viewstate")
	recordid  = viewstate_value("id")
	projec_id  = viewstate_value("projec_id")
	tablename = "projec_plagro_loting"
		
	select case lcase(viewstate)
	case "view"
		sql = "select * from [" & tablename & "] where id = " & recordid
		set rs = getrecordset(sql,false)
		projec_id = rs.fields("projec_id")
	case "edit","save"
		sql = "select * from [" & tablename & "] where id = " & recordid
		set rs = getrecordset(sql,false)
		projec_id = rs.fields("projec_id")
	case "new","savenew"
		sql = "select * from [" & tablename & "] where id = -1"
		set rs = getrecordset(sql,false)
		rs.addnew
		rs.fields("projec_id") = projec_id
		sec_setsecurityinfo (rs)
	case else
		response.Write "invalid viewstate !!"
		response.end
	end select
	
	if viewstate = "save" or viewstate = "savenew" then	
		if ispostback() then
		
		    if not v_valid("^\w+",true,fieldvalue(rs,"beschrijving")) then v_addformerror "beschrijving"
		    if not v_valid("^\d+$",true,fieldvalue(rs,"volgor")) then v_addformerror "volgor"
		    if not v_valid("^\d+$",true,fieldvalue(rs,"status_id")) then v_addformerror "status_id"
		    if not v_valid("^\d+",true,projec_id) then v_addformerror "projec_id"
		
			if errorcount = 0 then 
					viewstate = "update"
			end if
		end if		
	end if
	
	if viewstate = "update" then 
		save_rs rs
		recordid = rs.fields("id")		
		viewstate = "view"
		response.Redirect "l_projec_plagro_loting.asp?projec_id=" & projec_id
	end if
	
	if viewstate="edit" then viewstate = "save"
	if viewstate="new" then viewstate = "savenew"
	
	function save_rs(rs)
		with rs
			.fields("beschrijving") = fieldvalue(rs,"beschrijving")
			.fields("volgor") = fieldvalue(rs,"volgor")
			.fields("status_id") = fieldvalue(rs,"status_id")
			
			if uploader.files.count = 1 then
				for each file in uploader.files.items
					if file.filesize <= 500000 then
						.fields("img_size") = file.filesize
						.fields("img_contyp") = file.contenttype
						file.savetodatabase .fields("img_data")
					else
						'bestand is te groot
						Response.Write "Let op: maximale bestandsgrootte is 500.000 bytes!"				
					end if
				next
			end if
			
		end with
		sec_setsecurityinfo rs 
		putrecordset rs 
	end function

    projects_header(projec_id)
	
	f_form_hdr()
	
%> 
<input type="hidden" id="projec_id" name="projec_id" value="<%=projec_id %>" />
<table style="" cellpadding="0" cellspacing="0" ID="Table1">
	<tr>
		<td valign="top">
			<table style="" ID="Table2">
				<%
		            f_textarea rs,"beschrijving","beschrijving","100%","40"
		            f_textbox rs,"volgor","volgor","50"
		            f_listbox rs,"status_id","status_id","select id,stanaa from status  where inreto='internextern' order by stanaa","id","stanaa",120,""
		            f_filebox rs,"Plattegrond","img_data", 300
                %>
             </table>					
         </td>
	</tr>
</table>
<%
	f_form_ftr()	
%>
</form> 

<%   if viewstate <> "savenew" then %>
        <input src="../../include/plagro_loting.asp?id=<%=recordid %>" type="image" id="image" name="image"/>
<%   end if%>
<!-- #include file="../../templates/footers/content.asp" -->
