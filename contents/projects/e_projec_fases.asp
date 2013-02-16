<!-- #include file="../../templates/headers/content.asp" -->
<!-- #include file="functions.asp" -->
<%
	dim recordid, rs, sql, tablename
	
	viewstate = viewstate_value("viewstate")
	recordid  = viewstate_value("id")
	projec_id  = viewstate_value("projec_id")
	tablename = "projec_fases"
		
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
		rs.fields("fases_id") = 0
		sec_setsecurityinfo (rs)
	case else
		response.Write "invalid viewstate !!"
		response.end
	end select
	
	if viewstate = "save" or viewstate = "savenew" then	
		if ispostback() then
		
		    if not v_valid("^\w+",true,fieldvalue(rs,"fascod")) then v_addformerror "fascod"
		    if not v_valid("^\w+",true,fieldvalue(rs,"fasnaa")) then v_addformerror "fasnaa"
		    if not v_valid("^\d+$",true,fieldvalue(rs,"volgor")) then v_addformerror "volgor"
		
		    if projec_id = 0 then
			    if not v_valid("^\d+",true,projec_id) then v_addformerror "projec_id"
			else
			    'if not v_isdate(true,fieldvalue(rs,"datbeg")) then v_addformerror "datbeg"
			    'if not v_isdate(true,fieldvalue(rs,"datein")) then v_addformerror "datein"
			end if
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
		'response.Redirect viewstate_value("REFURL")
	end if
	
	if viewstate="edit" then viewstate = "save"
	if viewstate="new" then viewstate = "savenew"
	
	function save_rs(rs)
		with rs
			.fields("fascod") = fieldvalue(rs,"fascod")
			.fields("fasnaa") = fieldvalue(rs,"fasnaa")
			.fields("fasbes") = fieldvalue(rs,"fasbes")
			.fields("volgor") = fieldvalue(rs,"volgor")
			.fields("kleur") = left(fieldvalue(rs,"kleur"),6)
			.fields("datbeg") = convertdate(fieldvalue(rs,"datbeg"))
			.fields("datein") = convertdate(fieldvalue(rs,"datein"))			
			.fields("basis") = checkboxvalue(fieldvalue(rs,"basis"))
		end with
		sec_setsecurityinfo rs 
		putrecordset rs 
	end function

    if projec_id = 0 then
        f_header getlabel("projec_fases") & " :: " & rs.fields("fasnaa")
        %>
        <div class="f_remark">
        Let op! Dit is een fase in de basisset. Wijzigingen die u hier aanbrengt zullen in alle toekomstige projecten worden opgenomen.
        </div>
        <%
    else
	    projects_header(projec_id)
	end if    

	f_form_hdr()
	
%> 
<input type="hidden" id="projec_id" name="projec_id" value="<%=projec_id %>" />
<table style="" cellpadding="0" cellspacing="0" ID="Table1">
	<tr>
		<td valign="top">
			<table style="" ID="Table2">
				<%
		            f_textbox rs,"fascod","fascod","100%"
		            f_textbox rs,"fasnaa","fasnaa","100%"
		            f_textarea rs,"fasbes","fasbes","100%","40"
		            f_datebox rs,"datbeg","datbeg",120
		            f_datebox rs,"datein","datein",120
		            f_textbox rs,"volgor","volgor",80
		            f_textbox rs,"kleur","kleur",80
		            if projec_id = 0 then
                        f_checkbox rs,"basis","basis"
		            else
	                    f_checkbox rs,"tonen","basis"
		            end if    
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
