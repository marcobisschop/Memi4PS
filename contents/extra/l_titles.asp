<!-- #include file="../../templates/headers/content.asp" -->
<%
	f_header getlabel("hdr_aanhef")
%>
<div class="rolodex">
    <a href="e_titles.asp?viewstate=new&id=-1"><%=getlabel("new") %></a>
</div>
<%
	dim sql, fields
	sql = "select id,'-' + aannaa as aannaa,aanbes from aanhef"
	fields = ""
	fields = fields & "$name:=id;type:=hidden;boundcolumn:=id;$"
	fields = fields & "$name:=created;type:=hidden;$"
	fields = fields & "$name:=createdby;type:=hidden;$"
	fields = fields & "$name:=edited;type:=hidden;$"
	fields = fields & "$name:=editedby;type:=hidden;$"
	fields = fields & "$name:=aandat;type:=hidden;$"
	fields = fields & "$name:=aangeb;type:=hidden;$"
	fields = fields & "$name:=wijdat;type:=hidden;$"
	fields = fields & "$name:=wijgeb;type:=hidden;$"
	fields = fields & "$name:=aannaa;type:=link;url:=e_titles.asp?viewstate=edit&id=~id~;$"
	orderby = "aannaa"
	r_list sql, fields, orderby	
%>
<!-- #include file="../../templates/footers/content.asp" -->
