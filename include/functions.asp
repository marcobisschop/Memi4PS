<%

    function btw(d)
        dim rs, sql
        sql = "exec aspBTW '" & year(d) & "-"& month(d) & "-" & day(d) & "'"
        set rs= getrecordset(sql, true)
        if rs.eof then
            btw = 0.19
        else
            btw = rs.fields("btw_percentage")
        end if
        set rs = nothing
    end function

    function r_myprojects(sec_currentuserid)
       r_myprojects = ""
    end function

    function rw(txt)
        response.write txt
    end function
       
    function show_image (inreto, inreto_id, volgor, width, height)
        %>
<style type="text/css"> 
/* rotator in-page placement */
    div#rotator {
	position:relative;
	height:100px;
	margin-left: -45px;
}
/* rotator css */
	div#rotator ul li {
	float:left;
	position:absolute;
	list-style: none;
}
/* rotator image style */	
	div#rotator ul li img {
	border:1px solid #ccc;
	padding: 4px;
	background: #FFF;
	height: 100px;
}
    div#rotator ul li.show {
	/*z-index:500*/
}
</style> 
        <%
        dim rs
        if not isnumeric(width) then width = 100000
        
        height = 100
        width = fix(height/3*4)
        
    
        sql = "select top 5 id from dosarc where available=1 and inreto='" & inreto & "' and inreto_id=" & inreto_id &  " and volgor>=" & volgor
        set rs = getrecordset(sql, true)
        with rs
            if not .eof then
                response.write "<div id='rotator'><ul>"
                do until .eof
                    response.write "<li><img style='width: " & width & "px;height:" & height & "px;' src='/include/file.asp?table=dosarc&inreto=dosarc&inreto_id=" & .fields("id") & "'/></li>"
                    .movenext
                loop
                response.write "</div>"
            end if
        end with
        set rs = nothing
        %>
<script type="text/javascript">

    function theRotator() {
        //Set the opacity of all images to 0
        $('div#rotator ul li').css({ opacity: 0.0 });
        //Get the first image and display it (gets set to full opacity)
        $('div#rotator ul li:first').css({ opacity: 1.0 });
        //Call the rotator function to run the slideshow, 6000 = change to next image after 6 seconds
        setInterval('rotate()', 3000);
    }

    function rotate() {
        //Get the first image
        var current = ($('div#rotator ul li.show') ? $('div#rotator ul li.show') : $('div#rotator ul li:first'));
        //Get next image, when it reaches the end, rotate it back to the first image
        var next = ((current.next().length) ? ((current.next().hasClass('show')) ? $('div#rotator ul li:first') : current.next()) : $('div#rotator ul li:first'));
        //Set the fade in effect for the next image, the show class has higher z-index
        next.css({ opacity: 0.0 })
	    .addClass('show')
	    .animate({ opacity: 1.0 }, 1000);
        //Hide the current image
        current.animate({ opacity: 0.0 }, 1000)
	    .removeClass('show');
    };

    $(document).ready(function() {
        //Load the slideshow
        theRotator();
    });
</script> 
    <%        
    end function

    function Role_Is_Sales()
        Dim Result
        Role_Is_Sales =  (DBLookup("sec_users","id",sec_currentuserid(),"roleid") = 12)
    end function
    
    function Role_Is_HeadOffice()
        Dim Result
        Role_Is_HeadOffice =  (DBLookup("sec_users","id",sec_currentuserid(),"roleid") = 13)
    end function
    
    function Role_Is_BeneluxOffice()
        Dim Result
        Role_Is_BeneluxOffice =  (DBLookup("sec_users","id",sec_currentuserid(),"roleid") = 2)
    end function
    
    function Role_Is_Administrator()
        Dim Result
        Role_Is_Administrator =  (DBLookup("sec_users","id",sec_currentuserid(),"roleid") = 1)
    end function
    
    function State_Is_Outstanding(state_id)
        Dim Result
        State_Is_Outstanding =  CBool(DBLookup("states","id",state_id,"outstanding"))
    end function

    function AutoNumber(Name)
		On Error resume Next
		Dim rs, sql
		sql = "exec sp_identities_get '" & Ucase(Name) & "'"
		set rs = getrecordset(sql,true)
		AutoNumber = rs.fields("value")
		set rs = nothing		
		If Err.Number = 0 Then Exit Function
		AutoNumber = -1
	end function
	
	function AutoNumberWithPrefix(Name, Prefix)
		On Error resume Next
		Dim rs, sql
		sql = "exec sp_identity_withprefix '" & Ucase(Name) & "', '" & Prefix & "'"
		set rs = getrecordset(sql,true)
		AutoNumber = rs.fields("new_key")
		set rs = nothing
		
		If Err.Number = 0 Then Exit Function
		AutoNumber = -1
	end function
	
	function current_year()
		dim rs
		set rs = getrecordset("select * from years where is_current_year = 1", true)
		if rs.recordcount = 1 then
			current_year = rs.fields("id")
		else
			current_year = -1
		end if
		set rs = nothing
	end function
%>