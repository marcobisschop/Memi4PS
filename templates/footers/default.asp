<!-- #include file="../../settings/global.asp" -->
<!-- #include file="../../include/database.asp" -->
<!-- #include file="../../include/language.asp" -->
<!-- #include file="../../include/form.asp" -->
<!-- #include file="../../include/render.asp" -->

<!doctype html public "-//w3c//dtd html 4.0 transitional//en">
<html>
	<head>
	<LINK rel="stylesheet" type="text/css" href="<%=WebHost & WebPath%>styles/global.css">
	<LINK rel="stylesheet" type="text/css" href="<%=WebHost & WebPath%>styles/footer.css">
	</head>
	<body>
<%
    response.Write session("login_key")
	response.Write session("login_id") 
	response.Write session("login_roles") 	
%>

</body>
</html>
