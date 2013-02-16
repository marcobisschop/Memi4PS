<!-- #include file="../templates/headers/content.asp" -->
<%
	dim class_
	dim id
	dim delete_
	dim referer
	dim confirmed
	dim sql, sql_exec
	dim rs
	
	'Overschrijven wanneer er een andere query uitgevoerd moet worden!
	'Overschrijven in de select case []
	sql_exec = ""
	
	referer = viewstate_value("referer")
	if len(referer) = 0 then referer = request.ServerVariables("HTTP_REFERER")
	
	class_		= viewstate_value("class")
	id			= viewstate_value("id")
	delete_		= true
	
if not usercan("delete") then
%>
<div style="padding:10px; margin:0px;">
	<h3><%=getlabel("delete_norights") %></h3>
</div>
<%
else
	confirmed = (fieldvalue(nothing,"confirmed") = "true")
	%>
	<div style="padding:10px; margin:0px;">
	<%
	select case lcase(class_)
	case "keuzen_keuset"
	    sql_exec = "update keuzen set keuset_id=-1 where id=" & id
	case "factur"
	    delete_ = true
	case "nieuws"
	    delete_ = true
	case "agenda"
	    delete_ = true
	case "bouslu"
	    delete_ = true
	case "bounum"
	    sql_exec = "sp_object_delete 'bounum', " & id
	case "kosten"
	    sql_exec = "sp_object_delete 'kosten', " & id
	case "sec_menus"
	    sql_exec = "delete from sec_menus where parentid=" & id & " or id=" & id
	case "proslu"
	    sql = "select * from bouslu where proslu_id=" & id
	    set rs = getrecordset(sql, true)
		with rs
		    if .recordcount > 0 then
		        msg = getlabel("delete_proslu_nok_bouslu") & "<br>"
		        delete_ = false
		    end if
		end with
	case "dosarc"
	    delete_ = true
	case "projec_plagro_loting"
	    delete_ = true
	case "boukop"
	    delete_ = true
	case "boutyp"
	    sql = "select id from bounum where boutyp_id=" & id
		set rs = getrecordset(sql, true)
		with rs
		    if .recordcount > 0 then
		        msg = getlabel("delete_boutyp_nok_linkedbounum") & "<br>"
		        delete_ = false
		    end if
		end with
		sql = "select id from keuzen where keusoo_soonaa='W' and koppel_id=" & id
		set rs = getrecordset(sql, true)
		with rs
		    if .recordcount > 0 then
		        msg = msg & getlabel("delete_boutyp_nok_linkedkeuzen")
		        delete_ = false
		    end if
		end with
	case "keuafd"
	    sql = "select id from keuzen where keuafd_id=" & id
		set rs = getrecordset(sql, true)
		with rs
		    if .recordcount > 0 then
		        msg = getlabel("delete_keuafd_nok_inuse") & "<br>"
		        delete_ = false
		    end if
		end with
	case "bedrijf"
	    sql_exec = "sp_bedrijf_delete " & id	    
	case "projec_fases"
	    delete_ = true
	case "prodee"
	    'sql_exec = "sp_bedrijf_delete " & id	
	    delete_ = true
	case "keuset"
	    sql = "select id from keuzen where keuset_id=" & id
		set rs = getrecordset(sql, true)
		with rs
		    if .recordcount > 0 then
		        msg = getlabel("delete_keuset_nok_inuse") & "<br>"
		        delete_ = false
		    end if
		end with
		sql_exec = "delete from keuset where kst_pk=" & id
	case "prorel"
	    if id<>390 then
	        delete_ = true
	    end if
	case "forum"
	    delete_ = true
	case "docum"
	    sql_exec = "delete from dosarc where inreto='documents' and inreto_id=" & id & "; delete from docum where id=" & id	    
	case "regrkp"
	    class_ = "regrkp"
	    dim relati_id, relgro_id
	    relati_id = split(id,",")(0)
	    relgro_id = split(id,",")(1)
	    sql_exec = "delete from regrkp where relati_id=" & relati_id & " and relgro_id=" & relgro_id
		
		delete_ = true
	case "variables"
		delete_ = true
	case "relations"
		sql = "select id from relations_contacts where relations_id=" & id
		set rs = getrecordset(sql, true)
		with rs
		    if .recordcount > 0 then
		        msg = getlabel("delete_relations_nok_linkedcontacts")
		        delete_ = false
		    end if
		end with
	case "relations_contacts"
		sql = "select * from regrkp where id in (select regrkp_id from prorel) and relati_id=" & id
		set rs = getrecordset(sql, true)
		with rs
		    if .recordcount > 0 then
		        msg = getlabel("delete_relations_contacts_nok_prorel")
		        delete_ = false
		    end if
		end with
	case "relations_deelnemers"
		sql = "select * from regrkp where id in (select regrkp_id from prodee) and relati_id=" & id
		set rs = getrecordset(sql, true)
		with rs
		    if .recordcount > 0 then
		        msg = getlabel("delete_relations_contacts_nok_prodee")
		        delete_ = false
		    end if
		end with
		sql_exec = "sp_relati_delete " & id
	case "projec_fases_steps" 
        sql = "select id from projec_fases_steps where projec_id <> 0 and steps_id=" & id
		set rs = getrecordset(sql, true)
		with rs
		    if .recordcount > 0 then
		        msg = getlabel("delete_projec_fases_steps_usedinprojects")
		        delete_ = false
		    end if
		end with	
	case else	
		%>
		<h3><%=getlabel("delete_objectnotdefined") %> [<%=class_%>]</h3>
		<%
		delete_ = false
	end select
	%>
	</div>
	<%
	if not confirmed and delete_ then
	%>
	<div style="padding:10px; margin:0px;">
		<form id="Form1" name="confirm" action="delete.asp" method="get">
			<input type=hidden id=Hidden1 name=class value="<%=class_%>"> 
			<input type=hidden id=Hidden2 name=postback value="true">
			<input type=hidden id=Hidden3 name=viewstate value="<%=viewstate%>"> 
			<input type=hidden id=Hidden4 name=id value="<%=id%>">
			<input type=hidden id=clienten_id name=clienten_id value="<%=clienten_id%>">
			<input type=hidden id=Hidden5 name=referer value="<%=referer%>"> 
			<input type=hidden id=Hidden6 name=confirmed value="true">
			<p>
				<h3><%=getlabel("delete_areyousure") %></h3>
			</p>
			<a href="javascript:document.confirm.submit();"><%=getlabel("yes") %></a> <a href="<%=referer%>"><%=getlabel("no") %></a>
		</form>
	</div>
	<!-- #include file="../templates/footers/include.asp" -->
    <% 
		response.End 
	end if
	
	if confirmed and delete_ then
		'dim sql
		if len(sql_exec) = 0 then sql_exec = "delete from [" & class_ & "] where id = " & id
		executesql sql_exec
		msg = "<h3>" & getlabel("delete_success") & "<br><br>"  & msg & "</h3>"
	else
		msg = "<h3>"  & getlabel("delete_nosuccess") & "<br><br>" & msg & "</h3>"		
	end if	
end if
%>	
<div style="padding:10px; margin:0px;">
	<%=msg%>	
	<br /><br />
	Maak uw keuze uit het menu of klik <a href='<%=referer%>'>hier</a> om terug te 
	gaan.
</div>
<!-- #include file="../templates/footers/include.asp" -->

