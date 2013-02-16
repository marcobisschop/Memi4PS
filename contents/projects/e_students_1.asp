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
		
		    if not v_isdate(false, fieldvalue(rs,"verlaatopl")) then v_addformerror "verlaatopl"
		    if not v_isdate(false, fieldvalue(rs,"verlopl2")) then v_addformerror "verlopl2"
		    if not v_isdate(false, fieldvalue(rs,"verlopl3")) then v_addformerror "verlopl3"
		    if not v_isdate(false, fieldvalue(rs,"beediging")) then v_addformerror "beediging"
		    if not v_isdate(false, fieldvalue(rs,"uitstroom")) then v_addformerror "uitstroom"
		
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
			.fields("vooropleid") = fieldvalue(rs,"vooropleid")
			.fields("scoresqtes") = fieldvalue(rs,"scoresqtes")
			.fields("percsqtest") = fieldvalue(rs,"percsqtest")
			.fields("sollbrief") = fieldvalue(rs,"sollbrief")
			.fields("cohort") = fieldvalue(rs,"cohort")
			.fields("aanvangopl") = fieldvalue(rs,"aanvangopl")
			.fields("biologie") = fieldvalue(rs,"biologie")
			.fields("scheikunde") = convertdate(fieldvalue(rs,"scheikunde"))
			.fields("propedeuse") = fieldvalue(rs,"propedeuse")
			.fields("doorstroom") = fieldvalue(rs,"doorstroom")
			.fields("doorstroo1") = fieldvalue(rs,"doorstroo1")
			.fields("verlaatopl") = convertdate(fieldvalue(rs,"verlaatopl"))
			.fields("verlaten_j") = checkboxvalue(fieldvalue(rs,"verlaten_j"))
			.fields("verlatenja") = checkboxvalue(fieldvalue(rs,"verlatenja"))
			.fields("verlatenj1") = checkboxvalue(fieldvalue(rs,"verlatenj1"))
			.fields("verlopl2") = convertdate(fieldvalue(rs,"verlopl2"))
			.fields("verlopl3") = convertdate(fieldvalue(rs,"verlopl3"))
			.fields("beediging") = convertdate(fieldvalue(rs,"beediging"))
			.fields("uitstroom") = convertdate(fieldvalue(rs,"uitstroom"))
		end with
		sec_setsecurityinfo rs 
		putrecordset rs 
	end function

	'Hier wordt de titel van het formulier bepaalt
	students_header(rs.fields("id"))
	f_form_hdr()
%>
<table style="" cellpadding="0" cellspacing="0" ID="Table1">
	<tr>
        <td colspan=3>
        	<table style="" ID="Table11">
		        <%
                    f_frm_divider getlabel("hdr_student_doorstroom")
                %>
            </table>
        </td>
    </tr>
    <tr>
		<td valign="top">
			<table style="" ID="Table2">
				<%
	                f_textbox rs,"vooropleid","vooropleid",200
                    f_textbox rs,"scoresqtes","scoresqtes",40
                    f_textbox rs,"percsqtest","percsqtest",40
                    f_textbox rs,"sollbrief","sollbrief",200
                %>
             </table>
        </td>
        <td valign="top">
			<table style="" ID="Table3">
		        <%    
                    f_textbox rs,"cohort","cohort",60
                    f_datebox rs,"aanvangopl","aanvangopl",100
                    f_textbox rs,"biologie","biologie",40
                    f_textbox rs,"scheikunde","scheikunde",40
                %>
             </table>
        </td>    
    </tr>
</table>
<br /><br />
<table style="" cellpadding="0" cellspacing="0" ID="Table5">
    <tr>
        <td colspan=3>
        	<table style="" ID="Table10">
		        <%
                    f_frm_divider getlabel("hdr_student_doorstroom")
                %>
            </table>
        </td>
    </tr>
    <tr>
        <td valign="top">
			<table style="" ID="Table4">
		        <%    
		            f_listbox rs,"propedeuse","propedeuse","select name,value from variables where [group]='doorstroom_propedeuse' order by name","value","name","200",""
                    f_checkbox rs,"verlaten_j","verlaten_j"
                    f_datebox rs,"verlaatopl","verlaatopl",100
                %>
             </table>
        </td>
        <td valign="top">
			<table style="" ID="Table6">
		        <%    
                    f_listbox rs,"doorstroom","doorstroom","select name,value from variables where [group]='doorstroom_23' order by name","value","name","200",""
                    f_checkbox rs,"verlatenja","verlatenja"
                    f_datebox rs,"verlopl2","verlopl2",100
                %>
             </table>
        </td>
        <td valign="top">
			<table style="" ID="Table7">
		        <%    
                    f_listbox rs,"doorstroo1","doorstroo1","select name,value from variables where [group]='doorstroom_34' order by name","value","name","200",""
                    f_checkbox rs,"verlatenj1","verlatenj1"
                    f_datebox rs,"verlopl3","verlopl3",100 
                %>
             </table>
        </td>
    </tr>
</table>
<br /><br />
<table style="" cellpadding="0" cellspacing="0" ID="Table9">
    <tr>
        <td valign="top">
			<table style="" ID="Table8">
		        <%    
				    f_frm_divider getlabel("hdr_student_uitstroom")
                    f_datebox rs,"beediging","beediging",200
                    f_datebox rs,"uitstroom","uitstroom",200                   
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
