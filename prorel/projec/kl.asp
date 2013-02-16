<!-- #include file="../../templates/headers/content.asp" -->
<%
    dim bounum_id
    bounum_id = viewstate_value("bounum_id")
    
    dim sql
    sql = "select (select count(*) from docum where inreto='keuzen'and inreto_id=keuzen.id) as docum, keucod, memi, voltek, keubes, aantal, prikop, aantal*prikop as pritot, id from keuzen where keusoo_soonaa='b' and defini=1 and control=1 and koppel_id=" & bounum_id

    fields = "$name:=afrond;type:=bit;class:=keuzen;boundcolumn:=id;id:=~id~;field:=afrond;$"
    fields = fields & "$name:=keucod;type:=window;url:=../keuzen/e_keuzen.asp?viewstate=view&id=~id~;$"
    fields = fields & "$name:=memi;type:=memi;align:=center;label:=.;boundcolumn:=~memi~;$"
	fields = fields & "$name:=pritot;type:=text;align:=right;format:=d2;calculate:=sum;$"
	fields = fields & "$name:=voltek;type:=voltek;align:=center;label:=.;boundcolumn:=~voltek~;$"
	fields = fields & "$name:=docum;type:=has_docum;align:=center;label:=.;$"
	
    fields = fields & "$name:=id;type:=hidden;$"
    orderby = "keunaa"
    
    f_header dblookup("projec","id",session("projec_id"),"pronaa")
    f_header "Bouwnummer " & dblookup("vw_prodee","voorkeur",bounum_id,"extnum")
%>
<div style="padding: 15px 0px 15px 0px">
    U kunt onderstaande meterkastlijst printen met het menu "bestand -> afdrukken" of de toetscombinatie "CTRL+P". Klik op de code om 
    extra informatie betreffende de woonwens te bekijken.
    <br /><br />
    Tevens kunt u per regel aangeven of de woonwens is afgerond.
    <br /><br />
    Klik <a href='default.asp'>hier</a> om terug te gaan naar de bouwnummers.
    <br /><br />
    Controle datum: <%=dblookup("bounum", "id", bounum_id , "lacoda") %>
</div>
<%
    r_list sql, fields, orderby
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
