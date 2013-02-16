<%
	function has_attachments(notes_id)
		dim rs, sql
		sql = "select count(*) from notes_attachments where notes_id=" & notes_id
		set rs = getrecordset(sql, true)
		if cint(rs.fields(0)) > 0 then
			has_attachments = true
		else
			has_attachments = false
		end if
		set rs = nothing
	end function

    function r_tasks (inreto, inreto_id)
        dim rs, sql
        
        dim subject
        subject = fieldvalue(rs, "subject")
        
        if len(subject)>0 then
            sql = "insert into notes (subject, inreto, inreto_id) values ('" & subject & "','" & inreto & "'," & inreto_id & ")"
            executesql sql
        end if
       
        sql = "select * from notes where inreto='" & inreto & "' and inreto_id=" & inreto_id
        set rs = getrecordset(sql,true)
       
        
        with rs
            %>
            <table style="width:100%">
                <%f_form_hdr() %>
                <tr>
                    <td colspan=2><input onblur="document.all.taskform.submit()" style="width:100%" type=text id=subject name=subject value="" /></td>
                </tr>
                </form>
            <%
            
            do until .eof
                %>
                <tr>
                    <td><%=.fields("subject") %>&nbsp;</td>
                    <td align=right><a href="<%=WebPath%>include/deletenotes.asp?previouspage=/contents/<%=inreto%>.asp&previousid=<%=.fields("inreto_id")%>&id=<%=.fields("id")%>"><img title="<%=getLabel("delete")%>" src="<%=WebPath%>images/buttons/i.p.delete.gif" border="0"></a></td>
                </tr>
                <%
                .movenext
            loop
            %>
            </table>
            <%
        end with
        set rs = nothing    
    end function

    function r_noteheaders(inreto, inreto_id)
        Dim rs, sql
		sql = "select * from Notes where inreto='" & inreto & "' and inreto_id = " & inreto_id & " order by created desc"
		set rs = getrecordset(sql, True)
		with rs
		    if not .eof then
		        %><table style="padding: 2px" cellpadding=0 cellspacing=0><%
		        do until .eof
    		        %>
    		        <tr>
    		            <td><a href="<%=webpath %>richtextbox/edit.asp?viewstate=edit&id=<%=.fields("id") %>"><%=.fields("subject") %></a></td>
    		        </tr>
    		        <%        
		            .movenext
		        loop
		        %></table><%
		    end if
        end with        
    end function

	function r_notes (Label, inreto, inretoID)
		Dim rs, sql
		if inretoid = 0 then
			sql = "select * from Notes where inreto='" & inreto & "' order by created desc"
		else
			sql = "select * from Notes where inreto='" & inreto & "' and inreto_id = " & inretoID & " order by created desc"
		end if
		set rs = getrecordset(sql, True)
		with rs
        If CAN_EDIT Then    
		%>	
		<div class="rolodex">
		    <a href="<%=WebPath%>richtextbox/edit.asp?label=<%=Label%>&viewstate=new&inreto=<%=inreto%>&inreto_id=<%=inretoid%>&id=-1"><%=getlabel("new")%></a>
		</div>
		<%
		End If
		%>
		<table style="width:100%">
		<%
			do until .eof
		%>
			<tr>
				<td valign="top" style="width:25px">
					<%If CAN_EDIT Then%>
					<a href="<%=WebPath%>richtextbox/edit.asp?label=<%=Label%>&viewstate=edit&id=<%=.fields("id")%>">
					<img title="<%=getlabel("edit")%>" src="<%=WebPath%>images/page.gif" style="cursor:hand" border="0">
					</a>
					<%End If%>
				</td>
				<td style="border-top:1px solid;width:25px" valign="top">
					<%
					if has_attachments(.fields("id")) then
					%><img src="<%=webpath%>images/paperclip.gif"><%
					else
					%>&nbsp;<%
					end if
					%>
				</td>
				<td style="border-top:1px solid" valign="top">
                    <b><%=.fields("subject")%></b><br>
					<%=left(.fields("body"),500)%>
				</td>
				<td style="border-top:1px solid" valign="top" align="right" nowrap>
					<%
						dim dat, adfull
						dat = Right("00"& Day(rs.fields("edited")),2) & "-" & Right("00"& month(rs.fields("edited")),2) & "-" & Year(rs.fields("edited"))
						adfull = ""
						response.Write adfull & "<br>" & dat
					%>	
				</td>
				<td valign="top">
					<%
						doc = Request.ServerVariables("script_name")
					%>
					<%If CAN_EDIT Then%>
					<a href="<%=WebPath%>include/deletenotes.asp?previouspage=<%=doc%>&previousid=<%=.fields("inreto_id")%>&id=<%=.fields("id")%>"><img title="<%=getLabel("delete")%>" src="<%=WebPath%>images/buttons/i.p.delete.gif" border="0"></a>
					<%End If%>
				</td>
				
			</tr>
			<tr>
				<td colspan="2">&nbsp;</td>
				<td colspan="3">
<%
	dim rsAttach
	sql = "select id, description from notes_attachments where notes_id=" & rs.fields("id")
	set rsAttach = getrecordset(sql,true)
	With rsattach
		If not .eof then
			do until .eof
				response.write "&nbsp;<a target='" & .fields("description") & "' href='" & WebPath & "include/file.asp?table=notes_attachments&id=" & .fields("id") & "'>" & .fields("description") & "</a>," 
				.movenext
			loop
		end if
	End With
	set rsAttach = nothing
	
%>
				</td>
			</tr>
		<%		
				.movenext
			loop
		%>
		</table>
		<%
		end with
		set rs = nothing		
	end function
%>