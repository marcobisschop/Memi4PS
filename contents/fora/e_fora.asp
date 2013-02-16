<!-- #include file="../../templates/headers/content.asp" -->



<%
	dim recordid, rs, sql, tablename
	
	viewstate = viewstate_value("viewstate")
	recordid  = viewstate_value("id")
	projec_id  = viewstate_value("projec_id")


'response.write projec_id

	tablename = "fora"
		
	select case lcase(viewstate)
	case "view"
		sql = "select * from [" & tablename & "] where id = " & recordid
		set rs = getrecordset(sql,false)
	case "edit","save", "change"
		sql = "select * from [" & tablename & "] where id = " & recordid
		set rs = getrecordset(sql,false)
		if viewstate="save" then
		    projec_id  = rs.fields("projec_id")
		else 
		    projec_id = -1
		end if
	case "new","savenew"
		sql = "select * from [" & tablename & "] where id = -1"
		set rs = getrecordset(sql,false)
		rs.addnew
		rs.fields("projec_id") = projec_id
		'sec_setsecurityinfo (rs)
	case else
		response.Write "invalid viewstate !!" & viewstate
		response.end
	end select
	
	if viewstate = "save" or viewstate = "savenew" then	
		if ispostback() then
			if not v_valid("^\w+",true,fieldvalue(rs,"name")) then v_addformerror "name"
			'if not v_valid("^\d+$",true,projec_id) then v_addformerror "projec_id"
			if errorcount = 0 then 
					viewstate = "update"
			end if
		end if		
	end if
	
	if viewstate = "update" then 
		save_rs rs
		recordid = rs.fields("id")		
		viewstate = "view"
		response.Redirect viewstate_value("REFURL")
	end if
	
	if viewstate="edit" then viewstate = "save"
	if viewstate="change" and projec_id=-1 then 
	    viewstate="savenew" 
	elseif viewstate="change" and projec_id>-1 then 
	    viewstate = "save"
	end if
	if viewstate="new" then viewstate = "savenew"
	
	function save_rs(rs)
		with rs
			.fields("name") = fieldvalue(rs,"name")
			.fields("projec_id") = fieldvalue(rs,"projec_id")
			.fields("projec_fases_id") = fieldvalue(rs,"projec_fases_id")
			.fields("status") = fieldvalue(rs,"status")
			.fields("closed") = checkboxvalue(fieldvalue(rs, "closed"))
			.fields("basis") = checkboxvalue(fieldvalue(rs, "basis"))
		end with
		sec_setsecurityinfo rs 
		putrecordset rs 
	end function

	f_header getlabel("hdr_fora")
%>
    <div class=rolodex>
    <a href="forum.asp?viewstate=new&fora_id=<%=recordid %>"><%=getlabel("goto_forum") %></a><span class="menu_divider">|</span> 
    <a href="e_fora.asp?viewstate=new&amp;id=-1&projec_id=0"><%=GetLabel("new")%></a>
    </div>
   <div class="f_remark">
   Een forum wordt gebruikt om binnen een projectfase gezamenlijk over een onderwerp te discusseren en 
   op basis van de discussie eventueel een besluit te nemen. In een gesloten forum kunnen geen reacties meer worden 
   geplaatst. Het veld basis geeft aan dat het forum in elk nieuw project wordt opgenomen.
   </div> 
<% 
	f_form_hdr()
	
%>
<table style="" cellpadding="0" cellspacing="0" ID="Table1">
	<tr>
		<td valign="top">
			<table style="" ID="Table2">
				<%
		            f_textbox rs,"name","name",400
		            projec_id = f_listbox (rs,"projec_id","projec_id","select * from vw_projec order by pronaa","id","pronaa","200","change()")
		            
		            if projec_id = -1 then
		                f_listbox rs,"projec_fases_id","projec_fases_id","select * from vw_projec_fases where projec_id=" & projec_id & " order by volgor","id","fasnaa","200",""
		            else
                        %><input type="hidden" name="projec_fases_id" value="-1"><%		                
		            end if
                    f_checkbox rs,"closed","closed"
                    f_checkbox rs,"basis","basis"
                    f_listbox rs,"status","status","select * from status where inreto='fora' order by stanaa","id","stanaa","200",""

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
