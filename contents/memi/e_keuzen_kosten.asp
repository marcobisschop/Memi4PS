<!-- #include file="../../templates/headers/content.asp" -->
<!-- #include file="functions.asp" -->

<%
	dim recordid
	
	viewstate = viewstate_value("viewstate")
	recordid  = viewstate_value("id")
		
	keuzen_header (recordid)
		
    sql = "exec [sp_keuzen_kosten] " & recordid
    fields = "$name:=id;type:=checkbox;boundcolumn:=id;$"
    fields = fields & "$name:=kosten_id;type:=hidden;boundcolumn:=id;$"
    fields = fields & "$name:=keuzen_id;type:=hidden;boundcolumn:=id;$"
    fields = fields & "$name:=koppel_id;type:=hidden;boundcolumn:=id;$"
    fields = fields & "$name:=soonaa;type:=hidden;boundcolumn:=id;$"
    fields = fields & "$name:=soobes;type:=hidden;boundcolumn:=id;$"
    fields = fields & "$name:=nacbes;type:=hidden;boundcolumn:=id;$"
    fields = fields & "$name:=hoocod;type:=link;url:=e_keuzen_kosten_2.asp?viewstate=edit&id=~kosten_id~&keuzen_id=~keuzen_id~;$"
    fields = fields & "$name:=keusoo_soonaa;type:=link;url:=e_keuzen_kosten_2.asp?viewstate=edit&id=~kosten_id~&keuzen_id=~keuzen_id~;$"
    fields = fields & "$name:=del;type:=delete;class:=kosten;boundcolumn:=kosten_id;id:=~kosten_id~;label:=space;align:=right;$"
    fields = fields & "$name:=norm;type:=text;format:=d3;align:=right;$"
    fields = fields & "$name:=materieel;type:=text;format:=d2;align:=right;calculate:=sum;$"
    fields = fields & "$name:=materiaal;type:=text;format:=d2;align:=right;calculate:=sum;$"
    fields = fields & "$name:=onderaan;type:=text;format:=d2;align:=right;calculate:=sum;$"
    fields = fields & "$name:=prijs;type:=text;format:=d2;align:=right;calculate:=sum;$"
    fields = fields & "$name:=bedrag;type:=text;format:=d2;align:=right;calculate:=sum;$"
    fields = fields & "$name:=uren;type:=text;format:=d2;align:=right;calculate:=sum;$"
    
    orderby = ""
%>
<div class="rolodex">
		    
    <script language="javascript" type="text/javascript">
        function go(a) {
            var el = document.createElement("input");
            var el2 = document.createElement("input");
            var el3 = document.createElement("input");
            var link = "../memi/action.asp";
            el.type = "hidden";
            el.name = "action";
            el.value = a
            el2.type = "hidden";
            el2.name = "inreto_id";
            el2.value = "<%=recordid %>";
            el3.type = "hidden";
            el3.name = "inreto";
            el3.value = "kosten";
            document.list.action = link;
            document.list.appendChild(el);
            document.list.appendChild(el2);
            document.list.appendChild(el3);
            document.list.submit();
        }	
    </script>	

    <a title="<%=getlabel("new") %>" href="javascript: go('new_kosten');"><img src="/images/actions/documents/nieuw.gif" /></a>
    <span class="divider">|</span>
    <a title="<%=getlabel("cut") %>" href="javascript: go('cut_kosten');"><img src="/images/actions/documents/cut.png" /></a>
    <a title="<%=getlabel("copy") %>" href="javascript: go('copy_kosten');"><img src="/images/actions/documents/kopieren.gif" /></a>
    <%if len(session("dosarc_ids"))>0 then %>    
    <a title="<%=getlabel("paste") %>" href="javascript: go('paste_kosten');"><img src="/images/actions/documents/plakken.gif" /></a>
    <%end if %>
    <span class="divider">|</span>
    <a title="<%=getlabel("delete") %>" href="javascript: go('delete_kosten');"><img src="/images/actions/documents/verwijderen.gif" /></a>
</div>
<%    
    r_list sql, fields, orderby

%>
<!-- #include file="../../templates/footers/content.asp" -->
