<!-- #include file="../templates/headers/content.asp" -->

<%
    dim projec_id, next_
    projec_id = viewstate_value("projec_id")
    next_ = viewstate_value("next")
    
    if isnumeric(projec_id) then
        session("projec_id") = projec_id
        select case lcase(next_)
        case "voorblad"
            response.redirect "main.asp"
        case else
            response.redirect "projec/default.asp"
        end select
    end if        
    
    dim sql, fields, orderby
    sql = "select pronaa, 'Voorblad' as voorblad, soonaa, contacts_name2, projec_id, 'Keuzenlijst' as keuzenlijst, 'Kruisjeslijst' as kruisjeslijst, 'Relaties' as prorel, 'Bouwplaatsfotos' as bouwplaatsfotos, 'Kopers' as kopers from vw_prorel where relati_id=" & sec_currentuserid()
    
    fields = "$name:=pronaa;type:=link;url:=default.asp?projec_id=~projec_id~;$"
    fields = fields & "$name:=voorblad;type:=link;url:=default.asp?projec_id=~projec_id~&next=voorblad;$"
    
    if instr(1,sec_roles(),"aa")=0 and instr(1,sec_roles(),"pr")=0 and instr(1,sec_roles(),"kb")=0 then
        fields = fields & "$name:=keuzenlijst;type:=hidden;$"
    else        
        fields = fields & "$name:=keuzenlijst;type:=link;url:=projec/keuzenlijst.asp?projec_id=~projec_id~;$"
    end if
    
    fields = fields & "$name:=kruisjeslijst;type:=link;url:=projec/kruisjeslijst.asp?projec_id=~projec_id~;$"
    
    fields = fields & "$name:=prorel;type:=link;url:=projec/prorel.asp?projec_id=~projec_id~;$"
    fields = fields & "$name:=bouwplaatsfotos;type:=link;url:=bounum/bouwplaatsfotos.asp?projec_id=~projec_id~;$"
    fields = fields & "$name:=kopers;type:=link;url:=projec/kopers.asp?projec_id=~projec_id~;$"
    fields = fields & "$name:=projec_id;type:=hidden;$"
    orderby = "pronaa"
%>
<div style="padding: 15px 0px 15px 0px">
Selecteer het project waarmee u wilt werken:
</div>
<%    
    r_list sql, fields, orderby
    
%>

<!-- #include file="../templates/footers/content.asp" -->
