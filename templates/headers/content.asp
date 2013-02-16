<%@ LANGUAGE=VBSCRIPT LCID=1043 %>


<!-- #include file="../../settings/global.asp" -->
<!-- #include file="../../include/database.asp" -->
<!doctype html public "-//w3c//dtd html 4.0 transitional//en">
<html>
	<head>
	<title><%=Application_Title %></title>
	<meta http-equiv="content-type" content="text/html;charset=utf-8" />
	<LINK rel="stylesheet" type="text/css" href="<%=WebHost & WebPath%>styles/global.css">
	<LINK rel="stylesheet" type="text/css" href="<%=WebHost & WebPath%>styles/content.css">
	<LINK rel="stylesheet" type="text/css" href="<%=WebHost & WebPath%>styles/stabu.css">
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
     <script type="text/javascript" src="<%=WebHost & WebPath%>jscript/jquery-1.4.2.min.js"></script>
     <script type="text/javascript" src="<%=WebHost & WebPath%>jscript/menu.js"></script>
   

        <link href="<%=WebHost & WebPath%>jscript/shadowbox-3.0.3/shadowbox.css" rel="stylesheet" type="text/css" />

        <script src="<%=WebHost & WebPath%>jscript/shadowbox-3.0.3/shadowbox.js" type="text/javascript"></script>



    <script type="text/javascript">

        Shadowbox.init();

    
    function cancel() {
        document.edit.viewstate.value = 'cancel';
        document.edit.submit();
     }
	function change() {
		document.edit.viewstate.value = 'change';
		document.edit.submit();
	}
	</script>

   	</head>
	<body >
	<!-- #include file="../../include/language.asp" -->
    <!-- #include file="../../include/form.asp" -->
    <!-- #include file="../../include/form2009.asp" -->
    <!-- #include file="../../include/template.asp" -->    
    <!-- #include file="../../include/security.asp" -->
    <!-- #include file="../../include/render.asp" -->
    <!-- #include file="../../include/notes.asp" -->
    <!-- #include file="../../include/distinctives.asp" -->
    <!-- #include file="../../include/variables.asp" -->
    <!-- #include file="../../include/functions.asp" -->
    <!-- #include file="../../include/documents.asp" -->
    <!-- #include file="../../menus/dynamic.asp" -->
	<a href="/contents/main.asp" accesskey="S"></a>
	
	
	<div style="width: 95%; padding: 0px 10px 10px 10px">
    
    <div style="width: 100%; font-size: 24px; color: #003a77; padding-top: 10px; padding-bottom: 14px; text-align: left">
	
	
	<%
	select case Session("APPLICATION")
	case "maaz"
	    %> <img src="/images/logo_vandermaazen.jpg" style="width: 80px"/> - MEMI Pro &copy; <% rw Year(Now) %>
	    
	    <%
	case "spra"
	    %> <img src="/images/sprangers.png" style="width: 80px"/> - MEMI Pro &copy; 2009 - <% rw Year(Now) %>
	    
	    <%
	case "dewi","dewit"
	    %> DE WIT Projectmanagement  - MEMI Pro &copy; <% rw Year(Now) %>
	    
	    <%
	case "asrv"
	    %> ASR Vastgoed  - MEMI Pro &copy; <% rw Year(Now) %>
	    
	    <%
	case "zali"
	    %> Woningstichting de Zaligheden  - MEMI Pro &copy; 2009 - <% rw Year(Now) %>
	    
	    <%
	case "stad"
	    %> Stadlander  - MEMI Pro &copy; 2009 - <% rw Year(Now) %>
	    
	    <%
	case "wopa"
	    %> <img src="/images/woonpartners.jpg" style="width: 100px"/> - MEMI Pro &copy; 2009 - <% rw Year(Now) %>
	    
	    <%
	case "gold"
	    %> <img src="/images/goldewijk.jpg" style="width: 100px"/> - MEMI Pro &copy; 2009 - <% rw Year(Now) %>
	    
	    <%
	case "moon","moonen"
	    %> Bouwgroep Moonen - MEMI Pro &copy; 2009 - <% rw Year(Now)
	case "gisb","gisbergen"
	    %> Gisbergen - MEMI Pro &copy; 2009 - <% rw Year(Now)
	case "adri", "adriaans"
	    %> Adriaans Aannemersbedrijf BV - MEMI Pro &copy; 2009 - <% rw Year(Now)
	case "vanbree"
	    %> van Bree - MEMI Pro &copy; 2009 - <% rw Year(Now)
	case "vanbree"
	    %> Woon Limburg - MEMI Pro &copy; 2009 - <% rw Year(Now)
	case "bate", "baten"
	    %>Baten.projectinfo  <%
	case else
	    %> MEMI Pro &copy; 2009  - <% rw Year(Now)
	end select
	%>

	</div>
	
	<div id="mainContainer" style='background-color: #f0f0e0'>
        <div id="main_menu">
            <% menu -1 %>
        </div>
        <%
	select case lcase(APPL_DIR)
	case "deelnemer"
	    if viewstate_value("mode") = "kpb" then
            session("bounum_id") = viewstate_value("id")
            session("projec_id") = dblookup("bounum","id",session("bounum_id"),"projec_id")        
        end if
	    rw "<table style='width: 450px'>"
	    rw "<tr><td style='width: 90px'>Project:</td><td>" & dblookup("projec","id",session("projec_id"),"pronaa") & "</td></tr>" 
	    rw "<tr><td>Kopers:</td><td>" & dblookup("vw_prodee","voorkeur",session("bounum_id"),"kopers_naw") & "</td></tr>" 
	    rw "<tr><td>Bouwnummer:</td><td>" & dblookup("vw_bounum","bounum_id",session("bounum_id"),"extnum") & "</td></tr>" 
	    rw "<tr><td>Bouwtype:</td><td>" & dblookup("vw_bounum","bounum_id",session("bounum_id"),"typnaa") & "</td></tr>" 
	    rw "</table>"
	end select
	%>
    </div>
    
