<!-- #include file="../../templates/headers/content.asp" -->
<%
	f_header getlabel("deelnemers")
	dim sql, fields, orderby, rs
	
    sql = sql & " select "
    sql = sql & " bounum.extnum, coalesce(relati.voorle + ' ','') + coalesce(relati.tussen + ' ','') + coalesce(relati.achter,'') as naam"
    ' sql = sql & " relati.adrnum,relati.adrpos,relati.adrpla, relati.adrtel,relati.adrema "
    sql = sql & " , relati.adrpla, relati.adrtel,relati.adrema "
    sql = sql & " from vw_prodee"
    sql = sql & " left join relati on vw_prodee.relati_id = relati.id"
    sql = sql & " left join bounum on vw_prodee.voorkeur = bounum.id"
    sql = sql & " where vw_prodee.status_id=18"
    sql = sql & " and vw_prodee.projec_id in (" & session("projec_id") & ")"
    sql = sql & " and visible_to_others = 1" 

	fields = ""
	fields = fields & "$name:=id;type:=hidden;$"
	orderby = ""
	r_list sql, fields, orderby
%>
<!-- #include file="../../templates/footers/content.asp" -->
