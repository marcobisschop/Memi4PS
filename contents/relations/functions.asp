<%
	function relations_header(relations_id)
		if not isnumeric(relations_id) then relations_id = -1
		if relations_id <= 0 then
%>
<div class="relations_header">
    <%f_header getlabel("new_relation")%>
</div>
<%		
		else
			dim rs, sql
			sql = "select * from vw_relations where id=" & relations_id
			set rs= getrecordset(sql, true)
			with rs
			%>
<div class="relations_header">
	<table cellpadding="0" cellspacing="0">
		<tr>
			<td colspan="3"><%=f_header (rs.fields("bednaa"))%></td>
		</tr>
		<tr>
			<td></td>
			<td>
				<table cellpadding="5" cellspacing="0">
					<tr>
						<td style="width:96px; height:120px"><img style="width:96px; height:120px" src="../../images/relations/image.asp?sn=<%=.fields("bednaa")%>"></td>
						<td valign=top>
							<div style="padding: 5px;">
								<b>
									<%=.fields("bednaa")%>
								</b>
								<br>
								<table ID="Table2">
									<tr>
										<td>
										    <%=.fields("adrstr")%><br />
										    <%=.fields("adrpos")%>
										</td>
									</tr>
								</table>
							</div>
							<div style="padding: 5px;">
								<b>
									<%=getlabel("contact")%>
								</b>
								<br>
								<table>
									<tr>
										<td style="width: 100px;"><%=getlabel("adrtel")%></td>
										<td><%=.fields("adrtel")%></td>
									</tr>
									<tr>
										<td><%=getlabel("adrfax")%></td>
										<td><%=.fields("adrfax")%></td>
									</tr>
									<tr>
										<td><%=getlabel("adrema")%></td>
										<td><a href="mailto:<%=.fields("adrema")%>"><%=.fields("adrema")%></a></td>
									</tr>
									<tr>
										<td><%=getlabel("adrwww")%></td>
										<td><a target="_blank" href="http://<%=.fields("adrwww")%>"><%=.fields("adrwww")%></a></td>
									</tr>
								</table>
							</div>
						</td>
						<td valign=top>
							<div style="padding: 5px;">
							    <b>
									<%=getlabel("postadres")%>
								</b>
								<br>
								<table ID="Table1">
									<tr>
										<td>
										    <%=.fields("posstr")%>&nbsp;
										    <%=.fields("pospos")%><br>										 
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
			<td colspan=3 class="menu_bar">
			    <a class="menu_option" href="e_relations.asp?viewstate=view&id=<%=relations_id%>"><%=getlabel("menu_relations_0")%></a>
			    <span class="menu_divider">|</span>
			    <a class="menu_option" href="e_relations_distinctives.asp?viewstate=view&id=<%=relations_id%>"><%=getlabel("menu_relations_distinctives")%></a>
			    <span class="menu_divider">|</span>
			    <a class="menu_option" href="e_relations_1.asp?viewstate=view&id=<%=relations_id%>"><%=getlabel("menu_relations_1")%></a>
			    <span class="menu_divider">|</span>
			    <a class="menu_option" href="e_relations_notes.asp?viewstate=view&id=<%=relations_id%>&inreto=relations&inreto_id=<%=relations_id%>"><%=getlabel("menu_relations_notes")%></a>
			    <span class="menu_divider">|</span>
			    <a class="menu_option" href="e_relations_correspondence_list.asp?viewstate=view&id=<%=relations_id%>&inreto=relations&inreto_id=<%=relations_id%>"><%=getlabel("menu_relations_correspondence")%></a>
			</td>
		</tr>
	</table>
</div>
<%	
			end with
			set rs = nothing
		end if
	end function

	function contacts_header(contacts_id)
	    if not isnumeric(contacts_id) then contacts_id = -1
		if contacts_id <= 0 then
%>
<div class="relations_header">
    <%f_header getlabel("new_relation")%>
</div>
<%		else
			dim rs, sql, rsR, sqlR, RName
			sql = "select * from vw_contacts where relati_id=" & contacts_id
			set rs= getrecordset(sql, true)
			if isnumeric(rs.fields("bedrij_id")) then
			    sqlR = "select * from vw_relations where id=" & rs.fields("bedrij_id")
			    set rsR = getrecordset(sqlR, true)
			    RName = " - " & rsR.fields("bednaa") & ""
			    set rsR = nothing
			else
			    RName = ""
			end if
			with rs
			%>
