<!-- #INCLUDE FILE="HEADER.ASP" -->
<% 
    ' response.Write "hier"
    ' response.end
	function note_report (subject, inreto, inreto_id)
		dim sql
		sql = "insert into notes (inreto,inreto_id,subject,createdby,editedby,body) values ('" & inreto & "'," & inreto_id & ",'" & subject & "'," & SEC_CURRENTUSERID() & "," & SEC_CURRENTUSERID() & ",'')"
		' executesql sql
	end function

	dim verbosemode
	if len(viewstate_value("verbosemode")) > 0 then
		verbosemode = true
	else
		verbosemode = false
	end if

	dim RTFheader			
	dim RTFcontent
	dim RTFfooter
	
	dim reportname
	dim reportsource		' SQL datasource templates
	dim reportrs

	dim pageindex			' page cpounter
		
	dim FieldCollection 
	
	dim templaters
	dim templateid
	
	templateid = session("templateid")
	if len(templateid)=0 then templateid=viewstate_value("templateid")
	
	dim inreto,inreto_id
	inreto = viewstate_value("inreto")
	inreto_id = viewstate_value("inreto_id")
	
	dim relati_id
	relati_id = viewstate_value("relations_id")
	
	set templaters = getrecordset("select * from correspondence where id =" & TemplateId,true)
	with templaters
		reportname  	= .fields("name") & ".rtf"
		RTFheader	= .fields("rtfheader")
		RTFcontent	= .fields("rtfbody")
		RTFfooter	= .fields("rtffooter")
	end with
			
	reportsource = session("reportsource")
	
	' init
	set FieldCollection = CreateObject("Scripting.Dictionary")

    
	if VERBOSEMODE then %>
	<html>
		<head>
		<title>Template</title>
		<link type="text/css" rel="stylesheet" href="style.css">
		</head>
		<body>
<%	else
		' ----------------------------------------------------------
		' Flush RTF header to client
		' ----------------------------------------------------------
		Response.Clear 
		Response.AddHeader "Content-Disposition", "attachment; filename=" & reportname
		Response.Charset = "UTF-8"
		Response.ContentType = "application/msword"
		response.Write RTFheader
		'response.Write "/par"
		'response.Write reportsource
		'response.Write "/par"
	end if

	' ----------------------------------------------------------
	' loop thru recordset and create each page
	' ----------------------------------------------------------
	set reportrs = getrecordset(reportsource,true)
	'verbosemode=true
	if verbosemode then %>
		<b>De volgende velden zijn beschikbaar :</b><br>
		<TABLE width="50%" ID="Table1" width=100%>
<%		AddFieldsToCollection reportrs, FieldCollection
		for each templatefield in FieldCollection %>
			<tr>
				<td width=40% bgcolor=#f0f0f0>#<%=templatefield%>#</td><td><%=FieldCollection(templatefield)%></td>
			</tr>
<%		next %>
		</table><br>
		<br><b>De volgende velden zijn gevonden in het template :</b><br>
<%	 verboseFields FieldCollection, RTFcontent
	else
		' merge RTF stuff
		pageindex = 0
		do while not reportrs.eof
			AddFieldsToCollection reportrs, FieldCollection
			if pageindex > 0 then
				response.Write "\page"
			end if
			' Write parsed content to client
			response.Write ParseFields (FieldCollection, RTFcontent)
			' Start new page
			
			reportrs.movenext
			pageindex = pageindex + 1
		loop
	end if
	
	
	if verbosemode then %>
		</body>
		</html> 
