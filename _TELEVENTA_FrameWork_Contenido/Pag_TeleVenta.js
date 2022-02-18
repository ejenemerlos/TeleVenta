$("#mainNav").hide();

// Comprobar Ejercicio en Curso ----------------------------------------------------------------------------------------------------------------------------
var parametros = '{"sp":"pConfiguracion","modo":"ComprobarEjercicio"}';
flexygo.nav.execProcess('pMerlos','',null,null,[{'Key':'parametros','Value':limpiarCadena(parametros)}],'current',false,$(this),function(ret){if(ret){
	if(ret.JSCode!==""){ console.log("Se ha actualizado el portal al ejercicio "+ret.JSCode); }
}else{ alert('Error S.P. pConfiguracion - ComprobarEjercicio!!!\n'+JSON.stringify(ret)); } }, false);
// ----------------------------------------------------------------------------------------------------------------------------------------------------------

var ClienteCodigo = "";
var ctvll = "";
var PedidoGenerado = ""; 
var ArticuloClienteBuscando = false;
var _CargarOfertasCliente = false;
var dentroDelDiv = false;

if((flexygo.history.get($('main')).defaults)!==null &&	(flexygo.history.get($('main')).defaults)!==undefined){ 
	var elJSON = JSON.parse(flexygo.history.get($('main')).defaults);
	try{ClienteCodigo = elJSON.CODIGO;}catch{ClienteCodigo="";}
}

setTimeout(function(){
	if(ClienteCodigo!==""){ 
		cargarTeleVentaCliente(ClienteCodigo); 
		cargarTeleVentaLlamadas("llamadasDelCliente");
		cargarTeleVentaUltimosPedidos(ClienteCodigo); 
	}else{cargarTeleVentaLlamadas("listaGlobal");}
},1000);

function inicioTeleVenta(){
	cerrarVelo();
	PedidoGenerado="";	
	PedidoDetalle = [];	
	$("#btnPedido").text("Pedido");
	$(".moduloTV, #btnConfiguracion").stop().fadeIn();
	$(".moduloPedido").hide();
	recargarTVLlamadas();
}

function recargarTVLlamadas(tf){
	if(tf){ 
		cargarTbConfigOperador("recargar",false);
	}else{
		abrirVelo(icoCargando16 + " recargando datos...");
		tbLlamadasGlobal_Sel(IdTeleVenta,FechaTeleVenta, NombreTeleVenta); 
		setTimeout(function(){ tbLlamadasGlobal_Sel(IdTeleVenta,FechaTeleVenta, NombreTeleVenta); cerrarVelo(); },1000);
	}
}

function configurarTeleVenta(tf){
	if($("#dvConfiguracionTeleVenta").is(":visible") || tf){
		FechaTeleVenta = $.trim($("#inpFechaTV").val());
		NombreTeleVenta = $.trim($("#inpNombreTV").val());
		if(FechaTeleVenta===""){ alert("Debes seleccionar la fecha!"); return; }
		if(NombreTeleVenta===""){ alert("El nombre no puede estar vacío!"); return; }
		if(!existeFecha(FechaTeleVenta)){ alert("Ups! Parece que la fecha no es correcta!"); return; }
		$("#btnTerminar,#btnPedido,#btnConfiguracion").show();
		$("flx-module[moduleName='TV_Cliente'],flx-module[moduleName='TV_Llamadas'],flx-module[moduleName='TV_UltimosPedidos']").slideDown();
		$("flx-module[moduleName='TV_LlamadasTV']").stop().slideUp();
		$("#dvConfiguracionTeleVenta").stop().slideUp(300,function(){ $("#dvOpcionesTV").removeClass("esq1100").addClass("esq10"); }); 
		cargarTeleVentaLlamadas("cargarLlamadas");
		$("#dvFechaTV").html(FechaTeleVenta);
		estTV();
	}else { 
		$("#btnTerminar,#btnPedido,#btnConfiguracion").hide();
		$("flx-module[moduleName='TV_Cliente'],flx-module[moduleName='TV_Llamadas'],flx-module[moduleName='TV_UltimosPedidos']").hide();
		$("#dvOpcionesTV").removeClass("esq10").addClass("esq1100"); 
		$("flx-module[moduleName='TV_LlamadasTV'],#dvConfiguracionTeleVenta").stop().slideDown();
		cargarTeleVentaLlamadas("listaGlobal");		
	}
}

function estTV(){
	$("#dvEstTV").html(icoCargando16+" cargando datos...");
	var contenido = "";
	var parametros = '{"modo":"estadisticas","IdTeleVenta":"'+IdTeleVenta+'","FechaTeleVenta":"'+FechaTeleVenta+'","nombreTV":"'+NombreTeleVenta+'",'+paramStd+'}';
	flexygo.nav.execProcess('pEstTV','',null,null,[{'key':'parametros','value':limpiarCadena(parametros)}],'modal640x480',false,$(this),function(ret){
		if(ret){ 
			var js = JSON.parse(limpiarCadena(ret.JSCode));
			contenido = "Clientes: "+js[0].clientes+"&nbsp;&nbsp;&nbsp; Llamadas: "+js[0].llamadas
					  + "&nbsp;&nbsp;&nbsp; Pedidos: "+js[0].pedidos
					  + "&nbsp;&nbsp;&nbsp; Importe: "+js[0].importe+"&euro;";
			$("#dvEstTV").html(contenido);
			var filtros = js[0].filtros;
			var losFiltros = "";
			if(js[0].filtros[0].gestor.length>0){ losFiltros += " gestor,"; } 
			if(js[0].filtros[0].ruta.length>0){ losFiltros += " ruta,"; } 
			if(js[0].filtros[0].vendedor.length>0){ losFiltros += " vendedor,"; } 
			if(js[0].filtros[0].serie.length>0){ losFiltros += " serie,"; } 
			if(js[0].filtros[0].marca.length>0){ losFiltros += " marca,"; } 
			if(js[0].filtros[0].familia.length>0){ losFiltros += " familia,"; } 
			if(js[0].filtros[0].subfamilia.length>0){ losFiltros += " subfamilia "; } 
			
			if(losFiltros.length>0){ 
				losFiltros = losFiltros.substring(0,losFiltros.length-1); 
				$("#dvFiltrosTV").html("El registro '"+NombreTeleVenta+"' contiene filtros de "+losFiltros); 
			}else{ $("#dvFiltrosTV").html("Registro '"+NombreTeleVenta+"'"); }
		}else{ alert("Error SP: pLlamadas!!!"+JSON.stringify(ret)); }	
	},false);
}

function asignarMesesConsumo(){
	flexygo.nav.execProcess('pConfiguracion','',null,null, 
	[{'Key':'modo','Value':'MesesConsumo'},{'Key':'valor','Value':$("#inpMesesConsumo").val()}], 'modal640x480', false, $(this), function(ret){if(ret){ 
		$("#spanAsignacionAviso").fadeIn(); MesesConsumo = $("#inpMesesConsumo").val(); setTimeout(function(){ $("#spanAsignacionAviso").fadeOut(); },2000);
	}else{ alert('Error S.P. pConfiguracion!!!\n'+ret); } }, false);
}

function cargarConfiguracionTV(elCallBack){
	var parametros = '{"modo":"lista"}';
	flexygo.nav.execProcess('pConfiguracion','',null,null,[{'Key':'parametros','Value':limpiarCadena(parametros)}],'modal640x480',false,$(this),function(ret){if(ret){ 
		var js = JSON.parse(limpiarCadena(ret.JSCode));
		// Interruptores
		for(var i in js.IO){if(parseInt(js.IO[i].valor)===0){window["Conf"+js.IO[i].nombre]=0; }else{window["Conf"+js.IO[i].nombre]=1; }}
		if(ConfNoCobrarPortes===1){ $("#spNoCobrarPortes").show(); }else{ $("#spNoCobrarPortes").hide(); }
		if(ConfVerificarPedido===1){ $("#spVerificarPedido").show(); }else{ $("#spVerificarPedido").hide(); }
		// Comprobar si el cliente tiene varias direcciones
		var direcciones = '{"sp":"pClientesDirecciones","modo":"dameDirecciones","cliente":"'+ClienteCodigo+'"}';
		flexygo.nav.execProcess('pMerlos','',null,null,[{'Key':'parametros','Value':limpiarCadena(direcciones)}],'current',false,$(this),function(ret){if(ret){
			   console.log("pClientesDirecciones - ret.JSCode:\n"+ret.JSCode);
			   var contenido = "";
			   var dir = JSON.parse(limpiarCadena(ret.JSCode)); console.log("dir.error: "+dir.error);
			   if(dir.error===""){
				   $("#tdDirEntrega").html(dir.datos[0].DIRECCION);
				   $("#inpDirEntrega").val(dir.datos[0].LINEA);
				   if(dir.datos.length>1){
					   $("#thDirEntrega").addClass("fadeIO").addClass("modifDir").css("color","green");
					   $("#tdDirEntrega").css("background","#C6FFC5");
					   for(var d in dir.datos){
						   var direccion = dir.datos[d];
							contenido += "<div class='dvSub' onclick='asignarDireccionEntrega(\""+direccion.DIRECCION+"\",\""+direccion.LINEA+"\")'>"+direccion.DIRECCION+"</div>";
					   }
				   }else{ $("#thDirEntrega").removeClass("fadeIO").removeClass("modifDir").css("color","#666"); $("#tdDirEntrega").css("background","#EDEFF3"); }
			   }else{
				   contenido = "Error! - pClientesDirecciones!";
			   }
			   $("#dvCliDir").html(contenido);			   
		} else { alert('Error SP pClientesDirecciones - dameDirecciones!'+JSON.stringify(ret)); }}, false);
		// elCallBack
		if(elCallBack){ elCallBack(); }
	}else{ alert("Error SP: cargarConfiguracionTV - pConfiguracion - lista!!!\n"+JSON.stringify(ret)); }}, false);
}

function pedidoTV(){
	if(new Date(fechaCambiaFormato(FechaTeleVenta)) < new Date(fechaCambiaFormato(fechaCorta()))){ alert("No se pueden crear pedidos de días anteriores!"); return; }

	if(ClienteCodigo===""){ alert("Debes seleccionar un cliente!"); return; }
	if($("#btnPedido").text()==="Pedido"){
		$("#btnPedido").text("TeleVenta");
		$("#dvDatosDelClienteMin").html(datosDelCliente);
		$(".moduloTV, #btnConfiguracion").hide();
		$(".moduloPedido").stop().fadeIn();
		cargarConfiguracionTV(function(){cargarArticulosDisponibles(ClienteCodigo);});
		
		// comprobar si tiene Ofertas
		var parametros = '{"modo":"ofertasDelCliente","cliente":"'+ClienteCodigo+'","fecha":"'+FechaTeleVenta+'",'+paramStd+'}';
		flexygo.nav.execProcess('pOfertas','',null,null,[{'Key':'parametros','Value':limpiarCadena(parametros)}],'modal640x480',false,$(this),function(ret){
			if(ret){
				var js = JSON.parse(limpiarCadena(ret.JSCode));
				if(js.length>0){ $("#btnClienteOfertas").addClass("fadeIO"); }else{ $("#btnClienteOfertas").removeClass("fadeIO"); }
		}else{ alert("Error SP: pOfertas - ofertasDelCliente!!!\n"+JSON.stringify(ret)); }}, false);
		
		PedidoDetalle=[]; $("#dvPedidoDetalle").html(""); // por si se ha terminado una llamada sin crear pedido.
	}else{
		$("#btnPedido").text("Pedido");
		$(".moduloTV, #btnConfiguracion").stop().fadeIn();
		$(".moduloPedido").hide();
		$("#taObsInt").val(ObservacionesInternas);
	}
	
	if(PedidoNoCobrarPortes===1){ PedidoNoPortes(); };
}

