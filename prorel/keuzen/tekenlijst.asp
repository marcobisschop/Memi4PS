<%@ LANGUAGE=VBSCRIPT LCID=1043 %>
<!-- #include file="../../settings/global.asp" -->
<!-- #include file="../../include/database.asp" -->
<!doctype html public "-//w3c//dtd html 4.0 transitional//en">
<html>
	<head>
	<meta http-equiv="content-type" content="text/html;charset=utf-8" />
	<LINK rel="stylesheet" type="text/css" href="<%=WebHost & WebPath%>styles/global.css">
	<LINK rel="stylesheet" type="text/css" href="<%=WebHost & WebPath%>styles/content.css">
	<LINK rel="stylesheet" type="text/css" href="<%=WebHost & WebPath%>styles/menu_dynamic.css">
	<!-- Javascript voor de editor -->
    <%
        if InStr(Request.ServerVariables("HTTP_USER_AGENT"),"MSIE") then
	        Response.Write "<script language=JavaScript src='/richtextbox/scripts/editor.js'></script>"
        else
	        Response.Write "<script language=JavaScript src='/richtextbox/scripts/moz/editor.js'></script>"
        end if
     %>
     <script type="text/javascript" language="javascript" src='/richtextbox/scripts/language/dutch/editor_lang.js'></script>
     <script type="text/javascript" src="<%=WebHost & WebPath%>jscript/windowfunctions.js"></script>
     <script type="text/javascript" src="<%=WebHost & WebPath%>jscript/menu.js"></script>
   	</head>
	<body>
	<!-- #include file="../../include/language.asp" -->
    <!-- #include file="../../include/form.asp" -->
    <!-- #include file="../../include/security.asp" -->
    <!-- #include file="../../include/render.asp" -->
    <!-- #include file="../../include/notes.asp" -->
    <!-- #include file="../../include/distinctives.asp" -->
    <!-- #include file="../../include/variables.asp" -->
    <!-- #include file="../../include/functions.asp" -->
    <!-- #include file="../../include/documents.asp" -->
    <!-- #include file="../../menus/dynamic.asp" -->

<div style="padding: 2cm 1cm 0cm 0cm">
<%=dblookup("projec","id",session("projec_id"),"tekcor1") %><br />
<%=dblookup("projec","id",session("projec_id"),"tekcor2") %><br />
<%=dblookup("projec","id",session("projec_id"),"tekcor3") %><br />
<%=dblookup("projec","id",session("projec_id"),"tekcor4") %><br />
</div>
<div style="padding: 1cm 1cm 0cm 0cm">
<%=dblookup("vw_prodee","voorkeur",session("bounum_id"),"contacts_name") %><br />
<%=dblookup("vw_prodee","voorkeur",session("bounum_id"),"adresregel3") %><br />
<%=dblookup("vw_prodee","voorkeur",session("bounum_id"),"adresregel4") %><br />
</div>
<div style="padding: 1cm 1cm 0cm 0cm">
Betreft: Bevestigen woonwensen d.d. <%=FormatDateTime(Now(),2) %>
</div>
<div style="padding: 1cm 1cm 1cm 0cm">
Project/bouwnummer: <%=dblookup("vw_prodee","voorkeur",session("bounum_id"),"pronaa") %>, bouwnummer <%=dblookup("vw_prodee","voorkeur",session("bounum_id"),"extnum") %><br />
Contactpersoon: <%=dblookup("vw_prodee","voorkeur",session("bounum_id"),"contacts_name") %><br />
</div>
Geachte kopersbegeleider,
<p>
Bij deze doe ik u mijn getekende woonwensenlijst toekomen. Ik wil u vragen deze lijst zorgvuldig te controleren en 
indien nodig zo spoedig mogelijk contact met mij op te nemen op telefoonnummer <%=dblookup("vw_prodee","voorkeur",session("bounum_id"),"adrtel")%> of <%= dblookup("vw_prodee","voorkeur",session("bounum_id"),"telmob") %>.
</p><p>
In totaal bevestig ik <%=dblookup("vw_bounum_bevestigen","koppel_id",session("bounum_id"),"aantal") %> woonwensen met een totaalbedrag van <%=dblookup("vw_bounum_bevestigen","koppel_id",session("bounum_id"),"besteed_btw") %> euro inclusief btw.
</p>
Hoogachtend,
<p>
<br />
[Handtekening]<br />
<%=dblookup("vw_prodee","voorkeur",session("bounum_id"),"contacts_name") %><br />
</p>
<hr />
<p>
Overzicht woonwensen:
<%
    sql = "select keunaa, keubes, aantal, prikop, pritot from vw_keuzen where keusoo_soonaa='b' and koppel_id=" & session("bounum_id")
    sql = sql & " and defini=1 and aantal>0"
    fields = "$name:=prikop;type:=text;align:=right;format:=d2;$"
    fields = fields & "$name:=pritot;type:=text;align:=right;format:=d2;$"
    orderby = "keunaa"
    r_list sql, fields, orderby
%>
</p>
<!-- #include file="../../templates/footers/content.asp" -->