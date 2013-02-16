<!-- #include file="../../templates/headers/content.asp" -->
<!-- #include file="functions.asp" -->
<%
	dim recordid, rs, sql, tablename
	
	viewstate = viewstate_value("viewstate")
	recordid  = viewstate_value("id")
	
	projects_header(recordid)

%>
<div class="rolodex">
    <a href="../boutyp/e_boutyp.asp?viewstate=new&id=-1&projec_id=<%=recordid%>"><%=getlabel("new") %></a>
</div>
<%

    sql = "select *,'bouwnummers' as bouwnummers,'woonwensen'as woonwensen, 'x' as del from vw_boutyp where  projec_id=" & recordid
    fields = "$name:=id;type:=hidden;$"
    fields = fields & "$name:=boutyp_id;type:=hidden;$"
    fields = fields & "$name:=projec_id;type:=hidden;$"
    fields = fields & "$name:=aandat;type:=hidden;$"
	fields = fields & "$name:=aangeb;type:=hidden;$"
	fields = fields & "$name:=wijdat;type:=hidden;$"
	fields = fields & "$name:=wijgeb;type:=hidden;$"
	fields = fields & "$name:=typnaa;type:=link;url:=../boutyp/e_boutyp.asp?viewstate=view&id=~boutyp_id~&projec_id=~projec_id~;$"
    fields = fields & "$name:=bouwnummers;type:=link;url:=/contents/boutyp/e_boutyp_bounum.asp?viewstate=view&id=~boutyp_id~;$"
    fields = fields & "$name:=woonwensen;type:=link;url:=/contents/memi/l_keuzen.asp?viewstate=view&id=~boutyp_id~&keusoo_soonaa=W&koppel_id=~boutyp_id~&projec_id=~projec_id~;$"
    fields = fields & "$name:=del;type:=delete;class:=boutyp;boundcolumn:=boutyp_id;$"
    r_list sql, fields, "typnaa"

%>
<!-- #include file="../../templates/footers/content.asp" -->
