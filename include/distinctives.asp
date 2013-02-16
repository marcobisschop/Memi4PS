<%
        ' Interface naar table variables.
        ' Hierin staan programma variablen opgesomt
        
        function getdistinctive(name)
            dim rs, sql
            sql = "select * from distinctives where [name]='" & name & "'"
            set rs = getrecordset(sql,true)
            with rs
                if .eof then
                    getvariable = "!! VARIABLE UNDEFINED !! (function:getvariable)"
                else
                    getvariable = .fields("value")
                end if
            end with
            set rs = nothing
        end function

        function getdistinctives(inreto)
            dim rs, sql
            sql = "select * from distinctives where [inreto]='" & inreto & "' order by [group],[name]"
            set getdistinctives = getrecordset(sql,true)            
        end function
        
        function listdistinctives(inreto)
            dim rs, sql
            sql = "select * from distinctives where [inreto]='" & inreto & "' and inuse=1 order by [group],[name]"
            set rs = getrecordset(sql,true)            
            with rs
                f_header getlabel("distinctives")
                %><div style="padding: 5px;"><%
                if .eof then
                    response.write getlabel("no_distinctives") & " : " & inreto
                else
                    %><table style="width:98%" cellpadding=3 cellspacing=0 border=1><% 
                    dim group, fieldsperrow
                    fieldsperrow = 4
                    if viewstate = "view" then
                        do until .eof
                            if group <> .fields("group") then
                                if not .bof then
                                %>
                                    </td>
                                </tr>
                                <%
                                end if
                                %>
                                <tr>
                                    <td class="f_form_divider" colspan="<%=fieldsperrow%> %>"><%=f_frm_divider_nr(getlabel(.fields("group"))) %></td>
                                </tr>
                                <tr>
                                    <td class="" colspan="<%=fieldsperrow%> %>">
                                <%
                                group = .fields("group")
                            end if
                            if distinctive_selected(.fields("id"),inreto,recordid) then
                                response.Write "<b>" & .fields("name") & "</b> - "
                            end if
                        
                            .movenext
                        loop
                    else
                        do until .eof
                            if group <> .fields("group") then
                                %>
                                <tr>
                                    <td class="f_form_divider" colspan="<%=fieldsperrow%> %>"><%=f_frm_divider_nr(getlabel(.fields("group"))) %></td>
                                </tr>
                                <%
                                group = .fields("group")
                            end if
                            %>
                                <%
                                if viewstate="save" then %>
                                    <td nowrap>
                                    <input type="checkbox" <%if distinctive_selected(.fields("id"),inreto,recordid) then response.write "checked" %> id="distinctives_id_<%=.fields("id")%>" name="distinctives_id_<%=.fields("id")%>" value="<%=.fields("id")%>">
                                    <%= .fields("name")%>                            
                                    </td>
                                <%end if %>                            
                            <%
                            if .absoluteposition mod fieldsperrow = 0 then response.Write "<tr>"
                            
                            .movenext
                        loop
                        if .absoluteposition mod fieldsperrow <> 0 then
                            for i = 1 to .recordcount mod fieldsperrow 
                                rw "<td></td>"
                            next                            
                            rw "</tr>"
                        end if                            
                    end if                    
                    %></table><%                    
                end if    
                %></div><%
            end with
            set rs = nothing
        end function
        
        function distinctive_selected(distinctives_id, inreto, inreto_id)
            dim rs, sql
            sql = "select * from distinctives_links where distinctives_id=" & distinctives_id & " and inreto='" & inreto & "' and inreto_id=" & inreto_id
            set rs = getrecordset(sql, true)
            if rs.recordcount > 0 then
                distinctive_selected = true
            else
                distinctive_selected = false
            end if
            set rs =nothing
        end function
        
        function distinctives_save (inreto, inreto_id, distinctives_ids)
        
            ' Collect all distinctive ID's
            For each F in Uploader.FormElements
                if instr(1, F, "distinctives_id_") > 0 then
                    distinctives_ids = distinctives_ids & "," & uploader.form(f)
                end if
            Next
            distinctives_ids = mid(distinctives_ids, 2)
            ' Collect all distinctive ID's
        
            dim sql, ids
            sql = "delete from distinctives_links where inreto='" & inreto & "' and inreto_id=" & inreto_id
            executesql sql
            sql = ""
            if instr(1,distinctives_ids,",") > 0 then
                ids = split(distinctives_ids,",")
                for i = lbound(ids) to ubound(ids)
                    sql = sql & "insert into distinctives_links (inreto, inreto_id, distinctives_id) values ('" & inreto & "'," & inreto_id & "," & ids(i) & ");"
                    executesql sql 
                next
            else
                if distinctives_ids <> "" then
                    sql = sql & "insert into distinctives_links (inreto, inreto_id, distinctives_id) values ('" & inreto & "'," & inreto_id & "," & distinctives_ids & ")"
                    executesql sql           
                end if
            end if
        end function
        
%>