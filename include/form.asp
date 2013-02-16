<!-- #include file="upload.asp" -->
<!-- #include file="validation.asp" -->
<%
Dim Uploader, File
Set Uploader = New FileUploader
'on error resume next
Uploader.Upload()
'on error goto 0

Dim REFURL
' kan per pagina overschreven worden
if len(viewstate_value("refurl")) > 0 then refurl = viewstate_value("refurl")
if REFURL = "" Then REFURL = request.servervariables("http_referer") 
if REFURL = "" Then REFURL = "javascripthistory.back();"

dim formreadonly
formreadonly = true

function topmessage (message,top,left)
	top = 50
	left= 400
%>
<div style="width:100%; height: 100px;">
	<table cellpadding="0" cellspacing="0" style="width:100%;height: 100px;border=2px solid #ff0000">
		<tr>
			<td align="center" style="background-color=#ff0000;color=white;font-weight=700"><%=getlabel("Information")%></td>
		</tr>
		<tr>
			<td align="center" style="background-color=#ffffff;color=black; font-size: 14px;"><%=message%>!</td>
		</tr>
	</table>
</div>
<%
end function
	
function f_header(hdr)
	%>
	<table style="" cellpadding=0 cellspacing=0>
	    <tr>
	        <td class="f_header"><%=hdr%></td>
<!--	        <td class="f_header" align=right>
                <img style="cursor:hand" title="<%=getlabel("back") %>" src="<%=webpath & "images/buttons/back_16.gif" %>" onclick="history.back(-1)" />
	            <img style="cursor:hand" title="<%=getlabel("print") %>" src="<%=webpath & "images/buttons/print_16.gif" %>" onclick="window.print()" />
	        </td>
-->
	    </tr>
	</table>	    
	<%
end function

function f_form_hdr()	
	%>
	<form id="edit" name="edit" action="<%=Request.ServerVariables("SCRIPT_NAME")%>" method="post" ENCTYPE="multipart/form-data">
		<input type="hidden" id="postback" name="postback" value="true"> 
		<input type="hidden" id="viewstate" name="viewstate" value="<%=viewstate%>">
		<input type="hidden" id="id" name="id" value="<%=recordid%>"> 
		<input type="hidden" style="width500px" id="refurl" name="refurl" value="<%=REFURL%>">
	<%
end function

function f_form_hdr_name(f_name)	
	%>
	<form id="<%=f_name%>" name="<%=f_name%>" action="<%=Request.ServerVariables("SCRIPT_NAME")%>" method="post" ENCTYPE="multipart/form-data">
		<input type="hidden" id="Hidden2" name="postback" value="true"> 
		<input type="hidden" id="Hidden3" name="viewstate" value="<%=viewstate%>">
		<input type="hidden" id="Hidden4" name="id" value="<%=recordid%>"> 
		<input type="hidden" style="width500px" id="Hidden5" name="refurl" value="<%=REFURL%>">
	<%
end function

function f_frm_divider(hdr)
	%>
	<tr>
		<td class="f_form_divider" colspan="2"><%=hdr%></td>
	</tr>
	<%
end function

function f_frm_divider_nr(hdr)
	%>
	    <%=hdr%>
	<%
end function

function f_form_ftr()
	%>
		<table class="f_form_ftr">
			<tr>
				<td align="left">
					<%
					if viewstate = "view" then
					    if not force_viewstate_view then
					    %>
					    <input type=submit value="<%=getlabel("edit")%>" CLASS="BUTTON" ID="Submit1" NAME="Edit" onclick="document.forms['edit'].viewstate.value='edit';">
					    <%
					    end if
					else
					    if not force_viewstate_view then
					    %>
					    <input onclick="javascript:save()" type=submit value="<%=getlabel("save")%>" CLASS="BUTTON" ID="Submit2" NAME="Submit2">
					    <%
					    end if
					end if
					%>
				</td>
			</tr>
		</table>
		<script language=javascript>
		function save() { 
		    document.all.body.value = myEditor.getHTMLBody(); 
		}
		</script>
	</form>
	<%
end function

function f_hidden(name)
	%>
        <input type="hidden" id="<%=name%>" name="<%=name%>" value="<%=fieldvalue(nothing, name)%>">
    <%
