<!-- #include file="../../templates/headers/content.asp" -->
<%

    dim sql
    sql = "select *, 'ml' as ml, 'kl' as kl, 'doc' as doc from vw_bounum where  projec_id=" & session("projec_id")

    fields = "$name:=ml;type:=link;url:=ml.asp?bounum_id=~bounum_id~;$"
    fields = fields & "$name:=doc;type:=link;url:=doc.asp?bounum_id=~bounum_id~;$"
    fields = fields & "$name:=bounum_id;type:=hidden;$"
    fields = fields & "$name:=boutyp_id;type:=hidden;$"
    fields = fields & "$name:=projec_id;type:=hidden;$"
    fields = fields & "$name:=kopers;type:=hidden;$"
    fields = fields & "$name:=adrstr;type:=hidden;$"
    fields = fields & "$name:=adrpos;type:=hidden;$"
    fields = fields & "$name:=koonaa;type:=hidden;$"
    fields = fields & "$name:=plagro;type:=hidden;$"
    fields = fields & "$name:=ord;type:=hidden;$"
    fields = fields & "$name:=xy;type:=hidden;$"
    
    if instr(1,sec_roles(),"aa")=0 and instr(1,sec_roles(),"pr")=0 and instr(1,sec_roles(),"kb")=0 then
        fields = fields & "$name:=kl;type:=hidden;$"
    else
        fields = fields & "$name:=kl;type:=link;url:=kl.asp?bounum_id=~bounum_id~;$"
    end if
    
    orderby = "ord"
    
    f_header dblookup("projec","id",session("projec_id"),"pronaa")
%>
<div style="padding: 15px 0px 15px 0px">
    <br /><br />
    Klik <a href='../default.asp?projec_id=zzz'>hier</a> om terug te gaan naar de projectlijst.
</div>

<%
    r_list sql, fields, orderby
%>
<!-- #include file="../../templates/footers/content.asp" -->
