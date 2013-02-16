<!-- #include file="../../templates/headers/content.asp" -->
<!-- #include file="functions.asp" -->
<%
	dim recordid, rs, sql, fields
	
	viewstate = viewstate_value("viewstate")
	recordid  = viewstate_value("id")
	
	relations_header recordid
%>
<div class="rolodex">
&nbsp;<a href="e_relations_contacts.asp?viewstate=new&id=-1&bedrij_id=<%=recordid%>"><%=getlabel("new")%></a>
</div>
<%		
	sql = "select *, 'x' as del from vw_contacts where bedrij_id=" & recordid
	fields = ""
	fields = fields & "$name:=regrkp_id;type:=hidden;$"
	fields = fields & "$name:=relati_id;type:=hidden;$"
	fields = fields & "$name:=reltyp_id;type:=hidden;$"
	fields = fields & "$name:=relgro_id;type:=hidden;$"
	fields = fields & "$name:=contacts_name2;type:=hidden;$"
	fields = fields & "$name:=voorle;type:=hidden;$"
	fields = fields & "$name:=voorna;type:=hidden;$"
	fields = fields & "$name:=tussen;type:=hidden;$"
	fields = fields & "$name:=achter;type:=hidden;$"
	fields = fields & "$name:=bedrij_id;type:=hidden;$"
	fields = fields & "$name:=geslac_gesnaa;type:=hidden;$"
	fields = fields & "$name:=adrfax;type:=hidden;$"
	fields = fields & "$name:=adresregel3;type:=hidden;$"
	fields = fields & "$name:=adresregel4;type:=text;$"
	fields = fields & "$name:=bedrij_bednaa;type:=hidden;$"
	
	fields = fields & "$name:=adrema;type:=email;$"
	fields = fields & "$name:=contacts_name;type:=link;url:=e_relations_contacts.asp?viewstate=view&id=~relati_id~&myLetter=" & myLetter & ";$"
	fields = fields & "$name:=bedrij_bednaa;type:=link;url:=e_relations.asp?viewstate=view&id=~bedrij_id~;$"
	fields = fields & "$name:=key;type:=link;url:=http://memi2.telaterrae.com/me/impersonate.asp?key=~key~;target:=_blank;$"
	fields = fields & "$name:=del;type:=delete;class:=regrkp;boundcolumn:=relati_id,relgro_id;$"
	
	r_list sql, fields, "contacts_name"
%>	
<!-- #include file="../../templates/footers/content.asp" -->
