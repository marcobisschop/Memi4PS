<!-- #include file="header.asp" -->

<%
	label = viewstate_value("label")
	f_header label
%>
<div>
<%
	dim inreto, inreto_id
	dim sql, rs
	
	inreto = viewstate_value("inreto")
	inreto_id = viewstate_value("inreto_id")
		
	sql = "select * from notes where inreto='" & inreto & "' and inreto_id=" & inreto_id & " order by aandat desc"
	set rs = getrecordset(sql, true)
	with rs
		%>
		<table>
			<tr>
				<td style="height:34px;background-color:#ffffff;" colspan=5>
					<a href="correspondence_list.asp?inreto=<%=inreto%>&inreto_id=<%=inreto_id%>"><img style="border:0px" src="<%=webpath%>images/icons/new16_h.gif"></a>&nbsp;Nieuw
					<a href="javascript:window.print()"><img style="border:0px" src="<%=webpath%>images/icons/print16_h.gif"></a>&nbsp;Afdrukken
				</td>
			</tr>
		<%
		do until .eof
			%>
				<tr style="background-color:#ffffff">
					<td style="width:5%;border-top:1px solid">&nbsp;</td>
					<td style="width:85%;border-top:1px solid" nowrap align=left><b><%=.fields("subject")%></b></td>
					<td style="width:10%px;border-top:1px solid" nowrap align=left><%=sec_field(.fields("wijgeb"),"fullname")%></td>
					<td style="width:10%px;border-top:1px solid" nowrap align=right><%=right("00" & day(.fields("wijdat")),2) & "-" & right("00" & month(.fields("wijdat")),2) & "-" & year(.fields("wijdat"))%></td>
					<td style="width:5%;border-top:1px solid" align=right >&nbsp;</td>
				</tr>
			<%
				if len(.fields("body"))>0 then
			%>
				<tr style="background-color:#ffffff">
					<td style="width:25px">&nbsp;</td>
					<td colspan=4><%=left(.fields("body"),300)%></td>
				</tr>
			<%
				end if
			.movenext
		loop
		%>
		</table>
		<%
		
	end with	
	set rs = nothing
%>
</div>