<!-- #include file="../../templates/headers/content.asp" -->
<%
	f_header (getlabel("hdr_reports"))
	Dim rs, sql, fields, rapgro
	
	rapgro = viewstate_value("rapgro")
	'if rapgro = "" then rapgro = "students"
	%><div class=rolodex><%
	sql = "select distinct [rapgro] from rappor order by [rapgro]"
	set rs = getrecordset(sql ,true)
	with rs 
	    do until .eof
	        %>
	        <a href="?rapgro=<%=.fields("rapgro") %>"><%=getlabel(.fields("rapgro")) %></a>
	        <%
	        .movenext
	        if not .eof then response.Write "<span class=divider>|</span>"
	    loop
	end with
	set rs = nothing
	%></div><%
	
	sql    = "select id,rapnaa from rappor where zichtb=1 and [rapgro]='" & rapgro & "'"
	
	fields = "$name:=id;type:=hidden;boundcolumn:=id;$"
	fields = fields & "$name:=rapnaa;type:=link;url:=report.asp?report_id=~id~;$" 
	r_list sql, fields, "rapnaa"
%>
<!-- #include file="../../templates/footers/content.asp" -->