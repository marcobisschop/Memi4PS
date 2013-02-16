<!-- #include file="../templates/headers/content.asp" -->
<%
	dim rs,id,table
	'on error resume next
	id = request.querystring ("id")
	sql = "select * from projec_plagro_loting where id = " & id
	set rs = getrecordset (sql,true)
	response.clear 
	with rs
		'response.contenttype = "application/octet-stream" '.fields("filecontenttype")
		response.contenttype =  .fields("img_contyp")
		'response.addheader "content-disposition", "attachment;filename=" & .fields("arcnaa")
		response.binarywrite .fields("img_data")
		.close
	end with
	set rs = nothing	
	'response.end 
%>