<!-- #include file="../../templates/headers/content.asp" -->
<!-- #include file="functions.asp" -->
<%
	dim recordid, rs, sql, tablename
	
	viewstate = viewstate_value("viewstate")
	recordid  = viewstate_value("id")
	
	projects_header(recordid)
%>
<div class="rolodex">
    <a href="../bounum/e_bounum.asp?viewstate=new&id=-1&boutyp_id=-1&projec_id=<%=recordid %>"><%=getlabel("new") %></a>
</div>
<%	
    sql = "select *, 'memi' as me_mi, 'koperslijst'  as koperslijst, 'documentatie' as documentatie,  'x' as del from vw_bounum where projec_id=" & recordid & ""
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
    fields = fields & "$name:=xy;type:=link;url:=../bounum/e_bounum_projec_plagro_loting.asp?viewstate=view&id=~bounum_id~;$"
    fields = fields & "$name:=del;type:=delete;class:=bounum;boundcolumn:=bounum_id;id:=~bounum_id~;$"
    
    fields = fields & "$name:=me_mi;type:=link;url:=/contents/memi/l_keuzen.asp?viewstate=view&id=1078&keusoo_soonaa=B&koppel_id=~bounum_id~;$"
    fields = fields & "$name:=koperslijst;type:=link;url:=/deelnemer/keuzen/default.asp?mode=kpb&viewstate=view&id=~bounum_id~;$"
    fields = fields & "$name:=documentatie;type:=link;url:=/contents/bounum/e_pictures.asp?viewstate=view&id=~bounum_id~&inreto=bounum&inreto_id=~bounum_id~;$"
    
    r_list sql, fields, "ord"

%>
<!-- #include file="../../templates/footers/content.asp" -->
