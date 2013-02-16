<!-- #include file="../../templates/headers/content.asp" -->
<%
	f_header getlabel("hdr_classes")
	dim sql, fields, orderby
%>
<div style="width:100%" align=right >
	<a href="e_classes.asp?viewstate=new&id=-1"><%=getlabel("new")%></a>
</div>
<%	
	sql = "select * from classes"
	fields = ""
	fields = fields & "$name:=id;type:=hidden;boundcolumn:=id;$"
	fields = fields & "$name:=created;type:=hidden;$"
	fields = fields & "$name:=createdby;type:=hidden;$"
	fields = fields & "$name:=edited;type:=hidden;$"
	fields = fields & "$name:=editedby;type:=hidden;$"
	fields = fields & "$name:=name;type:=link;url:=e_classes.asp?viewstate=edit&id=~id~;$"
	orderby = ""
	r_list sql, fields, orderby
	
%>
<!-- #include file="../../templates/footers/content.asp" -->
