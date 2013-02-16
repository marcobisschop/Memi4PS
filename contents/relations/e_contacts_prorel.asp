<!-- #include file="../../templates/headers/content.asp" -->
<!-- #include file="functions.asp" -->
<%
	dim recordid, rs, sql, tablename
	
	recordid  = viewstate_value("id")
	
	'Hier wordt de titel van het formulier bepaalt
	contacts_header(recordid)

    sql = "select * from vw_prorel where relati_id=" & recordid
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
    
    fields = fields & "$name:=adrstr;type:=hidden;$"
    fields = fields & "$name:=adrnum;type:=hidden;$"
    fields = fields & "$name:=adrtoe;type:=hidden;$"
    fields = fields & "$name:=adrpos;type:=hidden;$"
    fields = fields & "$name:=adrpla;type:=hidden;$"
    fields = fields & "$name:=contacts_name2;type:=hidden;$"
    
    
    fields = fields & "$name:=adrema;type:=email;$"
	fields = fields & "$name:=pronaa;type:=link;url:=../projects/e_projects_prorel.asp?viewstate=view&id=~projec_id~;$"
	fields = fields & "$name:=zichtb;type:=link;url:=../projects/prorel_zichtbaar.asp?id=~prorel_id~;$"
	fields = fields & "$name:=key;type:=link;url:=http://memi2.telaterrae.com/me/impersonate.asp?key=~key~;target:=_blank;$"
	r_list sql, fields, ""

%>
<!-- #include file="../../templates/footers/content.asp" -->
