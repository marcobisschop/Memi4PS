<!-- #include file="../../templates/headers/content.asp" -->
<!-- #include file="functions.asp" -->
<%
	dim recordid, rs, sql, tablename
	
	viewstate = viewstate_value("viewstate")
	recordid  = viewstate_value("kst_pk")
	projec_id  = viewstate_value("projec_id")
	tablename = "keuset"
	
	projects_header projec_id
	
	if viewstate="" then viewstate = "new"
	if recordid = "" then recordid = -1
		
	select case lcase(viewstate)
	case "view"
		sql = "select * from [" & tablename & "] where kst_pk = " & recordid
		set rs = getrecordset(sql,false)
	case "edit","save", "change"
		sql = "select * from [" & tablename & "] where kst_pk = " & recordid
		set rs = getrecordset(sql,false)
	case "new","savenew"
		sql = "select * from [" & tablename & "] where kst_pk = -1"
		set rs = getrecordset(sql,false)
		rs.addnew
		rs("kst_projec_id") = projec_id
		sec_setsecurityinfo (rs)
	case "list"
	case else
		response.Write "invalid viewstate !!" & viewstate
		response.end
	end select
	
	if viewstate = "save" or viewstate = "savenew" then	
		if ispostback() then
			if not v_valid("^\w+",true,fieldvalue(rs,"kst_naam")) then v_addformerror "kst_naam"
			if not v_valid("^\w+",true,fieldvalue(rs,"kst_omschrijving")) then v_addformerror "kst_omschrijving"
			if not v_valid("^\d+$",true,fieldvalue(rs,"kst_aantal")) then v_addformerror "kst_aantal"
			if errorcount = 0 then 
					viewstate = "update"
			end if
		end if		
	end if
	
	response.write formerrors
	
	if viewstate = "update" then 
		save_rs rs
		recordid = rs.fields("kst_pk")		
		viewstate = "view"
		response.Redirect refurl
	end if
	
	if viewstate="edit" then viewstate = "save"
	if viewstate="new" then viewstate = "savenew"
	
	function save_rs(rs)
		with rs
			.fields("kst_naam") = fieldvalue(rs,"kst_naam")
			.fields("kst_omschrijving") = fieldvalue(rs,"kst_omschrijving")
			.fields("kst_kop_titel") = fieldvalue(rs,"kst_kop_titel")
			.fields("kst_kop_omschrijving") = fieldvalue(rs,"kst_kop_omschrijving")
			.fields("kst_aantal") = fieldvalue(rs,"kst_aantal")
			.fields("kst_verplicht") = checkboxvalue(fieldvalue(rs,"kst_verplicht"))
			.fields("kst_volgorde") = convertvalue(fieldvalue(rs,"kst_volgorde"))
			'.fields("is_closed") = checkboxvalue(fieldvalue(rs,"is_closed"))
		end with
		sec_setsecurityinfo rs 
		putrecordset rs 
	end function

	f_header getlabel(tablename)
	
	select case lcase(viewstate)
	case "list"
	    %>
	    <div class='rolodex'><a href='l_keuset.asp?viewstate=new&kst_pk=-1&projec_id=<%=projec_id %>'>Nieuwe set</a></div>
	    <%
	    sql = "select kst_pk, kst_naam, kst_omschrijving, kst_verplicht, kst_aantal, 'x' as del, kst_volgorde, kst_projec_id "
	    sql = sql & " ,(select count(*) from keuzen where keuset_id=keuset.kst_pk and keusoo_soonaa='p') as aantal_gekoppeld"
	    sql = sql & " from [" & tablename & "] where kst_projec_id=" & projec_id
        fields = "$name:=kst_pk;type:=hidden;$$name:=kst_projec_id;type:=hidden;$"
        fields = fields & "$name:=kst_naam;type:=link;url:=?viewstate=edit&kst_pk=~kst_pk~&projec_id=~kst_projec_id~;label:=edit;$"
        fields = fields & "$name:=del;type:=delete;class:="&tablename&";boundcolumn:=kst_pk;id:=~kst_pk~;$"
        orderby = "kst_volgorde desc"
        
       ' rw sql
        
        r_list sql, fields, orderby
	case else
	    f_form_hdr()
        %>
        <input type="hidden"  id="projec_id"  name="projec_id"  value="<%=projec_id %>" />
        <input type="hidden"  id="kst_pk"  name="kst_pk"  value="<%=recordid%>" />
        <table style="" cellpadding="0" cellspacing="0" ID="Table1">
	        <tr>
		        <td valign="top">
			        <table style="width:50%" ID="Table2">
				        <%
		                    f_textbox rs,"name","kst_naam",250
		                    f_textarea rs,"kst_omschrijving","kst_omschrijving","100%", "180"
		                    f_checkbox rs,"kst_verplicht","kst_verplicht"
		                    f_textbox rs,"kst_aantal","kst_aantal",40		
		                    f_textbox rs,"kst_volgorde","kst_volgorde",40	                    
                        %>
                     </table>	
                 </td>
                 <td valign="top">				
			        <table style="" ID="Table3">
				        <%
		                    f_textbox rs,"kst_kop_titel","kst_kop_titel",400
		                    f_textarea rs,"kst_kop_omschrijving","kst_kop_omschrijving","100%", "180"
                        %>
                     </table>					
                 </td>
	        </tr>
        </table>
        <%
	    f_form_ftr()
	    if recordid > 0 then
	        f_header "gekoppelde keuzen"
	        sql = "select id, keucod, keubes, 'x' as del from keuzen where keusoo_soonaa='p' and keuset_id=" & recordid
            fields = "$name:=id;type:=hidden;$"
            fields = fields & "$name:=del;type:=delete;class:=keuzen_keuset;boundcolumn:=id;id:=~id~;$"
            orderby = "keucod"
            r_list sql, fields, orderby
        end if
    end select
%>

<!-- #include file="../../templates/footers/content.asp" -->
