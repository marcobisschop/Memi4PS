<!-- #include file="../../settings/global.asp" -->
<!-- #include file="../../include/database.asp" -->
<!doctype html public "-//w3c//dtd html 4.0 transitional//en">
<html>
	<head>
	<LINK rel="stylesheet" type="text/css" href="<%=WebHost & WebPath%>styles/global.css">
	<LINK rel="stylesheet" type="text/css" href="<%=WebHost & WebPath%>styles/content.css">
	<%    'Check user's Language
    if EditorLang(currentLanguage) = "?lang=dutch" then
    %>	    <script language=JavaScript src='scripts/language/dutch/editor_lang.js'></script> 
    <%    end if

    'Check user's Browser
    'if InStr(request.ServerVariables("HTTP_USER_AGENT"),"MSIE") then
	 '   Response.Write "<script language=JavaScript src='scripts/editor.js'></script>"
    'else
	 '   Response.Write "<script language=JavaScript src='scripts/moz/editor.js'></script>"
    'end if
    %>
        <script language=JavaScript src='scripts/editor.js'></script>
	</head>
	<body>
	<div style="padding: 0px 0px 10px 0px">
<!-- #include file="../../include/language.asp" -->
<!-- #include file="../../include/form.asp" -->
<!-- #include file="../../include/security.asp" -->
<!-- #include file="../../include/render.asp" -->
<!-- #include file="../../include/notes.asp" -->