<!-- #include file="../../templates/headers/content.asp" -->
<%
	f_header getlabel("hdr_deelnemers")	

	dim rs, sql, myLetter, myLetters

	sql = "select distinct upper(left([achter],1)) as letter from vw_deelnemers"
	set rs = getrecordset(sql, true)
	with rs
		do until .eof
			myLetters = myLetters & ":" & .fields("letter") & ":"
			.movenext
		loop
	end with
	set rs = nothing
%>
<div class="rolodex">
<%	
	For I = 65 To 90
		myLetter = Chr(I)
		if instr(1,myLetters, ":" & myLetter & ":") then
			%><a href='?myLetter=<%=myLetter%>'><%=myLetter%></a>&nbsp;<%
		else
			Response.Write myLetter & "&nbsp;"
		end if
	Next
%>
:&nbsp;<a href="e_deelnemers.asp?viewstate=new&id=-1"><%=getlabel("new")%></a>
</div>
<%
	myLetter = viewstate_value("myLetter")
	if len(myLetter)>0 then
	    sql = "select relati_id, contacts_name, adrtel, telmob, adrema, [key], 'x' as del from vw_deelnemers where [achter] like '" & myLetter & "%'"
    	
	    dim fieldlist, orderby
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
	    fields = fields & "$name:=adresregel3;type:=hidden;$"
	    fields = fields & "$name:=adresregel4;type:=hidden;$"
	    fields = fields & "$name:=bedrij_bednaa;type:=hidden;$"
	    fields = fields & "$name:=key;type:=hidden;$"
	    fields = fields & "$name:=adrema;type:=email;$"
	    fields = fields & "$name:=contacts_name;type:=link;url:=e_deelnemers.asp?viewstate=view&id=~relati_id~&myLetter=" & myLetter & ";$"
	    fields = fields & "$name:=bedrij_bednaa;type:=hidden;url:=e_relations.asp?viewstate=view&id=~bedrij_id~;$"
	    fields = fields & "$name:=key;type:=link;url:=http://memi2.telaterrae.com/me/impersonate.asp?key=~key~;target:=_blank;$"
	    fields = fields & "$name:=del;type:=delete;class:=relations_deelnemers;boundcolumn:=relati_id;$"
	    orderby = "[achter]"
    	
	r_list sql, fields, orderby
	end if
%>
<!-- #include file="../../templates/footers/content.asp" -->
