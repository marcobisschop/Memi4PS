<!-- #include file="../../templates/headers/content.asp" -->
<%
	Dim ids, obj, projec_id
		
	ids = viewstate_value("inreto_id")
	obj = viewstate_value("inreto")
	projec_id = viewstate_value("projec_id")
	
	'response.Write obj & "<br>"
	'response.Write ids & "<br>"
	
	dim rs, sql
	
	select case lcase(obj)
	case "deelnemers"
		sql = "select *, contacts_name as contacts_name3 from vw_deelnemers where relati_id in (" & ids & ")"
		set rs = getrecordset(sql, true)
	case else
	end select
	
	if ispostback() then
	    'if isarray(ids) then
	        idArray = split(ids, ",")
	        for i = lbound(idArray) to ubound(idArray)
	            if idArray(i) <> 0 then
    	            sql = "exec sp_projec_maakdeelnemer " & projec_id & ", " & idArray(i)
    	            'response.Write sql & "<br>"
	                executesql sql
	            end if
	        next
	    'else
        '        sql = "exec sp_projec_maakdeelnemer " & projec_id & ", " & ids
        '        executesql sql
	    'end if
	    'response.Redirect "e_projects_deelnemers.asp?viewstate=view&id="& projec_id
	end if

    f_header getlabel("hdr_projec_add_deelnemers")	
%>
<p>
Selecteer het project waaraan u de deelnemers wilt toevoegen:
</p>
<%
    f_form_hdr()
%>
    <input type="hidden" id="inreto" name="inreto" value="<%=obj %>" />
    <input type="hidden" id="inreto_id" name="inreto_id" value="<%=ids %>" />
    <input type="hidden" id="projec_id" name="projec_id" value="<%=projec_id %>" /> 
<ul>
    <%
    sql = "select id, pronaa from projec order by pronaa"
    set rs =getrecordset(sql , true)
    with rs
        if not .eof then 
        do until .eof
            %>
            <li><a href="javascript:document.all.projec_id.value=<%=.fields("id") %>; document.edit.submit();"><%=.fields("pronaa") %></a></li>
            <%
            .movenext
        loop 
        else
        %>
        <li>Er zijn geen projecten beschikbaar op dit moment!</li>
        <%
        end if
    end with 
    set rs = nothing  
    %>
</ul>
<input type="button" value="Annuleren" id="cancel" name="cancel" onclick="history.back(-1)">
     
</form>

<!-- #include file="../../templates/footers/content.asp" -->
