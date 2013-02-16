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
									&nbsp;<%=rs.fields("keusoo_soonaa")%>
			                        &nbsp;<a href="l_keuzen.asp?viewstate=view&id=<%=rs.fields("id") %>&keusoo_soonaa=<%=rs.fields("keusoo_soonaa") %>&koppel_id=<%=rs.fields("koppel_id") %>">Terug</a>
								
								    <% 
							        select case lcase(rs.fields("keusoo_soonaa"))
							        case "s"
							        case "p"
							            rw " (" & dblookup("projec","id", rs.fields("koppel_id"), "pronaa") & ")"
							        case "w"
							            projec_id = dblookup("boutyp","id", rs.fields("koppel_id"), "projec_id") 
							            rw " (Type " & dblookup("boutyp","id", rs.fields("koppel_id"), "typnaa") 
							            rw ", " & dblookup("projec","id", projec_id, "pronaa") & ")"
							        case "b"
							            projec_id = dblookup("bounum","id", rs.fields("koppel_id"), "projec_id") 
							            rw " (Bnr. " & dblookup("bounum","id", rs.fields("koppel_id"), "extnum") 
							            rw ", " & dblookup("projec","id", projec_id, "pronaa") & ")"
							        end select
							        %>	
								
								</b>
								<br>
								<%=.fields("keubes")%>
							</div>	
							<span style='color:red'>
							<% 
					        select case lcase(rs.fields("keusoo_soonaa"))
					        case "s"
					            rw " U bevindt zich op project niveau"
					        case "p"
					            rw " U bevindt zich op project niveau"
					        case "w"
					            rw " U bevindt zich op bouwtype niveau"
					        case "b"
					            rw " U bevindt zich op bouwnummer niveau"
					        end select
					        %>		
					        </span>			
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
			   
			    <a class="menu_option" href="l_pictures.asp?id=<%=id%>&inreto=keuzen&inreto_id=<%=id%>"><%=getlabel("afbeeldingen")%></a>
			    <span class="menu_divider">|</span>
			   
			    <a class="menu_option" href="e_keuzen_notes.asp?viewstate=view&id=<%=id%>&inreto=keuzen&inreto_id=<%=id%>"><%=getlabel("menu_notes")%></a>
			    <span class="menu_divider">|</span>
			    <a class="menu_option" href="e_keuzen_kosten.asp?viewstate=view&id=<%=id%>&inreto=keuzen&inreto_id=<%=id%>"><%=getlabel("kostenregels")%></a>
			    <span class="menu_divider">|</span>
			    <a class="menu_option" href="e_pictures.asp?viewstate=view&id=<%=id%>&inreto=keuzen&inreto_id=<%=id%>"><%=getlabel("pictures")%></a>
			    
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
