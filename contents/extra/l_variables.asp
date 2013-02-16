<!-- #include file="../../templates/headers/content.asp" -->
<%
	f_header getlabel("hdr_variables")
	dim sql, fields, orderby
%>
<div style="width:100%" align=right >
	<a href="e_variables.asp?viewstate=new&id=-1"><%=getlabel("new")%></a>
</div>
<%	
	sql = "select *, 'x' as [del] from variables"
	fields = ""
	fields = fields & "$name:=id;type:=hidden;boundcolumn:=id;$"
	fields = fields & "$name:=created;type:=hidden;$"
	fields = fields & "$name:=createdby;type:=hidden;$"
	fields = fields & "$name:=edited;type:=hidden;$"
	fields = fields & "$name:=editedby;type:=hidden;$"
	fields = fields & "$name:=name;type:=link;url:=e_variables.asp?viewstate=edit&id=~id~;$"
	fields = fields & "$name:=del;type:=delete;class:=variables;boundcolumn:=id;label:=x;$"
	orderby = ""
	r_list sql, fields, orderby
	
%>
<!-- #include file="../../templates/footers/content.asp" -->
