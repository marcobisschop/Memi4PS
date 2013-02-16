<!-- #include file="../templates/headers/content.asp" -->
<table style="width:100%; height: 80%" cellspacing=0 cellpadding=20>
<tr>
    <td style="width: 300" valign=top>
    <%
        show_image "projec_images", session("projec_id"), 1, 300, 0
%>
<br /><br />
<%        
        f_header getlabel("news")
        dim news_id  
        news_id = viewstate_value("news_id")
        dim sql,rs
        sql = "select * from vw_news where inreto='projec' and inreto_id=" & session("projec_id") & " order by datum desc"
        set rs = getrecordset(sql ,true)
        with rs
            if .eof then
                response.write getlabel("no_news")
            else
                if news_id=0 then
                    onderw = .fields("onderw")
                    tekst = .fields("tekst")
                    datum = .fields("datum")
                else
                    onderw = dblookup("vw_news","id",news_id,"onderw")
                    tekst = dblookup("vw_news","id",news_id,"tekst")
                    datum = dblookup("vw_news","id",news_id,"datum")
                end if
                %>
                <div style="">
                <h1><%=onderw %></h1>
                <%=tekst %>
                <br /><br />
                Datum: <%=datum %>
                </div>
                <br />
                <br />
                <% 
                do until .eof
                        %>
                        <img src='/images/ico_pijl_2.gif' />&nbsp;<a href='main.asp?news_id=<%=.fields("id") %>'><%=.fields("onderw") %></a><br />
                        <%
                    .movenext
                loop
            end if
        end with
        set rs = nothing
    %>    
    </td>
    <td style="width:" valign=top>
        <%
        f_header getlabel("agenda")
        
        sql = "select * from vw_agenda where inreto='projec' and inreto_id=" & session("projec_id") & " order by agenda_date asc"
        set rs = getrecordset(sql ,true)
        with rs
            if .eof then
                response.write getlabel("no_agenda")
            else
                %>
                <table style="" cellpadding="2">
                <%
                do until .eof
                    %>
                    <tr>
                        <td><%=.fields("agenda_date") %></td>
                        <td><%=.fields("agenda_description") %></td>
                    </tr>
                    <%
                    .movenext
                loop
                %>
                </table>
                <%
            end if
        end with
        set rs = nothing
        %>
        <br /><br /><br /><br />
        <%
        f_header getlabel ("my_tasks")
        r_tasks "mytasks", sec_currentuserid()
    %>   
    </td>
</tr>
</table>
<!-- #include file="../templates/footers/content.asp" -->
