<!-- #include file="../templates/headers/content.asp" -->
<% 

    f_header getlabel ("my_tasks")
    r_tasks "mytasks", sec_currentuserid()
    
    r_myprojects sec_currentuserid()
%>
<!-- #include file="../templates/footers/content.asp" -->
