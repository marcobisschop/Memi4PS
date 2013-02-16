<%
    function Store(byRef RS, fld)
        on error resume next
        'on error goto 0
        
        'rw linebreak & fld & rs(fld)
        
        select case RS(fld).type
        case 3      'int
            if not isnumeric(fieldvalue(rs, fld)) then 
                rs(fld) = -1
            else
                rs(fld) = clng(fieldvalue(rs, fld))
            end if
        case 11     'bit
            rs(fld) = cbool(checkboxvalue(fieldvalue(rs, fld)))
        case 135    'date
            rs(fld) = c_date(fieldvalue(rs, fld), "iso")
        case 203    'nvarchar(max)
            rs(fld) = fieldvalue(rs, fld)
        case 202    'nvarchar    
            rs(fld) = fieldvalue(rs, fld)
        case else
            rs(fld) = fieldvalue(rs, fld)
        end select        
       
        if err.number <> 0 then 
           ' rw linebreak & "err.description = " & err.description
           ' rw linebreak & "err.number = " & err.number
           ' rw linebreak & "fld.name = " & fld
           ' rw linebreak & "fld.value = " & fieldvalue(rs, fld)

        end if           
        
    end function

    Function LoadRS4Viewstate(viewstate, tablename, pk_name, byref pk_value)
        on error goto 0
        dim rs, sql
        
        select case lcase(viewstate)
        case "new", "savenew"
            sql = "select * from [" & tablename & "] where [" & pk_name & "] = '-1'"
            set rs = getrecordset(sql, false)
            rs.addnew
            pk_value = -1
        case else
            sql = "select * from [" & tablename & "] where [" & pk_name & "] = '" & pk_value & "'"
            set rs = getrecordset(sql, true)
        end select
        set LoadRS4Viewstate = rs
    End Function

    dim linebreak
    linebreak = vbCRLF
    
    function p__r_header(fieldType, label, field)
        p__r_header = "<dt class=""lbl_" & fieldType & " lbl_" & field & """><label for=""" & field & """>" & label & "</label></dt>" & linebreak
    end function
    
    function p__r_error(fieldtype, field)
        if v_informerrors(field) then 
            error_message = err_load(field)
            error_message = "<b> ! please check</b>"
            p__r_error = "<dt class=""error err_" & fieldType & """ name=""err_" & field & """>" & error_message & "</dt>" & linebreak
            p__r_error = "<span style='color: red'>   " & error_message & "</span>" & linebreak
        else
            p__r_error = ""
        end if
    end function
    
    function p__r_getValue(rs, field)
        'uitzondering ivm waarde uit extStudentRequestValue
        'fld start dan met rqvpk en vervolgens de waarde van de primary key
        p__r_getValue = trim(fieldvalue(rs, field))
        if len(p__r_getValue) = 0 then p__r_getValue = viewstate_value(field)
    end function
    
    function p__r_canWrite()
        ret = false
        if s_can("W") then ret = true
        if FORCE_VIEWSTATE_VIEW = TRUE then ret = false
        if viewstate = "view" then ret = false
        p__r_canWrite = ret
    end function
    
    function r_header(hdr)
        'rw "<div class=""r_head"">"
        'rw hdr
        'rw "</div>"
	end function

    function r_label(lbl, description, classname)
        on error resume next
        dim ret, extraHTML
        if classname = "" then classname = "r_"
        getlabel(lbl)
        ret = ""
        ret = ret & p__r_header("label", lbl, lbl)
        r_label = ret
    end function
	
    function r_gender(rs, lbl, fld, classname)
        dim ret
        if classname = "" then classname = "r_textbox"
        r_gender = r_radio(rs, lbl, fld, "vwVariable", "var_pk", "trl_value", "", "", false, 0, "var_object='gender' and var_inreto like '%' and var_available = 1 and trl_language_fk in (1, 1, null)")
        'r_radio (rs, lbl, fld, object, bcolumn, lcolumn, width, classname, translate, lines, filter)
    end function
    
    function r_readonly (rs, lbl, fld, width, classname)
        r_label lbl, "", ""
    end function
    
    function r_labelbox(rs, lbl, fld, width, classname)
        dim value, err_message, ret, disabled
        if width <> "" then width = "width: " & width
        if classname = "" then classname = "r_textbox"
        if lbl = "" then lbl = getlabel(fld) else lbl = getlabel(lbl)
        value = p__r_getValue(rs, fld)
        ret = p__r_header("textbox", lbl, fld)
        ret = ret & "<dd class=""fld_textbox"" name=""fld_" & fld & """>" & linebreak
        if not p__r_canWrite() then 
            if len(value) = 0 or isnull(value) then value="&nbsp;"
            ret = ret & value
        else 
            if len(value) = 0 or isnull(value) then value="&nbsp;"
            ret = ret & value
        end if
        ret = ret & "</dd>" & linebreak
        r_labelbox = ret
    end function
   
    function r_textbox(rs, lbl, fld, width, classname)
        dim value, err_message, ret, disabled
        if width <> "" then width = "width: " & width
        if classname = "" then classname = "r_textbox"
        if lbl = "" then lbl = getlabel(fld) else lbl = getlabel(lbl)
        value = p__r_getValue(rs, fld)
        
        
        
        ret = p__r_header("textbox", lbl, fld)
        ret = ret & "<dd class=""fld_textbox"" id=""fld_" & fld & """ name=""fld_" & fld & """>" & linebreak
        if not p__r_canWrite() then 
            if len(value) = 0 or isnull(value) then value="&nbsp;"
            ret = ret & value
        else 
            ret = ret & "<input class=""" & disabled & """ " & disabled & " id =""" & fld & """ name=""" & fld & """ type=""text"" style=""" & width & """ value=""" & value & """ />" & linebreak
            ret = ret & p__r_error("textbox", fld)
        end if
        ret = ret & "</dd>" & linebreak
        r_textbox = ret
    end function
    
    function r_filebox(rs, lbl, fld, width, classname)
        dim value, err_message, ret, disabled
        if width <> "" then width = "width: " & width
        if classname = "" then classname = "r_textbox"
        if lbl = "" then lbl = getlabel(fld) else lbl = getlabel(lbl)
        value = p__r_getValue(rs, fld)
        ret = p__r_header("textbox", lbl, fld)
        ret = ret & "<dd class=""fld_textbox"" name=""fld_" & fld & """>" & linebreak
         
            ret = ret & "<input class=""" & disabled & """ " & disabled & " id =""" & fld & """ name=""" & fld & """ type=""file"" style=""" & width & """ value="""" />" & linebreak
            ret = ret & p__r_error("textbox", fld)
        
        ret = ret & "</dd>" & linebreak
        r_filebox = ret
    end function    
    
    function r_textbox_default(rs, lbl, fld, width, classname, default_value)
        dim value, err_message, ret, disabled
        if width <> "" then width = "width: " & width
        if classname = "" then classname = "r_textbox"
        if lbl = "" then lbl = getlabel(fld) else lbl = getlabel(lbl)        
        value = p__r_getValue(rs, fld)        
        if not ispostback() and value = "" then value = default_value        
        ret = p__r_header("textbox", lbl, fld)
        ret = ret & "<dd class=""fld_textbox"" id=""fld_" & fld & """ name=""fld_" & fld & """>" & linebreak
        if not p__r_canWrite() then 
            if len(value) = 0 or isnull(value) then value="&nbsp;"
            ret = ret & value
        else 
            ret = ret & "<input class=""" & disabled & """ " & disabled & " id =""" & fld & """ name=""" & fld & """ type=""text"" style=""" & width & """ value=""" & value & """ />" & linebreak
            ret = ret & p__r_error("textbox", fld)
        end if
        ret = ret & "</dd>" & linebreak
        r_textbox_default = ret
    end function
    
   function r_textarea(rs, lbl, fld, width, height, classname, fld_name_extension)
        dim value, err_message, ret, disabled
        if width <> "" then width = "width: " & width
        if height <> "" then height = "height: " & height        
        if classname = "" then classname = "r_textarea"
        if lbl = "" then lbl = getlabel(fld) else lbl = getlabel(lbl)        
        value = p__r_getValue(rs, fld)
        ret = p__r_header("textarea", lbl, fld)        
        ret = ret & "<dd class=""fld_textarea"" name=""fld_" & fld & """>" & linebreak
       
        if not p__r_canWrite() then 
            if len(value) = 0 or isnull(value) then value="&nbsp;"
            ret = ret & value
      
        else            
            if len(fld_name_extension)>0 then fld = fld & "@" & fld_name_extension
            ret = ret & "<textarea class=""" & disabled & """ " & disabled & " name=""" & fld & """ type=""text"" style=""" & width & "; " & height & """>" & value & "</textarea>" & linebreak
            ret = ret & p__r_error("textarea", fld)
        end if
        ret = ret & "</dd>" & linebreak        
        r_textarea = ret
    end function
   
    function r_htmlarea(rs, lbl, fld, width, height, classname, fld_name_extension)
        dim value, err_message, ret, disabled
        if width <> "" then width = "width: " & width
        if height <> "" then height = "height: " & height
        
        if classname = "" then classname = "r_textarea wymeditor"
        if lbl = "" then lbl = getlabel(fld) else lbl = getlabel(lbl)
        value = p__r_getValue(rs, fld)
        ret = p__r_header("textarea", lbl, fld)
        ret = ret & "<dd class=""fld_textarea"" name=""fld_" & fld & """>" & linebreak
        if not p__r_canWrite() then 
            ret = ret & value
            ret = ret & "<input class=""" & classname & """ " & disabled & " id=""" & fld & """ name=""" & fld & """ type=""hidden"" value=""" & value & """ />" & linebreak
        else            
            if len(fld_name_extension)>0 then fld = fld & "@" & fld_name_extension
            ret = ret & "<textarea class=""" & classname & """ " & disabled & " id=""" & fld & """ name=""" & fld & """ type=""text"" style=""" & width & "; " & height & """>" & value & "</textarea>" & linebreak
            SCRIPT_ACTIONS = SCRIPT_ACTIONS & " $('#" & fld & "').wysiwyg();" & linebreak
        end if
        ret = ret & p__r_error("textarea", fld)
        ret = ret & "</dd>" & linebreak
        r_htmlarea = ret
    end function
   
    function r_datebox(rs, lbl, fld, width, classname, startdate)
        dim value, err_message, ret, disabled
        'if width <> "" then width = "width: " & width
        if classname = "" then classname = "r_textbox"
        if startdate = "" then startdate = "01/01/1900"
        if trim(lbl) = "" then lbl = getlabel(fld) else lbl = getlabel(lbl)
        
        value = p__r_getValue(rs, fld)
        
        if viewstate="new" or viewstate="savenew" and not isPostback() then
            value = year(now) & "-" & month(now) & "-" & day(now)
        end if
        value = c_date(value, "ddmmyyyy")
        ret = p__r_header("textbox", lbl, fld)
        ret = ret & "<dd class=""fld_textbox"" name=""fld_" & fld & """ >" & linebreak
        if not p__r_canWrite() then  
            ret = ret & value
            ret = ret & "<input class=""" & disabled & """ " & disabled & " name=""" & fld & """ id=""" & fld & """ type=""hidden"" value=""" & value & " "" />" & linebreak
        else 
            readonly = ""
            ret = ret & "<input class=""datepicker"" id=""" & fld & """ name=""" & fld & """ type=""text"" style=""width: 80px"" value=""" & value & """ /> <i class='remark'>dd-mm-yyyy</i>" & linebreak
            ret = ret & "<a href=""#"" onclick=""openWindow('/admin/help/default.asp?url="&current_url&"#datepicker', 'width:300px, height:300px;')"">?</a>"
            SCRIPT_ACTIONS = SCRIPT_ACTIONS & linebreak & "  $(""#"  & fld & """).datepicker({ dateFormat: 'dd/mm/yy', showWeek: true, firstDay: 1, changeMonth: true, changeYear: true }); "
            '$(""#"  & fld & """).datepicker('option', 'duration', 'fast');" & linebreak
            
        end if
        ret = ret & p__r_error("textbox", fld)            
        ret = ret & "</dd>" & linebreak
        
       
        r_datebox = ret
    end function   
    
    function r_timebox(rs, lbl, fld, width, classname, starttime)
        on error resume next
        dim value, err_message, ret, disabled
        if width <> "" then width = width else width = "50px"
        if classname = "" then classname = "r_textbox"
        if lbl = "" then lbl = getlabel(fld) else lbl = getlabel(lbl)
        
        value = p__r_getValue(rs, fld)
        
        if viewstate="new" or viewstate="savenew" and not isPostback() then
            value = DefaultValue (s_domainid(), fld)
            if value="-999" then
                value = right("00" & hour(now)+1,2) & ":" & right("00" & minute(now),2) & ""
            end if
        elseif not ispostback() then
            value = right("00" & hour(value),2) & ":" & right("00" & minute(value),2) & ""
        end if
        ret = p__r_header("textbox", lbl, fld)
        ret = ret & "<dd class=""fld_textbox"" name=""fld_" & fld & """>" & linebreak
        if not p__r_canWrite() then  
            ret = ret & value
            ret = ret & "<input class="" " & disabled & """ " & disabled & " name=""" & fld & """ type=""hidden"" style=""" & width & """ value=""" & value & """ />" & linebreak
        else 
            readonly = ""
            ret = ret & "<input class="""" id=""" & fld & """ name=""" & fld & """ type=""text"" style=""width: " & width & """ value=""" & value & """ />" & linebreak
            ret = ret & p__r_error("textbox", fld)
            SCRIPT_ACTIONS = SCRIPT_ACTIONS & linebreak & "  $('#" & fld & " ').timePicker();"
        end if
        ret = ret & "</dd>" & linebreak
        r_timebox = ret
    end function   
    
    function r_datetimebox(rs, lbl, fld, width, classname, startdate)
        dim value, err_message, ret, disabled
        if width <> "" then width = "width: " & width
        if classname = "" then classname = "r_textbox"
        if startdate = "" then startdate = "01/01/1900"
        if lbl = "" then lbl = getlabel(fld) else lbl = getlabel(lbl)
        value = p__r_getValue(rs, fld)
        date_value = c_date(value, "ddmmyyyy")
        if ispostback then 
            time_value = fieldvalue(rs, fld & "_time")
        else
            time_value = c_date(value, "hhmm")
        end if
        ret = p__r_header("textbox", lbl, fld)
        ret = ret & "<dd class=""fld_textbox"" name=""fld_" & fld & """>" & linebreak
        if not p__r_canWrite() then 
            ret = ret & value
            ret = ret & "<input class=""date-pick " & disabled & """ " & disabled & " name=""" & fld & """ type=""hidden"" style=""" & width & """ value=""" & value & """ />" & linebreak
        else 
            readonly = ""
            ret = ret & "<input class=""date-pick"" readonly name=""" & fld & """ type=""text"" style=""width: " & width & """ value=""" & date_value & """ />" & linebreak
            ret = ret & "<input class=""time-pick"" name=""" & fld & "_time"" type=""text"" style=""width: " & width & """ value=""" & time_value & """ />" & linebreak
            ret = ret & "<script type=""text/javascript"" charset=""utf-8"">"
            ret = ret & "  $(function(){$("".date-pick"").datePicker().dpSetStartDate(""" & c_date(startdate,"ddmmyyyy") & """);});"
            ret = ret & "</script>"
        end if
        ret = ret & "</dd>" & linebreak
        ret = ret & p__r_error("textbox", fld)
        r_datetimebox = ret
    end function  
    
    'SQL: The query used to populate the select field
    'lbl: Label
    'object: The table from which to get data from
    'fld: The HTML name and id used
    'bcolumn: The DB column for the option value
    'lcolumn: The DB column for the option text
    'bcolumn_fk: Pre selected value
    'translate: Whether or not the text value is send trough getlabel
    'lines: Not actually used..
    function r_radio (rs, lbl, fld, object, bcolumn, lcolumn, width, classname, translate, lines, filter)
        dim value, err_message, ret, disabled, sql, rsSelect
        if translate <> false then translate = true
        if width <> "" then width = "" & width
        
        if classname = "" then classname = "r_select"
        if object = "" then 
            ret = getlabel("invalid_syntax") & ": r_select (rs, lbl, fld, object, bcolumn, lcolumn, width, classname, translate, lines, filter)"
            r_radio = ret
            exit function
        end if
        if lbl = "" then lbl = getlabel(fld) else lbl = getlabel(lbl)
        value = p__r_getValue(rs, fld)
        if len(value)=0 then value=-1
        ret = p__r_header("select", lbl, fld)
        ret = ret & "<dd class=""fld_select"" name=""fld_" & fld & """>" & linebreak
        if not p__r_canWrite() then 
            ret = ret & dblookup(object, bcolumn, value, lcolumn)
            ret = ret & "<input class=""" & disabled & """ " & disabled & " name=""" & fld & """ type=""hidden"" style=""width: " & width & """ value=""" & value & """ />" & linebreak
        else 
            sql = "select [" & bcolumn & "],[" & lcolumn & "] from [" & object & "] "
            if len(filter)>0 then sql = sql & " where (" & filter & ")"
           
            dim gRs, id
            set gRs = getrecordset(sql ,true)
            
            id = 0
            with gRs
                do until .eof
                    value = .fields(lcolumn)
                    if translate then value = getlabel(.fields(lcolumn))
                    if clng(bcolumn_fk) = .fields(bcolumn) then selected = "selected" else selected = ""
                    ret = ret & "<input class=""radio"" name=""" & fld & """ type=""radio"" " & selected & " value=""" & .fields(bcolumn) & """ id=""" & fld & "_" & id & """  /><label for=""" & fld & "_" & id & """>" & value & "</label>" & linebreak
                    id = id + 1
                    .movenext
                loop
            end with
            set rs = nothing            
        end if
        ret = ret & "</dd>" & linebreak
        
        ret = ret & p__r_error("select", fld)
        
        r_radio = ret
    end function
    
    'SQL: The query used to populate the select field
    'lbl: Label
    'object: The table from which to get data from
    'fld: The HTML name and id used
    'bcolumn: The DB column for the option value
    'lcolumn: The DB column for the option text
    'bcolumn_fk: Pre selected value
    'translate: Whether or not the text value is send trough getlabel
    'lines: Not actually used..
    function r_select (rs, lbl, fld, object, bcolumn, lcolumn, width, classname, translate, lines, filter)
        'on error resume next
        dim value, err_message, ret, disabled, sql, rsSelect        
        
        if translate = "true" then translate = true else translate=false
        
        'if translate <> false then translate = true else translate=false        
        
        if fld = "ord_shippingaddress_fk" then translate = false        
        'if width <> "" then width = "width: " & width        
        if classname = "" then classname = "r_select"
        if object = "" then 
            ret = getlabel("invalid_syntax") & ": r_select (rs, lbl, fld, object, bcolumn, lcolumn, width, classname, translate, lines, filter)"
            r_select = ret
            exit function
        end if            
        if lbl = "" then lbl = getlabel(fld) else lbl = getlabel(lbl)        
        value = p__r_getValue(rs, fld)    
        
        if viewstate="new" or viewstate="savenew" and not isPostback() then
            if not rs.eof then
                if len(rs.fields(fld))>0 then 
                    value = rs.fields(fld)        
                else
                    value = DefaultValue (s_domainid(), fld)
                end if
            else
                value = DefaultValue (s_domainid(), fld)
            end if
        end if
            
        if len(value)=0 then value=-1        
        ret = p__r_header("select", lbl, fld)        
        ret = ret & "<dd class=""fld_select"" name=""fld_" & fld & """>" & linebreak
        if not p__r_canWrite() then  
            if translate then
                ret = ret & getlabel(dblookup(object, bcolumn, value, lcolumn))
                ret = ret & "<input class=""" & disabled & """ " & disabled & " id=""" & fld & """ name=""" & fld & """ type=""hidden"" style=""" & width & """ value=""" & value & """ />" & linebreak
            else
                ret = ret & dblookup(object, bcolumn, value, lcolumn)
                ret = ret & "<input class=""" & disabled & """ " & disabled & "id=""" & fld & """ name=""" & fld & """ type=""hidden"" style=""" & width & """ value=""" & value & """ />" & linebreak
            end if
        else 
            sql = "select [" & bcolumn & "],[" & lcolumn & "] from [" & object & "]"
            if len(filter)>0 then sql = sql & " where (" & filter & ")"
            
            if lcase(object) = "vwvariable" then 
                sql = sql & " order by [var_order]"                  
            else
                sql = sql & " order by [" & object & "].[" & lcolumn & "]"   
            end if
            
            'rw linebreak & "r_select " & fld & " = " & value & linebreak
            
            ret = ret & r_dropdown (sql, fld, bcolumn, lcolumn, value, translate, lines, width)
            ret = ret & p__r_error("select", fld)
        end if
        ret = ret & "&nbsp;</dd>" & linebreak        
        r_select = ret
    end function   
    
    function r_dropdown (sql, fld, bcolumn, lcolumn, bcolumn_fk, translate, lines, width)
        on error resume next
        on error goto 0
        dim rsDD, value
        set rsDD = getrecordset(sql ,true)
        
        'rw "<br> fld = " & fld & " , " & sql & "</br>"
        
        'rw lines
        
        if width = "" then width = "350px"

        if not isnumeric(lines) then lines=0
                    
        if cint(lines)>1 then
            ret = ret & "<select multiple size='"& lines &"' style='width: "  & width & "' class=""" & disabled & """ " & disabled & " id=""" & fld & """ name=""" & fld & """>" & linebreak
        else
            ret = ret & "<select style='width: "  & width & "' class=""" & disabled & """ " & disabled & " id=""" & fld & """ name=""" & fld & """>" & linebreak
        end if
        with rsDD
            if .eof then
                ret = ret & "<option value=""-1"">" & getlabel("empty_list") & "</option>"
            else
                ret = ret & "<option value=""-1"">" & getlabel("choose_from_list") & "</option>"
            end if                    
            
            do until .eof
                on error resume next
                value = fieldvalue(rsDD, trim(lcolumn))
                if len(value)=0 then value = .fields(lcolumn)
                on error goto 0
                if fld = "ord_shippingaddress_fk" then translate = false
                if cbool(translate) then value = getlabel(.fields(lcolumn))
                on error resume next
                dim sumofkeys
                sumofkeys = bcolumn_fk - .fields(bcolumn)
                if not isnumeric(sumofkeys) then sumofkeys = -1
                if sumofkeys<0 then sumofkeys=-1
                if clng(bcolumn_fk) - clng(.fields(bcolumn)) = 0 then 
                    selected = " SELECTED " '& bcolumn_fk & "-" & .fields(bcolumn) 
                else 
                    selected = " "
                end if
                on error goto 0
                if debug_mode and s_domainid()=3 then value = value & " (" & .fields(bcolumn) & ")"
                ret = ret & "<option  value=""" & .fields(bcolumn) & """" & selected & ">" & value & "</option>" & linebreak
                .movenext
            loop
        end with
        set rsDD = nothing            
        ret = ret & "</select>" & linebreak
        
        if debug_mode then
            ret = ret & " <a title='##set_as_default##' href=""javascript: document.location = '/include/setdefault.asp?fld=" & fld & "&value=' + document.getElementById('" & fld & "').value"">+</a>"
        end if
        
        r_dropdown = ret
        if err.number <> 0 then
        '    r_dropdown = err.description & ":" & lcolumn & ":" & bcolumn & ":" & bcolumn_fk & ":" 
        end if
        
    end function
    
    function r_variable (lbl, fld,  var_inreto, var_object, vai_inreto_fk)
        dim value, err_message, ret, disabled
        if width <> "" then width = "width: " & width
        if classname = "" then classname = "r_textbox"
        if lbl = "" then lbl = getlabel(fld) else lbl = getlabel(lbl)
        
        ret = p__r_header("textbox", lbl, fld)
        ret = ret & "<dd class=""fld_textbox"" name=""fld_" & fld & """>" & linebreak
        
        dim sql
        if translate <> false then translate = true
        sql = "select * from vwvariable where var_inreto='"&var_inreto&"' and var_object='"&var_object&"' order by var_order, var_code"
        
        dim rs
        set rs = getrecordset(sql ,true)
        ret = ret & "" & linebreak
        with rs
            if .eof then
                ret = ret & getlabel("empty_list")
            else
                sqlVI = "select * from vwVariableInreto where var_inreto='"&var_inreto&"' and var_object='"&var_object&"' and vai_inreto_fk=" & vai_inreto_fk
                
                
                set rsVI = getrecordset(sqlVI, true)
                
                do until .eof
                    value = getlabel(.fields("var_code"))
                    
                    'Kijken of deze koppeling al bestaat en is gekozen
                    dim sqlVI, rsVI
                    
                    with rsVI
                        if not .eof then
                            do until .eof
                                if .fields("var_pk") = rs.fields("var_pk") then
                                    checked = " CHECKED=""yes"" "
                                    exit do
                                else
                                    checked = " "
                                end if
                                .movenext
                            loop
                            .movefirst
                        end if
                    end with
                
                    ret = ret & "<input id=""" & fld & """ name=""" & fld & """ " & checked & " style=""width: 15px"" type=""checkbox"" value=""" & .fields("var_pk") & """>" & value & "&nbsp;"
                    .movenext
                loop
                set rsVI = nothing
            end if
        end with
        set rs = nothing            
        ret = ret & "" & linebreak
        
        ret = ret & "</dd>" & linebreak
        ret = ret & p__r_error("textbox", fld)
        r_variable = ret
        
    end function
    
    function r_links (sql, link, lcolumn, translate, header, footer, prefix, postfix)
        on error goto 0
        dim rs, myLink, myValue, ret
        ret = ""
        set rs = getrecordset(sql, true)
        with rs
            if not .eof then
                ret = ret & header
                do until .eof
                    myLink = link
                    r_link rs, myLink
                    myValue = .fields(lcolumn)
                    if cbool(translate) then myValue = "##" & myValue & "##"
                    ret = ret & prefix & "<a href='" & myLink & "'>" & myValue & "</a>" & postfix
                    .movenext
                loop
                ret = ret & footer
            else            
            end if
        end with
        set rs = nothing
        r_links = ret
    end function
    
        
    function r_formheader()
        dim ret
        ret = dblookup("appTemplate","tpl_name","form_header","tpl_body")        
        ret = replace(ret, "__SCRIPT_NAME__", Request.ServerVariables("script_name"))
        ret = replace(ret, "__viewstate__", viewstate)
        ret = replace(ret, "__recordid__", Request.ServerVariables("recordid"))
        ret = replace(ret, "__idfield__", Request.ServerVariables("idfield"))
        ret = replace(ret, "__refurl__", Request.ServerVariables("refurl"))
        r_formheader = ret
    end function
    
    function r_formfooter()
        r_formfooter = dblookup("appTemplate","tpl_name","form_footer","tpl_body")        
    end function
    
    function r_form_ftr()
        %>
        <script type="text/javascript" text="text/javascript">
        function post_form(action) {
            switch (action) {
            case "edit":
                document.forms["edit"].viewstate.value=""edit"";
                document.forms["edit"].submit();
            case "save":
                document.forms["edit"].submit();
            default: 
                break;
            }
        }
        </script>
        </form>
        <%
    end function
    
    '-----------
    'Toegevoegd door DTr
    '-----------
    function r_checkbox(rs, lbl, fld, classname)
        dim value, err_message, ret, disabled, checked
        if classname = "" then classname = "r_checkbox"
        if lbl = "" then lbl = getlabel(fld) else lbl = getlabel(lbl)
        
        value = p__r_getValue(rs, fld)
        
        on error resume next
        if isnull(value) then
            checked = ""
        elseif cbool(checkboxvalue(value)) = true then
            checked="checked"
        else
            checked=""
        end if
        'if err.number <> 0 then 'rw "r_checkbox value = [" & value & "]"
        
        ret = p__r_header("checkbox", lbl, fld)
        ret = ret & "<dd class=""fld_checkbox"" name=""fld_" & fld & """>" & linebreak
        
        if viewstate = "view" or not s_can("W") then 
            ret = ret & "<input class=""checkbox""" & disabled & """ disabled name=""" & fld & """ type=""checkbox"" " & checked & " />" & linebreak
        else            
            ret = ret & "<input class=""checkbox""" & disabled & """ " & disabled & " name=""" & fld & """ type=""checkbox"" " & checked & " />" & linebreak
        end if
        ret = ret & "</dd>" & linebreak
        
        ret = ret & p__r_error("checkbox", fld)
        r_checkbox = ret
    end function
%>

