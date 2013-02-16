<!-- #include file="../../templates/headers/content.asp" -->
<%
	f_header getlabel("hdr_sec_modules")

	dim sql, fields, orderby
    sql = "select * from sec_modules where name not like '%.asp'"
    fields = ""
    fields = fields & "$name:=id;type:=hidden;boundcolumn:=id;$"
    fields = fields & "$name:=created;type:=hidden;$"
    fields = fields & "$name:=createdby;type:=hidden;$"
    fields = fields & "$name:=edited;type:=hidden;$"
    fields = fields & "$name:=editedby;type:=hidden;$"
    fields = fields & "$name:=aangeb;type:=hidden;$"
    fields = fields & "$name:=aandat;type:=hidden;$"
    fields = fields & "$name:=wijgeb;type:=hidden;$"
    fields = fields & "$name:=wijdat;type:=hidden;$"
    fields = fields & "$name:=name;type:=link;url:=e_sec_modules.asp?viewstate=edit&id=~id~;$"
    orderby = "name"
    
    f_header getlabel("hdr_sec_modules_normal")
    r_list sql, fields, orderby

    sql = "select * from sec_modules where name like '%.asp'"
    fields = ""
    fields = fields & "$name:=id;type:=hidden;boundcolumn:=id;$"
    fields = fields & "$name:=created;type:=hidden;$"
    fields = fields & "$name:=createdby;type:=hidden;$"
    fields = fields & "$name:=edited;type:=hidden;$"
    fields = fields & "$name:=editedby;type:=hidden;$"
    fields = fields & "$name:=aangeb;type:=hidden;$"
    fields = fields & "$name:=aandat;type:=hidden;$"
    fields = fields & "$name:=wijgeb;type:=hidden;$"
    fields = fields & "$name:=wijdat;type:=hidden;$"
    fields = fields & "$name:=name;type:=link;url:=e_sec_modules.asp?viewstate=edit&id=~id~;$"
    orderby = "name"
    
    f_header getlabel("hdr_sec_modules_special")
%> 
<div class='rolodex'>
    <a href="e_sec_modules.asp?viewstate=new&id=-1"><%=getlabel("new") %></a>
</div>
<%    
    r_list sql, fields, orderby

%>
<!-- #include file="../../templates/footers/content.asp" -->
