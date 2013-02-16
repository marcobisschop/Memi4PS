<%
	
    IF NOT CAN_EDIT THEN 
	    FORCE_VIEWSTATE_VIEW = TRUE
	END IF

    'Wordt bepaald in sec_roles_modules
    'Aan de hand van de rol van de gebruiker kan opgegeven worden wat de gebruiker binnen de module mag 

    'IF NOT USERCAN("WRITE") THEN	 
        'FORCE_VIEWSTATE_VIEW = TRUE
    'END IF

	FUNCTION SEC_ISLOGGEDIN()
		SEC_ISLOGGEDIN = (SESSION("LOGIN_ID") > 0)
	END FUNCTION
	

	function sec_isloggedin()
		sec_isloggedin = (session("login_id") > 0)
	end function
	
	if not sec_isloggedin() then
		login_key    = viewstate_value("login_key")
		if len(login_key) >= 8 then
		    if not sec_login(login_key) then
			    sec_loginform login_key 
		    else
			    session("login_message") = getlabel("login_invalid_credentials")
		    end if
		else
			    sec_loginform login_key 
		end if
	else
		
	end if
	
	if is_readonly(sec_currentuserid()) then
	    force_viewstate_view = true
	end if	
	
	function is_readonly(userid)
	    is_readonly = false
	end function
	
	sub sec_loginform(login_key)
		%>
		<table style="width:100%; height:100%;" id="table1">
			<tr>
				<td align="center" valign="middle">
					<%f_form_hdr()%>
						<table class="frm_login" id="table2" cellpadding=0 cellspacing=0>
							<tr>
								<td class="frm_login_header">
									<b><%=getlabel("login_title")%></b><br>
									<%=getlabel("login_enter_credentials")%>
								</td>
							</tr>
							<tr>
								<td class="frm_login_content" valign="center" align="center">
									<table style="width:100%" id="table5">
										<tr>
											<td><%=getlabel("login_key")%></td>
											<td><input type=password id=login_key name=login_key value="<%=login_key%>"></td>
										</tr>
										<tr>
											<td>&nbsp;</td>
											<td><input type="submit" id="login" name="login" value="login"></td>
										</tr>
										<tr>
											<td>&nbsp;</td>
											<td><%=session("login_message")%></td>
										</tr>
									</table>
								</td>
							</tr>
							<tr>
								<td class="frm_login_footer">
									<!--<a href="password_forgotten.asp"><%=getlabel("login_password_forgotten")%></a>
									<br>
									<a href="register.asp"><%=getlabel("login_register")%></a>-->
								</td>
							</tr>
						</table>
					</form>
				</td>
			</tr>
		</table>
		</body> 
		</html>
		<%
		response.end
	end sub
	
	if not sec_hasrole(requiredrole) then
		if not sec_isloggedin() then
			but_login    = request("login")
			inp_key      = request("key")
			if but_login = "login" then
				if not sec_login(inp_key) then
					sec_loginform()
				end if
			else
				sec_loginform()
			end if		
		end if
	end if

	function sec_hasrole(requiredrole)
		sec_hasrole = false
		select case ucase(requiredrole)
		case "none"
			sec_hasrole = true
		case "else"
			dim r(), i
			r = split(session("login_roles"),"|")
			for i = lbound(r) to ubound(r)
				if ucase(requiredrole) = ucase(r(i)) then sec_hasrole = true : exit function
			next
		end select
	end function

    function sec_currentuserrole_id()
		sec_currentuserrole_id = -1
		dim r, i
		
		r = split(session("login_roles"),"|")
		
	    sec_currentuserrole_id = DBLookup ("relsoo", "soonaa", "'" & r(1) & "'", "id")
	end function

	function sec_has_projec_role(requiredrole)
		sec_has_projec_role = false
		select case ucase(requiredrole)
		case "none"
			sec_has_projec_role = true
		case else
			dim r, i
			r = split(session("sec_projec_roles"),"|")
			for i = lbound(r) to ubound(r)
				if ucase(requiredrole) = ucase(r(i)) then 
					sec_has_projec_role = true 
					response.write "requiredrole = " & requiredrole & " : "
					response.write "role: " & r(i) & " : "
					response.write " found!<br>"				
					exit function
				else
					'response.write " not found!<br>"
				end if
			next
		end select
	end function

	function sec_login(key)
		dim rs, sql, result
		result = false
		session("database_selector") = left(key,4)
		sql = "sp_security_rollen '" & key & "'"
		'response.write sql
		set rs = getrecordset(sql, true)
		if not isobject(rs)  then response.Redirect "/close.asp"
		with rs
		    if not .eof then
			    if .recordcount >= 1 then
				    result = true
				    session("login_key") = .fields("key")	
				    sec_defineroles rs
				    'response.redirect webpath & "login.asp"
			    end if
			end if
		end with
		set rs = nothing
		sec_login = result
	end function

	sub sec_defineroles(rs)
		session("login_roles") = "ROLES:|"
		dim security_role
		with rs
		    session("login_type") = .fields("type")
			do until .eof
				if lcase(.fields("type")) = "koper" then
					security_role = "koper"
				else
					security_role = ucase(.fields("soonaa"))
				end if
				if instr(1,session("login_roles"),"|" & lcase(security_role) & "|") > 0 then
				    ' role already defined
				else
				    session("login_roles") = session("login_roles") & lcase(security_role) & "|"				
				end if
				.movenext
			loop
		end with 
	end sub

	function sec_isloggedin()
		sec_isloggedin = len(session("login_key")) > 0
	end function

	function sec_fullname()
		if sec_isloggedin() then
			dim rs, sql, result
			result = false
			sql = "sp_security_fullname '" & session("login_key") & "'"
			set rs = getrecordset(sql, true)
			with rs
				if .recordcount = 1 then
					result = .fields("fullname")
				end if
			end with
			set rs = nothing
		else
			result = ""
		end if
		sec_fullname = result
	end function
	
	function sec_loginid()
		if sec_isloggedin() then
			dim rs, sql, result
			result = false
			sql = "select * from relati where [key] = '" & session("login_key") & "'"
			set rs = getrecordset(sql, true)
			with rs
				if .recordcount = 1 then
					result = .fields("id")
				end if
			end with
			set rs = nothing
		else
			result = "-1"
		end if
		sec_loginid = result
	end function

    function sec_currentuserid()
		if sec_isloggedin() then
			dim rs, sql, result
			result = false
			sql = "select * from relati where [key] = '" & session("login_key") & "'"
			
			'response.write sql
			
			set rs = getrecordset(sql, true)
			with rs
				if .recordcount = 1 then
					result = .fields("id")
				end if
			end with
			set rs = nothing
		else
			result = "-1"
		end if
		sec_currentuserid = result		 
	end function
	
	function sec_roles()
		sec_roles = left(session("login_roles"),len(session("login_roles"))-1)
	end function

	function sec_setsecurityinfo(rs)
	    on error resume next
		with rs
			if len(.fields("createdby"))=0 or .fields("createdby")<=0 then
				.fields("createdby")  = sec_currentuserid()	
				.fields("created") = now() 
			end if
			.fields("editedby") = sec_currentuserid()			
			.fields("edited")= now()
		end with
		if err.number <> 0 then
		    with rs
			    if len(.fields("aangeb"))=0 or .fields("aangeb")<=0 then
				    .fields("aangeb")  = sec_currentuserid()	
				    .fields("aandat") = now() 
			    end if
			    .fields("wijgeb") = sec_currentuserid()			
			    .fields("wijdat")= now()
		    end with
		end if
	end function
				
	function sec_logevent(ev)
		dim sql,rs
		sql = "select * from log_events where id=-1"
		set rs = getrecordset(sql,false)
		with rs
			.addnew
			.fields("event") = ev
			.fields("sec_users_id") = sec_currentuserid()
		end with
		sec_setsecurityinfo(rs)
		putrecordset rs
		set rs = nothing		
	end function
	
	function generatepassword(lenpassword)
		'adapt these const to your language
		const strvowel = "aeiou"						'all the vowels except y
		const strconsonant = "bcdfghjklmnprstv"			'all the consonants except q,w,x,z
		const strdoubleconsonant = "cdfglmnprst"		'these consonants may be double	
					
				dim writeconsonant			'boolean
				dim nbrnd					'a random number
				dim i, tmp
					
		generatepassword = ""
		writeconsonant = false
				randomize
		for i = 0 to lenpassword	
		nbrnd = rnd
		'write a single or a double consonant ?
		'1.no word begin with a double consonant
						'2.about 10% of double consonants
		if generatepassword <> "" and (writeconsonant = false) and (nbrnd < 0.10) then
		'choose a double consonant
		tmp = mid(strdoubleconsonant, int(len(strdoubleconsonant) * rnd + 1), 1)
								'write it
		tmp = tmp & tmp
								i = i + 1
		'next letter may be a consonant
								writeconsonant = true
		else
								'if the last letter is a vowel, the probability is 90% to have a consonant							
		if (writeconsonant = false) and (nbrnd < 0.90) then
		'single consonant
		tmp= mid(strconsonant, int(len(strconsonant) * rnd + 1), 1)
		writeconsonant = true
								'if the last letter is a double consonant,
								'the next letter is necessary a vowel !
		else
		'write it
		tmp = mid(strvowel,int(len(strvowel) * rnd + 1), 1)
		writeconsonant = false
		end if
		end if
		'add a letter
		generatepassword = generatepassword & tmp
		next
			
		'check password length
		if len(generatepassword) > lenpassword then
		generatepassword = left(generatepassword, lenpassword)
		end if
    end function
    
    function UserCan (Right)
        'on error resume next 
        dim sql, rs, result
        result = false
        sql = "select * from sec_roles_modules where sec_roles_id=" & sec_currentuserrole_id & " and sec_modules_id=" & sec_currentmodule_id 
        'response.Write "<br>right: " & Right 
        'response.Write "<br>" & sql
        set rs = getrecordset(sql, true)
        if rs.recordcount = 1 then
            select case lcase(right)
            case "read"
                result = cbool(rs.fields("can_read"))
            case "write"
                result = cbool(rs.fields("can_write"))
            case "delete"
                result = cbool(rs.fields("can_delete"))
            case else
                result = false
            end select        
        else
            ' De combinatie bestaat nog niet in de tabel sec_roles_modules
            ' We maken standaard deze regel aan met alleen leesrechten!
            sql = "sp_security_roles_modules_set " & sec_currentuserrole_id & ", " & sec_currentmodule_id 
            executesql sql
            result = UserCan(right)
            'result = false
        end if
        'response.Write "<h1>" & right & " : " & result & "</h1>"
        if err.number <> 0 then 
            UserCan = Err.Description 
        else
            UserCan = Result        
        end if
        on error goto 0
    end function 
   
    function sec_candelete()
		UserCan("delete")
	end function
   
    function sec_currentmodule()
        if instr(request.ServerVariables("script_name"),"/")>0 then 
            result = request.ServerVariables("script_name")
            ma = split(result, "/")
            sec_currentmodule = ma(2)
        else
            sec_currentmodule = "This is not a program module!"
        end if
    end function 

    function sec_currentmodule_id()
        on error resume next 
        dim sql, rs, myPage, result, pageIndex, moduleIndex
        
        result = request.ServerVariables("script_name")
        
        'response.Write result
        'response.End 
        
        if lcase(result) = "/default.asp" then
            result = -1
        else
            if instr(request.ServerVariables("script_name"),"/")>0 then 
                ma = split(result, "/")
                pageIndex = UBound(ma)
                moduleIndex = UBound(ma) - 1
                if 1=2 then
                    response.Write "pageIndex=" & pageIndex & "<br>"
                    response.Write "moduleIndex=" & moduleIndex & "<br>"
                    response.Write "page=" & ma(pageIndex) & "<br>"
                    response.Write "module=" & ma(moduleIndex) & "<br>"
                    response.Write "page=" & ma(3) & "<br>"
                    response.Write "module=" & ma(2) & "<br>"
                end if
                'Controleren of deze pagina speciale rechten heeft
                'De pagina bestaat dan in de tabel sec_modules
                myPage = ma(pageIndex)
                sql = "select * from sec_modules where [name]='" & mypage & "'"
                set rs = getrecordset(sql, true)
                if rs.recordcount=1 then
                    result = DBLookup ("sec_modules", "name", "'" & ma(pageIndex) & "'", "id")
                else
                    'geen speciale rechten, dus modulenaam ophalen
                    result = DBLookup ("sec_modules", "name", "'" & ma(moduleIndex) & "'", "id")
                    if result = "" then
                       executesql "insert into sec_modules ([name]) values ('" & ma(moduleIndex) & "')"
                       result = DBLookup ("sec_modules", "name", "'" & ma(moduleIndex) & "'", "id") 
                       response.Write "insert the basterd"
                    end if 
                end if
                set rs = nothing
            else
                result = -1
            end if
        end if
        sec_currentmodule_id = result
        if err.number <> 0 then
            response.Write err.Description 
        end if
    end function 

    function sec_info()
    %>
        <table style="border-top: solid #000000 1px;">
            <tr><td><%=getlabel("script_name") %></td><td><%=request.ServerVariables("script_name")%></td></tr>
            <tr><td><%=getlabel("username") %></td><td><%=sec_currentusername()%></td></tr>
            <tr><td><%=getlabel("userrole") %></td><td><%=sec_currentuserrole()%></td></tr>
            <tr><td><%=getlabel("module_name") %></td><td><%=sec_currentmodule()%></td></tr>
            <tr><td><%=getlabel("module_id") %></td><td><%=sec_currentmodule_id()%></td></tr>
            <tr><td><%=getlabel("can_read") %></td><td><%=UserCan("read")%></td></tr>
            <tr><td><%=getlabel("can_write") %></td><td><%=UserCan("write")%></td></tr>
            <tr><td><%=getlabel("can_delete") %></td><td><%=UserCan("delete")%></td></tr>
        </table>
    <%    
    end function 
   
   FUNCTION SEC_FIELD(ID, FIELD)
	    DIM SQL, RS
	    SQL = "SELECT " & FIELD & " FROM vw_relations_contacts WHERE CONTACT_ID=" & ID
	    SET RS = GETRECORDSET(SQL, TRUE)
	    IF RS.RECORDCOUNT>0 THEN SEC_FIELD = RS.FIELDS(FIELD) ELSE SEC_FIELD = "SEC_FIELD: RECORD NOT FOUND IN TABLE vw_relations_contacts"
	    SET RS = NOTHING
    END FUNCTION 
%>