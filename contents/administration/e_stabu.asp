<!-- #include file="../../templates/headers/content.asp" -->
<%
	dim recordid, rs, sql, tablename
	
	viewstate = viewstate_value("viewstate")
	recordid  = viewstate_value("id")
	stabuh_id  = viewstate_value("stabuh_id")
	tablename = "stabuh"
	
	if viewstate="" then viewstate = "new"
	if recordid = "" then recordid = -1
		
	select case lcase(viewstate)
	case "view"
		sql = "select * from [" & tablename & "] where id = " & recordid
		set rs = getrecordset(sql,false)
	case "edit","save", "change"
		sql = "select * from [" & tablename & "] where id = " & recordid
		set rs = getrecordset(sql,false)
	case "new","savenew"
		sql = "select * from [" & tablename & "] where id = -1"
		set rs = getrecordset(sql,false)
		rs.addnew
		sec_setsecurityinfo (rs)
	case else
		response.Write "invalid viewstate !!" & viewstate
		response.end
	end select
	
	if viewstate = "save" or viewstate = "savenew" then	
		if ispostback() then
			if not v_valid("^\w+",true,fieldvalue(rs,"hoocod")) then v_addformerror "hoocod"
			if not v_valid("^\w+",true,fieldvalue(rs,"hoobes")) then v_addformerror "hoobes"
			if not v_valid("^\d+$",true,fieldvalue(rs,"nacalc_id")) then v_addformerror "nacalc_id"
			if errorcount = 0 then 
					viewstate = "update"
			end if
		end if		
	end if
	
	response.write formerrors
	
	if viewstate = "update" then 
		save_rs rs
		recordid = rs.fields("id")		
		viewstate = "view"
		response.Redirect viewstate_value("REFURL")
	end if
	
	if viewstate="edit" then viewstate = "save"
	if viewstate="new" then viewstate = "savenew"
	
	function save_rs(rs)
		with rs
			.fields("hoocod") = fieldvalue(rs,"hoocod")
			.fields("hoobes") = fieldvalue(rs,"hoobes")
			.fields("nacalc_id") = fieldvalue(rs,"nacalc_id")
			.fields("stabuh_id") = fieldvalue(rs,"stabuh_id")
			.fields("volgor") = fieldvalue(rs,"volgor")
		end with
		sec_setsecurityinfo rs 
		putrecordset rs 
	end function

	f_header getlabel(tablename)
	
	f_form_hdr()
	
%>
<table style="" cellpadding="0" cellspacing="0" ID="Table1">
	<tr>
		<td valign="top">
			<table style="" ID="Table2">
				<%
		            f_textbox rs,"hoocod","hoocod",100
		            f_textbox rs,"hoobes","hoobes",400
		            f_listbox rs,"nacalc_id","nacalc_id","select id, naccod + ':' + nacbes as naccod from nacalc order by naccod","id","naccod",400,""
				if viewstate="save" then
                    f_listbox rs,"valt onder","stabuh_id","select id, hoocod + ':' + hoobes as hoocod from stabuh order by hoocod","id","hoocod",400,""
				end if
				if viewstate="savenew" then
				    f_listbox rs,"valt onder","stabuh_id","select id, hoocod + ':' + hoobes as hoocod from stabuh order by hoocod","id","hoocod",400,""
				end if
				    f_textbox rs,"volgor","volgor",20
		            
                %>
             </table>					
         </td>
	</tr>
</table>
<%
	f_form_ftr()
	    
%>
</form> 

<!-- #include file="../../templates/footers/content.asp" -->
