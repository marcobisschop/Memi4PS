<!-- #include file="../../templates/headers/content.asp" -->
<!-- #include file="../../deelnemer/inc/functions.asp" -->
<%
	dim fora_id
	fora_id = viewstate_value("fora_id")
	if isnumeric(fora_id) then session("fora_id") = fora_id else response.Write "AAAA"
	
	viewstate = "savenew" 
	
	if ispostback() then
	
	    session("bounum") = 0
	
	    if len(viewstate_value("comment")) > 0 then
	        set rs = getrecordset("select * from forum where id=-1", false)
	        rs.addnew
	        rs.fields("bounum_id") = session("bounum_id")
			rs.fields("fora_id") = session("fora_id")
			rs.fields("relati_id") = session("relati_id")
			rs.fields("txt") = viewstate_value("comment")
			putrecordset rs
	    end if
	
	end if
	
	
	sql = "select * from vw_fora where id=" & fora_id
	set rsFora = getrecordset(sql, true)
	
	if rsFora.eof then
	    fase_header rsFora.fields("projec_id"), 0
	else
	    fase_header rsFora.fields("projec_id"), rsFora.fields("projec_fases_id")
	end if

	sql = "select * from vw_forum where fora_id=" & session("fora_id")
	set rs = getrecordset(sql, true)
	
	with rs
	    %>
	    <table style="width: 100%" cellspacing="0" cellpadding="10">
	    
	    <%
	    if not .eof then
	    do until .eof
	        if .absoluteposition mod 2 = 0 then bgcolor = "#E0E0E0" else bgcolor = "#D0D0D0"
	        
	            if .fields("contacts_name")&"" = "" then .fields("contacts_name") = "Admin"
	        
	        %>
	                <tr>
	                    <td style="background-color: <%=bgcolor %>"><%=.fields("forum_txt") %></td>
	                </tr>
	                <tr>
	                    <td style="background-color: <%=bgcolor %>; color: #ff0000; border-bottom: solid 1px #a0a0a0" align="left">
	                        <%=.fields("contacts_name") %> - <%=.fields("forum_created") %>
	                        
	                        <% 
	                        
	                            if usercan("delete") then
	                            
	                                rw "<br/><a href='action.asp?action=delete&inreto_fk=" & .fields("forum_id") & "'>delete</a>"
	                            
	                            end if
	                        
	                        %>
	                        
	                    </td>
	                </tr>
	                
	        <%
	        .movenext
	    loop
	    
	    end if
	    %>
	    </table>
	    <table style="width: 100%" cellspacing="0" cellpadding="10">
	    <tr>
	        <td colspan="2">
	            <%f_form_hdr() %> 
	           <input type="hidden" id="Hidden1" name="fora_id" value="<%=fora_id %>" />
	            Type hier uw reactie en druk vervolgens op reactie toevoegen
	            <textarea style="width: 100%; height: 50px" id="Textarea1" name="comment"></textarea>
	            <input type="submit" value="Reactie toevoegen" /> 
	            </form>
	        </td>
	    </tr>
	    </table>
	    <%
	end with
	
	set rs = nothing	
%>
<!-- #include file="../../templates/footers/content.asp" -->
