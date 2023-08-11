<div id="dvConfiguracionTeleVenta" class="mi-module ListadoSeccion">
	<table id="tbConfiguracionOperador" class="tbFrm">
		<tr>
			<th>Nombre del listado</th>
			<th class="tbHover" onclick="listadosGestores()">Gestor <span class='flR'>&#9660;</span></th>
			<th>Desde</th>
			<th>Hasta</th>
			<th></th>
		</tr>
		<tr>		
			<td><input type="text" id="inpNombreListado" style="width:100%; text-align:left; color:#333;" onkeyup="autoNombreTV=false;"></td>			
			<td style="position:relative;">
				<div id="dvListadoGestores" class="sombra" style="z-index:2; position:absolute; margin-top:-10px; padding:10px; background:#f2f2f2; border:1px solid:#CCC; display:none;"></div>
				<div id="dvListadoTDGestores"></div>
			</td>
			<td class="taC"><input type="text" id="ListadosDesde" placeholder="dd-mm-aaaa" onfocus="(this.type='date')" onblur="(this.type='text'); ListadosComprobarFechas();" style="width:90%; text-align:center;"></td>
			<td class="taC"><input type="text" id="ListadosHasta" placeholder="dd-mm-aaaa" onfocus="(this.type='date')" onblur="(this.type='text'); ListadosComprobarFechas();" style="width:90%; text-align:center;"></td>
			<td class="taC"><span class="MIbotonGreen" onclick="ListadosGenerar();">GENERAR</span></td>
		</tr>
	</table>
	<br>
</div>


<div id="dvBtnImp" class="ListadoSeccion inv MI_noImp" style="padding:20px; text-align:center;">
	<span class="MIbotonGreen" onclick="window.print()">IMPRIMIR</span>
	<span class="MIbotonGreen" style="margin-left:12px;" onclick="ListadosVolver()">volver</span>
</div>


<div id="dvListadosSeccion" class="ListadoSeccion">
	<div style="background:#68CDF9; padding:5px;">Listado</div>
	<div id="dvBuscList">
		<input type="text" id="dvBuscadorListadosListado" placeholder="Buscar por cualquiera de los campos" 
		style="width:100%; box-sizing:border-box;" onkeyup="buscarEnTabla(this.id,'tbListadosListado');">
	</div>
	<div id="dvListadosListado"></div>
	<br>
</div>


<div id="dvRegistrosTV" class="ListadoSeccion">
	<div style="background:#68CDF9; padding:5px;">Registros TeleVenta</div>
	<div id="dvBusc">
		<input type="text" id="dvBuscadorListados" placeholder="Buscar por cualquiera de los campos" 
		style="width:100%; box-sizing:border-box;" onkeyup="buscarEnTabla(this.id,'tbListadosTV');">
	</div>
	<div id="dvListadosTVListado"></div>
	<br>
</div>

<script>
cargarListadosListado();
cargarListadoTV();

var aListadosGestores = [];

function cargarListadoTV(){
	var parametros = '{"sp":"pListados","modo":"cargarListadoTV",'+paramStd+'}';
	flexygo.nav.execProcess('pMerlos','',null,null,[{'Key':'parametros','Value':limpiarCadena(parametros)}],'current',false,$(this),function(ret){if(ret){
		var js = JSON.parse(limpiarCadena(ret.JSCode));
		var contenido = `
			<table id="tbListadosTV" class="tbStd">
				<tr>
					<th>Usuario</th>
					<th>Fecha</th>
					<th>Nombre</th>
					<th class="taC">Llamadas</th>
					<th class="taC">Pedidos</th>
					<th class="taC">SubTotal</th>
					<th class="taC">Importe</th>
				</tr>
		`;
		if(js.length>0){
			for(var i in js){ 
				contenido += `
					<tr onclick="exportarListado('`+js[i].id+`')">
						<td>`+js[i].usuario+`</td>
						<td>`+js[i].fecha+`</td>
						<td>`+js[i].nombre+`</td>
						<td class="taR">`+js[i].llamadas+`</td>
						<td class="taR">`+js[i].pedidos+`</td>
						<td class="taR">`+new Intl.NumberFormat('de-DE',{style: 'currency',currency:'EUR',minimumFractionDigits:2}).format(parseFloat(js[i].subtotal))+`</td>
						<td class="taR">`+new Intl.NumberFormat('de-DE',{style: 'currency',currency:'EUR',minimumFractionDigits:2}).format(parseFloat(js[i].importe))+`</td>
					</tr>
				`
			}
			contenido += "</table>";
		}else{ contenido = "Sin resultados!"; }
		$("#dvListadosTVListado").html(contenido);
	} else { alert('Error SP pListados - cargarListadoTV!' + JSON.stringify(ret)); } }, false);
}

