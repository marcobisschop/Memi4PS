<%
		function sec_setsecurityinfo(rs)
		'on error resume next
		with rs
			if len(.fields("aangeb"))=0 or .fields("aangeb")<=0 then
				.fields("aangeb")  = sec_currentuserid()	
				.fields("aandat") = now() 
			end if
			.fields("wijgeb") = sec_currentuserid()			
			.fields("wijdat")= now()
		end with
		on error goto 0
	end function
%>