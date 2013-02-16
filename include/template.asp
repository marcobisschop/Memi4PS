<%  
    function TemplateWriteNC(tpl)
    
        'rw "script_actions = " & SCRIPT_ACTIONS
    
        'TemplateCleanup tpl
        'TemplateReplace tpl, "//__SCRIPT_ACTIONS__//", SCRIPT_ACTIONS
        
        'tpl = "<div>Save state: " & dbs_retrieve_session ("", "save_state") & "<br>" & formerrors & "</div>" & tpl       
        
        dim save_state
        save_state = lcase(dbs_retrieve_session ("", "save_state"))
        
        select case save_state
        case "ok"
            templatereplace tpl, "<!--//__save_state__//-->", loadtemplatedb("","save_state_ok")
        case "nok"
            templatereplace tpl, "<!--//__save_state__//-->", loadtemplatedb("","save_state_nok")
        end select
        
        dbs_input_session "", "save_state", ""
        
        rw tpl
    end function
    
  
    function TemplateWrite(tpl)
    
       ' rw "script_actions = " & SCRIPT_ACTIONS
    
    
        TemplateCleanup tpl
        
        if not s_can("W") then
            SCRIPT_ACTIONS = SCRIPT_ACTIONS & " $('.headerButtons').html(""<span style='color: red'>" & getlabel("readonly") & "</span>"");" & linebreak
        end if
        
        TemplateReplace tpl, "//__SCRIPT_ACTIONS__//", SCRIPT_ACTIONS
        
        'tpl = "<div>Save state: " & dbs_retrieve_session ("", "save_state") & "<br>" & formerrors & "</div>" & tpl       
        
        dim save_state
        save_state = lcase(dbs_retrieve_session ("", "save_state"))
        
        select case save_state
        case "ok"
            templatereplace tpl, "<!--//__save_state__//-->", loadtemplatedb("","save_state_ok")
        case "nok"
            templatereplace tpl, "<!--//__save_state__//-->", loadtemplatedb("","save_state_nok")
        end select
        
        dbs_input_session "", "save_state", ""
        
        
        
        rw tpl
    end function
    
    function TemplateCleanup(byref tpl)
        dim pattern, re, match, matches
        set re = new regexp
        re.pattern = "\$[^\$]*\$"
        re.Global=true
        re.IgnoreCase=true
        set matches = re.Execute(tpl)
        for each match in matches
           if match.value = "$$" then
               tpl = replace(tpl, match.value, "$")           
           else
               fldname = mid(match.value,2,len(match.value)-2)
               value = viewstate_value(fldname)
               tpl = replace(tpl, match.value, value)           
           end if
        next
        set re = nothing
    end function        

    function TemplateExists(tpl_name)
         tpl = dblookupTemplate("appTemplate", "tpl_name", "'" & lcase(tpl_name) & "'" , "tpl_body")
         if tpl = "" then TemplateExists = False else TemplateExists = True         
    end function

    function Template2Code(tpl)
        TemplateReplace tpl, "<", "&lt;"
        TemplateReplace tpl, ">", "&gt;"
        TemplateReplace tpl, chr(13), "<br>"        
        TemplateReplace tpl, chr(9), "&nbsp;&nbsp;&nbsp;"        
        Template2Code = tpl
    end function

    function TemplateForType (typ_code, tpl)
        dim sql, rs, tpl_name
        tpl_name = trim(tpl & "_" & typ_code)
        if TemplateExists(tpl_name) then
            TemplateForType = loadtemplateDB("", tpl_name)
        else
            TemplateForType = loadtemplateDB("", tpl)
        end if
        TemplateForType = TemplateForType '& tpl_name
    end function

    function loadTemplateDB (byref tpl, tpl_name)
        dim ret, sql, rs
        if tpl="" then
            'default_page
            sql = "exec aspTemplate_load '" & tpl_name & "', " & s_domainid()
            set rs = getrecordset(sql, true)
            with rs
                if .eof then
                    tpl = "~" & tpl_name & "~"
                else
                    tpl = .fields("tpl_body")
                end if
            end with
            set rs = nothing            
        end if
        dim pattern, re, match, matches
        set re = new regexp
        re.pattern = "\%%[^\%%]*\%%"
        re.Global=true
        re.IgnoreCase=true
        set matches = re.Execute(tpl)
        for each match in matches
           fldname = mid(match.value,3,len(match.value)-4)
           tpl = replace(tpl, match.value, loadTemplateDB ("", fldname))
        next
        set re = nothing        
        tpl = replace(tpl, "~my_language~", myLanguage())
        loadTemplateDB = tpl
    end function
    
    function loadTemplateDBInreto (byref tpl, tpl_inreto, tpl_inreto_fk)
        dim ret
        if tpl="" then
            tpl = dblookupfilter("appTemplate", "tpl_inreto='" & tpl_inreto & "' and tpl_inreto_fk=" & tpl_inreto_fk , "tpl_body")
        end if
        dim pattern, re, match, matches
        set re = new regexp
        re.pattern = "\%%[^\%%]*\%%"
        re.Global=true
        re.IgnoreCase=true
        set matches = re.Execute(tpl)
        for each match in matches
           fldname = mid(match.value,3,len(match.value)-4)
           tpl = replace(tpl, match.value, loadTemplateDB ("", fldname))
        next
        set re = nothing        
        loadTemplateDBInreto = tpl
    end function
    
    sub TemplateForm (byref tpl)
        'This function onlye works when the used paramters are globally defined in the calling page
        TemplateReplace tpl, "__script_name__", session("script_name")
        TemplateReplace tpl, "__viewstate__", viewstate
        TemplateReplace tpl, "__recordid__", recordid
        TemplateReplace tpl, "__idfield__", idfield
        TemplateReplace tpl, "__refurl__", refurl
    end sub
    
    sub TemplateFormAddField (byref tpl, type_, name, value)
        select case type_
        case "select"
        case else
            tpl = replace(tpl,"<!--formfields-->","<input type='" & type_ & "' name='" & name & "' value='" & value & "'/><!--formfields-->", 1, -1, 1)
        end select            
    end sub

    sub TemplateReplace (byref tpl, find, replacement_)
        dim Replacement
        select case lcase(find)
        case "__my_info__"
            Replacement = replacement_ & "<br><br><h1>" & s_domainname() & "</h1><p><a href='/admin/crm/contacts/default.asp?viewstate=edit&con_pk=" & s_userid() & "'>" & s_fullname() & "</a></p>"
            Replacement = Replacement & "<p>" & request.ServerVariables("remote_host") & "</p>"
            'Replacement = Replacement & "<p>##app_name:##" & s_applicationname() & "<br/>"
            'Replacement = Replacement & "##rol_name:##" & s_rolename() & "<br/>"
            'Replacement = Replacement & "##mod_name:##" & s_modulename() & "<br/>"
            'Replacement = Replacement & "##rights:##" & s_rights() & "<br/>"
            'Replacement = Replacement & "##DB Calls:##" & myDatabaseCalls & "<br/>"
            'Replacement = Replacement & "##Language:##" & myLanguage & "<br/>"
            'Replacement = Replacement & "##Session:##" & Session("SessionID") & "<br/>"
            'Replacement = Replacement & "##login_time:##" & dbs_starttime("") & "</p>"
            TemplateTranslate ReplaceMent
            if s_userid() >0 then 
                tpl = replace(tpl, find, Replacement, 1, -1, 1)
            else
                tpl = replace(tpl, find, replacement_, 1, -1, 1)
            end if                
        case else
            tpl = replace(tpl, find, replacement_, 1, -1, 1)
        end select            
    end sub

    sub TemplateParseSQL (byref tpl, sql)
        dim rs
        set rs = getrecordset(sql, true)
        TemplateParseRS tpl, rs
        set rs = nothing
    end sub

    sub TemplateParseRS (byref tpl, rs)
        on error resume next
        dim pattern, re, match, matches
        set re = new regexp
        re.pattern = "\$[^\$]*\$"
        re.Global=true
        re.IgnoreCase=true
        set matches = re.Execute(tpl)
        for each match in matches
           fldname = mid(match.value,2,len(match.value)-2)
           
           select case RS(fldname).type
            case 3      'int
                value = clng(rs.fields(fldname))
            case 11     'bit
                value = cbool(rs.fields(fldname))
            case 135    'date
                value = c_date(rs.fields(fldname), "ddmmyyyy")
            case 203    'nvarchar(max)
                value = rs.fields(fldname)
            case 202    'nvarchar    
                value = rs.fields(fldname)
            case else
                value = rs.fields(fldname)
           end select
           
           
           'rw "domain_filer = " & s_domain_filter_for_dropdowns()
           
           if lcase(fldname) = "domain_filter" then value = s_domain_filter_for_dropdowns()
           if lcase(fldname) = "dom_name" then value = s_domainname()
           if lcase(fldname) = "dom_pk" then value = s_domainid()
           if lcase(fldname) = "s_companyid" then value = s_companyid()
           if lcase(fldname) = "s_userid" then value = s_userid()
           if lcase(fldname) = "s_fullname" then value = s_fullname()
           if lcase(fldname) = "pagesize" then value = csPageSize
           
 '          if instr(0,fldname,"_www") > 0 Then value = TemplateFormat(value, "URL")  
           if len(value)>0 then 
            tpl = replace(tpl, match.value, value) 
           'else
           ' tpl = replace(tpl, match.value, "") 
           
           'rw "<br/>" & match.value & " = " & value
           
           end if
           value = ""          
        next
        set re = nothing
    end sub
    
    Sub TemplateReplaceGlobals (byRef tpl)
       TemplateReplace tpl, "$domain_filter$", s_domain_filter_for_dropdowns()
       TemplateReplace tpl, "$dom_name$", s_domainname()
       TemplateReplace tpl, "$dom_pk$", s_domainid()
       TemplateReplace tpl, "$s_companyid$", s_companyid()
       TemplateReplace tpl, "$s_userid$", s_userid()
       TemplateReplace tpl, "$s_fullname$", s_fullname()
       TemplateReplace tpl, "$pagesize$", csPageSize
    End Sub
    
    
    Function TemplateFormat(Value, Format)
        dim ret
        select case lcase(format)
        case "url"
            if Value <> "" AND left (Value, 7) <> "http://" then ret = "http://" & Value else ret = value
