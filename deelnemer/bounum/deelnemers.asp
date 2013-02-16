<!-- #include file="../../templates/headers/content.asp" -->
<%
	f_header getlabel("mijn buren")
%>
<div style="padding-top: 2px; vertical-align: top" class="rolodex">
    <script language="javascript" type="text/javascript">
    function go(action, inreto) {
    
        var el      = document.createElement("input");
        var el2     = document.createElement("input");
        el.type     = "hidden";
        el.name     = "inreto";
        el2.type    = "hidden";
        el2.name    = "inreto_id";
         
        field = document.all.checkbox_id;
        el2.value = '';
        el.value = inreto;
        if (typeof(field.length)=='undefined') {
            el2.value = field.value + ',';
        } else {
            for (i = 0; i < field.length; i++) {
                if (field[i].checked == true) el2.value += field[i].value + ',';
		    }            
        }
		switch (action) {   
            case 'correspondence' :
                document.list.action = 'correspondence.asp';
                break;
            case 'email' :
                document.list.action = '/deelnemer/messaging/default.asp';
                break;
            case 'pictures' :
                document.list.action = '../students/l_pictures.asp';
                break; 
            case 'deelnemen' :
                document.list.action = '../projects/add_deelnemers.asp';
                break; 
            case 'prorel' :
                document.list.action = '../projects/add_prorel.asp'
                break; 
            case 'toexcel' :
                document.list.action = 'selection_to_excel.asp';
                break; 
        }
        el2.value += '0';

        document.list.appendChild(el);
        document.list.appendChild(el2);
       
        
        document.list.submit();
    }
   	</script>	
    
    <a title="Bericht versturen" href="javascript: go('email','deelnemers');"><img src="/images/buttons/i.p.writenew.gif" />&nbsp;E-mail</a>
    <span class="divider">|</span>
</div>

<%	
	dim sql, fields, orderby, rs
	
    sql = sql & " select bounum.id,"
    sql = sql & " bounum.extnum, coalesce(relati.voorle + ' ','') + coalesce(relati.tussen + ' ','') + coalesce(relati.achter,'') as naam"
    ' sql = sql & " relati.adrnum,relati.adrpos,relati.adrpla, relati.adrtel,relati.adrema "
    sql = sql & " , relati.adrpla, relati.adrtel,relati.adrema, relati_id "
    sql = sql & " from vw_prodee"
    sql = sql & " left join relati on vw_prodee.relati_id = relati.id"
    sql = sql & " left join bounum on vw_prodee.voorkeur = bounum.id"
    sql = sql & " where vw_prodee.status_id=18"
    sql = sql & " and vw_prodee.projec_id in (" & session("projec_id") & ")"
    sql = sql & " and visible_to_others = 1" 

'rw sql


	fields = ""
	fields = fields & "$name:=id;type:=checkbox;boundcolumn:=relati_id;$"
	fields = fields & "$name:=adrema;type:=email;$"
	fields = fields & "$name:=relati_id;type:=hidden;$"
	orderby = "[ord] asc"
	r_list sql, fields, orderby
%>
<!-- #include file="../../templates/footers/content.asp" -->
