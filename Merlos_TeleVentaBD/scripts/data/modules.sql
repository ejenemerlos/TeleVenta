

BEGIN TRY

MERGE INTO [Modules] AS Target
USING (VALUES
  (N'Cliente_Acciones',N'flx-html',N'project',N'Vendedor',NULL,N'Registro de Llamadas',N'Registro de Llamadas',N'default',1,0,1,0,NULL,NULL,N'<div id="dvRegLlamadas" style=''max-height:280px;overflow:hidden;overflow-y:auto;''></div>

<script>
cargarLlamadasCliente();
function cargarLlamadasCliente(){
	' + convert(nvarchar(max),NCHAR(36)) + N'("#dvRegLlamadas").html(icoCargando16+" <span class=''fadeIO'' style=''color:#1f8eee;''>cargando datos...</span>"); 
	var ClienteCodigo = ' + convert(nvarchar(max),NCHAR(36)) + N'.trim(' + convert(nvarchar(max),NCHAR(36)) + N'("#spanClienteCodigo").text());
	if(ClienteCodigo===undefined || ClienteCodigo===""){ setTimeout(function(){ cargarLlamadasCliente(); },100); return; }
	var parametros = ''{"modo":"llamadasDelCliente","cliente":"''+ClienteCodigo+''"}'';
	flexygo.nav.execProcess(''pLlamadas'','''',null,null,[{''key'':''parametros'',''value'':limpiarCadena(parametros)}],''modal640x480'',false,' + convert(nvarchar(max),NCHAR(36)) + N'(this),function(ret){
		if(ret){  
				var js = JSON.parse(limpiarCadena(ret.JSCode));
				var contenido = "<table class=''tbStdP''>"
							  + "	<tr>"
							  + "		<th>Usuario</th>"
							  + "		<th class=''C''>Fecha</th>"
							  + "		<th>Pedido</th>"
							  + "		<th>Importe</th>"
							  + "	</tr>";
				if(js.length>0){
					for(var i in js){
						var  laLetra= ' + convert(nvarchar(max),NCHAR(36)) + N'.trim(js[i].idpedido).substring(6,8);
						var elImporte = parseFloat(' + convert(nvarchar(max),NCHAR(36)) + N'.trim(js[i].ic[0].importe)).toFixed(2);
						var elPedido = ' + convert(nvarchar(max),NCHAR(36)) + N'.trim(js[i].pedido);
						if(elPedido==="NO!"){ elPedido="Sin Pedido"; } else { elPedido = laLetra+"-"+elPedido}
						if(isNaN(elImporte)){ elImporte= ""; } else {elImporte = elImporte+" &euro;";}
						contenido +="<tr title=''"+' + convert(nvarchar(max),NCHAR(36)) + N'.trim(js[i].observa)+"''>"
								  + "	<td>"+' + convert(nvarchar(max),NCHAR(36)) + N'.trim(js[i].usuario)+"</td>"
								  + "	<td class=''C''>"+' + convert(nvarchar(max),NCHAR(36)) + N'.trim(js[i].fecha)+"</td>"
								  + "	<td>"+elPedido+"</td>"
								  + "	<td class=''R''>"+elImporte+"</td>"
								  + "</tr>";
					}
					contenido += "</table>";
				}else{ contenido = "<span style=''color:#1f8eee;''>Sin registros de llamadas!</span>"; }
			
			' + convert(nvarchar(max),NCHAR(36)) + N'("#dvRegLlamadas").html(contenido);
		}else{ alert("Error SP: pLlamadas - llamadasDelCliente !!!"+JSON.stringify(ret)); }	
	},false);
}


</script>',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,N'flow-chart-2',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,N'' + convert(nvarchar(max),NCHAR(36)) + N'("flx-module[modulename=''Cliente_Acciones''] .icon-minus").click();',0,0,0,NULL,NULL,NULL,NULL,NULL,0,0,0,NULL,0,NULL,NULL,0,0,NULL,0,1,1)
 ,(N'Cliente_Datos',N'flx-view',N'project',N'Cliente',N'(CODIGO=''{{CODIGO}}'')',N'Cliente_Datos',N'Datos del Cliente',N'default',0,0,1,0,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,N'client',NULL,NULL,N'DataConnectionString',NULL,NULL,N'Cliente_Datos',NULL,NULL,NULL,0,0,0,NULL,NULL,NULL,NULL,NULL,0,0,0,NULL,0,NULL,NULL,0,0,NULL,0,1,1)
 ,(N'Cliente_Incidencias',N'flx-html',N'project',NULL,NULL,N'Cliente_Incidencias',N'Incidencias',N'default',0,0,1,0,NULL,NULL,N'<div id="dvRegInci"></div>

<script>
cargarIncidenciasCliente();
function cargarIncidenciasCliente(){
	' + convert(nvarchar(max),NCHAR(36)) + N'("#dvRegInci").html(icoCargando16+" <span class=''fadeIO'' style=''color:#1f8eee;''>cargando datos...</span>"); 
	var ClienteCodigo = ' + convert(nvarchar(max),NCHAR(36)) + N'.trim(' + convert(nvarchar(max),NCHAR(36)) + N'("#spanClienteCodigo").text());
	if(ClienteCodigo===undefined || ClienteCodigo===""){ setTimeout(function(){ cargarIncidenciasCliente(); },100); return; }
	var parametros = ''{"modo":"incidenciasDelCliente","cliente":"''+ClienteCodigo+''"}'';
	flexygo.nav.execProcess(''pLlamadas'','''',null,null,[{''key'':''parametros'',''value'':limpiarCadena(parametros)}],''modal640x480'',false,' + convert(nvarchar(max),NCHAR(36)) + N'(this),function(ret){
		if(ret){
			var js = JSON.parse(limpiarCadena(ret.JSCode));
			var inciArtNum = js.inciArt.length;
			var inciPedNum = js.inciPed.length;
			
			var inciArtCont = "<table class=''tbStd''>"
							+ "<tr>"
						    + "	<th>Fecha</th>"
						    + "	<th>Artículo</th>"
						    + "	<th>Incidencia</th>"
						    + "	<th>Observaciones</th>"
						    + "</tr>"; 
			for(var a in js.inciArt){ 
				var obs = js.inciArt[a].observaciones; if(obs===null){ obs=""; }
				var inciArtDesc = js.inciArt[a].incidencia+" - "+js.inciArt[a].c[0].ia[0].nombre;
				var inciArtObs = js.inciArt[a].observaciones;
				if(js.inciArt[a].c[0].ia[0].nombre===null){ inciArtDesc=""; }
				if(js.inciArt[a].observaciones===null){ inciArtObs=""; }
				inciArtCont +="<tr title=''"+obs+"''>"
						    + "	<td>"+js.inciArt[a].c[0].fecha+"</td>"
						    + "	<td>"+js.inciArt[a].articulo+" - "+js.inciArt[a].c[0].ia[0].va[0].nArticulo+"</td>"
						    + "	<td>"+inciArtDesc+"</td>"
						    + "	<td>"+inciArtObs+"</td>"
						    + "</tr>"; 
			}
			inciArtCont +="</table><br><br>";
			
			var inciPedCont = "<table class=''tbStd''>"
							+ "<tr>"
						    + "	<th>Fecha</th>"
						    + "	<th>Pedido</th>"
						    + "	<th>Incidencia</th>"
						    + "	<th>Observaciones</th>"
						    + "</tr>"; 
			for(var b in js.inciPed){ 
				obs = js.inciPed[b].observaciones; if(obs===null){ obs=""; }
				inciPedCont +="<tr>"
						    + "	<td>"+js.inciPed[b].c[0].fecha+"</td>"
						    + "	<td>"+js.inciPed[b].c[0].pedido+"</td>"
						    + "	<td>"+js.inciPed[b].incidencia+" - "+js.inciPed[b].c[0].nombre+"</td>"
						    + "	<td>"+js.inciPed[b].observaciones+"</td>"
						    + "</tr>"; 
			}
			inciPedCont +="</table>";
			
			var contenido = "<div id=''dvIncidenciasCliente''>"
						  + "	<div class=''dvSub'' onclick=''incidenciasIO(\"dvInciArt\",\""+inciArtNum+"\")''>Incidencias de Artículos ("+inciArtNum+")</div>"
						  + "	<div id=''dvInciArt'' class=''dvInci inv'' style=''max-height:350px;overflow:hidden;overflow-y:auto;''>"+inciArtCont+"</div>"
						  + "	<div class=''dvSub'' onclick=''incidenciasIO(\"dvInciPed\",\""+inciPedNum+"\")''>Incidencias de Pedidos ("+inciPedNum+")</div>"
						  + "	<div id=''dvInciPed'' class=''dvInci inv'' style=''max-height:350px;overflow:hidden;overflow-y:auto;''>"+inciPedCont+"</div>"
						  + "</div>";
			' + convert(nvarchar(max),NCHAR(36)) + N'("#dvRegInci").html(contenido);
		}else{ alert("Error SP: pLlamadas!!!"+JSON.stringify(ret)); }	
	},false);
}


function incidenciasIO(dv, nm) {
    if (parseInt(nm) > 0) {
        ' + convert(nvarchar(max),NCHAR(36)) + N'("#" + dv).stop();
        if (' + convert(nvarchar(max),NCHAR(36)) + N'("#" + dv).is(":visible")) { ' + convert(nvarchar(max),NCHAR(36)) + N'("#" + dv).slideUp(); }
        else { ' + convert(nvarchar(max),NCHAR(36)) + N'(".dvInci").hide(); ' + convert(nvarchar(max),NCHAR(36)) + N'("#" + dv).slideDown(); }
    }
}
</script>',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,N'admin1',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,0,0,NULL,NULL,NULL,NULL,NULL,0,0,0,NULL,0,NULL,NULL,0,0,NULL,0,1,1)
 ,(N'Cliente_Pasos',N'flx-view',N'project',N'Cliente',N'(CODIGO=''{{CODIGO}}'')',N'Cliente_Pasos',N'Cliente_Pasos',N'none',1,1,1,0,NULL,NULL,N'<span class="btn btn-info" onclick=''flexygo.nav.openPageName("TeleVenta","","","{\"CODIGO\":\"{{CODIGO}}\"}","current",false,' + convert(nvarchar(max),NCHAR(36)) + N'(this));''><span title="Llamada" class="flx-icon icon-phone icon-margin-right"></span><span class="hidden-m">Llamada</span></span>',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,N'noicon',NULL,NULL,N'DataConnectionString',NULL,NULL,NULL,NULL,NULL,NULL,0,0,0,NULL,NULL,NULL,NULL,NULL,0,0,0,NULL,0,NULL,NULL,0,0,NULL,0,1,1)
 ,(N'Cliente_Pedidos',N'flx-objectlist',N'project',N'Pedidos',N'CLIENTE=''{{CODIGO}}''',N'Cliente_Pedidos',N'Pedidos',N'default',1,0,1,0,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,N'document1',N'syspager-listboth',10,NULL,N'systb-search',NULL,N'PedidosPlantilla01',NULL,NULL,NULL,0,0,0,NULL,NULL,NULL,NULL,NULL,0,0,0,NULL,0,NULL,NULL,0,0,NULL,0,1,1)
 ,(N'Cliente_view_cabecera',N'flx-html',N'project',NULL,N'(CODIGO=''{{CODIGO}}'')',N'Cliente_view_cabecera',N'Encabezado cliente',N'none',1,1,1,0,NULL,NULL,N'<table class="tbS">
  <tr>
    <th>
		<span class="flx-icon icon-phone" style="color:green;font:"></span> 
		<span style="font:bold 12px arial;">LLAMADAS </span> 
		<span id="spanLlamadas" style="font:bold 12px arial;"></span>
	</th>
    <th>
		<span class="flx-icon icon-document" style="color:orange;"></span> 
		<span style="font:bold 12px arial;">PEDIDOS </span> 
		<span id="spanPedidos" style="font:bold 12px arial;"></span>
	</th>
    <th>
		<span class="flx-icon icon-euros" style="color:#5DB5E6;"></span> 
		<span style="font:bold 12px arial;">IMPORTE </span> 
		<span id="spanImporte" style="font:bold 12px arial;"></span>
	</th>
  </tr>  
</table>


<script>
cargarDatosCliente();
function cargarDatosCliente(){
	var ClienteCodigo = ' + convert(nvarchar(max),NCHAR(36)) + N'.trim(' + convert(nvarchar(max),NCHAR(36)) + N'("#spanClienteCodigo").text());
	if(ClienteCodigo===undefined || ClienteCodigo===""){ setTimeout(function(){ cargarDatosCliente(); },100); return; }
	flexygo.nav.execProcess(''pClienteDatos'','''',null,null
		,[{''key'':''cliente'',''value'':ClienteCodigo},{''key'':''modo'',''value'':''datos''}],''modal640x480'',false,' + convert(nvarchar(max),NCHAR(36)) + N'(this),function(ret){
		if(ret){ 
			try{
				var js = JSON.parse(ret.JSCode);
				' + convert(nvarchar(max),NCHAR(36)) + N'("#spanLlamadas").html(js[0].numLlamadas);
				' + convert(nvarchar(max),NCHAR(36)) + N'("#spanPedidos").html(js[0].numPedidos);
				' + convert(nvarchar(max),NCHAR(36)) + N'("#spanImporte").html(js[0].ImportePedidos);
			}
			catch{}
		}else{ alert("Error SP: pLlamadas!!!"+JSON.stringify(ret)); }	
	},false);
}

</script>',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,N'noicon',NULL,NULL,N'DataConnectionString',NULL,NULL,NULL,NULL,NULL,NULL,0,0,0,NULL,NULL,NULL,NULL,NULL,0,0,0,NULL,0,NULL,NULL,0,0,NULL,0,1,1)
 ,(N'Clientes_Listado',N'flx-objectlist',N'system',N'Clientes',N'{{ObjectWhere}}',N'Lisado de Clientes',N'{{ObjectDescrip}}',N'default',0,0,1,1,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,N'sysobjecticon',N'syspager-listboth',25,NULL,N'systb-search',N'systb-row',NULL,NULL,NULL,NULL,0,0,0,NULL,NULL,NULL,NULL,NULL,0,0,0,NULL,0,NULL,NULL,0,0,NULL,0,1,1)
 ,(N'Configuracion',N'flx-html',N'project',NULL,NULL,N'Configuracion',N'Configuracion',N'none',1,1,1,0,NULL,NULL,N'<div id="dvMerlosConfiguracion"></div>
<script> ' + convert(nvarchar(max),NCHAR(36)) + N'("#dvMerlosConfiguracion").load("./Merlos/html/MerlosConfiguracion.html"); </script>',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,N'noicon',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,0,0,NULL,NULL,NULL,NULL,NULL,0,0,0,NULL,0,NULL,NULL,0,0,NULL,0,1,1)
 ,(N'Contactos',N'flx-sqllist',N'project',N'Contactos',N'CLIENTE=''{{CODIGO}}''',N'Contactos',N'Contactos',N'default',1,0,1,0,N'select * from vContactos where CLIENTE=''{{CODIGO}}''',N'<div id="dvContactosBotonera" style="padding:10px;">
  <span class="MIbotonGreen esq05" style="margin:10px;"
     onclick="' + convert(nvarchar(max),NCHAR(36)) + N'(''#dvContactosBotonera'').hide();' + convert(nvarchar(max),NCHAR(36)) + N'(''#dvContactosCampos'').slideDown();">Nuevo</span>
</div>
<div id="dvContactosCampos" class="inv" style="padding:10px;">
	<table class="tbStd">
      	<tr>
          	<th>Nombre</th>
            <th>Cargo</th>
            <th>email</th>
            <th>Teléfono</th>
      	</tr>
      	<tr>
          	<td><input type="text" id="inpCnombre"></td>
          	<td><input type="text" id="inpCcargo"></td>
          	<td><input type="text" id="inpCemail"></td>
          	<td><input type="text" id="inpCtelefono"></td>
      	</tr>
      	<tr>
          	<td colspan="3"></td>
          	<td class="C">
              	<span class="MIbotonGreen esq05" onclick="guardarContacto()">guardar</span>
              	&nbsp;&nbsp;&nbsp;<span class="MIbotonRed esq05" onclick="' + convert(nvarchar(max),NCHAR(36)) + N'(''#dvContactosBotonera'').slideDown();' + convert(nvarchar(max),NCHAR(36)) + N'(''#dvContactosCampos'').hide();">cancelar</span>
          	</td>
      	</tr>
  	</table>
</div>

<div id="dvContactos" style="padding:10px;">
<table id="tbContactos" class="tbStd">
  <tr>
    <th>Nombre</th>
    <th>Cargo</th>
    <th>email</th>
    <th>Teléfono</th>
</tr>',N'<tr>
  <td>{{PERSONA}}</td>
  <td>{{CARGO}}</td>
  <td>{{EMAIL}}</td>
  <td>{{TELEFONO}}</td>
</tr>',N'</table>
</div>',N'<div id="dvContactosBotoneraV" style="padding:10px;">
  <span class="MIbotonGreen esq05" style="margin:10px;"
     onclick="' + convert(nvarchar(max),NCHAR(36)) + N'(''#dvContactosBotoneraV'').hide();' + convert(nvarchar(max),NCHAR(36)) + N'(''#dvContactosCamposV'').slideDown();">Nuevo</span>
</div>
<div id="dvContactosCamposV" class="inv" style="padding:10px;">
	<table class="tbStd">
      	<tr>
          	<th>Nombre</th>
            <th>Cargo</th>
            <th>email</th>
            <th>Teléfono</th>
      	</tr>
      	<tr>
          	<td><input type="text" id="inpCnombreV"></td>
          	<td><input type="text" id="inpCcargoV"></td>
          	<td><input type="text" id="inpCemailV"></td>
          	<td><input type="text" id="inpCtelefonoV"></td>
      	</tr>
      	<tr>
          	<td colspan="3"></td>
          	<td class="C">
              	<span class="MIbotonGreen esq05" onclick="guardarContacto(true)">guardar</span>
              	&nbsp;&nbsp;&nbsp;<span class="MIbotonRed esq05" onclick="' + convert(nvarchar(max),NCHAR(36)) + N'(''#dvContactosBotoneraV'').slideDown();' + convert(nvarchar(max),NCHAR(36)) + N'(''#dvContactosCamposV'').hide();">cancelar</span>
          	</td>
      	</tr>
  	</table>
</div>
',NULL,N'  
var contClienteCodigo = "";
if((flexygo.history.get(' + convert(nvarchar(max),NCHAR(36)) + N'(''main'')).defaults)!==null){
	var contelJSON = JSON.parse( (flexygo.history.get(' + convert(nvarchar(max),NCHAR(36)) + N'(''main'')).defaults).replace(/''/g,"_l_").replace(/"/g,"''").replace(/_l_/g,''"'') );
	contClienteCodigo = contelJSON.CODIGO;
}

function guardarContacto(io){  
  	var persona = ' + convert(nvarchar(max),NCHAR(36)) + N'.trim(' + convert(nvarchar(max),NCHAR(36)) + N'("#inpCnombreV").val());
  	var cargo = ' + convert(nvarchar(max),NCHAR(36)) + N'.trim(' + convert(nvarchar(max),NCHAR(36)) + N'("#inpCcargoV").val());
  	var email = ' + convert(nvarchar(max),NCHAR(36)) + N'.trim(' + convert(nvarchar(max),NCHAR(36)) + N'("#inpCemailV").val());
  	var telefono = ' + convert(nvarchar(max),NCHAR(36)) + N'.trim(' + convert(nvarchar(max),NCHAR(36)) + N'("#inpCtelefonoV").val());
    if(!io){
    	persona = ' + convert(nvarchar(max),NCHAR(36)) + N'.trim(' + convert(nvarchar(max),NCHAR(36)) + N'("#inpCnombre").val());
        cargo = ' + convert(nvarchar(max),NCHAR(36)) + N'.trim(' + convert(nvarchar(max),NCHAR(36)) + N'("#inpCcargo").val());
        email = ' + convert(nvarchar(max),NCHAR(36)) + N'.trim(' + convert(nvarchar(max),NCHAR(36)) + N'("#inpCemail").val());
        telefono = ' + convert(nvarchar(max),NCHAR(36)) + N'.trim(' + convert(nvarchar(max),NCHAR(36)) + N'("#inpCtelefono").val());
    }
  	var elJS = ''{"modo":"guardar","cliente":"''+contClienteCodigo+''","persona":"''+persona+''","cargo":"''+cargo+''","email":"''+email+''","telefono":"''+telefono+''",''+paramStd+''}'';
	flexygo.nav.execProcess(''pContactos'','''',null,null,[{''Key'':''elJS'',''Value'':limpiarCadena(elJS)}], ''modal640x480'', false, ' + convert(nvarchar(max),NCHAR(36)) + N'(this), function(ret){if(ret){		
      	' + convert(nvarchar(max),NCHAR(36)) + N'("flx-module[modulename=''Contactos''] .icon-sincronize").click();
	}else{ alert("Error SP: pConfiguracion!!!\n"+ret); }}, false);
}

' + convert(nvarchar(max),NCHAR(36)) + N'("flx-module[modulename=''Contactos''] .icon-minus").click();',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,N'contacts-2',NULL,10,N'DataConnectionString',NULL,NULL,NULL,NULL,NULL,NULL,0,0,0,NULL,NULL,NULL,NULL,NULL,0,0,0,NULL,0,NULL,NULL,0,0,NULL,0,1,1)
 ,(N'inciCLIlistado',N'flx-objectlist',N'project',N'{{ObjectName}}',N'{{ObjectWhere}}',N'Incidencias de Clientes',N'Incidencias de Clientes',N'default',1,1,1,1,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,N'accepted-2',N'syspager-listheader',100,NULL,N'systb-list',N'systb-row',NULL,NULL,NULL,NULL,0,0,0,NULL,NULL,NULL,NULL,NULL,0,0,0,NULL,0,NULL,NULL,0,0,NULL,0,1,1)
 ,(N'Merlos_Clientes_Articulos',N'flx-html',N'project',NULL,NULL,N'Merlos_Clientes_Articulos',N'Inclusión/Exclusión de artículos en pedidos',N'default',0,0,1,0,NULL,NULL,N'<div class="CliArt_dvMenu CliArt_dv">
    <span class="MIbotonGreen esq05" style="margin:10px;" onclick="CliArt_NuevoRegistro_Click()">Nuevo Registro</span>
</div>
<div id="CliArt_dvListado" class=" CliArt_dv" style="padding:10px;"></div>
<div id="CliArt_dvArticulos" class=" CliArt_dv" style="padding:10px; display:none;"></div>

<div style="display:none;">
    <input type="text" id="inpClienteCodigo" value="{{CODIGO}}" />
</div>


<script>
    var CliArt_ClienteCodigo = ' + convert(nvarchar(max),NCHAR(36)) + N'.trim(' + convert(nvarchar(max),NCHAR(36)) + N'("#inpClienteCodigo").val());

    CliArt_CargarArticulos();

    function CliArt_CargarArticulos() {
        var contenido = "";
        var parametros = { "ClienteCodigo": CliArt_ClienteCodigo, "jsUser": jsUser };
        flexygo.nav.execProcess(''pPers_CliArt_CargarArticulos'', '''', null, null, [{ key: ''parametros'', value: JSON.stringify(parametros) }], ''current'', false, ' + convert(nvarchar(max),NCHAR(36)) + N'(this), function (ret) {
            if (ret) {console.log(ret.JSCode);
                var js = JSON.parse(ret.JSCode);
                if (js.error === "") {
                    jsr = js.respuesta;
                    if (jsr.length > 0) {
                        contenido = `
                            <div style="display:flex; gap:10px;">
                                <input type="text" id="CliArt_inpArtBuscadorPrincipal" placeholder="buscar"
                                style="flex:1;padding:5px; outline:none; border:none; background:#f2f2f2;"
                                onkeyup="buscarEnGrid(this.id,''CliArt_dvListaDeArticulosPrincipal'')">
                            </div>
                            <div style="margin-top:10px; display:grid; grid-template-columns: 2fr 5fr 1fr 1fr; gap:1px; border-bottom:1px solid #CCC;">
                                <div style="padding:5px; background:#999; font:16px arial; color:#FFF;">Artículo</div>
                                <div style="padding:5px; background:#999; font:16px arial; color:#FFF;">Descripción</div>
                                <div style="padding:5px; background:#999; font:16px arial; color:#FFF; text-align:center;">Incluir</div>
                                <div style="padding:5px; background:#999; font:16px arial; color:#FFF; text-align:center;">Excluir</div>
                            </div>
                            <div id="CliArt_dvListaDeArticulosPrincipal" style="border-bottom:2px solid #CCC; max-height:300px; overflow:hidden; overflow-y:auto;">
                        `;
                        for (var i in jsr) {
                            var incluir_Ckeck_Color = "#333";
                            var excluir_Ckeck_Color = "#333";
                            var incluir_Ckeck = icoCheckO;
                            var excluir_Ckeck = icoCheckO;
                            if (jsr[i].IncluirExcluir === 1) { incluir_Ckeck = icoCheckI; incluir_Ckeck_Color = "green"; }
                            if (jsr[i].IncluirExcluir === 2) { excluir_Ckeck = icoCheckI; excluir_Ckeck_Color = "green"; }

                            contenido += `
                                <div class="dvTR2 buscarEnGridTR" style="display:grid; grid-template-columns: 2fr 5fr 1fr 1fr; gap:1px;"
                                data-buscar="' + convert(nvarchar(max),NCHAR(36)) + N'{' + convert(nvarchar(max),NCHAR(36)) + N'.trim(jsr[i].Articulo)} ' + convert(nvarchar(max),NCHAR(36)) + N'{' + convert(nvarchar(max),NCHAR(36)) + N'.trim(jsr[i].Descripcion)}">
                                    <div class="codigo" style="padding:4px;">' + convert(nvarchar(max),NCHAR(36)) + N'{' + convert(nvarchar(max),NCHAR(36)) + N'.trim(jsr[i].Articulo)}</div>
                                    <div style="padding:4px;">' + convert(nvarchar(max),NCHAR(36)) + N'{' + convert(nvarchar(max),NCHAR(36)) + N'.trim(jsr[i].Descripcion)}</div>
                                    <div class="incluir" style="padding:4px; text-align:center; color:' + convert(nvarchar(max),NCHAR(36)) + N'{incluir_Ckeck_Color};" onclick="CliArt_IncluirExcluir(this)">' + convert(nvarchar(max),NCHAR(36)) + N'{incluir_Ckeck}</div>
                                    <div class="excluir" style="padding:4px; text-align:center; color:' + convert(nvarchar(max),NCHAR(36)) + N'{excluir_Ckeck_Color};" onclick="CliArt_IncluirExcluir(this)">' + convert(nvarchar(max),NCHAR(36)) + N'{excluir_Ckeck}</div>
                                </div>
                            `;
                        }
                        contenido += "</div>";
                    } else { contenido = "Sin resultados!"; }
                } else { contenido = js.error; }
                ' + convert(nvarchar(max),NCHAR(36)) + N'("#CliArt_dvListado").html(contenido);
            }
        }, false);
    }

    function CliArt_NuevoRegistro_Click() {
        ' + convert(nvarchar(max),NCHAR(36)) + N'("#CliArt_dvListado").hide();
        ' + convert(nvarchar(max),NCHAR(36)) + N'("#CliArt_dvArticulos").html(`
            <div style="display:flex; gap:10px;">
                <input type="text" id="CliArt_inpArtBuscador" placeholder="buscar"
                style="flex:1;padding:5px; outline:none; border:none; background:#f2f2f2;"
                onkeyup="CliArt_NuevoRegistro_Buscar()">
                <i class="flx-icon icon-close" style="cursor:pointer; font-size:20px;" 
                onclick="CliArt_CargarArticulos(); ' + convert(nvarchar(max),NCHAR(36)) + N'(''#CliArt_dvListado'').show(); ' + convert(nvarchar(max),NCHAR(36)) + N'(''#CliArt_dvArticulos'').hide();"></i>
            </div>
        `).slideDown();  
        
        if(dameValorJSON(flexygo.context.MerlosConfiguracion,"CargaArtDef")==="1"){ CliArt_NuevoRegistro_Buscar("todos"); }
    }

    function CliArt_NuevoRegistro_Buscar(todos){
        if(event.key==="Enter" || todos){
            var buscar = ' + convert(nvarchar(max),NCHAR(36)) + N'.trim(' + convert(nvarchar(max),NCHAR(36)) + N'("#CliArt_inpArtBuscador").val());
            if(buscar==""){buscar="todos";}
            if(todos){ CliArt_ClienteCodigo=todos; }else{CliArt_ClienteCodigo=' + convert(nvarchar(max),NCHAR(36)) + N'.trim(' + convert(nvarchar(max),NCHAR(36)) + N'("#inpClienteCodigo").val());}
            if(buscar!=="" || todos){
                var parametros = { "ClienteCodigo": CliArt_ClienteCodigo, "buscar": buscar, "jsUser": jsUser };
                flexygo.nav.execProcess(''pPers_Articulos'', '''', null, null, [{ key: ''parametros'', value: JSON.stringify(parametros) }], ''current'', false, ' + convert(nvarchar(max),NCHAR(36)) + N'(this), function (ret) {
                    if (ret) {
                        var datos = "";
                        var js = JSON.parse(ret.JSCode);
                        if (js.error === "") {
                            jsr = js.respuesta;
                            if (jsr.length > 0) {
                                contenido = `  
                                    <div style="display:flex; gap:10px;">
                                        <input type="text" id="CliArt_inpArtBuscador" placeholder="buscar"
                                        style="flex:1;padding:5px; outline:none; border:none; background:#f2f2f2;"
                                        onkeyup="CliArt_NuevoRegistro_Buscar()">
                                        <i class="flx-icon icon-close" style="cursor:pointer; font-size:20px;" 
                                        onclick="CliArt_CargarArticulos(); ' + convert(nvarchar(max),NCHAR(36)) + N'(''#CliArt_dvListado'').show(); ' + convert(nvarchar(max),NCHAR(36)) + N'(''#CliArt_dvArticulos'').hide();"></i>
                                    </div>
                                    <div style="margin-top:10px; display:grid; grid-template-columns: 2fr 5fr 1fr 1fr; gap:1px; border-bottom:1px solid #CCC;">
                                        <div style="padding:5px; background:#999; font:16px arial; color:#FFF;">Artículo</div>
                                        <div style="padding:5px; background:#999; font:16px arial; color:#FFF;">Descripción</div>
                                        <div style="padding:5px; background:#999; font:16px arial; color:#FFF; text-align:center;">Incluir</div>
                                        <div style="padding:5px; background:#999; font:16px arial; color:#FFF; text-align:center;">Excluir</div>
                                    </div>
                                    <div id="CliArt_dvListaDeArticulos" style="border-bottom:2px solid #CCC; max-height:300px; overflow:hidden; overflow-y:auto;">
                                `;
                                for (var i in jsr) {
                                    var incluir_Ckeck = icoCheckO;
                                    var excluir_Ckeck = icoCheckO;
                                    if (jsr[i].IncluirExcluir === 1) { incluir_Ckeck = icoCheckI; }
                                    if (jsr[i].IncluirExcluir === 2) { excluir_Ckeck = icoCheckI; }

                                    contenido += `
                                        <div class="dvTR2 buscarEnGridTR" style="display:grid; grid-template-columns: 2fr 5fr 1fr 1fr; gap:1px;"
                                        data-buscar="' + convert(nvarchar(max),NCHAR(36)) + N'{' + convert(nvarchar(max),NCHAR(36)) + N'.trim(jsr[i].CODIGO)} ' + convert(nvarchar(max),NCHAR(36)) + N'{' + convert(nvarchar(max),NCHAR(36)) + N'.trim(jsr[i].NOMBRE)}">
                                            <div class="codigo" style="padding:4px;">' + convert(nvarchar(max),NCHAR(36)) + N'{' + convert(nvarchar(max),NCHAR(36)) + N'.trim(jsr[i].CODIGO)}</div>
                                            <div style="padding:4px;">' + convert(nvarchar(max),NCHAR(36)) + N'{' + convert(nvarchar(max),NCHAR(36)) + N'.trim(jsr[i].NOMBRE)}</div>
                                            <div class="incluir" style="padding:4px; text-align:center;" onclick="CliArt_IncluirExcluir(this)">' + convert(nvarchar(max),NCHAR(36)) + N'{incluir_Ckeck}</div>
                                            <div class="excluir" style="padding:4px; text-align:center;" onclick="CliArt_IncluirExcluir(this)">' + convert(nvarchar(max),NCHAR(36)) + N'{excluir_Ckeck}</div>
                                        </div>
                                    `;
                                }
                                contenido += "</div>";
                            } else { contenido = "Sin resultados!"; }
                        } else { contenido = js.error; }
                        ' + convert(nvarchar(max),NCHAR(36)) + N'("#CliArt_dvArticulos").html(contenido);
                    }
                }, false);
            }
        }
    }

    function CliArt_IncluirExcluir(elem) {
        var estado = 0;
        var claseClick = ' + convert(nvarchar(max),NCHAR(36)) + N'(elem).attr("class");
        var elemICO = ' + convert(nvarchar(max),NCHAR(36)) + N'(elem).html();
        var incluirValor = 0;
        var excluirValor = 0;
        var articulo = ' + convert(nvarchar(max),NCHAR(36)) + N'(elem).closest(''.dvTR2'').find(''.codigo'').text();        

        if (elemICO === icoCheckO) { ' + convert(nvarchar(max),NCHAR(36)) + N'(elem).html(icoCheckI).css("color", "green"); estado = 1; } else { ' + convert(nvarchar(max),NCHAR(36)) + N'(elem).html(icoCheckO).css("color", "#333"); }

        if (claseClick === "incluir" && estado === 1) { incluirValor = 1; ' + convert(nvarchar(max),NCHAR(36)) + N'(elem).closest(''.dvTR2'').find(''.excluir'').html(icoCheckO).css("color", "#333"); }
        if (claseClick === "excluir" && estado === 1) { excluirValor = 1; ' + convert(nvarchar(max),NCHAR(36)) + N'(elem).closest(''.dvTR2'').find(''.incluir'').html(icoCheckO).css("color", "#333"); }

        var parametros = { "ClienteCodigo": CliArt_ClienteCodigo, "articulo": articulo, "incluirValor": incluirValor, "excluirValor": excluirValor, "jsUser": jsUser };
        flexygo.nav.execProcess(''pPers_ClientesArticulos'', '''', null, null, [{ key: ''parametros'', value: JSON.stringify(parametros) }], ''current'', false, ' + convert(nvarchar(max),NCHAR(36)) + N'(this), function (ret) {
            if (ret) {

            }
        }, false);
    }
    
</script>
',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,N'articles',NULL,20,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,0,0,NULL,NULL,NULL,NULL,NULL,0,0,0,NULL,0,NULL,NULL,0,0,NULL,0,1,1)
 ,(N'Merlos_Clientes_Articulos_Masivo',N'flx-html',N'project',NULL,NULL,N'Merlos_Clientes_Articulos_Masivo',N'Clientes-Artículos Masivo',N'default',0,0,1,0,NULL,NULL,N'<div id="dvMerlos_Clientes_Articulos_Masivo"></div>
<script> ' + convert(nvarchar(max),NCHAR(36)) + N'("#dvMerlos_Clientes_Articulos_Masivo").load("./Merlos/html/Merlos_Clientes_Articulos_Masivo.html"); </script>',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,N'articles',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,0,0,NULL,NULL,NULL,NULL,NULL,0,0,0,NULL,0,NULL,NULL,0,0,NULL,0,1,1)
 ,(N'Merlos_Listados',N'flx-html',N'project',NULL,NULL,N'Merlos_Listados',N'Listados',N'default',0,0,1,0,NULL,NULL,N'<div id="dvConfiguracionTeleVenta" class="mi-module ListadoSeccion">
    <table id="tbConfiguracionOperador" class="tbFrm">
        <tr>
            <th>Nombre del listado</th>
            <th class="tbHover" onclick="listadosGestores()">Gestor <span class=''flR''>&#9660;</span></th>
            <th>Desde</th>
            <th>Hasta</th>
            <th></th>
        </tr>
        <tr>
            <td><input type="text" id="inpNombreListado" style="width:100%; text-align:left; color:#333;" onkeyup="autoNombreTV=false;"></td>
            <td style="position:relative;">
                <div id="dvListadoGestores" class="sombra" style="z-index:2; position:absolute; margin-top:-10px; padding:10px; background:#f2f2f2; border:1px solid #CCC; display:none;"></div>
                <div id="dvListadoTDGestores"></div>
            </td>
            <td class="taC"><input type="text" id="ListadosDesde" placeholder="dd-mm-aaaa" onfocus="(this.type=''date'')" onblur="(this.type=''text''); ListadosComprobarFechas();" style="width:90%; text-align:center;"></td>
            <td class="taC"><input type="text" id="ListadosHasta" placeholder="dd-mm-aaaa" onfocus="(this.type=''date'')" onblur="(this.type=''text''); ListadosComprobarFechas();" style="width:90%; text-align:center;"></td>
            <td class="taC"><input type="button" class="MIbotonGreen" value="GENERAR" style="width:90%; text-align:center;" onclick="ListadosGenerar();"></td>
        </tr>
    </table>
    <br>
</div>


<div id="dvBtnImp " class="ListadoSeccion inv MI_noImp " style="padding:20px; text-align:center; ">
    <span class="MIbotonGreen " onclick="window.print() ">IMPRIMIR</span>
    <span class="MIbotonGreen " style="margin-left:12px; " onclick="ListadosVolver() ">volver</span>
</div>


<div id="dvListadosSeccion " class="ListadoSeccion inv">
    <div style="background:#68CDF9; padding:5px; ">Listado</div>
    <div class="inp-fecha-agrup ">
        <input type="text " class="inpFechaDesdeListados" id="ListadoLlamadasDesde" placeholder="dd-mm-aaaa " onfocus="(this.type=''date'' ) " onblur="(this.type=''text'' ); " style="width:90%; text-align:center; ">
        <input type="text " class="inpFechaHastaListados" id="ListadosLlamadasHasta" placeholder="dd-mm-aaaa " onfocus="(this.type=''date'' ) " onblur="(this.type=''text'' ); " style="width:90%; text-align:center; ">
        <input type="button" readonly class="MIbotonGreen " onclick="listadosLlamadasBuscarEntreFechas(); " value="Buscar " style="width:20%; text-align:center; ">
    </div>
    <div id="dvBuscList ">
        <input type="text " id="dvBuscadorListadosListado " placeholder="Buscar por cualquiera de los campos " style="width:100%; box-sizing:border-box; " onkeyup="buscarEnTabla(this.id, ''tbListadosListado''); ">
    </div>
    <div id="dvListadosListado"></div>
    <br>
</div>


<div id="dvRegistrosTV " class="ListadoSeccion inv">
    <div style="background:#68CDF9; padding:5px; ">Registros TeleVenta</div>
    <div class="inp-fecha-agrup ">
        <input type="text " class="inpFechaDesdeListados" id="ListadoLlamadasDesdeReg" placeholder="dd-mm-aaaa " onfocus="(this.type=''date'' ) " onblur="(this.type=''text'' ); " style="width:90%; text-align:center; ">
        <input type="text " class="inpFechaHastaListados" id="ListadosLlamadasHastaReg" placeholder="dd-mm-aaaa " onfocus="(this.type=''date'' ) " onblur="(this.type=''text'' ); " style="width:90%; text-align:center; ">
        <input type="button " readonly class="MIbotonGreen " onclick="listadosLlamadasRegBuscarEntreFechas(); " value="Buscar " style="width:20%; text-align:center; ">
    </div>
    <div id="dvBusc ">
        <input type="text " id="dvBuscadorListados " placeholder="Buscar por cualquiera de los campos " style="width:100%; box-sizing:border-box; " onkeyup="buscarEnTabla(this.id, ''tbListadosTV''); ">
    </div>
    <div id="dvListadosTVListado"></div>
    <br>
</div>

<!-- <script>
    cargarListadosListado();
    cargarListadoTV();
</script> -->',NULL,NULL,NULL,N'    cargarListadosListado();
    cargarListadoTV();',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,N'bullet-list',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,0,0,NULL,NULL,NULL,NULL,NULL,0,0,0,NULL,0,NULL,NULL,0,0,NULL,0,1,1)
 ,(N'Merlos_Version',N'flx-html',N'project',NULL,NULL,N'Merlos_Version',N'Versioning',N'none',0,0,0,0,NULL,NULL,N'<div id="dvMerlosVersioning"></div>
<script> ' + convert(nvarchar(max),NCHAR(36)) + N'("#dvMerlosVersioning").load("./Merlos/html/MerlosVersion.html"); </script>',NULL,NULL,NULL,N'Merlos_Inicio();',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,N'noicon',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,0,0,NULL,NULL,NULL,NULL,NULL,0,0,0,NULL,0,NULL,NULL,0,0,NULL,0,1,1)
 ,(N'MI_ListadosLlamadas',N'flx-objectlist',N'project',N'ListadosLlamadas',NULL,N'Listados llamadas',N'Llamadas',N'default',1,1,1,0,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,N'noicon',NULL,NULL,NULL,N'List toolbar Merlos',NULL,NULL,NULL,NULL,NULL,0,0,0,NULL,NULL,NULL,NULL,NULL,0,0,0,NULL,0,NULL,NULL,0,0,NULL,0,1,1)
 ,(N'TV_Cliente',N'flx-html',N'project',NULL,NULL,N'TV_Cliente',N'TV_Cliente',N'none',1,1,1,0,NULL,NULL,N'<div class="tvTitulo esq1100">Cliente <span class=''MIbotonP FR esq05'' onclick=''verFichaDeCliente()''>Ver Cliente</span></div>
<div id="dvDatosDelCliente" style="border:1px solid #323f4b; padding:10px; border-sizing:border-box;"></div>
',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,N'noicon',NULL,NULL,NULL,NULL,NULL,NULL,NULL,N'moduloTV inv',NULL,0,0,0,NULL,NULL,NULL,NULL,NULL,0,0,0,NULL,0,NULL,NULL,0,0,NULL,0,1,1)
 ,(N'TV_Llamadas',N'flx-html',N'project',NULL,NULL,N'TV_Llamadas',N'TV_Llamadas',N'none',1,1,1,0,NULL,NULL,N'<div class="tvTitulo esq1100">
	Llamadas
	<div class="dvImg20 icoRecarga fR" onclick="recargarTVLlamadas(true)"></div>
	<span class="MIbotonP fR esq05" style="margin-right:20px;" onclick="anyadirCliente()">Añadir Cliente</span>
</div>
<div id="dvLlamadas" style="border:1px solid #323f4b; padding:10px; border-sizing:border-box;"></div>
',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,N'noicon',NULL,NULL,NULL,NULL,NULL,NULL,NULL,N'moduloTV inv',NULL,0,0,0,NULL,NULL,NULL,NULL,NULL,0,0,0,NULL,0,NULL,NULL,0,0,NULL,0,1,1)
 ,(N'TV_LlamadasTV',N'flx-html',N'project',NULL,NULL,N'TV_LlamadasTV',N'TV_LlamadasTV',N'none',0,0,0,0,NULL,NULL,N'<div class="tvTitulo esq1100">Llamadas Tele Venta</div>
<div id="dvLlamadasTeleVenta" class="mi-module"></div>
',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,N'flx-phone',N'syspager-listheader',20,NULL,N'systb-search',NULL,NULL,NULL,NULL,NULL,0,0,0,NULL,NULL,NULL,NULL,NULL,0,0,0,NULL,0,NULL,NULL,0,0,NULL,0,1,1)
 ,(N'TV_OpcionesLlamada',N'flx-html',N'project',NULL,NULL,N'TV_OpcionesLlamada',N'TV_OpcionesLlamada',N'none',1,1,1,0,NULL,NULL,N'<div id="dvOpcionesTV" class="tvTitulo esq1100" style="padding:10px; box-sizing:border-box;">
    <table id="tbOpciones">
        <tr>
            <td style="width:200px;">
                <div id="dvFechaTV" class="esq10" style="float:left; background:#FFF; padding:5px 10px; white-space:nowrap; font:bold 32px arial; color:#68CDF9;"></div>
            </td>
            <td>
                <div id="dvSerieTV" class="esq10" style="float:left; position:relative; margin-left:15px; background:#FFF; padding:5px 10px; white-space:nowrap; font:bold 32px arial; color:#68CDF9; vertical-align:middle;"></div>
            </td>
            <td>
                <div style="float:right; display:flex; align-items:center; justify-content:flex-end; gap:5px;">
                    <div id="btnTerminar" class="MIbotonW FR vaM inv" onclick=''terminarLlamada()'' style="white-space:nowrap;">Terminar Llamada</div>
                    <div id="btnPedido" class="MIbotonW FR vaM inv" onclick=''pedidoTV()''>Pedido</div>
                    <div id="btnClientes" class="MIbotonW FR vaM inv" onclick=''cargarClientes()''>Clientes</div>
                    <div id="btnConfiguracion" class="MIbotonW FR vaM inv" onclick=''configurarTeleVenta()''>Configuración</div>
                </div>
            </td>
        </tr>
        <tr>
            <td colspan="3">
                <div style="margin-top:10px;">
                    <div id="dvEstTV" class="vaM" style="padding:0;white-space:nowrap; font:bold 16px arial; color:#FFF;"></div>
                    <div id="dvFiltrosTV" class="vaM" style="padding:0;margin-top:8px;font:14px arial; color:#666;"></div>
                </div>
            </td>
        </tr>
    </table>
</div>


<!--
<div id="dvOpcionesTV" class="tvTitulo esq1100" style="padding:10px; box-sizing:border-box;">
	<div id="tbOpciones" style="overflow:hidden;">
		<div id="dvFechaTV" class="esq10" style="float:left; background:#FFF; padding:5px 10px; white-space:nowrap; font:bold 32px arial; color:#68CDF9;"></div>
		<div id="dvSerieTV" class="esq10" style="float:left; position:relative; margin-left:15px; background:#FFF; padding:5px 10px; white-space:nowrap; font:bold 32px arial; color:#68CDF9; vertical-align:middle;"></div>
		<div style="float:right; display:flex; align-items:center; justify-content:flex-end; gap:5px;">
			<div id="btnTerminar" class="MIbotonW FR vaM inv" onclick=''terminarLlamada()'' style="white-space:nowrap;">Terminar Llamada</div>
			<div id="btnPedido" class="MIbotonW FR vaM inv" onclick=''pedidoTV()''>Pedido</div>
			<div id="btnClientes" class="MIbotonW FR vaM inv" onclick=''cargarClientes()''>Clientes</div>
			<div id="btnConfiguracion" class="MIbotonW FR vaM inv" onclick=''configurarTeleVenta()''>Configuración</div>
		</div>
	</div>
	<div style="margin-top:10px;">
		<div id="dvEstTV" class="vaM" style="padding:0;white-space:nowrap; font:bold 16px arial; color:#FFF;"></div>
		<div id="dvFiltrosTV" class="vaM" style="padding:0;margin-top:8px;font:14px arial; color:#666;"></div>
	</div>
</div>
-->

<div id="dvConfiguracionTeleVenta" class="mi-module">
    <table id="tbConfiguracionOperador" class="tbFrm">
        <tr>
            <th colspan="2" class="thO" style="vertical-align:middle; text-align:left;">Nombre registro llamadas</th>
            <td colspan="6" id="inputDatosNombreTV">
                <input type="text" id="inpNombreTV" style="width:100%; text-align:left; color:#333;" onkeyup="autoNombreTV=false;">
            </td>
            <td style="vertical-align:middle; text-align:center;">
                <div class=''img30 icoRecarga'' onclick="resetFrm(''OpcionesTV'')"></div>
            </td>
        </tr>
        <tr>
            <th style="width:11%;">Gestor &nbsp;<span class=''img16 icoDownC''></span></th>
            <th style="width:11%;">Ruta &nbsp;<span class=''img16 icoDownC''></span></th>
            <th>Vendedor &nbsp;<span class=''img16 icoDownC''></span></th>
            <th style="width:11%;">Serie &nbsp;<span class=''img16 icoDownC''></span></th>
            <th style="width:11%;">Marca &nbsp;<span class=''img16 icoDownC''></span></th>
            <th style="width:11%;">Familia &nbsp;<span class=''img16 icoDownC''></span></th>
            <th style="width:11%;">Subfamilia &nbsp;<span class=''img16 icoDownC''></span></th>
            <th style="width:100px;text-align:center" class="thO">Fecha</th>
            <th style="width:100px;text-align:center" class="thO"></th>
            <th style="width:80px;text-align:center" class="thO"></th>
        </tr>
        <tr>
            <td id="inputDatosGestor"></td>
            <td id="inputDatosRuta"></td>
            <td id="inputDatosVendedor"></td>
            <td id="inputDatosSerie"></td>
            <td id="inputDatosMarca"></td>
            <td id="inputDatosFamilia"></td>
            <td id="inputDatosSubfamilia"></td>
            <!-- <td id="inputDatosFecha">
                <input type="text" id="inpFechaTV" style="width:100%; text-align:center; color:#333;" onkeyup="calendarioEJGkeyUp(this.id,this.value)" onclick="mostrarElCalendarioEJG(this.id,false);event.stopPropagation();">
            </td> -->
            <td id="inputDatosFecha">
                <!-- <input type="text" id="inpFechaTV" style="width: 120px; background: #DAFFE4; border-radius: 3px; border: 1px solid #ccc; padding: 5px; text-align: center;" onkeydown="capturarUltimaTeclaPresionada(event,this.value);" onclick="capturarClick();" onchange="eventosFechaMultiselect(this.value);"> -->
                <input type="date" id="inpFechaTV" placeholder="dd/mm/aaaa" style="width: 120px; background: #DAFFE4; border-radius: 3px; border: 1px solid #ccc; padding: 5px; text-align: center;" onchange="fechasMultifechaOpciones();">
            </td>
            <td><span id="inpLlamada_MultiseleccionValores" style="background:#f2f2f2; padding:3px;"></span></td>
            <td class="inv" id="tdFechasTeleventa"></td>
            <td style="padding-top:10px;text-align:center;"><span class="MIboton" onclick="guardarTeleVenta(true)">Guardar</span></td>
        </tr>
    </table>
</div>



<script>
    
    initMultifechaOpciones();
   
</script>',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,N'noicon',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,0,0,NULL,NULL,NULL,NULL,NULL,0,0,0,NULL,0,NULL,NULL,0,0,NULL,0,1,1)
 ,(N'TV_Pedido',N'flx-html',N'project',NULL,NULL,N'TV_Pedido',N'TV_Pedido',N'none',1,1,1,0,NULL,NULL,N'<div class="tvTitulo esq1100">Pedido
	<span id="PedidoBotonesPortesVerif" class="flR">
		<span id="spNoCobrarPortes">
		<img src="" id="imgPedidoNoCobrarPortes" style="width:30px; cursor:pointer;" onclick="PedidoNoPortes()">
			&nbsp;<span style="font:14px arial; color:#333;">No Cobrar Portes</span>		
		</span>
		&nbsp;&nbsp;&nbsp;
		<span id="spVerificarPedido">
			<img src="" id="imgVerificarPedido" style="width:30px; cursor:pointer;" onclick="PedidoVerificar()">
			&nbsp;<span style="font:14px arial; color:#333;">Verificar Pedido</span>		
		</span>	
		&nbsp;&nbsp;&nbsp;
	</span>	
</div>
<div id="dvDatosDelClienteMin" style="position:relative;"></div>
<div id="dvPedido" style="border:1px solid #323f4b; padding:10px; border-sizing:border-box;">
	<span id="spanBotoneraPag" class="vaM">
		<span style="font:14px arial; color:#4985D6;">Buscar artículo</span>
		<input type="text" id="inpBuscarArticuloDisponible" style="width:300px;font:14px arial; color:#333;padding:4px;" 
			placeholder="Buscar por código o descipción" onkeyup="buscarArticuloDisponible()" onclick="' + convert(nvarchar(max),NCHAR(36)) + N'(this).select()">
		<span id="spBtnBuscarArt" class="MIboton esq05" onclick="buscarArticuloDisponible(window.event.keyCode=13)">Buscar</span>
		<span id="spResultados" class="inv">
			<span id="spResultadosT" class="esq05" style="margin:0 30px; border:1px solid #4985D6; color:#4985D6; padding:4px;"></span>
			<span id="spResBtn">
				<div class="icoLeft img30" onclick="paginador(); cargarArticulosDisponibles();"></div>
				<div class="icoRight img30" onclick="paginador(true); cargarArticulosDisponibles();"></div>
			</span>
			<span id="spBtnBuscarArtDispCli" class="MIboton esq05" onclick="buscarArtDispCli()">Artículos del Cliente</span>
		</span>
	</span>
	<span id="spanPersEPinfo" class="info" style="margin-left: 20px; display: none;">
		<div class="icoCarga img14 rotarR"></div> cargando artículos...
	</span>
	
	<div id="dvPersEP_Articulos" class="inv">
		<br>
		<table id="tbPersEP_ArticulosCab"></table>
		<div style="overflow:hidden; max-height:300px; overflow-y:auto">
			<table id="tbPersEP_Articulos"></table>		
		</div>
		<span id="spBtnAnyCont"></span>
		<div id="dvPedidoDetalle"></div>
	</div>
</div>

<script>	
	if(PedidoNoCobrarPortes===1){ ' + convert(nvarchar(max),NCHAR(36)) + N'("#imgPedidoNoCobrarPortes").attr("src",BtnDesI); }else{ ' + convert(nvarchar(max),NCHAR(36)) + N'("#imgPedidoNoCobrarPortes").attr("src",BtnDesO); }
	if(VerificarPedido===1){ ' + convert(nvarchar(max),NCHAR(36)) + N'("#imgVerificarPedido").attr("src",BtnDesI); }else{ ' + convert(nvarchar(max),NCHAR(36)) + N'("#imgVerificarPedido").attr("src",BtnDesO); }
	
	function PedidoNoPortes(){
		if(PedidoNoCobrarPortes===1){ PedidoNoCobrarPortes=0; ' + convert(nvarchar(max),NCHAR(36)) + N'("#imgPedidoNoCobrarPortes").attr("src",BtnDesO); }
		else{ PedidoNoCobrarPortes=1; ' + convert(nvarchar(max),NCHAR(36)) + N'("#imgPedidoNoCobrarPortes").attr("src",BtnDesI); }
	}

	function PedidoVerificar(){
		if(VerificarPedido===1){ VerificarPedido=0; ' + convert(nvarchar(max),NCHAR(36)) + N'("#imgVerificarPedido").attr("src",BtnDesO); }
		else{ VerificarPedido=1; ' + convert(nvarchar(max),NCHAR(36)) + N'("#imgVerificarPedido").attr("src",BtnDesI); }
	}
</script>',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,N'noicon',NULL,NULL,NULL,NULL,NULL,NULL,NULL,N'inv moduloPedido',NULL,0,0,0,NULL,NULL,NULL,NULL,NULL,0,0,0,NULL,0,NULL,NULL,0,0,NULL,0,1,1)
 ,(N'TV_Recibos_Pendientes',N'flx-objectlist',N'project',N'RecibosPendientes',N'CLIENTE=''{{CODIGO}}''',N'TV_Recibos_Pendientes',N'Recibos Pendientes',N'default',1,0,1,0,NULL,NULL,N'{{Fecha de vencimiento}}',NULL,NULL,NULL,N'' + convert(nvarchar(max),NCHAR(36)) + N'("flx-module[modulename=''TV_Recibos_Pendientes''] .icon-minus").click();',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,N'bullet-list',N'syspager-listboth',20,N'DataConnectionString',NULL,NULL,NULL,NULL,NULL,NULL,0,0,0,NULL,NULL,NULL,NULL,NULL,0,0,0,NULL,0,NULL,NULL,0,0,NULL,0,1,1)
 ,(N'TV_UltimosPedidos',N'flx-html',N'project',NULL,NULL,N'TV_UltimosPedidos',N'TV_UltimosPedidos',N'none',1,1,1,0,NULL,NULL,N'<div class="tvTitulo esq1100">Últimos Artículos Pedidos</div>
<div id="dvUltimosPedidos" style="border:1px solid #323f4b; padding:10px; border-sizing:border-box;" onmouseleave="cerrarAVT()"></div>
',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,N'noicon',NULL,NULL,NULL,NULL,NULL,NULL,NULL,N'moduloTV inv',NULL,0,0,0,NULL,NULL,NULL,NULL,NULL,0,0,0,NULL,0,NULL,NULL,0,0,NULL,0,1,1)
 ,(N'usuariosTV',N'flx-objectlist',N'project',N'gestores',NULL,N'usuariosTV',N'Gestores',N'clean',0,0,0,0,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,N'noicon',N'syspager-listfooter',20,NULL,NULL,NULL,N'gestores',NULL,N'inv sombra zi100',NULL,0,0,0,NULL,NULL,NULL,NULL,NULL,0,0,0,NULL,0,NULL,NULL,0,0,NULL,0,1,1)
) AS Source ([ModuleName],[TypeId],[ClassId],[ObjectName],[ObjectFilter],[Descrip],[Title],[ContainerId],[CollapsibleButton],[FullscreenButton],[RefreshButton],[SearchButton],[SQlSentence],[Header],[HTMLText],[Footer],[Empty],[CssText],[ScriptText],[ChartTypeId],[ChartSettingName],[Series],[Labels],[Value],[Params],[JsonOptions],[Path],[TransFormFilePath],[IconName],[PagerId],[PageSize],[ConnStringID],[ToolbarName],[GridbarName],[TemplateId],[HeaderClass],[ModuleClass],[JSAfterLoad],[Searcher],[ShowWhenNew],[ManualInit],[SchedulerName],[TimelineSettingName],[KanbanSettingsName],[ChartBackground],[ChartBorder],[Reserved],[Cache],[Offline],[PresetName],[RemovePreset],[MixedChartTypes],[MixedChartLabels],[ChartLineBorderDash],[ChartLineFill],[HTMLInit],[ModuleViewers],[Active],[OriginId])
ON (Target.[ModuleName] = Source.[ModuleName])
WHEN MATCHED AND (
	NULLIF(Source.[TypeId], Target.[TypeId]) IS NOT NULL OR NULLIF(Target.[TypeId], Source.[TypeId]) IS NOT NULL OR 
	NULLIF(Source.[ClassId], Target.[ClassId]) IS NOT NULL OR NULLIF(Target.[ClassId], Source.[ClassId]) IS NOT NULL OR 
	NULLIF(Source.[ObjectName], Target.[ObjectName]) IS NOT NULL OR NULLIF(Target.[ObjectName], Source.[ObjectName]) IS NOT NULL OR 
	NULLIF(Source.[ObjectFilter], Target.[ObjectFilter]) IS NOT NULL OR NULLIF(Target.[ObjectFilter], Source.[ObjectFilter]) IS NOT NULL OR 
	NULLIF(Source.[Descrip], Target.[Descrip]) IS NOT NULL OR NULLIF(Target.[Descrip], Source.[Descrip]) IS NOT NULL OR 
	NULLIF(Source.[Title], Target.[Title]) IS NOT NULL OR NULLIF(Target.[Title], Source.[Title]) IS NOT NULL OR 
	NULLIF(Source.[ContainerId], Target.[ContainerId]) IS NOT NULL OR NULLIF(Target.[ContainerId], Source.[ContainerId]) IS NOT NULL OR 
	NULLIF(Source.[CollapsibleButton], Target.[CollapsibleButton]) IS NOT NULL OR NULLIF(Target.[CollapsibleButton], Source.[CollapsibleButton]) IS NOT NULL OR 
	NULLIF(Source.[FullscreenButton], Target.[FullscreenButton]) IS NOT NULL OR NULLIF(Target.[FullscreenButton], Source.[FullscreenButton]) IS NOT NULL OR 
	NULLIF(Source.[RefreshButton], Target.[RefreshButton]) IS NOT NULL OR NULLIF(Target.[RefreshButton], Source.[RefreshButton]) IS NOT NULL OR 
	NULLIF(Source.[SearchButton], Target.[SearchButton]) IS NOT NULL OR NULLIF(Target.[SearchButton], Source.[SearchButton]) IS NOT NULL OR 
	NULLIF(Source.[SQlSentence], Target.[SQlSentence]) IS NOT NULL OR NULLIF(Target.[SQlSentence], Source.[SQlSentence]) IS NOT NULL OR 
	NULLIF(Source.[Header], Target.[Header]) IS NOT NULL OR NULLIF(Target.[Header], Source.[Header]) IS NOT NULL OR 
	NULLIF(Source.[HTMLText], Target.[HTMLText]) IS NOT NULL OR NULLIF(Target.[HTMLText], Source.[HTMLText]) IS NOT NULL OR 
	NULLIF(Source.[Footer], Target.[Footer]) IS NOT NULL OR NULLIF(Target.[Footer], Source.[Footer]) IS NOT NULL OR 
	NULLIF(Source.[Empty], Target.[Empty]) IS NOT NULL OR NULLIF(Target.[Empty], Source.[Empty]) IS NOT NULL OR 
	NULLIF(Source.[CssText], Target.[CssText]) IS NOT NULL OR NULLIF(Target.[CssText], Source.[CssText]) IS NOT NULL OR 
	NULLIF(Source.[ScriptText], Target.[ScriptText]) IS NOT NULL OR NULLIF(Target.[ScriptText], Source.[ScriptText]) IS NOT NULL OR 
	NULLIF(Source.[ChartTypeId], Target.[ChartTypeId]) IS NOT NULL OR NULLIF(Target.[ChartTypeId], Source.[ChartTypeId]) IS NOT NULL OR 
	NULLIF(Source.[ChartSettingName], Target.[ChartSettingName]) IS NOT NULL OR NULLIF(Target.[ChartSettingName], Source.[ChartSettingName]) IS NOT NULL OR 
	NULLIF(Source.[Series], Target.[Series]) IS NOT NULL OR NULLIF(Target.[Series], Source.[Series]) IS NOT NULL OR 
	NULLIF(Source.[Labels], Target.[Labels]) IS NOT NULL OR NULLIF(Target.[Labels], Source.[Labels]) IS NOT NULL OR 
	NULLIF(Source.[Value], Target.[Value]) IS NOT NULL OR NULLIF(Target.[Value], Source.[Value]) IS NOT NULL OR 
	NULLIF(Source.[Params], Target.[Params]) IS NOT NULL OR NULLIF(Target.[Params], Source.[Params]) IS NOT NULL OR 
	NULLIF(Source.[JsonOptions], Target.[JsonOptions]) IS NOT NULL OR NULLIF(Target.[JsonOptions], Source.[JsonOptions]) IS NOT NULL OR 
	NULLIF(Source.[Path], Target.[Path]) IS NOT NULL OR NULLIF(Target.[Path], Source.[Path]) IS NOT NULL OR 
	NULLIF(Source.[TransFormFilePath], Target.[TransFormFilePath]) IS NOT NULL OR NULLIF(Target.[TransFormFilePath], Source.[TransFormFilePath]) IS NOT NULL OR 
	NULLIF(Source.[IconName], Target.[IconName]) IS NOT NULL OR NULLIF(Target.[IconName], Source.[IconName]) IS NOT NULL OR 
	NULLIF(Source.[PagerId], Target.[PagerId]) IS NOT NULL OR NULLIF(Target.[PagerId], Source.[PagerId]) IS NOT NULL OR 
	NULLIF(Source.[PageSize], Target.[PageSize]) IS NOT NULL OR NULLIF(Target.[PageSize], Source.[PageSize]) IS NOT NULL OR 
	NULLIF(Source.[ConnStringID], Target.[ConnStringID]) IS NOT NULL OR NULLIF(Target.[ConnStringID], Source.[ConnStringID]) IS NOT NULL OR 
	NULLIF(Source.[ToolbarName], Target.[ToolbarName]) IS NOT NULL OR NULLIF(Target.[ToolbarName], Source.[ToolbarName]) IS NOT NULL OR 
	NULLIF(Source.[GridbarName], Target.[GridbarName]) IS NOT NULL OR NULLIF(Target.[GridbarName], Source.[GridbarName]) IS NOT NULL OR 
	NULLIF(Source.[TemplateId], Target.[TemplateId]) IS NOT NULL OR NULLIF(Target.[TemplateId], Source.[TemplateId]) IS NOT NULL OR 
	NULLIF(Source.[HeaderClass], Target.[HeaderClass]) IS NOT NULL OR NULLIF(Target.[HeaderClass], Source.[HeaderClass]) IS NOT NULL OR 
	NULLIF(Source.[ModuleClass], Target.[ModuleClass]) IS NOT NULL OR NULLIF(Target.[ModuleClass], Source.[ModuleClass]) IS NOT NULL OR 
	NULLIF(Source.[JSAfterLoad], Target.[JSAfterLoad]) IS NOT NULL OR NULLIF(Target.[JSAfterLoad], Source.[JSAfterLoad]) IS NOT NULL OR 
	NULLIF(Source.[Searcher], Target.[Searcher]) IS NOT NULL OR NULLIF(Target.[Searcher], Source.[Searcher]) IS NOT NULL OR 
	NULLIF(Source.[ShowWhenNew], Target.[ShowWhenNew]) IS NOT NULL OR NULLIF(Target.[ShowWhenNew], Source.[ShowWhenNew]) IS NOT NULL OR 
	NULLIF(Source.[ManualInit], Target.[ManualInit]) IS NOT NULL OR NULLIF(Target.[ManualInit], Source.[ManualInit]) IS NOT NULL OR 
	NULLIF(Source.[SchedulerName], Target.[SchedulerName]) IS NOT NULL OR NULLIF(Target.[SchedulerName], Source.[SchedulerName]) IS NOT NULL OR 
	NULLIF(Source.[TimelineSettingName], Target.[TimelineSettingName]) IS NOT NULL OR NULLIF(Target.[TimelineSettingName], Source.[TimelineSettingName]) IS NOT NULL OR 
	NULLIF(Source.[KanbanSettingsName], Target.[KanbanSettingsName]) IS NOT NULL OR NULLIF(Target.[KanbanSettingsName], Source.[KanbanSettingsName]) IS NOT NULL OR 
	NULLIF(Source.[ChartBackground], Target.[ChartBackground]) IS NOT NULL OR NULLIF(Target.[ChartBackground], Source.[ChartBackground]) IS NOT NULL OR 
	NULLIF(Source.[ChartBorder], Target.[ChartBorder]) IS NOT NULL OR NULLIF(Target.[ChartBorder], Source.[ChartBorder]) IS NOT NULL OR 
	NULLIF(Source.[Reserved], Target.[Reserved]) IS NOT NULL OR NULLIF(Target.[Reserved], Source.[Reserved]) IS NOT NULL OR 
	NULLIF(Source.[Cache], Target.[Cache]) IS NOT NULL OR NULLIF(Target.[Cache], Source.[Cache]) IS NOT NULL OR 
	NULLIF(Source.[Offline], Target.[Offline]) IS NOT NULL OR NULLIF(Target.[Offline], Source.[Offline]) IS NOT NULL OR 
	NULLIF(Source.[PresetName], Target.[PresetName]) IS NOT NULL OR NULLIF(Target.[PresetName], Source.[PresetName]) IS NOT NULL OR 
	NULLIF(Source.[RemovePreset], Target.[RemovePreset]) IS NOT NULL OR NULLIF(Target.[RemovePreset], Source.[RemovePreset]) IS NOT NULL OR 
	NULLIF(Source.[MixedChartTypes], Target.[MixedChartTypes]) IS NOT NULL OR NULLIF(Target.[MixedChartTypes], Source.[MixedChartTypes]) IS NOT NULL OR 
	NULLIF(Source.[MixedChartLabels], Target.[MixedChartLabels]) IS NOT NULL OR NULLIF(Target.[MixedChartLabels], Source.[MixedChartLabels]) IS NOT NULL OR 
	NULLIF(Source.[ChartLineBorderDash], Target.[ChartLineBorderDash]) IS NOT NULL OR NULLIF(Target.[ChartLineBorderDash], Source.[ChartLineBorderDash]) IS NOT NULL OR 
	NULLIF(Source.[ChartLineFill], Target.[ChartLineFill]) IS NOT NULL OR NULLIF(Target.[ChartLineFill], Source.[ChartLineFill]) IS NOT NULL OR 
	NULLIF(Source.[HTMLInit], Target.[HTMLInit]) IS NOT NULL OR NULLIF(Target.[HTMLInit], Source.[HTMLInit]) IS NOT NULL OR 
	NULLIF(Source.[ModuleViewers], Target.[ModuleViewers]) IS NOT NULL OR NULLIF(Target.[ModuleViewers], Source.[ModuleViewers]) IS NOT NULL OR 
	NULLIF(Source.[Active], Target.[Active]) IS NOT NULL OR NULLIF(Target.[Active], Source.[Active]) IS NOT NULL OR 
	NULLIF(Source.[OriginId], Target.[OriginId]) IS NOT NULL OR NULLIF(Target.[OriginId], Source.[OriginId]) IS NOT NULL) THEN
 UPDATE SET
  [TypeId] = Source.[TypeId], 
  [ClassId] = Source.[ClassId], 
  [ObjectName] = Source.[ObjectName], 
  [ObjectFilter] = Source.[ObjectFilter], 
  [Descrip] = Source.[Descrip], 
  [Title] = Source.[Title], 
  [ContainerId] = Source.[ContainerId], 
  [CollapsibleButton] = Source.[CollapsibleButton], 
  [FullscreenButton] = Source.[FullscreenButton], 
  [RefreshButton] = Source.[RefreshButton], 
  [SearchButton] = Source.[SearchButton], 
  [SQlSentence] = Source.[SQlSentence], 
  [Header] = Source.[Header], 
  [HTMLText] = Source.[HTMLText], 
  [Footer] = Source.[Footer], 
  [Empty] = Source.[Empty], 
  [CssText] = Source.[CssText], 
  [ScriptText] = Source.[ScriptText], 
  [ChartTypeId] = Source.[ChartTypeId], 
  [ChartSettingName] = Source.[ChartSettingName], 
  [Series] = Source.[Series], 
  [Labels] = Source.[Labels], 
  [Value] = Source.[Value], 
  [Params] = Source.[Params], 
  [JsonOptions] = Source.[JsonOptions], 
  [Path] = Source.[Path], 
  [TransFormFilePath] = Source.[TransFormFilePath], 
  [IconName] = Source.[IconName], 
  [PagerId] = Source.[PagerId], 
  [PageSize] = Source.[PageSize], 
  [ConnStringID] = Source.[ConnStringID], 
  [ToolbarName] = Source.[ToolbarName], 
  [GridbarName] = Source.[GridbarName], 
  [TemplateId] = Source.[TemplateId], 
  [HeaderClass] = Source.[HeaderClass], 
  [ModuleClass] = Source.[ModuleClass], 
  [JSAfterLoad] = Source.[JSAfterLoad], 
  [Searcher] = Source.[Searcher], 
  [ShowWhenNew] = Source.[ShowWhenNew], 
  [ManualInit] = Source.[ManualInit], 
  [SchedulerName] = Source.[SchedulerName], 
  [TimelineSettingName] = Source.[TimelineSettingName], 
  [KanbanSettingsName] = Source.[KanbanSettingsName], 
  [ChartBackground] = Source.[ChartBackground], 
  [ChartBorder] = Source.[ChartBorder], 
  [Reserved] = Source.[Reserved], 
  [Cache] = Source.[Cache], 
  [Offline] = Source.[Offline], 
  [PresetName] = Source.[PresetName], 
  [RemovePreset] = Source.[RemovePreset], 
  [MixedChartTypes] = Source.[MixedChartTypes], 
  [MixedChartLabels] = Source.[MixedChartLabels], 
  [ChartLineBorderDash] = Source.[ChartLineBorderDash], 
  [ChartLineFill] = Source.[ChartLineFill], 
  [HTMLInit] = Source.[HTMLInit], 
  [ModuleViewers] = Source.[ModuleViewers], 
  [Active] = Source.[Active], 
  [OriginId] = Source.[OriginId]
WHEN NOT MATCHED BY TARGET THEN
 INSERT([ModuleName],[TypeId],[ClassId],[ObjectName],[ObjectFilter],[Descrip],[Title],[ContainerId],[CollapsibleButton],[FullscreenButton],[RefreshButton],[SearchButton],[SQlSentence],[Header],[HTMLText],[Footer],[Empty],[CssText],[ScriptText],[ChartTypeId],[ChartSettingName],[Series],[Labels],[Value],[Params],[JsonOptions],[Path],[TransFormFilePath],[IconName],[PagerId],[PageSize],[ConnStringID],[ToolbarName],[GridbarName],[TemplateId],[HeaderClass],[ModuleClass],[JSAfterLoad],[Searcher],[ShowWhenNew],[ManualInit],[SchedulerName],[TimelineSettingName],[KanbanSettingsName],[ChartBackground],[ChartBorder],[Reserved],[Cache],[Offline],[PresetName],[RemovePreset],[MixedChartTypes],[MixedChartLabels],[ChartLineBorderDash],[ChartLineFill],[HTMLInit],[ModuleViewers],[Active],[OriginId])
 VALUES(Source.[ModuleName],Source.[TypeId],Source.[ClassId],Source.[ObjectName],Source.[ObjectFilter],Source.[Descrip],Source.[Title],Source.[ContainerId],Source.[CollapsibleButton],Source.[FullscreenButton],Source.[RefreshButton],Source.[SearchButton],Source.[SQlSentence],Source.[Header],Source.[HTMLText],Source.[Footer],Source.[Empty],Source.[CssText],Source.[ScriptText],Source.[ChartTypeId],Source.[ChartSettingName],Source.[Series],Source.[Labels],Source.[Value],Source.[Params],Source.[JsonOptions],Source.[Path],Source.[TransFormFilePath],Source.[IconName],Source.[PagerId],Source.[PageSize],Source.[ConnStringID],Source.[ToolbarName],Source.[GridbarName],Source.[TemplateId],Source.[HeaderClass],Source.[ModuleClass],Source.[JSAfterLoad],Source.[Searcher],Source.[ShowWhenNew],Source.[ManualInit],Source.[SchedulerName],Source.[TimelineSettingName],Source.[KanbanSettingsName],Source.[ChartBackground],Source.[ChartBorder],Source.[Reserved],Source.[Cache],Source.[Offline],Source.[PresetName],Source.[RemovePreset],Source.[MixedChartTypes],Source.[MixedChartLabels],Source.[ChartLineBorderDash],Source.[ChartLineFill],Source.[HTMLInit],Source.[ModuleViewers],Source.[Active],Source.[OriginId])
WHEN NOT MATCHED BY SOURCE AND TARGET.OriginId = 1 THEN 
 DELETE
;
END TRY
BEGIN CATCH
    DECLARE @ERRORNUMBER	INT,@ERRORMSG		VARCHAR(MAX),@ERRORSTATE		INT
    SELECT @ERRORNUMBER = 50000 + ERROR_NUMBER(),@ERRORMSG = ERROR_MESSAGE(), @ERRORSTATE = ERROR_STATE();
    THROW @ERRORNUMBER, @ERRORMSG, @ERRORSTATE
END CATCH
GO