end function

function f_hidden2(name, value)
	%>
        <input type="hidden" id="Hidden1" name="<%=name%>" value="<%=value%>">
    <%
end function

function f_form_ftr_nobuttons()
	%>
<table class="f_form_ftr">
	<tr>
		<td align="left">
			&nbsp;
		</td>
	</tr>
</table>
</form>
<%
end function

function f_color(fld)
	if v_informerrors(fld) then 
		f_color = f_errorstyle 
	else 
		f_color = f_noerrorstyle
	end if
end function

function f_maxlength(fld)
	'on error resume next
	f_maxlength = fld.definedsize
	if err.number <> 0 then f_maxlength = 50
	on error goto 0
	f_maxlength = ""
end function

function f_readonly (label,value)
	'label = getlabel(label)
%>
<tr>
	<td class="f_item_label"><%=label%></td>
	<td class="f_item_field"><%=value%></td>
</tr>
<%
end function

function f_readonly_checkbox (label,value)
	on error resume next
	label = getlabel(label)
	value = cbool(value)
	if err.number <> 0 then value = false
	%>
<tr>
	<td class="f_item_label"><%=label%></td>
	<td class="f_item_field"><%=getlabel(cbool(value))%></td>
</tr>
<%
end function

function f_address(rs, label, fld_prefix)
	dim value1, value2, value3, value4, value5, value6, value7
	label = getlabel(label)
	value1 = fieldvalue(rs,fld_prefix & "str")
	value2 = fieldvalue(rs,fld_prefix & "num")
	value3 = fieldvalue(rs,fld_prefix & "toe")
	value4 = fieldvalue(rs,fld_prefix & "pos")
	value5 = fieldvalue(rs,fld_prefix & "pla")
	value6 = fieldvalue(rs,fld_prefix & "lan")
	'value7 = fieldvalue(rs,fld_prefix & "adres7")
	if viewstate = "view" then 
%>
<tr>
	<td class="f_item_label" valign=top><%=label%></td>
	<td class="f_item_field">
	    <%=value1%>&nbsp;<%=value2%>&nbsp;<%=value3%><br>
	    <%=value4%>&nbsp;<%=value5%>&nbsp;(<%=value6%>)<br>
	    
	</td>
</tr>
<%		
	else
		%>
<tr>
	<td class="f_item_label" valign=top><%=label%></td>
	<td class="f_item_field">
	    <input title="<%=getlabel("adrstr") %>" type="text" style="<%=f_color(fld_prefix & "str")%>;width=180px" name="<%=fld_prefix & "str"%>" value="<%=value1%>">
	    <input title="<%=getlabel("adrnum") %>" type="text" style="<%=f_color(fld_prefix & "num")%>;width=50px" name="<%=fld_prefix & "num"%>" value="<%=value2%>">
	    <input title="<%=getlabel("adrtoe") %>" type="text" style="<%=f_color(fld_prefix & "toe")%>;width=30px" name="<%=fld_prefix & "toe"%>" value="<%=value3%>"><br>
	    <input title="<%=getlabel("adrpos") %>" type="text" style="<%=f_color(fld_prefix & "pos")%>;width=64px" name="<%=fld_prefix & "pos"%>" value="<%=value4%>">
	    <input title="<%=getlabel("adrpla") %>" type="text" style="<%=f_color(fld_prefix & "pla")%>;width=200px" name="<%=fld_prefix & "pla"%>" value="<%=value5%>"><br>
	    <%f_listbox_nr rs, fld_prefix & "lan", "select * from variables where [group]='countries' and inuse=1 order by name", "value", "name", "262px", ""%><br>
	</td>
</tr>
<%
	end if
end function

