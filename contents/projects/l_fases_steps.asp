<!-- #include file="../../templates/headers/content.asp" -->
<!-- #include file="functions.asp" -->
<%
	dim rs, sql, myLetter, myLetters, fases_id, projec_id
	
	fases_id = viewstate_value("fases_id")
	projec_id = viewstate_value("projec_id")
	
	
	if projec_id = 0 then
        f_header getlabel("hdr_projec_fases_steps")	
    else
	    projects_header(projec_id)
	end if 
	
	sql = "select *, 'stappen' as steps from projec_fases where projec_id=" & projec_id
	
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
	
	sql = "select * from projec_fases where id=" & fases_id
	set rs = getrecordset(sql, true)
	f_header "Fase: " & rs.fields("fasnaa")
	set rs = nothing

%>
<div class="rolodex">
    <a href="e_fases_steps.asp?viewstate=new&projec_id=<%=projec_id %>&fases_id=<%=fases_id %>"><%=getlabel("new")%></a>
</div>
<%
	

    sql = "select id, stepna, 'html' as html, volgor, basis, 'x' as del from vw_fases_steps where fases_id=" & fases_id
	
	fields = ""
	fields = fields & "$name:=id;type:=hidden;boundcolumn:=id;$"
	fields = fields & "$name:=projec_id;type:=hidden;boundcolumn:=id;$"
	fields = fields & "$name:=fases_id;type:=hidden;boundcolumn:=id;$"
	fields = fields & "$name:=steps_id;type:=hidden;boundcolumn:=id;$"
	fields = fields & "$name:=createdby;type:=hidden;$"
	fields = fields & "$name:=created;type:=hidden;$"
	fields = fields & "$name:=editedby;type:=hidden;$"
	fields = fields & "$name:=edited;type:=hidden;$"
	fields = fields & "$name:=stepna;type:=link;url:=e_fases_steps.asp?viewstate=edit&id=~id~;$"
	fields = fields & "$name:=html;type:=link;url:=e_steps_html.asp?viewstate=edit&id=~id~;$"
	fields = fields & "$name:=basis;type:=bit;class:=projec_fases_steps;field:=basis;id:=~id~;$"
	fields = fields & "$name:=volgor;type:=order;class:=projec_fases_steps;field:=volgor;id:=~id~;$"
	fields = fields & "$name:=del;type:=delete;class:=projec_fases_steps;boundcolumn:=id;$"
	
	orderby = "volgor"
	
	r_list sql, fields, orderby
%>
<!-- #include file="../../templates/footers/content.asp" -->
