<!-- #include file="../../templates/headers/content.asp" -->
<%
	dim recordid, rs, sql, tablename
	
	viewstate = viewstate_value("viewstate")
	recordid  = viewstate_value("id")
	clatyp_id  = viewstate_value("clatyp_id")
	tablename = "clacat"
	
	if viewstate="" then viewstate = "new"
	if recordid = "" then recordid = -1
		
	select case lcase(viewstate)
	case "view"
		sql = "select * from [" & tablename & "] where id = " & recordid
		set rs = getrecordset(sql,false)
	case "edit","save", "change"
		sql = "select * from [" & tablename & "] where id = " & recordid
		set rs = getrecordset(sql,false)
		clatyp_id = rs.fields("clatyp_id")
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
			if not v_valid("^\w+",true,fieldvalue(rs,"code")) then v_addformerror "code"
			if not v_valid("^\d+$",true,fieldvalue(rs,"clatyp_id")) then v_addformerror "clatyp_id"
			if errorcount = 0 then 
					viewstate = "update"
			end if
		end if		
	end if
	
	response.write formerrors
	
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
			.fields("clatyp_id") = fieldvalue(rs,"clatyp_id")
			.fields("name") = fieldvalue(rs,"name")
			.fields("code") = fieldvalue(rs,"code")
			.fields("available") = checkboxvalue(fieldvalue(rs,"available"))
			'.fields("is_closed") = checkboxvalue(fieldvalue(rs,"is_closed"))
		end with
		sec_setsecurityinfo rs 
		putrecordset rs 
	end function

	f_header getlabel(tablename)
	
%>
    <div class=rolodex>
    <%
    sqlClatyp = "select id, name from clatyp order by name"
    set rsClatyp = getrecordset(sqlclatyp,true)
    with rsClatyp
        do until .eof
            response.write "<a href='?clatyp_id="&.fields("id")&"'>"&.fields("name")&"</a>"
            .movenext
            if not .eof then response.write "<span class='divider'>|</span>"
        loop
    end with
    set rsClatyp = nothing

    %>
    </div>
<% 
	if len(clatyp_id)>0 then
	
	f_form_hdr()
	
%>
<input type="hidden"  id="clatyp_id"  name="clatyp_id"  value="<%=clatyp_id %>" />
<table style="" cellpadding="0" cellspacing="0" ID="Table1">
	<tr>
		<td valign="top">
			<table style="" ID="Table2">
				<%
		            f_textbox rs,"name","name",400
		            f_textbox rs,"code","code",40
		            f_checkbox rs,"available","available"
		            'f_checkbox rs,"is_closed","is_closed"
                %>
             </table>					
         </td>
	</tr>
</table>
<%
	f_form_ftr()
	    sql = "select id, name, code, available, is_closed, 'x' as del from [" & tablename & "] where clatyp_id=" & clatyp_id
	    fields = "$name:=id;type:=hidden;$"
	    fields = fields & "$name:=name;type:=link;url:=?viewstate=edit&id=~id~;label:=edit;$"
	    fields = fields & "$name:=available;type:=bit;class:="&tablename&";field:=available;boundcolumn:=id;id:=~id~;$"
	    fields = fields & "$name:=is_closed;type:=hidden;class:="&tablename&";field:=is_closed;boundcolumn:=id;$"
	    fields = fields & "$name:=del;type:=delete;class:="&tablename&";boundcolumn:=id;id:=~id~;$"
	    orderby = "name"
	    r_list sql, fields, orderby
	end if
%>
</form> 

<!-- #include file="../../templates/footers/content.asp" -->
