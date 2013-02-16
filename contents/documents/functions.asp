<% 
function header(id)
    f_header getlabel("docum")
        
	if id = 0 then
        
    else
        dim rs,  sqlP, sqlW, rsP, rsW, sqlK, rsK
        sql = "select * from docum where id=" & id
        set rs= getrecordset(sql, true)
        with rs
        %>
        <div class="relations_header">
            <table cellpadding="0" cellspacing="0">
	            <tr>
		            <td></td>
		            <td>
       		            <div style="padding: 5px;">
				            <table ID="Table2">
				                <tr>
						            <td style="width: 100px;"><%=getlabel(.fields("inreto"))%></td>
						            <td>
				                    <%
				                        select case lcase(.fields("inreto"))
				                        case "keuzen"
				                            response.write "<a href='../memi/e_pictures.asp?viewstate=view&id=" & .fields("inreto_id") & "'>" & dblookup("keuzen","id",.fields("inreto_id"),"keucod") & "</a>"
				                        case "projec"
				                            response.write "<a href='../projects/e_projects.asp?viewstate=view&id=" & .fields("inreto_id") & "'>" & dblookup("projec","id",.fields("inreto_id"),"pronaa") & "</a>"
				                        case "bounum"
				                            response.write "<a href='../bounum/e_bounum.asp?viewstate=view&id=" & .fields("inreto_id") & "'>" & dblookup("bounum","id",.fields("inreto_id"),"extnum") & dblookup("bounum","id",.fields("inreto_id"),"exttoe") & "</a>"
				                        end select				                
				                    %>
				                    </td>
				                </tr>
					            <tr>
						            <td style="width: 100px;"><%=getlabel("docnaa")%></td>
						            <td><%=.fields("docnaa")%></td>
					            </tr>
					            <tr>
						            <td><%=getlabel("docbes")%></td>
						            <td><%=.fields("docbes")%></td>
					            </tr>									
					            <tr>
						            <td><%=getlabel("docnum")%></td>
						            <td><%=.fields("docnum")%></td>
					            </tr>									
				            </table>
			            </div>
	                </td>
		            <td></td>
	            </tr>
	            <tr>
		            <td colspan=3 class="menu_bar">
		                <a class="menu_option" href="e_documents.asp?viewstate=view&id=<%=id%>"><%=getlabel("menu_general")%></a>
		                <span class="menu_divider">|</span>
		                <a class="menu_option" href="e_notes.asp?viewstate=view&id=<%=id%>&inreto=docum&inreto_id=<%=id%>"><%=getlabel("menu_notes")%></a>
		                <span class="menu_divider">|</span>
		                <a class="menu_option" href="a_documents.asp?viewstate=view&id=<%=id%>&inreto=docum&inreto_id=<%=id%>"><%=getlabel("menu_documents")%></a>
		                <span class="menu_divider">|</span>
		                <a class="menu_option" href="e_availability.asp?viewstate=edit&id=<%=id%>"><%=getlabel("menu_avalilablity")%></a>
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