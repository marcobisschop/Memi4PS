<!-- #include file="../../templates/headers/content.asp" -->
<!-- #include file="../projects/functions.asp" -->
<!-- #include file="../bounum/functions.asp" -->
<%
	dim recordid, rs, sql, tablename
	
	viewstate = viewstate_value("viewstate")
	dim inreto, inreto_id
    
    inreto = viewstate_value("inreto")
    inreto_id = viewstate_value("inreto_id")
        
    recordid  = viewstate_value("id")
	tablename = "claims"
	
	select case lcase(viewstate)
	case "view"
		sql = "select * from [" & tablename & "] where id = " & recordid
		set rs = getrecordset(sql,false)
	case "edit","save"
		sql = "select * from [" & tablename & "] where id = " & recordid
		set rs = getrecordset(sql,false)
		inreto = rs.fields("inreto")
		inreto_id = rs.fields("inreto_id")
	case "new","savenew"
		sql = "select * from [" & tablename & "] where id = -1"
		set rs = getrecordset(sql,false)
		rs.addnew
		rs.fields("inreto") = inreto
		rs.fields("inreto_id") = inreto_id
		sec_setsecurityinfo (rs)
	case else
		response.Write "invalid viewstate !!"
		response.end
	end select
	
	if viewstate = "save" or viewstate = "savenew" then	
		if ispostback() then
			if not v_isdate(true,fieldvalue(rs,"datum")) then v_addformerror "datum"
			if not v_valid("^\w",true,fieldvalue(rs,"onderw")) then v_addformerror "onderw"
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
			.fields("datum") = fieldvalue(rs,"datum")
			.fields("onderw") = fieldvalue(rs,"onderw")
			.fields("tekst") = fieldvalue(rs,"tekst")
		end with
		sec_setsecurityinfo rs 
		putrecordset rs 
	end function
	
	select case lcase(inreto)
    case "projec"
        projects_header inreto_id
    case "bounum"
        bounum_header inreto_id
    end select

    f_header getlabel("claims")
	f_header getlabel("news")
	f_form_hdr()
%>
<input type="hidden" id="inreto" name="inreto" value="<%=inreto %>"/>
<input type="hidden" id="inreto_id" name="inreto_id" value="<%=inreto_id %>"/>

<table style="" cellpadding=0 cellspacing=0 ID="Table1">
	<tr>
		<td valign="top">
			<table style="" ID="Table2">
				<%
					f_datebox rs,"claimdate","claimdate","120"
					f_textbox rs,"claimnumber","claimnumber","120"
					f_textarea rs,"description","description","100%","100"
					f_list rs,"clatyp","clatyp_id","select id, name from clatyp where available=1 order by name","id","name","",""
					f_list rs,"clacat","clacat_id","select id, name from clacat where available=1 order by name","id","name","",""
					f_list rs,"clasta","clasta_id","select id, name from clasta where available=1 order by name","id","name","",""
				%>
			</table>
		</td>
	</tr>
</table>
<%
f_form_ftr()
%>
<!-- #include file="../../templates/footers/content.asp" -->
