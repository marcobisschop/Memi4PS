<!-- #include file="../../templates/headers/content.asp" -->
<%

    f_header getlabel("Loting")

%>
<div style="margin-bottom: 20px; padding-top: 10px; padding-left: 10px; padding-right: 10px; padding-bottom: 10px; width: 100%">
U neemt deel aan de loting voor de kavelverdeling. Zodra u op uw naam kunt klikken kunt u deelnemen aan de loting.
</div>
    

<%
		
	sql =  "select * from vw_prodee where projec_id=" & session("projec_id") & " order by volgor"
    set rs = getrecordset(sql, true)
    with rs
        if not .eof then
        %>
        <table cellpadding="2">
        <tr>
                <td><b>#</td>
                <td><b>Deelnemer</td>
                <td><b>Bouwnummer</td>
                <td><b>Status</td> 
            </tr>
        <%    
        do until .eof
        
            ' response.Write session("relati_id") & "+" & .fields("relati_id") & "<br>" 
        
            if trim(session("relati_id")) = trim(.fields("relati_id")) then
            
                ' Deze regel betreft de ingelogde deelnemer
                ' Als zijn status op B (aan het loten) staat linkje tonen naar de plattegronden 
            
                if .fields("stanaa") = "B" then
            
                    %>
                    <tr>
                        <td><%=.absoluteposition %>.</td>
                        <td><a href="kavel_selectie.asp?prodee_id=<%=.fields("prodee_id")%>"><%=.fields("contacts_name2") %></a></td>
                        <td><%=.fields("extnum") %></td>
                        <td><%=.fields("stabes") %></td> 
                    </tr>
                    <%
                
                else
                
                    %>
                    <tr>
                        <td><%=.absoluteposition %>.</td>
                        <td><%=.fields("contacts_name2") %></td>
                        <td><%=.fields("extnum") %></td>
                        <td><%=.fields("stabes") %></td> 
                    </tr>
                    <%
                
                end if
            
            else
        
                %>
                <tr>
                    <td><%=.absoluteposition %>.</td>
                    <td><%=.fields("contacts_name2") %></td>
                    <td><%=.fields("extnum") %></td>
                    <td><%=.fields("stabes") %></td> 
                </tr>
                <%
                
            end if
            .movenext
        loop
        %>
        </table>
        <%
        end if
    end with 
    set rs = nothing 
%>
<br /><br />
<!--<a href="kavel_selectie.asp">Simulatie selectie</a>-->
<!-- #include file="../../templates/footers/content.asp" -->
