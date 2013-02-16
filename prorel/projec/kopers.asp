<!-- #include file="../../templates/headers/content.asp" -->
<%
	dim recordid, rs, sql, tablename
	
	dim projec_id
    projec_id = viewstate_value("projec_id")
    
    if isnumeric(projec_id) then
        session("projec_id") = projec_id
        'response.redirect "projec/default.asp"
    end if 
    
	'Hier wordt de titel van het formulier bepaalt
	f_header ("Kopers")
	
    sql = "select extnum,contacts_name, adresregel3, adresregel4,adrtel, telmob from vw_prodee where projec_id=" & session("projec_id")
	r_list sql, fields, "ord"

%>
<!-- #include file="../../templates/footers/content.asp" -->
