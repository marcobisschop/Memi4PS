<!-- #include file="../../templates/headers/content.asp" -->
<%
	'f_header (getlabel("hdr_rappor"))
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
	%>
	    <span class=divider>|</span>
	    <a style="color: #f00" href='e_reports.asp?viewstate=new&id=-1&rapgro=<%=rapgro %>'><%=getlabel("new") %></a>
	</div><%
	
	sql    = "select id,rapnaa,'" & getlabel("edit") & "' as edit from rappor where [rapgro]='" & rapgro & "'"
	
	fields = "$name:=id;type:=hidden;boundcolumn:=id;$"
	fields = fields & "$name:=rapnaa;type:=link;url:=report.asp?report_id=~id~;$" 
	fields = fields & "$name:=edit;type:=link;url:=e_reports.asp?viewstate=edit&id=~id~;$" 
	r_list sql, fields, "rapnaa"
%>
<!-- #include file="../../templates/footers/content.asp" -->