<div class="contacts_header">
	<table cellpadding="0" cellspacing="0">
		<tr>
			<td colspan="3"><%=f_header (rs.fields("contacts_name2") & RName)%></td>
		</tr>
		<tr>
			<td></td>
			<td>
				<table cellpadding="5" cellspacing="0">
					<tr>
						<td style="width:96px; height:120px"><img style="width:96px; height:120px" src="../../images/relations/image.asp?sn=<%=.fields("contacts_name")%>"></td>
						<td valign=top>
							<div style="padding: 5px;">
								<b>
									<%=.fields("contacts_name2")%>
								</b>
								<br>
								<table ID="Table3">
									<tr>
										<td>
										    <%=.fields("adresregel3")%><br />
										    <%=.fields("adresregel4")%><br>
										</td>
									</tr>
								</table>
							</div>
							<div style="padding: 5px;">
								<b>
									<%=getlabel("Persoonlijk")%>
								</b>
								<br>
								<table>
									<tr>
										<td style="width: 100px;"><%=getlabel("adrtel")%></td>
										<td><%=.fields("adrtel")%></td>
									</tr>
									<tr>
										<td style="width: 100px;"><%=getlabel("adrmob")%></td>
										<td><%=.fields("telmob")%></td>
									</tr>									
									<tr>
										<td><%=getlabel("adrema")%></td>
										<td><a href="mailto:<%=.fields("adrema")%>"><%=.fields("adrema")%></a></td>
									</tr>
								</table>
							</div>
						</td>
						<td valign=top>
							    <%  
								    if .fields("bedrij_id") > 0 then 
								        sql = "select * from vw_relations where id=" & .fields("bedrij_id")
								        set rsR = getrecordset(sql, true)
								        with rsR
								%>
								<div style="padding: 5px;">
								    <b>
									    <a href="e_relations_1.asp?viewstate=view&id=<%=.fields("id")%>"><%=.fields("bednaa")%></a>
								    </b>
								    <br>
								    <table ID="Table5">
									    <tr>
										    <td>
										        <%=.fields("adrstr")%><br>
										        <%=.fields("adrpos")%><br>
										    </td>
									    </tr>
								    </table>
							    </div>
							    <div style="padding: 5px;">
								    <b>
									    <%=getlabel("contact")%>
								    </b>
								    <br>
								  <table ID="Table4">
									<tr>
										<td style="width: 100px;"><%=getlabel("adrtel")%></td>
										<td><%=rsR.fields("adrtel")%></td>
									</tr>
									<tr>
										<td><%=getlabel("adrfax")%></td>
										<td><%=rsR.fields("adrfax")%></td>
									</tr>
									<tr>
										<td><%=getlabel("adrema")%></td>
										<td><a href="mailto:<%=rsR.fields("adrema")%>"><%=rsR.fields("adrema")%></a></td>
									</tr>
								    <tr>
										<td><%=getlabel("adrwww")%></td>
										<td><a target="_blank" href="http://<%=rsR.fields("adrwww")%>"><%=rsR.fields("adrwww")%></a></td>
									</tr>
								    </table>
							    </div>
								<%      
								        end with
								        set rsR = nothing
								    end if 
								%>
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
			    <a class="menu_option" href="e_relations_contacts.asp?viewstate=view&id=<%=contacts_id%>"><%=getlabel("menu_relations_contacts_1")%></a>
			    <span class="menu_divider">|</span>
			    <a class="menu_option" href="e_contacts_prorel.asp?viewstate=view&id=<%=contacts_id%>"><%=getlabel("prorel")%></a>
			    <span class="menu_divider">|</span>
			    <a class="menu_option" href="e_relations_contacts_distinctives.asp?viewstate=view&id=<%=contacts_id%>"><%=getlabel("menu_relations_contacts_distinctives")%></a>
			    <span class="menu_divider">|</span>
			    <a class="menu_option" href="e_relations_contacts_notes.asp?viewstate=view&id=<%=contacts_id%>&inreto=contacts&inreto_id=<%=contacts_id%>"><%=getlabel("menu_relations_contacts_notes")%></a>
			    <span class="menu_divider">|</span>
			    <a class="menu_option" href="e_relations_correspondence_list.asp?viewstate=view&id=<%=.fields("bedrij_id")%>&inreto=contacts&inreto_id=<%=contacts_id%>"><%=getlabel("menu_relations_correspondence")%></a>
			    <span class="menu_divider">|</span>
			    <a class="menu_option" href="/contents/projects/add_prorel.asp?inreto_id=<%=contacts_id%>"><%=getlabel("menu_projectrol")%></a>
			    
			    
			    
			    
			</td>
		</tr>
	</table>
</div>
<%	
			end with
			set rs = nothing
		end if
	end function


function deelnemers_header(contacts_id)
	    if not isnumeric(contacts_id) then contacts_id = -1
		if contacts_id <= 0 then
