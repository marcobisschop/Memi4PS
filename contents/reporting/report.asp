<!-- #include file="../../templates/headers/content.asp" -->
<!-- #include file="excel.asp" -->
<%
	ON ERROR GOTO 0
	DIM REPORT_ID, RS, SQL, QB
	REPORT_ID = VIEWSTATE_VALUE("REPORT_ID")
	
	rapgro = viewstate_value("rapgro")
	'if rapgro = "" then rapgro = "students"
	%><div class=rolodex><%
	sql = "select distinct [rapgro] from rappor order by [rapgro]"
	set rs = getrecordset(sql ,true)
	with rs 
	    do until .eof
	        %>
	        <a href="le_reports.asp?rapgro=<%=.fields("rapgro") %>"><%=getlabel(.fields("rapgro")) %></a>
	        <%
	        .movenext
	        if not .eof then response.Write "<span class=divider>|</span>"
	    loop
	end with
	set rs = nothing
	%>
	    <span class=divider>|</span>
	    <a style="color: #f00" href='e_reports.asp?viewstate=new&id=-1&rapgro=<%=rapgro %>'><%=getlabel("new") %></a>
	</div><%
	
	QB = VIEWSTATE_VALUE("QB")
	if QB = 1 then
	    'Query opgebouwd met querybuilder. Kan direct uitgevoerd worden!
	    F_HEADER getlabel("qb_my_selection")
	else
	    SQL = "SELECT * FROM rappor WHERE ID=" & REPORT_ID
	    SET RS = GETRECORDSET(SQL, TRUE)
	    F_HEADER rs.fields("rapnaa")
	end if	
	
%>

<script language="javascript">
    function go(action, inreto) {
        field = document.all.checkbox_id;
        document.all.inreto_id.value = '';
        document.all.inreto.value = inreto;
        if (typeof(field.length)=='undefined') {
            document.all.inreto_id.value = field.value + ',';
        } else {
            for (i = 0; i < field.length; i++) {
			    if (field[i].checked == true) document.all.inreto_id.value += field[i].value + ',';
		    }            
        }
		switch (action) {   
            case 'correspondence' :
                form1.action = 'correspondence.asp';
                break;
            case 'email' :
                form1.action = '../messaging/default.asp';
                break;
            case 'pictures' :
                form1.action = '../students/l_pictures.asp';
                break; 
            case 'deelnemen' :
                form1.action = '../projects/add_deelnemers.asp';
                break; 
            case 'prorel' :
                form1.action = '../projects/add_prorel.asp'
                break; 
            case 'toexcel' :
                form1.action = 'selection_to_excel.asp';
                break; 
        }
        document.all.inreto_id.value += '0';
        form1.submit();
    }
</script>
<table style="width:100%" ID="Table1">
<form action="report.asp" method="get" id=form1 name=form1>
<input type="hidden" name="inreto_id" id="inreto_id" value="">
<input type="hidden" name="inreto" id="inreto" value="">
<input type="hidden" id="REPORT_ID" name="REPORT_ID" value="<%=REPORT_ID%>">

<%
    if QB = 1 then
        'Query opgebouwd met querybuilder. Kan direct uitgevoerd worden!
    else 
%>


