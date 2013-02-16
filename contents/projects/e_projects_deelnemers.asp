<!-- #include file="../../templates/headers/content.asp" -->
<!-- #include file="functions.asp" -->
<%
	dim recordid, rs, sql, tablename
	recordid  = viewstate_value("id")
	'Hier wordt de titel van het formulier bepaalt
	projects_header(recordid)
%>
<div class="rolodex">
    <a href="l_projec_plagro_loting.asp?projec_id=<%=recordid%>"><%=getlabel("plagro_loting") %></a>
</div>
<%
    sql = "select *,'t' as task, 'x' as del, 'actions' as actions from vw_prodee where projec_id=" & recordid
    
    fields = "$name:=id;type:=hidden;boundcolumn:=id;$"
    fields = fields & "$name:=created;type:=hidden;$"
    fields = fields & "$name:=createdby;type:=hidden;$"
    fields = fields & "$name:=edited;type:=hidden;$"
    fields = fields & "$name:=editedby;type:=hidden;$"
    fields = fields & "$name:=projec_id;type:=hidden;$"
    fields = fields & "$name:=regrkp_id;type:=hidden;$"
    fields = fields & "$name:=relsoo_id;type:=hidden;$"
    fields = fields & "$name:=relati_id;type:=hidden;$"
    fields = fields & "$name:=prodee_id;type:=hidden;$"
    fields = fields & "$name:=pronaa;type:=hidden;$"
    
    fields = fields & "$name:=adrstr;type:=hidden;$"
    fields = fields & "$name:=adrnum;type:=hidden;$"
    fields = fields & "$name:=adrtoe;type:=hidden;$"
    fields = fields & "$name:=adrpos;type:=hidden;$"
    fields = fields & "$name:=adrpla;type:=hidden;$"
    fields = fields & "$name:=stipp_key;type:=hidden;$"
    fields = fields & "$name:=stipp_partnerid;type:=hidden;$"
    fields = fields & "$name:=status_id;type:=hidden;$"
    fields = fields & "$name:=voorkeur;type:=hidden;$"
    fields = fields & "$name:=kopers_naw;type:=hidden;$"
    fields = fields & "$name:=volgor;type:=hidden;$"
    fields = fields & "$name:=ord;type:=hidden;$"
    
    fields = fields & "$name:=adresregel1;type:=text;$"
    fields = fields & "$name:=adresregel2;type:=text;$"
    fields = fields & "$name:=adresregel3;type:=text;$"
    fields = fields & "$name:=adresregel4;type:=text;$"
    fields = fields & "$name:=adrtel;type:=text;$"
    fields = fields & "$name:=telmob;type:=text;$"
    fields = fields & "$name:=telwer;type:=hidden;$"
    fields = fields & "$name:=contacts_name2;type:=hidden;$"
    fields = fields & "$name:=soonaa;type:=hidden;$"
    fields = fields & "$name:=stanaa;type:=hidden;$"
      
    fields = fields & "$name:=adrema;type:=email;$"
	fields = fields & "$name:=contacts_name;type:=link;url:=e_prodee.asp?viewstate=edit&id=~id~&projec_id=~projec_id~;$"
	fields = fields & "$name:=stuurgroep;type:=hidden;url:=../../include/bit.asp?class=prodee&field=stuurgroep&id=~prodee_id~;$"
	fields = fields & "$name:=key;type:=link;url:=/impersonate.asp?key=~key~;target:=_top;$"
	fields = fields & "$name:=task;type:=link;url:=../../richtextbox/edit.asp?viewstate=new&id=-1&projec_id=~projec_id~&inreto=mytasks&inreto_id=~relati_id~&intro=~pronaa~;image:=/images/icons/task.gif;title:=Taak toevoegen;$"
	
	fields = fields & "$name:=del;type:=delete;class:=prodee;boundcolumn:=prodee_id;label:=;$"
	fields = fields & "$name:=actions;type:=hidden;columns:=~id~;wrapping:=nowrap;align:=center;$"
	
	r_list sql, fields, "volgor"
%>
<!-- #include file="../../templates/footers/content.asp" -->
