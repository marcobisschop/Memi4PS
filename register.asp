<!-- #include file="settings/global.asp" -->
<!-- #include file="include/database.asp" -->
<!doctype html public "-//w3c//dtd html 4.0 transitional//en">
<html>
	<head>
	<LINK rel="stylesheet" type="text/css" href="<%=WebHost & WebPath%>styles/global.css">
	<LINK rel="stylesheet" type="text/css" href="<%=WebHost & WebPath%>styles/content.css">
	</head>
<!-- #include file="include/language.asp" -->
<!-- #include file="include/form.asp" -->
<!-- #include file="include/render.asp" -->
	<body>
        <%
            f_header("hdr_register")
        %>
        <br /><br />
        <%
            f_header("register_content")
        %>			
	</body>	
</html>
