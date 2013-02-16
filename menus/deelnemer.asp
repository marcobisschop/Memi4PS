<!-- #include file="../templates/headers/menu.asp" -->
<table>
<tr>
<td><img src="../../images/logo.gif"/></td>
</tr>
<tr>
<td style="padding-left: 10px">
<%
	dim myUserID, RS, SQL, myURL, myImage, sqlMod, rsMod
	myUserID = SEC_CURRENTUSERID()
	
	
 ' Bepaal het projec_id voor de deelnemer
    ' We gaan er vanuit dat de deelnemer maar aan 1 project deelneemt en we bewaren deze variabele in Session("projec_id")
   
       sql = "exec sp_prodee_session '" & session("login_key") & "'"
       set rs = getrecordset(sql, true)
       with rs 
        if not .eof then
            for each fld in .fields
                session(fld.name) = trim(.fields(fld.name))
            next 
        end if 
       end with
      '  set rs = nothing

	Dim ot
	Set ot = Server.CreateObject("obout_asptreeview_pro.tree")
	ot.TreeIcons_Path = WebPath & "menus/asptreeview/tree/treeStyle_MSDN"
	ot.ShowIcons = false
			
	sql = "select pronaa from vw_projec where id=" & session("projec_id")		
	 set rsprojec = getrecordset(sql, true)		
	
	SQL = "sp_deelnemers_menu " & myUserID
	Set RS = getrecordset(SQL, true)

	
	With RS
		If Not .EOF Then
			ot.Add "", "root" , rsprojec.fields("pronaa") & "&nbsp;", , "hr.gif"
			' ot.Add "", "root" , "Sirnet versie 1.1&nbsp;", , "hr.gif"
			Do Until .EOF
			    if .fields("href") = "" then
			        myURL = "<span onclick='ob_os(this)'>" & GetLabel(.fields("name")) & "</span>"
			    else
				    myURL = "<a href='" & .fields("href") & "' target='" & .fields("target") & "'>" & GetLabel(.fields("name")) & "</a>"
				end if
				myImage = .fields("image")
				if isnull(myImage) then myImage = ""
				if .fields("parentid") < 0 then				
					ot.Add  "root", "p_" & .fields("id"), myUrl,  False, myImage
				else				
					ot.Add "p_" & .fields("parentid"), "p_" & .fields("parentid") &"_" & .fields("id"), myUrl, , myImage
				end if
				.MoveNext
			Loop
			
		End If
	End With	
	Set RS = Nothing

    sqlMod = "select * from projec where id=" & session("projec_id")		
	set rsMod = getrecordset(sqlMod, true)		
	
    if cbool(rsMod.fields("mod_loting")) then
        myURL = "<a href='/deelnemer/loting' target='content'>Loting</a>"
	    ot.Add "root", "p_loting", myUrl, , myImage
	end if

    if cbool(rsMod.fields("mod_fasering")) then
    
        myURL = "<a target='content' href='/deelnemer/projec/default.asp'>" & getlabel("my_project") & "</a>" 
        ot.Add  "root", "p_myproject", myUrl, false, myImage
       
        ' sql = "select * from vw_projec_fases where basis=1 and projec_id=" & session("projec_id") & " order by volgor"
       
        sql = "select * from vw_projec_fases where basis=1 and projec_id=" & session("projec_id")
	    sql = sql & " and (getdate() >= datbeg or datbeg is null)"
        sql = sql & " and (getdate() < datein or datein is null)"
        sql = sql & " order by volgor"
    	
       
        set rs = getrecordset(sql, true)
        with rs
            do until .eof
                myURL = "<a target='content' href='/deelnemer/projec/" & .fields("href") & "fase.asp?fases_id=" & .fields("id") & "'>" & .fields("fasnaa") & "</a>"
                ot.Add "p_myproject", "p_myproject_" & .fields("id"), myUrl, , myImage
                .movenext
            loop 
        end with 
        set rs = nothing 
    end if
   
    myURL = "<a target='content' href='/deelnemer/bounum/default.asp?viewstate=view'>" & getlabel("my_bounum") & "</a>" 
    ot.Add  "root", "p_mybounum", myUrl, false, myImage
    myURL = "<a target='content' href='/deelnemer/bounum/deelnemers.asp'>" & getlabel("deelnemers") & "</a>"
    ot.Add "p_mybounum", "p_mybounum_1", myUrl, , myImage
    myURL = "<a target='content' href='/deelnemer/bounum/docum.asp'>" & getlabel("docum") & "</a>"
    ot.Add "p_mybounum", "p_docum", myUrl, , myImage

    
    if cbool(rsMod.fields("mod_memi")) then
        myURL = "<a href='/deelnemer/keuzen/default.asp?keuafd_id=-1&slucat_id=-1' target='content'>Woonwensen</a>"
	    ot.Add "root", "p_woonwensen", myUrl, , myImage
    end if
    
    if cbool(rsMod.fields("mod_documents")) then
        myURL = "<a target='content' href='/deelnemer/documents/default.asp'>" & getlabel("documents") & "</a>"
        ot.Add  "root", "p_mydocumenten", myUrl, false, myImage
    end if

    if cbool(rsMod.fields("mod_fora")) then
        myURL = "<a target='content' href='/deelnemer/fora/default.asp'>" & getlabel("fora") & "</a>"
        ot.Add  "root", "p_myfora", myUrl, false, myImage
        sql = "select * from vw_fora where projec_id=" & session("projec_id") & " order by volgor"
        set rs = getrecordset(sql, true)
        with rs
            do until .eof
                if .fields("closed") then
                    myURL = "<a title='Gesloten' style='color: #ff0000' target='content' href='/deelnemer/fora/fora.asp?fora_id=" & .fields("id") & "'>" & .fields("name") & "</a>"
                else
                    myURL = "<a target='content' href='/deelnemer/fora/fora.asp?fora_id=" & .fields("id") & "'>" & .fields("name") & "</a>"
                end if 
                ot.Add "p_myfora", "p_myfora_" & .fields("id"), myUrl, , myImage
                .movenext
            loop 
        end with 
        set rs = nothing 
    end if

    
    set rsMod = Nothing
    
   response.write "<b>" & getlabel("Bouwnummer") & " " & DBLookup("bounum","id",session("bounum_id"),"extnum") & "</b><br><br>"
    	
	Response.Write ot.HTML
	Set ot = Nothing
%>
</td>
</tr>
</table>

<%
    if cbool(session("stuurgroep")) then
    %>
    <div style="padding-top: 20px; color: red" align="center"><%=getlabel("STUURGROEP")%></div>   
    <%
    end if 
%>

<!-- #include file="../templates/footers/menu.asp" -->
