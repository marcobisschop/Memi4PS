<!-- #include file="../../templates/headers/content.asp" -->
<%
    dim bounum_id
    bounum_id = viewstate_value("bounum_id")
    
    f_header dblookup("projec","id",session("projec_id"),"pronaa")
    f_header "Bouwnummer " & dblookup("vw_prodee","voorkeur",bounum_id,"extnum")
    f_header "Documentatie"
%>
<div style="padding: 15px 0px 15px 0px">
    <br /><br />
    Klik <a href='default.asp'>hier</a> om terug te gaan naar de bouwnummers.
</div>
<%
    sql = "select distinct docnaa, id from vw_docum where available=1 and inreto='bounum' and inreto_id=" & bounum_id & " order by docnaa"
    set rs = getrecordset(sql, true)
    with rs
        do until .eof
            response.write "<h1 style='color: #000'>" & .fields("docnaa") & "</h1>" 
            sql = "select dosarc_id, arcbes from vw_docum where id=" & .fields("id") & " order by volgor"
            set rs2 = getrecordset(sql, true)
            with rs2
                response.write "<ul>"
                do until .eof
                    response.write "<li><a href='/include/file.asp?table=dosarc&inreto=dosarc&inreto_id=" & .fields("dosarc_id") & "'>"& .fields("arcbes") & "&nbsp;</a></li>"
                    .movenext
                loop
                response.write "</ul>"
            end with            
            .movenext
        loop
    end with   
%>
<!-- #include file="../../templates/footers/content.asp" -->
