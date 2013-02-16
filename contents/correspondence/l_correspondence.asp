<!-- #include file="../../templates/headers/content.asp" -->
<%
    dim reflects
    reflects = viewstate_value("reflects")
    f_header getlabel("hdr_correspondence")
%>
<div class="rolodex">
<%
    dim rs
    sql = "select distinct [reflects] as reflects from correspondence order by [reflects]"
    set rs = getrecordset(sql,true)            
    with rs
        if .eof then
            response.write getlabel("no_correspondence")
        else
            do until .eof
                %><a href="?reflects=<%=.fields("reflects") %>"><%=getlabel(.fields("reflects")) %></a><%
                .movenext
                if not .eof then response.write " "
            loop                    
        end if    
    end with
    set rs = nothing
%>
    <hr>
    <a href="e_correspondence.asp?viewstate=new&amp;id=-1&reflects=<%=reflects %>"><%=getlabel("new") %></a>
</div>
<%
	Dim sql, fields
	sql    = "select id,name from correspondence where reflects='" & reflects & "'"
	fields = "$name:=id;type:=hidden;$"
	fields = fields & "$name:=name;type:=link;url:=e_correspondence.asp?viewstate=view&id=~id~;label:=correspondence_name;$" 
	r_list sql, fields, "name"
%>
<!-- #include file="../../templates/footers/content.asp" -->