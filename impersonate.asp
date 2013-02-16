<!-- #include file="settings/global.asp" -->
<!-- #include file="include/database.asp" -->
<!-- #include file="include/language.asp" -->
<!-- #include file="include/form.asp" -->

<!-- #include file="include/render.asp" -->
<%
	Session.Abandon()
	Response.Redirect "default.asp?login_key=" & viewstate_value("key")
%>