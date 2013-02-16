<!-- #include file="../../templates/headers/content.asp" -->
<!-- #include file="functions.asp" -->
<%
	dim recordid, rs, sql, tablename
	
	viewstate = viewstate_value("viewstate")
	recordid  = viewstate_value("id")
	students_id  = viewstate_value("students_id")
	toetsen_type = viewstate_value("toetsen_type")
	tablename = "toetsresultaten"
		
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
		rs.fields("studenten_id") = students_id
		sec_setsecurityinfo (rs)
	case else
		response.Write "invalid viewstate !!"
		response.end
	end select
	
	if viewstate = "save" or viewstate = "savenew" then	
		if ispostback() then
		    if not v_valid("^\d+$",true,fieldvalue(rs,"toetsen_id")) then v_addformerror "toetsen_id"
			'if not v_isdate(true,convertdate(fieldvalue(rs,"toetsdatum"))) then v_addformerror "toetsdatum"
			if not v_valid("^\d+$",true,fieldvalue(rs,"behaaldres")) then v_addformerror "behaaldres"			
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
			.fields("toetsen_id") = fieldvalue(rs,"toetsen_id")
			'.fields("toetsdatum") = convertdate(fieldvalue(rs,"toetsdatum"))
			.fields("behaaldres") = fieldvalue(rs,"behaaldres")
			
			sql = "select * from toetsen where id=" & fieldvalue(rs,"toetsen_id")
			'response.Write sql
			set rsT = getrecordset(sql, true)
			
			sql = "select * from toetsen_resultaten where id=" & .fields("behaaldres")
			'response.Write sql
			set rsR = getrecordset(sql, true)
		    if not rsR.eof then
		        if cbool(rsR.fields("passed")) then
		            rs.fields("behects") = cint(rsT.fields("maxects"))
		        else
		            rs.fields("behects") = 0
		        end if
		    end if
			set rsR = nothing
			set rsT = nothing
			
		end with
		sec_setsecurityinfo rs 
		putrecordset rs 
	end function

	'Hier wordt de titel van het formulier bepaalt
	students_header(students_id)

%>
<div class=rolodex>
    <a href="e_toetsresultaat.asp?viewstate=new&id=-1&students_id=<%=recordid %>"><%=getlabel("new") %></a>
</div>
<%
    f_form_hdr()
    f_hidden "students_id"
    f_hidden "toetsen_type"
%>
<table style="" cellpadding="0" cellspacing="0" ID="Table1">
    <tr>
		<td valign="top">
			<table style="" ID="Table2">
				<%
				    sql = "select id,codetot from toetsen where toetsen_type='" & toetsen_type & "' order by codetot"
				    f_listbox rs,"tests_name","toetsen_id",sql,"id","codetot",200,""
                   ' f_datebox rs,"toetsdatum", "toetsdatum",120
                    f_listbox rs,"behaaldres","behaaldres","select id,name from toetsen_resultaten order by name","id","name",120,""
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
