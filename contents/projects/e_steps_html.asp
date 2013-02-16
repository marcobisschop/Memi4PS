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
	case else
		response.Write "invalid viewstate !!"
		response.end
	end select
	
	if viewstate = "save" or viewstate = "savenew" then	
		if ispostback() then
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
			.fields("html") = fieldvalue(rs,"body")
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
<table style="width: 100%" cellpadding="0" cellspacing="0" ID="Table1">
	<tr>
		<td valign="top">
			<table style="" ID="Table2">
				<%
				    f_label rs, "stepna", "stepna"
		            f_htmlarea rs,"html","html","100%","450"
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
