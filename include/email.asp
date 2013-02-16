<!-- 
    METADATA 
    TYPE="typelib" 
    UUID="CD000000-8B95-11D1-82DB-00C04FB1625D"  
    NAME="CDO for Windows 2000 Library" 
-->
<%
   
	Const smtpServer		= "172.16.0.184"
	Const smtpUsername		= "administrator"
	Const smtpPassword		= "Me$$@ge2"


	function mail2 (mFrom, mTo, mCc, mBcc, mSubject, mBody, Attachments)
	    Set cdoConfig = CreateObject("CDO.Configuration")  
     
        With cdoConfig.Fields  
            .Item(cdoSendUsingMethod) = cdoSendUsingPort  
            .Item(cdoSMTPServer) = "127.0.0.1"  
            .Update  
        End With 
     
        Set cdoMessage = CreateObject("CDO.Message")  
     
        With cdoMessage 
            Set .Configuration = cdoConfig 
            .From = mFrom
            .To = mTo 
            .CC = mCC
            .BCC = mBcc
            .Subject = mSubject
            .HTMLBody = mBody
            If Len(Attachments)>0 Then
			    If Instr(1,attachments,";") Then
    			    Dim a
    			    a = Split(Attachments,";")
    			    for i = lbound(a) to ubound(a)
    			        .AddAttachment a(i)
    			    next
    			Else
    			    .AddAttachment Attachments
			    End If
			End If
            .Send 
        End With 
     
        Set cdoMessage = Nothing  
        Set cdoConfig = Nothing 
    end function
    
    
    
	function mail (mFrom, mTo, mCc, mBcc, mSubject, mBody, Attachments)
		Set cdoConfig = CreateObject("CDO.Configuration")  
     
        With cdoConfig.Fields  
            .Item(cdoSendUsingMethod) = cdoSendUsingPort  
            .Item(cdoSMTPServer) = "127.0.0.1"  
            .Update  
        End With 
     
        Set cdoMessage = CreateObject("CDO.Message")  
     
        With cdoMessage 
            Set .Configuration = cdoConfig 
            .From = mFrom
            .To = mTo 
            .CC = mCC
            .BCC = mBcc
            .Subject = mSubject
            .HTMLBody = mBody
            If Len(Attachments)>0 Then
			    If Instr(1,attachments,";") Then
    			    Dim a
    			    a = Split(Attachments,";")
    			    for i = lbound(a) to ubound(a)
    			        .AddAttachment a(i)
    			    next
    			Else
    			    .AddAttachment Attachments
			    End If
			End If
            .Send 
        End With 
     
        Set cdoMessage = Nothing  
        Set cdoConfig = Nothing 

	end function
	
	'mail "memi3@telaterrae.com", "marco@tripitch.com", "marco@telaterrae.com", "", "Login MemiPro", "lalalalala", ""
    'response.Write "mailtje"

	function mailURL(mFrom, mTo, mSubject, mUrl)
		Const g_Debug = False
		Dim iMsg
		Dim iConf
		Dim Flds

		Set iMsg = Server.CreateObject("CDO.Message")
		Set iConf = Server.CreateObject("CDO.Configuration")

		Set Flds = iConf.Fields
		'Flds("http://schemas.microsoft.com/cdo/configuration/urlproxyserver") = "proxyname:80"
		'Flds("http://schemas.microsoft.com/cdo/configuration/urlproxybypass") = "<local>"
		Flds("http://schemas.microsoft.com/cdo/configuration/urlgetlatestversion") = True
		Flds.Update

		With Flds
			.Item(cdoSendUsingMethod)       = cdoSendUsingPort
			.Item(cdoSMTPServer)            = smtpServer
			.Item(cdoSMTPServerPort)        = 25
			.Item(cdoSMTPConnectionTimeout) = 10
			.Item(cdoSMTPAuthenticate)      = 0' cdoBasic
			' .Item(cdoSendUserName)          = smtpUsername
			' .Item(cdoSendPassword)          = smtpPassword
			.Update
		End With

		Set iMsg.Configuration = iConf

		'On Error Resume Next

		With iMsg
			.To       = mTo '& ";bisschop.marco@telaterrae.com"
			.From     = mFrom
			.Subject  = mSubject
	''		response.write url
	''		response.end
			.CreateMHTMLBody mUrl, cdoSuppressNone  ', "grutdijk\mabis","Me$$@ge2"
			.Send
		End With

		

		If Err.Number <> 0 Then
		  ' Handle error.
		End If

		If g_Debug Then
		  Response.Write iMsg.GetStream.ReadText
		End if

		set iMsg = Nothing
		set iConf = Nothing

	end function
%>