<%
	function bounum_header(id)
	
		if id = 0 then
%>
<div class="relations_header">
    <%f_header getlabel("new_project")%>
</div>
<%	
		else
			dim rs, sql, sqlP, sqlW, rsP, rsW, sqlK, rsK
			sql = "select * from bounum where id=" & id
			set rs= getrecordset(sql, true)
			sqlP = "select * from projec where id=" & rs.fields("projec_id")
			sqlW = "select * from boutyp where id=" & rs.fields("boutyp_id")
			sqlK = "select * from vw_kopers where bounum_id=" & id & " order by achter"
			sqlK = "select *,'t' as task from vw_prodee where projec_id in (select projec_id from bounum where id=" & id & ") and voorkeur=" & id
			set rsP = getrecordset(sqlP, true)
			set rsW = getrecordset(sqlW, true)
			set rsK = getrecordset(sqlK, true)
			with rs
			%>
<div class="relations_header">
	<table cellpadding="0" cellspacing="0">
		<tr>
			<td colspan="3"><%=f_header (getlabel("bounum") & ": " & rs.fields("extnum") & rs.fields("exttoe"))%></td>
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
								<b>
									<%=getlabel("bounum") & ": " & rs.fields("extnum") & rs.fields("exttoe")%>
								</b>
								<br>
								<table ID="Table2">
									<tr>
										<td style="width: 100px;"><%=getlabel("pronaa")%></td>
										<td><a href='../projects/e_projects.asp?viewstate=edit&id=<%=rsP.fields("id") %>'><%=rsP.fields("pronaa")%></a></td>
									</tr>
									<tr>
										<td><%=getlabel("boutyp")%></td>
										<td><a href="../boutyp/e_boutyp_bounum.asp?viewstate=view&id=<%=rsW.fields("id")%>"><%=rsW.fields("typnaa")%></a></td>
									</tr>									
									<tr>
										<td valign=top><%=getlabel("kopers")%>
										
										<a href="e_bounum_nieuwe_koper.asp?id=<%=id%>">+</a>
										
										</td>
										<td>
										<%
										with rsK
										    do until .eof
										        response.write "<a href='../bounum/e_bounum_koper.asp?viewstate=view&id=" & .fields("relati_id") & "&bounum_id=" & id & "'>" & .fields("contacts_name") & "</a>" 
										        
										        .movenext
										        if not .eof then response.Write ", "
										    loop
										end with										
										%></td>
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
											<%=.fields("adrstr")%>&nbsp;<%=.fields("adrnum")%>&nbsp;<%=.fields("adrtoe")%><br />
											<%=.fields("adrpos")%>&nbsp;<%=.fields("adrpla")%><br>
											<%=.fields("adrlan")%><br>											
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
			    <a class="menu_option" href="../bounum/e_bounum.asp?viewstate=view&id=<%=id%>"><%=getlabel("menu_bounum_0")%></a>
                <span class="menu_divider">|</span>
			    <a class="menu_option" href="../bounum/e_bounum_kopers.asp?viewstate=view&id=<%=id%>"><%=getlabel("menu_bounum_kopers")%></a>
			    <span class="menu_divider">|</span>
			    <a class="menu_option" href="../bounum/e_bounum_notes.asp?viewstate=view&id=<%=id%>&inreto=bounum&inreto_id=<%=id%>"><%=getlabel("menu_notes")%></a>
			    <span class="menu_divider">|</span>
			    <a class="menu_option" href="../bounum/e_pictures.asp?viewstate=view&id=<%=id%>&inreto=bounum&inreto_id=<%=id%>"><%=getlabel("pictures")%></a>
			    <span class="menu_divider">|</span>
			    <a class="menu_option" href="../bounum/e_bounum_projec_plagro_loting.asp?viewstate=edit&id=<%=id%>"><%=getlabel("menu_loting")%></a>
			    <span class="menu_divider">|</span>
			    <a class="menu_option" href="../bounum/e_bounum_correspondence_list.asp?viewstate=view&id=<%=id%>&inreto=bounum&inreto_id=<%=id%>"><%=getlabel("menu_correspondence")%></a>
			    <span class="menu_divider">|</span>
			    <a class="menu_option" href="../memi/l_keuzen.asp?viewstate=view&id=<%=id%>&keusoo_soonaa=B&koppel_id=<%=id%>"><%=getlabel("menu_woonwensen")%></a>
	            <span class="menu_divider">|</span>
			    <a class="menu_option" href="../bounum/l_bouslu.asp?viewstate=new&id=<%=id%>&bounum_id=<%=id%>"><%=getlabel("bouslu")%></a>

			</td>
		</tr>
	</table>
</div>
<%	
			end with
			set rs = nothing
			set rsP = nothing
			set rsW = nothing
		end if
	end function
%>