function cargarSubDatos(objeto,cliente,id,pos){
	var y = ($("#"+id).offset()).top;
	var x = ($("#"+id).offset()).left;	
	var contenido = "";
	var elTXT = "";
	var elJS = '{"objeto":"'+objeto+'","cliente":"'+cliente+'",'+paramStd+'}';
	
	if(pos===-1){ x -=100;}
	 
    $("#dvDatosTemp").remove();
	$("body").prepend("<div id='dvDatosTemp' class='dvTemp' data-id='"+id+"'>"+icoCargando16+" cargando datos...</div>");	
	$("#dvDatosTemp").offset({top:y,left:x}).stop().fadeIn();	
   
    flexygo.nav.execProcess('pObjetoDatos','',null,null,[{'Key':'elJS','Value':elJS}], 'modal640x480', false, $(this), function(ret){if(ret){
		if(esJSON(ret.JSCode)){
			var js = JSON.parse(limpiarCadena(ret.JSCode));		
			if(js.length>0){
				for(var i in js){ 
					 if(objeto==="contactos"){ elTXT = js[i].LINEA+" - "+js[i].PERSONA; }
					 if(objeto==="inciCli" || objeto==="inciArt")  { elTXT = js[i].codigo+" - "+js[i].nombre; }
					contenido += "<div class='dvSub' onclick='asignarObjetoDatos(\""+id+"\",$(this).text())'>"+elTXT+"</div>"; 
				}
				if(objeto==="inciCli"){ 
					contenido = "<div class='dvSub' onclick='asignarObjetoDatos(\"MT\",\"Llamar más tarde\")'>MT - Llamar más tarde</div>"
								+"<div class='dvSub' onclick='asignarObjetoDatos(\"OD\",\"Llamar otro día\")'>OD - Llamar otro día</div>"+contenido;  }
			}else{ contenido="<div style='color:red;'>Sin resultados!</div>"; }
			if(objeto==="inciArt"){
				var inciAsig = $("#inpIncidenciaSolINP"+id.split("inpIncidenciaSol")[1]).val();
				if(inciAsig!==""){ contenido = "<div class='dvSubI' onclick='desasignarCliArt(\""+objeto+"\",\""+cliente+"\",\""+id+"\",\""+pos+"\")'>Asignado: "+inciAsig+"</div><br>" + contenido; }
			}
		}else{ contenido="<div style='color:red;'>Sin resultados!</div>"; }
		$("#dvDatosTemp").html(contenido);
	}else{ $("#dvDatosTemp").remove(); alert('Error S.P. pSeries!\n'+JSON.stringify(ret)); } }, false);
}

function asignarObjetoDatos(id,txt){
	if(Left(id,16)==="inpIncidenciaSol"){ 
		var idN = id.split("inpIncidenciaSol")[1];
		id="inpIncidenciaSolINP"+idN;
		$("#inpIncidenciaSolImg"+idN).attr("src","./Merlos/images/inciRed.png");
		var parametros = '{"modo":"incidenciaArticulo","IdTeleVenta":"'+IdTeleVenta+'","incidencia":"'+txt.split(" - ")[0]+'","cliente":"'+ClienteCodigo+'"'
						+',"articulo":"'+$("#tbArtDispTR"+idN).attr("data-art")+'","observaciones":"'+$.trim($("#inpObservaSolTA"+idN).val())+'",'+paramStd+'}';
		flexygo.nav.execProcess('pLlamadas','',null,null,[{'Key':'parametros','Value':limpiarCadena(parametros)}],'modal640x480',false,$(this),function(ret){});
	}	
	// Llamar más tarde
	if(id==="MT"){ id="inciCliente";  mostrarRelojEJG("inciCliente",true);  }
	// Llamar otro día
	if(id==="OD"){ 
		abrirVelo(
			"Asignar llamada para el cliente "+ClienteCodigo
			+"<br><br>"
			+"<input type='text' id='inpClienteOD' placeholder='Fecha y hora para la próxima llamada' "
			+"style='text-align:center;' "
			+"onfocus='(this.type=\"datetime-local\")' onblur='(this.type=\"text\")'>"
			+"<br><br><br>"
			+"<span class='MIbotonGreen esq05' onclick='ClienteLlamarOtroDia()'>establecer</span>"
			+"&nbsp;&nbsp;&nbsp;<span class='MIbotonRed esq05' onclick='cerrarVelo();'>cancelar</span>"
		);	
		return;
	}
	
	$("#"+id).val(txt);
	$("#dvDatosTemp").fadeOut(); 
}

function desasignarCliArt(objeto,cliente,id,pos){
	$("#inpIncidenciaSolINP"+id.split("inpIncidenciaSol")[1]).val("");
	$("#inpIncidenciaSolImg"+id.split("inpIncidenciaSol")[1]).attr("src","./Merlos/images/inciGris.png");
	cargarSubDatos(objeto,cliente,id,pos);
}

function ClienteLlamarOtroDia(){
	var nuevaLlamada = formatSqlFechaHora($.trim($("#inpClienteOD").val()));
	abrirVelo(icoCargando16 + " agendando llamada...");
	$("#inciCliente").val("OD - Llamar otro día");
	var parametros = '{"modo":"llamarOtroDia","cliente":"'+ClienteCodigo+'","IdTeleVenta":"'+IdTeleVenta+'","nuevaLlamada":"'+nuevaLlamada+'",'+paramStd+'}'; 	
	flexygo.nav.execProcess('pLlamadas','',null,null,[{'Key':'parametros','Value':limpiarCadena(parametros)}],'modal640x480',false,$(this),function(ret){
		if(ret){ terminarLlamada(); }
		else{ alert("Error pLlamadas - llamarOtroDia!\n"+JSON.stringify(ret)); }
	 },false);
}


/*  TV_Cliente  **************************************************************************************************************** */

var elVendedor = "";
var datosDelCliente = "";
	
function cargarTeleVentaCliente(CliCod){
	abrirIcoCarga();
	ClienteCodigo=CliCod;
	var parametros = '{"cliente":"'+ClienteCodigo+'","FechaTeleVenta":"'+FechaTeleVenta+'"}'; console.log("parametros:\n"+parametros);
	flexygo.nav.execProcess('pClienteDatos','',null,null,[{'key':'parametros','value':limpiarCadena(parametros)}],'modal640x480',false,$(this),function(ret){ console.log("limpiarCadena(ret.JSCode):\n"+limpiarCadena(ret.JSCode));
		if(ret){
			if(ret.JSCode===""){ return; }
			var contenido = "";
			datosDelCliente = "";
			var js = JSON.parse(limpiarCadena(ret.JSCode));
			if(js.length>0){
				ObservacionesInternas = js[0].ObservacionesInternas.replace(/<br>/g,"\n");
				
				contenido = 
					 "<table id='tbClienteDatos' class='tbTV'>"
					+"  <tr><th>Código</th><td>"+js[0].CODIGO+"</td><th>Nombre</th><td>"+js[0].NOMBRE+"</td></tr>"
					+"  <tr><th>CIF</th><td>"+js[0].CIF+"</td><th>R. Comercial</th><td>"+js[0].RCOMERCIAL+"</td></tr>"
					+"  <tr><th>Dirección</th><td colspan='3'>"+js[0].DIRECCION+"</td></tr>"
					+"  <tr><th>CP</th><td>"+js[0].CP+"</td><th>Población</th><td>"+js[0].POBLACION+"</td></tr>"
					+"  <tr><th>Provincia</th><td colspan='3'>"+js[0].provincia+"</td></tr>"
					+"  <tr><th>Email</th><td>"+js[0].EMAIL+"</td><th>Teléfono</th><td>"+$.trim(js[0].TELEFONO)+"" 
					+"		<span class='fR MIbotonP esq05' onclick='verTodosLosTelfs()'>ver todos</span></td></tr>"
					+"  <tr id='trTelfsCli' class='inv'></tr>"
					+"  <tr><th>Vendedor</th><td colspan='3'>"+js[0].VENDEDOR+" - "+js[0].nVendedor+"</td></tr>"
					+"  <tr><th colspan='4'>Observaciones del Cliente</th></tr>"
					+"  <tr><td colspan='4'><textarea style='width:100%; height:50px;' disabled>"+js[0].OBSERVACIO+"</textarea></td></tr>"
					+"  <tr><th colspan='4'>Observaciones Internas"
					+"		&nbsp;&nbsp;&nbsp;<span id='ObsIntAV' style='font:bold 14px arial; color:#00a504; display:none;'>Autoguardado - OK</span>"
					+"	</th></tr>"
					+"  <tr><td colspan='4'><textarea id='taObsInt' style='width:100%; height:50px; font:14px arial;'>"+ObservacionesInternas+"</textarea></td></tr>"
					+"</table>";					
				
				var btnOfertas = "inv"; ClienteOferta=false;
				if(js[0].OFERTA==="1" || js[0].OFERTA==="true" || js[0].OFERTA===true){ btnOfertas = ""; ClienteOferta=true; }
				
				var fe = $.trim(js[0].FechaEntrega);
				if((fe.split("-")[0]).length===4){ fe = fe.substr(8,2)+"-"+fe.substr(5,2)+"-"+fe.substr(0,4); }
				
				datosDelCliente = ""
								+ "<div style='background:#fff;'>"
								+ "		<table class='tbStdC'>"
								+ "			<tr>"
								+ "				<td style='width:400px;'>"
								+ "					<div style='padding:10px;box-sizing:border-box;background:#e1e3e7;color:#333;'>"
								+ "						("+js[0].CODIGO+") "+js[0].NOMBRE+""
								+ "						<br>"+js[0].RCOMERCIAL+" ("+js[0].POBLACION+")"
								+ "						<br>e-mail: "+js[0].EMAIL+""
								+ "						<br>teléfono: "+js[0].TELEFONO+""
								+ "						<div style='margin-top:12px;'></div>"
								+ "						<div class='dvRiesgo esq05' onclick='abrirModuloRiesgo(\""+js[0].CODIGO+"\")'>"
								+ "							RECIBOS PENDIENTES: "+js[0].numRecibos
								+ "							&nbsp;&nbsp;&nbsp;IMPORTE: "+parseFloat(js[0].importeRecibos).toFixed(2)+"&euro;"
								+ "							<br>RIESGO: "+parseFloat(js[0].CREDITO).toFixed(2)+"&euro;"
								+ "						</div>"
								+ "					</div>"
								+ "				</td>"
								+ "				<td style='width:400px; vertical-align:top; padding-top:10px;'>"
								+ "					<table id='tbClienteDatosMin'>"
								+ "						<tr>"
								+ "							<th class='vaM pl20' style='width:180px;'>Contacto</th>"
								+ "							<td>"
								+ "								<input type='text' id='inpDataContacto' style='text-align:left; color:#333;' "
								+ "								onclick='cargarSubDatos(\"contactos\",\""+ClienteCodigo+"\",this.id,0);event.stopPropagation();'>"
								+ "							</td>"
								+ "						<tr>"			
								+ " 						<th id='thDirEntrega' class='vaM pl20'>Dir. Entrega</th>"
								+ "							<div id='dvCliDir' class='dvTemp'></div><input type='text' id='inpDirEntrega' style='display:none;' />"
								+ "							<td id='tdDirEntrega' style='background:#EDEFF3; overflow:hidden;' onclick='verDireccionesDelCliente(); event.stopPropagation();'></td>"
								+ "						</tr>"	
								+ "						<tr>"
								+ "							<th class='vaM pl20'>Fecha Entrega</th>"
								+ "							<td>"
								+ "								<input type='text' id='inpFechaEntrega' style='text-align:center; color:#333;' "
								+ "								onkeyup='calendarioEJGkeyUp(this.id,this.value)' "
								+ "								onclick='mostrarElCalendarioEJG(this.id,true);event.stopPropagation();' "
								+ "								value='"+fe+"'>"
								+ "							</td>"
								+ "						</tr>"
								+ "						<tr>"
								+ "							<th class='vaM pl20'>Incidencia Cliente</th>"
								+ "							<td>"
								+ "								<input type='text' id='inciCliente'"
								+ "								onclick='cargarSubDatos(\"inciCli\",\""+ClienteCodigo+"\",this.id,0);event.stopPropagation();' >"
								+ "							</td>"
								+ "						</tr>"									
								+ "					</table>"
								+ "				</td>"
								+ "				<td class='vaT pl20' style='padding-top:7px;'>"
								+ "					Observaciones <span id='spObservacionesPedInt' class='curP' style='font:bold 14px arial; color:#00a504;' onclick='PedidoObservaciones()'>del Pedido</span>"
								+ "					<br>"
								+ "					<textarea id='taObservacionesDelPedido' style='width:98%;height:80px;padding:5px;box-sizing:border-box;'>"+ObservacionesDelPedido+"</textarea>"
								+ "				</td>"
								+ "				<td id='tdOfertas' class='vaT pl20 taC "+btnOfertas+"' style='width:150px; padding-top:45px;'>"
								+ "					<span id='btnClienteOfertas' class='MIbtnF' style='padding:20px;' onclick='ofertasDelCliente()'>Ofertas</span>"
								+ "				</td>"
								+ "			</tr>"
								+ "		</table>"
								+ "</div>";				
			}else{ contenido = "No se han obtenido resultados!"; }
			$("#dvDatosDelCliente").html(contenido);
			$("#taObsInt").off().on("blur",()=>{ ObservacionesInternas_Blur(); });
			elVendedor = js[0].VENDEDOR;
			cerrarVelo();			
		}else{ alert("Error SP: pClientesADI!"+JSON.stringify(ret)); }
	},false);
}

