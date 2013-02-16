<!-- #include file="../templates/headers/menu.asp" -->
<%
	dim myUserID, RS, SQL, myURL, myImage
	myUserID = SEC_CURRENTUSERID()
	
	SQL = "sp_kopers_menu " & myUserID
	Set RS = getrecordset(SQL, true)
	
	With RS
		If Not .EOF Then
			Dim ot
			Set ot = Server.CreateObject("obout_asptreeview_pro.tree")
			ot.TreeIcons_Path = WebPath & "menus/asptreeview/tree"
			ot.ShowIcons = true
			ot.Add "", "root" , "&nbsp;" & getLabel("Home") & "&nbsp;", , "memobook_blue.gif"
			Do Until .EOF
			    if .fields("href") = "" then
			        myURL = "<span onclick='ob_os(this)'>" & GetLabel(.fields("name")) & "</span>"
			    else
				    myURL = "<a href='" & .fields("href") & "' target='" & .fields("target") & "'>" & GetLabel(.fields("name")) & "</a>"
				end if
				myImage = .fields("image")
				if isnull(myImage) then myImage = ""
				if .fields("parentid") < 0 then				
					ot.Add  "root", "p_" & .fields("id"), myUrl, True, myImage
				else				
					ot.Add "p_" & .fields("parentid"), "p_" & .fields("parentid") &"_" & .fields("id"), myUrl, , myImage
				end if
				.MoveNext
			Loop
			Response.Write ot.HTML
			Set ot = Nothing
		End If
	End With	
	Set RS = Nothing
%>
<!-- #include file="../templates/footers/menu.asp" -->
