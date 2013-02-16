<%@ Language=VBScript LCID=1043%>
<%
	Response.Buffer = true
	NeedLogin = True
	NeedAdminRights = False
%>
<!-- #include file="../include/upload.asp" -->
<!-- #include file="../include/connection.asp" -->
<!-- #include file="../include/validation.asp" -->
<!-- #include file="../include/security.asp" -->
<!-- #include file="../include/shared.asp" -->
<!-- #include file="../include/notes.asp" -->
<%
	Const MaxFileSize = 10000000
	
	Dim Uploader, File
	Set Uploader = New FileUploader
	Uploader.Upload()
	
	Dim TableName, RecordID, ListURL, FormState, RS, Sql
	
	FormState = Uploader.Form("formstate")
	If Len(FormState) = 0 Then FormState = Request ("formstate")
	TableName = "notes_attachments"
	RecordID = Uploader.Form("id")
	If Len(RecordID) = 0 Then RecordID = Request("ID")
	notes_ID = Uploader.Form("notes_id")
	If Len(notes_ID) = 0 Then notes_ID = Request("notes_ID")
	ListURL   = "edit.asp?formstate=edit&id=" & notes_id 
	ActionURL = "edit_notes_attachments.asp"
	MultipartForm = True
		
	Select Case LCase(FormState)
	Case "edit"
		'Item bewerken, Het record met ID ophalen uit de tabel
		Sql = "select * from [" & TableName & "] where id = " & RecordID
		set rs = getrecordset(Idata,sql,false)
	Case Else
		'Item is nieuw, een lege regel uit de tabel halen en .Addnew toevoegen
		Sql = "select * from [" & TableName & "] where id = -1"
		set rs = getrecordset(Idata,sql,false)
		rs.addnew
		setSecurityInfo(rs)
	End Select
	
	' Controleren of het formulier gepost is
	If mPartIsPostBack() Then
		'Validatie op de invoervelden uitvoeren
		'Wanneer je wil dat de foutieve velden ook gekleurd zijn als
		'er een nieuw item wordt bewerkt kun je de validatie buiten
		'deze if functie plaatsen

		if not isvalid ("\w", false, FieldValue(formstate,rs,"description")) then AddFormError "description"
		
		' controleren of er een document up te loaden valt
		' if uploader.files.count <=0 then AddFormError "link"				
						
	End If
	
	' Wanneer het formulier gepost is en er zijn geen fouten gevonden
	' dan kunnen we de recordset opslaan. Na het opslaan zetten we de
	' formstate op edit en vullen het id van de nieuwe regel in RecordID
	If mPartIsPostBack() And ErrorCount = 0 Then
		With RS
			
			.fields("description") = FieldValue(formstate,rs,"description")			
			.fields("link") = FieldValue(formstate,rs,"description")			
			.fields("notes_id") = FieldValue(formstate,rs,"notes_id")			
			'opslaan van het bestand
			'zorg ervoor dat er maar 1 document opgeslagen mag worden
			if uploader.files.count = 1 then
				for each file in uploader.files.items
					if file.filesize <= MaxFileSize then
						
						.fields("filename") = file.filename
						.fields("filesize") = file.filesize
						.fields("filecontenttype") = file.contenttype
						
						file.savetodatabase .fields("filedata")
					else
						'bestand is te groot
						TopMessage getLabel("1019",currentLanguage) & MaxFileSize & " bytes!"		
					end if
				next
			end if
			
		End With
		' Invullen van de management informatie
		' Wie heeft het record aangemaakt of gewijzigd
		SetSecurityInfo rs ' gedefinieerd in ../include/security.asp
		PutRecordSet Idata, rs ' gedefinieerd in ../include/connection.asp
		FormState = "edit"
		RecordID = rs.fields("id")
		
		'Moeten we direct terug naar de List Pagina
		If ReturnToListURL Then Response.Redirect ListURL
	End If
%>
<html>
<head>
<meta NAME="GENERATOR" Content="Microsoft Visual Studio 6.0">
<link rel="stylesheet" type="text/css" href="../include/ibase.css">
</head>
<body>
<%
	renUserDetails 
	renderHeader "Attachments"
%>
<form id="edit" name="edit" action="<%=ActionURL%>" method="post" enctype="multipart/form-data">
<input type="hidden" id="postback" name="postback" value="true">
<input type="hidden" id="formstate" name="formstate" value="<%=FormState%>">
<input type="hidden" id="id" name="id" value="<%=RecordID%>">
<input type="hidden" id="notes_id" name="notes_id" value="<%=notes_ID%>">
<table style="width:100%"  cellpadding=0 cellspacing=0>	
	<tr> 
		<td valign=top>
			<table style="width:100%">	
			<%
				renderTextArea rs,"0937", "description", 300, 120
				renderFilebox  rs,"0938","filename",300
				renderLabel  rs,"0939","filename"
			%>
			</table>
		</td>
		<td valign=top>
			<%renSecurityInfo (rs)	%>
		</td>
	</tr>
	<%
		RenderFooter ListURL, TableName, RecordID, FormState, ListURL, ListURL
	%>
</table>
</form>
</body>
</html>
