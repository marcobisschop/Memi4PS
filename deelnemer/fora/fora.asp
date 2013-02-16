<!-- #include file="../../templates/headers/content.asp" -->
<!-- #include file="../inc/functions.asp" -->
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
	
	
	sql = "select * from vw_fora where id=" & session("fora_id")
	set rsFora = getrecordset(sql, true)
	
	if rsFora.eof then
	    fase_header session("projec_id"), 0
	else
	    fase_header session("projec_id"), rsFora.fields("projec_fases_id")
	end if

    if cbool(dblookup("fora","id",session("fora_id"),"closed")) then response.write "<h1 style='color:red'>" & getlabel("fora_gesloten") & "</h1>"

	if viewstate_value("no") = "no" then
	    sql = "select * from vw_forum where fora_id=" & session("fora_id") & " order by forum_edited desc"
	else
	    sql = "select * from vw_forum where fora_id=" & session("fora_id") & " order by forum_edited asc"
	end if
	set rs = getrecordset(sql, true)
	
	with rs
	     %>
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
	    <tr>
	        <td colspan="2">
	            <%
	            if viewstate_value("no") = "no"  then
	            %><a href="fora.asp?fora_id=<%=session("fora_id") %>&no=on"><%=getlabel("oud>nieuw") %></a><%
	            else 
	            %><a href="fora.asp?fora_id=<%=session("fora_id") %>&no=no"><%=getlabel("nieuw>oud") %></a><%
	            end if
	            %>
	        </td>
	    </tr>
	    
	    <%
	    if not .eof then
	   
	    do until .eof
	        if .absoluteposition mod 2 = 0 then bgcolor = "#ffffff" else bgcolor = "#D0D0D0"
	        %>
	                <tr>
	                    <td style="background-color: <%=bgcolor %>"><%=.fields("forum_txt") %></td>
	                </tr>
	                <tr>
	                    <td style="background-color: <%=bgcolor %>" style="color: #ff0000" align="right"><%=.fields("contacts_name") %> - <%=.fields("forum_created") %></td>
	                </tr>
	                <tr>
	                <td colspan="2"><hr /></td>
	                </tr>
	        <%
	        .movenext
	    loop
	    %>
	    </table>
	    <!--
	    <table style="width: 100%" cellspacing="0" cellpadding="10">
	    <tr>
	        <td colspan="2">
	            <%f_form_hdr() %> 
	           <input type="hidden" id="fora_id" name="fora_id" value="<%=fora_id %>" />
	            Type hier uw reactie en druk vervolgens op reactie toevoegen
	            <textarea style="width: 100%; height: 50px" id="comment" name="comment"></textarea>
	            <input type="submit" value="Reactie toevoegen" /> 
	            </form>
	        </td>
	    </tr>
	    -->
	    <%
	    end if
	end with
	
	set rs = nothing	
%>
<!-- #include file="../../templates/footers/content.asp" -->
