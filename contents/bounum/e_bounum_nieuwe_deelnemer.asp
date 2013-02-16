<!-- #include file="../../templates/headers/content.asp" -->
<!-- #include file="functions.asp" -->
<%
	dim recordid, sql
	
	recordid = viewstate_value("id")
	
    sql = "sp_relati_insert_deelnemer "
    sql = sql & ""
	    sql = sql & recordid & ", "
	    sql = sql & sec_currentuserid() & ", "
	    sql = sql & "'', "
	    sql = sql & "'', "
	    sql = sql & "'', "
	    sql = sql & "'', "
	    sql = sql & "'', "
	    sql = sql & "'', "
	    sql = sql & "'', "
	    sql = sql & "'', "
	    sql = sql & "'', "
	    sql = sql & "'', "
	    sql = sql & "'', "
	    sql = sql & "0, "
	    sql = sql & "'', "
	    sql = sql & "'', "
	    sql = sql & "'NIEUWE KOPER', "
	    sql = sql & "null, "
	    sql = sql & "'M', "
	    sql = sql & "'', "
	    sql = sql & "'', "
	    sql = sql & "'', "
	    sql = sql & "'', "
        sql = sql & "'', "
	    sql = sql & "'', "
	    sql = sql & "'', "
	    sql = sql & "'' "
	  '  sql = sql & ",'' "

    executesql sql
    response.Redirect REFURL   
    
    'response.Write sql
%>