<%	else
		' ----------------------------------------------------------
		' Flush RTF footer to client
		' ----------------------------------------------------------
		response.Write RTFfooter
		Response.Flush 
		note_report reportname, inreto, inreto_id
		'response.Redirect "correspondence_view.asp?label=Correspondentie&inreto=" & inreto & "&inreto_id=" & inreto_id
	end if
	
	
	sub AddFieldsToCollection(byref rs, byref col)
		
		Dim field
		Dim fieldName
		Dim fieldValue
	
		col.RemoveAll 	
		
		' add fields found in recordset to collection
		for each field in rs.fields
			fieldname	= ucase(field.name)
			fieldvalue	= field			
			IF FIELD.TYPE = 61 THEN
				FILEVALUE = RIGHT("00" & DAY(FIELD,2)) & "-" & RIGHT("00" & MONTH(FIELD,2)) & "-" & YEAR(FIELD)
			END IF			
			col.add fieldname, fieldvalue			
			' start debug code
			if 1=0 then
				response.Write "<TR><TD>"
				response.Write fieldname
				response.Write "</TD><TD>"
				response.Write fieldvalue
				response.Write "</TD><TR>"
			end if
			' end debug code
		next
		Dim extrafieldRs
		' add special fields to collection
		set extrafieldRs = getrecordset("select field, value from correspondence_fields",true)
		do while not extrafieldRs.eof
			fieldname	= extrafieldRs.fields("field")
			fieldvalue	= extrafieldRs.fields("value")
			 if not col.exists(extrafieldRs.fields("field")) then
			 	col.add fieldname, fieldvalue
			 end if
			extrafieldRs.movenext
		loop
		' Is er een relatie gekozen voor de brief
		if len(relati_id)>0 then
			'on error resume next
			dim relFields
			set relFields = getrecordset("select * from vw_relations where id=" & relati_id,true)
			with relFields
				if not .eof then
					DIM FLD
					for each fld in .fields
						if not col.exists(TRIM(FLD.NAME)) then
			 				col.add TRIM(FLD.NAME), TRIM(FLD.VALUE)
			 				'response.Write "FOUND : " & FLD.NAME & " = " & FLD.VALUE & "<BR>"							
						end if		
					next
				end if
			end with
			set relFields = nothing
			
		end if
		'col.add "SEC_NAAMZONDERTITEL", SEC_FULLNAME()
		'col.add "SEC_FULLNAME", SEC_FULLNAME()
	end sub
	
	function verboseFields (byref FieldCollection, RTFcontent)
		dim regexp, match, matches
		dim templatefield
		dim templatevalue		
		set regexp = new regexp
		regexp.Pattern = "#[^#]*#"
		regexp.Global = true
		regexp.IgnoreCase = true
		set matches = regexp.Execute(RTFcontent) %>
<TABLE width=100% ID="Table2">
<%		for each match in matches
			templatefield = match.value
			templatevalue = FieldCollection(mid(templatefield,2,len(templatefield)-2))
			if len(templatevalue) = 0 then
				templatevalue = "<font color=#FF0000><B>waarde is leeg</B></font>"
			end if %>
