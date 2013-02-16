<!-- #include file="../../templates/headers/content.asp" -->
<!-- #include file="functions.asp" -->
<%
    projec_id  = viewstate_value("id")
	projects_header(projec_id)	
%>
<div class="rolodex">
    <a href="e_factur.asp?viewstate=new&id=-1&projec_id=<%=projec_id %>"><%=getlabel("new")%></a>
</div>
<%
	dim rs, sql
	
	sql = "select * ,'Indienen' as [Actie_1], "
	sql = sql & " (select sum(prikop*aantal) from keuzen where keusoo_soonaa='B' and koppel_id in (select id from bounum where projec_id = "&projec_id&" and defini=1 and control=1)) as totaal_memi, "
	sql = sql & " (select sum(isnull(bedrag,0)) from factur_regels where projec_id = "&projec_id&" and factur_id=factur.id and status_id=30) as intedienen, "
	sql = sql & " (select sum(isnull(bedrag,0)) from factur_regels where projec_id = "&projec_id&" and factur_id=factur.id and status_id=31) as ingediend "
	sql = sql & " ,'Doorvoeren' as [Actie_2]"  
	sql = sql & " from factur where projec_id=" & projec_id
	
	'controleren of er al fases aangemaakt zijn binnen dit project
	set rs = getrecordset(sql,true)
	if rs.recordcount <= 0 then
	    'kopieer de basisset (projec_id=0) naar het huidige project
	'    executesql "sp_projec_fases_copy 0," & projec_id
	end if
		
	dim fieldlist, orderby
	fields = ""
	fields = fields & "$name:=id;type:=hidden;boundcolumn:=id;$"
	fields = fields & "$name:=projec_id;type:=hidden;boundcolumn:=id;$"
	fields = fields & "$name:=aangeb;type:=hidden;$"
	fields = fields & "$name:=aandat;type:=hidden;$"
	fields = fields & "$name:=wijgeb;type:=hidden;$"
	fields = fields & "$name:=wijdat;type:=hidden;$"
	fields = fields & "$name:=totaal_memi;type:=text;format:=d2;align:=right;$"
	fields = fields & "$name:=intedienen;type:=text;format:=d2;align:=right;$"
	fields = fields & "$name:=ingediend;type:=text;format:=d2;align:=right;$"
	fields = fields & "$name:=del;type:=delete;class:=factur;boundcolumn:=id;$"
	fields = fields & "$name:=facnaa;type:=link;url:=e_factur.asp?viewstate=edit&id=~id~&projec_id=~projec_id~;$"
	fields = fields & "$name:=actie_1;type:=link;url:=../facturatie/doorvoeren.asp?viewstate=edit&factur_id=~id~&projec_id=~projec_id~&action=indienen;align:=right;$"
	fields = fields & "$name:=actie_2;type:=link;url:=../facturatie/doorvoeren.asp?viewstate=edit&factur_id=~id~&projec_id=~projec_id~&action=doorvoeren;align:=right;$"
	
	orderby = "volgor"
	
	f_header getlabel("facturatie percentages")
	r_list sql, fields, orderby
	
	sql = "select * from vwFactur_overzicht where projec_id = " & projec_id
	fields = "$name:=projec_id;type:=hidden;$"
	fields = fields & "$name:=bounum_id;type:=hidden;$"
	fields = fields & "$name:=pronaa;type:=hidden;$"
	fields = fields & "$name:=laatste_factuur;type:=date;align:=right;$"
	fields = fields & "$name:=totaal_memi;type:=text;format:=d2;calculate:=sum;align:=right;$"
	fields = fields & "$name:=ingediend;type:=text;format:=d2;calculate:=sum;align:=right;$"
	fields = fields & "$name:=intedienen;type:=text;format:=d2;calculate:=sum;align:=right;$"
	fields = fields & "$name:=percentage;type:=text;format:=d2;align:=right;$"
	fields = fields & "$name:=factur;type:=bit;class:=bounum;boundcolumn:=id;field:=factur;id:=~bounum_id~;$"
	orderby = "extnum"
	
	f_header getlabel("facturatie overzicht")
	r_list sql, fields, orderby
	
%>
<!-- #include file="../../templates/footers/content.asp" -->
