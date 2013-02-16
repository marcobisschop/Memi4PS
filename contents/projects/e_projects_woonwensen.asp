<!-- #include file="../../templates/headers/content.asp" -->
<!-- #include file="functions.asp" -->
<%
	
	dim rs, sql, myLetter, myLetters, provin_id
    	
	dim page_size, page	
	page = viewstate_value ("page")
	page_size = viewstate_value ("page_size")
	keusoo_soonaa = viewstate_value ("keusoo_soonaa")
	koppel_id = viewstate_value("koppel_id")
	project_id = viewstate_value("id")

	if page="" then page = 1
	if page_size="" then page_size = 20
	if keusoo_soonaa="" then keusoo_soonaa = "S"
	if koppel_id="" then koppel_id = 0

	sql = "select count(*) as cnt from keuzen where keusoo_soonaa='" & keusoo_soonaa & "'"
	set rs = getrecordset(sql ,true)
	row_count = rs.fields("cnt")
	set rs = nothing
	
	projects_header (koppel_id)	
%>
<div style="padding-top: 2px; vertical-align: top" class="rolodex">

<script language="javascript" type="text/javascript">
	<!-- Begin
	function go(a)
	{
        var el      = document.createElement("input");
        var el2     = document.createElement("input");
        var el3     = document.createElement("input");
        var link    = "../memi/action.asp";                
        el.type     = "hidden";
        el.name     = "action";
        el.value    = a;
	    el2.type    = "hidden";
        el2.name    = "keusoo_soonaa";
        el2.value   = "P";
	    el3.type    = "hidden";
        el3.name    = "koppel_id";
        el3.value   = "<%=project_id %>";
	    document.list.action = link;
        document.list.appendChild(el);
        document.list.appendChild(el2);
        document.list.appendChild(el3);
        document.list.submit();
	}	
	//  End -->
	</script>	

    <a title="<%=getlabel("paste") %>" href="javascript: go('copy');"><img src="/images/actions/keuzen/kopieren.gif" /></a>
    <a title="<%=getlabel("paste") %>" href="javascript: go('paste');"><img src="/images/actions/keuzen/plakken.gif" /></a>
    <a title="<%=getlabel("controleren") %>" href="javascript: go('check');"><img src="/images/actions/keuzen/control.gif" /></a>
    <a title="<%=getlabel("vrijgeven") %>" href="javascript: go('release');"><img src="/images/actions/keuzen/vrijgeven.gif" /></a>

    <span class="menu_divider">|</span>
    
    
<%
    
	for i = 1 to (row_count / page_size) + 1
	%>
	<a href="?page=<%=i%>&page_size=<%=page_size%>&keusoo_soonaa=<%=keusoo_soonaa%>&koppel_id=<%=koppel_id%>"><%=i%></a>&nbsp;
	<%
	next
	
	if (page * page_size) > row_count then 
		page_size2 =  page_size - ((page * page_size) - row_count )
		page_end = row_count
	else
		page_size2 = page_size
		page_end = page*page_size
	end if

	%>(<%=page*page_size-page_size%>-<%=page_end%> van <%=row_count%>)
</div>
<%
	sql = ""
	sql = sql & " select *, 'actions' as actions from ("
	sql = sql & " select top " & page_size2 & " * from ("
	sql = sql & "    select top " & page * page_size & " id, keucod, memi, natebe, voltek, replace(left(cast(keubes as varchar(50)), 50),'<','') as keubes, prikop, aanmin, aanmax, defini, control"
	sql = sql & "    from keuzen where keusoo_soonaa='" & keusoo_soonaa & "'"
	sql = sql & " and koppel_id = " & koppel_id
	sql = sql & "   order by keucod asc"
	sql = sql & " ) as k1 order by keucod desc"
	sql = sql & " ) as k2 order by keucod asc"
	
	

	dim fieldlist, orderby
	fields = ""
	fields = fields & "$name:=id;type:=checkbox;boundcolumn:=id;wrapping:=nowrap;$"
	fields = fields & "$name:=keucod;type:=link;url:=e_keuzen.asp?viewstate=edit&id=~id~&page=" & page & "&keusoo_soonaa=" & keusoo_soonaa & ";valign:=top;$"
	fields = fields & "$name:=prikop;type:=text;format:=euro;align:=right;wrapping:=nowrap;$"
	fields = fields & "$name:=defini;type:=hidden;$"
	fields = fields & "$name:=control;type:=hidden;$"
	fields = fields & "$name:=aanmin;type:=text;align:=right;$"
	fields = fields & "$name:=aanmax;type:=text;align:=right;$"
	fields = fields & "$name:=memi;type:=memi;align:=center;label:=M;boundcolumn:=~memi~;$"
	fields = fields & "$name:=natebe;type:=natebe;align:=center;label:=O;boundcolumn:=~natebe~;$"
	fields = fields & "$name:=voltek;type:=voltek;align:=center;label:=T;boundcolumn:=~voltek~;$"
	fields = fields & "$name:=actions;type:=actions:keuzen;columns:=~id~,~defini~,~control~;wrapping:=nowrap;align:=right;$"
	orderby = "noorder"
	
	
	r_list sql, fields, orderby
%>
<!-- #include file="../../templates/footers/content.asp" -->
