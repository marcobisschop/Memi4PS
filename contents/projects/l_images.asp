<!-- #include file="../../templates/headers/content.asp" -->
<!-- #include file="functions.asp" -->
<%
	dim recordid	
	viewstate = viewstate_value("viewstate")
	recordid  = viewstate_value("id")		
	projects_header recordid
	
	sql = "select id,arcbes,cast(arcsiz/1024 as varchar) + ' Kb' as arcsiz,volgor,available,'x'as del from dosarc where inreto='projec_images' and inreto_id=" & recordid
	fields = "$name:=id;type:=hidden;$"
	fields = fields & "$name:=arcbes;type:=link;url:=../../include/file.asp?table=dosarc&inreto=dosarc&inreto_id=~id~;$"
	fields = fields & "$name:=arcsiz;type:=text;align:=right;$"
	fields = fields & "$name:=volgor;type:=text;align:=right;$"
	fields = fields & "$name:=del;type:=delete;class:=dosarc;boundcolumn:=id;align:=center;$"
	fields = fields & "$name:=available;type:=bit;class:=dosarc;field:=available;id:=~id~;align:=center;$"
	
	orderby = "volgor"
	
	sqlfile = "select '' as image, 0 as volgor, '' as arcbes"
	set rs = getrecordset(sqlfile, true)
	
	if ispostback() then
	    if not v_valid("^\d+$",true,fieldvalue(rs,"volgor")) then v_addformerror "volgor"
	    if not v_valid("^\w+",true,fieldvalue(rs,"arcbes")) then v_addformerror "arcbes"
	end if
	
	if ispostback() and errorcount=0 then
	    if uploader.files.count = 1 then
	        set rs = getrecordset("select * from dosarc where id=-1",false)
	        with rs
	            .addnew
			    .fields("arcbes") = fieldvalue(rs,"arcbes") & " "
			    .fields("inreto") = "projec_images"
			    if not isnumeric(fieldvalue(rs,"volgor")) then
			        .fields("volgor") = 0
			    else
			        .fields("volgor") = fieldvalue(rs,"volgor")
                end if			        
			    .fields("inreto_id") = recordid
			    .fields("available") = 1
			    for each file in uploader.files.items
				    if file.filesize <= MaxFileSize then
						
					    .fields("arccon") = file.contenttype
                        .fields("arcsiz") = file.filesize
                        .fields("arcnaa") = file.filename
		                file.savetodatabase rs.fields("arcdat")
			            
				    else
					    'bestand is te groot
					    Response.Write getlabel("error_maximum_filesize : " & MaxFileSize / 1024 & "Kb")				
				    end if
			    next
		    end with
		    sec_setsecurityinfo rs 
		    putrecordset rs 
	    end if
	end if
	
	f_form_hdr()
	f_filebox rs, "image", "image", 100
	f_textbox rs, "volgor", "volgor", 40
	f_textbox rs, "arcbes", "arcbes", 350
	f_form_ftr()
	set rs = nothing
	
	r_list sql, fields, orderby
		
%>
<!-- #include file="../../templates/footers/content.asp" -->
