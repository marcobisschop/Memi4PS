<!-- #include file="../templates/headers/content.asp" -->
<% f_header getlabel ("my_methods")%>
<table><tr><td valign=top>
<div style="padding: 10px;">
<%=getlabel ("search_projec_bymethod")%>
<div style="padding: 10px;">
<form target=_top id="search_projec" name="search_projec" action="reporting/report.asp">
    <input type="text" id="searchfor" name="searchfor" />
    <input type="hidden" id=Hidden1 name=immediately value=yes />
    <input type="hidden" id=Hidden2 name=report_id value=32 />
    <input type="submit" value="<%=getlabel("btn_search") %>" />
</form>
</div>

<%=getlabel ("search_bounum_bymethod")%>
<div style="padding: 10px;">
<form target=_top id="search_bounummer" name="search_bounummer" action="reporting/report.asp">
    <input type="text" id="searchfor" name="searchfor" />
    <input type="hidden" id=immediately name=immediately value=yes />
    <input type="hidden" id=report_id name=report_id value=30 />
    <input type="submit" value="<%=getlabel("btn_search") %>" />
</form>
</div>
<%=getlabel ("search_relation_bymethod")%>
<div style="padding: 10px;">
<form target=_top id="search_relations" name="search_relations" action="reporting/report.asp">
    <input type="text" id="searchfor" name="searchfor" />
    <input type="hidden" id=immediately name=immediately value=yes />
    <input type="hidden" id=report_id name=report_id value=29 />
    <input type="submit" value="<%=getlabel("btn_search") %>" />
</form>
</div>
<%=getlabel ("search_contact_bymethod")%>
<div style="padding: 10px;">
<form target=_top id="search_contacts" name="search_contacts" action="reporting/report.asp">
    <input type="text" id="Text1" name="searchfor" />
    <input type="hidden" id=Hidden3 name=immediately value=yes />
    <input type="hidden" id=Hidden4 name=report_id value=28 />
    <input type="submit" value="<%=getlabel("btn_search") %>" />
</form>
</div>
<%=getlabel ("search_deelnemer_bymethod")%>
<div style="padding: 10px;">
<form target=_top id="search_deelnemer" name="search_deelnemer" action="reporting/report.asp">
    <input type="text" id="searchfor" name="searchfor" />
    <input type="hidden" id=immediatly name=immediately value=yes />
    <input type="hidden" id=report_id name=report_id value=35 />
    <input type="submit" value="<%=getlabel("btn_search") %>" />
</form>
</div>
</div>
</td>
<td valign=top>
<%
     f_header getlabel ("my_tasks")
    r_tasks "mytasks", sec_currentuserid()
%>
</td>
</tr></table>
<!-- #include file="../templates/footers/content.asp" -->
