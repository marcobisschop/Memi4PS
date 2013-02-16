<!-- #include file="../../templates/headers/content.asp" -->
<%
	f_header getlabel("hdr_projec_fases")	
%>
<div class="rolodex">
    <a href="e_projec_fases.asp?viewstate=new&projec_id=0"><%=getlabel("new")%></a>
</div>
<%
	dim rs, sql, myLetter, myLetters
	
    sql = "select *, 'stappen' as steps from projec_fases where projec_id=0"
	
	dim fieldlist, orderby
	fields = ""
	fields = fields & "$name:=id;type:=hidden;boundcolumn:=id;$"
	fields = fields & "$name:=projec_id;type:=hidden;boundcolumn:=id;$"
	fields = fields & "$name:=fases_id;type:=hidden;boundcolumn:=id;$"
	fields = fields & "$name:=createdby;type:=hidden;$"
	fields = fields & "$name:=created;type:=hidden;$"
	fields = fields & "$name:=editedby;type:=hidden;$"
	fields = fields & "$name:=edited;type:=hidden;$"
	fields = fields & "$name:=datbeg;type:=hidden;$"
	fields = fields & "$name:=datein;type:=hidden;$"
	fields = fields & "$name:=fasbes;type:=hidden;$"
	fields = fields & "$name:=kleur;type:=color;$"
	fields = fields & "$name:=fascod;type:=link;url:=e_projec_fases.asp?viewstate=view&id=~id~;$"
	fields = fields & "$name:=steps;type:=link;url:=l_fases_steps.asp?viewstate=view&fases_id=~id~&projec_id=~projec_id~;$"
	fields = fields & "$name:=basis;type:=bit;class:=projec_fases;field:=basis;id:=~id~;$"
	fields = fields & "$name:=volgor;type:=order;class:=projec_fases;field:=volgor;id:=~id~;$"
	
	orderby = "volgor"
	
	r_list sql, fields, orderby
%>
<!-- #include file="../../templates/footers/content.asp" -->
