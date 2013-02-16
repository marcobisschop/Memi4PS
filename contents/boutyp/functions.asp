<%
	function boutyp_header(id, projec_id)
	    
		if cint(id) = -1 then
        %>
        <div class="relations_header">
            <%f_header getlabel("new_boutyp")%>
        </div>
        <%	
		else
			dim rs, sql, sqlP,  rsP
			sql = "select * from boutyp where id=" & id
			set rs= getrecordset(sql, true)
			sqlP = "select * from projec where id=" & projec_id
			set rsP = getrecordset(sqlP, true)
			
			%>
<div class="relations_header">
	<table cellpadding="0" cellspacing="0">
		<tr>
			<td colspan="3"><%=f_header (getlabel("typnaa") & " - " & rs.fields("typnaa"))%></td>
		</tr>
		<tr>
			<td></td>
			<td>
				<table cellpadding="5" cellspacing="0">
					<tr>
						<td style='width: 300px'>
						<%
						    show_image "projec_images", rs.fields("projec_id"), 1, 300, 0
						%>
						</td>
						<td valign=top>
							<div style="padding: 5px;">
								<table ID="Table2">
									<tr>
										<td style="width: 100px;"><%=getlabel("pronaa")%></td>
										<td><a href='../projects/e_projects_boutyp.asp?viewstate=edit&id=<%=rsP.fields("id") %>'><%=rsP.fields("pronaa")%></a></td>
									</tr>
									<tr>
										<td><%=getlabel("boutyp")%></td>
										<td><%=rs.fields("typnaa")%></td>
									</tr>									
									
								</table>
							</div>
						</td>
						<td valign=top>
						    &nbsp;
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
			<td colspan=3 class="menu_bar" id="menu_bar">
			    <a class="menu_option" href="../boutyp/e_boutyp.asp?viewstate=view&id=<%=id%>"><%=getlabel("menu_boutyp_0")%></a>
                <span class="menu_divider">|</span>
			    <a class="menu_option" href="../boutyp/e_boutyp_bounum.asp?viewstate=view&id=<%=id%>"><%=getlabel("menu_boutyp_bounum")%></a>
			    <span class="menu_divider">|</span>
			    <a class="menu_option" href="../boutyp/e_boutyp_notes.asp?viewstate=view&id=<%=id%>&inreto=boutyp&inreto_id=<%=id%>"><%=getlabel("menu_notes")%></a>
			    <span class="menu_divider">|</span>
			    <a class="menu_option" href="../boutyp/e_pictures.asp?viewstate=view&id=<%=id%>&inreto=boutyp&inreto_id=<%=id%>"><%=getlabel("pictures")%></a>
			    <span class="menu_divider">|</span>
			    <a class="menu_option" href="../boutyp/e_boutyp_correspondence_list.asp?viewstate=view&id=<%=id%>&inreto=bounum&inreto_id=<%=id%>"><%=getlabel("menu_correspondence")%></a>
			    <span class="menu_divider">|</span>
			    <a class="menu_option" href="../memi/l_keuzen.asp?viewstate=view&id=<%=id%>&keusoo_soonaa=W&koppel_id=<%=id%>&projec_id=<%=projec_id %>"><%=getlabel("menu_woonwensen")%></a>
	
			</td>
		</tr>
	</table>
</div>
<%	
			
			set rs = nothing
			set rsP = nothing
		end if
	end function
%>
