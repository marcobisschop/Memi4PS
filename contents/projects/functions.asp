<%
	function projects_header(id)
		if id = 0 then
%>
<div class="relations_header">
    <%f_header getlabel("new_project")%>
</div>
<%	
		else
			dim rs, sql
			sql = "select * from projec where id=" & id
			set rs= getrecordset(sql, true)
			with rs
			%>
<div class="relations_header">
	<table cellpadding="0" cellspacing="0">
		<tr>
			<td colspan="3"><%=f_header (rs.fields("pronaa"))%></td>
		</tr>
		<tr>
			<td></td>
			<td>
				<table cellpadding="5" cellspacing="0">
					<tr>
						<td style='width: 300px'>
						<%
						    show_image "projec_images", id, 1, 180, 0
						%>
						</td>
						<td valign=top>
							<div style="padding: 5px;">
								<table ID="Table2">
									<tr>
										<td style="width: 100px;"><%=getlabel("projec")%></td>
										<td><a href='/contents/projects/e_projects.asp?viewstate=view&id=<%=rs.fields("id") %>'><%=.fields("pronaa")%></a></td>
									</tr>
									<tr>
										<td style="width: 100px;"><%=getlabel("pronum")%></td>
										<td><%=.fields("pronum")%></td>
									</tr>
									<tr>
										<td><%=getlabel("startd")%></td>
										<td><%=.fields("startd")%></td>
									</tr>
									<tr>
										<td><%=getlabel("eindda")%></td>
										<td><%=.fields("eindda")%></td>
									</tr>
								</table>
							</div>
						</td>
						<td valign=top>
						    <div style="padding: 5px;">
								<b>
									<%=getlabel("address")%>
								</b>
								<br>
								<table ID="Table1">
									<tr>
										<td>
											<%=.fields("adrcor1")%><br>
											<%=.fields("adrcor2")%><br>
											<%=.fields("adrcor3")%><br>
											<%=.fields("adrcor4")%><br>											
										</td>
									</tr>
								</table>
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
			<td colspan=3 class="menu_bar" id="menu_bar">
			    <a class="menu_option" href="../projects/e_projects.asp?viewstate=view&id=<%=id%>"><%=getlabel("menu_projects_0")%></a>
			    <span class="menu_divider">|</span>
			    <a class="menu_option" href="../projects/e_projects_prorel.asp?viewstate=view&id=<%=id%>"><%=getlabel("prorel")%></a>
			    <span class="menu_divider">|</span>
			    <a class="menu_option" href="../projects/e_projects_deelnemers.asp?viewstate=view&id=<%=id%>"><%=getlabel("prodeelnemers")%></a>
			    <span class="menu_divider">|</span>
			    <a class="menu_option" href="../projects/e_projects_boutyp.asp?viewstate=view&id=<%=id%>"><%=getlabel("menu_projec_boutyp")%></a>
			    <span class="menu_divider">|</span>
			    <a class="menu_option" href="../projects/e_projects_bounum.asp?viewstate=view&id=<%=id%>"><%=getlabel("menu_projec_bounum")%></a>
			    <span class="menu_divider">|</span>
			    <a class="menu_option" href="../projects/e_projects_fases.asp?viewstate=view&projec_id=<%=id%>"><%=getlabel("menu_projec_fases")%></a>
			    <span class="menu_divider">|</span>
			    <a class="menu_option" href="../projects/e_projects_notes.asp?viewstate=view&id=<%=id%>&inreto=projects&inreto_id=<%=id%>"><%=getlabel("menu_notes")%></a>
			    <span class="menu_divider">|</span>
			    <a class="menu_option" href="../memi/l_keuzen.asp?viewstate=view&id=<%=id%>&keusoo_soonaa=P&koppel_id=<%=id%>"><%=getlabel("menu_woonwensen")%></a>
			    <span class="menu_divider">|</span>
			    <a class="menu_option" href="../projects/l_proslu.asp?viewstate=new&id=<%=id%>&projec_id=<%=id%>"><%=getlabel("proslu")%></a>
			    <span class="menu_divider">|</span>
			    <a class="menu_option" href="../projects/e_modules.asp?viewstate=edit&id=<%=id%>"><%=getlabel("projec_mod")%></a>
			    <span class="menu_divider">|</span>
			    <a class="menu_option" href="../agenda/l_agenda.asp?inreto=projec&inreto_id=<%=id%>"><%=trim(getlabel("agenda"))%></a>
			    <span class="menu_divider">|</span>
			    <a class="menu_option" href="../news/l_news.asp?inreto=projec&inreto_id=<%=id%>"><%=trim(getlabel("news"))%></a>
			     <span class="menu_divider">|</span>
			    <a class="menu_option" href="../projects/l_images.asp?inreto=projec&id=<%=id%>"><%=trim(getlabel("images"))%></a>
			     <span class="menu_divider">|</span>
			    <a class="menu_option" href="../projects/l_bouwplaatsfotos.asp?inreto=projec_bouwplaatsfotos&id=<%=id%>"><%=trim(getlabel("bouwplaatsfotos"))%></a>
			     <span class="menu_divider">|</span>
			    <a class="menu_option" href="../projects/l_factur.asp?inreto=projec&id=<%=id%>"><%=trim(getlabel("facturatie"))%></a>
			     <span class="menu_divider">|</span>
			    <a class="menu_option" href="../projects/l_keuset.asp?viewstate=list&projec_id=<%=id%>"><%=trim(getlabel("keuset"))%></a>
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
