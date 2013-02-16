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

    f_header getlabel("agenda")
    dim sql, fields, orderby
    %>
    <div style="width:100%" align=right >
    <a href="e_agenda.asp?viewstate=new&id=-1&inreto=<%=inreto %>&inreto_id=<%=inreto_id %>"><%=getlabel("new")%></a>
    </div>
    <%	
    sql = "select *, 'x' as del from vw_agenda where inreto='" & inreto & "' and inreto_id=" & inreto_id 
    fields = ""
    fields = fields & "$name:=id;type:=checkbox;boundcolumn:=id;$"
    fields = fields & "$name:=inreto;type:=hidden;boundcolumn:=id;$"
    fields = fields & "$name:=inreto_id;type:=hidden;boundcolumn:=id;$"
    fields = fields & "$name:=del;type:=delete;class:=agenda;boundcolumn:=id;id:=~id~;$"
    fields = fields & "$name:=agenda_date;type:=link;url:=e_agenda.asp?viewstate=edit&id=~id~&inreto=~inreto~;$"
    orderby = "agenda_date"
    
    r_list sql, fields, orderby

    
%>
<!-- #include file="../../templates/footers/content.asp" -->
