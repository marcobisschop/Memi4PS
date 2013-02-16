<!-- #include file="../../templates/headers/content.asp" -->
<%

    f_header getlabel("Loting")

%>
<div style="margin-bottom: 20px; padding-top: 10px; padding-left: 10px; padding-right: 10px; padding-bottom: 10px; width: 100%">
<b>U heeft een keuze gemaakt.</b>
<p>
 Nu dient u deze keuze te bevestigen. <br />
Doe dit alleen wanneer u zeker bent van uw keuze, want na bevestiging kunt u geen wijzigingen meer aanbrengen.
</p>
</div>
    
<%
        dim rs, sql, bounum_id
        bounum_id = viewstate_value("bounum_id")
        
        dim confirmed
        confirmed = len(viewstate_value("confirmed"))>0
        
        if confirmed then
            if not isnumeric(bounum_id) then
            
            else
                sql = "select * from vw_prodee where projec_id=" & session("projec_id") & " and relati_id=" & session("relati_id")
                set rs = getrecordset(sql, true)
                
                with rs
                   if not .eof then
                        dim prodee_id
                        prodee_id = .fields("prodee_id")
                        sql = "update prodee set edited=getdate(), editedby=" & session("relati_id") & ", status_id = (select id from status where inreto='prodee' and stanaa='c'), voorkeur = " & bounum_id & " where id=" & prodee_id
                        executesql sql
                        %>
                        <div style="padding: 15px 15px 15px 15px">
                            Uw keuze is definitief.
                            <br />
                           Maak een keuze uit het menu om verder te gaan. 
                        </div>
                        <%
                   else
                    response.Write sql 
                   end if 
                end with
                
                set rs = nothing
            end if        
        else
        f_form_hdr()
        %>
        <input type="hidden" id="bounum_id" name="bounum_id" value="<%=bounum_id %>" />
        <div style="padding: 15px 15px 15px 15px">
            Gekozen kavel/bouwnummer: <b><%=dblookup("vw_bounum", "bounum_id", bounum_id, "extnum") %></b>
            <br/><br />
            <input type="checkbox" id="confirmed" name="confirmed"/>Ik wil mijn keuze definitief maken.
            <br />
        </div>
        <%
        f_form_ftr()        
        end if
         
%>


<!-- #include file="../../templates/footers/content.asp" -->
