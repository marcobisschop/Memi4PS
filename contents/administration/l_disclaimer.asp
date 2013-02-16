<!-- #include file="../../templates/headers/content.asp" -->
<%
	f_header getlabel("hdr_disclaimer")
%>
<div class="rolodex">
    <a href="../extra/e_disclaimer.asp?viewstate=new&id=-1"><%=getlabel("new") %></a>
</div>
<%
	dim sql, fields
	sql = "select dsc_pk, dsc_name, dsc_body, dsc_available from disclaimer"
	fields = ""
	fields = fields & "$name:=dsc_pk;type:=hidden;$"
	fields = fields & "$name:=dsc_available;type:=hidden;$"
	fields = fields & "$name:=dsc_name;type:=link;url:=e_disclaimer.asp?viewstate=edit&dsc_pk=~dsc_pk~;$"
	orderby = "dsc_name"
	r_list sql, fields, orderby	
%>
<!-- #include file="../../templates/footers/content.asp" -->
