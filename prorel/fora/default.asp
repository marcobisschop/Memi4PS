<!-- #include file="../../templates/headers/content.asp" -->
<%

    f_header getlabel("fora")

%>
<div style="margin-bottom: 20px; padding-top: 10px; padding-left: 10px; padding-right: 10px; padding-bottom: 10px; width: 100%">
Een forum wordt gebruikt om binnen een projectfase gezamenlijk over een onderwerp te discusseren en op 
basis van de discussie eventueel een besluit te nemen. In een gesloten forum kunnen geen reacties meer worden geplaatst.
</div>
    
<b>Beschikbare forum(s):</b>

<%
		
	sql = "select * from vw_fora where projec_id=" & session("projec_id") & " order by volgor"
    set rs = getrecordset(sql, true)
    with rs
        if not .eof then
            %><ul><%
            do until .eof
                if .fields("closed") then
                    myURL = "<a title='Gesloten' style='color: #ff0000' target='content' href='/deelnemer/fora/fora.asp?fora_id=" & .fields("id") & "'>" & .fields("name") & "</a>"
                else
                    myURL = "<a target='content' href='/deelnemer/fora/fora.asp?fora_id=" & .fields("id") & "'>" & .fields("name") & "</a>"
                end if 
                %><li><%=myurl%></li><%
                .movenext
            loop 
            %></ul><%
        end if
    end with 
    set rs = nothing 
%>
<!-- #include file="../../templates/footers/content.asp" -->
