<!-- #include file="../../templates/headers/content.asp" -->
<%

    dim rsProjec
    set rsProjec = getrecordset("select * from vw_projec where id=" & session("projec_id"),true) 

    f_header "Project:" &  rsProjec.fields("pronaa")  

    set rsProjec = Nothing

	dim fases_id
	fases_id = viewstate_value("fases_id")
	
	dim sql, rs
	sql = "select * from vw_projec_fases where basis=1 and projec_id=" & session("projec_id")
	sql = sql & " and (getdate() >= datbeg or datbeg is null)"
    sql = sql & " and (getdate() < datein or datein is null)"
    sql = sql & " order by volgor"
	
	'response.write sql
	
	set rs = getrecordset(sql, true)
	with rs
	   if not .eof then 
	   %>
	    <table style="width: 100%">
	    <%	    
	    do until .eof
	        %>
	        <tr>
	            <td style="color: #ffffff;background-color:<%=.fields("kleur") %>; padding: 5px 5px 5px 5px; border-bottom: solid 1px #c0c0c0; font-weight: 700"><a style="color: #ffffff" href="fase.asp?fases_id=<%=.fields("id") %>"><%=.fields("fasnaa") %></a></td>
	            <td nowrap style="color: #ffffff;background-color:<%=.fields("kleur") %>; padding: 5px 5px 5px 5px; border-bottom: solid 1px #c0c0c0; font-weight: 700; text-align: right"><a style="color: #ffffff" href="fase.asp?fases_id=<%=.fields("id") %>">klik hier</a></td>
	        </tr>
	        <tr>
	            <td style="padding-top: 5px; padding-left: 15px; padding-bottom: 15px; padding-right: 5px; ">
	            <%=.fields("fasbes") %><br /><br />
                <!--<a style="" href="fase.asp?fases_id=<%=.fields("id") %>">>> Naar fase</a>-->
               </td>
	        </tr>
	        <%
	        .movenext
	    loop
	    %>
	    </table>
	    <%
	    
	    else
	    %>
	    <%
	    end if
	end with
	set rs = nothing
%>
<!-- #include file="../../templates/footers/content.asp" -->
