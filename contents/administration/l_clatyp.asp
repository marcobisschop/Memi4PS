<!-- #include file="../../templates/headers/content.asp" -->
<%
	dim recordid, rs, sql, tablename
	
	viewstate = viewstate_value("viewstate")
	recordid  = viewstate_value("id")
	tablename = "clatyp"
	
	if viewstate="" then viewstate = "new"
	if recordid = "" then recordid = -1
		
	select case lcase(viewstate)
	case "view"
		sql = "select * from [" & tablename & "] where id = " & recordid
		set rs = getrecordset(sql,false)
	case "edit","save", "change"
		sql = "select * from [" & tablename & "] where id = " & recordid
		set rs = getrecordset(sql,false)
	case "new","savenew"
		sql = "select * from [" & tablename & "] where id = -1"
		set rs = getrecordset(sql,false)
		rs.addnew
		sec_setsecurityinfo (rs)
	case else
		response.Write "invalid viewstate !!" & viewstate
		response.end
	end select
	
	if viewstate = "save" or viewstate = "savenew" then	
		if ispostback() then
			if not v_valid("^\w+",true,fieldvalue(rs,"name")) then v_addformerror "name"
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
	if viewstate="new" then viewstate = "savenew"
	
	function save_rs(rs)
		with rs
			.fields("name") = fieldvalue(rs,"name")
			.fields("available") = checkboxvalue(fieldvalue(rs,"available"))
		end with
		sec_setsecurityinfo rs 
		putrecordset rs 
	end function

	f_header getlabel(tablename)
%>
    <div class=rolodex>
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
		            f_checkbox rs,"available","available"
                %>
             </table>					
         </td>
	</tr>
</table>
<%
	f_form_ftr()
	
	sql = "select id, name, available,'"&getlabel("clasta")&"' as clasta,'"&getlabel("clacat")&"' as clacat  from [" & tablename & "]"
	fields = "$name:=id;type:=hidden;$"
	fields = fields & "$name:=name;type:=link;url:=?viewstate=edit&id=~id~;label:=edit;"
	fields = fields & "$name:=available;type:=bit;class:="&tablename&";field:=available;boundcolumn:=id;id:=~id~;$"
	fields = fields & "$name:=clasta;type:=link;url:=l_clasta.asp?caltyp_id=~id~;$"
	fields = fields & "$name:=clatyp;type:=link;url:=l_clatyp.asp?caltyp_id=~id~;$"
	orderby = "name"
	r_list sql, fields, orderby
%>
</form> 

<!-- #include file="../../templates/footers/content.asp" -->
