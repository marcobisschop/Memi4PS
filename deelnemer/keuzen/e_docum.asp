<!-- #include file="../../templates/headers/content.asp" -->
<!-- #include file="functions.asp" -->
<%
	dim recordid, rs, sql, tablename
	
	viewstate = viewstate_value("viewstate")
	myLetter = viewstate_value("myLetter")
	page = viewstate_value("page")
	recordid  = viewstate_value("id")
	tablename = "keuzen"
	
	select case lcase(viewstate)
	case "view"
		sql = "select * from [" & tablename & "] where id = " & recordid
		set rs = getrecordset(sql,false)
	case "edit","save"
		sql = "select * from [" & tablename & "] where id = " & recordid
		set rs = getrecordset(sql,false)
	case "new","savenew"
		sql = "select * from [" & tablename & "] where id = -1"
		set rs = getrecordset(sql,false)
		rs.addnew
		sec_setsecurityinfo (rs)
	case else
		response.Write "invalid viewstate !!"
		response.end
	end select
	
	if viewstate = "save" or viewstate = "savenew" then	
		if ispostback() then
			if not v_valid("^\w+$",true,fieldvalue(rs,"keunaa")) then v_addformerror "keunaa"
			if not v_valid(isvalidcurrency,true,fieldvalue(rs,"prikop")) then v_addformerror "prikop"
			if not v_valid("\d+$",true,fieldvalue(rs,"keucat_id")) then v_addformerror "keucat_id"
			if not v_valid("\d+$",true,fieldvalue(rs,"keuafd_id")) then v_addformerror "keuafd_id"
			if errorcount = 0 then 
					viewstate = "update"
			end if
		end if		
	end if
	
	if viewstate = "update" then 
		save_rs rs
		recordid = rs.fields("id")		
		viewstate = "view"
		response.Redirect viewstate_value("REFURL")
	end if
	
	if viewstate="edit" then viewstate = "save"
	if viewstate="new" then viewstate = "savenew"
	
	function save_rs(rs)
		with rs
			'.fields("keucod") = fieldvalue(rs,"keucod")
			'.fields("keunaa") = fieldvalue(rs,"keucod")
			'.fields("altcod") = fieldvalue(rs,"altcod")
			'.fields("keubes") = fieldvalue(rs,"keubes")
			'.fields("prikop") = convertvalue(fieldvalue(rs,"prikop"))
			'.fields("voltek") = checkboxvalue(fieldvalue(rs,"voltek"))
			'.fields("keucat_id") = fieldvalue(rs,"keucat_id")
			'.fields("keuafd_id") = fieldvalue(rs,"keuafd_id")
			'.fields("slucat_id") = fieldvalue(rs,"slucat_id")
			'.fields("defini") = checkboxvalue(fieldvalue(rs,"defini"))
			'.fields("control") = checkboxvalue(fieldvalue(rs,"control"))
			'.fields("afrond") = checkboxvalue(fieldvalue(rs,"afrond"))
			'.fields("natebe") = checkboxvalue(fieldvalue(rs,"natebe"))
			'.fields("voorstel") = checkboxvalue(fieldvalue(rs,"voorstel"))
			'.fields("locked") = checkboxvalue(fieldvalue(rs,"locked"))
			'.fields("aanmin") = fieldvalue(rs,"aanmin")
			'.fields("aanmax") = fieldvalue(rs,"aanmax")
			'.fields("aantal") = fieldvalue(rs,"aantal")
			
		end with
		sec_setsecurityinfo rs 
		putrecordset rs 
	end function
	
	viewstate = "view"
	
	
	keuzen_header recordid
	f_form_hdr()
	f_hidden "page"
%>

Documentatie

<!-- #include file="../../templates/footers/content.asp" -->
