<!-- #include file="../../templates/headers/content.asp" -->
<!-- #include file="functions.asp" -->
<%
	dim recordid, rs, sql, tablename
	
	viewstate = viewstate_value("viewstate")
	recordid  = viewstate_value("id")
	tablename = "docum"
	
	
	if viewstate = "edit" then viewstate = "save"
	
	if ispostback() and errorcount = 0 then
	    
	    'Zet alle reeds aanwezige beschikbaarheid op 0, dus niet beschikbaar
	    sql = "update docum_availability set available=0 where docum_id=" & recordid & " and projec_id=-1"
	    executesql sql
	
	    for each fld in uploader.formelements
	        if left(fld,3) = "chk" then
	            myIds = split(fld,"_")
	            d_id = myIds(1) 
	            f_id = myIds(2) 
	            r_id = myIds(3) 
	            score = fieldvalue(rs,fld)
	            feedback = fieldvalue(rs,replace(fld,"score","feedback"))
	            sql = "sp_docum_availability " & d_id & "," & f_id & "," & r_id & ",-1,1"
	            'sp_docum_availability 
	            '    @docum_id int,
	            '    @projec_fases_id int,
	            '    @relsoo_id int,
	            '    @projec_id int = -1,
	            '    @available int = 0
	            'response.Write sql & "<br>"
	            executesql sql
	        end if 
	    next		
	end if
			
	function save_rs(rs)
		with rs
				
		end with
		sec_setsecurityinfo rs 
		'putrecordset rs 
	end function
	
	header recordid
	f_form_hdr()
	
	sql = "select id,soonaa,soobes from relsoo order by soonaa"
	set rsRol = getrecordset(sql, true)
	
    sql = "select id,kleur,fascod,fasnaa from vw_projec_fases where projec_id=0 order by volgor"
    set rs = getrecordset(sql, true)
    with rs
        if not .eof then
            %>
			<script language=javascript>
			function checkAll(){
			    for (i=0;i<document.edit.length;i++) {
                    if (document.edit[i].type=="checkbox") {
                        document.edit[i].checked = document.edit.checkall.checked;
                    } 
                }
            }
			</script>	
            <input title="<%=getlabel("checkall")%>" type=checkbox id="checkall" name="checkall" onclick="checkAll()">&nbsp;<%=getlabel("checkall") %>
            <table class="r_table" cellpadding=0 cellspacing=0>
                <tr>
                    <td class="r_head" valign=top ><a><%=getlabel("fas_rol") %></a></td>
            <%
                with rsRol
                    do until .eof
                        %>
                        <td class="r_head" valign=top><a title="<%=.fields("soobes") %>"><%=.fields("soonaa") %></a></td>
                        <%
                        .movenext
                    loop
                end with
            %>        
                </tr>
            <%
            do until .eof
    	        %>
    	        <tr>
    	            <td class="r_field" valign=top ><%=.fields("fascod") & ": " & .fields("fasnaa") %></td>
    	            <%
    	            rsRol.movefirst
    	            do until rsRol.eof
    	                %>
    	                <td class="r_field" valign=top >
    	                <%
    	                f_chk_fase_rol recordid, .fields("id"), rsRol.fields("id")
    	                %>
    	                </td>
    	                <%
    	                rsrol.movenext
    	            loop
    	            %>
    	        </tr>
    	        <%
                .movenext
            loop
            %>
            </table> 
            <%
        else
            response.Write getlabel("no_projec_fases")
        end if
    end with
    
    f_form_ftr()
    
    set rs = nothing
    set rsRel = nothing
    
    function f_chk_fase_rol (doc_id, fase, rol)
        dim chk
        if (viewstate_value("chk_" & doc_id & "_" & fase & "_" & rol) = "on") then
            chk = "checked"
        else
            dim sql, rs
            sql = "select * from docum_availability where docum_id=" & doc_id & " and projec_fases_id=" & fase & " and relsoo_id=" & rol & " and projec_id=-1"
            
            'response.Write sql & "<br>"
            
            set rs = getrecordset(sql,true)
            if rs.recordcount = 0 then
                chk = ""
            else
                if cbool(rs.fields("available")) then
                    chk = "checked"
                else
                    chk = ""
                end if
            end if
            set rs = nothing
        end if
        %>
        <input type="checkbox" id="chk_<%=fase%>_<%=rol%>" name="chk_<%=doc_id%>_<%=fase%>_<%=rol%>" <%=chk %>/>
        <%
    end function

%>
<!-- #include file="../../templates/footers/content.asp" -->
