

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


</script>',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,N'flow-chart-2',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,N'' + convert(nvarchar(max),NCHAR(36)) + N'("flx-module[modulename=''Cliente_Acciones''] .icon-minus").click();',0,0,0,NULL,NULL,NULL,NULL,NULL,0,0,0,1)
 ,(N'Cliente_Datos',N'flx-view',N'project',N'Cliente',N'(CODIGO=''{{CODIGO}}'')',N'Cliente_Datos',N'Datos del Cliente',N'default',0,0,1,0,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,N'client',NULL,NULL,N'DataConnectionString',NULL,NULL,N'Cliente_Datos',NULL,NULL,NULL,0,0,0,NULL,NULL,NULL,NULL,NULL,0,0,0,1)
 ,(N'Cliente_Incidencias',N'flx-html',N'project',NULL,NULL,N'Cliente_Incidencias',N'Incidencias',N'default',0,0,1,0,NULL,NULL,N'<div id="dvRegInci"></div>

<script>
cargarIncidenciasCliente();
function cargarIncidenciasCliente(){
	' + convert(nvarchar(max),NCHAR(36)) + N'("#dvRegInci").html(icoCargando16+" <span class=''fadeIO'' style=''color:#1f8eee;''>cargando datos...</span>"); 
	var ClienteCodigo = ' + convert(nvarchar(max),NCHAR(36)) + N'.trim(' + convert(nvarchar(max),NCHAR(36)) + N'("#spanClienteCodigo").text());
	if(ClienteCodigo===undefined || ClienteCodigo===""){ setTimeout(function(){ cargarIncidenciasCliente(); },100); return; }
	var parametros = ''{"modo":"incidenciasDelCliente","cliente":"''+ClienteCodigo+''"}'';
	flexygo.nav.execProcess(''pLlamadas'','''',null,null,[{''key'':''parametros'',''value'':limpiarCadena(parametros)}],''modal640x480'',false,' + convert(nvarchar(max),NCHAR(36)) + N'(this),function(ret){
		if(ret){	/**/ console.log("pLlamadas incidenciasDelCliente re:\n"+limpiarCadena(ret.JSCode));
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
</script>',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,N'admin1',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,0,0,NULL,NULL,NULL,NULL,NULL,0,0,0,1)
 ,(N'Cliente_Pasos',N'flx-view',N'project',N'Cliente',N'(CODIGO=''{{CODIGO}}'')',N'Cliente_Pasos',N'Cliente_Pasos',N'none',1,1,1,0,NULL,NULL,N'<span class="btn btn-info" onclick=''flexygo.nav.openPageName("TeleVenta","","","{\"CODIGO\":\"{{CODIGO}}\"}","current",false,' + convert(nvarchar(max),NCHAR(36)) + N'(this));''><span title="Llamada" class="flx-icon icon-phone icon-margin-right"></span><span class="hidden-m">Llamada</span></span>',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,N'noicon',NULL,NULL,N'DataConnectionString',NULL,NULL,NULL,NULL,NULL,NULL,0,0,0,NULL,NULL,NULL,NULL,NULL,0,0,0,1)
 ,(N'Cliente_Pedidos',N'flx-objectlist',N'project',N'Pedidos',N'CLIENTE=''{{CODIGO}}''',N'Cliente_Pedidos',N'Pedidos',N'default',1,0,1,0,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,N'document1',N'syspager-listboth',10,NULL,NULL,NULL,N'PedidosPlantilla01',NULL,NULL,N'' + convert(nvarchar(max),NCHAR(36)) + N'("flx-module[modulename=''Cliente_Pedidos''] .icon-minus").click();',0,0,0,NULL,NULL,NULL,NULL,NULL,0,0,0,1)
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

</script>',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,N'noicon',NULL,NULL,N'DataConnectionString',NULL,NULL,NULL,NULL,NULL,NULL,0,0,0,NULL,NULL,NULL,NULL,NULL,0,0,0,1)
 ,(N'Clientes_Listado',N'flx-objectlist',N'system',N'Clientes',N'{{ObjectWhere}}',N'Lisado de Clientes',N'{{ObjectDescrip}}',N'default',0,0,1,1,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,N'sysobjecticon',N'syspager-listboth',25,NULL,N'systb-search',N'systb-row',NULL,NULL,NULL,NULL,0,0,0,NULL,NULL,NULL,NULL,NULL,0,0,0,1)
 ,(N'Configuracion',N'flx-html',N'project',NULL,NULL,N'Configuracion',N'Configuracion',N'none',1,1,1,0,NULL,NULL,N'<style>
	#tbConfigMenu tr th {padding:2px 6px;}
	.separador { width:30px;}

	.tPersP{ font: bold 14px arial; color:#333; }
	.tPersP:hover{ color:#A9C5EB; cursor:pointer; }

	#tbConfigBBDD th, #tbConfigBBDD td {padding:4px;}
	#tbConfigBBDD th {font:14px arial; color:#333; }
	#tbConfigBBDD td input { width:130px; text-align:center; border:1px solid #ccc; }
</style>

<script>
	if(flexygo.context.currentRole!=="Admins"){ flexygo.nav.openPageName(''TeleVenta'','''','''',null,''current'',false,' + convert(nvarchar(max),NCHAR(36)) + N'(this)); }
</script>

<div id="dvConfiguracion" class="esq10 configSeccion inv" style="padding:20px; background:rgb(240,240,240);">
	<div id="dvNombreEmpresa" style="text-align:center; font:bold 16px arial; color:#323f4b;">Ejercicio {{Ejercicio}} - Empresa: {{NombreEmpresa}}</div>
	<br>
	<div class="tCnfT">Configuración de la aplicación</div>
	<table id="tbConfiguracion">
		<tr>
			<th style="width:25%;">Reconfigurar el Portal</th>
			<td>				
				&nbsp;&nbsp;<span class="MIbotonGreen esq05" onclick="reconfigurar_Click()">reconfigurar</span>
			</td>
		</tr>
		<tr>
			<th>Serie Pedidos</th>
			<td>
				&nbsp;&nbsp;
				<input type="text" id="inpSerie" class="C esq05" style="width:80px; font:bold 14px arial;" onclick="inpDatos_Click(''Serie''); event.stopPropagation();" readonly>
				<div id="dvSerieListado" class="dvListaDatos"></div>
				<span id="spanAsignacionSerieAviso" class="inv" style="font:bold 14px arial; color:green;">&nbsp;&nbsp; asignación correcta!</span>
			</td>
		</tr>
		<tr>
			<th>Meses de consumo</th>
			<td>
				&nbsp;&nbsp;
				<input type="text" id="inpMesesConsumo" class="C esq05" style="width:30px; font:bold 14px arial;" value="1" readonly>
				&nbsp;&nbsp;
				&nbsp;<div class="icoMenos img20" onclick="masmenos(false,''inpMesesConsumo'',1,12)"></div>
				&nbsp;<div class="icoMas img20" onclick="masmenos(true,''inpMesesConsumo'',1,12)"></div>
				&nbsp;&nbsp;<span class="MIbotonGreen esq05" onclick="asignarMesesConsumo()">asignar</span>
				<span id="spanAsignacionAviso" class="inv" style="font:bold 14px arial; color:green;">&nbsp;&nbsp; asignación correcta!</span>
			</td>
		</tr>
	</table>
</div>

<div id="dvBBDD" class="esq10 configSeccion inv" style="margin-top:10px; padding:20px; background:rgb(240,240,240);">
	<div class="tCnfT">Configuración Bases de Datos</div>
	<div id="dvBBDD01" class="C">
		<br>
		Selecciona la base de datos de comunes <select id="selComun" class="esq05" style="padding:5px;" onchange="cargarEmpresas()"></select> 
		<br><br>
		Selecciona la empresa <select id="selEmpresas" class="esq05" style="padding:5px;"></select> 
		<br><br>
		Ejercicio actual + <select id="selNumEjercicios" class="esq05" style="padding:5px;">
								<option>0</option>
								<option>1</option>
								<option>2</option>
								<option>3</option>
								<option>4</option>
								<option>5</option>
							</select> años atrás
		<br><br><br>
		<span class="MIbotonGreen esq05" style="padding:10px;" onclick="configurarElPortal_Click()">Configurar el Portal</span>
	</div>
</div>


<script>	
	var veloContenido = 
		 ''<img src="./Merlos/images/icoCarga.png" class="rotarR" width="30">''
		+''<br><br><span class="info">cargando datos, espera, por favor...</span>'';
	abrirVelo(veloContenido,400);
	
	var SeriesCargadas = false;
	var elementosDIV = ["dvSerieListado"];
	
	' + convert(nvarchar(max),NCHAR(36)) + N'(document).on("click",function(e) {
		for(var i in elementosDIV){
			var container = ' + convert(nvarchar(max),NCHAR(36)) + N'("#"+elementosDIV[i]);
			if (!container.is(e.target) && container.has(e.target).length === 0) { ' + convert(nvarchar(max),NCHAR(36)) + N'("#"+elementosDIV[i]).stop().slideUp(); }
		}
	});
	
	// Comprobar que exista una configuración de BBDD de Datos
	flexygo.nav.execProcess(''pConfigPrimeraBBDD'','''',null,null, [{''Key'':''modo'',''Value'':''verificar''}], ''modal640x480'', false, ' + convert(nvarchar(max),NCHAR(36)) + N'(this), function(ret){ 
		if(ret){
			if(ret.JSCode.trim()!==""){
				' + convert(nvarchar(max),NCHAR(36)) + N'("#mainNav").show();
				cargarConfiguracion();
			}else{
				// -- si no existe mostramos el formulario para entrar los datos
				cerrarVelo(); 
				' + convert(nvarchar(max),NCHAR(36)) + N'("#mainNav").hide();
				' + convert(nvarchar(max),NCHAR(36)) + N'("#dvBBDD").fadeIn();
				cargarComunes();
			}
		}else{ alert(''Error S.P. pConfigPrimeraBBDD!!!\n''+JSON.stringify(ret)); } 			
	}, false);
	
	function cargarComunes(){
		var contenido = "<option value=''''></option>";
		var elC = "red";
		' + convert(nvarchar(max),NCHAR(36)) + N'("#selComun").html("<option value=''''>cargando comunes...</option>").css("color",elC);
		flexygo.nav.execProcess(''pComunes'','''',null,null, 
		[{''Key'':''modo'',''Value'':''lista''}]
		, ''modal640x480'', false, ' + convert(nvarchar(max),NCHAR(36)) + N'(this), function(ret){ if(ret){ 
			var elJS = JSON.parse(limpiarCadena(ret.JSCode));
			if(elJS.comunes.length>0){ 
				for(var i in elJS.comunes){
					contenido += "<option value=''"+elJS.comunes[i].nombre+"''>"+elJS.comunes[i].nombre+"</option>";
				}
				elC = "#333";
			}else{ contenido = "<option value=''''>Sin resultados!</option>";}
			' + convert(nvarchar(max),NCHAR(36)) + N'("#selComun").html(contenido).css("color",elC);
		} }, false);
	}
	
	function cargarEmpresas(){
		var contenido = "<option value=''''></option>";
		var elC = "red";
		var bdComunes = ' + convert(nvarchar(max),NCHAR(36)) + N'.trim(' + convert(nvarchar(max),NCHAR(36)) + N'("#selComun").val());
		' + convert(nvarchar(max),NCHAR(36)) + N'("#selEmpresas").html("<option value=''''>cargando empresas...</option>").css("color",elC);
		flexygo.nav.execProcess(''pEmpresas'','''',null,null, 
		[{''Key'':''modo'',''Value'':''lista''},{''Key'':''comun'',''Value'':bdComunes}]
		, ''modal640x480'', false, ' + convert(nvarchar(max),NCHAR(36)) + N'(this), function(ret){ if(ret){ 
			var elJS = JSON.parse(limpiarCadena(ret.JSCode));
			if(elJS.empresas.length>0){ 
				for(var i in elJS.empresas){
					contenido += "<option value=''"+elJS.empresas[i].codigo+"''>"+elJS.empresas[i].codigo+" - "+elJS.empresas[i].nombre+"</option>";
				}
				elC = "#333";
			}else{ contenido = "<option value=''''>Sin resultados!</option>";}
			' + convert(nvarchar(max),NCHAR(36)) + N'("#selEmpresas").html(contenido).css("color",elC);
		} }, false);
	}	
	
	function configuracionAviso(){ ' + convert(nvarchar(max),NCHAR(36)) + N'("#dvBBDD01").fadeIn();	' + convert(nvarchar(max),NCHAR(36)) + N'("#dvConfigBBDD").hide(); }

	function lanzarConfiguracion(paso){	
		var comun    = ' + convert(nvarchar(max),NCHAR(36)) + N'.trim(' + convert(nvarchar(max),NCHAR(36)) + N'("#selComun").val()); 
		var empresa  = ' + convert(nvarchar(max),NCHAR(36)) + N'.trim(' + convert(nvarchar(max),NCHAR(36)) + N'("#selEmpresas").val()); 
		var nEmpresa = ' + convert(nvarchar(max),NCHAR(36)) + N'.trim(' + convert(nvarchar(max),NCHAR(36)) + N'(''select[id="selEmpresas"] option:selected'').text()); 
		var numEjer  = ' + convert(nvarchar(max),NCHAR(36)) + N'.trim(' + convert(nvarchar(max),NCHAR(36)) + N'(''#selNumEjercicios'').val()); 
		if(!paso){ verificarVersionEW(comun); return; }
		
		veloContenido =  "<img src=''./Merlos/images/icoCarga.png'' class=''rotarR'' width=''30''><br><br>configurando el portal, por favor, espera...";
		abrirVelo(veloContenido,400);
		
		flexygo.nav.execProcess(''pConfiguracionLanzar'','''',null,null
		, [{''Key'':''comun'',''Value'':comun},{''Key'':''empresa'',''Value'':empresa}]
		, ''modal640x480'', false, ' + convert(nvarchar(max),NCHAR(36)) + N'(this), function(ret){ 
			if(ret){ 
				var elJS = JSON.parse(limpiarCadena(ret.JSCode));		
				var ejercicio = elJS.ejercicio;
				var letra     = elJS.letra;
				var gestion   = elJS.gestion;
				var comun     = elJS.comun;
				var campos    = elJS.campos;
				flexygo.nav.execProcess(''pConfigBBDD'','''',null,null, 
					[
					 {''Key'':''modo'',''Value'':''actualizar''}
					,{''Key'':''accion'',''Value'':''todo''}
					,{''Key'':''ejercicio'',''Value'':ejercicio}
					,{''Key'':''gestion'',''Value'':gestion}
					,{''Key'':''letra'',''Value'':letra}
					,{''Key'':''comun'',''Value'':comun}
					,{''Key'':''campos'',''Value'':campos}
					,{''Key'':''empresa'',''Value'':empresa}
					,{''Key'':''nEmpresa'',''Value'':nEmpresa}
					,{''Key'':''numEjer'',''Value'':numEjer}
					]
					, ''modal640x480'', false, ' + convert(nvarchar(max),NCHAR(36)) + N'(this), function(ret){
					if(ret){ 
						' + convert(nvarchar(max),NCHAR(36)) + N'(".configSeccion").hide(); ' + convert(nvarchar(max),NCHAR(36)) + N'("#dvConfiguracion").fadeIn(); 
						if(ret.JSCode!==""){ alert(ret.JSCode); }
						else{ cerrarVelo(); }
						limpiarLaCache();
						//' + convert(nvarchar(max),NCHAR(36)) + N'("#mainNav").show();
						flexygo.nav.execProcess(''GoHome'','''','''',null,null,''current'',false,' + convert(nvarchar(max),NCHAR(36)) + N'(this));
					}else{ alert(''Error S.P.!!!\n''+ret); } }, false);					
			}else{ alert(''Error S.P.!!!\n''+ret); } 			
		}, false);
	}
	
	function verificarVersionEW(comun){
		flexygo.nav.execProcess(''pVersiones'','''',null,null, 
		[
		 {''Key'':''modo'',''Value'':''EW''}
		,{''Key'':''comun'',''Value'':comun}
		]
		, ''modal640x480'', false, ' + convert(nvarchar(max),NCHAR(36)) + N'(this), function(ret){
		if(ret){ 
			var version = parseInt(ret.JSCode.split(".")[2]);
			if(parseInt(version)>=7502){ lanzarConfiguracion(true); }
			else{ 
				alert("Esta versión de Eurowin\n"
					 +"no es compatible con este producto!"); 
			}
		}else{ alert(''Error S.P.!!!\n''+ret); } }, false);
	}		
		
	function tAhora() {	var d = new Date();	var n = d.getTime(); return n; }	
	
	function configurarElPortal_Click(){
		veloContenido =  "El portal se va a configurar"
						+"<br>con los datos seleccionados."
						+"<br><br><br>"
						+"<span class=''MIbotonOrange'' onclick=''lanzarConfiguracion(false)''>configurar</span>"
						+"&nbsp;&nbsp;&nbsp;<span class=''MIbotonRed'' onclick=''cerrarVelo()''>cancelar</span>";
		abrirVelo(veloContenido,400);
	}
	
	function reconfigurar_Click(){
		veloContenido =  "Se eliminará la base de datos actual"
						+"<br>y se pedirán de nuevo los datos"
						+"<br>de configuración."
						+"<br><br><br>"
						+"<span class=''MIbotonOrange'' onclick=''reconfigurarElPortal()''>reconfigurar</span>"
						+"&nbsp;&nbsp;&nbsp;<span class=''MIbotonRed'' onclick=''cerrarVelo()''>cancelar</span>";
		abrirVelo(veloContenido,400);
	}
	
	function inpDatos_Click(inp){
		' + convert(nvarchar(max),NCHAR(36)) + N'(".dvListaDatos").hide();
		' + convert(nvarchar(max),NCHAR(36)) + N'("#dv"+inp+"Listado").stop().slideDown();
	}
	
	function asignarMesesConsumo(){
		MesesConsumo = ' + convert(nvarchar(max),NCHAR(36)) + N'("#inpMesesConsumo").val();
		flexygo.nav.execProcess(''pConfiguracion'','''',null,null, 
		[{''Key'':''modo'',''Value'':''MesesConsumo''},{''Key'':''valor'',''Value'':' + convert(nvarchar(max),NCHAR(36)) + N'("#inpMesesConsumo").val()}], ''modal640x480'', false, ' + convert(nvarchar(max),NCHAR(36)) + N'(this), function(ret){if(ret){ 
			cargarConfiguracion(); 
			' + convert(nvarchar(max),NCHAR(36)) + N'("#spanAsignacionAviso").fadeIn(); setTimeout(function(){ ' + convert(nvarchar(max),NCHAR(36)) + N'("#spanAsignacionAviso").fadeOut(); },2000);
		}else{ alert(''Error S.P. pConfiguracion!!!\n''+ret); } }, false);
	}
	
	function cargarConfiguracion(){
		flexygo.nav.execProcess(''pConfiguracion'','''',null,null,[{''Key'':''modo'',''Value'':''lista''}],''modal640x480'', false, ' + convert(nvarchar(max),NCHAR(36)) + N'(this), function(ret){if(ret){
			var js = JSON.parse(limpiarCadena(ret.JSCode));
			esperarCargaSeries(js.ConfSQL[0].TVSerie);
			' + convert(nvarchar(max),NCHAR(36)) + N'("#inpMesesConsumo").val(js.ConfSQL[0].MesesConsumo); 
			' + convert(nvarchar(max),NCHAR(36)) + N'("#dvConfiguracion").fadeIn();
			cargarSeries();
			cerrarVelo();
		}else{ alert("Error SP: pConfiguracion!!!\n"+ret); }}, false);
	}
	
	function cargarSeries(){
		var contenido = "";
		flexygo.nav.execProcess(''pSeries'','''',null,null,[{''Key'':''modo'',''Value'':''Serie''}], ''modal640x480'', false, ' + convert(nvarchar(max),NCHAR(36)) + N'(this), function(ret){if(ret){
			var js = JSON.parse(ret.JSCode);
			if(js.length>0){
				for(var i in js){ contenido += "<div class=''dvLista'' onclick=''asignarSerie(\""+js[i].codigo+"\")''>"+js[i].codigo+" - "+js[i].nombre+"</div>"; }
			}else{ contenido="<div style=''color:red;''>Sin resultados!</div>"; }
			' + convert(nvarchar(max),NCHAR(36)) + N'("#dvSerieListado").html(contenido);
			SeriesCargadas=true;
		}else{ alert(''Error S.P. pSeries!!!\n''+ret); } }, false);
	}
	function esperarCargaSeries(serie){
		if(SeriesCargadas){ ' + convert(nvarchar(max),NCHAR(36)) + N'("#inpSerie").val(serie); }
		else{ setTimeout(function(){ esperarCargaSeries(serie); },200); }
	}
	function asignarSerie(serie){
		SERIE = serie;
		flexygo.nav.execProcess(''pConfiguracion'','''',null,null,[{''Key'':''modo'',''Value'':''TVSerie''},{''Key'':''valor'',''Value'':serie}],''modal640x480'', false, ' + convert(nvarchar(max),NCHAR(36)) + N'(this), function(ret){if(ret){
			' + convert(nvarchar(max),NCHAR(36)) + N'("#inpSerie").val(serie);
			' + convert(nvarchar(max),NCHAR(36)) + N'("#dvSerieListado").stop().slideUp();
			' + convert(nvarchar(max),NCHAR(36)) + N'("#spanAsignacionSerieAviso").fadeIn(); 
			limpiarLaCache();
			setTimeout(function(){ ' + convert(nvarchar(max),NCHAR(36)) + N'("#spanAsignacionSerieAviso").fadeOut(); },2000);
		}else{ alert("Error SP: pConfiguracion!!!\n"+ret); }}, false);
	}
	
	function reconfigurarElPortal(){
		veloContenido =  ''<img src="./Merlos/images/icoCarga.png" class="rotarR" width="30">''
						+''<br><br><span class="info">reconfigurando, espera, por favor...</span>'';
		abrirVelo(veloContenido,400);
		flexygo.nav.execProcess(''pConfiguracion'','''',null,null,[{''Key'':''modo'',''Value'':''reconfigurar''}],''modal640x480'', false, ' + convert(nvarchar(max),NCHAR(36)) + N'(this), function(ret){
			if(ret){ location.reload();  }
		}, false);
	}
