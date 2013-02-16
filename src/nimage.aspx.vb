
Imports system.Drawing
Imports system.Drawing.Imaging
Imports System.Drawing.Drawing2D
Imports System.Drawing.Text
Imports Branding


Partial Class src_nimage
    Inherits System.Web.UI.Page


    Private Sub Page_Load(ByVal sender As System.Object, _
        ByVal e As System.EventArgs) Handles MyBase.Load

        Dim ImgSetting As New Branding.Images.Settings

        Dim strBackgroundColor As String = ""    'bgc
        Dim strBackColor As String = ""              'bc
        Dim strForeColor As String = ""               'fc
        Dim strTextColor As String = ""               'tc
        Dim strText As String = ""                       't
        Dim strFont As String = ""                       'f
        Dim strFontSize As String = ""                'fs
        Dim strBorderColor As String = ""           'bc
        Dim strImageWidth As String = ""           'bc
        Dim strImageHeight As String = ""           'bc
        Dim strApplyGlass As String = ""           'g
        Dim strApplyBorder As String = ""           'b
        Dim strApplyInternalFill As String = ""           'if

        strBackgroundColor = "#" & Request.QueryString("bgc")
        If IsNothing(strBackgroundColor) Then strBackgroundColor = "#FFFFFF"
        If strBackgroundColor.Length <> 7 Then strBackgroundColor = "#FFFFFF"

        strBackColor = "#" & Request.QueryString("bc")
        If IsNothing(strBackColor) Then strBackColor = "#6699FF"
        If strBackColor.Length <> 7 Then strBackColor = "#6699FF"

        strForeColor = "#" & Request.QueryString("fc")
        If IsNothing(strForeColor) Then strForeColor = "#0000AA"
        If strForeColor.Length <> 7 Then strForeColor = "#0000AA"

        strTextColor = "#" & Request.QueryString("tc")
        If IsNothing(strForeColor) Then strTextColor = "#0000AA"
        If strTextColor.Length <> 7 Then strTextColor = "#0000AA"

        strText = Request.QueryString("t")
        If IsNothing(strText) Then strText = "NO TEXT SUPPLIED {t}"

        strFont = Request.QueryString("f")
        If IsNothing(strFont) Then strFont = "Arial"

        strFontSize = Request.QueryString("fs")
        If IsNothing(strFontSize) Then strFontSize = "10"

        strBorderColor = "#" & Request.QueryString("bdc")
        If IsNothing(strForeColor) Then strBorderColor = "#0000AA"
        If strBorderColor.Length <> 7 Then strBorderColor = "#0000AA"

        strImageWidth = Request.QueryString("iw")
        If IsNothing(strImageWidth) Then strImageWidth = "200"

        strImageHeight = Request.QueryString("ih")
        If IsNothing(strImageHeight) Then strImageHeight = "30"

        strApplyGlass = Request.QueryString("g")
        If IsNothing(strApplyGlass) Then strApplyGlass = "true"

        strApplyBorder = Request.QueryString("b")
        If IsNothing(strApplyBorder) Then strApplyBorder = "true"

        strApplyInternalFill = Request.QueryString("if")
        If IsNothing(strApplyInternalFill) Then strApplyInternalFill = "true"


        ImgSetting.BackgroundColor = ColorTranslator.FromHtml(strBackgroundColor)
        ImgSetting.BackColor = ColorTranslator.FromHtml(strBackColor)
        ImgSetting.ForeColor = ColorTranslator.FromHtml(strForeColor)
        ImgSetting.TextColor = ColorTranslator.FromHtml(strTextColor)
        ImgSetting.Height = Convert.ToInt32(strImageHeight)
        ImgSetting.Width = Convert.ToInt32(strImageWidth)
        ImgSetting.Text = strText
        ImgSetting.TextFont = New Font(strFont, Convert.ToInt32(strFontSize), FontStyle.Bold, GraphicsUnit.Point)
        ImgSetting.ApplyGlass = Convert.ToBoolean(strApplyGlass)
        ImgSetting.ApplyBorder = Convert.ToBoolean(strApplyBorder)
        ImgSetting.ApplyInternalFill = Convert.ToBoolean(strApplyInternalFill)
        ImgSetting.BorderColor = ColorTranslator.FromHtml(strBorderColor)

        Dim oTest As Bitmap = Branding.Images.GetRoundedRectangle(ImgSetting)

        oTest.Save(Response.OutputStream, ImageFormat.Gif)

        oTest.Dispose()

    End Sub

End Class