function f_person(rs, label, fld_prefix)
	dim value1, value2, value3, value4, value5, value6, value7
	label = getlabel(label)
	value1 = fieldvalue(rs, "aanhef_id") 'titel
	value2 = fieldvalue(rs, "voorle") 'voorletters
	value3 = fieldvalue(rs, "voorna") 'voornaam
	value4 = fieldvalue(rs, "tussen") 'tussenvoegsels
	value5 = fieldvalue(rs, "achter") 'achternaam
	if viewstate = "view" then 
    %>
    <tr>
	    <td class="f_item_label" valign=top><%=label%></td>
	    <td class="f_item_field">
	        <%=value2%>&nbsp;<%=value4%>&nbsp;<%=value5%><br>
	        <%=value3%><br>
	    </td>
    </tr>
    <%		
	else
		%>
        <tr>
	        <td class="f_item_label" valign=top><%=label%></td>
	        <td class="f_item_field">
	            <%f_listbox_nr rs, "aanhef_id", "select id,aannaa from aanhef order by aannaa", "id", "aannaa", "", ""%>
	            <input title="<%=getlabel("voorle") %>" type="text" style="<%=f_color("voorle")%>;width=80px" name="<%="voorle"%>" value="<%=value2%>">
	            <input title="<%=getlabel("tussen") %>" type="text" style="<%=f_color("tussen")%>;width=80px" name="<%="tussen"%>" value="<%=value4%>"><br>
	            <input title="<%=getlabel("achter") %>" type="text" style="<%=f_color("achter")%>;width=150px" name="<%="achter"%>" value="<%=value5%>">
	            <%=getlabel("voornaam")%>&nbsp;:&nbsp;<input type="text" style="<%=f_color("voorna")%>;width=100px" name="<%="voorna"%>" value="<%=value3%>"><br>
	        </td>
        </tr>
        <%
	end if
end function

function f_textbox (rs,label, fld, width)
	dim value
	label = getlabel(label)
	value = fieldvalue(rs,fld)
	if viewstate = "view" then 
		f_readonly label, value
	else
		%>
<tr>
	<td class="f_item_label"><%=label%></td>
	<td class="f_item_field"><input maxlength="<%=f_maxlength(rs(fld))%>" type="text" style="<%=f_color(fld)%>;width:<%=width%>" id="<%=fld%>" name="<%=fld%>" value="<%=value%>"></td>
</tr>
<%
	end if
end function

function f_eurobox (rs,label, fld, width)
	on error resume next
	dim value
	label = getlabel(label)
	value = fieldvalue(rs,fld)
	if viewstate = "view" then
		if len(value)>0 then value = formatnumber(value,2,true,false,true) 
		f_readonly label, "€ " & value
	else
		%>
<tr>
	<td class="f_item_label"><%=label%></td>
	<td class="f_item_field"><input maxlength="<%=f_maxlength(rs(fld))%>" type="text" style="<%=f_color(fld)%>;width:<%=width%>" id="Text5" name="<%=fld%>" value="<%=value%>"></td>
</tr>
<%
	end if
	if err.number <> 0 then response.write fld
end function

function f_checkbox (rs,label, fld)
	dim value
	value = fieldvalue(rs,fld)
	if viewstate = "view" then
		f_readonly_checkbox label,value
	else
	    label = getlabel(label)
		%>
<tr>
	<td class="f_item_label"><%=label%></td>
	<td class="f_item_field">
		<input type="checkbox" style="<%=f_color(fld)%>;border=0" id="Checkbox1" name="<%=fld%>" 
						<%
						on error resume next
						if cbool(value) = true then
							response.write " checked"
						end if
						on error goto 0
						%>
					>
	</td>
</tr>
<%	
	end if
end function

function f_gender (rs,label, fld)
	dim value
	value = fieldvalue(rs,fld)
	label = getlabel(label)
	if viewstate = "view" then
		%>
<tr>
	<td class="f_item_label"><%=label%></td>
	<td class="f_item_field">
		<%=getlabel(value)%>
		&nbsp;(<%=value%>)
	</td>
</tr>
<%
	else
		%>
<tr>
	<td class="f_item_label"><%=label%></td>
	<td class="f_item_field">
		<input type="radio" style="<%=f_color(fld)%>;border=0" id="Checkbox2" name="<%=fld%>" value="M"
						<%
						on error resume next
						if value = "M" then
							response.write " checked"
						end if
						on error goto 0
						%>
					><%=getlabel("m")%>
		&nbsp; <input type="radio" style="<%=f_color(fld)%>;border=0" id="Radio1" name="<%=fld%>" value="V"
						<%
						on error resume next
						if value = "V" then
							response.write " checked"
						end if
						on error goto 0
						%>
					><%=getlabel("v")%>
	</td>
</tr>
<%	
	end if
end function

