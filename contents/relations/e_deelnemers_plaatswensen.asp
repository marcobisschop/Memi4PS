<!-- #include file="../../templates/headers/content.asp" -->
<!-- #include file="functions.asp" -->
<%
	dim recordid, rs, sql, tablename
	
	viewstate = viewstate_value("viewstate")
	recordid  = viewstate_value("id")
	tablename = "relations"
		
	deelnemers_header (recordid)	
	sql = "select * from deelne_plawen where relati_id=" & recordid
    	
    dim fieldlist, orderby
    fields = "$name:=relati_id;type:=hidden;$"
    orderby = "[volgnr]"
	
    r_list sql, fields, orderby
%>
<!-- #include file="../../templates/footers/content.asp" -->
