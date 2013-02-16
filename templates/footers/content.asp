	
    <%
        'sec_info()
        'response.write sec_roles()
        ' response.write session("projec_id")
    %>
    </div>
    <hr />
    
    
    <%
	select case Session("APPLICATION")
	case "maaz"
	    %> <img src="/images/logo_vandermaazen.jpg" style="width: 300px"/> <%
	case "kokb"
	    %> <img src="/images/kokb.png" style="width: 300px"/> <%
	case "spra"
	    %> <img src="/images/sprangers.png" style="width: 300px"/> <%
	case "dewi","dewit"
	    %> <img src="/images/logo_dewit.jpg" style="width: 300px"/> <%
	case "asrv"
	    %> <img src="/images/logo_asrv.jpg" style="width: 300px"/> <%
	case "zali"
	    %> <img src="/images/logo_zaligheden.jpg" style="width: 300px"/> <%
	case "stad"
	    %> <img src="/images/logo_stadlander.jpg" style="width: 300px"/> <%
	case "adri"
	    %> <img src="/images/logo_adriaans.jpg" style="width: 300px"/> <%
	case "adriaans"
	    %> Adriaans - MEMI Pro &copy; 2009 <%
	case "vanbree"
	    %> <img src="/images/logo_bree.jpg" style="width: 300px"/> <%
	case "woli"
	    %><img src="/images/wonenlimburg.jpg"/><%
	case "bate", "baten"
	    %><img src="/images/bouwbedrijfbatenbv.gif"/><%
	case "wopa"
	    %><img src="/images/woonpartners.jpg" style="width: 100px"/><%
	case "gisb","gisbergen"
	    %><img src="/images/gisbergen.jpg"/><%
	case "moon","moonen"
	    %><img src="/images/moonen.jpg" style="width: 200px"/><%
	case "gold"
	    %><img src="/images/goldewijk.jpg" style="width: 100px"/><%
	case else
	    %><img src="/images/logo.gif"/><%
	end select
	%>
    
    
</body>
</html>
