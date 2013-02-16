<!-- #include file="../../templates/headers/content.asp" -->
<%
    dim projec_id
    projec_id = session("projec_id")
    
    sql = "exec sp_projec_kruislijst_2"
    
    
%>
<!-- #include file="../../templates/footers/content.asp" -->
