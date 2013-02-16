<!-- #include file="../../templates/headers/content.asp" -->
<%
f_header getlabel("docum")
%>

<div class="f_remark">
Selecteer een project bij <b>voor project</b> om project specifieke documenten toe te voegen. 
Wanneer er geen project geselecteerd wordt het document algemeen en dus voor alle projecten zichtbaar.
</div>

<script language="javascript">
    function change() {
        edit.submit(); 
    } 
</script>
<div class="rolodex">
<%	
	dim sql, fieldlist, orderby, myLetter, myLetters
	
	f_form_hdr()
	
	sql = "select -1 as projec_id"
	set rs = getrecordset(sql ,true)
	projec_id = f_listbox (rs,"for_project","projec_id","select id, pronaa from projec order by pronaa","id","pronaa", "200","change();")

	
	sql = "select distinct upper(left([docnaa],1)) as letter from docum"
	if projec_id>0 then
	    sql = sql & " where inreto='projec' and inreto_id=" & projec_id
	else
	    sql = sql & " where inreto='projec_algemeen' and inreto_id <=0"
	end if
	set rs = getrecordset(sql, true)
	with rs
		do until .eof
			myLetters = myLetters & ":" & .fields("letter") & ":"
			.movenext
		loop
	end with
	set rs = nothing
	For I = 65 To 90
		myLetter = Chr(I)
		if instr(1,myLetters, ":" & myLetter & ":") then
			%><a href='?myLetter=<%=myLetter%>&projec_id=<%=projec_id %>'><%=myLetter%></a>&nbsp;<%
		else
			Response.Write myLetter & "&nbsp;"
		end if
	Next
%>
:&nbsp;<a href="?myLetter=ALL&projec_id=<%=projec_id %>"><%=getlabel("show_all")%></a>
:&nbsp;<a href="e_documents.asp?viewstate=new&inreto=projec&inreto_id=<%=projec_id %>"><%=getlabel("new")%></a>
</form>
</div>  
<%
    myLetter = Viewstate_value("myletter")
    if myLetter = "ALL" then myLetter = "%"	
	if myLetter = "" then myLetter = "A"	
	sql = "select id,docnaa,docnum,available,stuurgroep,'x' as del, 'O' as [open] from docum where docnaa like '" & myLetter & "%'"
	if projec_id > 0 then
	    sql = sql & " and inreto='projec' and inreto_id=" & projec_id
	else
	    sql = sql & " and inreto='projec_algemeen' and inreto_id <=0"
	end if
	fields = ""
	fields = fields & "$name:=id;type:=hidden;boundcolumn:=id;$"
	fields = fields & "$name:=docnum;type:=text;$"
	fields = fields & "$name:=status;type:=text;$"
	fields = fields & "$name:=docnaa;type:=link;url:=e_documents.asp?viewstate=view&id=~id~;$"
	fields = fields & "$name:=available;type:=bit;class:=docum;field:=available;id:=~id~;$"	
	fields = fields & "$name:=del;type:=delete;class:=docum;boundcolumn:=id;$"
	fields = fields & "$name:=open;type:=link;url:=../../include/file.asp?table=dosarc&inreto=documents&inreto_id=~id~;$"
	
	
	orderby = "docnum"

    r_list sql, fields, orderby
%>
<!-- #include file="../../templates/footers/content.asp" -->