function ObservacionesInternas_Blur(){
	var ObservacionesInternas_ta = $.trim($("#taObsInt").val());
	if(ObservacionesInternas_ta!==ObservacionesInternas){
		$("#ObsIntAV").fadeIn();
		ObservacionesInternas_Click(true);
		setTimeout(()=>{ $("#ObsIntAV").fadeOut(); },1000);
	}
}

function taObservacionesDelPedido_Blur(){
	var ObservacionesInternas_ta = $.trim($("#taObservacionesDelPedido").val());
	if(ObservacionesInternas_ta!==ObservacionesInternas){
		$("#taObservacionesDelPedidoAV").fadeIn();
		ObservacionesInternas_Click();
		setTimeout(()=>{ $("#taObservacionesDelPedidoAV").fadeOut(); },1000);
	}
}

function abrirModuloRiesgo(cliente){
	flexygo.nav.openPage('list','RecibosPendientes','CLIENTE=\''+ClienteCodigo+'\'','{\'CLIENTE\':\''+ClienteCodigo+'\'}','popup',false,$(this)); 
}

function PedidoObservaciones(){
	if($("#spObservacionesPedInt").text()==="del Pedido"){
		$("#spObservacionesPedInt").html("Internas&nbsp;&nbsp;&nbsp;<span id='taObservacionesDelPedidoAV' style='font:bold 14px arial; color:#00a504; display:none;'>Autoguardado - OK</span>"); 
		$("#taObservacionesDelPedido").val(ObservacionesInternas); 
		$("#taObservacionesDelPedido").off().on("blur",()=>{ taObservacionesDelPedido_Blur(); });
	}else{$("#spObservacionesPedInt").text("del Pedido"); $("#taObservacionesDelPedido").val(ObservacionesDelPedido); $("#taObservacionesDelPedido").off()}
}

function ObservacionesInternas_Click(tf){
	ObservacionesInternas = $.trim($("#taObservacionesDelPedido").val());
	if(tf){ ObservacionesInternas = $.trim($("#taObsInt").val()); }
	var parametros = '{"modo":"ObservacionesInternas","cliente":"'+ClienteCodigo+'","observaciones":"'+ObservacionesInternas+'",'+paramStd+'}'; 	
	flexygo.nav.execProcess('pClienteDatos','',null,null,[{'Key':'parametros','Value':limpiarCadena(parametros)}],'modal640x480',false,$(this),function(ret){
		if(!ret){ alert("Error pClienteDatos!\n"+JSON.stringify(ret)); }
	 },false);
}
 
function verFichaDeCliente(){ 
	if(ClienteCodigo===""){ alert("Ningún cliente seleccionado!"); return; }
	flexygo.nav.openPage('view','Cliente','CODIGO=\''+ClienteCodigo+'\'','{\'CODIGO\':\''+ClienteCodigo+'\'}','popup',false,$(this)); 
}

function ofertasDelCliente(){
	var parametros = '{"modo":"ofertasDelCliente","cliente":"'+ClienteCodigo+'","fecha":"'+FechaTeleVenta+'",'+paramStd+'}';
	flexygo.nav.execProcess('pOfertas','',null,null,[{'Key':'parametros','Value':limpiarCadena(parametros)}],'modal640x480',false,$(this),function(ret){
		if(ret){
			var js = JSON.parse(limpiarCadena(ret.JSCode));
			if(js.length>0){ $("#btnClienteOfertas").addClass("fadeIO"); }else{ $("#btnClienteOfertas").removeClass("fadeIO"); }
			abrirVelo("<div>"+icoCargando16+" buscando ofertas para el cliente "+ClienteCodigo+"...</div>");
			var contenido = "<span style='font:bold 14px arial; color:#68CDF9;'>Ofertas - Cliente "+ClienteCodigo+"</span>"
						  + "<span style='float:right;' onclick='cerrarVelo();'>"+icoAspa+"</span>"
						  + "<br><br>"
						  + "<div style='max-height:500px; overflow:hidden; overflow-y:auto;'>"
						  + "	<table id='tbOfertasCliente' class='tbStd'>"
						  + "	<tr>"
						  + "		<th class='taL'>Artículo</th>"
						  + "		<th class='taC'>Inicio</th>"
						  + "		<th class='taC'>Fin</th>"
						  + "		<th class='taC'>PVP</th>"
						  + "		<th class='taC'>Dto.</th>"
						  + "	</tr>";
			if(js.length>0){
				for(var i in js){
					contenido += "<tr onclick='ofertaArticuloBuscar(\""+$.trim(js[i].ARTICULO)+"\")'>"
							  +  "	<td class='taL'>"+$.trim(js[i].ARTICULO)+"</td>"
							  +  "	<td class='taC'>"+$.trim(js[i].FECHA_IN)+"</td>"
							  +  "	<td class='taC'>"+$.trim(js[i].FECHA_FIN)+"</td>"
							  +  "	<td class='taR'>"+parseFloat(js[i].PVP).toFixed(2)+"</td>"
							  +  "	<td class='taR'>"+parseFloat(js[i].DTO1).toFixed(2)+"</td>"
							  +  "</tr>";
				}
				contenido += "</table></div><br><br>";
			}else{
				contenido = "<div>No se han obtenido ofertas para el cliente "+ClienteCodigo+"!"
				+"<br><br><br><span class='MIboton esq05' onclick='cerrarVelo();'>aceptar</span>"
				+"</div>";
			}
			abrirVelo(contenido);
		}else{ alert("Error pOfertas!\n"+JSON.stringify(ret)); }
	},false);
}

function ofertaArticuloBuscar(articulo){
	$("#inpBuscarArticuloDisponible").val(articulo);
	buscarArticuloDisponible(window.event.keyCode=13);
	cerrarVelo();
}

function verTodosLosTelfs(){
	if($("#trTelfsCli").is(":visible")){ $("#trTelfsCli").hide(); return; }
	var parametros = '{"modo":"verTodosLosTelfs","cliente":"'+ClienteCodigo+'",'+paramStd+'}'; 	
	flexygo.nav.execProcess('pClienteDatos','',null,null,[{'Key':'parametros','Value':limpiarCadena(parametros)}],'modal640x480',false,$(this),function(ret){
		if(ret){ 
			var contenido = "<table class='tbStd'>"
						  + "	<tr>"
						  + "		<th>Persona</th>"
						  + "		<th>Cargo</th>"
						  + "		<th>Teléfono</th>"
						  + "	</tr>";
			var js = JSON.parse(ret.JSCode);
			if(js.length>0){
				for(var i in js){
					contenido +="	<tr>"
							  + "		<td>"+$.trim(js[i].PERSONA)+"</td>"
							  + "		<td>"+$.trim(js[i].CARGO)+"</td>"
							  + "		<td>"+$.trim(js[i].TELEFONO)+"</td>"
							  + "	</tr>";
				}
				contenido     +="</table>"
			}else{ contenido = "No se han obtenido resultados!"; }
			$("#trTelfsCli").html("<td colspan='4'>"+contenido+"</td>").show();
		}
		else{ alert("Error pClienteDatos verTodosLosTelfs!\n"+JSON.stringify(ret)); }
	 },false);
}



/*  TV_Llamadas  **************************************************************************************************************** */
function cargarTeleVentaLlamadas(modo){
	abrirIcoCarga();
	ctvll = modo;
	var elDV = "dvLlamadas";
	var contenido = "";
	var parametros = '{"modo":"'+modo+'","cliente":"'+ClienteCodigo+'","IdTeleVenta":"'+IdTeleVenta+'","nombreTV":"'+NombreTeleVenta+'","FechaTeleVenta":"'+FechaTeleVenta+'","usuariosTV":'+UsuariosTV+','+paramStd+'}'; 	
	flexygo.nav.execProcess('pLlamadas','',null,null,[{'key':'parametros','value':limpiarCadena(parametros)}],'modal640x480',false,$(this),function(ret){
		if(ret){
			if(ret.JSCode===""){ contenido = "No se han obtenido resultados!"; }				
			else{ 
				contenido = "";
				
				var js = JSON.parse(limpiarCadena(ret.JSCode));
				if(js.length>0){
					contenido += "<div style='height:370px; overflow:hidden; overflow-y:auto;'>";
					if(modo==="llamadasDelCliente"){						
						contenido += "<table id='tbLlamadasDelCliente' class='tbStdP'>"
									+"	<tr>"
									+"		<th>Fecha</th>"
									+"		<th>Hora</th>"
									+"		<th>Incidencia</th>"
									+"		<th>Pedido</th>"
									+"	</tr>";
					}
					if(modo==="cargarLlamadas"){
						contenido += "<table id='tbLlamadas' class='tbStdP'>"
									+"	<tr>"
									+"		<th>Cliente</th>"
									+"		<th>Nombre</th>"
									+"		<th style='text-align:center;'>Horario</th>"
									+"		<th style='text-align:center;'>Estado</th>"
									+"		<th style='text-align:center;'>Último pedido</th>"
									+"		<th style='text-align:center;'>Pedido</th>"
									+"	</tr>";
					}
					if(modo==="listaGlobal"){
						contenido += ""
									+"<input type='text' id='inpListadoGlobal' placeholder='buscar' "
									+" onkeyup='buscarEnTabla(this.id,\"tbLlamadasGlobal\")'>"
									+"<table id='tbLlamadasGlobal' class='tbStdP' style='margin-top:4px;'>"
									+"	<tr>"
									+"		<th style='width:150px;'>Fecha</th>"
									+"		<th class='rolTeleVentaO'>Usuario</th>"
									+"		<th>Nombre</th>"
									+"		<th style='text-align:center;'>Clientes</th>"
									+"		<th style='text-align:center;'>Llamadas</th>"
									+"		<th style='text-align:center;'>Pedidos</th>"
									+"		<th style='text-align:center;'>Importe</th>"
									+"		<th style='text-align:center;'>Total</th>"
									+"	</tr>";
					}
					
					for(var i in js){
						var elPedido = $.trim(js[i].serie)+" - "+$.trim(js[i].pedido);
						if($.trim(js[i].serie)===""){ elPedido=$.trim(js[i].pedido); }
						if(modo==="llamadasDelCliente"){
							var laHora = Left($.trim(js[i].hora),5);
							var laIncidencia = $.trim(js[i].incidencia)+" - "+$.trim(js[i].ic[0].nIncidencia);	
							var laFecha = $.trim(js[i].fecha);
							if((laFecha.split("-")[0]).length===4){ laFecha = laFecha.substr(8,2)+"-"+laFecha.substr(5,2)+"-"+laFecha.substr(0,4); }
							if($.trim(js[i].incidencia)===""){ laIncidencia = ""; }
							contenido += "<tr>"
									  +"	<td>"+laFecha+"</td>"
									  +"	<td>"+laHora+"</td>"
									  +"	<td>"+laIncidencia+"</td>"
									  +"	<td>"+elPedido+"</td>"
									  +"</tr>";
						}
						if(modo==="cargarLlamadas"){	
							var elBG = "";
							var estado = "PENDIENTE";
							var ultimoPedido = js[i].cli[0].ultimoPedido;
							if(ultimoPedido==="null" || ultimoPedido==null){ ultimoPedido = "";}
							if($.trim(js[i].completado)==="1"){ elBG = "style='background:#FFCFCF;'"; estado="COMPLETADO"; } 							
							contenido += "<tr "+elBG+" onclick='TV_SelecionarCliente(\""+$.trim(js[i].cliente)+"\")'>"
									  +"	<td>"+$.trim(js[i].cliente)+"</td>"
									  +"	<td>"+$.trim(js[i].cli[0].NOMBRE)+"</td>"
									  +"	<td style='text-align:center;'>"+$.trim(js[i].horario)+"</td>"
									  +"	<td data-completado='"+$.trim(js[i].completado)+"' style='text-align:center;'>"+estado+"</td>"
									  +"	<td style='text-align:right;'>"+ultimoPedido+"</td>"
									  +"	<td style='text-align:right;'>"+elPedido+"</td>"
									  +"</tr>";
						}
						if(modo==="listaGlobal"){
							var elSubTotal = parseFloat($.trim(js[i].subtotal)).toFixed(2);
							if(isNaN(elSubTotal)){ elSubTotal=""; }else{ elSubTotal += " &euro;"; }
							var elImporte = parseFloat($.trim(js[i].importe)).toFixed(2);
							if(isNaN(elImporte)){ elImporte=""; }else{ elImporte += " &euro;"; }
							contenido += "<tr onclick='tbLlamadasGlobal_Sel(\""+$.trim(js[i].id)+"\",\""+$.trim(js[i].fecha)+"\",\""+$.trim(js[i].nombreTV)+"\")'>"
									  +"	<td>"+$.trim(js[i].fecha)+"</td>"
									  +"	<td class='rolTeleVentaO'>"+$.trim(js[i].usuario)+"</td>"
									  +"	<td>"+$.trim(js[i].nombreTV)+"</td>"
									  +"	<td style='text-align:right;'>"+$.trim(js[i].clientes)+"</td>"
									  +"	<td style='text-align:right;'>"+$.trim(js[i].llamadas)+"</td>"
									  +"	<td style='text-align:right;'>"+$.trim(js[i].pedidos)+"</td>"
									  +"	<td style='text-align:right;'>"+elSubTotal+"</td>"
									  +"	<td style='text-align:right;'>"+elImporte+"</td>"
									  +"</tr>";
							elDV = "dvLlamadasTeleVenta";
						}
					}
					contenido += "</table></div>";					
				}else{ contenido = "Sin registros!"; }
			}
			$("#"+elDV).html(contenido);
			if(currentRole==="TeleVenta"){ $(".rolTeleVentaO").hide(); }
			cerrarVelo();
		}else{ alert("Error SP: pLlamadas!!!"+JSON.stringify(ret)); }
	},false);
}

