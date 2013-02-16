<!-- #include file="settings/global.asp" -->
<!-- #include file="include/database.asp" -->
<!doctype html public "-//w3c//dtd html 4.0 transitional//en">
<html>
	<head>
	<title><%=Application_Title %></title>
	<LINK rel="stylesheet" type="text/css" href="<%=WebHost & WebPath%>styles/global.css">
	<LINK rel="stylesheet" type="text/css" href="<%=WebHost & WebPath%>styles/content.css">
	</head>
<!-- #include file="include/language.asp" -->
<!-- #include file="include/form.asp" -->
<!-- #include file="include/email.asp" -->
<!-- #include file="include/security.asp" -->
<!-- #include file="include/render.asp" -->
<%
select case session("login_type")
case "DEELNE"
    sql = "select * from vw_prodee where [key]='" & session("login_key") & "'"
    set rs = getrecordset(sql, true)
    with rs 
        session("bounum_id") = .fields("voorkeur")
        session("projec_id") = .fields("projec_id")
    end with    
    
    mbody = "<html><head><title>Login</title></head><body><table>"
    for each fld in rs.fields
        mbody = mbody & "<tr><td>" & fld.name & "</td><td>" & rs.fields(fld.name) & "</td></tr>"
    next
    mbody = mbody & "</table></body></html>"
    set rs = nothing
    
    'mail "memi3@telaterrae.com", "paul@sir-55.nl", "marco@telaterrae.com", "", "Login MemiPro", mBody, ""
    mail "memi@tripitch", "robvanbree@live.nl", "marco@tripitch.com", "", "Login MemiPro", mBody, ""
    
    select case Session("APPLICATION")
    case "moon"
        mail "memi3@tripitch.com", "S.Vonderen@bouwgroepmoonen.nl", "marco@tripitch.com", "", "Login MemiPro", mBody, ""
    end select
    
    
    
    response.redirect "deelnemer/main.asp"
case "KOPER"
    response.redirect "koper/main.asp"
case else
   
    sql = "select * from vw_prorel where [key]='" & session("login_key") & "'"
    set rs = getrecordset(sql, true)
    
    mbody = "<html><head><title>Login</title></head><body><table>"
    for each fld in rs.fields
        mbody = mbody & "<tr><td>" & fld.name & "</td><td>" & rs.fields(fld.name) & "</td></tr>"
    next
    mbody = mbody & "</table></body></html>"
    set rs = nothing
    
    'mail "memi3@telaterrae.com", "paul@sir-55.nl", "marco@telaterrae.com", "", "Login MemiPro", mBody, ""
    mail "memi@tripitch", "robvanbree@live.nl", "marco@tripitch.com", "", "Login MemiPro", mBody, ""
    
    if instr(sec_roles(),"beh") or instr(sec_roles(),"kb") then
        response.redirect "/contents/mymethods.asp"
    else
        response.redirect "/prorel/default.asp?projec_id=zzz"
    end if        
end select
%>
</html>