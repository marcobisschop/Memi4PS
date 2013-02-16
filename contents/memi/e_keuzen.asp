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
			if not v_valid("^\w+",true,fieldvalue(rs,"keucod")) then v_addformerror "keucod"
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
		
		sql = "exec spKeuzen_synchroniseer " & recordid
        executesql sql
        			
		viewstate = "view"
		response.Redirect viewstate_value("REFURL")
	end if
	
	if viewstate="edit" then viewstate = "save"
	if viewstate="new" then viewstate = "savenew"
	
	rw formerrors
	
	function save_rs(byref rs)
		with rs
			.fields("keucod") = fieldvalue(rs,"keucod")
			.fields("keunaa") = fieldvalue(rs,"keucod")
			.fields("altcod") = fieldvalue(rs,"altcod")
			
			rw len(fieldvalue(rs,"keubes"))
			
			.fields("keubes") = cstr(fieldvalue(rs,"keubes"))
			.fields("prikop") = convertvalue(fieldvalue(rs,"prikop"))
			.fields("voltek") = checkboxvalue(fieldvalue(rs,"voltek"))
			.fields("keucat_id") = fieldvalue(rs,"keucat_id")
			.fields("keuafd_id") = fieldvalue(rs,"keuafd_id")
			.fields("slucat_id") = fieldvalue(rs,"slucat_id")
			.fields("defini") = checkboxvalue(fieldvalue(rs,"defini"))
			.fields("control") = checkboxvalue(fieldvalue(rs,"control"))
			.fields("afrond") = checkboxvalue(fieldvalue(rs,"afrond"))
			.fields("natebe") = checkboxvalue(fieldvalue(rs,"natebe"))
			.fields("voorstel") = checkboxvalue(fieldvalue(rs,"voorstel"))
			.fields("locked") = checkboxvalue(fieldvalue(rs,"locked"))
			.fields("aanmin") = fieldvalue(rs,"aanmin")
			.fields("aanmax") = fieldvalue(rs,"aanmax")
			.fields("aantal") = fieldvalue(rs,"aantal")
			.fields("memi") = checkboxvalue(fieldvalue(rs,"memi"))
			
			if lcase(rs.fields("keusoo_soonaa"))="p" then
			    .fields("keuset_id") = fieldvalue(rs,"keuset_id")
			end if
			
		end with
		sec_setsecurityinfo rs 
		putrecordset rs 
	end function
	
	
	keuzen_header recordid
	f_form_hdr()
	f_hidden "page"
%>

<table style="" cellpadding=0 cellspacing=0 ID="Table1">
	<tr>
		<td valign="top">
			<table style="" ID="Table2">
				<%
					f_textbox rs,"keucod","keucod","150"
					f_textbox rs,"altcod","altcod","150"
					f_textbox rs,"prikop","prikop",150
				    
				%>
			</table>
		</td>
		<td valign="top">
			<table style="" ID="Table3">
				<%
					f_checkbox rs,"voltek","voltek"
					f_checkbox rs,"natebe","natebe"
					f_checkbox rs,"is_voorstel","voorstel"
				%>
			</table>
		</td>
		<td valign="top">
			<table style="" ID="Table11">
				<%
					'f_label rs,"keusoo_soonaa","keusoo_soonaa"
					'f_label rs,"koppel_id","koppel_id"
					'f_label rs,"origin_id","origin_id"
					f_checkbox rs,"meerwerk","memi"
				%>
			</table>
		</td>
	</tr>
</table>	
<table style="" cellpadding=0 cellspacing=0 ID="Table6">
	<tr>
		<td valign="top">
			<table style="" ID="Table5">
				<%
					f_frm_divider getlabel("keubes")
					f_textarea rs,"keubes","keubes","100%",220
					
					f_frm_divider getlabel("catafd")
					f_listbox rs,"keucat","keucat_id","select * from vw_keucat order by catnaa","id","catnaa","100%",""
					f_listbox rs,"keuafd","keuafd_id","select * from keuafd order by afdnaa","id","afdnaa","100%",""
					
					if lcase(rs.fields("keusoo_soonaa"))="p" then
					    f_listbox rs,"keuset","keuset_id","select * from keuset where kst_projec_id=" & rs.fields("koppel_id") & " order by kst_naam","kst_pk","kst_naam","100%",""
                    end if					    
					
				%>
			</table>
		</td>
		
	</tr>
</table>
<table style="" cellpadding=0 cellspacing=0 ID="Table7">
	<tr>
		<td valign="top">
			<table style="" ID="Table8">
				<%
					f_frm_divider getlabel("Voortgang")
					%>
</td>
	</tr>
</table>					
<table style="" cellpadding=0 cellspacing=0 ID="Table9">
	<tr>
		<td valign="top" style="width: 50%">
			<table style="" ID="Table10">
			    <tr>
			        <td colspan=2 class='f_item_label' style="width: 100%; padding-bottom: 5px; background-color: #f80000">
			        Geef voor elke keuze de bijbehorende sluitingscategorie op. Later worden dan voor elk bouwnummer de juiste data aangehouden in de woonwensenlijst.
			        </td>
			    </tr>
				<%  
					f_listbox rs,"slucat","slucat_id","select * from slucat order by catnaa","id","catnaa","100%",""
					f_checkbox rs,"defini","defini"
					f_checkbox rs,"control","control"
					f_checkbox rs,"afrond","afrond"
				%>
			</table>
		</td>
		<td valign="top">
			<table style="" ID="Table4">
				<%
					f_textbox rs,"aanmin","aanmin",40
					f_textbox rs,"aanmax","aanmax",40
					f_textbox rs,"aantal","aantal",40
					f_checkbox rs,"locked","locked"
				%>
			</table>
		</td>
	</tr>
</table>
<%
f_form_ftr()
%>
<!-- #include file="../../templates/footers/content.asp" -->
