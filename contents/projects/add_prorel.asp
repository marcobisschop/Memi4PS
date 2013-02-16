<!-- #include file="../../templates/headers/content.asp" -->
<%
	Dim ids, obj, projec_id, relsoo_id, regrkp_id
		
	ids = viewstate_value("inreto_id")
	obj = viewstate_value("inreto")
	projec_id = viewstate_value("projec_id")
	relsoo_id = viewstate_value("relsoo_id")
	
	'response.Write obj & "<br>"
	'response.Write ids & "<br>"
	
	dim rs, sql
	
	select case lcase(obj)
	case "relations_contacts"
		sql = "select * from vw_contacts where relati_id in (" & ids & ")"
		set rs = getrecordset(sql, true)
	case else
	end select
		
	if ispostback() then
	
	    idArray = split(ids, ",")
	    
	    for i = lbound(idArray) to ubound(idArray)
	        if idArray(i) <> 0 then
	            sql = "select regrkp_id from vw_contacts where relati_id=" & idArray(i)
    	        set rs = getrecordset(sql, true)
	            regrkp_id = rs.fields("regrkp_id")
	            set rs = nothing
	            sql = "exec sp_prorel_insert " & sec_currentuserid & ", " & regrkp_id & ", " & projec_id & ", " & relsoo_id
	            executesql sql
	        end if
	    next
	
	    response.Redirect "e_projects_prorel.asp?viewstate=view&id=" & projec_id
	
	end if

    f_header getlabel("hdr_projec_add_deelnemers")	
%>
<p>
Selecteer het project waaraan u de deelnemers wilt toevoegen:
</p>
<%
    if uploader.form("postback") <> "change" then
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
                    <li><a href="javascript:document.all.postback.value='change';document.all.projec_id.value=<%=.fields("id") %>; document.edit.submit();"><%=.fields("pronaa") %></a></li>
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
    <%
     else
    f_form_hdr()
    %>
        <input type="hidden" id="inreto" name="inreto" value="<%=obj %>" />
        <input type="hidden" id="inreto_id" name="inreto_id" value="<%=ids %>" />
        <input type="hidden" id="projec_id" name="projec_id" value="<%=projec_id %>" /> 
        <input type="hidden" id="relsoo_id" name="relsoo_id" value="<%=relsoo_id%>" /> 
    <ul>
        <%
        sql = "select id, soobes from relsoo order by soonaa"
        set rs =getrecordset(sql , true)
        with rs
            if not .eof then 
            do until .eof
                %>
                <li><a href="javascript:document.all.postback.value='true';document.all.relsoo_id.value=<%=.fields("id") %>; document.edit.submit();"><%=.fields("soobes") %></a></li>
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
<%
    end if
%>
<!-- #include file="../../templates/footers/content.asp" -->
