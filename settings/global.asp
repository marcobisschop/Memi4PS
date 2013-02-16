<%
	'Voer hier globale constanten en variabelen op die door de hele applicatie gebruikt 
	'kunnen worden.

	'security
	Const DEBUG_MODE = FALSE
	Const MAXPASSWORDAGEINDAYS = 60
	Const MIN_PASSWORD_LENGTH = 6
	Const CAN_EDIT = TRUE
	Dim FORCE_VIEWSTATE_VIEW			' Wordt gezet in security.asp adhv van CAN_EDIT

	'applicatie instellingen
	Dim Application_Title  
	Application_Title   = "MEMI Pro &copy; " & Year(Now)
	Const Application_Version = "3.2.1"
	
	'webhost settings
	Dim WEBHOST, WEBPATH, LOGIN_URL, CURRENT_URL, APPL_DIR
	
	Session("server_name") = lcase(request.ServerVariables("server_name"))
	Session("http_accept_language") = lcase(request.ServerVariables("http_accept_language"))
	Session("remote_addr") = lcase(request.ServerVariables("remote_addr"))
	Session("http_user_agent") = lcase(request.ServerVariables("http_user_agent"))
	Session("http_accept") = lcase(request.ServerVariables("http_accept"))
	Session("script_name") = lcase(request.ServerVariables("script_name"))
	
	Session("APPLICATION") = lcase(split(session("server_name"),".")(0))
	
	WEBHOST   = "http://" & Session("server_name")
	WEBPATH   = "/"
	LOGIN_URL = WEBHOST & "login.asp"
	CURRENT_URL = WEBHOST & Request.ServerVariables("SCRIPT_NAME")
		
	server.ScriptTimeout = 6000
	session.Timeout = 90	
	
	APPL_DIR = SPLIT(CURRENT_URL, "/")(3)
	
	'maximale bestandgrootte voor uploaden
	Const MaxFileSize = 10000000 'bytes
	
	'foutmeldingsinstellingen
	Const f_errorstyle = "background-color:AA0000"	
	Const f_noerrorstyle = ""
	
%>
