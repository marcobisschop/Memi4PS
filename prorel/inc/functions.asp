<%

function fase_docum (projec_id, fases_id)
%>
<hr />
<b>Documenten: </b>
<%
	if cbool(session("stuurgroep")) then
        sql = "select distinct docum_id, docnaa, docnum from vw_docum_availability where available=1 and inreto='projec' and inreto_id=" & projec_id & " and projec_fases_id in (select fases_id from projec_fases where id=" & fases_id & " ) and relsoo_id=" & session("relsoo_id") & " order by docnaa"
    else
        sql = "select distinct docum_id, docnaa, docnum from vw_docum_availability where stuurgroep=0 and available=1 and inreto='projec' and inreto_id=" & projec_id & " and projec_fases_id in (select fases_id from projec_fases where id=" & fases_id & " ) and relsoo_id=" & session("relsoo_id") & " order by docnaa"
    end if 

    ' response.Write sql

	set rs = getrecordset(sql, true)
	with rs
	    if not .eof then
	    %><ul><%
	    do until .eof
	        %><li><a title="<%=.fields("docnum") %>" href="../documents/docum.asp?table=dosarc&inreto=documents&inreto_id=<%=.fields("docum_id") %>"><%=.fields("docnaa") %></a></li><%
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

end function

function fase_footer (projec_id, fases_id)
%>
<hr />
<b>Documenten: </b>
<%
	
	sql = "select distinct docum_id, docnaa, docnum from vw_docum_availability where available=1 and inreto='projec' and inreto_id=" & projec_id & " and projec_fases_id in (select fases_id from projec_fases where id=" & fases_id & " ) and relsoo_id=" & session("relsoo_id") & " order by docnaa"

' response.Write sql

	set rs = getrecordset(sql, true)
	with rs
	    if not .eof then
	    %><ul><%
	    do until .eof
	        %><li><a title="<%=.fields("docnum") %>" href="../../include/file.asp?table=dosarc&inreto=documents&inreto_id=<%=.fields("docum_id") %>"><%=.fields("docnaa") %></a></li><%
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

end function


function fase_header(projec_id, fases_id)
    on error resume next
    Dim rsProjec, rsFase
    set rsProjec = getrecordset("select * from vw_projec where id=" & projec_id,true) 
    set rsFase = getrecordset("select * from vw_projec_fases where id=" & fases_id,true) 
%>

    <div style="margin-bottom: 20px; font-weight: 700; font-size: 12px; padding-top: 10px; padding-left: 10px; padding-right: 10px; padding-bottom: 10px; background-color: <%=rsfase.fields("kleur") %>; width: 100%">
    <table>
    <tr>
        <td style="font-weight: 700; font-size: 12px; width: 90px">Project:</td>
        <td style="font-weight: 700; font-size: 12px;"><%=rsProjec.fields("pronaa") %></td>
    </tr><tr> 
       <td style="font-weight: 700; font-size: 12px;">Fase:</td>
       <td style="font-weight: 700; font-size: 12px;">
        <%if rsFase.eof then%>
            Algemeen
        <%
        else 
        %>
            <%=rsFase.fields("fasnaa") %>
        <%
        end if
      %>      
       </td>
    </tr>
    </table>
    </div>
        <%if rsFase.eof then%>
        <%
        else 
        %>
        <%=rsFase.fields("fasbes") %>
        <hr />
        <%
        end if
      
    set rsProjec = Nothing
    set rsFase = Nothing 
end function

function fase_footer (projec_id, fases_id)
%>
<hr />
<b>Documenten: </b>
<%
	
	sql = "select distinct docum_id, docnaa, docnum from vw_docum_availability where available=1 and inreto='projec' and inreto_id=" & projec_id & " and projec_fases_id in (select fases_id from projec_fases where id=" & fases_id & " ) and relsoo_id=" & session("relsoo_id") & " order by docnaa"

' response.Write sql

	set rs = getrecordset(sql, true)
	with rs
	    if not .eof then
	    %><ul><%
	    do until .eof
	        %><li><a title="<%=.fields("docnum") %>" href="../../include/file.asp?table=dosarc&inreto=documents&inreto_id=<%=.fields("docum_id") %>"><%=.fields("docnaa") %></a></li><%
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
<hr />
<b>Forum(s): </b>
<%
	sql = "select * from vw_fora where projec_id=" & projec_id & " and projec_fases_id=" & fases_id & " order by name"
	
	set rs = getrecordset(sql, true)
	with rs
	    if not .eof then
	    do until .eof
	        %><a href="../fora/fora.asp?fora_id=<%=.fields("id") %>"><%=.fields("name") %></a><%
	        .movenext
	        if not .eof then Response.Write ", "
	    loop
	    else
	    %>
	    Geen forums beschikbaar!
	    <%
	    end if
	end with

end function
%>