<TR><TD width=40% bgcolor=#f0f0f0> 
<%			response.Write templatefield
			response.Write "</TD><TD>"
			response.Write templatevalue
			response.Write "</TD></TR>"
		next
		response.Write "</TABLE>"
		set regexp = nothing	
	end function
	
	function ParseFields (byref FieldCollection, RTFcontent)
		dim regexp, match, matches
		dim templatefield
		dim templatevalue
		dim bpid
		dim secuserid
		dim parsedcontent 
		parsedcontent = RTFcontent
		bpid = session("bpid")
		secuserid=session("userid")
		set regexp = new regexp
		regexp.Pattern = "#[^#]*#"
		regexp.Global = true
		regexp.IgnoreCase = true
		set matches = regexp.Execute(RTFcontent)
		for each match in matches
				templatefield = match.value
				templatefield2 = trim(ucase(mid(match.value,2,len(match.value)-2)))
				templatevalue = ""
				
				if instr(1,templatefield2,";") > 0 then
				    
					templateA = split(templatefield2,";")
					templatefield2 = trim(templateA(0))
					templateformat= trim(ucase(templateA(1)))
					
				else 
					templateformat= "NOFORMAT"
				end if
				
				select case ucase(templatefield2)
					case "DATE_NOW"
						templatevalue=NOW()
					case "SEC_NAAMZONDERTITEL"
						templatevalue=SEC_FULLNAME()
					case "SEC_FULLNAME"
						templatevalue=SEC_FULLNAME()
					case "TEST_OVERVIEW_HF"
					    sql = "select * from vw_students_results_correspondence where type='HF' and studenten_id=" & Trim(FieldCollection("ID")) & " order by blok,omschrijving"
					    templatevalue = Studieresultaat(SQL)
					case "TEST_OVERVIEW_P"
					    sql = "select * from vw_students_results_correspondence where type='P' and studenten_id=" & Trim(FieldCollection("ID")) & " order by blok,omschrijving"
					    templatevalue = Studieresultaat(SQL)
					case else
						templatevalue = Trim(FieldCollection(templatefield2))
				end select
				
				on error resume next
				if isnull(templatevalue)=false and len(templatevalue)>0 then				
					select case ucase(templateformat)
						case "S"
							templatevalue = cdate(templatevalue)
							TEMPLATEVALUE = RIGHT("00" & DAY(TEMPLATEVALUE),2) & "-" & _
											RIGHT("00" & MONTH(TEMPLATEVALUE),2) & "-" & _
											YEAR(TEMPLATEVALUE)
								
						CASE "L"
							strMonths = "januari,februari,maart,april,mei,juni,juli,augustus,september,oktober,november,december"
							MONTHS = split(strMonths,",")
							Templatevalue = cdate(templatevalue)
							TEMPLATEVALUE = RIGHT("00" & DAY(TEMPLATEVALUE),2) & " " & _
											months(MONTH(TEMPLATEVALUE)-1) & " " & _
											YEAR(TEMPLATEVALUE)
							TEMPLATEVALUE = DAY(TEMPLATEVALUE) & " " & _
											months(MONTH(TEMPLATEVALUE)-1) & " " & _
											YEAR(TEMPLATEVALUE)
							'templatevalue = "langedatum"
						CASE "HFDLTR"
							templatevalue=ucase(left(templatevalue,1)) & right(templatevalue,len(templatevalue)-1)			
						CASE "EURO"
						CASE "GETAL"
							placeKomma= instr(1,templatevalue,",")
							if placekomma=0 then
								templatevalue=templatevalue & ",00"
							elseif placekomma=len(templatevalue)-1 then
								templatevalue=templatevalue & "0"
							elseif placekomma>len(templatevalue)-2 then
								templatevalue=left(templatevalue,placekomma+2)	
							end if
						CASE "BEDRAG"
							placeKomma= instr(1,templatevalue,",")
							if placekomma=0 then
								templatevalue=templatevalue & ",00"
							elseif placekomma=len(templatevalue)-1 then
								templatevalue=templatevalue & "0"
							elseif placekomma>len(templatevalue)-2 then
								templatevalue=left(templatevalue,placekomma+2)	
							end if
						case "NOFORMAT"
							'niets doen, format wordt niet gebruikt
						case else
							'templateformat niet bepaald in code. of typefout in document RTF
							templatevalue = templatefield & "\b << FORMAT NIET BEKEND :----" & templateformat & "----\b0"
					end select
				end if	
				if err.number <> 0 then
					templatevalue = "\par\par HUIDIGE WAARDE: " & templatevalue & "\par\par"
					templatevalue = templatevalue & "\par FOUT: #" & templatefield & "# : FORMAAT BEPALEN NIET GELUKT \par \par \b vb error: "	
					TEMPLATEVALUE = TEMPLATEVALUE & ERR.Description & "\b0\par\par"	
				else
					'templatevalue = templatevalue & "OK"		
				end if
				'on error goto 0
				
				'templatefield2 = "#" & templatefield2 & "#"
				if isnull(templatevalue)=false and len(templatevalue)>0 then				
					parsedcontent = replace (parsedcontent, templatefield, templatevalue)
				else 'vervangen veld in document door lege waarde
					parsedcontent = replace (parsedcontent, templatefield, "")
				end if					
				' start debug code
				if 1=0 then
					response.Write "\par <BR>templatefield : " & templatefield
					response.Write "\par <br>, Value from collection  : " & templatevalue
				end if
				' end debug code
		next
		
		'RTF = "\par\par"
		'FOR EACH F IN FieldCollection
		
		'	RTF = RTF & "\par " & F & " = " & FieldCollection(F)
			
		'NEXT
		
