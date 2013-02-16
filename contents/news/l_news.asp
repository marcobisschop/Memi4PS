<!-- #include file="../../templates/headers/content.asp" -->
<!-- #include file="../projects/functions.asp" -->
<!-- #include file="../bounum/functions.asp" -->

<%
    dim inreto, inreto_id
    
    inreto = viewstate_value("inreto")
    inreto_id = viewstate_value("inreto_id")
        
    select case lcase(inreto)
    case "projec"
        projects_header inreto_id
    
    end select

    f_header getlabel("news")
    dim sql, fields, orderby
    %>
    <div style="width:100%" align=right >
    <a href="e_news.asp?viewstate=new&id=-1&inreto=<%=inreto %>&inreto_id=<%=inreto_id %>"><%=getlabel("new")%></a>
    </div>
    <%	
    sql = "select *, 'x' as del from vw_nieuws where inreto='" & inreto & "' and inreto_id=" & inreto_id 
    fields = ""
    fields = fields & "$name:=id;type:=checkbox;boundcolumn:=id;$"
    fields = fields & "$name:=inreto;type:=hidden;boundcolumn:=id;$"
    fields = fields & "$name:=inreto_id;type:=hidden;boundcolumn:=id;$"
    fields = fields & "$name:=tekst;type:=hidden;boundcolumn:=id;$"
    fields = fields & "$name:=datum;type:=link;url:=e_news.asp?viewstate=edit&id=~id~&inreto=~inreto~;$"
    fields = fields & "$name:=del;type:=delete;class:=nieuws;boundcolumn:=id;id:=~id~;$"
    orderby = "datum"
    
    r_list sql, fields, orderby

    
%>
<!-- #include file="../../templates/footers/content.asp" -->
