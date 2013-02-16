<%
	function toExcel(Query)
		Response.Clear 
		Response.ContentType = "application/vnd.ms-excel"
		Response.AddHeader "Content-Disposition", "attachment;filename=CustomReport.xls"
		Dim rs
		set rs = getrecordset(query,true)
		with rs
			if not .eof then
				response.Write "<table class=excel_table>"
				response.Write "<tr class=excel_row>"
				for each fld in .fields
					response.Write "<td class=excel_header>" & fld.name & "</td>"
				next
				response.Write "</tr>"
				do until .eof
					response.Write "<tr class=excel_row>"
					for each fld in rs.fields
						response.Write "<td class=excel_field>" & .fields(trim(fld.name)) & "</td>"
					next
					response.Write "</tr>"
					.movenext
				loop
				response.Write "</table>"
			end if
		end with
		set rs = nothing
		Response.End 
	end function
	
	function toExcel2(Query)
		Response.Clear 
		Response.ContentType = "application/vnd.ms-excel"
		Response.AddHeader "Content-Disposition", "attachment;filename=CustomReport2.xls"
		Dim rs
		set rs = getrecordset(query,true)
		with rs
			if not .eof then
				response.Write "<table class=excel_table>"
				response.Write "<tr class=excel_row>"
				for each fld in .fields
					response.Write "<td class=excel_header>" & fld.name & "</td>"
				next
				response.Write "</tr>"
				do until .eof
					response.Write "<tr class=excel_row>"
					for each fld in rs.fields
						response.Write "<td class=excel_field>" & .fields(trim(fld.name)) & "</td>"
					next
					response.Write "</tr>"
					.movenext
				loop
				response.Write "</table>"
			end if
		end with
		set rs = nothing
		Response.End 
	end function
%>