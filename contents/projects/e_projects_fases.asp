<!-- #include file="../../templates/headers/content.asp" -->
<!-- #include file="functions.asp" -->
<%
    projec_id  = viewstate_value("projec_id")
	projects_header(projec_id)	
%>
<div class="rolodex">
    <a href="e_projec_fases.asp?viewstate=new&projec_id=<%=projec_id %>"><%=getlabel("new")%></a>
</div>
<%
	dim rs, sql
	
	sql = "select * ,'stappen' as steps, 'x' as del from projec_fases where projec_id=" & projec_id
	
	'controleren of er al fases aangemaakt zijn binnen dit project
	set rs = getrecordset(sql,true)
	if rs.recordcount <= 0 then
	    'kopieer de basisset (projec_id=0) naar het huidige project
	    executesql "sp_projec_fases_copy 0," & projec_id
	end if
		
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
	fields = fields & "$name:=fascod;type:=link;url:=e_projec_fases.asp?viewstate=view&id=~id~&;$"
	fields = fields & "$name:=steps;type:=link;url:=l_fases_steps.asp?viewstate=view&fases_id=~id~&projec_id=~projec_id~;$"
	fields = fields & "$name:=del;type:=delete;class:=projec_fases;boundcolumn:=id;$"
	fields = fields & "$name:=basis;type:=link;url:=../../include/bit.asp?class=projec_fases&field=basis&id=~id~&;$"
	
	orderby = "volgor"
	
	r_list sql, fields, orderby
%>
<!-- #include file="../../templates/footers/content.asp" -->
