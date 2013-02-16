<!-- #include file="../../templates/headers/content.asp" -->
<!-- #include file="functions.asp" -->
<%
	dim recordid, rs, sql, tablename
	recordid  = viewstate_value("projec_id")
	'Hier wordt de titel van het formulier bepaalt
	projects_header(recordid)
%>
<div class="rolodex">
    <a href="e_projec_plagro_loting.asp?viewstate=new&id=-1&projec_id=<%=recordid%>"><%=getlabel("new") %></a>
</div>
<%
    sql = "select id, beschrijving, status, volgor, 'x' as del from vw_projec_plagro_loting where projec_id=" & recordid
    fields = "$name:=id;type:=hidden;$"
    fields = fields & "$name:=created;type:=hidden;$"
    fields = fields & "$name:=createdby;type:=hidden;$"
    fields = fields & "$name:=edited;type:=hidden;$"
    fields = fields & "$name:=editedby;type:=hidden;$"
    fields = fields & "$name:=projec_id;type:=hidden;$"
    fields = fields & "$name:=beschrijving;type:=link;url:=e_projec_plagro_loting.asp?viewstate=view&id=~id~;$"
	fields = fields & "$name:=del;type:=delete;class:=projec_plagro_loting;boundcolumn:=id;$"
	
	r_list sql, fields, "volgor"
%>
<!-- #include file="../../templates/footers/content.asp" -->
