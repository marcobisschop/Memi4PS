<!-- #include file="../../templates/headers/content.asp" -->
<!-- #include file="../inc/functions.asp" -->
<%

    dim rsProjec
	dim steps_id
	steps_id = viewstate_value("steps_id")
	session("steps_id") = steps_id
	
    set rsProjec = getrecordset("select * from vw_projec where id=" & session("projec_id"),true) 
    set rsFase = getrecordset("select * from vw_projec_fases where id=" & session("fases_id"),true) 
    set rsStep = getrecordset("select * from vw_fases_steps where id=" & session("steps_id"),true) 
%>

<div style="margin-bottom: 20px; font-weight: 700; font-size: 12px; padding-top: 10px; padding-left: 10px; padding-right: 10px; padding-bottom: 10px; background-color: <%=rsfase.fields("kleur") %>; width: 100%">
<table>
<tr>
    <td style="font-weight: 700; font-size: 12px; width: 90px">Project:</td>
    <td style="font-weight: 700; font-size: 12px;"><%=rsProjec.fields("pronaa") %></td>
</tr><tr> 
   <td style="font-weight: 700; font-size: 12px;">Fase:</td>
   <td style="font-weight: 700; font-size: 12px;"><%=rsFase.fields("fasnaa") %></td>
</tr><tr> 
   <td style="font-weight: 700; font-size: 12px;">Stap:</td>
   <td style="font-weight: 700; font-size: 12px;"><%=rsStep.fields("stepna") %></td>
</tr>
</table>
</div>



<div style="margin-bottom: 20px; padding-top: 10px; padding-left: 10px; padding-right: 10px; padding-bottom: 10px; width: 100%">

<%=rsStep.fields("html") %><br />

<%

    dim rsFS
    set rsFS = getrecordset("exec sp_fases_prevstep " & steps_id, true)
    if not rsFS.eof then
        %>
        <br />
        <b>Vorige stap:</b>&nbsp;<a href="?steps_id=<%=rsFS.fields("id") %>"><%=rsFS.fields("stepna") %></a>
        <%
    end if 
    set rsFS = nothing 
    set rsFS = getrecordset("exec sp_fases_nextstep " & steps_id, true)
    if not rsFS.eof then
        %>
        <br />
        <b>Volgende stap:</b>&nbsp;<a href="?steps_id=<%=rsFS.fields("id") %>"><%=rsFS.fields("stepna") %></a>
        <%
    end if 
    set rsFS = nothing 


    fase_footer session("projec_id"), session("fases_id")

	set rs = nothing
	set rsProjec = Nothing
	set rsFase = Nothing
	set rsStep = Nothing

%>

</div>
<!-- #include file="../../templates/footers/content.asp" -->