%>
<div class="relations_header">
    <%f_header getlabel("new_relation")%>
</div>
<%		else
			dim rs, sql, rsR, sqlR, RName
			sql = "select * from vw_deelnemers where relati_id=" & contacts_id
			set rs= getrecordset(sql, true)
			
			' response.write rs.recordcount
			' response.end
			
			RName = ""
			with rs
			%>
<div class="contacts_header">
	<table cellpadding="0" cellspacing="0">
		<tr>
			<td colspan="3"><%=f_header (rs.fields("contacts_name2") & RName)%></td>
		</tr>
		<tr>
			<td></td>
			<td>
				<table cellpadding="5" cellspacing="0">
					<tr>
						<td style="width:96px; height:120px"><img style="width:96px; height:120px" src="../../images/relations/image.asp?sn=<%=.fields("contacts_name")%>"></td>
						<td valign=top>
							<div style="padding: 5px;">
								<b>
									<%=.fields("contacts_name2")%>
								</b>
								<br>
								<table ID="Table6">
									<tr>
										<td>
										    <%=.fields("adresregel3")%><br />
										    <%=.fields("adresregel4")%><br>
										</td>
									</tr>
								</table>
							</div>
							<div style="padding: 5px;">
								<b>
									<%=getlabel("Persoonlijk")%>
								</b>
								<br>
								<table>
									<tr>
										<td style="width: 100px;"><%=getlabel("adrtel")%></td>
										<td><%=.fields("adrtel")%></td>
									</tr>
									<tr>
										<td style="width: 100px;"><%=getlabel("adrmob")%></td>
										<td><%=.fields("telmob")%></td>
									</tr>									
									<tr>
										<td><%=getlabel("adrema")%></td>
										<td><a href="mailto:<%=.fields("adrema")%>"><%=.fields("adrema")%></a></td>
									</tr>
								</table>
							</div>
						</td>
						<td valign=top>
							   <%
							        if isnumeric(rs.fields("stipp_partnerid")) then
							           dim pSql, rsP
							           pSql = "select * from vw_deelnemers where stipp_key=" & rs.fields("stipp_partnerid")
							           'response.Write pSql
							           set rsP = getrecordset(pSql, true)
							           with rsP
                                %>							           
							    <div style="padding: 5px;">
								<b>
									<%=.fields("contacts_name2")%>
								</b>
								<br>
								<table ID="Table7">
									<tr>
										<td>
										    <%=.fields("adresregel3")%><br />
										    <%=.fields("adresregel4")%><br>
										</td>
									</tr>
								</table>
							</div>
							<div style="padding: 5px;">
								<b>
									<%=getlabel("Persoonlijk")%>
								</b>
								<br>
								<table>
									<tr>
										<td style="width: 100px;"><%=getlabel("adrtel")%></td>
										<td><%=.fields("adrtel")%></td>
									</tr>
									<tr>
										<td style="width: 100px;"><%=getlabel("adrmob")%></td>
										<td><%=.fields("telmob")%></td>
									</tr>									
									<tr>
										<td><%=getlabel("adrema")%></td>
										<td><a href="mailto:<%=.fields("adrema")%>"><%=.fields("adrema")%></a></td>
									</tr>
								</table>
							</div>
							    <%  
							          end with 
							           set rsP = nothing 
							        end if
							   %>
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
			    <a class="menu_option" href="e_deelnemers.asp?viewstate=view&id=<%=contacts_id%>"><%=getlabel("algemeen")%></a>
			    <span class="menu_divider">|</span>
			    <a class="menu_option" href="e_deelnemers_distinctives.asp?viewstate=view&id=<%=contacts_id%>"><%=getlabel("distinctives")%></a>
			    <span class="menu_divider">|</span>
			    <!--//
			    <a class="menu_option" href="e_deelnemers_plaatswensen.asp?viewstate=view&id=<%=contacts_id%>"><%=getlabel("plaatswensen")%></a>
			    <span class="menu_divider">|</span>
			    //-->
			    <a class="menu_option" href="e_deelnemers_notes.asp?viewstate=view&id=<%=contacts_id%>&inreto=contacts&inreto_id=<%=contacts_id%>"><%=getlabel("notes")%></a>
			    <span class="menu_divider">|</span>
			    <!--//
			    <a class="menu_option" href="e_deelnemers_correspondence_list.asp?viewstate=view&inreto=contacts&inreto_id=<%=contacts_id%>"><%=getlabel("correspondence")%></a>
			    <span class="menu_divider">|</span>
			    //-->
			    <a class="menu_option" href="../projects/add_deelnemers.asp?inreto=deelnemers&inreto_id=<%=contacts_id%>"><%=getlabel("maak deelnemer")%></a>
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
