<!-- #include file="../../templates/headers/content.asp" -->
<!-- #include file="functions.asp" -->
<%
	dim recordid, rs, sql, tablename
	
	viewstate = viewstate_value("viewstate")
	recordid  = viewstate_value("id")
	projec_id  = viewstate_value("projec_id")
	fases_id  = viewstate_value("fases_id")
	tablename = "projec_fases_steps"
		
	select case lcase(viewstate)
	case "view"
		sql = "select * from [" & tablename & "] where id = " & recordid
		set rs = getrecordset(sql,false)
		projec_id = rs.fields("projec_id")
	case "edit","save"
		sql = "select * from [" & tablename & "] where id = " & recordid
		set rs = getrecordset(sql,false)
		projec_id = rs.fields("projec_id")
		fases_id = rs.fields("fases_id")
	case "new","savenew"
		sql = "select * from [" & tablename & "] where id = -1"
		set rs = getrecordset(sql,false)
		rs.addnew
		rs.fields("projec_id") = projec_id
		rs.fields("fases_id") = fases_id
		sec_setsecurityinfo (rs)
	case else
		response.Write "invalid viewstate !!"
		response.end
	end select
	
	if viewstate = "save" or viewstate = "savenew" then	
		if ispostback() then
		
		    if not v_valid("^\w+",true,fieldvalue(rs,"stepna")) then v_addformerror "stepna"
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
		    
			.fields("stepna") = fieldvalue(rs,"stepna")
			.fields("volgor") = fieldvalue(rs,"volgor")
			.fields("basis") = checkboxvalue(fieldvalue(rs,"basis"))
		end with
		sec_setsecurityinfo rs 
		putrecordset rs 
	end function

    if projec_id = 0 then
        f_header getlabel("projec_fases_steps")
    else
	    projects_header(projec_id)
	end if    

	f_form_hdr()
	f_hidden "projec_id"
	f_hidden "fases_id"
%>
<table style="" cellpadding="0" cellspacing="0" ID="Table1">
	<tr>
		<td valign="top">
			<table style="" ID="Table2">
				<%
		            f_textbox rs,"stepna","stepna","100%"
		            f_textbox rs,"volgor","volgor",80
		            f_checkbox rs,"basis","basis"
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
