<!-- #include file="../../templates/headers/content.asp" -->
<%
	f_header (getlabel("hdr_search_relations"))

	dim rs, sql, myLetter, myLetters

	sql = "select distinct upper(left([name],1)) as letter from vw_relations"
	set rs = getrecordset(sql, true)
	with rs
		do until .eof
			myLetters = myLetters & ":" & .fields("letter") & ":"
			.movenext
		loop
	end with
	set rs = nothing
%>
<div style="padding-left: 10px">
	<p>
	<%=getlabel("search_relations_bymethod")%>
	</p>
	<form action="../reports/result.asp" method="post">
	<select id="id" name="id"></select>
	<input type="text" id=searchfor name=searchfor>
	<input type=submit id=go name=go>
	</form>
	<p>
	<%=getlabel("search_relations_byrolodex")%>
	</p>
	<div class="rolodex_large">

	<%	
		For I = 65 To 90
			myLetter = Chr(I)
			if instr(1,myLetters, ":" & myLetter & ":") then
				%><a href='l_relations.asp?myLetter=<%=myLetter%>'><%=myLetter%></a>&nbsp;<%
			else
				Response.Write myLetter & "&nbsp;"
			end if
		Next

	%>
	</div>
</div>
<!-- #include file="../../templates/footers/content.asp" -->
