<!-- #include file="../templates/headers/content.asp" -->
<%
	Dim previouspage, previousid, NoteId, TableName
	
	NoteID			= viewstate_value("id")
	previouspage	= viewstate_value("previouspage")
	previousid		= viewstate_value("previousid")
	
	sql = "DELETE FROM Notes WHERE id=" & NoteID
	ExecuteSQL sql
	Response.Redirect refurl ' previouspage & "?viewstate=edit&id=" & previousid
%>
<!-- #include file="../templates/footers/content.asp" -->
