<!-- #include file="../../templates/headers/content.asp" -->
<%
	f_header getlabel("hdr_user_roles")
%>
<div class=rolodex>
    <a href="e_sec_roles.asp?viewstate=new&amp;id=-1"><%=GetLabel("new")%></a>
</div>
<%	
	Dim sql, fields
	sql    = "select id,*,'x' as del from relsoo"
	fields = ""
	fields = fields & "$name:=id;type:=hidden;boundcolumn:=id;$"
	fields = fields & "$name:=aandat;type:=hidden;boundcolumn:=id;$"
	fields = fields & "$name:=aangeb;type:=hidden;boundcolumn:=id;$"
	fields = fields & "$name:=wijdat;type:=hidden;boundcolumn:=id;$"
	fields = fields & "$name:=wijgeb;type:=hidden;boundcolumn:=id;$"
	fields = fields & "$name:=soonaa;type:=link;url:=e_sec_roles.asp?viewstate=edit&id=~id~;label:=Rol;$" 
	fields = fields & "$name:=soobes;type:=text;label:=Omschrijving;$" 
	'fields = fields & "$name:=del;type:=delete;class:=relsoo;boundcolumn:=id;label:=delete;$" 
	r_list sql, fields, "soonaa"
%>
<!-- #include file="../../templates/footers/content.asp" -->
