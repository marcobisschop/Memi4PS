<!-- #include file="../../templates/headers/content.asp" -->
<%
	f_header getlabel("hdr_language_labels")	

	dim rs, sql, myLetter, myLetters

	sql = "select distinct upper(left([key],1)) as letter from language_labels"
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
</div>
<%
	myLetter = viewstate_value("myLetter")
	if len(myLetter)=0 then myLetter = "A"
	sql = "select * from language_labels where [key] like '" & myLetter & "%'"
	
	dim fieldlist, orderby
	fieldlist = ""
	fieldlist = fieldlist & "$name:=id;type:=hidden;$"
	fieldlist = fieldlist & "$name:=created;type:=hidden;$"
	fieldlist = fieldlist & "$name:=createdby;type:=hidden;$"
	fieldlist = fieldlist & "$name:=edited;type:=hidden;$"
	fieldlist = fieldlist & "$name:=editedby;type:=hidden;$"
	fieldlist = fieldlist & "$name:=key;type:=link;url:=e_language_labels.asp?viewstate=edit&id=~id~&myLetter=" & myLetter & ";$"
	orderby = "[key]"
	
	r_list sql, fieldlist, orderby
%>
<!-- #include file="../../templates/footers/content.asp" -->
