<!-- #include file="../../templates/headers/content.asp" -->
<%
	f_header getlabel("hdr_status")
	dim sql, fields, orderby
%>
<div style="width:100%" align=right >
	<a href="e_status.asp?viewstate=new&id=-1"><%=getlabel("new")%></a>
</div>
<%	
	sql = "select * from status"
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
	fields = fields & "$name:=inreto_id;type:=hidden;$"
	fields = fields & "$name:=statusmail;type:=hidden;$"
	fields = fields & "$name:=boukop;type:=hidden;$"
	fields = fields & "$name:=default;type:=hidden;$"
	fields = fields & "$name:=stabes;type:=hidden;$"
	fields = fields & "$name:=stanaa;type:=link;url:=e_status.asp?viewstate=edit&id=~id~;$"
	orderby = "inreto, stanaa"
	r_list sql, fields, orderby
	
%>
<!-- #include file="../../templates/footers/content.asp" -->
