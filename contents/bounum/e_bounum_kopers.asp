<!-- #include file="../../templates/headers/content.asp" -->
<!-- #include file="functions.asp" -->
<%
	dim recordid, sql, fields
	
	viewstate = viewstate_value("viewstate")
	recordid  = viewstate_value("id")
		
	bounum_header (recordid)	
%>
<div class="rolodex">
    <!--<a href="../bounum/e_bounum_nieuwe_koper.asp?id=<%=recordid%>"><%=getlabel("nieuwe koper") %></a>-->
</div>
<%	
	sql = "select *,'t' as task from vw_prodee where projec_id in (select projec_id from bounum where id=" & recordid & ") and voorkeur=" & recordid
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
    
    fields = fields & "$name:=adresregels1;type:=hidden;$"
    fields = fields & "$name:=adresregel2;type:=hidden;$"
    fields = fields & "$name:=adrtel;type:=hidden;$"
    fields = fields & "$name:=contacts_name2;type:=hidden;$"
    fields = fields & "$name:=soonaa;type:=hidden;$"
    fields = fields & "$name:=stanaa;type:=hidden;$"
      
    fields = fields & "$name:=adrema;type:=email;$"
	fields = fields & "$name:=contacts_name2;type:=link;url:=e_prodee.asp?viewstate=edit&id=~id~&projec_id=~projec_id~;$"
	fields = fields & "$name:=stuurgroep;type:=link;url:=../../include/bit.asp?class=prodee&field=stuurgroep&id=~prodee_id~;$"
	fields = fields & "$name:=key;type:=link;url:=/impersonate.asp?key=~key~;target:=_top;$"
	fields = fields & "$name:=task;type:=link;url:=../../richtextbox/edit.asp?viewstate=new&id=-1&projec_id=~projec_id~&inreto=mytasks&inreto_id=~relati_id~&intro=~pronaa~;image:=/images/icons/task.gif;title:=Taak toevoegen;$"
	
	fields = fields & "$name:=del;type:=delete;class:=prodee;boundcolumn:=prodee_id;$"
	fields = fields & "$name:=actions;type:=actions:prodee;columns:=~id~;wrapping:=nowrap;align:=center;$"
	
	r_list sql, fields, "volgor"
	
%>
<!-- #include file="../../templates/footers/content.asp" -->
