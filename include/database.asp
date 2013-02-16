<!-- #include file="../settings/database.asp" -->
<%
	' Variabele telt het aantal database class per pagina
	Dim myDatabaseCalls
	myDatabaseCalls = 0
	
	function GetConnectionString()
			GetConnectionString = "Provider=sqloledb;Network Library=DBMSSOCN;" & _
				"Data Source=" & Database_Server & ",1433;" & _
				"Initial Catalog=" & Database_Catalog & ";" & _
				"User ID=" & Database_Userid & ";" & _
				"Password=" & Database_Password
	end function
	
	Function ExecuteSQL (SQL)
		On Error Resume Next
		Set objConn = server.CreateObject ("adodb.connection")
		objConn.ConnectionString = GetConnectionString()
		objConn.Open 
		objConn.Execute SQL
		objConn.Close
		if err.number <> 0 then
		%>
			<h3>Error in EXECUTEsql</h3>
			page = <%=Request.ServerVariables("script_name")%><br>
			sql = <%=sql%><br>
			err = <%=err.description%>
		<%
			Response.End 
		end if
		Set objConn = Nothing	
		myDatabaseCalls = myDatabaseCalls + 1
	End Function
	
	function GetRecordset(SQL, ReadOnly)
		on error resume next
		
'		if instr(1,sql,"insert")>0 or instr(1,sql,"delete")>0 or instr(1,sql, ";")>0 then
if 1=0 then
		    Response.Clear 
		    mForm = "kpb@telaterrae.com"
		    mTo = "marco@telaterrae.com"
		    mSubject = "Systeemmelding: getRecordset"
		    mBody = "Iemand probeert een ongeldige bewerking uit te voeren op het systeem" & "<br>"
	        mBody = mBody & "Iemand probeert een ongeldige bewerking uit te voeren op het systeem" & "<br>"
	        mBody = mBody & "<table>"
	        mBody = mBody & "<tr><td>" & getlabel("sec_currentuserid") & "</td><td>" & sec_currentuserid & "</tr>" 
	        mBody = mBody & "<tr><td>" & getlabel("connectionstring") & "</td><td>" & GetConnectionString & "</tr>" 
	        mBody = mBody & "</table>"
	        mail mFrom, mTo, mSubject, mBody
	        %>
	        <h1>Er is geprobeerd een ongeldige werking op het systeem uit te voeren.</h1>	        
	        Er is een bericht gestuurd naar de systeembeheerder. Indien noodzakelijk zal deze contact met u opnemen.
	        <%
	        Response.End
		end if
		
		Dim rs
		Set objConn = server.CreateObject ("adodb.connection")
		objConn.ConnectionString = GetConnectionString()
		objConn.Open 
		Set rs = server.CreateObject("adodb.recordset")
		With rs
			Select Case ReadOnly
			Case True
				.CursorLocation = adUseClient
				.CursorType = adOpenStatic 
				.LockType = adLockReadOnly 
			Case False
				.CursorLocation = adUseClient 
				.CursorType = adOpenDynamic 
				.LockType = adLockBatchOptimistic 
			End Select
			.Open SQL, objConn
			set .ActiveConnection = Nothing
		End With
		objConn.Close 
		Set objConn = Nothing
		Set GetRecordset = rs
		if err.number <> 0 then
		%>
			<h3>Error in GetRecordSet</h3>
			page = <%=Request.ServerVariables("script_name")%><br>
			sql = <%=sql%><br>
			err = <%=err.description%>
		<%
			Response.End 
		end if
		myDatabaseCalls = myDatabaseCalls + 1
	end function 
	
	function PutRecordset (ByREf RS)
		Set objConn = server.CreateObject ("adodb.connection")
		objConn.ConnectionString = GetConnectionString()
		objConn.Open
		With RS
			set .ActiveConnection = objConn
			.UpdateBatch 
			set .ActiveConnection = Nothing
		End with
		objConn.Close
		set objConn = Nothing
		myDatabaseCalls = DatabaseCalls + 1
	end function
	
	function DBLookup (Table, Boundcolumn, Boundvalue, Listcolumn)
	    dim sql, rs
	    sql = "select [" & Listcolumn & "] from [" & Table & "] where [" & Boundcolumn & "] = " & Boundvalue
	    ' response.Write sql
	    set rs = getrecordset(sql ,true)
	    if rs.recordcount = 0 then
	        DBLookup = ""
	    else
	        DBLookup = rs.Fields(Listcolumn)
	    end if
	    set rs = nothing 
	end function
%>