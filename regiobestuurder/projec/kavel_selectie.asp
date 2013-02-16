<!-- #include file="../../templates/headers/content.asp" -->
<%

    f_header getlabel("Loting")

%>
<div style="margin-bottom: 20px; padding-top: 10px; padding-left: 10px; padding-right: 10px; padding-bottom: 10px; width: 100%">
Overzicht plattegronden
</div>
    
<%
        dim rs, sql
        sql = "select * from vw_projec_plagro_loting where projec_id=" & session("projec_id")
        set rs = getrecordset(sql, true)
        with rs
            if .eof then
                %>
                    <div>
                    Nog geen plattegronden aanwezig.
                    </div>
                <%
                ' response.redirect "" 
            else
                do until .eof
                    %>
                    <div style="padding-top: 15px; padding-left: 15px; font-weight: 700">
                    <%=.fields("beschrijving") %><br /><br />
                    <img src="../../include/plagro_loting.asp?id=<%=.fields("id") %>"/>
                    </div>
                    
                    <%
                    
                    .movenext
                loop 
            end if
        end with
        set rs = nothing
%>


<!-- #include file="../../templates/footers/content.asp" -->
