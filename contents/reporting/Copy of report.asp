<!-- #include file="../../templates/headers/content.asp" -->
<!-- #include file="excel.asp" -->
<%
	ON ERROR GOTO 0
	DIM REPORT_ID, RS, SQL
	REPORT_ID = VIEWSTATE_VALUE("REPORT_ID")
	SQL = "SELECT * FROM rappor WHERE ID=" & REPORT_ID
	SET RS = GETRECORDSET(SQL, TRUE)
	
	NOLABELS = cbool(rs.fields("nolabel"))
	
	F_HEADER rs.fields("rapnaa")
%>
<table style="width:100%" ID="Table1">
<form action="report.asp" method="get" id=form1 name=form1>
<input type="hidden" id="REPORT_ID" name="REPORT_ID" value="<%=REPORT_ID%>">
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
			<td class=f_item_label><%=getLabel(plabel)%></td>
			<td class=f_item_field><input style="width:100%" id="<%=pname%>" name="<%=pname%>" value="<%=currentvalue%>"></td>
		</tr>
		<%			
 		case "select"
 		%>
		<tr>
			<td class=f_item_label><%=getLabel(plabel)%></td>
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
			<td class=f_item_label><%=getLabel(plabel)%></td>
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

	if viewstate_value("postback")="true" or len(viewstate_value("immediately")) > 0 then	
		
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
		
        set rsQ = getrecordset(query,true)
        if not rsQ.recordcount = 0 then rs.movefirst
        If not rsQ.eof then
	        Reflectsids = ""
	        Do until rsQ.eof
		        Reflectsids = Reflectsids & rsQ.fields("id") & ","
		        rsQ.movenext
	        Loop
	        rsQ.movefirst
	        Reflectsids = Left(Reflectsids,Len(Reflectsids)-1)
        Else
	        Reflectsids = -1
        End If	
        %>
            <tr>
                <td class="f_item_label"><%=getlabel("Actions")%></td>
                <td class="f_item_field">
                    <a href="correspondence.asp?inreto=<%=rs.fields("inreto") %>&inreto_id=<%=reflectsids%>"><%=getlabel("correspondence") %></a>
                    <span class="divider">|</span>
                    <a href="../messaging/default.asp?inreto=<%=rs.fields("inreto") %>&inreto_id=<%=reflectsids%>"><%=getlabel("send_email") %></a>
                </td> 
            </tr>
        <%
   
	end if
	
%>
	<tr>
		<td class=r_field colspan=2>
			<input id="submit" name="submit" type="submit" value="<%=getLabel("execute")%>">
			<input type=checkbox id="excel" name="excel" <% if fieldvalue(nothing,"excel") = "on" then response.Write " CHECKED" %>><%=getlabel("reporting_toexcel")%>
		</td>
	</tr>
	<input type="hidden" id="immediately" name="immediately" value="<%=request("immediately")%>">
	<input type="hidden" id="postback" name="postback" value="true">
</form>
</table>

<%	
	if viewstate_value("postback")="true" or len(viewstate_value("immediately")) > 0 then	
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