<!-- #include file="../../templates/headers/content.asp" -->
<!-- #include file="../inc/functions.asp" -->
<%

    dim docum_id
    docum_id = viewstate_value("inreto_id")

    sql = "select id, arcnaa, arcbes from dosarc where inreto='documents' and inreto_id=" & docum_id & " order by volgor asc"
    
	set rs = getrecordset(sql, true)
	with rs
	    if not .eof then
	    %><ul><%
	    do until .eof
	        %><li><a title="<%=getlabel("open") %>" href="../../include/file.asp?table=dosarc&inreto=dosarc&inreto_id=<%=.fields("id") %>"><%=.fields("arcbes") %></a></li><%
	        .movenext
	    loop
	    %></ul><%
	    else
	    %>
	    Geen documenten beschikbaar!
	    <%
	    end if
	end with
	set rs = nothing
%>
<!-- #include file="../../templates/footers/content.asp" -->