'ret = value
        end select
        TemplateFormat = ret
    end Function
    
    sub TemplateParseQS (byref tpl)
        on error resume next
        dim pattern, re, match, matches
        set re = new regexp
        re.pattern = "\$[^\$]*\$"
        re.Global=true
        re.IgnoreCase=true
        set matches = re.Execute(tpl)
        for each match in matches
           fldname = mid(match.value,2,len(match.value)-2)
           value = viewstate_value(fldname)
           if len(value)>0 then tpl = replace(tpl, match.value, value)    
        next
        set re = nothing
    end sub
    
    sub TemplateTranslate (byref tpl)
        dim pattern, re, match, matches
        set re = new regexp
        re.pattern = "\##[^\##]*\##"
        re.Global=true
        re.IgnoreCase=true
        set matches = re.Execute(tpl)
        for each match in matches
           fldname = mid(match.value,3,len(match.value)-4)
           tpl = replace(tpl, match.value, getlabel(fldname))
        next
        set re = nothing
        'TemplateParseRS = tpl
    end sub
    
    sub TemplateParseFormFields (byref tpl, rs)
        'on error resume next
        dim pattern, re, match, matches, myField
        set re = new regexp
        re.pattern = "\+[^\+]*\+"
        re.Global=true
        re.IgnoreCase=true
        set matches = re.Execute(tpl)
        for each match in matches
            
            strMatch = mid(match.value,2,len(match.value)-2)
            
            'tpl = tpl & "[" & strMatch & "]<br>"
            
            fld_label = r_param("label", strMatch) 
            fld_id = r_param("id", strMatch) 
            fld_type = r_param("type", strMatch) 
            fld_object = r_param("object", strMatch) 
            fld_bcolumn = r_param("bcolumn", strMatch) 
            fld_lcolumn = r_param("lcolumn", strMatch) 
            fld_width = r_param("width", strMatch) 
            fld_height = r_param("height", strMatch) 
            fld_classname = r_param("classname", strMatch) 
            fld_translate = r_param("translate", strMatch) 
            fld_lines = r_param("lines", strMatch) 
            fld_filter = r_param("filter", strMatch) 
            fld_startdate = r_param("startdate", strMatch) 
            fld_starttime = r_param("starttime", strMatch) 
            fld_fields = r_param("fields", strMatch) 
            fld_orderby = r_param("orderby", strMatch) 
            fld_querystring = r_param("querystring", strMatch) 
            fld_sql = r_param("sql", strMatch) 
            fld_description = r_param("description", strMatch)
            fld_inreto = r_param("inreto", strMatch)
            fld_object = r_param("object", strMatch)
            fld_inreto_fk = r_param("inreto_fk", strMatch)
            fld_link = r_param("link", strMatch)
            fld_header = r_param("header", strMatch)
            fld_footer = r_param("footer", strMatch)
            fld_prefix = r_param("prefix", strMatch)
            fld_postfix = r_param("postfix", strMatch)
            fld_default = r_param("default", strMatch)
            fld_timeframe = r_param("timeframe", strMatch)
            
            fld_year = r_param("year", strMatch)
            fld_month = r_param("month", strMatch)
            fld_day = r_param("day", strMatch)
            fld_nodays = r_param("nodays", strMatch)
            
            select case lcase(trim(fld_type))
            case "dblookupfilter"
                myField  = fld_prefix & DBLookupFilter (fld_table, fld_filter, fld_lcolumn) & fld_postfix
            case "calendar"
                if fld_year = "" then fld_year = myYear
                if fld_month = "" then fld_month = myMonth
                if fld_day = "" then fld_day = myDay             
                if fld_week = "" then fld_week = myWeek
                myField = r_calendar(fld_year, fld_week, fld_month, fld_day, fld_nodays, 3)
                'myField = "r_calendar("&fld_year&", "&fld_month&", "&fld_day&", "&fld_nodays&")"
            case "hidden"
                myField = "<input type='hidden' id='" & fld_id & "' name='" & fld_id & "' value='" & fld_default & "'/>"
            case "chart"
               fld_charttype = r_param("charttype", strMatch)
               fld_title = r_param("title", strMatch)
               fld_xaxistitle = r_param("xAxisName", strMatch)
               myField = r_graph(fld_charttype, fld_width, fld_height, fld_sql, fld_bcolumn, fld_lcolumn, fld_title, fld_xaxistitle)                
            case "graph_ms3d"
                fld_yColumn = r_param("yColumn", strMatch) 
                fld_xColumn = r_param("xColumn", strMatch)
                fld_ValueField = r_param("ValueField", strMatch)
                myField = r_graph_MS3D(fld_sql, fld_yColumn, fld_xColumn, fld_width, fld_height, fld_ValueField)            
            case "overview_link"
               ' myField = "fld_inreto=" & fld_inreto & "<br>fld_object=" & fld_object & "<br>fld_inreto_fk=" & fld_inreto_fk
                myField  = r_overview_link(fld_inreto, fld_inreto_fk, fld_object)
            case "distinctives"
                if len(fld_inreto)=0 then fld_inreto = viewstate_value("inreto")
                if len(fld_inreto_fk)=0 then fld_inreto_fk = viewstate_value("inreto_fk")
                if len(fld_object)=0 then fld_object = viewstate_value("object")
                myField = dis_show_object (fld_inreto, fld_object, fld_inreto_fk)
            case "overview_distinctives"
                myField = r_overview_distinctives (fld_inreto, fld_object, fld_inreto_fk)
  '          case "overview_details_relation"
 '               myField = overview_details_relation (fld_inreto, fld_object, fld_inreto_fk)
            case "overview_depots"
                myField = r_overview_depots (fld_inreto, fld_object, fld_inreto_fk)
            case "overview_appointments"
                myField = r_overview_appointments (fld_inreto, fld_object, fld_inreto_fk, fld_timeframe)
            case "overview_documents"
                myField = r_overview_documents (fld_inreto, fld_object, fld_inreto_fk)
            case "overview_news"
                myField = r_overview_news ()
            case "overview_empty"
                myField = r_overview_empty (fld_inreto, fld_object, fld_inreto_fk)
            case "overview_pri_contacts"
  '              from_where = left (fld_type, instr(fld_type, "_")-1)
                myField = r_overview_pri_contacts (fld_inreto, fld_object, fld_inreto_fk, from_where)
            case "overview_upcoming_courses"
  '              from_where = left (fld_type, instr(fld_type, "_")-1)
                myField = r_overview_upcoming_courses ()
            case "info_pri_contacts"
                myField = r_info_pri_contacts (fld_inreto, fld_object, fld_inreto_fk, from_where)
            case "gender"
                myField = r_gender(rs, fld_label, fld_id, fld_classname)
            case "label"
                myField = r_label(fld_label, fld_description, fld_classname)
                'myField = "213451345"
            case "labelbox"
                myField = r_labelbox(rs, fld_label, fld_id, fld_width, fld_classname)
                'myField = "213451345"
            case "text","input","textbox"
                myField = r_textbox_default (rs, fld_label, fld_id, fld_width, fld_classname, fld_default)
            case "file"
                myField = r_filebox (rs, fld_label, fld_id, fld_width, fld_classname)
            case "default"
                myField = r_textbox_default (rs, fld_label, fld_id, fld_width, fld_classname, fld_default)
            case "checkbox"
                myField = r_checkbox (rs, fld_label, fld_id, fld_classname)
            case "textarea"
                myField = r_textarea (rs, fld_label, fld_id, fld_width, fld_height, fld_classname, fld_name_extension)
            case "htmlarea"
                myField = r_htmlarea (rs, fld_label, fld_id, fld_width, fld_height, fld_classname, fld_name_extension)
            case "datetime"
                myField = r_datetimebox (rs, fld_label, fld_id, fld_width, fld_classname, fld_startdate)
            case "date"
                myField = r_datebox (rs, fld_label, fld_id, fld_width, fld_classname, fld_startdate)
            case "time"
                myField = r_timebox (rs, fld_label, fld_id, fld_width, fld_classname, fld_starttime)
            case "select"
                myField = r_select (rs, fld_label, fld_id, fld_object, fld_bcolumn, fld_lcolumn, fld_width, fld_classname, fld_translate, fld_lines, fld_filter)
            case "dropdown"
                myField = r_dropdown (fld_sql, fld_id, fld_bcolumn, -1, fld_lcolumn, fld_translate, fld_lines, fld_width)
            case "list"      
                'fld_fields = "$name:=ord_pk;type:=text;$" 'this just for test to check if r_param does not render field "fields" properly
                myField = r_list_2 (fld_sql, fld_fields, fld_orderby, fld_id, fld_querystring)
            case "variable"
                myField = r_variable (fld_label, fld_id, fld_inreto, fld_object, fld_inreto_fk)                
            case "links"
                myField = r_links (fld_sql, fld_link, fld_lcolumn, fld_translate, fld_header, fld_footer, fld_prefix, fld_postfix)                
            case else
                tpl = replace(tpl, match.value, "type not defind [" & fld_type & "]")
            end select           
            tpl = replace(tpl, match.value, myField) & ""
        next
        set re = nothing
        'TemplateParseRS = tpl
    end sub
'--------------------------------------------------------------        
    
%>