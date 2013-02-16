<!-- #include file="../../templates/headers/content.asp" -->
<!-- #include file="../projects/functions.asp" -->
<!-- #include file="../boutyp/functions.asp" -->
<!-- #include file="../bounum/functions.asp" -->
<%
	

	dim rs, sql, myLetter, myLetters, provin_id
    	
	dim page_size, page	
	page = viewstate_value ("page")
	page_size = viewstate_value ("page_size")
	keusoo_soonaa = viewstate_value ("keusoo_soonaa")
	koppel_id = viewstate_value("koppel_id")
	toon_nul = viewstate_value("toon_nul")


	if page="" then page = 1
	if page_size="" then page_size = 50
	if keusoo_soonaa="" then keusoo_soonaa = "S"
	if koppel_id="" then koppel_id = 0


select case ucase(keusoo_soonaa)
case "P"
    projects_header koppel_id
case "W"
    boutyp_header koppel_id, dblookup("boutyp","id",koppel_id,"projec_id")
    projec_id = dblookup("boutyp","id",koppel_id,"projec_id")
case "B"
    bounum_header koppel_id
case "S"
    f_header getlabel("memi_stamlijst")	
end select

	sql = "select count(*) as cnt from keuzen "
	sql = sql & " where keusoo_soonaa='" & keusoo_soonaa & "' and koppel_id=" & koppel_id

select case ucase(keusoo_soonaa)
case "B"
    if toon_nul = "0" then
        sql = sql & " and aantal > 0"
        toon_nullen = 1
    else
        sql = sql & " and aantal >= 0"
        toon_nullen = 0
    end if
end select	
	
	set rs = getrecordset(sql ,true)
	row_count = rs.fields("cnt")
	set rs = nothing
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
        el2.value   = "<%=keusoo_soonaa %>";
	    el3.type    = "hidden";
        el3.name    = "koppel_id";
        el3.value   = "<%=koppel_id %>";
	    document.list.action = link;
        document.list.appendChild(el);
        document.list.appendChild(el2);
        document.list.appendChild(el3);
        document.list.submit();
	}	
	//  End -->
	</script>	

    <a title="<%=getlabel("new") %>" href="javascript: go('new');"><img src="/images/actions/keuzen/nieuw.gif" /></a>
    <span class="divider">|</span>
    <a title="<%=getlabel("copy") %>" href="javascript: go('copy');"><img src="/images/actions/keuzen/kopieren.gif" /></a>
    
<%if len(session("keuzen_ids"))>0 then %>    
    <a title="<%=getlabel("paste") %>" href="javascript: go('paste');"><img src="/images/actions/keuzen/plakken.gif" /></a>    
<%end if %>
<%if ucase(keusoo_soonaa)="B" then%>    
    <span class="divider">|</span>
    <a title="<%=getlabel("controleren") %>" href="javascript: go('check');"><img src="/images/actions/keuzen/control.gif" /></a>
    <a title="<%=getlabel("informeer relaties") %>" href="javascript: go('inform_relations');"><img src="/images/actions/keuzen/inform_relations.gif" /></a>
    <a title="<%=getlabel("vrijgeven") %>" href="javascript: go('release');"><img src="/images/actions/keuzen/vrijgeven.gif" /></a>
    <span class="divider">|</span>
    <a title="<%=getlabel("factureren aan") %>" href="javascript: go('invoice_on');"><img src="/images/actions/keuzen/basket_add.png" /></a>
    <a title="<%=getlabel("factureren uit") %>" href="javascript: go('invoice_off');"><img src="/images/actions/keuzen/basket_delete.png" /></a>
    <a title="<%=getlabel("facturatie overzicht") %>" href="../facturatie/bounum.asp?bounum_id=<%=koppel_id%>"><img src="/images/actions/keuzen/basket.png" /></a>
    <span class="divider">|</span>
<%end if %>    
    <span class="divider">|</span>
    <a title="<%=getlabel("delete") %>" href="javascript: go('delete');"><img src="/images/actions/keuzen/verwijderen.gif" /></a>
    <span class="menu_divider">|</span>
    