function tbLlamadasGlobal_Sel(id,fecha,nombre){
	$("#inpFechaTV").val(fecha);
	$("#inpNombreTV").val(nombre);
	IdTeleVenta = id;
	FechaTeleVenta = fecha;
	NombreTeleVenta = nombre;
	cargarTbConfigOperador("cargar");
	configurarTeleVenta();
	$("#dvFechaTV").show();
}

function asignarserieconfig(){
	var serie = $.trim($("#inpLLBserieConfig").val()); 
	flexygo.nav.execProcess('pConfiguracion','',null,null,[{'Key':'modo','Value':'TVSerie'},{'Key':'valor','Value':serie}],'modal640x480', false, $(this), function(ret){if(ret){
		$("#spanAsignacionSerieAviso").fadeIn(); // SERIE = serie;
		setTimeout(function(){ $("#spanAsignacionSerieAviso").fadeOut(); },2000);
	}else{ alert("Error SP: pConfiguracion!!!\n"+JSON.stringify(ret)); }}, false);
}

function TV_SelecionarCliente(cliente){
	cargarTeleVentaCliente(cliente);
	cargarTeleVentaUltimosPedidos(cliente);
}

function inpDatos_Click(id){
	$(".dvListaDatos").stop().fadeOut();
	var elInp = id.split("LLB")[1];
	var contenido = "";
	var elInpSQL = elInp;
	var asigSerie = "";
	if(elInp==="serieConfig"){ elInpSQL="serie"; asigSerie = "asignarserieconfig();";}
	var elJS = '{"modo":"'+elInpSQL+'",'+paramStd+'}';
	$("#dvLLB"+elInp).html(icoCargando16 + " cargando...").stop().slideDown();
	flexygo.nav.execProcess('pInpDatos','',null,null,[{'Key':'elJS','Value':elJS}], 'modal640x480', false, $(this), function(ret){if(ret){
		var js = JSON.parse(limpiarCadena(ret.JSCode));		
		if(js.length>0){
			for(var i in js){ 
				var elClick = js[i].codigo+" - "+js[i].nombre;
				if(id==="inpLLBserie" || id==="inpLLBserieConfig"){ elClick = js[i].codigo; SERIE = js[i].codigo; }
				contenido += "<div class='dvLista' "
				+"onclick='$(\"#"+id+"\").val(\""+elClick+"\"); $(\"#dvLLB"+elInp+"\").stop().slideUp(); "+asigSerie+"'>"
				+js[i].codigo+" - "+js[i].nombre
				+"</div>"; 
			}
		}else{ contenido="<div style='color:red;'>Sin resultados!</div>"; }
		$("#dvLLB"+elInp).html(contenido);
	}else{ alert('Error S.P. pSeries!\n'+JSON.stringify(ret)); } }, false);
}




/*  TV_UltimosPedidos  *********************************************************************************************************** */

function cargarTeleVentaUltimosPedidos(ClienteCodigo){
	var parametros = '{"cliente":"'+ClienteCodigo+'",'+paramStd+'}';
	flexygo.nav.execProcess('pUltimosPedidos','',null,null,[{'key':'parametros','value':limpiarCadena(parametros)}],'modal640x480',false,$(this),function(ret){
		if(ret){			
			if(ret.JSCode===""){ ret.JSCode="[]"; }
			var contenido = "<table class='tbStdP'>"
						+   "<tr>"
						+   "	<th style='width:100px;'>Fecha</th>"
						+   "	<th class='C' style='width:100px;'>Pedido</th>"
						+   "	<th class='C' style='width:100px;'>Entrega</th>"
						+   "	<th class='C' style='width:100px;'>Ruta</th>"
						+   "	<th class='C' style='width:100px;'>Estado</th>"
						+   "	<th class='L'>Observaciones</th>"
						+   "	<th class='C' style='width:200px;'>Importe</th>"
						+   "	<th class='C' style='width:200px;'>Total</th>"
						+   "</tr>";
			var js = JSON.parse(limpiarCadena(ret.JSCode));
			if(js.length>0){
				for(var i in js){
					contenido += "<tr>"
							  +"	<td>"+$.trim(js[i].FECHA)+"</td>"
							  +"	<td id='tdPedidoVer_"+i+"' class='C' onmouseenter='verPedidoDetalle(\""+$.trim(js[i].IDPEDIDO)+"\",\""+$.trim(js[i].LETRA)+"-"+$.trim(js[i].numero)+"\","+i+")' "
							  +"	onmouseleave='dentroDelDiv=false; cerrarAVT();' style='cursor:pointer; color:#000;'>"+$.trim(js[i].LETRA)+"-"+$.trim(js[i].numero)+"</td>"
							  +"	<td class='C'>"+$.trim(js[i].ENTREGA)+"</td>"
							  +"	<td class='C'>"+$.trim(js[i].RUTA)+"</td>"
							  +"	<td class='C'>"+$.trim(js[i].ESTADO)+"</td>"
							  +"	<td class='L' style='overflow:hidden;'>"+$.trim(js[i].OBSERVACIO)+"</td>"
							  +"	<td class='R'>"+$.trim(js[i].TOTALPEDformato)+"</td>"
							  +"	<td class='R'>"+$.trim(js[i].TOTALDOCformato)+"</td>"
							  +"</tr>"
				}
				contenido += "</table>"
			}else{ contenido = "No se han obtenido resultados!"; }
			$("#dvUltimosPedidos").html("<div style='max-height:200px; overflow:hidden; overflow-y:auto;'>"+contenido+"</div>");
		}else{ alert("Error SP: pUltimosPedidos!\n"+JSON.stringify(ret)); }
	},false);
}

function verPedidoDetalle(idpedido,pedido,i){
	if(ArticuloClienteBuscando){return;}
	ArticuloClienteBuscando=true;
	dentroDelDiv=true;
	var contenido = icoCargando16+" cargando lineas del pedido "+pedido+"..."; 
	abrirAVT(contenido);
	contenido =  "<span style='font:bold 16px arial; color:#666;'>Datos del pedido "+pedido+"</span>"
				+"<br><br>"
				+"<div style='max-height:300px; overflow:hidden; overflow-y:auto;'>"
				+"	<table id='tbPedidosDetalle' class='tbStd'>"
				+"		<tr>"
				+"			<th>Artículo</th>"
				+"			<th>Descipción</th>"
				+"			<th class='C'>Cajas</th>"
				+"			<th class='C'>Uds.</th>"
				+"			<th class='C'>Peso</th>"
				+"			<th class='C'>Precio</th>"
				+"			<th class='C'>Dto</th>"
				+"			<th class='C'>Importe</th>"
				+"		</tr>"; 
	var parametros = '{"idpedido":"'+idpedido+'",'+paramStd+'}';
	flexygo.nav.execProcess('pPedidoDetalle','',null,null,[{'key':'parametros','value':limpiarCadena(parametros)}],'modal640x480',false,$(this),function(ret){
		if(ret){ 
			var js = JSON.parse(limpiarCadena(ret.JSCode));   
			if(js.length>0){
				for(var j in js){ 
					contenido   +="<tr>"
								+"		<td>"+js[j].ARTICULO+"</td>"
								+"		<td>"+js[j].DEFINICION+"</td>"
								+"		<td class='C'>"+js[j].cajas+"</td>"
								+"		<td class='C'>"+js[j].UNIDADES+"</td>"
								+"		<td class='C'>"+js[j].PESO+"</td>"
								+"		<td class='C'>"+js[j].PRECIO+"</td>"
								+"		<td class='C'>"+js[j].DTO1+"</td>"
								+"		<td class='R'>"+js[j].IMPORTEf+"</td>"
								+"	</tr>"; 
				}
				contenido += "</table></div>";
			}else{ contenido = "No se han obtenido resultados! <span class='flR' onclick='cerrarVelo()'>"+icoAspa+"</span>"; }
			abrirAVT(contenido,800);
			ArticuloClienteBuscando=false;
			if(!dentroDelDiv){cerrarAVT();}
		}else{ alert("Error SP: pPedidoDetalle!!!"+JSON.stringify(ret)); }
	},false);	
}



/*  TV_Pedido  **************************************************************************************************************** */

var PedidoActivo = "";
var PedidoActivoNum = "";
var PedidoModo = "crear";
var PedidoDetalle = [];
var dvIncidenciasCLI = "";
var dvIncidenciasART = "";

var Values = "";
var ContextVars = '<Row>'
	+'<Property Name="currentReference" Value="'+currentReference+'"/>'
	+'<Property Name="currentSubreference" Value="'+currentSubreference+'"/>'
	+'<Property Name="currentRole" Value="'+currentRole+'"/>'
	+'<Property Name="currentRoleId" Value="'+currentRoleId+'"/>'
	+'<Property Name="currentUserLogin" Value="'+currentUserLogin+'"/>'
	+'<Property Name="currentUserId" Value="'+currentUserId+'"/>'
	+'<Property Name="currentUserFullName" Value="'+currentUserFullName+'"/>'
	+'</Row>';	
