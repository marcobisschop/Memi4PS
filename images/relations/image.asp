<!-- #include file="../../settings/global.asp" -->
<%
	dim relationName, fs, filespec, FPAth
	relationName = Request.Querystring("sn")
	set fs = server.CreateObject("scripting.filesystemobject")
	filespec = "/images/relations/" & relationName & ".jpg"
	checkspec = server.MapPath("/images/relations/") & "\" & relationName & ".jpg"
	if fs.FileExists(checkspec) then
		FPath = checkspec
	else
		FPath = server.MapPath("/images/relations/no_image.jpg")
	end if	
	Set adoStream = Server.CreateObject("ADODB.Stream")
	adoStream.Open()
	adoStream.Type = 1
	adoStream.LoadFromFile(FPath)
	Response.BinaryWrite adoStream.Read()
	adoStream.Close: Set adoStream = Nothing
	Response.End
%>