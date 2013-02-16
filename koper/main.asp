<!-- #include file="../templates/headers/content.asp" -->

<% Response.Clear() %>

<!doctype html public "-//w3c//dtd html 4.0 transitional//en">
<html>
	<head>
	<LINK rel="stylesheet" type="text/css" href="<%=WebHost & WebPath%>styles/global.css">
	<LINK rel="stylesheet" type="text/css" href="<%=WebHost & WebPath%>styles/content.css">
	</head>
    <frameset resize=no cols="*,*" border=1>
        <frame id=left name=left src="myMethods.asp">
        <frameset resize=no rows="*,*" border=1>
            <frame id=rtop name=rtop src="myTasks.asp">
            <frame id=rbottom name=rbottom src="myNotes.asp">
        </frameset>
    </frameset>
    <noframes>
	    <body>
		    deze applicatie gebruikt frames!
	    </body>
    </noframes>
</html>
<!-- #include file="../templates/footers/content.asp" -->