<%
	f_label rs, "report" ,"rapnaa"
	f_label rs, "description" ,"rapbes"
	
	'Start report	
	
	Dim query, regexp, match, match2, matches, matches2, pattern
	
	query = rs.fields("rapsql")
	set regexp = new regexp
	regexp.Global = true
	regexp.IgnoreCase = true
	regexp.pattern = "\$[^\$]*\$"
	set matches = regexp.Execute(query)
	for each match in matches
		strMatch = mid(match.value,2)
		ptype  = r_param("type",strmatch)
		pname  = r_param("name",strmatch)
		plabel = r_param("label",strmatch)
		
		currentvalue = request(pname)
		select case ptype
		case "same"
		case "input", "date"
		
		
		%>
		<tr>
			<td class=f_item_label><%=getLabel(plabel)%>:</td>
			<td class=f_item_field><input style="width:100%" id="<%=pname%>" name="<%=pname%>" value="<%=currentvalue%>"></td>
		</tr>
		<%			
 		case "select"
 		%>
		<tr>
			<td class=f_item_label><%=getLabel(plabel)%>:</td>
			<td class=f_item_field>
				<select style="width:100%" id="Select1" name="<%=pname%>">
			<%
				renderoptions r_param("sql",strMatch),r_param("listcolumn",strMatch),r_param("boundcolumn",strMatch), currentvalue
			%>
				</select>
			</td>
		</tr>
		<%			
		case "multiselect"
		%>
		<tr>
			<td class=f_item_label><%=getLabel(plabel)%>:</td>
			<td class=f_item_field><select multiple=true style="width:100%;height:100px" size=4 id="Select2" name="<%=pname%>">
			<%
				renderoptions r_param("sql",strMatch),r_param("listcolumn",strMatch),r_param("boundcolumn",strMatch), currentvalue
			%>
			</select></td>
		</tr>
		<%			
		case else
		end select						
	next
	
%>
	<tr>
		<td class=r_field colspan=2>
			<input id="submitgo" name="submitgo" type="submit" value="<%=getLabel("execute")%>">
			<input type=checkbox id="excel" name="excel" <% if fieldvalue(nothing,"excel") = "on" then response.Write " CHECKED" %>><%=getlabel("reporting_toexcel")%>
		</td>
	</tr>
	<input type="hidden" id="immediately" name="immediately" value="<%=request("immediately")%>">
	<input type="hidden" id="postback" name="postback" value="true">



<% 
    end if