</script>',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,N'noicon',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,0,0,NULL,NULL,NULL,NULL,NULL,0,0,0,1)
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

' + convert(nvarchar(max),NCHAR(36)) + N'("flx-module[modulename=''Contactos''] .icon-minus").click();',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,N'contacts-2',NULL,10,N'DataConnectionString',NULL,NULL,NULL,NULL,NULL,NULL,0,0,0,NULL,NULL,NULL,NULL,NULL,0,0,0,1)
 ,(N'inciCLIlistado',N'flx-objectlist',N'project',N'{{ObjectName}}',N'{{ObjectWhere}}',N'Incidencias de Clientes',N'Incidencias de Clientes',N'default',1,1,1,1,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,N'accepted-2',N'syspager-listheader',100,NULL,N'systb-list',N'systb-row',NULL,NULL,NULL,NULL,0,0,0,NULL,NULL,NULL,NULL,NULL,0,0,0,1)
 ,(N'TV_Cliente',N'flx-html',N'project',NULL,NULL,N'TV_Cliente',N'TV_Cliente',N'none',1,1,1,0,NULL,NULL,N'<div class="tvTitulo esq1100">Cliente <span class=''MIbotonP FR esq05'' onclick=''verFichaDeCliente()''>Ver Cliente</span></div>
<div id="dvDatosDelCliente" style="border:1px solid #323f4b; padding:10px; border-sizing:border-box;"></div>
',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,N'noicon',NULL,NULL,NULL,NULL,NULL,NULL,NULL,N'moduloTV inv',NULL,0,0,0,NULL,NULL,NULL,NULL,NULL,0,0,0,1)
 ,(N'TV_Llamadas',N'flx-html',N'project',NULL,NULL,N'TV_Llamadas',N'TV_Llamadas',N'none',1,1,1,0,NULL,NULL,N'<div class="tvTitulo esq1100">
	Llamadas
	<div class="dvImg20 icoRecarga fR" onclick="recargarTVLlamadas()"></div>
	<span class="MIbotonP fR esq05" style="margin-right:20px;" onclick="anyadirCliente()">Añadir Cliente</span>
</div>
<div id="dvLlamadas" style="border:1px solid #323f4b; padding:10px; border-sizing:border-box;"></div>
',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,N'noicon',NULL,NULL,NULL,NULL,NULL,NULL,NULL,N'moduloTV inv',NULL,0,0,0,NULL,NULL,NULL,NULL,NULL,0,0,0,1)
 ,(N'TV_LlamadasTV',N'flx-html',N'project',NULL,NULL,N'TV_LlamadasTV',N'TV_LlamadasTV',N'none',0,0,0,0,NULL,NULL,N'<div class="tvTitulo esq1100">
	Llamadas Tele Venta
</div>
<div id="dvLlamadasTeleVenta" style="border:1px solid #323f4b; padding:10px; border-sizing:border-box;"></div>
',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,N'flx-phone',N'syspager-listheader',20,NULL,N'systb-search',NULL,NULL,NULL,NULL,NULL,0,0,0,NULL,NULL,NULL,NULL,NULL,0,0,0,1)
 ,(N'TV_OpcionesLlamada',N'flx-html',N'project',NULL,NULL,N'TV_OpcionesLlamada',N'TV_OpcionesLlamada',N'none',1,1,1,0,NULL,NULL,N'<div id="dvOpcionesTV" class="tvTitulo esq1100" style="padding:10px; box-sizing:border-box;">
	<table id="tbOpciones">
		<tr>
			<th>
				<div id="dvEstTV" class="vaM" style="font:16px arial; color:#accfdd;" ></div>
				<div id="dvFiltrosTV" class="vaM" style="margin-top:8px;font:16px arial; color:#92D6B6;" ></div>
			</th>
			<th><div id="dvFechaTV" class="FR vaM" style="margin:-3px 40px 0 0; font:bold 32px arial; color:#FFF;" ></div></th>
			<th>
				<div id="btnTerminar" class="MIbotonW FR vaM inv" style="margin-top:-5px;" onclick=''terminarLlamada()''>Terminar Llamada</div>
				<div id="btnPedido" class="MIbotonW FR vaM inv" style="margin:-5px 10px 0 0;" onclick=''pedidoTV()''>Pedido</div>
				<div id="btnClientes" class="MIbotonW FR vaM inv" style="margin:-5px 10px 0 0;" onclick=''cargarClientes()''>Clientes</div>
				<div id="btnConfiguracion" class="MIbotonW FR vaM inv" style="margin:-5px 10px 0 0;" onclick=''configurarTeleVenta()''>Configuración</div>
			</th>
		</tr>
	</table>
</div>

<div id="dvConfiguracionTeleVenta" style="border:1px solid #323f4b; padding:10px; border-sizing:border-box;">
	<table id="tbConfiguracionOperador">
		<tr>
			<th colspan="2" class="thO" style="vertical-align:middle; text-align:left;">Nombre registro llamadas</th>
			<td colspan="6" id="inputDatosNombreTV">
				<input type="text" id="inpNombreTV" style="width:100%; text-align:left; color:#333;" onkeyup="autoNombreTV=false;">
			</td>
			<td style="vertical-align:middle; text-align:center;">
				<div class=''img20 icoRecargaAzul'' onclick="resetFrm(''OpcionesTV'')"></div>
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
			<td id="inputDatosFecha">
				<input type="text" id="inpFechaTV" style="width:100%; text-align:center; color:#333;" 
				onkeyup="calendarioEJGkeyUp(this.id,this.value)" 
				onclick="mostrarElCalendarioEJG(this.id,false);event.stopPropagation();">
			</td>
			<td style="padding-top:10px;text-align:center;" ><span class="MIboton" onclick="guardarTeleVenta(true)">Guardar</span></td>
		</tr>
	</table>
</div>


<script>
' + convert(nvarchar(max),NCHAR(36)) + N'("#inpFechaTV").val(FechaTeleVenta);
' + convert(nvarchar(max),NCHAR(36)) + N'("#dvFechaTV").html(FechaTeleVenta);
' + convert(nvarchar(max),NCHAR(36)) + N'("#tbConfiguracionOperador th").on("click",function(){ inputTbDatos((' + convert(nvarchar(max),NCHAR(36)) + N'(this).text()).split(" ")[0]); event.stopPropagation(); });

function cargarTbConfigOperador(modo,comprobar){ console.log("cargarTbConfigOperador("+modo+","+comprobar+")");
	var fecha = ' + convert(nvarchar(max),NCHAR(36)) + N'.trim(' + convert(nvarchar(max),NCHAR(36)) + N'("#inpFechaTV").val()); 
	var nombre = ' + convert(nvarchar(max),NCHAR(36)) + N'.trim(' + convert(nvarchar(max),NCHAR(36)) + N'("#inpNombreTV").val());	
		/**/ console.log("fecha: "+fecha+" - nombre: "+nombre);
	
	var elJS = ''{"modo":"'' + modo + ''","IdTeleVenta":"'' + IdTeleVenta + ''","nombreTV":"'' + nombre + ''","fecha":"'' + fecha + ''",'' + paramStd + ''}'';
	if(modo==="guardar"){
		var objetos = ["Gestor","Ruta","Vendedor","Serie","Marca","Familia","Subfamilia"];
		for(var o in objetos){
			var tr = "";
			' + convert(nvarchar(max),NCHAR(36)) + N'("#inputDatos"+objetos[o]).find("div").each(function(){
				tr += ''{"''+objetos[o]+''":"''+(' + convert(nvarchar(max),NCHAR(36)) + N'(this).text()).split(" - ")[0]+''"}''; 
			});
			window["op"+objetos[o]] = ''"''+objetos[o]+''":[''+tr.replace(/}{/g,"},{")+'']'';
		}
		
		elJS = ''{"modo":"'' + modo + ''","comprobar":"'' + comprobar + ''","IdTeleVenta":"'' + IdTeleVenta + ''","nombreTV":"'' + nombre + ''","fecha":"'' + fecha + ''"''
			 + '',''+window["opGestor"]+'',''+window["opRuta"]+'',''+window["opVendedor"]+'',''+window["opSerie"]+'',''+window["opMarca"]+''''
			 +'',''+window["opFamilia"]+'',''+window["opSubfamilia"]+'','' + paramStd + ''}'';
	}
	/**/ console.log("elJS: "+elJS);
	// Obtener Vendedor, Serie, Marca, Familia y Subfamilia
	flexygo.nav.execProcess(''pOperadorConfig'','''',null,null,[{''Key'':''elJS'',''Value'':limpiarCadena(elJS)}],''modal640x480'',false,' + convert(nvarchar(max),NCHAR(36)) + N'(this),function(ret){
        if (ret) { /**/ console.log("pOperadorConfig ret:\n"+limpiarCadena(ret.JSCode));
			if(ret.JSCode==="nombreTV_Existe!"){ alert("El nombre ya existe en la base de datos!"); return; }
			
            var js = JSON.parse(limpiarCadena(ret.JSCode));   
			SERIE = js.serieActiva; 

			var gestores = "";
			for(var i in js.gestor){ gestores += "<div class=''dvSub'' onclick=''inputTbDatosEliminar(\"Gestor\",\""+js.gestor[i].gestor+"\")''>"+js.gestor[i].gestor+"</div>"; }
			' + convert(nvarchar(max),NCHAR(36)) + N'("#inputDatosGestor").html(gestores);
			
			var rutas = "";
			for(var i in js.ruta){ rutas += "<div class=''dvSub'' onclick=''inputTbDatosEliminar(\"Ruta\",\""+js.ruta[i].ruta+"\")''>"+js.ruta[i].ruta+"</div>"; }
			' + convert(nvarchar(max),NCHAR(36)) + N'("#inputDatosRuta").html(rutas);
			
			var vendedores = "";
			for(var i in js.vendedor){ vendedores += "<div class=''dvSub'' onclick=''inputTbDatosEliminar(\"Vendedor\",\""+js.vendedor[i].vendedor+"\")''>"+js.vendedor[i].vendedor+"</div>"; }
			' + convert(nvarchar(max),NCHAR(36)) + N'("#inputDatosVendedor").html(vendedores);

			var series = "";
			for(var i in js.serie){ series += "<div class=''dvSub'' onclick=''inputTbDatosEliminar(\"Serie\",\""+js.serie[i].serie+"\")''>"+js.serie[i].serie+"</div>"; }
			' + convert(nvarchar(max),NCHAR(36)) + N'("#inputDatosSerie").html(series);		

			var marcas = "";
			for(var i in js.marca){ marcas += "<div class=''dvSub'' onclick=''inputTbDatosEliminar(\"Marca\",\""+js.marca[i].marca+"\")''>"+js.marca[i].marca+"</div>"; }
			' + convert(nvarchar(max),NCHAR(36)) + N'("#inputDatosMarca").html(marcas);

			var familias = "";
			for(var i in js.familia){ familias += "<div class=''dvSub'' onclick=''inputTbDatosEliminar(\"Familia\",\""+js.familia[i].familia+"\")''>"+js.familia[i].familia+"</div>"; }
			' + convert(nvarchar(max),NCHAR(36)) + N'("#inputDatosFamilia").html(familias);

			var subfamilias = "";
			for(var i in js.subfamilia){ subfamilias += "<div class=''dvSub'' onclick=''inputTbDatosEliminar(\"Subfamilia\",\""+js.subfamilia[i].subfamilia+"\")''>"+js.subfamilia[i].subfamilia+"</div>"; }
			' + convert(nvarchar(max),NCHAR(36)) + N'("#inputDatosSubfamilia").html(subfamilias);

			if(modo==="guardar"){ 
				cargarTeleVentaLlamadas("listaGlobal"); 
				if(js.llamUserReg==="0"){
					' + convert(nvarchar(max),NCHAR(36)) + N'("#inpNombreTV, #inpFechaTV").val("");
					alert("No se han encontrado llamadas con los parámetros seleccionados!");
				}
			}		
        } else { alert(''Error S.P. pOperadorConfig!\n'' + JSON.stringify(ret)); }
    }, false);
}

function inputTbDatos(id){
	if(id==="Fecha" || id==="Nombre" || id===""){ return; }
	' + convert(nvarchar(max),NCHAR(36)) + N'("#dvinputDatosTemp").remove();
	' + convert(nvarchar(max),NCHAR(36)) + N'("body").prepend("<div id=''dvinputDatosTemp'' class=''dvTemp''>"+icoCargando16 + "cargando datos...</div>");
	var y = (' + convert(nvarchar(max),NCHAR(36)) + N'("#inputDatos" + id).offset()).top;
	var x = (' + convert(nvarchar(max),NCHAR(36)) + N'("#inputDatos"+id).offset()).left;
	' + convert(nvarchar(max),NCHAR(36)) + N'("#dvinputDatosTemp").offset({top:y,left:x}).stop().fadeIn();	
	
	var contenido = "";
    var modo = id.toLowerCase().replace(" ", "_").normalize("NFD").replace(/[\u0300-\u036f]/g, "");
    var elJS = ''{"modo":"'' + modo + ''",'' + paramStd + ''}'';
	
    flexygo.nav.execProcess(''pInpDatos'', '''', null, null, [{''Key'':''elJS'',''Value'':limpiarCadena(elJS)}], ''modal640x480'', false, ' + convert(nvarchar(max),NCHAR(36)) + N'(this), function(ret){
        if (ret) {
            var js = JSON.parse(limpiarCadena(ret.JSCode));
            if (js.length > 0) {
                for (var i in js) {
                    contenido += "<div class=''dvLista'' onclick=''inputTbDatosAsignar(\""+id+"\",\""+js[i].codigo+" - "+' + convert(nvarchar(max),NCHAR(36)) + N'.trim(js[i].nombre)+"\")''>"
                        + js[i].codigo + " - " + js[i].nombre
                        + "</div>";
                }
            } else { contenido = "<div style=''color:red;''>Sin resultados!</div>"; }
            ' + convert(nvarchar(max),NCHAR(36)) + N'("#dvinputDatosTemp").html( contenido);
        } else { alert(''Error S.P. pInpDatos!\n'' + JSON.stringify(ret)); }
    }, false);
}
function inputTbDatosAsignar(id,valor){
	if((' + convert(nvarchar(max),NCHAR(36)) + N'("#inputDatos"+id).html()).indexOf(valor)===-1){
		var htmlVal = ' + convert(nvarchar(max),NCHAR(36)) + N'("#inputDatos"+id).html();
		if(id==="Serie"){ htmlVal=""; }
		' + convert(nvarchar(max),NCHAR(36)) + N'("#inputDatos"+id).html( htmlVal + "<div class=''dvSub'' onclick=''inputTbDatosEliminar(\""+id+"\",\""+valor+"\")''>"+valor+"</div>");
		if(' + convert(nvarchar(max),NCHAR(36)) + N'.trim(' + convert(nvarchar(max),NCHAR(36)) + N'("#inpNombreTV").val())===""){ autoNombreTV=true; }
		if(autoNombreTV){ 
			' + convert(nvarchar(max),NCHAR(36)) + N'("#inpNombreTV").val( (' + convert(nvarchar(max),NCHAR(36)) + N'("#inpNombreTV").val()).replace("+"+id,"").replace(id,"") +"+"+id);
			var elNom = ' + convert(nvarchar(max),NCHAR(36)) + N'("#inpNombreTV").val();
			if(Left(elNom,1)==="+"){ ' + convert(nvarchar(max),NCHAR(36)) + N'("#inpNombreTV").val(elNom.replace("+","")); }
		}
	}
	' + convert(nvarchar(max),NCHAR(36)) + N'("#dvinputDatosTemp").fadeOut(300,function(){ ' + convert(nvarchar(max),NCHAR(36)) + N'("#dvinputDatosTemp").remove(); });
}
function inputTbDatosEliminar(id,valor){ console.log("inputTbDatosEliminar("+id+","+valor+")");
	var contenido = "";
	' + convert(nvarchar(max),NCHAR(36)) + N'("#inputDatos"+id).find("div").each(function(){
		if(' + convert(nvarchar(max),NCHAR(36)) + N'(this).text()!==valor){ 
			contenido += "<div class=''dvSub'' onclick=''inputTbDatosEliminar(\""+id+"\",\""+' + convert(nvarchar(max),NCHAR(36)) + N'(this).text()+"\")''>"+' + convert(nvarchar(max),NCHAR(36)) + N'(this).text()+"</div>"; 
		}
	});
	' + convert(nvarchar(max),NCHAR(36)) + N'("#inputDatos"+id).html(contenido);
	console.log("autoNombreTV: "+autoNombreTV+" contenido: "+contenido);
	if(autoNombreTV && contenido===""){ ' + convert(nvarchar(max),NCHAR(36)) + N'("#inpNombreTV").val( (' + convert(nvarchar(max),NCHAR(36)) + N'("#inpNombreTV").val()).replace("+"+id,"").replace(id,"") ); }
	if(Left(' + convert(nvarchar(max),NCHAR(36)) + N'("#inpNombreTV").val(),1)==="+"){ ' + convert(nvarchar(max),NCHAR(36)) + N'("#inpNombreTV").val((' + convert(nvarchar(max),NCHAR(36)) + N'("#inpNombreTV").val()).replace("+","")); }
}

function guardarTeleVenta(tf){ 
	var nombre = ' + convert(nvarchar(max),NCHAR(36)) + N'.trim(' + convert(nvarchar(max),NCHAR(36)) + N'("#inpNombreTV").val());
	var fecha = ' + convert(nvarchar(max),NCHAR(36)) + N'.trim(' + convert(nvarchar(max),NCHAR(36)) + N'("#inpFechaTV").val());
	if(nombre===""){ alert("El nombre para el registro de llamadas es obligatorio!"); return; }
	if(fecha===""){ alert("La fecha es obligatoria!"); return; }
	FechaTeleVenta=fecha;
	' + convert(nvarchar(max),NCHAR(36)) + N'("#dvFechaTV").html(fecha);
	cargarTbConfigOperador("guardar",tf);
}

</script>',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,N'noicon',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,0,0,NULL,NULL,NULL,NULL,NULL,0,0,0,1)
 ,(N'TV_Pedido',N'flx-html',N'project',NULL,NULL,N'TV_Pedido',N'TV_Pedido',N'none',1,1,1,0,NULL,NULL,N'<div class="tvTitulo esq1100">Pedido</div>
<div id="dvDatosDelClienteMin"></div>
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
		<span id="spBtnAnyCont">
			<br>
			<span class="MIboton esq05" onclick="pedidoAnyadirDetalle()">añadir al pedido</span>
		</span>
		<div id="dvPedidoDetalle"></div>
	</div>
</div>',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,N'noicon',NULL,NULL,NULL,NULL,NULL,NULL,NULL,N'inv moduloPedido',NULL,0,0,0,NULL,NULL,NULL,NULL,NULL,0,0,0,1)
 ,(N'TV_UltimosPedidos',N'flx-html',N'project',NULL,NULL,N'TV_UltimosPedidos',N'TV_UltimosPedidos',N'none',1,1,1,0,NULL,NULL,N'<div class="tvTitulo esq1100">Pedidos</div>
<div id="dvUltimosPedidos" style="border:1px solid #323f4b; padding:10px; border-sizing:border-box;"></div>
',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,N'noicon',NULL,NULL,NULL,NULL,NULL,NULL,NULL,N'moduloTV inv',NULL,0,0,0,NULL,NULL,NULL,NULL,NULL,0,0,0,1)
 ,(N'usuariosTV',N'flx-objectlist',N'project',N'gestores',NULL,N'usuariosTV',N'Gestores',N'clean',0,0,0,0,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,N'noicon',N'syspager-listfooter',20,NULL,NULL,NULL,N'gestores',NULL,N'inv sombra zi100',NULL,0,0,0,NULL,NULL,NULL,NULL,NULL,0,0,0,1)
) AS Source ([ModuleName],[TypeId],[ClassId],[ObjectName],[ObjectFilter],[Descrip],[Title],[ContainerId],[CollapsibleButton],[FullscreenButton],[RefreshButton],[SearchButton],[SQlSentence],[Header],[HTMLText],[Footer],[Empty],[CssText],[ScriptText],[ChartTypeId],[ChartSettingName],[Series],[Labels],[Value],[Params],[JsonOptions],[Path],[TransFormFilePath],[IconName],[PagerId],[PageSize],[ConnStringID],[ToolbarName],[GridbarName],[TemplateId],[HeaderClass],[ModuleClass],[JSAfterLoad],[Searcher],[ShowWhenNew],[ManualInit],[SchedulerName],[TimelineSettingName],[KanbanSettingsName],[ChartBackground],[ChartBorder],[Reserved],[Cache],[Offline],[OriginId])
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
  [OriginId] = Source.[OriginId]
WHEN NOT MATCHED BY TARGET THEN
 INSERT([ModuleName],[TypeId],[ClassId],[ObjectName],[ObjectFilter],[Descrip],[Title],[ContainerId],[CollapsibleButton],[FullscreenButton],[RefreshButton],[SearchButton],[SQlSentence],[Header],[HTMLText],[Footer],[Empty],[CssText],[ScriptText],[ChartTypeId],[ChartSettingName],[Series],[Labels],[Value],[Params],[JsonOptions],[Path],[TransFormFilePath],[IconName],[PagerId],[PageSize],[ConnStringID],[ToolbarName],[GridbarName],[TemplateId],[HeaderClass],[ModuleClass],[JSAfterLoad],[Searcher],[ShowWhenNew],[ManualInit],[SchedulerName],[TimelineSettingName],[KanbanSettingsName],[ChartBackground],[ChartBorder],[Reserved],[Cache],[Offline],[OriginId])
 VALUES(Source.[ModuleName],Source.[TypeId],Source.[ClassId],Source.[ObjectName],Source.[ObjectFilter],Source.[Descrip],Source.[Title],Source.[ContainerId],Source.[CollapsibleButton],Source.[FullscreenButton],Source.[RefreshButton],Source.[SearchButton],Source.[SQlSentence],Source.[Header],Source.[HTMLText],Source.[Footer],Source.[Empty],Source.[CssText],Source.[ScriptText],Source.[ChartTypeId],Source.[ChartSettingName],Source.[Series],Source.[Labels],Source.[Value],Source.[Params],Source.[JsonOptions],Source.[Path],Source.[TransFormFilePath],Source.[IconName],Source.[PagerId],Source.[PageSize],Source.[ConnStringID],Source.[ToolbarName],Source.[GridbarName],Source.[TemplateId],Source.[HeaderClass],Source.[ModuleClass],Source.[JSAfterLoad],Source.[Searcher],Source.[ShowWhenNew],Source.[ManualInit],Source.[SchedulerName],Source.[TimelineSettingName],Source.[KanbanSettingsName],Source.[ChartBackground],Source.[ChartBorder],Source.[Reserved],Source.[Cache],Source.[Offline],Source.[OriginId])
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





