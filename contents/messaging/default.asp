<!-- #include file="../../templates/headers/content.asp" -->
<!-- #include file="../../include/email.asp" -->
<DIV STYLE="MARGIN:15PX;WIDTH:100%;BORDER:1PX SOLID #21497A;">
<%
	Dim ids, obj
		
	ids = viewstate_value("inreto_id")
	obj = viewstate_value("inreto")
	
	'response.Write obj & "<br>"
	'response.Write ids & "<br>"
	
	dim rs, sql
	
	select case lcase(obj)
	case "deelnemers"
		sql = "select *, contacts_name as contacts_name3 from vw_deelnemers where relati_id in (" & ids & ")"
		'rw sql
		set rs = getrecordset(sql, true)
	case "relations"
		sql = "select *, bednaa as contacts_name3 from vw_relations where id in (" & ids & ")"
		set rs = getrecordset(sql, true)
	case "relations_contacts"
		sql = "select * from vw_relations_contacts where contact_id in (" & ids & ")"
		set rs = getrecordset(sql, true)
	case else
	end select
	
	if viewstate_value("send") = "Versturen" then
		if len(viewstate_value("messagesubject"))=0 then
			topMessage getlabel("errmsg_messagesubject"),"200","200"	
		else
		    Set FS = CreateObject("Scripting.FileSystemObject")
		    sPath = FS.GetSpecialFolder(2)
						
  		    if uploader.files.count >= 1 then
  		        Dim Attachments
  		        Attachments = "" 
				for each file in uploader.files.items
					if file.filesize <= MaxFileSize then
						file.savetodiskwithname sPath, file.filename
						Attachments = Attachments & sPath & file.filename & ";"
					else
						'bestand is te groot
						Response.Write "Let op: maximale bestandsgrootte is " & MaxFileSize & " bytes!"				
					end if
				next
				Attachments = Left(Attachments, Len(Attachments)-1)
				sendMessage obj, ids, viewstate_value("messagesubject"), viewstate_value("body"), Attachments
				for each file in uploader.files.items
					FS.DeleteFile sPath & file.filename					
				next
			else
			    sendMessage obj, ids, viewstate_value("messagesubject"), viewstate_value("body"), ""
			end if
			
	        response.Redirect REFURL
		end if
	end if	
	
%>
<form action="default.asp" method=get>
<input type=hidden id=inreto name=inreto value="<%=obj %>" />
<input type=hidden id=refurl name=refurl value="<%=refurl %>" />
<input type=hidden id=inreto_id name=inreto_id value="<%=ids %>" />
<table style="width:98%" cellpadding=3>
	<tr>
		<td colspan=2><b><%=getlabel("message_header")%></b></td>
	</tr>
	<tr>
		<td style="height:5px;" colspan=2><hr></td>
	</tr>
	<tr>
		<td valign=top><%=getlabel("messagefrom")%>:</td>
		<td><%=sec_field(SEC_CURRENTUSERID(), "contacts_name3")%></td>
	</tr>
	<tr>
		<td style="height:5px;" colspan=2><hr></td>
	</tr>
	<tr>
		<td valign=top><%=getlabel("messageto")%>:</td>
		<td>
		<div style="width:100%;height:60px;overflow:auto;">
		<%
			with rs 
				do until .eof
					if v_valid(isvalidemail,true, .fields("adrema")) then
						response.write .fields("contacts_name3") & " &#060;" & .fields("adrema") & "&#062;<br>"
					else
						response.write "<font color=red>" & .fields("contacts_name3") & " &#060;" & .fields("adrema") & "&#062;</font><br>"
					end if
					.movenext
				loop
			end with
		%>
		</div>
		</td>
	</tr>
	<tr>
		<td style="height:5px;" colspan=2><hr></td>
	</tr>
	<tr>
		<td valign=top><%=getlabel("subject")%>:</td>
		<td><input style="width:100%" type=text id=messagesubject name=messagesubject value="<%=viewstate_value("messagesubject")%>"></td>
	</tr>
	<tr>
		<td valign=top><%=getlabel("attachments")%>&nbsp;(<a href="javascript:Expand()">+</a>):</td>
		<td>
		    <DIV ID=files>
		        <input style="width:100%" type="file" id="file1" name="file1" value="">
		    </DIV>
		    <SCRIPT>
                //Script to add an attachment file field 
                var nfiles = 1;
                function Expand(){
                  nfiles++
                  var adh = '<input style="width:100%" type="file" id="file'+nfiles+'" name="file'+nfiles+'">';
                  files.insertAdjacentHTML('BeforeEnd',adh);
                };
            </SCRIPT>
		</td>
	</tr>
 	<tr>
		<td style="height:5px;" colspan=2><hr></td>
	</tr>
	<%	
		f_htmlarea nothing, "messagebody", "body","700px",340
	%>
	<tr>
		<td style="height:5px;" colspan=2><hr></td>
	</tr>
</table>
&nbsp;&nbsp;<input type="submit" value="Versturen" id=send name=send>
<input type="button" value="Annuleren" id=cancel name=cancel onclick="window.close()">
</form>
</div>

<!-- #include file="../../templates/footers/content.asp" -->

<%

    


	function sendMessage (obj, ids, subject, body, Attachments)
		dim mFrom, mTo, Mtos
		
		mFromName = dblookup("vw_contacts_email","id", sec_currentuserid(),"con_fullname")
		mFromEmail = dblookup("vw_contacts_email","id", sec_currentuserid(),"adrema")
		
		mFrom = mFromName & " <" & mFromEmail & ">"
		'mFrom = "A en S Financieel Adviseurs BV <info@asfa.nl>"
		with rs
			.movefirst
			do until .eof
				if v_valid(isvalidemail,true, .fields("adrema")) then
					mTo = replace(.fields("contacts_name2"),",","") & " <" & .fields("adrema") & ">, "
					mTos = Mtos & "<br>" & Mto
					mail mFrom, mTo, mCc, mBcc, Subject, Body, Attachments	
				end if
				.movenext
			loop			
			.movefirst
		end with
		mBCc = "marco@telaterrae.com"
		mail mFrom, mFrom, mCc, mBcc, "Controle e-mail: " & Subject, "<h1>Als laatste verstuurd</h1>" & Body & "<h1>Verstuurd aan</h1>" & Mtos, Attachments	
	end function
%>
<%
	' set rs = nothing
%>