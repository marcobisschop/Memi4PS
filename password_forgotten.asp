<!-- #include file="settings/global.asp" -->
<!-- #include file="include/database.asp" -->
<!-- #include file="include/variables.asp" -->
<!doctype html public "-//w3c//dtd html 4.0 transitional//en">
<html>
	<head>
	<LINK rel="stylesheet" type="text/css" href="<%=WebHost & WebPath%>styles/global.css">
	<LINK rel="stylesheet" type="text/css" href="<%=WebHost & WebPath%>styles/content.css">
	</head>
<!-- #include file="include/language.asp" -->
<!-- #include file="include/form.asp" -->
<!-- #include file="include/render.asp" -->
<!-- #include file="include/email.asp" -->
	<body>
        <table style="width:100%; height:100%;" ID="Table1">
			<tr>
				<td align="center" valign="middle">
					<%f_form_hdr()%>
						<table class="frm_login" ID="Table2" cellpadding=0 cellspacing=0>
							<tr>
								<td class="frm_login_header">
									<b><%=GetLabel("login_password_forgotten_title")%></b><br>
									<%=GetLabel("login_password_forgotten_description")%>
								</td>
							</tr>
							<tr>
								<td class="frm_login_content" valign="center" align="center">
								    <%
								        Dim rs, sql, do_send,PASSWORD_FORGOTTEN_MESSAGE,password_message
								        Dim login_email
								        do_send = true
								        login_email = fieldvalue(rs,"login_email")
								        if not v_valid(isvalidemail,true,login_email) then
								            PASSWORD_FORGOTTEN_MESSAGE = getlabel("login_password_forgotten_emailinvalid")
								        else
								            sql = "select * from relati where [emapri]='" & login_email & "'"
								            ' response.write sql
								            set rs = getrecordset(sql, true)
								            with rs
								                if .recordcount = 0 then PASSWORD_FORGOTTEN_MESSAGE = getlabel("login_password_forgotten_emailunknown")
								                if .recordcount > 1 then PASSWORD_FORGOTTEN_MESSAGE = getlabel("login_password_forgotten_emailnotunique")
								                if .recordcount = 1 then
								                    if .fields("locked") = 1 then 
								                        PASSWORD_FORGOTTEN_MESSAGE = getlabel("login_password_forgotten_accountislocked")
								                    else
								                        PASSWORD_FORGOTTEN_MESSAGE = getlabel("login_password_forgotten_passwordsend")
								                        password_message = getlabel("login_password_forgotten_emailbody")
								                        'on error resume next
								                        for each fld in .fields
								                            'response.Write fld & "<br>"
								                            password_message = replace(password_message,"#" & fld.name & "#",.fields(trim(fld.name)))
								                        next
								                        do_send = true
								                        'on error goto 0
								                    end if
								                end if
								            end with								            
								            set rs = nothing
								            if do_send then
								            
								                ' response.Write password_message
								            
								                mail getvariable("_EMAIL_PASSWORDFORGOTTEN_FROM_NAME_") & "<" & getvariable("_EMAIL_PASSWORDFORGOTTEN_FROM_")& ">", login_email,"","", getlabel("login_password_forgotten_emailsubject"), password_message,""
								                
								                'mail (mFrom, mTo, mCc, mBcc, mSubject, mBody, Attachments)
								            end if
								        end if
								        
								    %>
									<table style="width:100%" ID="Table5">
										<tr>
											<td><%=GetLabel("email")%></td>
											<td><input type=text id=Login_Email name=Login_Email value="<%=Login_Email%>"></td>
										</tr>
										<tr>
											<td>&nbsp;</td>
											<td><input type="submit" id="login" name="login" value="<%=GetLabel("login_password_forgotten_button")%>"></td>
										</tr>
										<tr>
											<td>&nbsp;</td>
											<td><p><%=PASSWORD_FORGOTTEN_MESSAGE%></p></td>
										</tr>
									</table>
								</td>
							</tr>
							<tr>
								<td class="frm_login_footer">
									<a href="default.asp"><%=GetLabel("login_login")%></a>
									<br>
									<!--<a href="register.asp"><%=GetLabel("login_register")%></a>-->
								</td>
							</tr>
						</table>
					</FORM>
				</td>
			</tr>
		</table>	        
	</body>	
</html>