<%
	for i = 1 to (row_count / page_size) + 1
	%>
	<a href="?page=<%=i%>&page_size=<%=page_size%>&keusoo_soonaa=<%=keusoo_soonaa%>&koppel_id=<%=koppel_id%>"><%=i%></a>&nbsp;
	<%
	next
	
	'rw "page =" & page & "<br>"
	'rw "page_size =" & page_size & "<br>"
	'rw "row_count =" & row_count & "<br>"
	
	if (page * page_size) > row_count then 
		page_size2 =  page_size - ((page * page_size) - row_count )
		page_end = row_count
	else
		page_size2 = page_size
		page_end = page*page_size
	end if

	%>(<%=page*page_size-page_size%>-<%=page_end%> van <%=row_count%>)
	
	<div id="divWait" style="visibility:hidden ;padding-top: 10px; position: absolute; top: 400; left: 400; width: 250; height: 50; border: solid 2px #ff0000; vertical-align: middle; text-align:center; background-color: #ffffff; color: #ff0000; font-size: 14pt">... Even geduld ...</div>
	
	<select style="padding-top: 12px" id="page_size" onchange="document.location = '?page=1&page_size=' + this.value + '&keusoo_soonaa=<%=keusoo_soonaa%>&koppel_id=<%=koppel_id%>'; document.getElementById('divWait').style.visibility='visible';">
	    <option value=20 <%if page_size=20 then response.write "selected" %>>20</option>
	    <option value=50 <%if page_size=50 then response.write "selected" %>>50</option>
	    <option value=100 <%if page_size=100 then response.write "selected" %>>100</option>
	    <option value=250 <%if page_size=250 then response.write "selected" %>>250</option>
	    <option value=500 <%if page_size=500 then response.write "selected" %>>500</option>
	</select>
	
	<%
	select case ucase(keusoo_soonaa)
    case "B"
    %>
        <span style="color: red">
        Laatste controle datum: <%=dblookup("bounum","id",koppel_id,"lacoda") %></span>
        <%
    end select
    %>
    <span style="color: red">
        <a target="_blank" href="p_keuzen.asp?viewstate=view&id=<%=koppel_id %>&keusoo_soonaa=<%=keusoo_soonaa %>&koppel_id=<%=koppel_id %>">Printversie</a>
        <a href="l_keuzen.asp?viewstate=view&id=<%=koppel_id %>&keusoo_soonaa=<%=keusoo_soonaa %>&koppel_id=<%=koppel_id %>&toon_nul=<%=toon_nullen %>"><%if toon_nullen="0" then rw getlabel("verberg_nullen") else rw getlabel("toon_nullen") %></a>
	</span>
	
</div>
<%
	sql = ""
	sql = sql & " select * from ("
	sql = sql & " select top " & page_size2 & " * from ("
	sql = sql & "    select top " & page * page_size & " id, "
	sql = sql & " (select count(*) from docum where inreto='keuzen'and inreto_id=keuzen.id) as docum, "
	'sql = sql & " (select count(*) from fnKeuzenImages (keuzen.id)) as no_pictures,"
	sql = sql & " keusoo_soonaa as S, keucod, memi, natebe, voltek, replace(left(cast(keubes as varchar(250)), 250),'<','') as keubes, prikop, aanmin, aanmax, aantal, defini, control, afrond, factur, 'status' as status"
	sql = sql & "    ,[dbo].[fn_keuzen_kosten](keuzen.id) as kosten   "
	sql = sql & "    from keuzen where keusoo_soonaa='" & keusoo_soonaa & "'"
	
	
	
select case ucase(keusoo_soonaa)
case "B"
    if toon_nul = "0" then
        sql = sql & " and aantal > 0"
        toon_nullen = 1
    else
        sql = sql & " and aantal >= 0"
        toon_nullen = 0
    end if
