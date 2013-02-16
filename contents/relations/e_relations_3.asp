<!-- #include file="../../templates/headers/content.asp" -->
<!-- #include file="functions.asp" -->
<%
	dim recordid, rs, sql, tablename
	
	viewstate = viewstate_value("viewstate")
	recordid  = viewstate_value("id")
	tablename = "relations"
		
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
			if not v_valid("^\w+",true,fieldvalue(rs,"name")) then v_addformerror "name"
			if not v_valid("^\w+",true,fieldvalue(rs,"address")) then v_addformerror "address"
			if not v_valid("^\w+",true,fieldvalue(rs,"zipcode")) then v_addformerror "zipcode"
			if not v_valid("^\w+",true,fieldvalue(rs,"city")) then v_addformerror "city"
			if not v_valid("^\w+",true,fieldvalue(rs,"phone1")) then v_addformerror "phone1"
			if not v_valid("^\w+",false,fieldvalue(rs,"fax1")) then v_addformerror "fax1"
			if not v_valid("^\w+",true,fieldvalue(rs,"email")) then v_addformerror "email"
			if not v_valid("^\w+",true,fieldvalue(rs,"relations_type")) then v_addformerror "relations_type"
	
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
			.fields("name") = fieldvalue(rs,"name")
			.fields("address") = fieldvalue(rs,"address")
			.fields("zipcode") = fieldvalue(rs,"zipcode")
			.fields("city") = fieldvalue(rs,"city")
			.fields("phone1") = fieldvalue(rs,"phone1")
			.fields("fax1") = fieldvalue(rs,"fax1")
			.fields("email") = fieldvalue(rs,"email")
			.fields("relations_type") = fieldvalue(rs,"relations_type")
			
			
			
		end with
		sec_setsecurityinfo rs 
		putrecordset rs 
	end function

	'Hier wordt de titel van het formulier bepaalt
	relations_header (recordid)	
	f_form_hdr()
%>
<table style="" cellpadding="0" cellspacing="0" ID="Table1">
	<tr>
		<td valign="top">
			<table style="" ID="Table2">
				<%
					f_textbox rs,"relations_name","name","300"
					f_textbox rs,"address","address","300"
					f_textbox rs,"zipcode","zipcode","100"
					f_textbox rs,"city","city","300"
					f_textbox rs,"phone1","phone1","150"
					f_textbox rs,"fax1","fax1","150"
					f_emailbox rs,"email","email","300"
					f_listbox rs,"relations_type","relations_type","select name,value from variables where [group]='relations_type' order by name","value","name",300,""
					f_textbox rs,"id","id",200
            f_textbox rs,"created","created",200
            f_textbox rs,"createdby","createdby",200
            f_textbox rs,"edited","edited",200
            f_textbox rs,"editedby","editedby",200
            f_textbox rs,"relations_type","relations_type",200
            f_textbox rs,"number","number",200
            f_textbox rs,"name","name",200
            f_textbox rs,"address","address",200
            f_textbox rs,"housenr","housenr",200
            f_textbox rs,"zipcode","zipcode",200
            f_textbox rs,"city","city",200
            f_textbox rs,"country","country",200
            f_textbox rs,"bezoek_str","bezoek_str",200
            f_textbox rs,"phone1","phone1",200
            f_textbox rs,"fax1","fax1",200
            f_textbox rs,"email","email",200
            f_textbox rs,"branche","branche",200
            f_textbox rs,"department","department",200
            f_textbox rs,"pc_plaats","pc_plaats",200
            f_textbox rs,"post_huisn","post_huisn",200
            f_textbox rs,"post_kix","post_kix",200
            f_textbox rs,"post_landc","post_landc",200
            f_textbox rs,"post_plaat","post_plaat",200
            f_textbox rs,"post_postc","post_postc",200
            f_textbox rs,"post_straa","post_straa",200
            f_textbox rs,"phone2","phone2",200
            f_textbox rs,"phone3","phone3",200
            f_textbox rs,"toevhuisnr","toevhuisnr",200
            f_textbox rs,"zoeknaam","zoeknaam",200
            f_textbox rs,"zoekplaats","zoekplaats",200
            f_textbox rs,"internet_a","internet_a",200

            f_textbox rs,"setnr","setnr",200
            f_textbox rs,"memo_algem","memo_algem",200
            f_textbox rs,"memo_codes","memo_codes",200
            f_textbox rs,"taalnummer","taalnummer",200
            f_textbox rs,"adres","adres",200
            f_textbox rs,"soort_rela","soort_rela",200
            f_textbox rs,"land","land",200
			
				%>
			</table>
		</td>
	</tr>
</table>
<%
	f_form_ftr()
%>
</form> 
<!-- #include file="../../templates/footers/content.asp" -->