'		RTF = "\par \par{\lang1033\langfe1043\langnp1033\insrsid15493117 \tab 11111,0000}"
		
		set regexp = nothing	
		ParseFields = parsedcontent & RTF
	end function 
	
	Function zeggedef20(getal)
		select case round(getal,0)
			case 1 
				zeggedef20="één"
			case 2 
				zeggedef20="twee"
			case 3
				zeggedef20="drie"
			case 4
				zeggedef20="vier"
			case 5
				zeggedef20="vijf"
			case 6
				zeggedef20="zes"
			case 7
				zeggedef20="zeven"
			case 8
				zeggedef20="acht"
			case 9
				zeggedef20="negen"
			case 10
				zeggedef20="tien"
			case 11
				zeggedef20="elf"
			case 12
				zeggedef20="twaalf"
			case 13
				zeggedef20="dertien"
			case 14
				zeggedef20="veertien"
			case 15
				zeggedef20="vijftien"
			case 16
				zeggedef20="zestien"
			case 17
				zeggedef20="zeventien"
			case 18
				zeggedef20="achttien"
			case 19
				zeggedef20="negentien"
			case 20
				zeggedef20="twintig"
			case else
				zeggedef20="****" & getal
		end select
	end function		

	function zeggedef100(getal) 
		dim tempzeg
		if getal >= 1 and getal <= 20 then
				tempzeg=zeggedef20(getal)
		elseif getal >= 21 and getal < 30 then 
				tempzeg=zeggedef20(getal-20) & "entwintig"	

		elseif getal= 30 then
				tempzeg="dertig"
		elseif getal >= 31 and getal < 40 then 
				tempzeg=zeggedef20(getal-30) & "endertig"	
		elseif getal= 40 then
				tempzeg="veertig"
		elseif getal >= 41 and getal <50 then
				tempzeg=zeggedef20(getal-40) & "enveertig"	
		elseif getal= 50 then
				tempzeg="vijftig"
		elseif getal >= 51 and getal < 60 then
				tempzeg=zeggedef20(getal-50) & "envijftig"	
		elseif getal= 60 then
				tempzeg="zestig"
		elseif getal >= 61 and getal < 70 then
				tempzeg=zeggedef20(getal-60) & "enzestig"	
		elseif getal= 70 then
				tempzeg="zeventig"
		elseif getal >= 71 and getal < 80 then 
				tempzeg=zeggedef20(getal-70) & "enzeventig"	
		elseif getal= 80 then
				tempzeg="tachtig"
		elseif getal >= 81 and getal < 90 then
				tempzeg=zeggedef20(getal-80) & "entachtig"	
		elseif getal= 90 then
				tempzeg="negentig"
		elseif getal >= 91 and getal < 100 then
				tempzeg=zeggedef20(getal-90) & "ennegentig"	
		end if
		if instr (1,tempzeg,"tweeen")> 0 then
			zeggedef100=replace (tempzeg,"tweeen","tweeën",1)
		elseif instr (1,tempzeg,"drieen")> 0 then
			zeggedef100=replace (tempzeg,"drieen","drieën",1)
		else
			zeggedef100=tempzeg
		end if
	end function

	function zeggedef1(getal,mode)
		dim getaltemp,zeggedef

		if getal > 100000 then
			zeggedef=" bedrag > 100000!"
		else
			getaltemp=getal
	'		zeggedef=""
			if getaltemp > 1000 then
				zeggedef=zeggedef100(int(getaltemp/1000)) & "duizend"
				getaltemp=getaltemp-int(getaltemp/1000)*1000
			end if		
			if getaltemp>=100 then
				zeggedef=zeggedef & zeggedef100(int(getaltemp/100)) & "honderd"
				getaltemp=getaltemp-int(getaltemp/100)*100
			end if		
			if getaltemp > 1 then
				zeggedef=zeggedef & zeggedef100(int(getaltemp)) & " euro"
				getaltemp=getaltemp-int(getaltemp)
			elseif getal < 1 then
				zeggedef=" nul euro"
			else
				zeggedef=zeggedef & " euro"
			end if		

			if getal < 1 then
				zeggedef="nul euro en " & zeggedef100(getaltemp*100) & " cent"
			elseif getaltemp > 0 then
				zeggedef=zeggedef & " en " & zeggedef100(Int(getaltemp * 100 + 0.5)) & " cent"
			end if		
		end if
	'end if
	zeggedef1=zeggedef

	end function
	
	Function RTF_BuildTable(mySQL, HiddenFields)
        Dim myRS, myTable 
        set myRS = getrecordset(mySQL, true)

        ' Load NumCells variable to write table 
        ' row properties
        For Each column in myRS.Fields
            If not instr(1,HiddenField,column.name) Then NumCells = NumCells + 1
        Next
        'NumCells = myRs.Fields.Count
          
        ' load NumRows variable to set up table 
        ' contents loop for recordset
        NumRows = myRS.RecordCount
          
        ' populate header row
        myTable = myTable & "\trowd\trautofit1\intbl"
          
        j = 1
        For i = 1 To NumCells
          myTable = myTable & "\cellx" & j
          j = j + 1
        Next
          
        myTable = myTable & "{"
          
        ' loop thru and write the column name from the db
        For Each column In myRS.Fields
          If not instr(1,HiddenField,column.name) Then myTable = myTable & column.name & "\cell "
        Next
          
        myTable = myTable & "}"
          
        myTable = myTable & "{"
        myTable = myTable & "\trowd\trautofit1\intbl"
          
        j = 1
        For i = 1 To NumCells
          myTable = myTable & "\cellx" & j
          j = j + 1
        Next
        myTable = myTable & "\row }"
          
        ' write table contents
        For k = 1 To NumRows
          myTable = myTable & "\trowd\trautofit1\intbl"
          j = 1
          For i = 1 To NumCells
             myTable = myTable & "\cellx" & j
             j = j + 1
          Next
          myTable = myTable & "{"
                
          For Each column In myRS.Fields
             If not instr(1,HiddenField,column.name) Then myTable = myTable & column & "\cell "
          Next
                
          myTable = myTable & "}"
                
          myTable = myTable & "{"
          myTable = myTable & "\trowd\trautofit1\intbl"
          j = 1
          For i = 1 To NumCells
             myTable = myTable & "\cellx" & j
             j = j + 1
          Next
          myTable = myTable & "\row }"   
          myRS.MoveNext
        Next      
        
        myTable = myTable & "\par "
        
        set myRS = Nothing
        RTF_BuildTable = myTable
    End Function
	
	Function StudieResultaat(SQL)
	    on error goto 0
	    Dim TableRTF, rs, TableRow
	    
	    TableRow = "\cellx0\cellx6000\cellx7200\cellx8200\cellx9200\cellx10200"
	    
	    set rs = getrecordset(sql,true)
		tableRTF = tableRTF & "{"
		tableRTF = tableRTF & "\par\par"
		tableRTF = tableRTF & "\trowd\trhdr\trgaph30\trleft0\trrh262\trautofit1"
		tableRTF = tableRTF & TableRow
		tableRTF = tableRTF & "\pard\intbl\ql {\b Blok} \cell"
		tableRTF = tableRTF & "\pard\intbl\ql {\b Omschrijving} \cell"
		tableRTF = tableRTF & "\pard\intbl\ql {\b Her} \cell"
		tableRTF = tableRTF & "\pard\intbl\qr {\b Resultaat} \cell"
		tableRTF = tableRTF & "\pard\intbl\qr {\b EC} \cell"
		tableRTF = tableRTF & "\pard\intbl\qr {\b Totaal EC} \cell"
		tableRTF = tableRTF & "\pard\intbl\row"
        
        Dim blockScore, blockName, totalScore
        blockName = ""
        blockScore = 0
        totalScore = 0
        
        With rs
		    Do until .eof
		        if blockName <> .fields("blok") then
		            blockName = .fields("blok")
		            blockScore = 0
		        end if
		        blockScore = blockScore + .fields("beh.ects")
		        totalScore = totalScore + .fields("beh.ects") 
		        
			    tableRTF = tableRTF & "\trowd\trgaph30\trleft0\trrh262"
			    tableRTF = tableRTF & TableRow
		        tableRTF = tableRTF & "\pard\intbl\ql " & .fields("blok") & "\cell"
			    tableRTF = tableRTF & "\pard\intbl\ql " & .fields("omschrijving") & "\cell"
			    tableRTF = tableRTF & "\pard\intbl\ql " & .fields("hertoets") & "\cell"
			    tableRTF = tableRTF & "\pard\intbl\qr " & .fields("resultaat") & "\cell"
			    tableRTF = tableRTF & "\pard\intbl\qr " & .fields("beh.ects") & "\cell"
			    tableRTF = tableRTF & "\pard\intbl\qr \cell"
			    tableRTF = tableRTF & "\pard\intbl\row"
			    .movenext
			    if not .eof then
			        if blockName <> .fields("blok") then
		                tableRTF = tableRTF & "\trowd\trgaph30\trleft0\trrh262"
			            tableRTF = tableRTF & TableRow
		                tableRTF = tableRTF & "\pard\intbl\ql " & "" & "\cell"
			            tableRTF = tableRTF & "\pard\intbl\ql " & "" & "\cell"
			            tableRTF = tableRTF & "\pard\intbl\ql " & "" & "\cell"
			            tableRTF = tableRTF & "\pard\intbl\ql " & "" & "\cell"
			            tableRTF = tableRTF & "\pard\intbl\ql " & "" & "\cell"
			            tableRTF = tableRTF & "\pard\intbl\qr {\b " & blockScore & "}\cell"
			            tableRTF = tableRTF & "\pard\intbl\row"
		            end if
			    else
			            tableRTF = tableRTF & "\trowd\trgaph30\trleft0\trrh262"
			            tableRTF = tableRTF & TableRow
		                tableRTF = tableRTF & "\pard\intbl\ql " & "" & "\cell"
			            tableRTF = tableRTF & "\pard\intbl\ql " & "" & "\cell"
			            tableRTF = tableRTF & "\pard\intbl\ql " & "" & "\cell"
			            tableRTF = tableRTF & "\pard\intbl\ql " & "" & "\cell"
			            tableRTF = tableRTF & "\pard\intbl\ql " & "" & "\cell"
			            tableRTF = tableRTF & "\pard\intbl\qr {\b " & blockScore & "}\cell"
			            tableRTF = tableRTF & "\pard\intbl\row"
			            
			            tableRTF = tableRTF & "\trowd\trgaph30\trleft0\trrh262"
			            tableRTF = tableRTF & TableRow
		                tableRTF = tableRTF & "\pard\intbl\ql " & "" & "\cell"
			            tableRTF = tableRTF & "\pard\intbl\ql " & "{\b Totaal aantal EC}" & "\cell"
			            tableRTF = tableRTF & "\pard\intbl\ql " & "" & "\cell"
			            tableRTF = tableRTF & "\pard\intbl\ql " & "" & "\cell"
			            tableRTF = tableRTF & "\pard\intbl\ql " & "" & "\cell"
			            tableRTF = tableRTF & "\pard\intbl\qr {\b " & totalScore & "}\cell"
			            tableRTF = tableRTF & "\pard\intbl\row"
			    end if			    
		    loop
		end with
		tableRTF = tableRTF & "}"
		set rs = nothing
		Studieresultaat = TableRTF
	End Function
	
%>