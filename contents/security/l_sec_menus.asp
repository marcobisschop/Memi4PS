<!-- #include file="../../templates/headers/content.asp" -->
<%
	f_header getlabel("mi_menus")
	dim sql, fields, orderby

    sql = "select * from sec_applications where enabled=1 order by name"
    set rs = getrecordset(sql, true)
%>
    <div class=rolodex>
<% 
    with rs
        if not .eof then response.write getlabel("applicatie") & ": "
        do until .eof
            response.Write "<a href='?application_id=" & .fields("id") & "'>" 
            response.Write .fields("name")
            response.Write "</a>"
            .movenext
            if not .eof then response.Write "<span class='divider'>|</span>"
        loop
    end with
    
    set rs = nothing

	dim application_id
	application_id = viewstate_value("application_id")
	if cint(application_id) > 0 then
        %> 
            <hr />
            <a href="e_sec_menus.asp?viewstate=new&amp;id=-1&application_id=<%=application_id%>"><%=GetLabel("new")%></a>
            </div>
        <%
	    dim action, direction, parentid, id
	    action    = viewstate_value("action")
	    direction = viewstate_value("direction")
	    parentid  = viewstate_value("parentid")
	    id        = viewstate_value("id")
    	
	    select case lcase(action)
	    case "order"
		    sql		= "select * from sec_menus where sec_applications_id=" & application_id & " and parentid=" & parentid & " order by [order]"
		    set rs	= getrecordset(sql,false)
		    do until clng(rs.fields("id")) = clng(id) or rs.eof
			    rs.movenext
		    loop
		    order = rs.fields("order")
		    select case lcase(direction)
		    case "up"
			    rs.moveprevious
			    if not rs.bof then
				    rs.fields("order") = order
				    rs.movenext
				    rs.fields("order") = order - 1
			    end if
    			
		    case "down"
			    rs.movenext
			    if not rs.eof then
				    rs.fields("order") = order
				    rs.moveprevious
				    rs.fields("order") = order + 1
			    end if
		    end select
		    putrecordset rs
		    set rs = nothing
	    case else
	    end select

	    sql = "select * from sec_menus where parentid<=0 and sec_applications_id=" & application_id & " order by [order]"
	    set rs = getrecordset(sql,true)
    	
	    with rs
		    if .eof then
		    else
			    %>
			    <div style="padding-left:20 px;">
			    <table style="width:200px;"><tr>
			    <%
				    r_menu rs,0
			    %>
			    </table>
			    </div>
			    <%
		    end if
	    end with
    	
	end if
	
	function r_menu(rs,level)
		dim rssub
		if not rs.eof then
			%>
			<tr>
			<%
				for i = 1 to level
				%>
					<td align="right">&nbsp;</td>
				<%				
				next
				%>
					<td colspan nowrap>
					<a title="up" href="l_sec_menus.asp?application_id=<%=rs.fields("sec_applications_id") %>&action=order&amp;direction=up&amp;parentid=<%=rs.fields("parentid")%>&amp;id=<%=rs.fields("id")%>"><img SRC="../../images/buttons/i.p.sort.asc.gif" style="border=0"></a>
					<a title="down" href="l_sec_menus.asp?application_id=<%=rs.fields("sec_applications_id") %>&action=order&amp;direction=down&amp;parentid=<%=rs.fields("parentid")%>&amp;id=<%=rs.fields("id")%>"><img SRC="../../images/buttons/i.p.sort.desc.gif" style="border=0"></a>
					<a href="e_sec_menus.asp?application_id=<%=rs.fields("sec_applications_id") %>&viewstate=edit&amp;parentid=<%=rs.fields("parentid")%>&amp;id=<%=rs.fields("id")%>"><%=getlabel(rs.fields("name"))%></a>&nbsp;
					(<a href="../../include/delete.asp?class=sec_menus&id=<%=rs.fields("id")%>"><%=getlabel("x")%></a>)
					</td>
				</tr>
				<%				
				set rssub = getrecordset("select * from sec_menus where parentid=" & rs.fields("id") & " and sec_applications_id=" & application_id & " order by [order]",true)
				r_menu rssub,level + 1
				parentid = rs.fields("parentid")
			rs.movenext
			if rs.eof then
			%>
				<tr>
			<%
			for i = 1 to level
			%>
				<td colspan align="right">&nbsp;</td>
			<%				
			next
			%>
				<td valign="top"><a href="e_sec_menus.asp?viewstate=new&amp;application_id=<%=application_id %>&parentid=<%=parentid%>&amp;id=-1"><%=getlabel("new")%></a></td>
			</tr>
			<%
			end if
			
			r_menu rs,level			
		end if
		set rssub = nothing
	end function	
%>
<!-- #include file="../../templates/footers/content.asp" -->