end select	
	
	
	sql = sql & " and koppel_id = " & koppel_id
	sql = sql & "   order by keucod asc"
	sql = sql & " ) as k1 order by keucod desc"
	sql = sql & " ) as k2 order by keucod asc"
	
	'rw "<br>" &  toon_nul
	'rw "<br>" &  sql

	dim fieldlist, orderby
	fields = ""
	fields = fields & "$name:=id;type:=checkbox;boundcolumn:=id;wrapping:=nowrap;$"
	fields = fields & "$name:=keucod;type:=link;url:=e_keuzen.asp?viewstate=edit&id=~id~&page=" & page & "&keusoo_soonaa=" & keusoo_soonaa & ";valign:=top;$"
	fields = fields & "$name:=kosten;type:=link;url:=e_keuzen_kosten.asp?viewstate=edit&id=~id~&inreto=keuzen&inreto_id=~id~&page=" & page & "&keusoo_soonaa=" & keusoo_soonaa & ";valign:=top;$"
	fields = fields & "$name:=prikop;type:=text;format:=euro;align:=right;wrapping:=nowrap;$"
	fields = fields & "$name:=defini;type:=hidden;$"
	fields = fields & "$name:=control;type:=hidden;$"
	fields = fields & "$name:=afrond;type:=hidden;$"
	fields = fields & "$name:=factur;type:=hidden;$"
	if ucase(keusoo_soonaa) ="B" then
	    fields = fields & "$name:=aanmin;type:=hidden;$"
	    fields = fields & "$name:=aanmax;type:=hidden;$"
	    fields = fields & "$name:=aanmax;type:=text;align:=right;$"
	else
	    fields = fields & "$name:=aanmin;type:=text;align:=right;$"
	    fields = fields & "$name:=aanmax;type:=text;align:=right;$"	
	    fields = fields & "$name:=aantal;type:=hidden;$"
	end if
	fields = fields & "$name:=memi;type:=memi;align:=center;label:=.;boundcolumn:=~memi~;$"
	fields = fields & "$name:=natebe;type:=natebe;align:=center;label:=.;boundcolumn:=~natebe~;$"
	fields = fields & "$name:=voltek;type:=voltek;align:=center;label:=.;boundcolumn:=~voltek~;$"
	fields = fields & "$name:=docum;type:=has_docum;align:=center;label:=.;$"
	
	'fields = fields & "$name:=actions;type:=actions:keuzen;columns:=~id~,~defini~,~control~;wrapping:=nowrap;align:=right;$"
	
	if ucase(keusoo_soonaa) ="B" then
	    fields = fields & "$name:=status;type:=status:keuzen;boundcolumn:=~id~;$"
	else
	    fields = fields & "$name:=status;type:=hidden;$"
	end if
	orderby = "noorder"
	
	r_list sql, fields, orderby

    if len(session("keuzen_ids")) then
        if keusoo_soonaa = session("keusoo_soonaa") or keusoo_soonaa = "P" and session("keusoo_soonaa") = "S" or keusoo_soonaa = "W" and session("keusoo_soonaa") = "P" or keusoo_soonaa = "B" and session("keusoo_soonaa") = "W" Then
                
            f_header getlabel("keuzen_buffer") 
            %><br /><br /><%
            sql = "select keucod,id from keuzen where id in (" & session("keuzen_ids") & ")"
            set rs = getrecordset(sql, true)
            with rs
                do until .eof
                    %><a target="_blank" href="e_keuzen.asp?viewstate=edit&id=<%=.fields("id") %>"><%=.fields("keucod")%></a><%
                    if not .eof then
                        %>, <%
                        .movenext
                    end if
                loop
            end with
            set rs = nothing
        %>
        <br /><br />
        <a title="<%=getlabel("empty_buffer") %>" href="../memi/action.asp?action=empty_buffer"><img src="/images/actions/keuzen/verwijderen.gif" /></a>
        <%
        end if        
    end if

%>
<table>
<tr><td style="width: 24px; text-align: center"><img style="width: 16px" src="/images/afbeeldingen.png" /></td><td><%=getlabel("heeft documentatie") %></td></tr>
<tr><td style="width: 24px; text-align: center"><img style="width: 16px" src="/images/no_afbeeldingen.png" /></td><td><%=getlabel("heeft geen documentatie") %></td></tr>
<tr><td style="width: 24px; text-align: center"><img style="width: 8px" src="/images/actions/keuzen/meerwerk.jpg" /></td><td><%=getlabel("meerwerk") %></td></tr>
<tr><td style="width: 24px; text-align: center"><img style="width: 8px" src="/images/actions/keuzen/minderwerk.jpg" /></td><td><%=getlabel("minderwerk") %></td></tr>
<tr><td style="width: 24px; text-align: center"><img style="width: 16px" src="/images/actions/keuzen/natebe.gif" /></td><td><%=getlabel("natebe") %></td></tr>
<tr><td style="width: 24px; text-align: center"><img style="width: 16px" src="/images/actions/keuzen/voltek.gif" /></td><td><%=getlabel("voltek") %></td></tr>
</table>
<!-- #include file="../../templates/footers/content.asp" -->
