<!-- #include file="../../templates/headers/content.asp" -->
<!-- #include file="functions.asp" -->
<%
	dim recordid, rs, sql, tablename
	
	recordid  = viewstate_value("id")
	
	'Hier wordt de titel van het formulier bepaalt
	projects_header(recordid)

    sql = "select *, 'project.gegevens' as edit  "
    'sql = sql & ", (select bednaa from relati where id in ( " 
    'sql = sql & "select relati_id from regrkp where reltyp_id=1 and relgro_id in ( " 
    'sql = sql & "select relati_id from regrkp where reltyp_id=1 and relgro_id in ( "  
    'sql = sql & "select relgro_id from regrkp where relati_id=vw_prorel.relati_id))) " 
    sql = sql & ", 'x' as del, 't' as task from vw_prorel where projec_id=" & recordid
    
    fields = "$name:=id;type:=hidden;$"
    fields = fields & "$name:=aandat;type:=hidden;$"
    fields = fields & "$name:=aangeb;type:=hidden;$"
    fields = fields & "$name:=wijdat;type:=hidden;$"
    fields = fields & "$name:=wijgeb;type:=hidden;$"
    fields = fields & "$name:=projec_id;type:=hidden;$"
    fields = fields & "$name:=regrkp_id;type:=hidden;$"
    fields = fields & "$name:=relsoo_id;type:=hidden;$"
    fields = fields & "$name:=relati_id;type:=hidden;$"
    fields = fields & "$name:=prorel_id;type:=hidden;$"
    fields = fields & "$name:=pronaa;type:=hidden;$"
    
    fields = fields & "$name:=adrstr;type:=hidden;$"
    fields = fields & "$name:=adrnum;type:=hidden;$"
    fields = fields & "$name:=adrtoe;type:=hidden;$"
    fields = fields & "$name:=adrpos;type:=hidden;$"
    fields = fields & "$name:=adrpla;type:=hidden;$"
    
    
    fields = fields & "$name:=adrema;type:=email;$"
	fields = fields & "$name:=edit;type:=link;url:=../projects/e_prorel.asp?viewstate=edit&id=~id~&;$"
	fields = fields & "$name:=contacts_name2;type:=link;url:=../relations/e_relations_contacts.asp?viewstate=view&id=~relati_id~&myLetter=" & myLetter & ";$"
	fields = fields & "$name:=zichtb;type:=link;url:=prorel_zichtbaar.asp?id=~prorel_id~;$"
	fields = fields & "$name:=key;type:=link;url:=/impersonate.asp?key=~key~;target:=_top;$"
	
	fields = fields & "$name:=task;type:=link;url:=../../richtextbox/edit.asp?viewstate=new&id=-1&projec_id=~projec_id~&inreto=mytasks&inreto_id=~relati_id~&intro=~pronaa~;image:=/images/icons/task.gif;title:=Taak toevoegen;$"
	
	fields = fields & "$name:=del;type:=delete;class:=prorel;boundcolumn:=prorel_id;$"
	
	r_list sql, fields, ""

%>
<!-- #include file="../../templates/footers/content.asp" -->
