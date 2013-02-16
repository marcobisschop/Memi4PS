<!-- #include file="../../templates/headers/content.asp" -->
<!-- #include file="functions.asp" -->
<%
	dim recordid, rs, sql, tablename
	
	viewstate = viewstate_value("viewstate")
	recordid  = viewstate_value("id")
	bounum_id  = viewstate_value("bounum_id")
	projec_id = DBLookup ("bounum", "id", bounum_id, "projec_id")
	
	tablename = "bouslu"
		
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
		rs.fields("bounum_id") = bounum_id		
		sec_setsecurityinfo (rs)
	case else
		response.Write "invalid viewstate !!"
		response.end
	end select
	
	if viewstate = "save" or viewstate = "savenew" then	
		if ispostback() then
		    if not v_valid("^\d+$",true,fieldvalue(rs,"proslu_id")) then v_addformerror "proslu_id"
		    if not v_valid("^\d+$",true,fieldvalue(rs,"slucat_id")) then v_addformerror "slucat_id"
		    if errorcount = 0 then 
					viewstate = "update"
			end if
		end if		
	end if
	
	if viewstate = "update" then 
		save_rs rs
		recordid = rs.fields("id")		
		viewstate = "view"
		' response.Redirect viewstate_value("REFURL")
	end if
	
	if viewstate="edit" then viewstate = "save"
	if viewstate="new" then viewstate = "savenew"
	
	function save_rs(rs)
		with rs
		    .fields("slucat_id") = fieldvalue(rs,"slucat_id")
			.fields("proslu_id") = fieldvalue(rs,"proslu_id")
		end with
		sec_setsecurityinfo rs 
		putrecordset rs 
	end function

    bounum_header(bounum_id)
	
	f_form_hdr()
	
%>
<input type="hidden" id="bounum_id" name="bounum_id" value="<%=bounum_id %>" />
<table style="" cellpadding="0" cellspacing="0" ID="Table1">
	<tr>
		<td valign="top">
			<table style="" ID="Table2">
				<%
		            f_listbox rs,"slucat","slucat_id","select id, catnaa from slucat order by catnaa","id","catnaa","",""
		            f_listbox rs,"proslu","proslu_id","select proslu_id, slunaa from vw_proslu where projec_id = " & projec_id & " order by slunaa","proslu_id","slunaa","",""
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
    sql = "select *, 'x' as del, bouslu_id as id from vw_bouslu where bounum_id = " & bounum_id & " order by datum"
    fields = ""
    fields = fields & "$name:=bouslu_id;type:=hidden;$"
	fields = fields & "$name:=id;type:=hidden;$"
	fields = fields & "$name:=bounum_id;type:=hidden;$"
	fields = fields & "$name:=slucat_id;type:=hidden;$"
	fields = fields & "$name:=projec_id;type:=hidden;$"
	fields = fields & "$name:=slunaa;type:=link;url:=?viewstate=edit&id=~bouslu_id~&bounum_id=~bounum_id~;label:=" & getlabel("edit") & ";$"
	fields=  fields & "$name:=del;type:=delete;class:=bouslu;boundcolumn:=id;id:=~bouslu_id~;$"
    r_list sql, fields, "noorder"
%>
<!-- #include file="../../templates/footers/content.asp" -->
