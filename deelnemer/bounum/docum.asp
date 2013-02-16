<!-- #include file="../../templates/headers/content.asp" -->
<!-- #include file="../inc/functions.asp" -->
<%
    f_header getlabel("documentatie")
    dim sql, rs
    
    sql = " select * from vw_docum "
    sql = sql & " where inreto='bounum' "
    sql = sql & " and inreto_id=" & session("bounum_id") 
    sql = sql & " order by docnaa"
    
    set rs = getrecordset(sql, true)
    
    with rs 
        do until .eof
            
            response.write "<p><b>" & .fields("docnaa") & "</b><br><br>"
            sqlDosarc = "select id, arcbes from dosarc where inreto='documents' and inreto_id=" & .fields("id")
            set rsDosarc = getrecordset(sqlDosarc, true)
            
            if not rsDosarc.eof then
                response.write "<ul>"
                do until rsDosarc.eof
                    response.write "<li><a href='/include/file.asp?table=dosarc&inreto=documents&inreto_id=" & rs.fields("id") &"'>" & rsDosarc.fields("arcbes") & "</a></li>"
                    rsDosarc.movenext
                loop
                response.write "</ul>"
            end if
            response.write "</p>"
            set rsDosarc = nothing
            .movenext
        loop
    end with
    
    set rs = nothing
     
    
%>
<!-- #include file="../../templates/footers/content.asp" -->
