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
    case "bounum"
        bounum_header inreto_id
    end select

    f_header getlabel("claims")
    dim sql, fields, orderby
    %>
    <div style="width:100%" align=right >
    <a href="e_claims.asp?viewstate=new&id=-1&inreto=<%=inreto %>&inreto_id=<%=inreto_id %>"><%=getlabel("new")%></a>
    </div>
    <%	
    sql = "select * from vw_claims where inreto='" & inreto & "' and inreto_id=" & inreto_id 
    fields = "$name:=claims_id;type:=hidden;$"
    fields = fields & "$name:=manager_id;type:=hidden;$"
    fields = fields & "$name:=clacat_id;type:=hidden;$"
    fields = fields & "$name:=clasta_id;type:=hidden;$"
    fields = fields & "$name:=clatyp_id;type:=hidden;$"
    orderby = "claimdate"
    
    r_list sql, fields, orderby    
%>
<!-- #include file="../../templates/footers/content.asp" -->
