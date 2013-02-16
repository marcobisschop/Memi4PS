<!-- #include file="../../templates/headers/content.asp" -->
<%
	f_header getlabel("hdr_projects")	

	dim rs, sql, myLetter, myLetters, provin_id
    provin_id = viewstate_value("provin_id")

%>
<div class="rolodex">
<%	
	sql = "select distinct id,prvnaa from provin where id in (select distinct provin_id from projec) order by prvnaa"
	set rs = getrecordset(sql, true)
	with rs
		do until .eof
			%><a href='?provin_id=<%=.fields("id")%>'><%=.fields("prvnaa")%></a><%
			.movenext
			if not .eof then response.Write "<span class='divider'>|</a>"
		loop
	end with
	set rs = nothing
%>
&nbsp;|&nbsp;<a href="e_projects.asp?viewstate=new&id=0"><%=getlabel("new") %></a>
</div>
<%
    if len(provin_id)=0 then 
        if lcase(session("application")) = "demo" then
            sql = "select id,pronaa,pronum,intref, (select stanaa from status where id=status_id) as status from projec where id=68"
        else
   	        sql = "select id,pronaa,pronum,intref, (select stanaa from status where id=status_id) as status from projec where id<>68"
   	    end if
    else
        if lcase(session("application")) = "demo" then
            sql = "select id,pronaa,pronum,intref, (select stanaa from status where id=status_id) as status from projec where id=68 and provin_id in (" & provin_id & ")"
        else
   	        sql = "select id,pronaa,pronum,intref, (select stanaa from status where id=status_id) as status from projec where id<>68 and provin_id in (" & provin_id & ")"
        end if
	end if 
	
	dim fieldlist, orderby
	fields = ""
	fields = fields & "$name:=id;type:=hidden;boundcolumn:=id;$"
	fields = fields & "$name:=age;type:=text;$"
	fields = fields & "$name:=status;type:=text;$"
	fields = fields & "$name:=pronaa;type:=link;url:=e_projects.asp?viewstate=view&id=~id~&;$"
	
	orderby = "pronaa"
    
	r_list sql, fields, orderby
%>
<!-- #include file="../../templates/footers/content.asp" -->
