<!-- #include file="../../templates/headers/content.asp" -->
<%
	dim recordid, rs, sql, tablename
	
	viewstate = viewstate_value("viewstate")
	recordid  = viewstate_value("id")
	tablename = "sec_modules"
	
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
			'if not v_valid("^\w",true,fieldvalue(rs,"name")) then v_addformerror "name"
			if errorcount = 0 then 
					viewstate = "update"
			end if
		end if		
	end if
	
	'response.Write viewstate
	'response.Write formerrors
	
	if viewstate = "update" then 
		save_rs rs
		recordid = rs.fields("id")		
		viewstate = "edit"
		response.Redirect "l_sec_modules.asp"
	end if
	
	if viewstate="edit" then viewstate = "save"
	if viewstate="new" then viewstate = "savenew"
	
	function save_rs(rs)
		with rs
		    .fields("name") = fieldvalue(rs,"name")
		    .fields("description") = fieldvalue(rs,"description")
		
			dim fld, sqlRights
			sqlRights = "update sec_roles_modules set can_read=0, can_write=0, can_delete=0 where sec_modules_id=" & recordid & ";" 
			for each fld in uploader.FormElements
		        if left(fld,4) = "can_" then
		            rights = split(fld,"_")
		            sqlRights =  sqlRights & "update sec_roles_modules set [" & rights(0) & "_" & rights(1) & "]=1 where sec_roles_id=" & rights(2) & " and sec_modules_id=" & rights(3) & ";"
		            'response.write sqlRights
		        else
    		        'ander veld, niks doen
    	        end if	    
			next
            executesql sqlRights			
        end with
		sec_setsecurityinfo rs 
		putrecordset rs 
	end function
	
	f_header getlabel("hdr_module") & rs.fields("name") & " (" & rs.fields("id") & ")"
	f_form_hdr()
%>
<table style="" cellpadding=0 cellspacing=0 ID="Table1">
	<tr>
		<td valign="top">
			<table style="" ID="Table2">
				<%
					f_textbox rs,"name","name","450"
					f_textarea rs,"description","description","450","120"
				%>
			</table>
		</td>
	</tr>
	<tr>
		<td valign="top">
<%
    if viewstate="save" then
  
  f_header getlabel("module_rights")
  
    sql = "select id, " & recordid & " as module, soonaa, soobes from relsoo order by soonaa"
    set rs = getrecordset(sql, true) 
    with rs
        %>
        <table style="width:600px;">
                <tr>
                    <td class="r_head"><%=getlabel("sec_roles")%></td>
                    <td align="center" class="r_head"><%=getlabel("can_read")%></td>
                    <td align="center" class="r_head"><%=getlabel("can_write")%></td>
                    <td align="center" class="r_head"><%=getlabel("can_delete")%></td>
                </tr>
        <% 
        do until .eof
            %>
                <tr>
                    <td class="f_item_label"><table><tr><td><%=.fields("soobes") & "</td><td align='right'>" & .fields("id") %></td></tr></table></td>
                    <td align="center" class="f_item_field"><%=createChecker(rs,"can_read") %></td>
                    <td align="center" class="f_item_field"><%=createChecker(rs,"can_write") %></td>
                    <td align="center" class="f_item_field"><%=createChecker(rs,"can_delete") %></td>
                </tr>
            <%
            .movenext
        loop
        %>
        </table>
        <%
    end with  
    set rs = nothing 
   
   function createChecker(rs,field)
        %>
        <input type="checkbox" id="<%=field & "_" & rs.fields("id") & "_" & rs.fields("module") %>" name="<%=field & "_" & rs.fields("id") & "_" & rs.fields("module") %>" <%=SetChecked(rs.fields("id"),rs.fields("module"),field) %> />
        <%
   end function
    
%>
<%
    end if
%>
       </td>
    </tr> 
</table>
<hr />
<% 
    f_form_ftr()
   
   function SetChecked(sec_roles_id,sec_modules_id, field)
        dim sql, rs
        sql = "select [" & field & "] from sec_roles_modules where sec_roles_id=" & sec_roles_id & " and sec_modules_id=" & sec_modules_id
        set rs = getrecordset(sql, true)
        if rs.recordcount = 1 then
            if rs.fields(field) then 
                SetChecked = "CHECKED" 
            else 
                SetChecked = ""
            end if
        else
            sql = "insert into sec_roles_modules (sec_roles_id,sec_modules_id,can_read,can_write,can_delete) values (" & sec_roles_id & "," & sec_modules_id & ",0,0,0)"
            executesql sql
            SetChecked = ""
        end if
        set rs = nothing
   end function 
%>


<!-- #include file="../../templates/footers/content.asp" -->
