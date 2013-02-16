<!-- #include file="../../templates/headers/content.asp" -->
<!-- #include file="../inc/functions.asp" -->
<%
    dim sql, rs
    
    f_header getlabel("documentatie")
    
    %>
    <div style="padding: 15px 0px 15px 0px">
    Hier treft u alle documenten aan die voor u van belang kunnen zijn tijdens de bouw van uw woning. De documenten bevatten algemene projectinformatie, maar 
    er staan ook voor uw bouwnummer specifieke documenten tussen. De verkooptekeningen en plattegronden van uw bouwnummer kunt u gebruiken voor het aangeven 
    van uw woonwensen. Voor sommige woonwensen is dit noodzakelijk!
    </div>
    <%
    
    'PROJECTINFO
    sql = "select distinct docnum, docnaa, id from vw_docum where available=1 and inreto='projec' and inreto_id=" & session("projec_id") & " order by docnum"
    set rs = getrecordset(sql, true)
    with rs
        do until .eof
            response.write "<h1 style='color: #000'>" & .fields("docnaa") & "</h1>" 
            sql = "select dosarc_id, arcbes, arcsiz from vw_docum where id=" & .fields("id") & " order by volgor"
            set rs2 = getrecordset(sql, true)
            with rs2
                response.write "<ul>"
                do until .eof
                    response.write "<li><a href='/include/largefile.asp?table=dosarc&inreto=dosarc&inreto_id=" & .fields("dosarc_id") & "'>"& .fields("arcbes") & "&nbsp;</a> <span style='font-size: 9px; color: gray'>(" & fix(.fields("arcsiz")/1024) & "Kb)</span></li>"
                    .movenext
                loop
                response.write "</ul>"
            end with            
            .movenext
        loop
    end with    
    
    'BOUNUMMERINFO
    sql = "select distinct docnum, docnaa, id from vw_docum where available=1 and inreto='bounum' and inreto_id=" & session("bounum_id") & " order by docnum"
    set rs = getrecordset(sql, true)
    with rs
        do until .eof
            response.write "<h1 style='color: #000'>" & .fields("docnaa") & "</h1>" 
            sql = "select dosarc_id, arcbes, arcsiz from vw_docum where id=" & .fields("id") & " order by volgor"
            set rs2 = getrecordset(sql, true)
            with rs2
                response.write "<ul>"
                do until .eof
                    response.write "<li><a href='/include/file.asp?table=dosarc&inreto=dosarc&inreto_id=" & .fields("dosarc_id") & "'>"& .fields("arcbes") & "&nbsp;</a><span style='font-size: 9px; color: gray'>(" & fix(.fields("arcsiz")/1024) & "Kb)</span></li>"
                    .movenext
                loop
                response.write "</ul>"
            end with            
            .movenext
        loop
    end with    
    
    set rs = nothing
    set rs2 = nothing
%>
<!-- #include file="../../templates/footers/content.asp" -->