var	RetValues = '<Property Success="False" SuccessMessage="" WarningMessage="" JSCode="" JSFile="" CloseParamWindow="False" refresh="False"/>';

cargarIncidencias("art");
cargarIncidencias("cli");

function llamarMasTardeCliente(horaSel){
	abrirIcoCarga();
	var parametros = '{"modo":"llamarMasTardeCliente","IdTeleVenta":"'+IdTeleVenta+'","cliente":"'+ClienteCodigo+'","horario":"'+horaSel+'"}'; 
	flexygo.nav.execProcess('pLlamadas','',null,null,[{'Key':'parametros','Value':limpiarCadena(parametros)}],'modal640x480',false,$(this),function(ret){
		if(ret){ pedidoTV(); recargarTVLlamadas(); }
		else{ alert("Error pLlamadas llamarMasTardeCliente!\n"+JSON.stringify(ret)); }
		cerrarVelo();
	},false);
}

function cargarArticulosDisponibles(modo){console.log("cargarArticulosDisponibles("+modo+")");
	tfArticuloSeleccionado = "";
	$("#spanBotoneraPag , #spResultados, #dvPersEP_Articulos").hide();
	$("#spanPersEPinfo").fadeIn(300,function(){
		var varios = "paginar";
		var celdaValor = "";
		var esconder_spResBtn=false; 
		var registrosTotales = 0;
		var elSP = "pArticulosBuscar";	
		var parametros = '{"registros":'+paginadorRegistros+',"buscar":"'+$.trim($("#inpBuscarArticuloDisponible").val())+'","cliente":"'+ClienteCodigo+'","IdTeleVenta":"'+IdTeleVenta+'","fechaTV":"'+FechaTeleVenta+'","nombreTV":"'+NombreTeleVenta+'",'+paramStd+'}';
		if(modo){ elSP = "pArticulosCliente"; }
		console.log(elSP + " - parametros:\n"+parametros);
		flexygo.nav.execProcess(elSP,'',null,null,[{"Key":"parametros","Value":limpiarCadena(parametros)}],'modal640x480',false,$(this),function(ret){
			if(ret){
				var respuesta = limpiarCadena(ret.JSCode); if(respuesta===""){ respuesta = "[]";} 
				var contenido="";
				var art = JSON.parse(respuesta);
				var elColSpan = 10; if(ConfMostrarStockVirtual===0){ elColSpan = 9; }
				if(art.length>0){
					registrosTotales = art[0].registros;
					var contenidoCab = "";
					if(modo){ 
						contenidoCab +="<tr>"
									 + "	<th colspan='2'></th>"
									 + "	<th colspan='3' style='text-align:center; background:rgb(73, 133, 214);'>Última Venta</th>"
									 + "	<th colspan='"+elColSpan+"'></th>";
					}
					contenidoCab +="<tr>"
									 + "	<th id='thCodigo' style='width:10%;'>Código</th>"
									 + "	<th>Descripción</th>";
					if(modo){ 
							contenidoCab += "<th style='width:5%; text-align:center; background:rgb(73, 133, 214);'>Cajas</th>"
									     +  "<th style='width:5%; text-align:center; background:rgb(73, 133, 214);'>Uds.</th>"
									     +  "<th style='width:5%; text-align:center; background:rgb(73, 133, 214);'>Peso</th>";
					}	
					contenidoCab += "	<th class='PedidoMaximo inv' style='width:5%; text-align:center;'>Pedido Máximo</th>"
								 +  "	<th style='width:5%; text-align:center;'>Cajas</th>"
								 +  "	<th style='width:5%; text-align:center;'>Uds.</th>"
								 +  "	<th style='width:5%; text-align:center;'>Peso</th>"
								 +  "	<th style='width:5%; text-align:center;'>Tarifa mín.</th>"
								 +  "	<th style='width:5%; text-align:center; cursor:pointer; color:#99ffa5;' onclick='mostrarTarifaArticulo()'>Precio</th>"
								 +  "	<th style='width:5%; text-align:center;'>Dto.</th>"
								 +  "	<th style='width:5%; text-align:center;'>Importe</th>"
								 +  "	<th style='width:5%; text-align:center;' class='inpStockVirtual'>Stock</th>"
								 +  "	<th style='width:40px; text-align:center; box-sizing:border-box;'></th>"
								 +  "	<th style='width:40px; text-align:center; box-sizing:border-box;'></th>"
								 +  "</tr>";
					$("#tbPersEP_ArticulosCab").html(contenidoCab);
					
					var valorPeso = "";
					
					for(var i in art){	
						var CajasIO = "";
						var UdsIO = "";
						var PesoIO = "";
						var elPedUniCaja ="0"; 
						var elPeso = $.trim(art[i].PesoArticulo); if(elPeso==="" || elPeso===null){ elPeso="0"; }	
						var elPedUniCajaValor = elPedUniCaja; if(elPedUniCajaValor==="0"){ elPedUniCajaValor=""; }
						var elPesoValor = elPeso; if(elPesoValor==="0"){ elPesoValor=""; }
						var eOnClick = "";						
						var	stockVirtual = parseInt(art[i].StockVirtual); 
						
						if(modo){ 
							stockVirtual = parseInt(art[i].StockVirtual); if(isNaN(stockVirtual)){stockVirtual="";}							
							elPedUniCaja = $.trim(art[i].UNICAJA); 
							if(elPedUniCaja==="" || elPedUniCaja===null){ elPedUniCaja="0"; }	
							if(parseFloat(elPedUniCaja)>0){ }else{ CajasIO="readonly disabled"; }
							if(parseFloat(art[i].PESO)>0){ }else{ PesoIO="readonly disabled"; }	
							eOnClick="onmouseenter='articuloCliente(\"tbArtDispTR"+i+"\",\""+art[i].CODIGO+"\")' onmouseleave='dentroDelDiv=false;cerrarAVT();'";
						}else{
							elPedUniCaja = $.trim(art[i].UNICAJA); 
							if(parseFloat(elPedUniCaja)>0){ }else{ CajasIO="readonly disabled"; }
							elPeso = $.trim(art[i].peso); if(elPeso==="" || elPeso===null){ elPeso="0"; }	
							if(parseFloat(elPeso)>0){ }else{ PesoIO="readonly disabled"; }	
							valorPeso= " value='"+parseFloat(elPeso).toFixed(3)+"' "; 
						}						
						
						contenido 	+= "<tr id='tbArtDispTR"+i+"' class='trBsc' data-json='{\"articulo\":\""+art[i].CODIGO+"\"}'"
									+  "data-art='"+art[i].CODIGO+"' data-nom='"+art[i].NOMBRE+"'>"
									+"	<td class='trBscCod' style='width:10%;' "+eOnClick+" >"+art[i].CODIGO+"</td>"
									+"	<td class='trBscNom'>"+art[i].NOMBRE+"</td>";
						if(modo){ 
							contenido += "<td class='C' style='width:5%;'>"+ art[i].CAJAS +"</td>"
									  +  "<td class='C' style='width:5%;'>"+ art[i].UDS +"</td>"
									  +  "<td class='C' style='width:5%;'>"+ art[i].PESO +"</td>";
						}						
						contenido += " 	<td class='C trBscCajas inv' style='width:10%;'>"+elPedUniCaja+"</td>"
									+"	<td class='C' style='width:5%;'>"
									+"		<input type='text' id='inp_cajas_"+i+"' class='inpCajasSol' "
									+"		onkeyup='$(this).css(\"color\",\"#000\"); calcCUP(\"cajas\",\"tbArtDispTR"+i+"\","+elPedUniCaja+","+elPeso+",false);' "
									+"		onfocus='celdaValor=this.value' "
									+"		onfocusout='if(celdaValor!==this.value){calcCUP(\"cajas\",\"tbArtDispTR"+i+"\","+elPedUniCaja+","+elPeso+",true);}' "
									+"		onclick='$(this).select(); cargarPrecio("+i+",this.id); event.stopPropagation();' "+CajasIO+">"
									+"	</td>"
									+"	<td class='C' style='width:5%;'>"
									+"		<input type='text' id='inp_uds_"+i+"' class='inpCantSol' "
									+"		onkeyup='$(this).css(\"color\",\"#000\"); calcCUP(\"uds\",\"tbArtDispTR"+i+"\","+elPedUniCaja+","+elPeso+",false);' "
									+"		onfocus='celdaValor=this.value' "
									+"		onfocusout='if(celdaValor!==this.value){calcCUP(\"uds\",\"tbArtDispTR"+i+"\","+elPedUniCaja+","+elPeso+",true);}' "
									+"		onclick='$(this).select(); cargarPrecio("+i+",this.id); event.stopPropagation();' "+UdsIO+">"
									+"	</td>"
									+"	<td class='C' style='width:5%;'>"
									+"		<input type='text' id='inp_peso_"+i+"' class='inpPesoSol C' "+valorPeso+" "
									+"		onkeyup='$(this).css(\"color\",\"#000\"); calcCUP(\"peso\",\"tbArtDispTR"+i+"\","+elPedUniCaja+","+elPeso+",false);' "
									+"		onfocus='celdaValor=this.value' "
									+"		onfocusout='if(celdaValor!==this.value){calcCUP(\"peso\",\"tbArtDispTR"+i+"\","+elPedUniCaja+","+elPeso+",true);}' "
									+"		onclick='$(this).select(); cargarPrecio("+i+",this.id); event.stopPropagation();' "+PesoIO+">"
									+"	</td>";
						if(modo){ contenido +="<td id='tarifaTD"+i+"' class='C' style='width:5%;'></td>"; }
						else{ contenido +="<td id='tarifaTD"+i+"' class='C' style='width:5%;'>"+(art[i].pvp).toFixed(2)+"</td>"; }
						contenido += "	<td id='precioTD"+i+"' class='C' style='width:5%;'>"
							//		+"		<span class='flx-icon icon-sincronize-1 rotarR' style='font-size:12px; color:green;'></span>"
									+"  </td>"
									+"	<td id='DtoTD"+i+"' class='C' style='width:5%;'>"
							//		+"		<span class='flx-icon icon-sincronize-1 rotarR' style='font-size:12px; color:orange;'></span>"
									+"  </td>"
									+"	<td class='inpImporteSol R' style='width:5%;'></td>"
									+"	<td class='inpStockVirtual R' style='width:5%;'>"+stockVirtual+"</td>"
									+"	<td id='inpIncidenciaSol"+i+"' class='C' style='width:40px; box-sizing:border-box;' "
									+"	style='table-layout:fixed;' "
									+"	onclick='cargarSubDatos(\"inciArt\",\""+ClienteCodigo+"\",this.id,-1);event.stopPropagation();'>"
									+"		<img id='inpIncidenciaSolImg"+i+"' src='./Merlos/images/inciGris.png' width='14'>"
									+"		<input type='text' id='inpIncidenciaSolINP"+i+"' class=' trInciArt inv'>"
									+"	</td>"
									+"	<td id='inpObservaSol"+i+"' class='C' style='width:40px;  box-sizing:border-box;' "
									+"	onclick='incidencia(\"obs\",this.id);event.stopPropagation();'>"
									+"		<img id='inpObservaSolImg"+i+"' src='./Merlos/images/ojoGris.png' width='14'>"
									+"		<textarea id='inpObservaSolTA"+i+"' class='trObservaArt inv'></textarea>"
									+"	</td>"
									+"</tr>";
					}					
					$("#tbPersEP_Articulos").html(contenido);
					if(ConfMostrarStockVirtual===0){ $(".inpStockVirtual").hide(); }
					
					//setTimeout(function(){obtenerPreciosYOfertas(modo);},1000);
					
					if(flexygo.context.ConfigArtMaxPedido==="1"){ $(".PedidoMaximo").removeClass("inv").addClass("vis"); }					
					var pagRD = paginadorRegistros+1;
					var pagRH = paginadorRegistros+100;
					if(pagRH>registrosTotales){ pagRH=registrosTotales; esconder_spResBtn=true; }
					$("#spResultadosT").text("Mostrando registros del "+pagRD+" al "+ pagRH +" de "+registrosTotales+" encontrados."); 
					$("#spanBotoneraPag, #spResultados, #dvPersEP_Articulos, #spBtnAnyCont, #tbPersEP_ArticulosCab").stop().fadeIn(); 
					if(modo){ $("#spResultados").hide(); }
					if(esconder_spResBtn){$("#spResBtn").hide(); paginadorRegistros=0; }
					if(modo){ 
						$("#thCodigo").css("background","#4985D6"); 
						$(".trBscCod").css("color","#4985D6"); 
					}
					$("#inpBuscarArticuloDisponible").val("");
				}else{ 
					$("#tbPersEP_Articulos").html("No se han obtenido resultados!"); 					
					$("#spBtnAnyCont , #spResultados , #tbPersEP_ArticulosCab").stop().hide();
					$("#spanBotoneraPag, #dvPersEP_Articulos").stop().fadeIn(); 
					paginadorRegistros=0;
				}
				$("#spanPersEPinfo").hide();
			}else{ alert("Error pArticulosBuscar!\n"+JSON.stringify(ret)); }
		 },false);
	});
}

