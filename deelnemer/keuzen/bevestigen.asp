<!-- #include file="../../templates/headers/content.asp" -->
<!-- #include file="../../include/email.asp" -->
<style>
A.Knop {text-decoration:none; padding: 2px 5px 2px 5px; background: #ddd; color: black; border: 2px outset #555}
</style>
<%
    dim bevestigen
    bevestigen = viewstate_value("bevestigen")
    if bevestigen = "ja" then
        executesql "exec sp_bounum_bevestigen " & session("bounum_id") & "," & sec_currentuserid()
        
        bounum_id = session("bounum_id")
        projec_id = session("projec_id")
        sqlPRO = "select * from vw_prorel where projec_id=" & projec_id & " and soonaa in ('KB','BEH')"
        msg = "Bouwnummer <a href='#href#'>#extnum# van project #pronaa#</a> heeft opnieuw zijn keuzen bevestigd."
        sqlBNR = "select * from vw_bounum where bounum_id = " & bounum_id
        set rsBNR = getrecordset(sqlBNR, true)
        with rsBNR
            for each fld in .fields
                msg = replace(msg,"#" & fld.name & "#", fld.value & "")
            next
        end with
        
        msg = replace(msg, "#href#", "" & WEBHOST & WEBPATH & "contents/memi/l_keuzen.asp?viewstate=view&id=" & bounum_id & "&keusoo_soonaa=B&koppel_id=" & bounum_id)
        
        set rsBNR = nothing
        set rsPRO = getrecordset(sqlPRO, true)
        with rsPRO
            do until .eof
                if len(.fields("adrema")) then
                    mBcc = mBcc & .fields("adrema") & ","
                end if
                .movenext
            loop
        end with
        if len(mBcc)>0 then
            mBcc = mid(mBcc,1,len(mBcc)-1)
            mBcc = replace(mBcc,",,",",")
        end if
        mFrom = "memi3@telaterrae.com"
        mTo  = "marco@telaterrae.com"
        mCc  = ""
        mSubject = "Kopersbegeleiding.nl"
        mBody = msg
        Attachments = ""
        mail mFrom, mTo, mCc, mBcc, mSubject, mBody, Attachments

                
        set rsPRO = nothing        
        
    end if
    f_header ("woonwensen")
%>
<script LANGUAGE="JavaScript">
<!--
function confirmPost()
{
var agree=confirm("Weet u het zeker?");
if (agree)
document.location = "bevestigen.asp?bevestigen=ja";
else
return false ;
}
// -->
</script>
<div style="padding: 15px 0px 15px 0px">
U staat op het punt om de door u gekozen woonwensen aan ons te bevestigen. Zodra u dit doet kunt u de gemaakte woonwensen niet meer wijzigen! 
Woonwensen waarvan u de aantallen nog niet heeft gewijzigd kunt u nog wijzigen totdat de sluitingsdatum is verlopen. Klik <a href='default.asp'>hier</a> om terug te gaan naar de woonwensen.
<br /><br />
Wij hebben nog steeds uw handtekening nodig voordat wij kunnen overgaan tot het uitvoeren van uw woonwensen! 
Stuurt u daarom <b>NA ELKE BEVESTIGING</b> de nieuwe getekende lijst op. Indien nodig voegt u de bijhorende plattegronden toe. Klik hier voor de 
<a target="_blank" href='tekenlijst.asp'>tekenlijst</a>. De tekenlijst opent in een nieuw venster dat u direct kunt afdrukken. Gebruik hiervoor het menu "bestand -> afdrukken" of de toetscombinatie "CTRL+P".
</div>

<a class="knop" onclick="confirmPost()" href="#">Klik hier om de woonwensen te bevestigen</a>&nbsp;&nbsp;
<a class="knop" target="_blank" href="tekenlijst.asp">Klik hier om de tekenlijst te openen</a>
<p>
Hier ziet u  een overzicht van de keuzen die u op dit moment heeft gemaakt, maar die nog niet door u zijn bevestigd.
<%
    sql = "select keunaa, keubes, aantal, prikop, pritot from vw_keuzen where keusoo_soonaa='b' and koppel_id=" & session("bounum_id")
    sql = sql & " and defini=0 and aantal>0"
    fields = "$name:=prikop;type:=text;align:=right;format:=d2;$"
    fields = fields & "$name:=pritot;type:=text;align:=right;format:=d2;$"
    orderby = "keunaa"
    r_list sql, fields, orderby
%>

</p>
<hr />
<p>
Hier ziet u  een overzicht van de keuzen die reeds door u zijn bevestigd.
<%
    sql = "select keunaa, keubes, aantal, prikop, pritot from vw_keuzen where keusoo_soonaa='b' and koppel_id=" & session("bounum_id")
    sql = sql & " and defini=1 and aantal>0"
    
    fields = "$name:=prikop;type:=text;align:=right;format:=d2;wrap:=nowrap;$"
    fields = fields & "$name:=pritot;type:=text;align:=right;format:=d2;$"
    
    orderby = "keunaa"
    r_list sql, fields, orderby
%>
</p>
<a class="Knop" onclick="confirmPost()" href="#">Klik hier om de woonwensen te bevestigen</a>
</div>

<!-- #include file="../../templates/footers/content.asp" -->