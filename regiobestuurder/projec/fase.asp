<!-- #include file="../../templates/headers/content.asp" -->
<!-- #include file="../inc/functions.asp" -->
<%

    dim rsProjec
	dim fases_id
	fases_id = viewstate_value("fases_id")
	session("fases_id") = fases_id

    fase_header session("projec_id"), session("fases_id")

%>
<b>Binnen de fase zullen de volgende stappen worden doorlopen:</b>
<%
   	
	dim sql, rs
	sql = "select * from vw_fases_steps where projec_id=" & session("projec_id") & " and fases_id = " & session("fases_id") 'in (select fases_id from projec_fases where id=" & fases_id & " )"
	set rs = getrecordset(sql, true)
	with rs
	    if not .eof then
	    %>
	    <ul>
	    <%	    
	    do until .eof
	        %>
	        <li><a href="step.asp?steps_id=<%=.fields("id") %>">Stap <%=.absoluteposition %>: <%=.fields("stepna") %></a></li>
	        
	        <%
	        .movenext
	    loop
	    %>
	    </ul>
	    <%
	    else
	    %>
	    <%
	    end if
	end with
	set rs = nothing
	
	
	fase_footer session("projec_id"), session("fases_id")
	
	set rs = nothing

    set rsProjec = Nothing
	set rsFase = Nothing

%>

<!-- #include file="../../templates/footers/content.asp" -->
