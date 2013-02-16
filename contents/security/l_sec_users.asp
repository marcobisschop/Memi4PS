<!-- #include file="../../templates/headers/content.asp" -->
<%
	f_header getlabel("hdr_users")
	dim sql, fields, orderby

    sql = "select * from relsoo order by soonaa"
    set rs = getrecordset(sql, true)
%>
    <div class=rolodex>
<% 
    with rs
        do until .eof
            response.Write "<a href='?roleid=" & .fields("id") & "'>" 
            response.Write .fields("soonaa")
            response.Write "</a>"
            .movenext
            if not .eof then response.Write "<span class=divider>|</span>"
        loop
    end with
%> 
    <hr />
    <a href="e_sec_users.asp?viewstate=new&amp;id=-1"><%=GetLabel("new")%></a>
    </div>
<%    
    set rs = nothing

	dim roleid
	roleid = viewstate_value("roleid")
	if cint(roleid) > 0 then
	    sql = "select sec_users.* from sec_users where sec_users.roleid=" & roleid 
	    fields = ""
	    fields = fields & "$name:=id;type:=hidden;boundcolumn:=id;$"
	    fields = fields & "$name:=sec_applications_id;type:=hidden;boundcolumn:=id;$"
	    fields = fields & "$name:=created;type:=hidden;$"
	    fields = fields & "$name:=createdby;type:=hidden;$"
	    fields = fields & "$name:=edited;type:=hidden;$"
	    fields = fields & "$name:=editedby;type:=hidden;$"
	    fields = fields & "$name:=aangeb;type:=hidden;$"
	    fields = fields & "$name:=aandat;type:=hidden;$"
	    fields = fields & "$name:=wijgeb;type:=hidden;$"
	    fields = fields & "$name:=wijdat;type:=hidden;$"
	    fields = fields & "$name:=username;type:=hidden;$"
	    fields = fields & "$name:=password;type:=hidden;$"
	    fields = fields & "$name:=locked;type:=hidden;$"
	    fields = fields & "$name:=roleid;type:=hidden;$"
	    fields = fields & "$name:=sec_roles_id;type:=hidden;$"
	    fields = fields & "$name:=editedby;type:=hidden;$"
	    fields = fields & "$name:=password_changed;type:=hidden;$"
	    fields = fields & "$name:=email;type:=email;$"
	    fields = fields & "$name:=fullname;type:=link;url:=e_sec_users.asp?viewstate=view&id=~id~;$"
	    orderby = ""
	    r_list sql, fields, orderby
	else
	    response.write getlabel("select_role")
	end if
	
%>
<!-- #include file="../../templates/footers/content.asp" -->
