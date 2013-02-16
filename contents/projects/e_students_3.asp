<!-- #include file="../../templates/headers/content.asp" -->
<!-- #include file="functions.asp" -->
<%
	dim recordid, rs, sql, tablename
	
	viewstate = viewstate_value("viewstate")
	recordid  = viewstate_value("id")
	tablename = "studenten"
		
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
		recordid = rs.fields("id")		
		viewstate = "view"
		'response.Redirect viewstate_value("REFURL")
	end if
	
	if viewstate="edit" then viewstate = "save"
	if viewstate="new" then viewstate = "savenew"
	
	function save_rs(rs)
		with rs
			
		end with
		sec_setsecurityinfo rs 
		putrecordset rs 
	end function

	'Hier wordt de titel van het formulier bepaalt
	students_header(rs.fields("id"))
%>
<div class=rolodex>
    <a href="e_toetsresultaat.asp?viewstate=new&id=-1&students_id=<%=recordid %>&toetsen_type=hf"><%=getlabel("new") %></a>
</div>
<%
	sql = "select * from vw_students_results where toetsen_type='hf' and studenten_id =" & recordid 	
	dim fieldlist, orderby
	fields = ""
	fields = fields & "$name:=id;type:=hidden;$"
	fields = fields & "$name:=studenten_id;type:=hidden;$"
	fields = fields & "$name:=toetsdatum;type:=hidden;$"
	fields = fields & "$name:=toetsen_type;type:=hidden;$"
	fields = fields & "$name:=tests_id;type:=hidden;$"
	fields = fields & "$name:=codetot;type:=link;url:=e_toetsresultaat.asp?viewstate=edit&id=~id~&toetsen_type=hf&students_id=~studenten_id~;$"
	orderby = "toetsdatum"
	r_list sql, fields, orderby
%>
</form> 
<!-- #include file="../../templates/footers/content.asp" -->
