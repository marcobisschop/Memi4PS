<!-- #include file="../../templates/headers/content.asp" -->
<%

    f_header getlabel("Loting")

%>
<div style="margin-bottom: 20px; padding-top: 10px; padding-left: 10px; padding-right: 10px; padding-bottom: 10px; width: 100%">
U neemt deel aan de loting voor de kavelverdeling. Selecteer het kavel van uw voorkeur.
</div>
    
<%
        dim rs, sql
        sql = "select * from vw_projec_plagro_loting where projec_id=" & session("projec_id")
        set rs = getrecordset(sql, true)
        with rs
            if .eof then
                %>
                    <div>
                    Nog geen plattegronden voor de loting aanwezig.
                    </div>
                <%
                ' response.redirect "" 
            else
                do until .eof
                    %>
                    <div style="padding-top: 15px; padding-left: 15px; font-weight: 700">
                    <%=.fields("beschrijving") %><br /><br />
                    <img src="../../include/plagro_loting.asp?id=<%=.fields("id") %>" usemap="#map_<%=.fields("id") %>"/>
                    </div>
                    
                    <%
                    writemap .fields("id")
                    .movenext
                loop 
            end if
        end with
        set rs = nothing
        
        function writemap(map_id)
            dim sql ,rs
            sql = "select * from bounum where projec_plagro_loting_id=" & map_id
            set rs = getrecordset(sql, true)
            with rs
                if not .eof then
                %>
               <map name="map_<%=map_id %>">   
                <%
                do until .eof
                    %>
                    <area style="border: solid 1px #ff0000" shape="circle" coords="<%=.fields("projec_plagro_loting_x") %>,<%=.fields("projec_plagro_loting_y") %>,20" href="kavel_selectie_bevestigen.asp?bounum_id=<%=.fields("id") %>" title="Selecteer <%=.fields("extnum") %>">
                    <% 
                    .movenext
                loop 
               %>
               </map>
               <%
               end if 
            end with
            set rs = nothing
        end function
        
%>


<!-- #include file="../../templates/footers/content.asp" -->
