<%
	If viewstate_value("change_language") = "TRUE" then
		dim Language, prevPage
		Language = viewstate_value("lng")
		prevPage = Request.ServerVariables("HTTP_REFERER")
		
		Session("Language") = Language
		Response.Redirect prevPage 
	end if
	
	'response.Write "current language=" & session("language")
		
	Dim	isTranslateMode, Color, defaultLanguage, labelColor
	isTranslateMode = False
	Color			= "#FF0000"
	labelColor		= "#FF0000"
	defaultLanguage = "NL"
	'defaultLanguage = "UK"
	
	function EditorLang(language)
		select case lcase(language)
			case "nl"
				EditorLang = "?lang=dutch"
			case "uk"
				EditorLang = ""
		end select
    end function
	
	function currentLanguage()
		isTranslateMode = False
		Color = "#FF0000"
		currentLanguage = Session("Language")
		if len(currentLanguage)=0 then
			currentLanguage = defaultLanguage
			session("language") = currentLanguage
		end if
		if session("language") = "keys" then isTranslateMode = True : Color = "#FF0000"
	end function

	function getLabel(key)
	    if session("translation_off")=1 then
	        getlabel = key
	        exit function
	    end if
		language = session("language")
		dim sql, rs, label
		key = replace(trim(key),"'","''")
		sql = "select * from language_labels where [key]='" & key & "'"
		'response.write "language sql = " & sql & "<br>"
		set rs = getrecordset(sql, true)
		with rs
			if not .eof then
				select case lcase(language)
				case "nl"
					label = "" & .fields("nl") & ""
				case "uk"
					label = "" & .fields("uk") & ""
				case "keys"
					label = .fields("key")
				end select
				if len(label)=0 then 
					If isTranslateMode Then
						label = "<a target='Content' href='" & WebPath & "beheer/editlabels.asp?formstate=edit&id=" & rs.fields("id") & "&Listurl=return'><font color=" & Color &">NT: " & key & "</font></a>"
					Else
						label = "<font color=" & Color &">NT: " & key & "</font>"
					End if
				else
					If isTranslateMode Then
						label = label & "(<a target='Content' href='" & WebPath & "beheer/editlabels.asp?formstate=edit&id=" & rs.fields("id") & "&Listurl=return'> e</a>)"
					End If
				end if
			else
				If isTranslateMode then
					label = "<a target='Content' href='" & WebPath & "beheer/editlabels.asp?formstate=new&id=-1&Listurl=return'><font color=" & Color &">NK: " & key & "</font></a>"
				else
					label = "<font color=" & Color &">NK: " & key & "</font>"
					sql = "insert into language_labels ([key],nl,en) values ('" & lcase(key) & "','" & lcase(key) & "','" & lcase(key) & "')"
					executesql sql
				end if
			end if
		end with
		getLabel = label
		set rs = nothing
	end function

%>
<!--
	<p>
	CL : <%=CurrentLanguage%><br>
	LNG:
	<a href="<%=webpath%>include/language.asp?lng=keys">keys</a>, 
	<a href="<%=webpath%>include/language.asp?lng=nl">nl</a>, 
	<a href="<%=webpath%>include/language.asp?lng=uk">uk</a><br>
	<a href="<%=webpath%>include/tabledefs.asp" target="Content">tables</a>
	
	</p>
-->
