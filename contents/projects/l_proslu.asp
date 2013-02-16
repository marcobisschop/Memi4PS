<!-- #include file="../../templates/headers/content.asp" -->
<!-- #include file="functions.asp" -->
<%
	dim recordid, rs, sql, tablename
	
	viewstate = viewstate_value("viewstate")
	recordid  = viewstate_value("id")
	projec_id  = viewstate_value("projec_id")
	tablename = "proslu"
		
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
		    if not v_valid("^\w+",true,fieldvalue(rs,"slunaa")) then v_addformerror "slunaa"
		    if not v_valid("^\d+$",true,fieldvalue(rs,"projec_id")) then v_addformerror "projec_id"
		    if not v_valid("^\d+$",true,fieldvalue(rs,"slucat_id")) then v_addformerror "slucat_id"
		    if not v_isdate(true,fieldvalue(rs,"datum")) then v_addformerror "datum"
		    if errorcount = 0 then 
					viewstate = "update"
			end if
		end if		
	end if
	
	if viewstate = "update" then 
		save_rs rs
		recordid = rs.fields("id")		
		viewstate = "view"
		response.Redirect "/contents/projects/l_proslu.asp?viewstate=new&id="&projec_id&"&projec_id="&projec_id
	end if
	
	if viewstate="edit" then viewstate = "save"
	if viewstate="new" then viewstate = "savenew"
	
	function save_rs(rs)
		with rs
		    .fields("slunaa") = fieldvalue(rs,"slunaa")
			.fields("slucat_id") = fieldvalue(rs,"slucat_id")
			.fields("projec_id") = fieldvalue(rs,"projec_id")
			.fields("datum") = DateToISO(fieldvalue(rs,"datum"))
		end with
		sec_setsecurityinfo rs 
		putrecordset rs 
	end function

    projects_header(projec_id)
	
	f_form_hdr()
	
	if viewstate="savenew" then
	    f_header "Maak een nieuwe sluitingsdatum aan door onderstaande velden in te vullen"
	else
	    f_header "Wijzig de door u geslecteerde sluitingsdatum en druk op opslaan"
	end if
	
%>
<input type="hidden" id="projec_id" name="projec_id" value="<%=projec_id %>" />
<table style="" cellpadding="0" cellspacing="0" ID="Table1">
	<tr>
		<td valign="top">
			<table style="" ID="Table2">
				<%
		            f_textbox rs,"slunaa","slunaa",200
		            f_listbox rs,"slucat","slucat_id","select id, catnaa from slucat order by catnaa","id","catnaa","",""
		            f_datebox rs,"datum","datum",80
                %>
             </table>					
         </td>
	</tr>
</table>
<%
	f_form_ftr()
%>
</form> 
<hr />
<%
    f_header "Selecteer een sluitignsdatum om te wijzigen"
    sql = "select *, 'x' as del from vw_proslu where projec_id = " & projec_id & " order by slunaa, datum"
    fields = ""
    fields = fields & "$name:=proslu_id;type:=hidden;$"
	fields = fields & "$name:=slucat_id;type:=hidden;$"
	fields = fields & "$name:=projec_id;type:=hidden;$"
	fields = fields & "$name:=slunaa;type:=link;url:=?viewstate=edit&id=~proslu_id~&projec_id=~projec_id~;label:=" & getlabel("edit") & ";$"
	fields = fields & "$name:=del;type:=delete;class:=proslu;boundcolumn:=proslu_id;$"
	
    r_list sql, fields, "noorder"
%>
<!-- #include file="../../templates/footers/content.asp" -->