function exportarListado(id){
	var parametros = '{"sp":"pListados","modo":"exportarListado","id":"'+id+'",'+paramStd+'}';
	flexygo.nav.execProcess('pMerlos','',null,null,[{'Key':'parametros','Value':limpiarCadena(parametros)}],'current',false,$(this),function(ret){if(ret){
		var js = JSON.parse(limpiarCadena(ret.JSCode));
		var contenido = `
			<table id="tbListadosTV" class="tbStd">
				<tr>
					<th>Cód. Cliente</th>
					<th>Nombre</th>
					<th class="taC">Teléfono</th>
					<th class="taC">Horario</th>
					<th class="taC">Pedido</th>
					<th class="taC">Serie</th>
					<th class="taC">SubTotal</th>
					<th class="taC">Importe</th>
					<th class="taC">Completado</th>
				</tr>
		`;
		if(js.length>0){
			for(var i in js){ 
				contenido += `
					<tr>
						<td>`+js[i].cliente+`</td>
						<td>`+js[i].vc[0].RCOMERCIAL+`</td>
						<td class="taC">`+js[i].vc[0].TELEFONO+`</td>
						<td class="taC">`+js[i].horario+`</td>
						<td class="taR">`+js[i].pedido+`</td>
						<td class="taC">`+js[i].serie+`</td>
						<td class="taR">`+new Intl.NumberFormat('de-DE',{style: 'currency',currency:'EUR',minimumFractionDigits:2}).format(parseFloat(js[i].subtotal))+`</td>
						<td class="taR">`+new Intl.NumberFormat('de-DE',{style: 'currency',currency:'EUR',minimumFractionDigits:2}).format(parseFloat(js[i].importe))+`</td>
						<td class="taC">`+js[i].completado+`</td>
					</tr>
				`
			}
			contenido += "</table>";
		}else{ contenido = "Sin resultados!"; }
		$("#dvListadosTVListado").html(contenido);
		$(".ListadoSeccion").hide();
		$("#dvRegistrosTV, #dvBtnImp").show();
	} else { alert('Error SP pListados - exportarListado - id: '+id+'!\n' + JSON.stringify(ret)); } }, false);
}

function ListadosVolver(){ flexygo.nav.openPageName('TV_Listados','','',null,'current',false,$(this)); }

function listadosGestores(){
	var parametros = '{"sp":"pListadosGestores","modo":"dameGestores",'+paramStd+'}';
	flexygo.nav.execProcess('pMerlos','',null,null,[{'Key':'parametros','Value':limpiarCadena(parametros)}],'current',false,$(this),function(ret){if(ret){
		var contenido = "";
		var js = JSON.parse(ret.JSCode);
		if(js.length>0){
			for(var i in js){ contenido += "<div class='dvSub' onclick='ListadosSeleccionarGestor(\""+js[i].CODIGO+"\",\""+js[i].NOMBRE+"\")'>"+js[i].CODIGO+" - "+js[i].NOMBRE+"</div>"; }
		}else{ contenido = "<div style='text-align:center; font:16px arial; color:red;'>Sin registros!</div>"; }
		$("#dvListadoGestores").html(contenido).slideDown();
	} else { alert('Error SP pListados - exportarListado - id: '+id+'!\n' + JSON.stringify(ret)); } }, false);
}

function ListadosSeleccionarGestor(codigo,nombre){
	aListadosGestores.push('{"codigo":"'+codigo+'","nombre":"'+nombre+'"}');
	ListadosDivGestores();
}

function ListadosDivGestores(){
	var contenido = "";
	for(var i in aListadosGestores){ 
		var js = JSON.parse(aListadosGestores[i]);
		contenido += "<div class='dvSub' onclick='ListadosEliminarGestor(\""+js.codigo+"\")'>"+js.codigo+" - "+js.nombre+"</div>"; 
	}
	$("#dvListadoTDGestores").html(contenido);
	$(document).click();
}

function ListadosEliminarGestor(codigo){
	console.log("ListadosEliminarGestor("+codigo+")");
}

function ListadosComprobarFechas(){
	var ListadosFDesde = $.trim($("#ListadosDesde").val());
	var ListadosFHasta = $.trim($("#ListadosHasta").val());					
	if(ListadosFHasta===""){ ListadosFHasta=ListadosFDesde; }
	$("#ListadosDesde").val(fechaFormato(ListadosFDesde));
	$("#ListadosHasta").val(fechaFormato(ListadosFHasta));
}

