<%
function Forum_Who (rs)
    if not rs.eof then
        if rs.fields("relati_id") > 0 then
            'Geplaatst door een relatie
            sql = "select * from prorel "
	        sql = sql & " left join regrkp "  
		    sql = sql & " left join relati on regrkp.relati_id = relati.id "
	        sql = sql & " on prorel.regrkp_id = regrkp.id "
	        sql = sql & " left join relsoo on prorel.relsoo_id = relsoo.id "
            sql = sql & " where relati.id=" & rs.fields("relati_id") 
            sql = sql & " and prorel.projec_id=6" ' & rs.fields("projec_id") 
            set rsRelati = getrecordset(sql, true)
            Forum_Who = rsRelati.fields("soonaa")
            set rsRelati = Nothing
        elseif rs.fields("bounum_id") > 0 then
            'Geplaatst door een bouwnummer
            Forum_Who = "Bouwnummer " & rs.fields("extnum")
        else
            Forum_Who = "Beheerder"
        end if
    else
        Forum_Who = "Onbekend"
    end if  
end function
 %>