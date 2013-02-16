<!-- #INCLUDE FILE="HEADER.ASP" -->
<!-- #INCLUDE FILE="CORRESPONDENCE.ASP" -->
<%
Dim strFileName

Const adTypeBinary = 1

Dim rs, sql, ciid, inreto, inreto_id
ciid = viewstate_value("ciid")
inreto = viewstate_value("inreto")
inreto_id = viewstate_value("inreto_id")

response.write ciid
response.end

sql = "select * from correspondence where id=" & ciid
'Response.Clear

set rs = getrecordset(sql,true)
with rs
	strFileName = .fields("name") & ".rtf"
	Response.AddHeader "Content-Disposition", "attachment; filename=" & StrFileName
	Response.Charset = "UTF-8"
	Response.ContentType = "application/msword"
	Response.Write .fields("RTFHeader") & " #BEGIN#"
	Response.Write .fields("RTFBody")
	Response.Write "#END#" & .fields("RTFFooter")
end with
set rs = nothing
Response.Flush
%>
<!-- #INCLUDE FILE="FOOTER_nomenu.ASP" -->