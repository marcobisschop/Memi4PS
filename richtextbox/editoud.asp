<%@ Language=VBScript %><% 
	'Buffering is nodig om later in het asp script te kunnen redirect
	'naar een andere pagina.
	'Vanaf IIS5 bestaat ook de mogelijkheid om een transfer te doen
	'naar een andere pagina. (Server.transfer "") Hiermee worden alle
	'QueryString en Form variabelen behouden en kunnen in de nieuwe
	'pagina gebruikt worden.
	Response.Buffer = True 
%>
<!-- #include file="../include/connection.asp" -->
<!-- #include file="../include/security.asp" -->
<!-- #include file="../include/validation.asp" -->
<!-- #include file="../include/shared.asp" -->
<!-- #include file="../include/nocache.asp" -->
<%
	Dim TableName, RecordID, ListURL, FormState, RS, Sql
	
	FormState = Request("formstate")
	TableName = "tblNotes"
	InrelatieTot = Request("inrelationto")
	InrelatieTot_ID = Request("inrelationto_id")
	RecordID  = Request("id")

	If IsPostBack() Then
		ListURL = Request.Form("ListURL")
	Else
		ListURL = request.servervariables("HTTP_REFERER")
	End If
	
	'Response.Write "listurl = " & listurl
	
	ActionURL = "edit.asp?tn=" & TableName
	
	Select Case LCase(FormState)
	Case "edit"
		'Item bewerken, Het record met ID ophalen uit de tabel
		Sql = "select * from [" & TableName & "] where id = " & RecordID
		set rs = getrecordset(Idata,sql,false)
		InrelatieTot = rs.fields("inrelationto")
		InrelatieTot_ID = rs.fields("inrelationto_id")
	Case Else
		'Item is nieuw, een lege regel uit de tabel halen en .Addnew toevoegen
		Sql = "select * from [" & TableName & "] where id=-1"
		set rs = getrecordset(Idata,sql,false)
		rs.Addnew
	End Select
	
	' Controleren of het formulier gepost is
	If IsPostBack() Then
		'Validatie op de invoervelden uitvoeren
		'Wanneer je wil dat de foutieve velden ook gekleurd zijn als
		'er een nieuw item wordt bewerkt kun je de validatie buiten
		'deze if functie plaatsen
		if not len(fieldvalue(formstate,rs,"body")) > 0 then addFormError "body"
			
	End If
	
	' Wanneer het formulier gepost is en er zijn geen fouten gevonden
	' dan kunnen we de recordset opslaan. Na het opslaan zetten we de
	' formstate op edit en vullen het id van de nieuwe regel in RecordID
	If IsPostBack() And ErrorCount = 0 Then
		With RS
			.fields("inrelationto") = fieldvalue(formstate,rs,"inrelationto")
			.fields("inrelationto_id") = clng(fieldvalue(formstate,rs,"inrelationto_id"))
			.fields("body") = fieldvalue(formstate,rs,"body")
		End With
		' Invullen van de management informatie
		' Wie heeft het record aangemaakt of gewijzigd
		SetSecurityInfo rs ' gedefinieerd in ../include/security.asp
		PutRecordSet Idata, rs ' gedefinieerd in ../include/connection.asp
		
		FormState = "edit"
		RecordID = rs.fields("id")
		
		
				
		'Wanneer er in de parent pagina al eens op save is gedrukt dan
		' zijn deze gegevens weg
		If Instr(1,ListURL,"id=")<=0 Then
			ListURL = ListURL & "&formstate=edit&id=" & fieldvalue(formstate,rs,"inrelationto_id")
		End If
		
		
		'Moeten we direct terug naar de List Pagina
		ReturnToListURL = True
		If fieldvalue(formstate,rs,"inrelationto") = "call_description" then returntolisturl = false
		If ReturnToListURL Then Response.Redirect ListURL
	End If
	
	'wanneer er niets is ingetikt gaan we gewoon terug naar de vorige pagina
	If IsPostBack() And ErrorCount <> 0 Then
		'Wanneer er in de parent pagina al eens op save is gedrukt dan
		' zijn deze gegevens weg
		If Instr(1,ListURL,"id=")<=0 Then
			ListURL = ListURL & "&formstate=edit&id=" & fieldvalue(formstate,rs,"inrelationto_id")
		End If
		
		
		'Moeten we direct terug naar de List Pagina
		ReturnToListURL = True
		If ReturnToListURL Then Response.Redirect ListURL
	End If	
%>
<html>
<head>
<LINK rel="stylesheet" type="text/css" href="../include/ibase.css">
<!-- Javascript voor de editor -->
<script language="Javascript1.2" src="editor.js"></script>
<!-- Einde javascript voor de editor -->
<script>

