<%
	const isvaliddate			= "^([0-3]{0,2}\d)\-([0-1]{0,2}\d)\-([0-9]{4})$"' "^[0-9]{1,2}-[0-9]{1,2}-\d{4}"
	const isvalidtime			= "^([012]\d)\:([0-5]\d)$"
	const isvalidemail			= "^[\w\-\.]+@[a-z0-9]+[\-]?[a-z0-9]+((\.(com|net|org|edu|int|mil|gov))|(\.(com|net|org|edu|int|mil|gov)\.[a-z]{2})|(\.[a-z]{2}))$"
	const isvalidcurrency		= "^([0-9]+\,[0-9]{2})|([0-9]+)$"
	const isvalidstreetname		= "/\d+/" 
	const ex_adrnum				= "^\d+$"                                                                                                                                                                                                                                                            
	const ex_adrpos				= "^\d{4}\s[A-Z]{2}$"                                                                                                                                                                                                                                                            
	const isvalidcity			= "^\w*"                                                                                                                                                                                                                                                            
	const isvalidphonenumber	= "^\d*$"
	const isvalidimei			= "^[a-z0-9]{4}-[a-z0-9]{4}-[a-z0-9]{4}"
	const isvalidtext			= "^\w*"
	const isipnummer			= "^[0-9]{2,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}$"

	dim formerrors, errorcount		
	errorcount = 0

	' use this function to add an error to the error collection
	function v_addformerror (field)
		formerrors = formerrors & field & ";"
		errorcount = errorcount + 1
	end function

	' use this function to see if a field contains a format error
	function v_informerrors (field)
		if instr(1,lcase(formerrors),lcase(field) & ";") > 0 then
			v_informerrors = true
		end if
		' response.write formerrors
	end function
	
	function v_haserrors()
		dim result
		result = false
		if len(formerrors)>0 then result = true
		v_haserrors = result
	end function
	
	' use this function to check wether the input for the field is valid given the specified expression
	function v_valid (exp, required, value)
		v_valid = false 
		value = trim(value)
		if required = true and len(value)=0 then
			exit function
		end if
		if required = false and len(value)=0 then
			v_valid = true
		else
			if len(value) > 0 then
				set oregexp = new regexp
				with oregexp
					.pattern = exp
					.ignorecase = true 
					v_valid = .test (value)
				end with
				set oregexp = nothing 
			else
				v_valid = false
			end if
		end if
	end function
	
	function v_isdate(required,value)
		dim d
		v_isdate = false
		if len(value)=0 and required = true then exit function
		if len(value)=0 or isnull(value)  and required = false then v_isdate = true : exit function
		if isnull(value) then exit function 
		d = convertdate(value)
		if v_valid(isvaliddate,required,d) then
			v_isdate = true
		end if		
		on error resume next
		if not isdate(cdate(d)) then
			v_isdate = false
		end if
		if err.number <> 0 then
			v_isdate = false
		end if
		on error goto 0
	end function
	
	Function v_IsTime(Required, Value)
		dim t
		v_IsTime = False
		if len(value)=0 and required = true then exit function
		if len(value)=0 and required = false then v_istime = true : exit function
		t = converttime(Value)
		If Not v_valid("^[0-2]\d\:[0-5]\d$", Required, t) Then Exit Function
		v_IsTime = True
	End Function
	
	function DateToISO (D)
		Dim myYear
		Dim myMonth
		Dim myDay
		Dim Result
		
		if not isdate(d) then
		    myYear = year(now)
		    myMonth = 1
		    myDay = 1
		else
		    myYear = Year(D)
		    myMonth = Month(D)
		    myDay = Day(D)
		end if
		
		
		Result = myYear & "-" & myMonth & "-" & myDay
		DateToISO = Result
	end function
	
	
	function formatdate(d)
		formatdate = right("00" & day(d),2) & "-" & right("00" & month(d),2) & "-" & year(d)
	end function
	
	function convertdate(d)
		' vervang alles wat geen cijfer is door een -
		on error resume next
		if len(d)=0 then 
			convertdate = null
			exit function
		end if
		dim dd
		const validchars = "0123456789"
		for i = 1 to len(d)
			if instr(1,validchars,mid(d,i,1))<=0 then
				dd = dd & "-"
			else
				dd = dd & mid(d,i,1)
			end if
		next
		if dd="-" then 
			convertdate = "" 
		else 
			ad = split(dd,"-")
			convertdate = right("00" & ad(1),2) & "-" & right("00" & ad(0),2) & "-" & ad(2)
			convertdate = dd
		end if
	end function

	function converttime(d)
		' vervang alles wat geen cijfer is door een -
		on error resume next
		if len(d)=0 then 
			convertdate = null
			exit function
		end if
		dim dd
		const validchars = "0123456789"
		for i = 1 to len(d)
			if instr(1,validchars,mid(d,i,1))<=0 then
				dd = dd & ":"
			else
				dd = dd & mid(d,i,1)
			end if
		next
		if dd=":" then converttime = "" else converttime = dd		
	end function

	function convertvalue(v)
		convertvalue = replace(v,",",".")
		if v = "" then convertvalue = "0.00"
	end function
	
	function chsofi(sofi)
		dim s
		chsofi = false
		if len(sofi)<>9 then exit function 
		if not isnumeric(sofi) then exit function
		s = 0
		s = s + mid(sofi,1,1) * 9
		s = s + mid(sofi,2,1) * 8
		s = s + mid(sofi,3,1) * 7
		s = s + mid(sofi,4,1) * 6
		s = s + mid(sofi,5,1) * 5
		s = s + mid(sofi,6,1) * 4
		s = s + mid(sofi,7,1) * 3
		s = s + mid(sofi,8,1) * 2
		s = s + mid(sofi,9,1) * -1
		if s mod 11 = 0 then chsofi = true
	end function
	
	Function chNRek(cNRek)
        cNRek = Trim(cNRek)
        If IsNumeric(Left(cNRek, 1)) Then
            ' gewoon bank rekening nummer
                If Not IsNumeric(Right(cNRek, Len(cNRek) - 1)) Then
                    chNRek = False
                    Exit Function
                End If
                If Len(cNRek) <> 9 And Len(cNRek) <> 10 Then
                    chNRek = False
                    Exit Function
                End If
                If Not isElfP(cNRek) Then
                    chNRek = False
                    Exit Function
                End If
                chNRek = True
        Else
            ' Postbank rekening nummer
                If LCase(Left(cNRek, 1)) <> "p" Then
                    cNRek = False
                    Exit Function
                End If
                If Not IsNumeric(Right(cNRek, Len(cNRek) - 1)) Then
                    chNRek = False
                    Exit Function
                End If
                If Len(cNRek) < 2 Or Len(cNRek) > 8 Then
                    chNRek = False
                    Exit Function
                End If
                If LCase(cNRek) = "p3102" Then
                    chNRek = False
                    Exit Function
                End If
                chNRek = True
        End If
	End Function

	Function isElfP(cRek) 
	    Dim som 
	    Dim i 
	    som = 0
	    i = 0
	    For i = 1 To Len(cRek)
	        som = som + CInt(Mid(cRek, i, 1)) * (Len(cRek) - i + 1)
	    Next
	    If som Mod 11 = 0 Then
	        isElfP = True
	    Else
	        isElfP = False
	    End If
	End Function
%>