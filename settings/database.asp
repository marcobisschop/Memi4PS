<%
	'Voer hier globale constanten voor de database toegang

	'DatabaseLocation
	Dim Database_Server   
	Dim Database_Catalog  
	Dim Database_Userid   
	Dim Database_Password 
	
	select case lcase(session("application"))
    case "memi4ps"	
        Database_Server   = "usiiifg40x.database.windows.net"
        Database_Catalog  = "memi4ps"	    
        Database_Userid   = "memi4ps@usiiifg40x"
	    Database_Password = "nEw26NcX"
	case else
	    Database_Server   = "usiiifg40x.database.windows.net"
        Database_Catalog  = "memi4ps"	    
        Database_Userid   = "memi4ps@usiiifg40x"
	    Database_Password = "nEw26NcX"
    end select	    	
		
	'CursorLocation
	Const adUseClient	= 3
	Const adUseServer	= 2
	Const adUseNone		= 1
	
	'Cursortypes
	Const adOpenUnspecified	= -1 
	Const adOpenForwardOnly	= 0
	Const adOpenKeyset		= 1
	Const adOpenDynamic		= 2
	Const adOpenStatic		= 3

	'LockTypes
	Const adLockUnspecified		= -1
	Const adLockReadOnly		= 1
	Const adLockPessimistic		= 2
	Const adLockOptimistic		= 3
	Const adLockBatchOptimistic	= 4
%>