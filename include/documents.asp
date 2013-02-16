<%
    function r_documents (inreto, inreto_id)
		Dim rs, sql, fields, orderby
		sql = "select id,arcnaa,arccon,arcsiz,wijdat,available,volgor, 'x' as del from dosarc where inreto='" & inreto & "' and inreto_id = " & inreto_id & ""
		
		' response.write sql
		
		fields = "$name:=id;type:=checkbox;boundcolumn:=id;$"
		fields = fields & "$name:=arcnaa;type:=link;url:=../documents/e_dosarc.asp?viewstate=edit&id=~id~;$"
		fields = fields & "$name:=available;type:=bit;class:=dosarc;field:=available;id:=~id~;$"
	    fields = fields & "$name:=volgor;type:=order;class:=dosarc;field:=volgor;id:=~id~;$"
	    fields = fields & "$name:=del;type:=delete;class:=dosarc;boundcolumn:=id;id:=~id~;$"
	
		orderby = "volgor, arcnaa"
%>
		<div class="rolodex">
		    
		    <script language="javascript" type="text/javascript">
	        <!-- Begin
	        function go(a)
	        {
                var el      = document.createElement("input");
                var el2     = document.createElement("input");
                var el3     = document.createElement("input");
                var link    = "../documents/action.asp";                
                el.type     = "hidden";
                el.name     = "action";
                el.value    = a
	            el2.type    = "hidden";
                el2.name    = "inreto_id" ;
                el2.value   = "<%=inreto_id %>";
	            el3.type    = "hidden";
                el3.name    = "inreto";
                el3.value   = "<%=inreto %>";
	            document.list.action = link;
                document.list.appendChild(el);
                document.list.appendChild(el2);
                document.list.appendChild(el3);
                document.list.submit();
	        }	
	        //  End -->
	        </script>	

            <a title="<%=getlabel("new") %>" href="javascript: go('new_dosarc');"><img src="/images/actions/documents/nieuw.gif" /></a>
            <span class="divider">|</span>
            <a title="<%=getlabel("delete") %>" href="javascript: go('delete');"><img src="/images/actions/documents/verwijderen.gif" /></a>
            <span class="divider">|</span>
            <a title="<%=getlabel("cut") %>" href="javascript: go('cut');"><img src="/images/actions/documents/cut.png" /></a>
            <a title="<%=getlabel("copy") %>" href="javascript: go('copy');"><img src="/images/actions/documents/kopieren.gif" /></a>
        <%if len(session(inreto & "_ids"))>0 then %>    
            <a title="<%=getlabel("paste") %>" href="javascript: go('paste');"><img src="/images/actions/documents/plakken.gif" /></a>
        <%end if %>
        </div>  
<%
		r_list sql, fields, orderby		
		
		if len(session(inreto & "_ids")) then
        if keusoo_soonaa = session("keusoo_soonaa") or keusoo_soonaa = "P" and session("keusoo_soonaa") = "S" or keusoo_soonaa = "W" and session("keusoo_soonaa") = "P" or keusoo_soonaa = "B" and session("keusoo_soonaa") = "W" Then
                
            f_header getlabel("copy_buffer") 
            %><br /><br /><%
            sql = "select arcnaa,id from dosarc where id in (" & session(inreto & "_ids") & ")"
            rw sql
            set rs = getrecordset(sql, true)
            with rs
                do until .eof
                    %><a target="_blank" href="e_dosarc.asp?viewstate=edit&id=<%=.fields("id") %>"><%=.fields("arcnaa")%></a><%
                    if not .eof then
                        %>, <%
                        .movenext
                    end if
                loop
            end with
            set rs = nothing
        %>
        <br /><br />
        <a title="<%=getlabel("empty_buffer") %>" href="../documents/action.asp?action=empty_buffer&inreto=dosarc"><img src="/images/actions/documents/verwijderen.gif" /></a>
        <%
        end if        
    end if
	end function
%>