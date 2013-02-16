<%  
    function r_list (sql, fields, orderby)
        r_list_2 sql, fields, orderby, "list"
    end function

	function r_list_2 (sql, fields, orderby, fname)
	    
		dim rs, order, script, qstring
		script = Request.ServerVariables("SCRIPT_NAME")
		if instr(1,Request.ServerVariables("QUERY_STRING"),"orderby") then
			qstring = mid(Request.ServerVariables("QUERY_STRING"),1,instrrev(Request.ServerVariables("QUERY_STRING"),"orderby")-1)
			if qstring = "&" then
				qstring = "aaa"
			else

			end if
		else
			qstring = Request.ServerVariables("QUERY_STRING")
			if len(qstring)>0 then qstring = qstring & "&"
		end if
		
		if orderby <> "noorder" then
			order = Request.QueryString("order")
			if ucase(order) = "ASC" then
				order = "DESC"
			else
				order = ""
			end if
			if len(Request.QueryString ("orderby"))<>0 then 
				if len(Request.QueryString ("orderby"))>0 then
					orderby = Request.QueryString ("orderby")
					'Response.Write orderby
					orderby = " order by " & orderby & " " & order
				else
					orderby = ""
				end if
			else
				if len(orderby)>0 then
					orderby = " order by " & orderby & " " & order
				end if
			end if
			sql = sql & orderby
		else 
			order = orderby
		end if		
		set rs = getrecordset(sql,true)
		script = script & "?" & qstring
		with rs
			r_head rs, fields, script, order, fname
			if not .eof then 
				if exists_in_rs(rs,"id") then
					r_list_2 = rs.fields("id")
				else
					r_list_2 = -1
				end if
			end if
			do until .eof
				if .absoluteposition mod 2 = 0 then oddeven = "r_roweven" else oddeven = "r_rowodd"
				%><tr class="<%=oddeven%>"><%
				for each field in .fields
				    value = ""
				    if field.type = 135 then
				        value = Year(field.value) & "-" & Right("00" & Month(field.value),2) & "-" & Right("00"& Day(field.value),2)
				        value = Right("00"& Day(field.value),2) & "-" & Right("00" & Month(field.value),2) & "-" & Year(field.value) 
				    else
				        value = field.value
				    end if
				
					r_field rs, fields, field.name, value, oddeven
					'r_field rs, fields, field.name, field.value, oddeven
				next
				%></tr><%
				.movenext					
			loop
			r_foot rs, fields
		end with
		set rs = nothing
	end function
	
	function r_head(rs, fields, script, order, fname)
		%>
		<form id="<%=fname %>" name="<%=fname %>" action="" method="get"  ENCTYPE="multipart/form-data">
		<table class="r_table" cellpadding="0" cellspacing="0">
		<%
		dim pattern, re, match, matches, hidden
		set re = new regexp
		re.pattern = "\$[^\$]*\$"
		re.Global=true
		re.IgnoreCase=true
		set matches = re.Execute(fields)
		for each f in rs.fields
			hidden = false
			plabel = ""
			pname = f.name
			ptype = ""
			wrap = ""
			for each match in matches
				strMatch = mid(match.value,2)
				hidden = false
				if lcase(r_param("name", strMatch)) = lcase(f.name) then
					ptype = lcase(r_param("type",strMatch))
					plabel = r_param("label",strMatch) & ""
					palign = r_param("align",strMatch) & ""
					pwidth = r_param("width",strMatch) & ""
					if len(palign)=0 then palign="left"
					if len(plabel & "") > 0 then plabel = getlabel(plabel) else plabel = getlabel(pname)
					if ptype = "hidden" then 
						hidden = true
						exit for
					end if					
				else
					hidden = true
				end if
			next
			if len(plabel & "") = 0 then plabel = getlabel(pname)
			
			if instr(fields,"$form;") then
			    action = r_param("action",strMatch)
			    method = r_param("method",strMatch)
			    name = r_param("name",strMatch)
			end if
			
			select case ptype
			case "hidden"
				%><%
			case "checkbox"
				%><td class="r_head" valign=top align="<%=palign%>">
					<input title="<%=getlabel("checkall")%>" type="checkbox" id="checkall_<%=fname %>" name="checkall_<%=fname %>" onclick="checkall2('<%=fname %>')">&nbsp;
					<script language=javascript>
					<!-- Begin
					
					function checkall2(fname) {
					    for (i=0; i<document.getElementById(fname).elements.length; i++) { 
		                    el = document.getElementById(fname).elements[i];
		                    if (el.type=="checkbox") {
			                    el.checked = document.getElementById('checkall_' + fname).checked;
		                    } 
	                    }
					}
					
					function checkAll()
					{
					field = document.<%=fname %>.checkbox_<%=pname%>;
					alert(field);
					for (i = 0; i < field.length; i++)
						field[i].checked = document.<%=fname %>.checkall_<%=pname %>.checked ;
						//alert(field[i].checked);
					}
					//  End -->
					</script>				
				</td><%
			case "delete"
			    if usercan("delete") then
			    %><td class="r_head" align="<%=palign%>"><%=plabel%></td><% 
			    else			     
			    end if
			case "copy"
			    %><td class="r_head" align="<%=palign%>"><%=plabel%></td><% 			    
			case else
			    if ptype = "value" then palign = "right"
				if order = "noorder" then
				%><td style="width:<%=pwidth%>" class="r_head" align="<%=palign%>"><%=plabel%></td><%
				else
				%><td style="width:<%=pwidth%>" class="r_head" align="<%=palign%>"><a style="r_head" href="<%=script%>orderby=<%=f.name%>&order=<%=order%>"><%=plabel%></a></td><%
				end if
				Response.Write vbCrLf 
			end select
		next
		set re = nothing
	end function
	
	function r_foot(rs,fields)
		%><tr><%
		dim pattern, re, match, matches
		set re = new regexp
		re.pattern = "\$[^\$]*\$"
		re.Global=true
		re.IgnoreCase=true
		set matches = re.Execute(fields)
		for each f in rs.fields
			hidden = false
			pcalculate = ""
			for each match in matches
				strMatch = mid(match.value,2)
				if lcase(r_param("name", strMatch)) = lcase(f.name) then
					ptype = lcase(r_param("type",strMatch))
					pcalculate = lcase(r_param("calculate",strMatch))
					palign = lcase(r_param("align",strMatch))
					if ptype = "hidden" then 
						hidden = true
						exit for
					end if
				end if
			next
			if not hidden then 
				%><td class='r_foot' align='<%=palign %>'><%=calculatefield(rs,f.name,pcalculate)%>&nbsp;</td><%
			end if
		next
		set re = nothing
		%></tr>
		</table>
		<%
		if instr(fields, "$form;") then 
		    method = lcase(r_param("method",strMatch))
		    action = lcase(r_param("action",strMatch))
		    action = r_link(rs, action)
		    button = lcase(r_param("button",strMatch))
		%>
	    &nbsp;&nbsp;&nbsp;<input type="button" value="<%=button %>" onclick="sssubmit()"/>
	    <script type="text/javascript">
	    
	    function sssubmit() {
	        var myform = document.list;
	        myform.method = '<%=method %>';
	        myform.action = '<%=action %>';
	        //myform.name = '<%=ucase(r_param("name", strMatch)) %>';
	        myform.submit();
	    }
	    
	    </script>
		<%
		end if
		%>
		</form>
		<%
	end function
	
	function r_field (rs, fields, field, value, oddeven)
		dim pattern, re, match, matches
		set re = new regexp
		re.pattern = "\$[^\$]*\$"
		re.Global=true
		re.IgnoreCase=true
		set matches = re.Execute(fields)
		if matches.count > 0 then
			for each match in matches
				strMatch = mid(match.value,2)
				if lcase(r_param("name", strMatch)) = lcase(field) then
					ptype = lcase(r_param("type",strMatch))
					pformat = lcase(r_param("format",strMatch))
					pcalculate = lcase(r_param("calculate",strMatch))
					palign = lcase(r_param("align",strMatch))
					ptranslate = lcase(r_param("translate",strMatch))
					pwidth = lcase(r_param("width",strMatch))
					pwrap = r_param("wrap",strMatch) & ""
					
					if len(pwidth)= 0 then pwidth = "*"
					if ptranslate="1" or ptranslate="true" then value = getlabel(value)
					
					
					exit for
				else
				    ptype = "text"
				end if
			next
			
			select case ptype
			case "input_float"
			    fieldname = r_param("fieldname",strMatch)			
		        fieldname = r_link (rs, fieldname) 
		        %><td class="r_field" align="<%=palign%>"><input style="width:50px; text-align:right" value="<%=formatvalue(pformat,value) %>" name="<%=fieldname %>" id="<%=fieldname %>"/></td><%
			case "email"
				if len(value) <> 0 then
					%><td class="r_field" align="<%=palign%>"><a href="mailto:<%=formatvalue(pformat,value) %>"><img src="<%=webhost & webpath%>images/buttons/i.p.writenew.gif" title="<%=formatvalue(pformat,value)%>"></a></td><%
				else
					%><td class="r_field" align="<%=palign%>">&nbsp;</td><%
				end if
			case "www"
				if len(value) <> 0 then
					%><td class="r_field" align="<%=palign%>"><a target="_blank" href="http://<%=formatvalue(pformat,value)%>"><img src="<%=webhost & webpath%>images/buttons/home_16.gif" title="<%=formatvalue(pformat,value)%>"></a></td><%
				else
					%><td class="r_field" align="<%=palign%>">&nbsp;</td><%
				end if
			case "bit"
				class_ = r_param("class",strMatch)
		        field_ = r_param("field",strMatch)			
		        id = r_param("id",strMatch) 
		        id = r_link (rs, id) 
		        boundcolumn = r_param("boundcolumn",strMatch)			
		        if cbool(value) then
					%><td class="r_field" align="<%=palign%>"><a href="<%=webhost & webpath%>include/bit.asp?class=<%=class_ %>&field=<%=field_ %>&id=<%=id %>&boundcolumn=<%=boundcolumn %>"><img src="<%=webhost & webpath%>images/ok.gif" title="<%=getlabel("true")%>"></a></td><%
				else
					%><td class="r_field" align="<%=palign%>"><a href="<%=webhost & webpath%>include/bit.asp?class=<%=class_ %>&field=<%=field_ %>&id=<%=id %>&boundcolumn=<%=boundcolumn %>"><img src="<%=webhost & webpath%>images/nok.gif" title="<%=getlabel("false")%>"></a></td><%
				end if
			case "truefalse"
			    url = r_param("url",strMatch)
				title = r_link(rs, r_param("title", strMatch))
				target = r_param("target",strMatch)
				url = r_link (rs, url)
				%>
				<td class="r_field" align="<%=palign%>">
				    <%if cbool(value) then %>				    
				        <a title="<%=title%>" target="<%=target%>" href="<%=url%>"><img src="<%=webhost & webpath%>images/ok.gif" title="<%=getlabel("true")%>"></a>
                    <%else %>				    
                        <a title="<%=title%>" target="<%=target%>" href="<%=url%>"><img src="<%=webhost & webpath%>images/nok.gif" title="<%=getlabel("false")%>"></a>
                    <%end if %>
				</td>
				<%			
			case "order"
				class_ = r_param("class",strMatch)
		        field_ = r_param("field",strMatch)			
		        id = r_param("id",strMatch) 
		        id = r_link (rs, id) 
		        %><td class="r_field" align="<%=palign%>">
		                 <a href="<%=webhost & webpath%>include/order.asp?class=<%=class_ %>&field=<%=field_ %>&id=<%=id %>&direction=up"><img src="<%=webhost & webpath%>images/arrow_up.gif" title="<%=getlabel("up")%>"></a>
		                 <a href="<%=webhost & webpath%>include/order.asp?class=<%=class_ %>&field=<%=field_ %>&id=<%=id %>&direction=down"><img src="<%=webhost & webpath%>images/arrow_down.gif" title="<%=getlabel("down")%>"></a>
		                &nbsp; <%=formatvalue(pformat,value)%>&nbsp;
		              </td>
		        <%				
			case "hidden"
			case "text"
				%><td class="r_field" style="width: <%=pwidth%>;" align="<%=palign%>" <%=pwrap %>><%=formatvalue(pformat,value)%> <%if not skip_space then rw "&nbsp;" %></td><%
			case "translate"
				%><td class="r_field" align="<%=palign%>"><%=getlabel(value)%>&nbsp;</td><%
			case "value"
				%><td class="r_field" align="right"><%=formatvalue(pformat,value)%>&nbsp;</td><%
			case "date"
			    %><td class="r_field" align="right"><%=convertdate(value)%>&nbsp;</td><%
			case "link"
				url = r_param("url",strMatch)
				title = r_link(rs, r_param("title", strMatch))
				target = r_param("target",strMatch)
				url = r_link (rs, url)
				%><td class="r_field" align="<%=palign%>"><a title="<%=title%>" target="<%=target%>" href="<%=url%>"><%=formatvalue(pformat,value)%></a>&nbsp;</td><%
			case "image"
				url = r_param("url",strMatch)
				src = r_param("src",strMatch)
				label = r_param("label",strMatch)
				title = r_param("title", strMatch)
				target = r_param("target",strMatch)
				url = r_link (rs, url)
				src = r_link (rs, src)
				label = r_link (rs, label)
				title = r_link (rs, title)
				title = getlabel(title)
				value = getlabel(value)
				%><td class="r_field" align="<%=palign%>"><a title="<%=title%>" target="<%=target%>" href="<%=url%>"><img src="<%=webhost & src%>" title=""></a>&nbsp;</td><%
			case "window"
				url = r_param("url",strMatch)
				url = r_link (rs, url)
				title = r_param("title", strMatch)
				width = r_param("width",strMatch)
				height = r_param("height",strMatch)
				params = r_param("params",strMatch)
				
				if len(width)=0 then width = "550"
				if len(height)=0 then height = "550"
				if len(params)=0 then params = "center:true"
				
				%><td class="r_field" align="<%=palign%>">
				    <a title="<%=title %>" href="<%=url%>" onclick="return openWindow(this, {width:<%=width %>,height:<%=height %>,<%=params %>})"><%=formatvalue(pformat,value)%></a>                            
				</td><%
			case "delete"
			    if usercan("delete") then 
			        class_ = r_param("class",strMatch)
			        boundcolumn = r_param("boundcolumn",strMatch)			
			        if instr(1,boundcolumn,",") then
			            bc = split(boundcolumn,",")
			            for i = lbound(bc) to ubound(bc)
			                boundcolumn = boundcolumn & r_param(bc(i),strMatch) & ","
			            next
			            boundcolumn = left(boundcolumn,len(boundcolumn)-2)
			        end if
			        url = webpath & "include/delete.asp?class=" & class_ & "&id=~" & boundcolumn & "~"
    				
				    ' response.Write url
    				
				    title = r_param("title", strMatch)
				    target = r_param("target",strMatch)
				    url = r_link (rs, url)
				    %><td class="r_field" align="<%=palign%>"><a title="<%=title%>" target="<%=target%>" href="<%=url%>"><img border=0 src="<%=webpath %>images/xprecycle.gif" /></a></td><%
	            else
	                %><td>&nbsp;</td><% 
	            end if 
			case "copy"
		        class_ = r_param("class",strMatch)
		        boundcolumn = r_param("boundcolumn",strMatch)			
		        if instr(1,boundcolumn,",") then
		            bc = split(boundcolumn,",")
		            for i = lbound(bc) to ubound(bc)
		                boundcolumn = boundcolumn & r_param(bc(i),strMatch) & ","
		            next
		            boundcolumn = left(boundcolumn,len(boundcolumn)-2)
		        end if
		        url = webpath & "include/copy.asp?class=" & class_ & "&id=~" & boundcolumn & "~"
				
			    title = r_param("title", strMatch)
			    target = r_param("target",strMatch)
			    url = r_link (rs, url)
			    %><td class="r_field" align="<%=palign%>"><a title="<%=title%>" target="<%=target%>" href="<%=url%>"><img border=0 src="<%=webpath %>images/buttons/copy.gif" /></a></td><%
            case "checkbox"
				boundvalue = r_param("boundcolumn",strMatch)
				boundvalue = rs.fields(boundvalue)
				listvalue  = r_param("listcolumn",strMatch)
				listvalue = r_link (rs, listvalue)
				%><td class="r_field" style="width: 20px" align="<%=palign%>"><input type="checkbox"  id="checkbox_<%=field%>"  name="checkbox_<%=field%>" value="<%=boundvalue%>"><%=listvalue%></td><%
			case "actions:keuzen"
			   	columns = r_param("columns",strMatch)
			    columns = r_link(rs, columns)	
			   	column = Split(columns,",")
			    	
				%>
				    <td <%=pwrapping %> class="r_field" align="<%=palign%>">
				<%if column(1) then %>        <a title="<%=getlabel("controleren") %>" href="#"><img src="/images/actions/keuzen/control.gif" /></a>    <%end if %>
				<%if column(2) then %>        <a title="<%=getlabel("vrijgeven") %>" href="#"><img src="/images/actions/keuzen/vrijgeven.gif" /></a>   <%end if %>
				        -
				        <a title="<%=getlabel("kopieren") %>" href="#"><img src="/images/actions/keuzen/kopieren.gif" /></a>
				        <a title="<%=getlabel("verwijderen") %>" href="#"><img src="/images/actions/keuzen/verwijderen.gif" /></a>
				    </td>
				<%	
			case "status:keuzen"
			   	%>
				    <td <%=pwrapping %> class="r_field" align="<%=palign%>">
				    <%if cbool(rs.fields("defini")) then %><a title="<%=getlabel("defini") %>" href="#">D</a>&nbsp;<% else %>&nbsp;<% end if %>
				    <%if cbool(rs.fields("control")) then %><a title="<%=getlabel("control") %>" href="#">G</a>&nbsp;<% else %>&nbsp;<% end if %>
				    <%if cbool(rs.fields("afrond")) then %><a title="<%=getlabel("afrond") %>" href="#">A</a>&nbsp;<% else %>&nbsp;<% end if %>
				    <%if cbool(rs.fields("factur")) then %><a title="<%=getlabel("factur") %>" href="#">F</a>&nbsp;<% else %>&nbsp;<% end if %>
				    </td>
				<%	
			 case "memi"
			    memi = r_param("boundcolumn",strMatch)
			    memi = r_link(rs,memi)
			    if memi then memi = "meerwerk.jpg" else memi = "minderwerk.jpg"
		        %><td style="width: 10px" <%=pwrapping %> class="r_field" align="<%=palign%>"><%
		        if appl_dir = "contents" then
			        %><a title="<%=getlabel("memi") %>" href="<%=webhost & webpath%>include/bit.asp?class=keuzen&field=memi&id=<%=rs.fields("id") %>"><img style="width: 8px" src="/images/actions/keuzen/<%=memi %>" /></a><%	 
			    else
			    %><img title="<%=getlabel("memi") %>"style="width: 8px" src="/images/actions/keuzen/<%=memi %>" /><%	
			    end if
			    %></td><%
				
			 case "has_docum"
			    %><td style="width: 10px" <%=pwrapping %> class="r_field" align="<%=palign%>"><%
			    if value>0 then has_docum = "/images/afbeeldingen.png" else has_docum="/images/no_afbeeldingen.png"
                if appl_dir="contents" then
                %><a title="<%=getlabel("docum") %>" href="<%=webhost & webpath%>contents/memi/e_pictures.asp?viewstate=edit&id=<%=rs.fields("id") %>"><img src="<%=has_docum %>" /></a><%			        
                else
                %><img src="<%=has_docum %>" /><%			                            
                end if
		        %></td><%	 
			 case "natebe"
			    natebe = r_param("boundcolumn",strMatch)
			    natebe = r_link(rs,natebe)
			    if natebe then natebe = "natebe.jpg" else natebe = "pixel.gif"
		        %><td style="width: 10px" <%=pwrapping %> class="r_field" align="<%=palign%>"><%
		        if appl_dir = "contents" then
			        %><a title="<%=getlabel("natebe") %>" href="<%=webhost & webpath%>include/bit.asp?class=keuzen&field=natebe&id=<%=rs.fields("id") %>"><img style="width: 16px" src="/images/actions/keuzen/<%=natebe %>" /></a><%	 
			    else
			    %><img title="<%=getlabel("natebe") %>"style="width: 16px" src="/images/actions/keuzen/<%=natebe %>" /><%	
			    end if
			    %></td><%
				
			 case "voltek" 
			    voltek = r_param("boundcolumn",strMatch)
			    voltek = r_link(rs,voltek)
			    if voltek then voltek = "voltek.gif" else voltek = "pixel.gif"
		        %><td style="width: 10px" <%=pwrapping %> class="r_field" align="<%=palign%>"><%
		        if appl_dir = "contents" then
			        %><a title="<%=getlabel("voltek") %>" href="<%=webhost & webpath%>include/bit.asp?class=keuzen&field=voltek&id=<%=rs.fields("id") %>"><img style="width: 16px" src="/images/actions/keuzen/<%=voltek %>" /></a><%	 
			    else
			    %><img title="<%=getlabel("voltek") %>" style="width: 16px" src="/images/actions/keuzen/<%=voltek %>" /><%	
			    end if
			    %></td><%
				
			case "actions:prodee"
			   	columns = r_param("columns",strMatch)
			    columns = r_link(rs, columns)	
			   	column = Split(columns,",")
				%>
				    <td <%=pwrapping %> class="r_field" align="<%=palign%>">
				        <a title="<%=getlabel("maak_koper") %>" href="../prodee/action.asp?action=d2k&checkbox_id=<%=columns %>"><img src="/images/actions/prodee/maak_koper.gif" /></a>
				    </td>
				<%
			end select
		else
		    if isnumeric(value) then palign="right"
			%><td class="r_field" align="<%=palign%>"><%=formatvalue(pformat,value)%></td><%
		end if
		Response.Write vbCrLf 
		set matches = nothing
		set re = nothing
	end function
	
	function r_link (rs, url)
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
				if instr(field,",") then
				    bc = split(field,",")
				    for i = lbound(bc) to ubound(bc)
				        url = replace(url,bc(i),rs.fields(bc(i)))
				    next
				    url = replace(url, "~","")
				else
				    url = replace(url,match.value,rs.fields(field))
				end if
			next
		end if
		r_link = url
		set re = nothing
	end function
	
	function r_param (param,str)
		dim a, regexp, match, matches
		set regexp = new regexp
		regexp.Pattern = "[^;]*;"
		regexp.Global = true
		regexp.IgnoreCase = true
		set matches = regexp.Execute(str)
		for each match in matches
			a = split(match.value,":=")
			if lcase(a(0)) = lcase(param) then
				r_param = left(a(1),len(a(1))-1)
				exit function
			end if
		next
		set regexp = nothing		
	end function
	
	function calculatefield (rs, field, calculate)
		'Response.Write field 
		'Response.end
		if len(calculate)>0 then
			dim sum, count
			sum = 0
			count = 0
			if not rs.recordcount = 0 then rs.movefirst
			do until rs.eof
				if len(rs.fields(field))=0 then 
					value = 0
				else
					value = rs.fields(field)
				end if
				sum = sum + value
				count = count + 1
				if not rs.eof then rs.movenext
			loop
			
			select case lcase(calculate)
			case "sum"
				value = formatvalue("d2",sum)
			case "avg"
				value = formatvalue("d2",sum \ count)
			case "count"
				value = count
			case else
				value = ""
			end select
		end if
		calculatefield = "<b>" & value & "</b>"
	end function
	
	function formatvalue (format, value)
	    
		select case lcase(format)
		case "number"
			if not isnumeric(value) then value=0
			formatvalue = formatnumber(value,0)
		case "d2"
			if not isnumeric(value) then value=0
			formatvalue = formatnumber(value)
		case "shortdate"
		    formatvalue = formatdatetime(value,2)
		case else
			formatvalue = value			
		end select
	end function
%>