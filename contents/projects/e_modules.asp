<!-- #include file="../../templates/headers/content.asp" -->
<!-- #include file="functions.asp" -->
<%
	dim recordid, rs, sql, tablename
	
	viewstate = viewstate_value("viewstate")
	recordid  = viewstate_value("id")
	tablename = "projec"
		
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
			if errorcount = 0 then 
					viewstate = "update"
			end if
		end if		
	end if
	
	if viewstate = "update" then 
		save_rs rs
		recordid = rs.fields("id")		
		viewstate = "view"
		'response.Redirect viewstate_value("REFURL")
	end if
	
	if viewstate="edit" then viewstate = "save"
	if viewstate="new" then viewstate = "savenew"
	
	function save_rs(rs)
		with rs
			.fields("mod_fasering") = checkboxvalue(fieldvalue(rs,"mod_fasering"))
			.fields("mod_memi") = checkboxvalue(fieldvalue(rs,"mod_memi"))
			.fields("mod_documents") = checkboxvalue(fieldvalue(rs,"mod_documents"))
			.fields("mod_fora") = checkboxvalue(fieldvalue(rs,"mod_fora"))
			.fields("mod_loting") = checkboxvalue(fieldvalue(rs,"mod_loting"))
		end with
		sec_setsecurityinfo rs 
		putrecordset rs 
	end function

	'Hier wordt de titel van het formulier bepaalt
	projects_header(recordid)
	f_header "Geef hier aan welke modules er beschikbaar zijn voor de kopers van dit project"
	f_form_hdr()
%>

<table style="" cellpadding="0" cellspacing="0" ID="Table1">
	<tr>
		 <td valign="top">
			<table style="" ID="Table3">
			    <tr>
			        <td class="r_head"><%=getlabel("module") %></td>
			        <td class="r_head"><%=getlabel("available") %></td>
			    </tr>
		        <%
                    f_checkbox rs,"mod_fasering","mod_fasering"		     
                    f_checkbox rs,"mod_memi","mod_memi"		     
                    f_checkbox rs,"mod_documents","mod_documents"		     
                    f_checkbox rs,"mod_fora","mod_fora"		     
                    f_checkbox rs,"mod_loting","mod_loting"		     
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