// set this to the URL of editor direcory (with trailing forward slash)
// NOTE: _editor_url MUST be on the same domain as this page or the popups
// won't work (due to IE cross frame/cross window security restrictions).
// example: http://www.hostname.com/editor/

_editor_url = "";
</script>

<script language="javascript1.2">

	function init() // genereer textarea
	{
		editor_generate('body');
		//tekst.focus();
	}
	
	function selOn(ctrl) // kleur veranderen bij muisover
	{
		ctrl.style.borderColor = '#000000';
		ctrl.style.backgroundColor = '#B5BED6';
		ctrl.style.cursor = 'hand';	
	}
  
	function selOff(ctrl) // kleur terug zetten bij muisaf
	{
		ctrl.style.borderColor = '#d3d3d3';  
		ctrl.style.backgroundColor = '#d3d3d3';
	}
</script>

<style type="text/css">
<!--
  .btn   { BORDER-WIDTH: 1; width: 26px; height: 24px; BACKGROUND-COLOR: '#d3d3d3'; CURSOR: 'hand';}
  .btnDN { BORDER-WIDTH: 1; width: 26px; height: 24px; BORDER-STYLE: inset; BACKGROUND-COLOR: '#d3d3d3'; CURSOR: 'hand';}
  .btnNA { BORDER-WIDTH: 1; width: 26px; height: 24px; filter: alpha(opacity=25);}
-->
</style>


<style type="text/css">
<!--
  body, td { font-family: arial; font-size: 12px; }
  .headline { font-family: arial black, arial; font-size: 28px; letter-spacing: -2px; }
  .subhead  { font-family: arial, verdana; font-size: 12px; let!ter-spacing: -1px; }
-->
</style>

<title></title>
<body onLoad="init()">
<%
	Label = Request("Label")
	If Len(Label)=0 Then Label = getlabel("0913",currentLanguage)
	renUserDetails 
	renderHeader Label

	if lcase(fieldvalue(formstate,rs,"inrelationto")) = "call_description" then
		callid = fieldvalue(formstate,rs,"inrelationto_id")
%>
		<a href="../beheer/editcall.asp?formstate=edit&id=<%=callid%>"><%=getLabel("1039",currentLanguage)%></a>
<%
	end if
%>
<form name="frmNews" action="<%=ActionURL%>&label=<%=label%>" method="post" onSubmit="">
	<!--<input type="hidden" id="tekst" name="tekst" value="<%=replace(fieldvalue(formstate, rs, "tekst"),"""","'")%>">-->
	<input type="hidden" id="postback" name="postback" value="true">
	<input type="hidden" id="formstate" name="formstate" value="<%=FormState%>">
	<input type="hidden" style="width:100%" id="ListURL" name="ListURL" value="<%=ListURL%>">
	<input type="hidden" id="id" name="id" value="<%=RecordID%>">
	<input type="hidden" id="inrelationto" name="inrelationto" value="<%=fieldvalue(formstate,rs,"inrelationto")%>">
	<input type="hidden" id="inrelationto_id" name="inrelationto_id" value="<%=fieldvalue(formstate,rs,"inrelationto_id")%>">

	<table style="width:100%">
		<%
			renderTextArea rs,"0933", "body", "500", 200
		%>
	</table>
	
	<br>
	<TABLE WIDTH=100% bgcolor=Silver BORDER=0 CELLSPACING=1 CELLPADDING=1>
	<TR>
		<TD  align=right><input type="image" src="../images/ok.gif" border="0" WIDTH="16" HEIGHT="16" id=image1 name=image1></TD>
	</TR>
	</TABLE>

    </form>

<%
	if lcase(fieldvalue(formstate,rs,"inrelationto")) = "call_description" then
		if formstate="edit" then
			renderHeader getlabel("1083",currentlanguage)
			SQL = "select filename,description,filesize,filecontenttype,id from notes_attachments where notes_id=" & recordid
			set rs = getRecordSet (Idata, SQL, false)
			renderRS rs, "filename", "id", "edit_notes_attachments.asp?notes_id=" & recordid & "&formstate=edit&id=", "filename;description;filesize;filecontenttype"
			set rs = nothing
			%>
			<a href="edit_notes_attachments.asp?notes_id=<%=recordid%>&formstate=new&id=-1"><img SRC="../images/page.gif" border="0" WIDTH="16" HEIGHT="16">
			<%=getLabel("0804",currentLanguage)%>
			</a>
			<%
		end if
	end if
%>
</body>
</html>


