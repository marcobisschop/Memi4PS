<!-- #include file="../../templates/headers/content.asp" -->
<%
    f_header getlabel("hdr_correspondence_fields")
%> 
<div class="rolodex">
<a href="e_correspondence_fields.asp?viewstate=new&id=-1"><%=getlabel("new") %></a>
</div>
<%
	Dim sql, fields
	sql    = "select id, field, value from correspondence_fields"
	fields = "$name:=id;type:=hidden;$"
	fields = fields & "$name:=value;type:=text;label:=Waarde;$"
	fields = fields & "$name:=field;type:=link;url:=e_correspondence_fields.asp?viewstate=edit&id=~id~;label:=Veldnaam;$" 
	r_list sql, fields, "field"
%>

<!-- #include file="../../templates/footers/content.asp" -->