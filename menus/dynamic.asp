<%

function menu(parent_id)
    dim ret, sql, rs
    ret = ""
    sec_currentuserid
    sec_currentuserrole_id
    
    sql = sql & " select "
	sql = sql & "     *  "
    sql = sql & " from sec_menus  "
    sql = sql & " where id in ( "
    sql = sql & "     select menuid from sec_rolemenus where relsoo_id = " & sec_currentuserrole_id 
	sql = sql & "     ) "
    sql = sql & " and enabled = 1 "
    sql = sql & " and parentid = " & parent_id
    sql = sql & " order by [order] "
    
    ' response.write sql
    
    set rs = getrecordset(sql, true)
    
    
    
    with rs
        if not .eof then
            do until .eof            
                if .absoluteposition = 1 then response.write "<ul>" & vbcrlf
                
                select case lcase(.fields("name"))
                case "woonwensen"
                    showMenu = true
                case else
                    showMenu = True                                 
                end select
                
                If showMenu = True Then
                    response.write "<li>" & vbcrlf
                    response.write "<a href='" & replace(.fields("href"),"../","/") & "'>"                                
                    response.write getlabel(.fields("name"))
                    response.write "</a>" & vbcrlf
                    menu .fields("id")
                    response.write "</li>"  & vbcrlf        
                else
                    response.write "<li style='color: #000;'>" & vbcrlf
                    response.write getlabel(.fields("name"))
                    response.write "</li>"  & vbcrlf        
                end if
                if .absoluteposition = .recordcount then response.write "</ul>" & vbcrlf
                .movenext                             
                
            loop
        else
            
        end if
    end with
    set rs = nothing    
    'response.write session("language")
end function

function menuAvailable(name)
    menuAvailable = true
end function

%>