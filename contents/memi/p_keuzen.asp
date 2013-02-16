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

	if page="" then page = 1
	if page_size="" then page_size = 1000
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
    sql = sql & " and aantal > 0"
end select	
	
	set rs = getrecordset(sql ,true)
	row_count = rs.fields("cnt")
	set rs = nothing
%>
<div style="padding-top: 2px; vertical-align: top" class="rolodex">
    

	
</div>
<%
	sql = ""
	sql = sql & " select * from ("
	sql = sql & " select top " & page_size & " * from ("
	sql = sql & "    select top " & page * page_size & " id, (select count(*) from docum where inreto='keuzen'and inreto_id=keuzen.id) as docum, keusoo_soonaa as S, keucod, memi, natebe, voltek, replace(left(cast(keubes as varchar(2500)), 2500),'<','') as keubes, prikop, aanmin, aanmax, aantal, defini, control, afrond, 'status' as status"
	sql = sql & "    from keuzen where keusoo_soonaa='" & keusoo_soonaa & "'"
	
select case ucase(keusoo_soonaa)
case "B"
    sql = sql & " and aantal > 0"
end select	
	
	
	sql = sql & " and koppel_id = " & koppel_id
	sql = sql & "   order by keucod asc"
	sql = sql & " ) as k1 order by keucod desc"
	sql = sql & " ) as k2 order by keucod asc"
	
	'response.write sql

	dim fieldlist, orderby
	fields = ""
	fields = fields & "$name:=id;type:=hidden;boundcolumn:=id;wrapping:=nowrap;$"
	fields = fields & "$name:=keucod;type:=text;url:=e_keuzen.asp?viewstate=edit&id=~id~&page=" & page & "&keusoo_soonaa=" & keusoo_soonaa & ";valign:=top;$"
	fields = fields & "$name:=prikop;type:=text;format:=d2;align:=right;wrapping:=nowrap;$"
	fields = fields & "$name:=defini;type:=hidden;$"
	fields = fields & "$name:=control;type:=hidden;$"
	fields = fields & "$name:=afrond;type:=hidden;$"
	if ucase(keusoo_soonaa) ="B" then
	    fields = fields & "$name:=aanmin;type:=hidden;$"
	    fields = fields & "$name:=aanmax;type:=hidden;$"
	    fields = fields & "$name:=aanmax;type:=hidden;align:=right;$"
	else
	    fields = fields & "$name:=aanmin;type:=hidden;align:=right;$"
	    fields = fields & "$name:=aanmax;type:=hidden;align:=right;$"	
	    fields = fields & "$name:=aantal;type:=hidden;$"
	end if
	fields = fields & "$name:=memi;type:=memi;align:=center;label:=.;boundcolumn:=~memi~;$"
	fields = fields & "$name:=natebe;type:=natebe;align:=center;label:=.;boundcolumn:=~natebe~;$"
	fields = fields & "$name:=voltek;type:=voltek;align:=center;label:=.;boundcolumn:=~voltek~;$"
	fields = fields & "$name:=docum;type:=hidden;align:=center;label:=.;$"
	fields = fields & "$name:=S;type:=hidden;align:=center;label:=.;$"
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
<tr><td style="width: 24px; text-align: center"><img style="width: 8px" src="/images/actions/keuzen/meerwerk.jpg" /></td><td><%=getlabel("meerwerk") %></td></tr>
<tr><td style="width: 24px; text-align: center"><img style="width: 8px" src="/images/actions/keuzen/minderwerk.jpg" /></td><td><%=getlabel("minderwerk") %></td></tr>
<tr><td style="width: 24px; text-align: center"><img style="width: 16px" src="/images/actions/keuzen/natebe.gif" /></td><td><%=getlabel("natebe") %></td></tr>
<tr><td style="width: 24px; text-align: center"><img style="width: 16px" src="/images/actions/keuzen/voltek.gif" /></td><td><%=getlabel("voltek") %></td></tr>
</table>

<script language=javascript>
    document.getElementById("main_menu").style.display = "none";
    document.getElementById("menu_bar").innerHTML = "Keuzenlijst";
   
</script>

<!-- #include file="../../templates/footers/content.asp" -->