%>
</form>
</table>
<%	
	if viewstate_value("postback")="true" or len(viewstate_value("immediately")) > 0 or QB = 1 then	
	
	    ' Voor QueryBuilder
	    if QB = 1 then
	        'Query opgebouwd met querybuilder. Kan direct uitgevoerd worden!
	        'Query is opgeslagen in een sessie variabele
	        query = replace(lcase(session("qb_query")), "[" & lcase(session("qb_inreto_id")) & "]", "[" & session("qb_inreto_id") & "] as [id]",1,1)
	        
	        if not instr(1, lcase(query), lcase(session("qb_inreto_id"))) then
	            query = replace(lcase(query), "select ", " select [" & lcase(session("qb_inreto_id")) & "] as [id], ")
	           
	            if lcase(session("qb_inreto_id")) <> "id" then	           
	                 query = replace(lcase(query), "select ", " select [" & lcase(session("qb_inreto_id")) & "], ")
	            end if
	        end if        
	        
	        'Dummy recordset vullen voor de vervolg functies 
	        
	        ' response.Write lcase(session("qb_inreto")) & "<br>" 
	        ' response.Write lcase(session("qb_inreto_id"))
	        
	         select case lcase(session("qb_inreto"))
	         case "students"
	            ' links = links & "$name:=" & session("qb_inreto_id") & ";type:=hidden;$"  
	            links = links & "$name:=id;type:=checkbox;boundcolumn:=id;$"  	            
	            set rs = getrecordset("select '" & links & "' as links, '" & session("qb_inreto") & "' as inreto"  , true)  
	         case "relations"
	            links = links & "$name:=" & session("qb_inreto_id") & ";type:=hidden;$"  
	            links = links & "$name:=id;type:=checkbox;boundcolumn:=id;$" 
	            set rs = getrecordset("select '" & links & "' as links, '" & session("qb_inreto") & "' as inreto"  , true)  
	         case "relations_contacts"  
	            links = links & "$name:=" & session("qb_inreto_id") & ";type:=hidden;$"  
	            links = links & "$name:=id;type:=checkbox;boundcolumn:=id;$"  
	            set rs = getrecordset("select '" & links & "' as links, '" & session("qb_inreto") & "' as inreto"  , true)  
	         end select 
	        
	         
	        ' response.Write query
	        
	        %>
	        <div style="padding: 5px 5px 5px 5px;">
	            <a href="report.asp?qb=1&excel=on"><%=getlabel("openinexcel") %></a>
	        </div>
	        <%
	         
	    end if
	
		links = rs.fields("links")
		set regexp = new regexp
		regexp.Global = true
		regexp.IgnoreCase = true
		regexp.pattern = "\$[^\$]*\$"
		set matches = regexp.Execute(query)
		for each match in matches
			strMatch = mid(match.value,2)
			pname = r_param("name",strmatch)
			ptype = r_param("type",strmatch)
			if ptype = "date" then
				d = split(request(pname),"-")
				d2 = d(1) & "-" & d(0) & "-" & d(2)
				query = replace(query, match.value, d2)
			else
				query = replace(query, match.value, viewstate_value(pname))
			end if
		next
	
		if fieldvalue(nothing,"excel") = "on" then
			toExcel query
		end if
		
		select case lcase(rs.fields("inreto")) 
        case "deelnemers"
            set rs = getrecordset(query,true)
	        if not rs.recordcount = 0 then rs.movefirst
	        If not rs.eof then
		        Reflectsids = ""
		        'response.Write Reflectsid
		        Do until rs.eof
			        Reflectsids = Reflectsids & rs.fields("id") & ","
			        rs.movenext
		        Loop
		        rs.movefirst
		        Reflectsids = Left(Reflectsids,Len(Reflectsids)-1)
	        Else
		        Reflectsids = -1
	        End If	
	        %>
	        <hr>&nbsp;&nbsp;
	        <a style="font-weight:700" href="javascript:go('correspondence','deelnemers');"><%=getlabel("correspondence") %></a><span class="divider">|</span>
	        <a style="font-weight:700" href="javascript:go('email','deelnemers');"><%=getlabel("send_email") %></a><span class="divider">|</span>
	        <a style="font-weight:700" href="javascript:go('deelnemen','deelnemers');"><%=getlabel("deelnemen") %></a><span class="divider">|</span>
	        <a style="font-weight:700" href="javascript:go('toexcel','deelnemers');"><%=getlabel("selection_to_excel") %></a>
	        <hr>
	        <%
	    case "relations"
            set rs = getrecordset(query,true)
	        if not rs.recordcount = 0 then rs.movefirst
	        If not rs.eof then
		        Reflectsids = ""
		        'response.Write Reflectsid
		        Do until rs.eof
			        Reflectsids = Reflectsids & rs.fields("relations_id") & ","
			        rs.movenext
		        Loop
		        rs.movefirst
		        Reflectsids = Left(Reflectsids,Len(Reflectsids)-1)
	        Else
		        Reflectsids = -1
	        End If	
	        %>
	        <hr>&nbsp;&nbsp;
	        <a style="font-weight:700" href="javascript:go('correspondence','relations');"><%=getlabel("correspondence") %></a><span class="divider">|</span>
	        <a style="font-weight:700" href="javascript:go('email','relations');"><%=getlabel("send_email") %></a><span class="divider">|</span>
	        <a style="font-weight:700" href="javascript:go('toexcel','relations');"><%=getlabel("selection_to_excel") %></a>
	        <hr>
	        <%
	    case "relations_contacts"
            set rs = getrecordset(query,true)
	        if not rs.recordcount = 0 then rs.movefirst
	        If not rs.eof then
		        Reflectsids = ""
		        'response.Write Reflectsid
		        Do until rs.eof
			        Reflectsids = Reflectsids & rs.fields("relati_id") & ","
			        rs.movenext
		        Loop
		        rs.movefirst
		        Reflectsids = Left(Reflectsids,Len(Reflectsids)-1)
	        Else
		        Reflectsids = -1
	        End If	
	        %>
	        <hr>&nbsp;&nbsp;
	        <a style="font-weight:700" href="javascript:go('correspondence','relations_contacts');"><%=getlabel("correspondence") %></a><span class="divider">|</span>
	        <a style="font-weight:700" href="javascript:go('email','relations_contacts');"><%=getlabel("send_email") %></a><span class="divider">|</span>
	        <a style="font-weight:700" href="javascript:go('prorel','relations_contacts');"><%=getlabel("geefprojectrol") %></a><span class="divider">|</span>
	        <a style="font-weight:700" href="javascript:go('toexcel','relations_contacts');"><%=getlabel("selection_to_excel") %></a>
	        <hr>
	        <%
	    end select
	    
	    r_list query, links, ""
			    
	end if
	
	
	function isselected(selected,value)
		dim s
		isselected = false
		s = split(selected,",")
		if isarray(s) then
			for i = lbound(s) to ubound(s)
				if trim(s(i)) = trim(value) then
					isselected = true
					'exit for
				else
				end if
			next
		else
			if s = value then isselected = true
		end if
	end function
	
	function renderoptions (sql,listcolumn,boundcolumn,currentvalues)
		dim rs
		set rs = getrecordset(sql,true)
		with rs
			do until .eof
				if isselected(currentvalues, .fields(boundcolumn)) then
					selected = "selected"
				else
					selected = ""
				end if
			%>
				<option <%=selected%> value="<%=.fields(boundcolumn)%>"><%=.fields(listcolumn)%></option>
			<%	
				if err.number <> 0 then
					Response.Write listcolumn & "<br>"
					Response.Write boundcolumn & "<br>"
					Response.Write sql & "<br>"
					exit function
				end if
				.movenext
			loop
		end with
		set rs = nothing
	end function
	
	function renderlink (rs, url)
		dim pattern, re, match, matches
		on error resume next
		set re = new regexp
		re.pattern = "~[^~]*~"
		re.Global=true
		re.IgnoreCase=true
		set matches = re.Execute(url)
		if matches.count > 0 then
			for each match in matches
				strMatch = mid(match.value,2)
				field = mid(strmatch,1,len(match.value)-2)
				url = replace(url,match.value,rs.fields(field))
			next
		end if
		renderlink = url
		set re = nothing
	end function
	
	function renderfield (rs, links, field, value)
		dim pattern, re, match, matches
		set re = new regexp
		re.pattern = "\#[^\#]*\#"
		re.Global=true
		re.IgnoreCase=true
		set matches = re.Execute(links)
		if matches.count > 0 then
			for each match in matches
				strMatch = mid(match.value,2)
				if getparam("name", strMatch) = field then
					ptype = lcase(getparam("type",strMatch))
					pformat = getparam("format",strmatch)
					palign = getparam("align",strMatch)
					exit for
				else
					ptype = "dd"
				end if
			next
			
			select case ptype
			case "hidden"
			case "chart"
				chartwidth = fix(value) * getparam("scale",strMatch)
				if chartwidth = "" then chartwidth = value
				%>
				<td style="border-bottom:1px solid" valign=center>
					<IMG SRC="../images/redbar_left.gif" height=15><IMG SRC="../images/redbar_middle.gif" width=<%=chartwidth%> height=15><IMG SRC="../images/redbar_right.gif" height=15 ><%=formatvalue(pformat,value)%>
				</td>
				<%
			case "link"
				url = getparam("url",strMatch)
				title = getparam("title", strMatch)
				target = getparam("target",strMatch)
				url = renderlink (rs, url)
				if rs.absoluteposition = 1 then
					idname = "firstlink"
				else
					idname = "firstlink"
				end if
				%><td style="border-bottom:1px solid" valign=top><a id="<%=idname%>" name="<%=idname%>" title="<%=title%>" target="<%=target%>" href="<%=url%>" align="<%=palign%>"><%=formatvalue(pformat,value)%></a></td><%
			case "checkbox"
				value2 = getparam("value",strMatch)
				value2 = renderlink (rs, value2)
				%><td style="border-bottom:1px solid" valign=top><input type=checkbox id=<%=field%> name=<%=field%> value="<%=value2%>" align="<%=palign%>"><%=formatvalue(pformat,value)%></td><%
			case else
				%><td style="border-bottom:1px solid" valign=top align="<%=palign%>"><%=formatvalue(pformat,value)%></td><%
			end select
		else
			%><td style="border-bottom:1px solid" valign=top align="<%=palign%>"><%=formatvalue(pformat,value)%></td><%
		end if
		set matches = nothing
		set re = nothing
	end function
	
	
	
	set rs = nothing
%>

<!-- #include file="../../templates/footers/content.asp" -->