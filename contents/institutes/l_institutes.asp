<!-- #include file="../../templates/headers/content.asp" -->
<%
	f_header getlabel("hdr_institutes")
	dim sql, fields, orderby
%>
<div style="width:100%" align=right >
	<a href="e_institutes.asp?viewstate=new&id=-1"><%=getlabel("new")%></a>
</div>
<%	
	sql = "select * from institutes"
	fields = ""
	fields = fields & "$name:=id;type:=checkbox;boundcolumn:=id;$"
	fields = fields & "$name:=created;type:=hidden;$"
	fields = fields & "$name:=createdby;type:=hidden;$"
	fields = fields & "$name:=edited;type:=hidden;$"
	fields = fields & "$name:=editedby;type:=hidden;$"
	fields = fields & "$name:=name;type:=link;url:=e_institutes.asp?viewstate=edit&id=~id~;$"
	orderby = ""
	r_list sql, fields, orderby
	
%>
<!-- #include file="../../templates/footers/content.asp" -->
