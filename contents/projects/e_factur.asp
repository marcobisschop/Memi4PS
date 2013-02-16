<!-- #include file="../../templates/headers/content.asp" -->
<!-- #include file="functions.asp" -->
<%
	dim recordid, rs, sql, tablename
	
	viewstate = viewstate_value("viewstate")
	recordid  = viewstate_value("id")
	projec_id  = viewstate_value("projec_id")
	tablename = "factur"
		
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
		sec_setsecurityinfo (rs)
	case else
		response.Write "invalid viewstate !!"
		response.end
	end select
	
	if viewstate = "save" or viewstate = "savenew" then	
		if ispostback() then
		    if not v_valid("^\d+$",true,fieldvalue(rs,"projec_id")) then v_addformerror "projec_id"
		    if not v_valid("^\w+",true,fieldvalue(rs,"facnaa")) then v_addformerror "facnaa"
		    if not v_valid("^\d+$",true,fieldvalue(rs,"percen")) then v_addformerror "percen"
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
			.fields("facnaa") = fieldvalue(rs,"facnaa")
			.fields("percen") = fieldvalue(rs,"percen")
			.fields("facdat") = convertdate(fieldvalue(rs,"facdat"))
			.fields("volgor") = fieldvalue(rs,"volgor")
			
		end with
		sec_setsecurityinfo rs 
		putrecordset rs 
	end function

    projects_header(projec_id)
	
	f_form_hdr()
	
	f_header getlabel("Facturatie regel")
	
%>
<input type="hidden" id="projec_id" name="projec_id" value="<%=projec_id %>" />
<table style="" cellpadding="0" cellspacing="0" ID="Table1">
	<tr>
		<td valign="top">
			<table style="" ID="Table2">
				<%
		            f_textbox rs,"facnaa","facnaa", "255px"
		            f_textbox rs,"percen","percen", "25px"
		            f_datebox rs,"facdat","facdat", "70px"
		            f_textbox rs,"volgor","volgor", "25px"
		            
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