function f_label (rs,label, fieldname)
    on error resume next
	label = getlabel(label)
	%>
<tr>
	<td class="f_item_label"><%=label%></td>
	<td class="f_item_field"><%=rs.fields(fieldname)%></td>
</tr>
<%
end function

function f_textbox_remark (rs,label, fld, width, remark)
	dim value
	label = getlabel(label)
	value = fieldvalue(rs,fld)
	if viewstate = "view" then 
		f_readonly label, value
	else
		%>
<tr>
	<td class="f_item_label"><%=label%></td>
	<td class="f_item_field">
		<input maxlength="<%=f_maxlength(rs(fld))%>" type="text" style="<%=f_color(fld)%>;width:<%=width%>" id="<%=fld%>" name="<%=fld%>" value="<%=value%>">
		<br>
		<i>
			<%=remark%>
		</i>
	</td>
</tr>
<%
	end if
end function

function f_datebox (rs,label, fld, width)
	dim value
	label = getlabel(label)
	value = fieldvalue(rs,fld)
	if isdate(value) then
        value = day(value) & "-" & month(value) & "-" & year(value)
    else
        value = ""
    end if	
	if viewstate = "view" then 
		f_readonly label, value
	else	    
		%>
<tr>
	<td class="f_item_label"><%=label%></td>
	<td class="f_item_field"><input type="text" style="<%=f_color(fld)%>;width:<%=width%>" id="Text4" name="<%=fld%>" value="<%=value%>"></td>
</tr>
<%
	end if
end function

function f_emailbox (rs,label, fld, width)
	dim value
	label = getlabel(label)
	value = fieldvalue(rs,fld)
	if viewstate = "view" then 
		if len(value)>0 then
			f_readonly label, value & "&nbsp;&nbsp;<a href='mailto:" & value & "'><img SRC='" & webpath & "images/buttons/email_16.gif' border='0' WIDTH='16' HEIGHT='16'></a>"
		else
			f_readonly label, value 
		end if
	else
		%>
<tr>
	<td class="f_item_label"><%=label%></td>
	<td class="f_item_field">
		<input maxlength="<%=f_maxlength(rs(fld))%>" type="text" style="<%=f_color(fld)%>;width:<%=width%>" id="Text2" name="<%=fld%>" value="<%=value%>">
		<%		
		if len(value)>0 and not v_informerrors(fld) then
		%>
			<a href="mailto<%=value%>"><img SRC="<%=webpath%>images/buttons/i.p.writenew.gif" border="0" WIDTH="16" HEIGHT="16"></a>
		<%	
		end if
		%>
	</td>
</tr>
<%	
	end if
end function

function f_linkbox (rs,label, fld, width)
	dim value
	label = getlabel(label)
	value = fieldvalue(rs,fld)
	if viewstate = "view" then 
		if len(value)>0 then
			f_readonly label, value & "&nbsp;&nbsp;<a href='" & value & "'><img SRC='" & webpath & "images/icons/home_purple16_h.gif' border='0' WIDTH='16' HEIGHT='16'></a>"
		else
			f_readonly label, value 
		end if
	else
%>
<tr>
	<td class="f_item_label"><%=label%></td>
	<td class="f_item_field"><input maxlength="<%=f_maxlength(rs(fld))%>" type="text" style="<%=f_color(fld)%>;width:<%=width%>" id="Text3" name="<%=fld%>" value="<%=value%>">
		<%		if len(value)>0 and not v_informerrors(fld) then
				%>
		<a href="<%=value%>"><img SRC="<%=webpath%>images/icons/home_purple16_h.gif" border="0" WIDTH="16" HEIGHT="16"></a><%	
		end if
%>
	</td>
</tr>
<%	end if
end function

function f_textlinkbox (rs,label, fld, width, link)
	dim value
	label = getlabel(label)
	value = fieldvalue(rs,fld)
	if viewstate = "view" then 
		if len(value)>0 then
			f_readonly label, "<a href='" & link & "'>" & value & "</a>"
		else
			f_readonly label, value
		end if
	else
%>
<tr>
	<td class="f_item_label"><%=label%></td>
	<td class="f_item_field">
		<input maxlength="<%=f_maxlength(rs(fld))%>" type="text" style="<%=f_color(fld)%>;width:<%=width%>" id="Text6" name="<%=fld%>" value="<%=value%>">
	</td>
