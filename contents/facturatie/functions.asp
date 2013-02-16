<%
	function keuzen_header(id)
		if id = 0 then
%>
<div class="keuze_header">
    <%f_header getlabel("new_keuze")%>
</div>
<%	
		else
			dim rs, sql
			sql = "select * from keuzen where id=" & id
			set rs= getrecordset(sql, true)
			with rs
			%>
<div class="relations_header">
	<table cellpadding="0" cellspacing="0">
		<tr>
			<td colspan="3"><%=f_header (rs.fields("keucod"))%></td>
		</tr>
		<tr>
			<td></td>
			<td>
				<table cellpadding="5" cellspacing="0">
					<tr>
						<td><!--<img style="width:181px; height:205px" src="../../images/students/image.asp?sn=<%=.fields("intref")%>">--></td>
						<td valign=top style="width: 60%">
							<div style="padding: 5px;">
								<b>
									<%=.fields("keucod")%>
								</b>
								<br>
								<%=.fields("keubes")%>
							</div>							
						</td>
						<td valign=top align=right style="font-size:20px">
						    <div style="padding: 5px;">
						    <%
						    if .fields("prikop") < 0 then
						        response.write "<span style='color: red'> " & formatnumber (.fields("prikop"),2) & "</span>"
						    else
						        response.write "<span style='color: blue'> " & formatnumber (.fields("prikop"),2) & "</span>"
						    end if
						    
						    %>
						    
						    </div>
						</td>
					</tr>
					<tr>
						<td></td>
					</tr>
				</table>
			</td>
			<td></td>
		</tr>
		<tr>
			<td colspan=3 class="menu_bar">
			    <a class="menu_option" href="e_keuzen.asp?viewstate=view&id=<%=id%>"><%=getlabel("general")%></a>
			    <span class="menu_divider">|</span>
			    <a class="menu_option" href="e_pictures.asp?viewstate=view&id=<%=id%>&inreto=keuzen&inreto_id=<%=id%>"><%=getlabel("pictures")%></a>
			    <span class="menu_divider">|</span>
			    <a class="menu_option" href="e_keuzen_notes.asp?viewstate=view&id=<%=id%>&inreto=keuzen&inreto_id=<%=id%>"><%=getlabel("menu_notes")%></a>
			</td>
		</tr>
	</table>
</div>
<%	
			end with
			set rs = nothing
		end if
	end function
%>
