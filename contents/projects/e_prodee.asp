<!-- #include file="../../templates/headers/content.asp" -->
<!-- #include file="functions.asp" -->
<%
	dim recordid, rs, sql, tablename
	
	viewstate = viewstate_value("viewstate")
	recordid  = viewstate_value("id")
	projec_id  = viewstate_value("projec_id")
	tablename = "prodee"
		
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
		    if not v_valid("^\d+$",true,fieldvalue(rs,"status_id")) then v_addformerror "status_id"
		    if not v_valid("^\d+$",true,fieldvalue(rs,"volgor")) then v_addformerror "volgor"
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
		response.Redirect viewstate_value("REFURL")
	end if
	
	if viewstate="edit" then viewstate = "save"
	if viewstate="new" then viewstate = "savenew"
	
	function save_rs(rs)
		with rs
			.fields("voorkeur") = fieldvalue(rs,"voorkeur")
			.fields("status_id") = fieldvalue(rs,"status_id")
			.fields("volgor") = fieldvalue(rs,"volgor")
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
		            f_listbox rs,"voorkeur","voorkeur","select bounum_id, 'Bouwnummer ' + extnum as extnum from vw_bounum where projec_id=" & projec_id,"bounum_id","extnum","",""
		            f_listbox rs,"status","status_id","select id, stanaa + ' - ' + coalesce(stabes,'') as stanaa from status where inreto='prodee'","id","stanaa","",""
		            f_textbox rs,"volgor","volgor", 50
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
