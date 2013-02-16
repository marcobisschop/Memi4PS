<!-- #include file="../../templates/headers/content.asp" -->
<%
	dim recordid, rs, sql, tablename
	
	viewstate = viewstate_value("viewstate")
	if viewstate="view" then viewstate = "edit"
	
	recordid  = session("bounum_id")
	projec_id  = session("projec_id")
	' boutyp_id  = viewstate_value("boutyp_id")
	tablename = "bounum"
		
	select case lcase(viewstate)
	case "view"
		sql = "select * from [" & tablename & "] where id = " & recordid
		set rs = getrecordset(sql,false)
	case "edit","save"
		sql = "select * from [" & tablename & "] where id = " & recordid
		set rs = getrecordset(sql,false)
	case else
		response.Write "invalid viewstate !!"
		response.end
	end select
	
	if viewstate = "save" or viewstate = "savenew" then	
		if ispostback() then
			if not v_valid("^\d+$",true,fieldvalue(rs,"memi_budget")) then v_addformerror "memi_budget"
			if errorcount = 0 then 
					viewstate = "update"
			end if
		end if		
	end if
	
	if viewstate = "update" then 
		save_rs rs
		recordid = rs.fields("id")		
		viewstate = "edit"
	end if
	
	if viewstate="edit" then viewstate = "save"
	if viewstate="new" then viewstate = "savenew"
	
	response.write formerrors
	
	function save_rs(rs)
		with rs
			.fields("memi_budget") = fieldvalue(rs,"memi_budget")
			.fields("visible_to_others") = checkboxvalue(fieldvalue(rs,"visible_to_others"))
		end with
		sec_setsecurityinfo rs 
		putrecordset rs 
	end function

	'Hier wordt de titel van het formulier bepaalt
    f_header getlabel("my_bounum")
	
	
%>
<div style="padding: 15px 0px 15px 0px">
    Wanneer u het goed vindt dat uw toekomstige buren contact met u kunnen zoeken, 
    zet u onderstaand vinkje aan. Wilt u dit liever niet zet het vinkje dan uit.
    
   <p> <b>Uw gegevens worden voor anderen zichtbaar onder het menu [Mijn gegevens] - [Mijn buren].</b></p>
    
</div>
<%f_form_hdr()%>
<table style="" cellpadding="0" cellspacing="0" ID="Table1">
	<%
	    f_checkbox rs,"visible_to_others","visible_to_others"                
    %>
</table>
<div style="padding: 15px 0px 15px 0px">
    Door uw budget aan te geven houdt de woonwensenlijst u te allen tijde op de hoogte van het bedrag dat u nog kunt besteden. Zodra u het budget overschrijdt zult u in het <span style="color: #f00">rood</span> gaan. Let op: U kunt ook nu nog steeds woonwensen selecteren!
</div>
<table style="" cellpadding="0" cellspacing="0" ID="Table1">
	<%
        f_textbox rs,"memi_budget","memi_budget",120
    %>
</table>
<br /><br /><br />
<%
	f_form_ftr()
%>
</form> 
<!-- #include file="../../templates/footers/content.asp" -->
