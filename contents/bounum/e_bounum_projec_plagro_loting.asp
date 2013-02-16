<!-- #include file="../../templates/headers/content.asp" -->
<!-- #include file="functions.asp" -->
<%
    dim recordid 
    recordid = viewstate_value("id")
    
    bounum_header recordid 
	
	if ispostback() then
        sql = "update bounum set projec_plagro_loting_id=" & viewstate_value("plagro_loting_id") & ", projec_plagro_loting_x=" & viewstate_value("image.x") & ", projec_plagro_loting_y=" & viewstate_value("image.y") & " where id=" & recordid
        executesql sql
        
        %>
        <div style="color: Red; font-size: 14px; padding: 15px 15px 15px 15px"><%=getlabel("saved") %></div>
        <%
        response.Redirect REFURL
    end if 
    
	
    dim rs, sql
    sql = "select * from vw_projec_plagro_loting where projec_id in (select projec_id from bounum where id=" & recordid & ")"
    set rs = getrecordset(sql, true)
    with rs
        if .eof then
            %>
                <div>
                Nog geen plattegronden voor de loting aanwezig.
                </div>
            <%
            ' response.redirect "" 
        else
            do until .eof
                f_form_hdr()
	            
                %>
                    <input type="hidden" id="projec_id" name="projec_id" value="<%=.fields("projec_id") %>" />
                    <input type="hidden" id="bounum_id" name="bounum_id" value="<%=recordid %>" />
                    <input type="hidden" id="plagro_loting_id" name="plagro_loting_id" value="<%=.fields("id") %>" />
                    <div style="padding-top: 15px; padding-left: 15px; font-weight: 700">
                    <%=.fields("beschrijving") %><br /><br />
                    <input src="../../include/plagro_loting.asp?id=<%=.fields("id") %>" type="image" id="image" name="image"/>
                    </div>                    
                </form> 
                <%                
                .movenext
            loop 
            %>
            
            <% 
        end if
    end with
    set rs = nothing
        
%>


<!-- #include file="../../templates/footers/content.asp" -->
