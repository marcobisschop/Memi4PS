<!-- #include file="../../templates/headers/content.asp" -->
<%
	f_header getlabel("hdr_fora")
	dim sql, fields, orderby

%>
    <div class=rolodex>
    <a href="e_fora.asp?viewstate=new&amp;id=-1&projec_id=0"><%=GetLabel("new")%></a>
    </div>
<%    
    set rs = nothing

    sql = "select *, 'del' as del from vw_fora"
    fields = ""
    fields = fields & "$name:=id;type:=hidden;$"
    fields = fields & "$name:=projec_id;type:=hidden;$"
    fields = fields & "$name:=projec_fases_id;type:=hidden;$"
    fields = fields & "$name:=created;type:=hidden;$"
    fields = fields & "$name:=createdby;type:=hidden;$"
    fields = fields & "$name:=edited;type:=hidden;$"
    fields = fields & "$name:=editedby;type:=hidden;$"
    fields = fields & "$name:=name;type:=link;url:=e_fora.asp?viewstate=view&id=~id~&projec_id=~projec_id~;$"
    fields = fields & "$name:=del;type:=delete;class:=fora;boundcolumn:=id;id:=~id~;$"
    orderby = ""
    r_list sql, fields, orderby

%>
<!-- #include file="../../templates/footers/content.asp" -->
