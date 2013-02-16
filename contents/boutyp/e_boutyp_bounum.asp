<!-- #include file="../../templates/headers/content.asp" -->
<!-- #include file="functions.asp" -->
<%
	dim recordid, rs, sql, tablename, projec_id
	
	viewstate = viewstate_value("viewstate")
	recordid  = viewstate_value("id")
	
	projec_id = DBLookup ("boutyp", "id", recordid, "projec_id")
	boutyp_header recordid, projec_id
%>
<div class="rolodex">
    <a href="../bounum/e_bounum.asp?viewstate=new&id=-1&boutyp_id=<%=recordid%>&projec_id=<%=projec_id %>"><%=getlabel("new") %></a>
</div>
<%
    sql = "select * from vw_bounum where boutyp_id=" & recordid & ""
    fields = "$name:=id;type:=hidden;$"
    fields = fields & "$name:=bounum_id;type:=hidden;$"
    fields = fields & "$name:=kopers;type:=hidden;$"
    fields = fields & "$name:=projec_id;type:=hidden;$"
    fields = fields & "$name:=boutyp_id;type:=hidden;$"
    fields = fields & "$name:=koobes;type:=hidden;$"
    fields = fields & "$name:=bounum;type:=hidden;$"
    fields = fields & "$name:=pronaa;type:=hidden;$"
    fields = fields & "$name:=ord;type:=hidden;$"
    fields = fields & "$name:=extnum;type:=link;url:=../bounum/e_bounum.asp?viewstate=view&id=~bounum_id~;$"
    r_list sql, fields, "ord"

%>
<!-- #include file="../../templates/footers/content.asp" -->
