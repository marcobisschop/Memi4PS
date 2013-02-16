<!-- #include file="../../templates/headers/content.asp" -->
<%
Dim strFilePath, strFileSize, strFileName

Const adTypeBinary = 1

strFilePath = Request.QueryString("File")
strFileSize = Request.QueryString("Size")
strFileName = Request.QueryString("Name")

Response.Clear
Dim rs, sql, id
id = request("id")
sql = "select * from correspondence where id=" & id
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
<!-- #include file="../../templates/footers/content.asp" -->