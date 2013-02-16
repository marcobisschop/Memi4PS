<!-- #include file="../../templates/headers/content.asp" -->
<!-- #include file="functions.asp" -->
<%
	dim recordid
	
	viewstate = viewstate_value("viewstate")
	recordid  = viewstate_value("id")
		
	bounum_header recordid

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
        el2.value   = "<%=recordid %>";
        el3.type    = "hidden";
        el3.name    = "inreto";
        el3.value   = "bounum";
        document.list.action = link;
        document.list.appendChild(el);
        document.list.appendChild(el2);
        document.list.appendChild(el3);
        document.list.submit();
    }	
    //  End -->
    </script>	

    <a title="<%=getlabel("new") %>" href="javascript: go('new');"><img src="/images/actions/documents/nieuw.gif" /></a>
    <span class="divider">|</span>
    <a title="<%=getlabel("cut") %>" href="javascript: go('cut');"><img src="/images/actions/documents/cut.png" /></a>
    <a title="<%=getlabel("copy") %>" href="javascript: go('copy');"><img src="/images/actions/documents/kopieren.gif" /></a>
    <%if len(session("dosarc_ids"))>0 then %>    
    <a title="<%=getlabel("paste") %>" href="javascript: go('paste');"><img src="/images/actions/documents/plakken.gif" /></a>
    <%end if %>
    <span class="divider">|</span>
    <a title="<%=getlabel("delete") %>" href="javascript: go('delete');"><img src="/images/actions/documents/verwijderen.gif" /></a>
</div>
<%	
	
	sql = "select id,docnaa,docnum,available,stuurgroep, volgor from docum where docnaa like '" & myLetter & "%'"
	sql = sql & " and inreto='bounum' and inreto_id=" & recordid
	
	fields = ""
	fields = fields & "$name:=id;type:=checkbox;boundcolumn:=id;$"
	fields = fields & "$name:=docnum;type:=text;$"
	fields = fields & "$name:=status;type:=text;$"
	fields = fields & "$name:=docnaa;type:=link;width:=700;height:=500;url:=../documents/e_documents.asp?viewstate=view&id=~id~;$"
	fields = fields & "$name:=available;type:=bit;class:=docum;field:=available;id:=~id~;$"	
	fields = fields & "$name:=volgor;type:=order;class:=docum;field:=volgor;id:=~id~;$"
	
	orderby = "volgor"

    r_list sql, fields, orderby
	
%>
<!-- #include file="../../templates/footers/content.asp" -->
