<!-- #include file="../../templates/headers/content.asp" -->
<%
	f_header getlabel("hdr_distinctives")
	dim sql, fields, orderby, inreto
	inreto = viewstate_value("inreto")
%>
<div class="rolodex">
<%
    dim rs
    sql = "select distinct inreto from distinctives order by [inreto]"
    set rs = getrecordset(sql,true)            
    with rs
        if .eof then
            response.write getlabel("no_distinctivegroups")
        else
            do until .eof
                %><a href="?inreto=<%=.fields("inreto") %>"><%=getlabel(.fields("inreto")) %></a><%
                .movenext
                if not .eof then response.Write "&nbsp;|&nbsp;"
            loop                    
        end if    
    end with
    set rs = nothing
%>
    <hr>
	<a href="e_distinctives.asp?viewstate=new&id=-1&inreto=<%=inreto %>"><%=getlabel("new")%></a>
</div>
<%	
	sql = "select * from distinctives where inreto='" & inreto & "'"
	fields = ""
	fields = fields & "$name:=id;type:=hidden;boundcolumn:=id;$"
	fields = fields & "$name:=created;type:=hidden;$"
	fields = fields & "$name:=createdby;type:=hidden;$"
	fields = fields & "$name:=edited;type:=hidden;$"
	fields = fields & "$name:=editedby;type:=hidden;$"
	fields = fields & "$name:=name;type:=link;url:=e_distinctives.asp?viewstate=edit&id=~id~;$"
	orderby = "name"
	r_list sql, fields, orderby
	
%>
<!-- #include file="../../templates/footers/content.asp" -->
