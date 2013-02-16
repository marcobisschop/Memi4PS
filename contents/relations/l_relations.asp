<!-- #include file="../../templates/headers/content.asp" -->
<%
	f_header getlabel("hdr_relations")	

	dim rs, sql, myLetter, myLetters

	sql = "select distinct upper(left([bednaa],1)) as letter from vw_relations"
	sql = sql & " union "
	sql = sql & "select distinct upper(left([zoekco],1)) as letter from vw_relations"
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
:&nbsp;<a href="e_relations.asp?viewstate=new"><%=getlabel("new")%></a>
</div>
<%
	myLetter = viewstate_value("myLetter")
	if len(myLetter)=0 then myLetter = "A"
	sql = "select *, 'x' as del from vw_relations where [zoekco] like '" & myLetter & "%' or  [bednaa] like '" & myLetter & "%'"
	
	dim fieldlist, orderby
	fields = ""
	fields = fields & "$name:=id;type:=hidden;$"
	fields = fields & "$name:=aandat;type:=hidden;$"
	fields = fields & "$name:=aangeb;type:=hidden;$"
	fields = fields & "$name:=wijdat;type:=hidden;$"
	fields = fields & "$name:=wijgeb;type:=hidden;$"
	fields = fields & "$name:=adrfax;type:=hidden;$"
	fields = fields & "$name:=adrstr;type:=hidden;$"
	fields = fields & "$name:=adrpos;type:=hidden;$"
	fields = fields & "$name:=adrema;type:=email;$"
	fields = fields & "$name:=adrwww;type:=hidden;$"
	fields = fields & "$name:=bednaa;type:=link;url:=e_relations.asp?viewstate=view&id=~id~&myLetter=" & myLetter & ";$"
	fields = fields & "$name:=del;type:=delete;class:=bedrijf;boundcolumn:=id;" & myLetter & ";$"
	orderby = "bednaa"
	
	r_list sql, fields, orderby
%>
<!-- #include file="../../templates/footers/content.asp" -->
