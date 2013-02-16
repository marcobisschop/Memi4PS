<!-- #include file="../../templates/headers/content.asp" -->
<!-- #include file="functions.asp" -->
<%
	dim recordid, rs, sql, tablename
	
	viewstate = viewstate_value("viewstate")
	recordid  = viewstate_value("id")
	tablename = "distinctives_links"
		
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
			if errorcount = 0 then 
					viewstate = "update"
			end if
		end if		
	end if
	
	if viewstate = "update" then 
		save_rs rs
		inreto = "relations"
		inreto_id = recordid
		distinctives_id = viewstate_value("distinctives_id")
		'response.write "!! TOONT NOG MAAR 1 WAARDE !! ids:" & distinctives_id
		distinctives_save inreto, inreto_id, distinctives_id
		viewstate = "view"
	end if
	
	if viewstate="edit" then viewstate = "save"
	if viewstate="new" then viewstate = "savenew"
	
	function save_rs(rs)
		with rs
			
		end with
		'sec_setsecurityinfo rs 
		putrecordset rs 
	end function

	'Hier wordt de titel van het formulier bepaalt
	relations_header(recordid)
	f_form_hdr()
    listdistinctives "relations"
	f_form_ftr()
%>
</form> 
<!-- #include file="../../templates/footers/content.asp" -->