function cargarPrecio(i,inp){
	if($.trim($("#precioTD"+i).html())!==""){return;}
	var contenidoTR = $("#tbArtDispTR"+i).html();
	$("#tbArtDispTR"+i).html("<td colspan='15' style='padding:10px; text-align:center; background:#DEFFDA;'>"+icoCargando16+" cargando precios y ofertas...</td>");
	var elArticulo = $("#tbArtDispTR"+i).attr("data-art");
	var parametros = '{'
		+'"modo":"verArticuloPrecio"'
		+',"empresa":"'+flexygo.context.CodigoEmpresa+'"'
		+',"cliente":"'+ClienteCodigo+'"'
		+',"articulo":"'+elArticulo+'"'
		+',"unidades":"1"'
		+',"FechaTeleVenta":"'+FechaTeleVenta+'"'
		+',' + paramStd
	+'}';
	flexygo.nav.execProcess('pPreciosTabla','',null,null,[{'Key':'parametros','Value':limpiarCadena(parametros)}],'modal640x480',false,$(this),function(ret){
	if(ret){
		try{										
			var js = JSON.parse(limpiarCadena(ret.JSCode));
			var PT = js[0].precioTarifa; if(isNaN(PT) || PT===""){ PT=0.00; }
			var PC = js[0].precio; if(isNaN(PC) || PC===""){ PC=0; }
			var DT = js[0].dto;    if(isNaN(DT) || DT===""){ DT=0; }
			$("#tbArtDispTR"+i).html(contenidoTR);
			$("#tarifaTD"+i).html(parseFloat(PT).toFixed(2));
			$("#precioTD"+i).html(
				"<input type='text' class='inpPrecioSol' onkeyup='$(this).css(\"color\",\"#000\"); calcularImporte(\"tbArtDispTR"+i+"\")' "
				+"onclick='$(this).select(); tfArtSel("+i+")' "
				+"value='"+parseFloat(PC).toFixed(2)+"'>"
			);
			$("#DtoTD"+i).html(
				"<input type='text' class='inpDtoSol' onkeyup='$(this).css(\"color\",\"#000\");  calcularImporte(\"tbArtDispTR"+i+"\")' "
				+"onclick='$(this).select();' "
				+"value='"+parseFloat(DT).toFixed(2)+"'>"
			);
			$("#"+inp).focus();
		}catch{ alert("Error JSON pPreciosTabla - verArticuloPrecio!\n"+JSON.stringify(ret)); }									
	}else{ alert("Error RET - pPreciosTabla - verArticuloPrecio!\n"+JSON.stringify(ret)); }
 },false);
}

function tfArtSel(i){ tfArticuloSeleccionadoI=i; tfArticuloSeleccionado=$("#tbArtDispTR"+i).attr("data-art"); }

function mostrarTarifaArticulo(){
	if(tfArticuloSeleccionado===""){ return; }
	abrirVelo(icoCargando16+" buscando el artículo "+tfArticuloSeleccionado+" en las distintas tarifas...");
	var parametros = '{"modo":"verArticuloTarifas","articulo":"'+tfArticuloSeleccionado+'"}';
	flexygo.nav.execProcess('pPreciosTabla','',null,null,[{'Key':'parametros','Value':limpiarCadena(parametros)}],'modal640x480',false,$(this),function(ret){
		if(ret){ 
			var contenido = "<span style='font:bold 14px arial; color:#68CDF9;'>Artículo: "+tfArticuloSeleccionado+" - Tarifas</span>"
						  + "<span style='float:right;' onclick='cerrarVelo();'>"+icoAspa+"</span>"
						  + "<br><br>"
						  + "<table id='tbArticulosTarifas' class='tbStd'>"
						  + "	<tr>"
						  +  "		<th>Tarifa</th>"
						  +  "		<th>PVP</th>"
						  +  "	</tr>";
			var js = JSON.parse(limpiarCadena(ret.JSCode));
			if(js.length>0){ 
				for(var i in js){
					var elPVP = parseFloat(js[i].pvp).toFixed(2); if(isNaN(elPVP)){ elPVP = "0.00"; }
					contenido += "<tr onclick='establecerPvpTarifa("+js[i].pvp+")'>"
							  +  "	<td>"+js[i].tarifa+"</td>"
							  +  "	<td>"+elPVP+"</td>"
							  +  "</tr>";
				}
				contenido += "</table>";
			}else{ contenido = "No se han obtenido registros!<br><br><br><span class='MIboton esq05' onclick='cerrarVelo();'>aceptar</span>"; }
			abrirVelo(contenido);
		}
		else{ alert("Error pPreciosTabla - verArticuloTarifas!\n"+JSON.stringify(ret)); }
	 },false);
}

function establecerPvpTarifa(pvp){ $("#tbArtDispTR"+tfArticuloSeleccionadoI).find(".inpPrecioSol").val(parseFloat(pvp).toFixed(2)); cerrarVelo(); }

function articuloCliente(trid,articulo){
	if(ArticuloClienteBuscando){ return; }
	ArticuloClienteBuscando = true;
	dentroDelDiv=true;
	abrirAVT(icoCargando16+" buscando el artículo "+articulo+" en los albaranes...");
	var contenido = "<span style='font:bold 14px arial; color:#68CDF9;'>Artículo: "+articulo+"</span>"
				    +"<br><br>"
				    +"<table class='tbStd'>"
					+"	<tr>"
					+"		<th class='C'>Fecha</th>"
					+"		<th class='C'>Cajas</th>"
					+"		<th class='C'>Uds.</th>"
					+"		<th class='C'>Peso</th>"
					+"		<th class='C'>Precio</th>"
					+"		<th class='C'>Dto</th>"
					+"		<th class='C'>Importe</th>"
					+"	</tr>";  
	var parametros = '{"modo":"UltimasVentasArticulo","registros":'+paginadorRegistros+',"buscar":"'+$.trim($("#inpBuscarArticuloDisponible").val())+'","articulo":"'+articulo+'","cliente":"'+ClienteCodigo+'","IdTeleVenta":"'+IdTeleVenta+'","fechaTV":"'+FechaTeleVenta+'","nombreTV":"'+NombreTeleVenta+'",'+paramStd+'}';
	flexygo.nav.execProcess('pArticulosCliente','',null,null,[{'Key':'parametros','Value':limpiarCadena(parametros)}],'modal640x480',false,$(this),function(ret){
		if(ret){ 
			var js = JSON.parse(limpiarCadena(ret.JSCode)); 
			if(js.length>0){ 
				for(var i in js){
					contenido  += "	<tr>"
								+"		<td class='C'>"+js[i].FECHA+"</td>"
								+"		<td class='C'>"+js[i].CAJAS+"</td>"
								+"		<td class='C'>"+js[i].UDS+"</td>"
								+"		<td class='C'>"+js[i].PESO+"</td>"
								+"		<td class='C'>"+js[i].PRECIO+"</td>"
								+"		<td class='C'>"+js[i].DTO1+"</td>"
								+"		<td class='C'>"+js[i].IMPORTE+"</td>"
								+"	</tr>"; 
				}
				contenido += "</table>";
			}else{ contenido = "No se han obtenido registros!<br><br><br><span class='MIboton esq05' onclick='cerrarAVT();'>aceptar</span>"; }
			abrirAVT(contenido,800);
			ArticuloClienteBuscando=false;
			if(!dentroDelDiv){cerrarAVT();}
		}
		else{ alert("Error pArticulosCliente - UltimasVentasArticulo!\n"+JSON.stringify(ret)); ArticuloClienteBuscando=false; }
	 },false);
}

function calcCUP(modo,i,unicaja,unipeso,uniprecio,elENTER){ 
	var elTR = "#"+i;
	var cajas = $(elTR).find(".inpCajasSol").val();		if(isNaN(cajas)){ cajas=0; }
	var uds = $(elTR).find(".inpCantSol").val();		if(isNaN(uds)){ uds=0; }
	var peso = $(elTR).find(".inpPesoSol").val();		if(isNaN(peso)){ peso=0; }
	var codigo = $(elTR).find(".inpCodigoSol").val();	
	var linia = $(elTR).find(".inpLiniaSol").val();	
	
	if(modo==="cajas"){ 
		uds=cajas*unicaja; if(isNaN(uds)){ uds=0; } $(elTR).find(".inpCantSol").val(uds); 
		if(parseFloat(unipeso)>0) { peso=uds*unipeso; if(isNaN(peso)){ peso=0; } $(elTR).find(".inpPesoSol").val(peso.toFixed(3)); }
	}
	if(modo==="uds"){ 
		if(parseFloat(unicaja)>0) { cajas=uds/unicaja; if(isNaN(cajas)){ cajas=0; } $(elTR).find(".inpCajasSol").val(Math.floor(cajas)); }
		if(parseFloat(unipeso)>0) { peso=uds*unipeso; if(isNaN(peso)){ peso=0; } $(elTR).find(".inpPesoSol").val(peso.toFixed(3)); }
	}
	
	calcularImporte(i);
}

function calcularImporte(i){
	var elTR = "#"+i;
	var uds = $(elTR).find(".inpCantSol").val();		if(isNaN(uds)){ uds=0; }
	var peso = $(elTR).find(".inpPesoSol").val();		if(isNaN(peso)){ peso=0; }
	var dto = $(elTR).find(".inpDtoSol").val();			if(isNaN(dto)){ dto=0; }
	var precio = $(elTR).find(".inpPrecioSol").val();	if(isNaN(precio)){ precio=0; }
	var importe = parseFloat(precio) * parseFloat(uds);
	if(parseFloat(peso)>0 && parseInt(EWtrabajaPeso)===1){ importe =  parseFloat(precio) * parseFloat(peso); }
	if(parseFloat(dto)>0){ importe = importe - ((importe*dto)/100); }
	if(isNaN(importe)){ importe=0; } 
	$(elTR).find(".inpImporteSol").html(importe.toFixed(2)+"&euro;");
}

function buscarArticuloDisponible(){
	if(ClienteCodigo===""){ alert("No hay un cliente seleccionado!"); return; }
	if(event.keyCode===13){
		var buscarArticulo = $.trim($("#inpBuscarArticuloDisponible").val());
		if(buscarArticulo===""){ return; }
		paginadorRegistros=0;
		cargarArticulosDisponibles(false);
		return; 
	}
	var buscar = $.trim($("#inpBuscarArticuloDisponible").val()).toUpperCase();
	if(buscar===""){ $(".trBsc").removeClass("inv"); return; }
	$("#tbPersEP_Articulos").find(".trBsc").each(function(){ 
		 var cod = $(this).find(".trBscCod").text().toUpperCase();
		 var nom = $(this).find(".trBscNom").text().toUpperCase();
		 if(cod.indexOf(buscar)>=0 || nom.indexOf(buscar)>=0 ){ $(this).removeClass("inv"); }else{ $(this).addClass("inv"); }
	});
	repintarZebra("tbPersEP_Articulos","#fff");
}

