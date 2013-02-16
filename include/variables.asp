<%
        ' Interface naar table variables.
        ' Hierin staan programma variablen opgesomt
        
function getvariable(name)
    dim rs, sql
    sql = "select * from variables where [name]='" & name & "'"
    set rs = getrecordset(sql,true)
    with rs
        if .eof then
            getvariable = "!! VARIABLE UNDEFINED !! (function:getvariable)"
        else
            getvariable = .fields("value")
        end if
    end with
    set rs = nothing
end function

function getvariablegroup(name)
    dim sql
    sql = "select * from variables where [group]='" & name & "' order by name"
    set getvariablegroup = getrecordset(sql,true)    
end function

%>