</tr>
<%	end if
end function

function f_listbox(rs, label, fld, sql, boundcolumn, listcolumn, width, action)
	dim value
	label = getlabel(label)
	value = fieldvalue(rs,fld)
	if len(value)=0 then
		f_listbox = "-1"
	else
		f_listbox = value
	end if
	dim rsList
	set rsList = getrecordset(sql,true)			
	if viewstate = "view" then 
			with rsList
				do until .eof
					if .fields(boundcolumn) = value then 
						value = .fields(listcolumn)
						exit do
					end if
					.movenext
				loop
			end with		
			f_readonly label, value 
	else%>
<tr>
	<td class="f_item_label"><%=label%></td>
	<td class="f_item_field">
		<%
	on error resume next
	if len(action)>0 then
		Response.Write "<select style='" & f_color(fld) & ";width" & width & "px' id='" & fld & "' name='" & fld & "' onchange='" & action & "'>"
	else
		Response.Write "<select style='" & f_color(fld) & ";width" & width & "px' id='" & fld & "' name='" & fld & "'>"
	end if
	with rsList
		Response.Write "<option value=""-1""></option>"
		do until .eof
			if not isnull(value) then
				'response.write .fields(boundcolumn).type
				select case .fields(boundcolumn).type
				case 200 'text  case insensitive
					if ucase(.fields(boundcolumn)) = ucase(value) then
						s = "selected"
					else
						s = ""
					end if
				case 3
					'response.write "Listvalue =" & .fields(boundcolumn) & vbcrlf 
					'response.write "value =" & value & vbcrlf 
					if isnumeric(value) then
						if clng(.fields(boundcolumn)) = clng(value) then
							s = "selected"
						else
							s = ""
						end if
					else 
						s = ""
					end	if
				end select
			else
				s = ""
			end if
			Response.Write "<option " & s & " value=""" & .fields(boundcolumn) & """>" & .fields(listcolumn) & "</option>" & vbcrlf
			.movenext
		loop
	end with
	Response.Write "</select>"
	if err.number <> 0 then
		Response.Write "name = " & name & "<br>"
		Response.Write "sql = " & sql & "<br>"
		Response.Write "value = " & value & "<br>"
		Response.Write "boundcolumn = " & boundcolumn & "<br>"
		Response.Write "listcolumn = " & listcolumn & "<br>"
		Response.Write "<p>" & err.Description 
		Response.End 
	end if
	%>
	</td>
</tr>
<%
	end if
end function

function f_listbox_nr(rs, fld, sql, boundcolumn, listcolumn, width, action)
	dim value
	value = fieldvalue(rs,fld)
	if len(value)=0 then
		f_listbox_nr = "-1"
	else
		f_listbox_nr = value
	end if
	dim rsList
	set rsList = getrecordset(sql,true)			
	if viewstate = "view" then 
			with rsList
				do until .eof
					if .fields(boundcolumn) = value then 
						value = .fields(listcolumn)
						exit do
					end if
					.movenext
				loop
			end with		
			'response.write value 
	else
	    on error resume next
	    if len(action)>0 then
		    Response.Write "<select style='" & f_color(fld) & ";width" & width & "px' id='" & fld & "' name='" & fld & "' onchange='" & action & "'>"
	    else
		    Response.Write "<select style='" & f_color(fld) & ";width" & width & "px' id='" & fld & "' name='" & fld & "'>"
	    end if
	    with rsList
		    Response.Write "<option value=""-1""></option>"
		    do until .eof
			    if not isnull(value) then
				    'response.write .fields(boundcolumn).type
				    select case .fields(boundcolumn).type
				    case 200 'text  case insensitive
					    if ucase(.fields(boundcolumn)) = ucase(value) then
						    s = "selected"
					    else
						    s = ""
					    end if
				    case 3
					    'response.write "Listvalue =" & .fields(boundcolumn) & vbcrlf 
					    'response.write "value =" & value & vbcrlf 
					    if isnumeric(value) then
						    if clng(.fields(boundcolumn)) = clng(value) then
							    s = "selected"
						    else
							    s = ""
						    end if
					    else 
						    s = ""
					    end	if
				    end select
			    else
				    s = ""
			    end if
			    Response.Write "<option " & s & " value=""" & .fields(boundcolumn) & """>" & .fields(listcolumn) & "</option>" & vbcrlf
			    .movenext
		    loop
	    end with
	    Response.Write "</select>"
	    if err.number <> 0 then
		    Response.Write "name = " & name & "<br>"
		    Response.Write "sql = " & sql & "<br>"
		    Response.Write "value = " & value & "<br>"
		    Response.Write "boundcolumn = " & boundcolumn & "<br>"
		    Response.Write "listcolumn = " & listcolumn & "<br>"
		    Response.Write "<p>" & err.Description 
		    Response.End 
	    end if
	end if
end function


function f_timebox (rs, label, fld, width)
	'on error resume next
	dim value
	label = getlabel(label)
	value = converttime(fieldvalue(rs,fld))
	if isdate(fieldvalue(rs,fld)) then
		value = right("00" & hour(fieldvalue(rs,fld)),2) & "" & right("00" & minute(fieldvalue(rs,fld)),2)
	else
		value = fieldvalue(rs,fld)
	end if
	if viewstate = "view" then 
		f_readonly label, value
	else
%>
<tr>
	<td class="f_item_label"><%=label%></td>
	<td class="f_item_field"><input  <%=ro%> type="text" style="<%=f_color(fld)%>;width:<%=width%>" id="<%=fld%>" name="<%=fld%>" value="<%=value%>"></td>
</tr>
<%
	end if
end function

function f_textboxnorow (rs,label, fieldname, width)
	if v_informerrors(fieldname) then styerror = errorstyle else styerror = noerrorstyle
	if formreadonly then ro = cro else ro = ""
	if len(label)>0 then response.write label & "&nbsp;"
%>
<input <%=ro%> type="text" style="<%=styerror%>;width:<%=width%>" id="<%=fieldname%>" name="<%=fieldname%>" value="<%=fieldvalue(rs,fieldname)%>">
<%
end function

function f_filebox (rs,label, fld, width)
	label = getlabel(label)
	if v_informerrors(fld) then styerror = errorstyle else styerror = noerrorstyle
	if formreadonly then ro = cro else ro = ""
	%>
<tr>
	<td class="f_item_label"><%=label%></td>
	<td class="f_item_field"><input <%=ro%> type="file" style="<%=styerror%>;width:<%=width%>" id="<%=fld%>" name="<%=fld%>" value=""></td>
</tr>
<%
end function

function f_textarea (rs,label, fld, width, height)
	dim value
	label = getlabel(label)
	value = fieldvalue(rs,fld)
	if viewstate = "view" then 
		f_readonly label, value
	else
	%>
<tr>
	<td class="f_item_label"><%=label%></td>
	<td class="f_item_field">
		<%
			on error resume next
			defsize = rs.fields(fld).definedsize
			if err.number <> 0 then defsize = 50
			if defsize > 2000 then defsize = 2000
			on error goto 0
		%>
		<textarea maxlength="<%=defsize%>" <%=ro%> style="<%=styerror%>;width:<%=width%>;height:<%=height%>" id="<%=fld%>" name="<%=fld%>"><%=value%></textarea>
	</td>
</tr>
<%
	end if
end function

function f_htmlarea (rs,label, fieldname, width, height)
	dim value
	label = getlabel(label)
	value = fieldvalue(rs,fieldname)
	if viewstate = "view" then 
		f_readonly label, value
	else
	%>
    <tr>
	    <td class="f_item_label"><%=label%></td>
	    <td class="f_item_field">
		    <pre id="idTemporary" name="idTemporary" style="display:none"><%=Server.HTMLEncode(value & "")%></pre>
		    <input type=hidden id="body" name="<%=fieldname%>" value="" />
		    <script>
		    var myEditor = new InnovaEditor("myEditor");
	        myEditor.width = '<%=width %>';
	        myEditor.height = '<%=height %>';  
		    myEditor.RENDER(document.getElementById("idTemporary").innerHTML);  
		    </script>            
	    </td>
    </tr>
    <%
	end if
end function

function ispostback()
	'response.Write viewstate_value("postback")
	if exists_in_form("postback") then
		if viewstate_value("postback") <> "change" then
			ispostback = true
		else
			ispostback = false
		end if
	else
		ispostback = false
	end if
	' response.Write ispostback
	' ispostback = len(Uploader.Form("postback")) > 0 
	' if not (len(uploader.form("postback")) > 0) then mpartispostback = ispostback()
end function

function viewstate_value(fld)
'on error goto 0
	if exists_in_form(fld) then
		viewstate_value = Uploader.Form(fld)
	elseif exists_in_querystring(fld) then
		viewstate_value = request.Querystring(fld)
	end if
	if fld = "viewstate" then
		if FORCE_VIEWSTATE_VIEW then viewstate_value = "view"
	end if
end function

function fieldvalue(rs,fld)
	' response.Write "viewstate = " & viewstate & "<br>"
	on error resume next
	
	
	Dim myViewstate
	myViewstate = viewstate
	
	if myViewstate = "change" then myViewstate = "save"
	
	if viewstate_value("postback") = "change" then
		if exists_in_form(fld) then
				fieldvalue = Uploader.Form(fld)
			elseif exists_in_querystring(fld) then
				fieldvalue = request.Querystring(fld)
			elseif exists_in_rs(rs, fld) then
				if not rs.eof then
					fieldvalue = rs.Fields(fld)
				else
					fieldvalue = Uploader.Form(fld)
				end if
			end if
	else
		select case lcase(myViewstate)
		case "view"
			if exists_in_rs(rs,fld) then
				fieldvalue = rs.fields(fld)
			elseif exists_in_querystring(fld) then
				fieldvalue = request.Querystring(fld)
			end if
		case "edit", "new"
			if ispostback then
				if exists_in_form(fld) then
					fieldvalue = Uploader.Form(fld)
				elseif exists_in_querystring(fld) then
					fieldvalue = request.Querystring(fld)
				elseif exists_in_rs(rs, fld) then
					if not rs.eof then
						fieldvalue = rs.Fields(fld)
					else
						fieldvalue = Uploader.Form(fld)
					end if
				end if
			else
				if viewstate = "new" then
					if exists_in_querystring(fld) then
						fieldvalue = request.Querystring(fld)
					elseif exists_in_rs(rs,fld) then
						fieldvalue = rs.fields(fld)
					end if
				end if
				if viewstate = "edit" then
					if exists_in_rs(rs,fld) then
						fieldvalue = rs.fields(fld)
					elseif exists_in_querystring(fld) then
							fieldvalue = request.Querystring(fld)
					end if
				end if
			end if
		case "save"
			if exists_in_form(fld) then
				fieldvalue = Uploader.Form(fld)
			elseif exists_in_querystring(fld) then
				fieldvalue = request.Querystring(fld)
			elseif exists_in_rs(rs, fld) then
				fieldvalue = rs.Fields(fld)
			end if
		case else
			if exists_in_form(fld) then
				fieldvalue = Uploader.Form(fld)
				' response.Write Uploader.Form(fld) & "<br>"
			elseif exists_in_querystring(fld) then
				fieldvalue = request.Querystring(fld)
			end if
		end select
		if err.number <> 0 then
			%>
Error<%=err.number%><br>
Description<%=ERR.Description%><br>
<%	
		end if
	end if
	on error goto 0
end function

function exists_in_rs(rs,fld)
	if not isobject(rs) then exists_in_rs = false : exit function
	dim rs_fld
	for each rs_fld in rs.fields
		if lcase(rs_fld.name) = lcase(fld) then exists_in_rs = true : exit function
	next
	exists_in_rs = false
end function

function exists_in_form(fld)
	if not isobject(Uploader) then
		exists_in_form = False
	else
		exists_in_form = Uploader.Exists(trim(fld))
	end if
	'response.Write fld & " exists in form = " & exists_in_form & "<br>"
	'response.end
end function

function exists_in_querystring(fld)
	on error resume next
	exists_in_querystring = len(request.querystring(fld))>0
	'response.Write fld & " exists in querystring = " & exists_in_querystring & "<br>"
	on error goto 0
end function

function checkboxvalue(value)
	if lcase(value) = "on" then
		checkboxvalue = 1
	else
		checkboxvalue = 0
	end if
end function
%>