function buscarArtDispCli(){ cargarArticulosDisponibles(ClienteCodigo); }

function pedidoAnyadirDetalle(){
	$("#tbPersEP_Articulos").find(".trBsc").each(function(){ 
		 var cod = $(this).find(".trBscCod").text();
		 var cjs = parseFloat($(this).find(".inpCajasSol").val());
		 var can = parseFloat($(this).find(".inpCantSol").val()); 		 
		 var cajas = parseFloat($(this).find(".trBscCajas").text()); 
		 var StockVirtual = parseFloat($(this).find(".tdBscStockVirtual").text()); 
		 var maxPed = parseFloat($(this).find(".tdBscMaxPed").text());		
		 var peso = parseFloat($(this).find(".inpPesoSol").val());					if(isNaN(peso)){ peso=0; }	
		 var precio = parseFloat($(this).find(".inpPrecioSol").val());				if(isNaN(precio)){ precio=0; }	
		 var dto = parseFloat($(this).find(".inpDtoSol").val());					if(isNaN(dto)){ dto=0; }	
		 var importe = parseFloat($(this).find(".inpImporteSol").text());			if(isNaN(importe)){ importe=0; }	
		 var CosteResiduo = parseFloat($(this).find(".inpCosteResiduo").text());	if(isNaN(CosteResiduo)){ CosteResiduo=0; }	
		 var incidencia = ($(this).find(".trInciArt").val()).split(" - ")[0];
		 var incidenciaDescrip = ($(this).find(".trInciArt").val()).split(" - ")[1];
		 var observacion = $(this).find(".trObservaArt").val();

		if(parseFloat(cjs)>0 || parseFloat(can)>0){	
			// comprobar Coste Residuo
			(function(){
				var parametros = '{"modo":"residuo","articulo":"'+cod+'"}';
				flexygo.nav.execProcess('pArticulos','',null,null,[{'Key':'parametros','Value':limpiarCadena(parametros)}],'current',false,$(this),function(ret){if(ret){
					var residuo = JSON.parse(ret.JSCode);
					var pImporte = parseFloat(residuo[0].P_IMPORTE);
					if(residuo[0].PVERDE && parseInt(residuo[0].P_TAN)===2){
						if(parseFloat(peso)>0){ CosteResiduo = parseFloat(pImporte) * parseFloat(peso); }
						else{ CosteResiduo = parseFloat(pImporte) * parseFloat(can); }
					}
					
					PedidoDetalle.push('{"codigo":"'+cod+'","unidades":"'+can+'","peso":"'+peso+'","precio":"'+precio+'","dto":"'+dto+'"'
					+',"importe":"'+importe+'","CosteResiduo":"'+CosteResiduo+'","CosteResiduoArt":"'+cod+'","artUnicaja":"'+cajas+'"'
					+',"incidencia":"'+incidencia+'","incidenciaDescrip":"'+incidenciaDescrip+'","observacion":"'+observacion+'"}');
					
					// comprobar Impuesto Bebidas Azucaradas
					var param = '{"modo":"bebidasAzucaradas","articulo":"'+cod+'"}';
					(function(){
						flexygo.nav.execProcess('pArticulos','',null,null,[{'key':'parametros','value':limpiarCadena(param)}],'current',false,$(this),function(r){if(r){
							var esc = JSON.parse(r.JSCode);
							if(esc.length>0){
								for(var x=0; x<esc.length; x++){
									var escComponente = esc[x].COMPONENTE;
									if(escComponente===null){continue;}
									var escUds = parseFloat(can) * parseFloat(esc[x].UNIDADES);
									var escPrecio = parseFloat(esc[x].PVP)
									var escImporte = escUds * escPrecio;
									var pImporte = parseFloat(esc[x].P_IMPORTE)
									
									PedidoDetalle.push('{"codigo":"'+escComponente+'","unidades":"'+escUds+'","peso":"'+peso+'"'
									+',"precio":"'+escPrecio+'","dto":"'+dto+'","importe":"'+escImporte+'"'
									+',"CosteResiduo":"'+CosteResiduo+'","CosteResiduoArt":"'+cod+'","artUnicaja":"'+cajas+'","incidencia":"'+incidencia+'"'
									+',"incidenciaDescrip":"'+incidenciaDescrip+'","observacion":"'+observacion+'"}');	
								}
								pedidoVerDetalle();
							}							
						}else{ alert("Error! - pArticulos - impuestos: "+JSON.stringify(r)); } },false);
					})();
										
					if(PedidoDetalle.length<1){ alert("No se han seleccionado cantidades del listado!"); }
					else{ pedidoVerDetalle(); }
					$(".inpCajasSol,.inpCantSol,.inpPesoSol,.inpP").val("");
					$(".inpImporteSol").html("");
				} else { alert('Error SP pArticulos - residuos!'+JSON.stringify(ret)); }}, false);
			})();
		}		
	});		
}

function ultimoArticulo_Click(art){/* $("#inpBuscarArticuloDisponible").val(art); buscarArticuloDisponible(window.event.keyCode=13);*/ }

function pedidoVerDetalle(){
	if(PedidoDetalle.length>0){
		var CosteResiduoArticulos = [];
		var elTotal = 0.00;
		var contenido =  "<br><table id='tbPedidoDetalle' class='tbStd'>"
					  +  "	<tr>"
					  +  "	<th colspan='8' style='vertical-align:middle; background:#CCC;'>Líneas del Pedido</th>"
					  +  "	</tr>"
					  +  "	<tr>"
					  +  "		<th style='width:50px;'></th>"
					  +  "		<th>código</th>"
					  +  "		<th class='taC' style='width:80px;'>unidades</th>"
					  +  "		<th class='taC' style='width:80px;'>peso</th>"
					  +  "		<th class='taC' style='width:80px;'>precio</th>"
					  +  "		<th class='taC' style='width:80px;'>dto</th>"
					  +  "		<th class='taC' style='width:80px;'>C.Residuo</th>"
					  +  "		<th class='taC' style='width:100px;'>importe</th>"
					  +  "	</tr>";
		var js = JSON.parse("["+PedidoDetalle+"]");
		for(var i in js){
			var importe = parseInt(js[i].unidades) * parseFloat(js[i].precio);
			if(parseFloat(js[i].peso)>0){ importe = parseFloat(js[i].peso) * parseFloat(js[i].precio) }
			var dto = (importe * parseFloat(js[i].dto) )/100;
			importe = importe - dto;			
			var CosteResiduo = parseFloat(js[i].CosteResiduo);
			if(isNaN(CosteResiduo)){CosteResiduo=0;}
			elTotal += importe + CosteResiduo;

			var peso = parseFloat(js[i].peso).toFixed(2);
			var precio = parseFloat(js[i].precio).toFixed(2);
			var dto1 = parseFloat(js[i].dto).toFixed(2);
			
			var lasUds = js[i].unidades;
			if(isNaN(lasUds)){ lasUds = ""; }
			
			contenido += "	<tr>"
					  +  "		<td class='taC'>"
					  +  "			<img src='./Merlos/images/cerrarRed.png' class='curP' width='20' "
					  +  "			onclick='PedidoEliminarLinea(\""+js[i].codigo+"\")'>"
					  +  "		</td>"
					  +  "		<td>"+js[i].codigo+"</td>"
					  +  "		<td class='taR'>"+lasUds+"</td>"
					  +  "		<td class='taR'>"+peso+"</td>"
					  +  "		<td class='taR'>"+precio+" &euro;</td>"
					  +  "		<td class='taR'>"+dto1+"</td>"
					  +  "		<td class='taR' id='CosteResiduo_"+js[i].codigo+"'>"+parseFloat(CosteResiduo).toFixed(3)+"</td>"
					  +  "		<td class='taR'>"+importe.toFixed(2)+" &euro;</td>"
					  +  "	</tr>";
		}
		contenido 	  += "<tr><th colspan='2'></th><th colspan='5'>TOTAL PEDIDO</th><th class='taR'>"+elTotal.toFixed(2)+"</th></tr></table>"
		$("#dvPedidoDetalle").html(contenido);
	}else{$("#dvPedidoDetalle").html("<div style='padding:10px; color:red;'>Sin Lineas para el pedido!</div>");}
}

function PedidoEliminarLinea(cd){
	var js = JSON.parse("["+PedidoDetalle+"]");
	var nuevoP = [];
	for(var i in js){
		if(js[i].codigo!==cd){ nuevoP.push('{"codigo":"'+js[i].codigo+'","unidades":"'+js[i].unidades+'","peso":"'+js[i].peso+'","precio":"'+js[i].precio+'","dto":"'+js[i].dto+'","importe":"'+js[i].importe+'"}'); }
	}
	PedidoDetalle = nuevoP;
	pedidoVerDetalle();
}