function ListadosGenerar(){
	var NombreListado = $.trim($("#inpNombreListado").val());
	var ListadosFDesde = $.trim($("#ListadosDesde").val());
	var ListadosFHasta = $.trim($("#ListadosHasta").val());
	
	if(NombreListado===""){ abrirVelo("No se ha indicado un nombre para el registro!",null,null,1); return; }
	if(aListadosGestores.length===0){ abrirVelo("No se han seleccionado Gestores!",null,null,1); return; }
	if(ListadosFDesde===""){ abrirVelo("No se ha indicado la fecha de origen!",null,null,1); return; }
	if(ListadosFHasta===""){ abrirVelo("No se ha indicado la fecha de destino!",null,null,1); return; }
	
	var parametros = '{"sp":"pListadosGestores","modo":"dameListado","NombreListado":"'+NombreListado+'","losGestores":['+aListadosGestores+'],"ListadosFDesde":"'+ListadosFDesde+'","ListadosFHasta":"'+ListadosFHasta+'",'+paramStd+'}';
	flexygo.nav.execProcess('pMerlos','',null,null,[{'Key':'parametros','Value':limpiarCadena(parametros)}],'current',false,$(this),function(ret){if(ret){
		cargarListadosListado();
		resetFrmListados();
	} else { alert('Error SP pListados - exportarListado - id: '+id+'!\n' + JSON.stringify(ret)); } }, false);
}

function cargarListadosListado(){
	var parametros = '{"sp":"pListados","modo":"cargarListados",'+paramStd+'}';
	flexygo.nav.execProcess('pMerlos','',null,null,[{'Key':'parametros','Value':limpiarCadena(parametros)}],'current',false,$(this),function(ret){if(ret){
		var js = JSON.parse(limpiarCadena(ret.JSCode));
		var contenido = `
			<table id="tbListadosListado" class="tbStd">
				<tr>
					<th>Nombre</th>
					<th>Gestor</th>
					<th class="taC">Desde</th>
					<th class="taC">Hasta</th>
				</tr>
		`;
		if(js.length>0){
			for(var i in js){ 
				contenido += `
					<tr onclick="imprimirListado('`+js[i].id+`')">
						<td>`+js[i].nombreListado+`</td>
						<td>`+IsNull(js[i].gestor,"")+`</td>
						<td class="taC">`+js[i].fecha+`</td>
						<td class="taC">`+IsNull(js[i].hasta,"")+`</td>
					</tr>
				`
			}
			contenido += "</table>";
		}else{ contenido = "Sin resultados!"; }
		$("#dvListadosListado").html(contenido);
	} else { alert('Error SP pListados - cargarListados!' + JSON.stringify(ret)); } }, false);
}

function resetFrmListados(){
	$("#inpNombreListado, #ListadosDesde, #ListadosHasta").val("");
	$("#dvListadoTDGestores").html("");
}

function imprimirListado(id){
	var parametros = '{"sp":"pListados","modo":"imprimirListado","id":"'+id+'",'+paramStd+'}';
	flexygo.nav.execProcess('pMerlos','',null,null,[{'Key':'parametros','Value':limpiarCadena(parametros)}],'current',false,$(this),function(ret){if(ret){ console.log(ret.JSCode);
		var js = JSON.parse(limpiarCadena(ret.JSCode));
		var contenido = `
			<table id="tbListadosTV" class="tbStd">
				<tr>
					<th>Cód. Cliente</th>
					<th>Cliente</th>
					<th>Población</th>
					<th class="taC">Fecha</th>
					<th class="taC">Horario</th>
				</tr>
		`;
		if(js.length>0){
			for(var i in js){ 
				contenido += `
					<tr>
						<td>`+$.trim(js[i].cliente)+`</td>
						<td>`+$.trim(js[i].vc[0].nombre)+`</td>
						<td>`+$.trim(js[i].vc[0].poblacion)+`</td>
						<td class="taC" style="white-space: nowrap;">`+$.trim(js[i].fecha)+`</td>
						<td class="taC" style="white-space: nowrap;">`+$.trim(js[i].horario)+`</td>
					</tr>
				`
			}
			contenido += "</table>";
		}else{ contenido = "Sin resultados!"; }
		$("#dvListadosListado").html(contenido);
		$(".ListadoSeccion").hide();
		$("#dvListadosSeccion, #dvBtnImp").show();
	} else { alert('Error SP pListados - imprimirListado - id: '+id+'!\n' + JSON.stringify(ret)); } }, false);
}
</script>