var terminandoLlamada=false;
function terminarLlamada(){
	if(terminandoLlamada){ return; }
	terminandoLlamada=true;
	if(ClienteCodigo===""){ alert("No hay un cliente activo!"); terminandoLlamada=false; return; }
	var contacto = ($.trim($("#inpDataContacto").val())).split(" - ")[0];
	if(PedidoDetalle.length>0 && PedidoGenerado===""){ 
		var fff = $.trim($("#inpFechaEntrega").val());
		if(fff!==""){
			if(!existeFecha(fff)){ alert("Ups! Parece que la fecha no es correcta!"); terminandoLlamada=false; return; }
			if(!validarFechaMayorActual(fff)){ alert("La fecha debe ser posterior a hoy!"); terminandoLlamada=false; return; }
		}
		abrirVelo(icoCargando16 + " generando el pedido..."); 
		var lasLineas = (JSON.stringify(PedidoDetalle)).replace(/{/g,"_openLL_").replace(/}/g,"_closeLL_");
		var Values = '<Row rowId="elRowDelObjetoPedido" ObjectName="Pedido">'
					+	'<Property Name="MODO" Value="Pedido"/>'
					+	'<Property Name="IdTeleVenta" Value="'+IdTeleVenta+'"/>'
					+	'<Property Name="FechaTV" Value="'+FechaTeleVenta+'"/>'
					+	'<Property Name="NombreTV" Value="'+NombreTeleVenta+'"/>'
					+	'<Property Name="IDPEDIDO" Value="'+PedidoActivo+'"/>'
					+	'<Property Name="EMPRESA" Value="'+flexygo.context.CodigoEmpresa+'"/>'
					+	'<Property Name="CLIENTE" Value="'+ClienteCodigo+'"/>'
					+	'<Property Name="ENV_CLI" Value="'+$("#inpDirEntrega").val()+'"/>'
					+	'<Property Name="SERIE" Value="'+$("#dvSerieTV").text()+'"/>'
					+	'<Property Name="CONTACTO" Value="'+contacto+'"/>'
					+	'<Property Name="INCICLI" Value="'+$.trim(($("#inciCliente").val()).split(" - ")[0])+'"/>'
					+	'<Property Name="INCICLIDescrip" Value="'+$.trim(($("#inciCliente").val()).split(" - ")[1])+'"/>'
					+	'<Property Name="ENTREGA" Value="'+$.trim($("#inpFechaEntrega").val())+'"/>'
					+	'<Property Name="VENDEDOR" Value="'+elVendedor+'"/>'
					+	"<Property Name='LINEAS' Value='"+lasLineas+"'/>"
					+	"<Property Name='NoCobrarPortes' Value='"+PedidoNoCobrarPortes+"'/>"
					+	"<Property Name='VerificarPedido' Value='"+VerificarPedido+"'/>"
					+	"<Property Name='OBSERVACIO' Value='"+$.trim($("#taObservacionesDelPedido").val())+"'/>"
					+'</Row>';
		flexygo.nav.execProcess('pPedido_Nuevo','Pedido',null,null
		,[{key:'Values',value:Values}, {key:'ContextVars',value:ContextVars},{key:'RetValues',value:RetValues}],'modal640x480',false,$(this),function(ret){
			if(ret && !ret.JSCode.includes("'Error pedidoNuevo !!!")){
				var js = JSON.parse(limpiarCadena(ret.JSCode));
				cargarTeleVentaUltimosPedidos(ClienteCodigo);
				$("#inpBuscarArticuloDisponible").val("");
				$("#tbPersEP_ArticulosCab, #dvPedidoDetalle").html("");
				$("#dvPersEP_Articulos, #spResultados").slideUp();
				PedidoGenerado = js.Codigo;
				terminarLlamadaDef(PedidoGenerado,true);
			}else{ alert("Error pPedido_Nuevo!\n"+JSON.stringify(ret)); }
		 },false);
	}else{ terminarLlamadaDef(); }
}
function terminarLlamadaDef(pedido,confirmacion){
	var incidenciaCliente = $.trim($("#inciCliente").val()).split(" - ")[0];
	var incidenciaClienteDescrip = $.trim($("#inciCliente").val()).split(" - ")[1];
	var observaciones = $.trim($("#taObservacionesDelPedido").val());
	var elTXT;
	if((incidenciaCliente==="" && observaciones==="") && !confirmacion){
		if(incidenciaCliente==="" && observaciones===""){ elTXT = "No se han indicado observaciones del pedido<br>ni incidencias del cliente!";	}
		if(incidenciaCliente==="" && observaciones!==""){ elTXT = "No se ha indicado incidencia del cliente!";	}
		if(incidenciaCliente!=="" && observaciones===""){ elTXT = "No se han indicado observaciones del cliente!";	}
		abrirVelo(
			  elTXT
			+ "<br><br><br>"
			+ "<span class='MIbotonGreen' onclick='terminarLlamadaDef(\""+pedido+"\",true)'>Terminar la llamada</span>"
			+ "&nbsp;&nbsp;&nbsp;<span class='MIbotonRed' onclick='cerrarVelo()'>cancelar</span>"
		);
		terminandoLlamada=false; return;
	}
	var incidenciasSinPedido = "";
	if(PedidoGenerado==="" && PedidoDetalle.length===0){
		var articulo = "";
		var inciArt  = "";
		var obsArt   = "";
		var elID     =  0;
		$("#tbPersEP_Articulos").find("tr").each(function(){
			articulo = $(this).attr("data-art");
			inciArt  = $.trim($("#inpIncidenciaSolINP"+elID).val());	if(inciArt==undefined){ inciArt=""; }
			obsArt   = $.trim($("#inpObservaSolTA"+elID).val());		if(obsArt==undefined){ obsArt=""; }

			if(inciArt!==""  || obsArt!==""){ 
				var iArt = inciArt.split(" - ")[0];
				var iArtDescrip = inciArt.split(" - ")[1]; 
				if(iArt===""){ iArtDescrip="";}
				incidenciasSinPedido += '{"articulo":"'+articulo+'","incidencia":"'+iArt+'","descrip":"'+iArtDescrip+'","observacion":"'+obsArt+'"}'; 
			}
			elID++;
		});
		incidenciasSinPedido = ',"inciSinPed":['+incidenciasSinPedido.replace(/}{/g,"},{")+']';
	} 
	var parametros = '{"modo":"terminar","cliente":"'+ClienteCodigo+'","IdTeleVenta":"'+IdTeleVenta+'","FechaTeleVenta":"'+FechaTeleVenta+'","nombreTV":"'+NombreTeleVenta+'"'
					+',"incidenciaCliente":"'+incidenciaCliente+'","incidenciaClienteDescrip":"'+incidenciaClienteDescrip+'","observaciones":"'+observaciones+'"'
					+',"pedido":"'+pedido+'","empresa":"'+CodigoEmpresa+'","serie":"'+$("#dvSerieTV").text()+'"'+incidenciasSinPedido+','+paramStd+'}';
	flexygo.nav.execProcess('pLlamadas','',null,null,[{'key':'parametros','value':limpiarCadena(parametros)}],'modal640x480',false,$(this),function(ret){
		if(ret){ 
			terminandoLlamada=false;
			if(ctvll==="llamadasDelCliente"){ flexygo.nav.openPage('list','Clientes','(BAJA=0)',null,'current',false,$(this)); $("#mainNav").show(); }
			else{ inicioTeleVenta(); }			
		}else{ alert("Error SP: pLlamadas!!!"+JSON.stringify(ret)); }
	},false);
}

function cargarIncidencias(modo){
	abrirVelo(icoCargando16+" obteniendo incidencias...");
	var parametros = '{"modo":"'+modo+'",'+paramStd+'}';
	flexygo.nav.execProcess('pIncidencias','',null,null,[{'key':'parametros','value':limpiarCadena(parametros)}],'modal640x480',false,$(this),function(ret){
		if(ret){
			var js = JSON.parse(limpiarCadena(ret.JSCode));   
			window["dvIncidencias"+modo.toUpperCase()] = "";
			for(var i in js){ 
				window["dvIncidencias"+modo.toUpperCase()] += "<div class='indiencia dvSub' "
							  +  "onclick='asignarIncidencia($(this).parent().attr(\"data-id\"),\""+js[i].codigo+" - "+js[i].nombre+"\")'>"
							  +  js[i].codigo+" - "+js[i].nombre
							  +  "</div>";
			}
			cerrarVelo();
		}else{ alert("Error SP: pIncidencias!!!"+JSON.stringify(ret)); }
	},false);
}

function incidencia(modo,id){
	$("#dvIncidenciasTemp").remove();
	if(modo==="obs"){
		var uds = $.trim($("#tbArtDispTR"+id.split("inpObservaSol")[1]).find(".inpCantSol").val());
		if(uds==="" || parseInt(uds)===0 || isNaN(uds)){ return; }		
		var pHolder = "placeholder='Observaciones del producto'";
		var obsArt = $("#inpObservaSolTA"+id.split("inpObservaSol")[1]).val();
		if(obsArt!==""){ pHolder=""; }
		$("body").prepend(
			 "<div id='dvIncidenciasTemp' class='dvTemp'>"
			+"	<textarea style='width:100%;height:130px;padding:5px;box-sizing:border-box;' "+pHolder+">"+obsArt+"</textarea>"
			+"	<div style='text-align:center;padding:10px;'><span class='MIbotonGreen' "
			+"		onclick='observacionesArticulo(\""+id+"\")'>guardar</span>"
			+"	</div>"
			+"</div>"
		);
	}
	else{ $("body").prepend("<div id='dvIncidenciasTemp' class='dvTemp' data-id='"+id+"'>"+window["dvIncidencias"+modo.toUpperCase()]+"</div>"); }
	var y = ($("#"+id).offset()).top  - ($("#dvIncidenciasTemp").height());
	var x = (($("#"+id).offset()).left - $("#dvIncidenciasTemp").width()) + $("#"+id).width();
	$("#dvIncidenciasTemp").offset({top:y,left:x}).stop().fadeIn();
}

function asignarIncidencia(dis,inci){
	if(dis==="inciCliente"){ $("#inciCliente").val(inci); }
	else{
		$("#inpIncidenciaSolImg"+dis.split("inpIncidenciaSol")[1]).attr("src","./Merlos/images/inciRed.png");
		$("#inpIncidenciaSolINP"+dis.split("inpIncidenciaSol")[1]).html(inci);
	}
	$("#dvIncidenciasTemp").remove();	
}

function observacionesArticulo(id){
	var ind = id.split("inpObservaSol")[1];
	var ta = $("#dvIncidenciasTemp textarea").val();
	$("#inpObservaSolImg"+ind).attr("src","./Merlos/images/ojoRed.png");
	$("#inpObservaSolTA"+ind).val(ta);
	$("#dvIncidenciasTemp").remove();
}

/*  TV_LlamadasTV  **************************************************************************************************************** */
function cargarIncidencias(modo){
	var parametros = '{"modo":"'+modo+'",'+paramStd+'}';
	flexygo.nav.execProcess('pIncidencias','',null,null,[{'key':'parametros','value':limpiarCadena(parametros)}],'modal640x480',false,$(this),function(ret){
		if(ret){
			var js = JSON.parse(limpiarCadena(ret.JSCode));   
			window["dvIncidencias"+modo.toUpperCase()] = "";
			for(var i in js){ 
				window["dvIncidencias"+modo.toUpperCase()] += "<div class='indiencia dvSub' "
							  +  "onclick='asignarIncidencia($(this).parent().attr(\"data-id\"),\""+js[i].codigo+" - "+js[i].nombre+"\")'>"
							  +  js[i].codigo+" - "+js[i].nombre
							  +  "</div>";
			}
		}else{ alert("Error SP: pIncidencias!!!"+JSON.stringify(ret)); }
	},false);
}




function anyadirCliente(){
	if(new Date(fechaCambiaFormato(FechaTeleVenta)) < new Date(fechaCambiaFormato(fechaCorta()))){ alert("No se pueden asignar clientes a registros de días anteriores!"); return; }
	var contenidoDvLlamadas = $("#dvLlamadas").html();
	$("#dvLlamadas").html("<div>"
						+ "	<div>Añadir Cliente al listado actual</div>"
						+ "	<input type='text' id='inpAnyadirCli' placeholder='buscar...' onkeyup='buscarEnCampos(this.id,\"dvAnyadirCli\")'>"
						+ "	<div id='dvAnyadirCli' style='height:250px; overflow:hidden; overflow-y:auto;'><div class='taC vaM'>"+icoCargando16+" cargando clientes...</div></div>"
						+ "</div>");
	flexygo.nav.execProcess('pClientesBasic','',null,null,[{'key':'usuario','value':currentReference},{'key':'rol','value':currentRole}],'modal640x480',false,$(this),function(ret){
		if(ret){ 
			var contenido = "";
			var js = JSON.parse(limpiarCadena(ret.JSCode));
			if(js.clientes.length>0){
				for(var i in js.clientes){ 
					contenido += "<div class='dvSub' data-buscar='"+js.clientes[i].codigo+" "+js.clientes[i].nombre+" "+js.clientes[i].nComercial+" "+js.clientes[i].CIF+" "+js.clientes[i].TELEFONO+"' "
							  +  "onclick='dvAnyadirCli_Click(\""+js.clientes[i].codigo+"\")'>"+js.clientes[i].codigo+" - "+js.clientes[i].nombre+"</div>";
				}
			}else{ contenido = "<div style='text-align:center; color:red;'>Sin resultados!</div>";}
			$("#dvAnyadirCli").html(contenido)
		}else{ alert("Error SP: pClientesBasic!!!"+JSON.stringify(ret)); }
	},false);
}

function dvAnyadirCli_Click(cliente){
	$("#dvLlamadas").html("<div class='taC vaM'>"+icoCargando16+" añadiendo el cliente "+cliente+" al listado...</div>");
	var parametros = '{"modo":"anyadirCliente","IdTeleVenta":"'+IdTeleVenta+'","nombreTV":"'+NombreTeleVenta+'","FechaTeleVenta":"'+FechaTeleVenta+'"'
					+',"cliente":"'+cliente+'",'+paramStd+'}';
	flexygo.nav.execProcess('pLlamadas','',null,null,[{'key':'parametros','value':limpiarCadena(parametros)}],'modal640x480',false,$(this),function(ret){
		if(ret){
			if(ret.JSCode==="clienteExiste!"){ alert("El cliente ya existe en la lista actual!"); }
			recargarTVLlamadas();
		}else{ alert("Error SP: pLlamadas - dvAnyadirCli_Click!!!"+JSON.stringify(ret)); }
	},false);
}

function verDireccionesDelCliente(){
	if(!$("#thDirEntrega").hasClass("modifDir")){return;}
	$("#dvCliDir").stop().slideDown();
}

function asignarDireccionEntrega(direccion,linea){
	$("#tdDirEntrega").text(direccion);
	$("#inpDirEntrega").val(linea);
	$("#thDirEntrega").removeClass("fadeIO");
	$("#tdDirEntrega").css("background","#C5FFF7");
	$(document).click();
}
