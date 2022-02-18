﻿

BEGIN TRY

MERGE INTO [Pages] AS Target
USING (VALUES
  (N'8462DB46-6433-4DED-854E-E390DC933587',N'list',N'Cliente',NULL,N'default',N'list Cliente',N'noicon',N'{{ObjectDescrip}}',NULL,NULL,0,NULL,0,1,0,NULL,0,1)
 ,(N'94822B23-78A9-40EB-936F-062108F2F76D',N'view',N'Cliente',NULL,N'default',N'view Cliente',N'noicon',N'{{ObjectDescrip}}',NULL,N'
comprobarModuloClientePedidos();
comprobarModuloRecibosPendientes();


function comprobarModuloClientePedidos(){ 
	if(' + convert(nvarchar(max),NCHAR(36)) + N'("flx-module[modulename=''Cliente_Pedidos'']").is(":visible")){
		' + convert(nvarchar(max),NCHAR(36)) + N'("flx-module[modulename=''Cliente_Pedidos''] .icon-minus").click();
		' + convert(nvarchar(max),NCHAR(36)) + N'("flx-module[modulename=''Cliente_Pedidos''] div.cntBodyHeader, flx-module[modulename=''Cliente_Pedidos''] div.cntBodyFooter").hide(); 		
	}else{ setTimeout(function(){ comprobarModuloClientePedidos(); },100); }
}

function comprobarModuloRecibosPendientes(){ 
	if(' + convert(nvarchar(max),NCHAR(36)) + N'("flx-module[modulename=''TV_Recibos_Pendientes'']").is(":visible")){
		' + convert(nvarchar(max),NCHAR(36)) + N'("flx-module[modulename=''TV_Recibos_Pendientes''] .icon-minus").click();
		' + convert(nvarchar(max),NCHAR(36)) + N'("flx-module[modulename=''TV_Recibos_Pendientes''] div.cntBodyHeader, flx-module[modulename=''TV_Recibos_Pendientes''] div.cntBodyFooter").hide(); 		
	}else{ setTimeout(function(){ comprobarModuloRecibosPendientes(); },100); }
}
',1,NULL,0,1,0,NULL,0,1)
 ,(N'C408D692-F571-40FF-8C6F-79C80314E7C2',N'list',N'inciCLI',NULL,N'default',N'list inciCLI',N'noicon',N'{{ObjectDescrip}}',NULL,NULL,0,NULL,0,1,0,NULL,0,1)
 ,(N'Ruta',N'generic',NULL,N'webdefault',N'default',N'Ruta',N'noicon',N'Ruta',NULL,NULL,0,NULL,0,0,0,NULL,0,1)
 ,(N'Supervisor',N'generic',NULL,N'webdefault',N'default',N'Supervisor',N'noicon',N'Supervisor',NULL,NULL,0,NULL,0,0,0,NULL,0,1)
 ,(N'TeleVenta',N'generic',N'Cliente',NULL,N'MI_1_2_1',N'TeleVenta',N'noicon',N'Pantalla de Tele Venta',NULL,N'' + convert(nvarchar(max),NCHAR(36)) + N'("#mainNav").hide();

// Comprobar Ejercicio en Curso ----------------------------------------------------------------------------------------------------------------------------
var parametros = ''{"sp":"pConfiguracion","modo":"ComprobarEjercicio"}'';
flexygo.nav.execProcess(''pMerlos'','''',null,null,[{''Key'':''parametros'',''Value'':limpiarCadena(parametros)}],''current'',false,' + convert(nvarchar(max),NCHAR(36)) + N'(this),function(ret){if(ret){
	if(ret.JSCode!==""){ console.log("Se ha actualizado el portal al ejercicio "+ret.JSCode); }
}else{ alert(''Error S.P. pConfiguracion - ComprobarEjercicio!!!\n''+JSON.stringify(ret)); } }, false);
// ----------------------------------------------------------------------------------------------------------------------------------------------------------

var ClienteCodigo = "";
var ctvll = "";
var PedidoGenerado = ""; 
var ArticuloClienteBuscando = false;
var _CargarOfertasCliente = false;
var dentroDelDiv = false;

if((flexygo.history.get(' + convert(nvarchar(max),NCHAR(36)) + N'(''main'')).defaults)!==null &&	(flexygo.history.get(' + convert(nvarchar(max),NCHAR(36)) + N'(''main'')).defaults)!==undefined){ 
	var elJSON = JSON.parse(flexygo.history.get(' + convert(nvarchar(max),NCHAR(36)) + N'(''main'')).defaults);
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
	' + convert(nvarchar(max),NCHAR(36)) + N'("#btnPedido").text("Pedido");
	' + convert(nvarchar(max),NCHAR(36)) + N'(".moduloTV, #btnConfiguracion").stop().fadeIn();
	' + convert(nvarchar(max),NCHAR(36)) + N'(".moduloPedido").hide();
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
	if(' + convert(nvarchar(max),NCHAR(36)) + N'("#dvConfiguracionTeleVenta").is(":visible") || tf){
		FechaTeleVenta = ' + convert(nvarchar(max),NCHAR(36)) + N'.trim(' + convert(nvarchar(max),NCHAR(36)) + N'("#inpFechaTV").val());
		NombreTeleVenta = ' + convert(nvarchar(max),NCHAR(36)) + N'.trim(' + convert(nvarchar(max),NCHAR(36)) + N'("#inpNombreTV").val());
		if(FechaTeleVenta===""){ alert("Debes seleccionar la fecha!"); return; }
		if(NombreTeleVenta===""){ alert("El nombre no puede estar vacío!"); return; }
		if(!existeFecha(FechaTeleVenta)){ alert("Ups! Parece que la fecha no es correcta!"); return; }
		' + convert(nvarchar(max),NCHAR(36)) + N'("#btnTerminar,#btnPedido,#btnConfiguracion").show();
		' + convert(nvarchar(max),NCHAR(36)) + N'("flx-module[moduleName=''TV_Cliente''],flx-module[moduleName=''TV_Llamadas''],flx-module[moduleName=''TV_UltimosPedidos'']").slideDown();
		' + convert(nvarchar(max),NCHAR(36)) + N'("flx-module[moduleName=''TV_LlamadasTV'']").stop().slideUp();
		' + convert(nvarchar(max),NCHAR(36)) + N'("#dvConfiguracionTeleVenta").stop().slideUp(300,function(){ ' + convert(nvarchar(max),NCHAR(36)) + N'("#dvOpcionesTV").removeClass("esq1100").addClass("esq10"); }); 
		cargarTeleVentaLlamadas("cargarLlamadas");
		' + convert(nvarchar(max),NCHAR(36)) + N'("#dvFechaTV").html(FechaTeleVenta);
		estTV();
	}else { 
		' + convert(nvarchar(max),NCHAR(36)) + N'("#btnTerminar,#btnPedido,#btnConfiguracion").hide();
		' + convert(nvarchar(max),NCHAR(36)) + N'("flx-module[moduleName=''TV_Cliente''],flx-module[moduleName=''TV_Llamadas''],flx-module[moduleName=''TV_UltimosPedidos'']").hide();
		' + convert(nvarchar(max),NCHAR(36)) + N'("#dvOpcionesTV").removeClass("esq10").addClass("esq1100"); 
		' + convert(nvarchar(max),NCHAR(36)) + N'("flx-module[moduleName=''TV_LlamadasTV''],#dvConfiguracionTeleVenta").stop().slideDown();
		cargarTeleVentaLlamadas("listaGlobal");		
	}
}

function estTV(){
	' + convert(nvarchar(max),NCHAR(36)) + N'("#dvEstTV").html(icoCargando16+" cargando datos...");
	var contenido = "";
	var parametros = ''{"modo":"estadisticas","IdTeleVenta":"''+IdTeleVenta+''","FechaTeleVenta":"''+FechaTeleVenta+''","nombreTV":"''+NombreTeleVenta+''",''+paramStd+''}'';
	flexygo.nav.execProcess(''pEstTV'','''',null,null,[{''key'':''parametros'',''value'':limpiarCadena(parametros)}],''modal640x480'',false,' + convert(nvarchar(max),NCHAR(36)) + N'(this),function(ret){
		if(ret){ 
			var js = JSON.parse(limpiarCadena(ret.JSCode));
			contenido = "Clientes: "+js[0].clientes+"&nbsp;&nbsp;&nbsp; Llamadas: "+js[0].llamadas
					  + "&nbsp;&nbsp;&nbsp; Pedidos: "+js[0].pedidos
					  + "&nbsp;&nbsp;&nbsp; Importe: "+js[0].importe+"&euro;";
			' + convert(nvarchar(max),NCHAR(36)) + N'("#dvEstTV").html(contenido);
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
				' + convert(nvarchar(max),NCHAR(36)) + N'("#dvFiltrosTV").html("El registro ''"+NombreTeleVenta+"'' contiene filtros de "+losFiltros); 
			}else{ ' + convert(nvarchar(max),NCHAR(36)) + N'("#dvFiltrosTV").html("Registro ''"+NombreTeleVenta+"''"); }
		}else{ alert("Error SP: pLlamadas!!!"+JSON.stringify(ret)); }	
	},false);
}

function asignarMesesConsumo(){
	flexygo.nav.execProcess(''pConfiguracion'','''',null,null, 
	[{''Key'':''modo'',''Value'':''MesesConsumo''},{''Key'':''valor'',''Value'':' + convert(nvarchar(max),NCHAR(36)) + N'("#inpMesesConsumo").val()}], ''modal640x480'', false, ' + convert(nvarchar(max),NCHAR(36)) + N'(this), function(ret){if(ret){ 
		' + convert(nvarchar(max),NCHAR(36)) + N'("#spanAsignacionAviso").fadeIn(); MesesConsumo = ' + convert(nvarchar(max),NCHAR(36)) + N'("#inpMesesConsumo").val(); setTimeout(function(){ ' + convert(nvarchar(max),NCHAR(36)) + N'("#spanAsignacionAviso").fadeOut(); },2000);
	}else{ alert(''Error S.P. pConfiguracion!!!\n''+ret); } }, false);
}

function cargarConfiguracionTV(elCallBack){
	var parametros = ''{"modo":"lista"}'';
	flexygo.nav.execProcess(''pConfiguracion'','''',null,null,[{''Key'':''parametros'',''Value'':limpiarCadena(parametros)}],''modal640x480'',false,' + convert(nvarchar(max),NCHAR(36)) + N'(this),function(ret){if(ret){ 
		var js = JSON.parse(limpiarCadena(ret.JSCode));
		// Interruptores
		for(var i in js.IO){if(parseInt(js.IO[i].valor)===0){window["Conf"+js.IO[i].nombre]=0; }else{window["Conf"+js.IO[i].nombre]=1; }}
		if(ConfNoCobrarPortes===1){ ' + convert(nvarchar(max),NCHAR(36)) + N'("#spNoCobrarPortes").show(); }else{ ' + convert(nvarchar(max),NCHAR(36)) + N'("#spNoCobrarPortes").hide(); }
		if(ConfVerificarPedido===1){ ' + convert(nvarchar(max),NCHAR(36)) + N'("#spVerificarPedido").show(); }else{ ' + convert(nvarchar(max),NCHAR(36)) + N'("#spVerificarPedido").hide(); }
		// Comprobar si el cliente tiene varias direcciones
		var direcciones = ''{"sp":"pClientesDirecciones","modo":"dameDirecciones","cliente":"''+ClienteCodigo+''"}'';
		flexygo.nav.execProcess(''pMerlos'','''',null,null,[{''Key'':''parametros'',''Value'':limpiarCadena(direcciones)}],''current'',false,' + convert(nvarchar(max),NCHAR(36)) + N'(this),function(ret){if(ret){
			   console.log("pClientesDirecciones - ret.JSCode:\n"+ret.JSCode);
			   var contenido = "";
			   var dir = JSON.parse(limpiarCadena(ret.JSCode)); console.log("dir.error: "+dir.error);
			   if(dir.error===""){
				   ' + convert(nvarchar(max),NCHAR(36)) + N'("#tdDirEntrega").html(dir.datos[0].DIRECCION);
				   ' + convert(nvarchar(max),NCHAR(36)) + N'("#inpDirEntrega").val(dir.datos[0].LINEA);
				   if(dir.datos.length>1){
					   ' + convert(nvarchar(max),NCHAR(36)) + N'("#thDirEntrega").addClass("fadeIO").addClass("modifDir").css("color","green");
					   ' + convert(nvarchar(max),NCHAR(36)) + N'("#tdDirEntrega").css("background","#C6FFC5");
					   for(var d in dir.datos){
						   var direccion = dir.datos[d];
							contenido += "<div class=''dvSub'' onclick=''asignarDireccionEntrega(\""+direccion.DIRECCION+"\",\""+direccion.LINEA+"\")''>"+direccion.DIRECCION+"</div>";
					   }
				   }else{ ' + convert(nvarchar(max),NCHAR(36)) + N'("#thDirEntrega").removeClass("fadeIO").removeClass("modifDir").css("color","#666"); ' + convert(nvarchar(max),NCHAR(36)) + N'("#tdDirEntrega").css("background","#EDEFF3"); }
			   }else{
				   contenido = "Error! - pClientesDirecciones!";
			   }
			   ' + convert(nvarchar(max),NCHAR(36)) + N'("#dvCliDir").html(contenido);			   
		} else { alert(''Error SP pClientesDirecciones - dameDirecciones!''+JSON.stringify(ret)); }}, false);
		// elCallBack
		if(elCallBack){ elCallBack(); }
	}else{ alert("Error SP: cargarConfiguracionTV - pConfiguracion - lista!!!\n"+JSON.stringify(ret)); }}, false);
}

function pedidoTV(){
	if(new Date(fechaCambiaFormato(FechaTeleVenta)) < new Date(fechaCambiaFormato(fechaCorta()))){ alert("No se pueden crear pedidos de días anteriores!"); return; }

	if(ClienteCodigo===""){ alert("Debes seleccionar un cliente!"); return; }
	if(' + convert(nvarchar(max),NCHAR(36)) + N'("#btnPedido").text()==="Pedido"){
		' + convert(nvarchar(max),NCHAR(36)) + N'("#btnPedido").text("TeleVenta");
		' + convert(nvarchar(max),NCHAR(36)) + N'("#dvDatosDelClienteMin").html(datosDelCliente);
		' + convert(nvarchar(max),NCHAR(36)) + N'(".moduloTV, #btnConfiguracion").hide();
		' + convert(nvarchar(max),NCHAR(36)) + N'(".moduloPedido").stop().fadeIn();
		cargarConfiguracionTV(function(){cargarArticulosDisponibles(ClienteCodigo);});
		
		// comprobar si tiene Ofertas
		var parametros = ''{"modo":"ofertasDelCliente","cliente":"''+ClienteCodigo+''","fecha":"''+FechaTeleVenta+''",''+paramStd+''}'';
		flexygo.nav.execProcess(''pOfertas'','''',null,null,[{''Key'':''parametros'',''Value'':limpiarCadena(parametros)}],''modal640x480'',false,' + convert(nvarchar(max),NCHAR(36)) + N'(this),function(ret){
			if(ret){
				var js = JSON.parse(limpiarCadena(ret.JSCode));
				if(js.length>0){ ' + convert(nvarchar(max),NCHAR(36)) + N'("#btnClienteOfertas").addClass("fadeIO"); }else{ ' + convert(nvarchar(max),NCHAR(36)) + N'("#btnClienteOfertas").removeClass("fadeIO"); }
		}else{ alert("Error SP: pOfertas - ofertasDelCliente!!!\n"+JSON.stringify(ret)); }}, false);
		
		PedidoDetalle=[]; ' + convert(nvarchar(max),NCHAR(36)) + N'("#dvPedidoDetalle").html(""); // por si se ha terminado una llamada sin crear pedido.
	}else{
		' + convert(nvarchar(max),NCHAR(36)) + N'("#btnPedido").text("Pedido");
		' + convert(nvarchar(max),NCHAR(36)) + N'(".moduloTV, #btnConfiguracion").stop().fadeIn();
		' + convert(nvarchar(max),NCHAR(36)) + N'(".moduloPedido").hide();
		' + convert(nvarchar(max),NCHAR(36)) + N'("#taObsInt").val(ObservacionesInternas);
	}
	
	if(PedidoNoCobrarPortes===1){ PedidoNoPortes(); };
}

function cargarSubDatos(objeto,cliente,id,pos){
	var y = (' + convert(nvarchar(max),NCHAR(36)) + N'("#"+id).offset()).top;
	var x = (' + convert(nvarchar(max),NCHAR(36)) + N'("#"+id).offset()).left;	
	var contenido = "";
	var elTXT = "";
	var elJS = ''{"objeto":"''+objeto+''","cliente":"''+cliente+''",''+paramStd+''}'';
	
	if(pos===-1){ x -=100;}
	 
    ' + convert(nvarchar(max),NCHAR(36)) + N'("#dvDatosTemp").remove();
	' + convert(nvarchar(max),NCHAR(36)) + N'("body").prepend("<div id=''dvDatosTemp'' class=''dvTemp'' data-id=''"+id+"''>"+icoCargando16+" cargando datos...</div>");	
	' + convert(nvarchar(max),NCHAR(36)) + N'("#dvDatosTemp").offset({top:y,left:x}).stop().fadeIn();	
   
    flexygo.nav.execProcess(''pObjetoDatos'','''',null,null,[{''Key'':''elJS'',''Value'':elJS}], ''modal640x480'', false, ' + convert(nvarchar(max),NCHAR(36)) + N'(this), function(ret){if(ret){
		if(esJSON(ret.JSCode)){
			var js = JSON.parse(limpiarCadena(ret.JSCode));		
			if(js.length>0){
				for(var i in js){ 
					 if(objeto==="contactos"){ elTXT = js[i].LINEA+" - "+js[i].PERSONA; }
					 if(objeto==="inciCli" || objeto==="inciArt")  { elTXT = js[i].codigo+" - "+js[i].nombre; }
					contenido += "<div class=''dvSub'' onclick=''asignarObjetoDatos(\""+id+"\",' + convert(nvarchar(max),NCHAR(36)) + N'(this).text())''>"+elTXT+"</div>"; 
				}
				if(objeto==="inciCli"){ 
					contenido = "<div class=''dvSub'' onclick=''asignarObjetoDatos(\"MT\",\"Llamar más tarde\")''>MT - Llamar más tarde</div>"
								+"<div class=''dvSub'' onclick=''asignarObjetoDatos(\"OD\",\"Llamar otro día\")''>OD - Llamar otro día</div>"+contenido;  }
			}else{ contenido="<div style=''color:red;''>Sin resultados!</div>"; }
			if(objeto==="inciArt"){
				var inciAsig = ' + convert(nvarchar(max),NCHAR(36)) + N'("#inpIncidenciaSolINP"+id.split("inpIncidenciaSol")[1]).val();
				if(inciAsig!==""){ contenido = "<div class=''dvSubI'' onclick=''desasignarCliArt(\""+objeto+"\",\""+cliente+"\",\""+id+"\",\""+pos+"\")''>Asignado: "+inciAsig+"</div><br>" + contenido; }
			}
		}else{ contenido="<div style=''color:red;''>Sin resultados!</div>"; }
		' + convert(nvarchar(max),NCHAR(36)) + N'("#dvDatosTemp").html(contenido);
	}else{ ' + convert(nvarchar(max),NCHAR(36)) + N'("#dvDatosTemp").remove(); alert(''Error S.P. pSeries!\n''+JSON.stringify(ret)); } }, false);
}

function asignarObjetoDatos(id,txt){
	if(Left(id,16)==="inpIncidenciaSol"){ 
		var idN = id.split("inpIncidenciaSol")[1];
		id="inpIncidenciaSolINP"+idN;
		' + convert(nvarchar(max),NCHAR(36)) + N'("#inpIncidenciaSolImg"+idN).attr("src","./Merlos/images/inciRed.png");
		var parametros = ''{"modo":"incidenciaArticulo","IdTeleVenta":"''+IdTeleVenta+''","incidencia":"''+txt.split(" - ")[0]+''","cliente":"''+ClienteCodigo+''"''
						+'',"articulo":"''+' + convert(nvarchar(max),NCHAR(36)) + N'("#tbArtDispTR"+idN).attr("data-art")+''","observaciones":"''+' + convert(nvarchar(max),NCHAR(36)) + N'.trim(' + convert(nvarchar(max),NCHAR(36)) + N'("#inpObservaSolTA"+idN).val())+''",''+paramStd+''}'';
		flexygo.nav.execProcess(''pLlamadas'','''',null,null,[{''Key'':''parametros'',''Value'':limpiarCadena(parametros)}],''modal640x480'',false,' + convert(nvarchar(max),NCHAR(36)) + N'(this),function(ret){});
	}	
	// Llamar más tarde
	if(id==="MT"){ id="inciCliente";  mostrarRelojEJG("inciCliente",true);  }
	// Llamar otro día
	if(id==="OD"){ 
		abrirVelo(
			"Asignar llamada para el cliente "+ClienteCodigo
			+"<br><br>"
			+"<input type=''text'' id=''inpClienteOD'' placeholder=''Fecha y hora para la próxima llamada'' "
			+"style=''text-align:center;'' "
			+"onfocus=''(this.type=\"datetime-local\")'' onblur=''(this.type=\"text\")''>"
			+"<br><br><br>"
			+"<span class=''MIbotonGreen esq05'' onclick=''ClienteLlamarOtroDia()''>establecer</span>"
			+"&nbsp;&nbsp;&nbsp;<span class=''MIbotonRed esq05'' onclick=''cerrarVelo();''>cancelar</span>"
		);	
		return;
	}
	
	' + convert(nvarchar(max),NCHAR(36)) + N'("#"+id).val(txt);
	' + convert(nvarchar(max),NCHAR(36)) + N'("#dvDatosTemp").fadeOut(); 
}

function desasignarCliArt(objeto,cliente,id,pos){
	' + convert(nvarchar(max),NCHAR(36)) + N'("#inpIncidenciaSolINP"+id.split("inpIncidenciaSol")[1]).val("");
	' + convert(nvarchar(max),NCHAR(36)) + N'("#inpIncidenciaSolImg"+id.split("inpIncidenciaSol")[1]).attr("src","./Merlos/images/inciGris.png");
	cargarSubDatos(objeto,cliente,id,pos);
}

function ClienteLlamarOtroDia(){
	var nuevaLlamada = formatSqlFechaHora(' + convert(nvarchar(max),NCHAR(36)) + N'.trim(' + convert(nvarchar(max),NCHAR(36)) + N'("#inpClienteOD").val()));
	abrirVelo(icoCargando16 + " agendando llamada...");
	' + convert(nvarchar(max),NCHAR(36)) + N'("#inciCliente").val("OD - Llamar otro día");
	var parametros = ''{"modo":"llamarOtroDia","cliente":"''+ClienteCodigo+''","IdTeleVenta":"''+IdTeleVenta+''","nuevaLlamada":"''+nuevaLlamada+''",''+paramStd+''}''; 	
	flexygo.nav.execProcess(''pLlamadas'','''',null,null,[{''Key'':''parametros'',''Value'':limpiarCadena(parametros)}],''modal640x480'',false,' + convert(nvarchar(max),NCHAR(36)) + N'(this),function(ret){
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
	var parametros = ''{"cliente":"''+ClienteCodigo+''","FechaTeleVenta":"''+FechaTeleVenta+''"}''; console.log("parametros:\n"+parametros);
	flexygo.nav.execProcess(''pClienteDatos'','''',null,null,[{''key'':''parametros'',''value'':limpiarCadena(parametros)}],''modal640x480'',false,' + convert(nvarchar(max),NCHAR(36)) + N'(this),function(ret){ console.log("limpiarCadena(ret.JSCode):\n"+limpiarCadena(ret.JSCode));
		if(ret){
			if(ret.JSCode===""){ return; }
			var contenido = "";
			datosDelCliente = "";
			var js = JSON.parse(limpiarCadena(ret.JSCode));
			if(js.length>0){
				ObservacionesInternas = js[0].ObservacionesInternas.replace(/<br>/g,"\n");
				
				contenido = 
					 "<table id=''tbClienteDatos'' class=''tbTV''>"
					+"  <tr><th>Código</th><td>"+js[0].CODIGO+"</td><th>Nombre</th><td>"+js[0].NOMBRE+"</td></tr>"
					+"  <tr><th>CIF</th><td>"+js[0].CIF+"</td><th>R. Comercial</th><td>"+js[0].RCOMERCIAL+"</td></tr>"
					+"  <tr><th>Dirección</th><td colspan=''3''>"+js[0].DIRECCION+"</td></tr>"
					+"  <tr><th>CP</th><td>"+js[0].CP+"</td><th>Población</th><td>"+js[0].POBLACION+"</td></tr>"
					+"  <tr><th>Provincia</th><td colspan=''3''>"+js[0].provincia+"</td></tr>"
					+"  <tr><th>Email</th><td>"+js[0].EMAIL+"</td><th>Teléfono</th><td>"+' + convert(nvarchar(max),NCHAR(36)) + N'.trim(js[0].TELEFONO)+"" 
					+"		<span class=''fR MIbotonP esq05'' onclick=''verTodosLosTelfs()''>ver todos</span></td></tr>"
					+"  <tr id=''trTelfsCli'' class=''inv''></tr>"
					+"  <tr><th>Vendedor</th><td colspan=''3''>"+js[0].VENDEDOR+" - "+js[0].nVendedor+"</td></tr>"
					+"  <tr><th colspan=''4''>Observaciones del Cliente</th></tr>"
					+"  <tr><td colspan=''4''><textarea style=''width:100%; height:50px;'' disabled>"+js[0].OBSERVACIO+"</textarea></td></tr>"
					+"  <tr><th colspan=''4''>Observaciones Internas"
					+"		&nbsp;&nbsp;&nbsp;<span id=''ObsIntAV'' style=''font:bold 14px arial; color:#00a504; display:none;''>Autoguardado - OK</span>"
					+"	</th></tr>"
					+"  <tr><td colspan=''4''><textarea id=''taObsInt'' style=''width:100%; height:50px; font:14px arial;''>"+ObservacionesInternas+"</textarea></td></tr>"
					+"</table>";					
				
				var btnOfertas = "inv"; ClienteOferta=false;
				if(js[0].OFERTA==="1" || js[0].OFERTA==="true" || js[0].OFERTA===true){ btnOfertas = ""; ClienteOferta=true; }
				
				var fe = ' + convert(nvarchar(max),NCHAR(36)) + N'.trim(js[0].FechaEntrega);
				if((fe.split("-")[0]).length===4){ fe = fe.substr(8,2)+"-"+fe.substr(5,2)+"-"+fe.substr(0,4); }
				
				datosDelCliente = ""
								+ "<div style=''background:#fff;''>"
								+ "		<table class=''tbStdC''>"
								+ "			<tr>"
								+ "				<td style=''width:400px;''>"
								+ "					<div style=''padding:10px;box-sizing:border-box;background:#e1e3e7;color:#333;''>"
								+ "						("+js[0].CODIGO+") "+js[0].NOMBRE+""
								+ "						<br>"+js[0].RCOMERCIAL+" ("+js[0].POBLACION+")"
								+ "						<br>e-mail: "+js[0].EMAIL+""
								+ "						<br>teléfono: "+js[0].TELEFONO+""
								+ "						<div style=''margin-top:12px;''></div>"
								+ "						<div class=''dvRiesgo esq05'' onclick=''abrirModuloRiesgo(\""+js[0].CODIGO+"\")''>"
								+ "							RECIBOS PENDIENTES: "+js[0].numRecibos
								+ "							&nbsp;&nbsp;&nbsp;IMPORTE: "+parseFloat(js[0].importeRecibos).toFixed(2)+"&euro;"
								+ "							<br>RIESGO: "+parseFloat(js[0].CREDITO).toFixed(2)+"&euro;"
								+ "						</div>"
								+ "					</div>"
								+ "				</td>"
								+ "				<td style=''width:400px; vertical-align:top; padding-top:10px;''>"
								+ "					<table id=''tbClienteDatosMin''>"
								+ "						<tr>"
								+ "							<th class=''vaM pl20'' style=''width:180px;''>Contacto</th>"
								+ "							<td>"
								+ "								<input type=''text'' id=''inpDataContacto'' style=''text-align:left; color:#333;'' "
								+ "								onclick=''cargarSubDatos(\"contactos\",\""+ClienteCodigo+"\",this.id,0);event.stopPropagation();''>"
								+ "							</td>"
								+ "						<tr>"			
								+ " 						<th id=''thDirEntrega'' class=''vaM pl20''>Dir. Entrega</th>"
								+ "							<div id=''dvCliDir'' class=''dvTemp''></div><input type=''text'' id=''inpDirEntrega'' style=''display:none;'' />"
								+ "							<td id=''tdDirEntrega'' style=''background:#EDEFF3; overflow:hidden;'' onclick=''verDireccionesDelCliente(); event.stopPropagation();''></td>"
								+ "						</tr>"	
								+ "						<tr>"
								+ "							<th class=''vaM pl20''>Fecha Entrega</th>"
								+ "							<td>"
								+ "								<input type=''text'' id=''inpFechaEntrega'' style=''text-align:center; color:#333;'' "
								+ "								onkeyup=''calendarioEJGkeyUp(this.id,this.value)'' "
								+ "								onclick=''mostrarElCalendarioEJG(this.id,true);event.stopPropagation();'' "
								+ "								value=''"+fe+"''>"
								+ "							</td>"
								+ "						</tr>"
								+ "						<tr>"
								+ "							<th class=''vaM pl20''>Incidencia Cliente</th>"
								+ "							<td>"
								+ "								<input type=''text'' id=''inciCliente''"
								+ "								onclick=''cargarSubDatos(\"inciCli\",\""+ClienteCodigo+"\",this.id,0);event.stopPropagation();'' >"
								+ "							</td>"
								+ "						</tr>"									
								+ "					</table>"
								+ "				</td>"
								+ "				<td class=''vaT pl20'' style=''padding-top:7px;''>"
								+ "					Observaciones <span id=''spObservacionesPedInt'' class=''curP'' style=''font:bold 14px arial; color:#00a504;'' onclick=''PedidoObservaciones()''>del Pedido</span>"
								+ "					<br>"
								+ "					<textarea id=''taObservacionesDelPedido'' style=''width:98%;height:80px;padding:5px;box-sizing:border-box;''>"+ObservacionesDelPedido+"</textarea>"
								+ "				</td>"
								+ "				<td id=''tdOfertas'' class=''vaT pl20 taC "+btnOfertas+"'' style=''width:150px; padding-top:45px;''>"
								+ "					<span id=''btnClienteOfertas'' class=''MIbtnF'' style=''padding:20px;'' onclick=''ofertasDelCliente()''>Ofertas</span>"
								+ "				</td>"
								+ "			</tr>"
								+ "		</table>"
								+ "</div>";				
			}else{ contenido = "No se han obtenido resultados!"; }
			' + convert(nvarchar(max),NCHAR(36)) + N'("#dvDatosDelCliente").html(contenido);
			' + convert(nvarchar(max),NCHAR(36)) + N'("#taObsInt").off().on("blur",()=>{ ObservacionesInternas_Blur(); });
			elVendedor = js[0].VENDEDOR;
			cerrarVelo();			
		}else{ alert("Error SP: pClientesADI!"+JSON.stringify(ret)); }
	},false);
}

function ObservacionesInternas_Blur(){
	var ObservacionesInternas_ta = ' + convert(nvarchar(max),NCHAR(36)) + N'.trim(' + convert(nvarchar(max),NCHAR(36)) + N'("#taObsInt").val());
	if(ObservacionesInternas_ta!==ObservacionesInternas){
		' + convert(nvarchar(max),NCHAR(36)) + N'("#ObsIntAV").fadeIn();
		ObservacionesInternas_Click(true);
		setTimeout(()=>{ ' + convert(nvarchar(max),NCHAR(36)) + N'("#ObsIntAV").fadeOut(); },1000);
	}
}

function taObservacionesDelPedido_Blur(){
	var ObservacionesInternas_ta = ' + convert(nvarchar(max),NCHAR(36)) + N'.trim(' + convert(nvarchar(max),NCHAR(36)) + N'("#taObservacionesDelPedido").val());
	if(ObservacionesInternas_ta!==ObservacionesInternas){
		' + convert(nvarchar(max),NCHAR(36)) + N'("#taObservacionesDelPedidoAV").fadeIn();
		ObservacionesInternas_Click();
		setTimeout(()=>{ ' + convert(nvarchar(max),NCHAR(36)) + N'("#taObservacionesDelPedidoAV").fadeOut(); },1000);
	}
}

function abrirModuloRiesgo(cliente){
	flexygo.nav.openPage(''list'',''RecibosPendientes'',''CLIENTE=\''''+ClienteCodigo+''\'''',''{\''CLIENTE\'':\''''+ClienteCodigo+''\''}'',''popup'',false,' + convert(nvarchar(max),NCHAR(36)) + N'(this)); 
}

function PedidoObservaciones(){
	if(' + convert(nvarchar(max),NCHAR(36)) + N'("#spObservacionesPedInt").text()==="del Pedido"){
		' + convert(nvarchar(max),NCHAR(36)) + N'("#spObservacionesPedInt").html("Internas&nbsp;&nbsp;&nbsp;<span id=''taObservacionesDelPedidoAV'' style=''font:bold 14px arial; color:#00a504; display:none;''>Autoguardado - OK</span>"); 
		' + convert(nvarchar(max),NCHAR(36)) + N'("#taObservacionesDelPedido").val(ObservacionesInternas); 
		' + convert(nvarchar(max),NCHAR(36)) + N'("#taObservacionesDelPedido").off().on("blur",()=>{ taObservacionesDelPedido_Blur(); });
	}else{' + convert(nvarchar(max),NCHAR(36)) + N'("#spObservacionesPedInt").text("del Pedido"); ' + convert(nvarchar(max),NCHAR(36)) + N'("#taObservacionesDelPedido").val(ObservacionesDelPedido); ' + convert(nvarchar(max),NCHAR(36)) + N'("#taObservacionesDelPedido").off()}
}

function ObservacionesInternas_Click(tf){
	ObservacionesInternas = ' + convert(nvarchar(max),NCHAR(36)) + N'.trim(' + convert(nvarchar(max),NCHAR(36)) + N'("#taObservacionesDelPedido").val());
	if(tf){ ObservacionesInternas = ' + convert(nvarchar(max),NCHAR(36)) + N'.trim(' + convert(nvarchar(max),NCHAR(36)) + N'("#taObsInt").val()); }
	var parametros = ''{"modo":"ObservacionesInternas","cliente":"''+ClienteCodigo+''","observaciones":"''+ObservacionesInternas+''",''+paramStd+''}''; 	
	flexygo.nav.execProcess(''pClienteDatos'','''',null,null,[{''Key'':''parametros'',''Value'':limpiarCadena(parametros)}],''modal640x480'',false,' + convert(nvarchar(max),NCHAR(36)) + N'(this),function(ret){
		if(!ret){ alert("Error pClienteDatos!\n"+JSON.stringify(ret)); }
	 },false);
}
 
function verFichaDeCliente(){ 
	if(ClienteCodigo===""){ alert("Ningún cliente seleccionado!"); return; }
	flexygo.nav.openPage(''view'',''Cliente'',''CODIGO=\''''+ClienteCodigo+''\'''',''{\''CODIGO\'':\''''+ClienteCodigo+''\''}'',''popup'',false,' + convert(nvarchar(max),NCHAR(36)) + N'(this)); 
}

function ofertasDelCliente(){
	var parametros = ''{"modo":"ofertasDelCliente","cliente":"''+ClienteCodigo+''","fecha":"''+FechaTeleVenta+''",''+paramStd+''}'';
	flexygo.nav.execProcess(''pOfertas'','''',null,null,[{''Key'':''parametros'',''Value'':limpiarCadena(parametros)}],''modal640x480'',false,' + convert(nvarchar(max),NCHAR(36)) + N'(this),function(ret){
		if(ret){
			var js = JSON.parse(limpiarCadena(ret.JSCode));
			if(js.length>0){ ' + convert(nvarchar(max),NCHAR(36)) + N'("#btnClienteOfertas").addClass("fadeIO"); }else{ ' + convert(nvarchar(max),NCHAR(36)) + N'("#btnClienteOfertas").removeClass("fadeIO"); }
			abrirVelo("<div>"+icoCargando16+" buscando ofertas para el cliente "+ClienteCodigo+"...</div>");
			var contenido = "<span style=''font:bold 14px arial; color:#68CDF9;''>Ofertas - Cliente "+ClienteCodigo+"</span>"
						  + "<span style=''float:right;'' onclick=''cerrarVelo();''>"+icoAspa+"</span>"
						  + "<br><br>"
						  + "<div style=''max-height:500px; overflow:hidden; overflow-y:auto;''>"
						  + "	<table id=''tbOfertasCliente'' class=''tbStd''>"
						  + "	<tr>"
						  + "		<th class=''taL''>Artículo</th>"
						  + "		<th class=''taC''>Inicio</th>"
						  + "		<th class=''taC''>Fin</th>"
						  + "		<th class=''taC''>PVP</th>"
						  + "		<th class=''taC''>Dto.</th>"
						  + "	</tr>";
			if(js.length>0){
				for(var i in js){
					contenido += "<tr onclick=''ofertaArticuloBuscar(\""+' + convert(nvarchar(max),NCHAR(36)) + N'.trim(js[i].ARTICULO)+"\")''>"
							  +  "	<td class=''taL''>"+' + convert(nvarchar(max),NCHAR(36)) + N'.trim(js[i].ARTICULO)+"</td>"
							  +  "	<td class=''taC''>"+' + convert(nvarchar(max),NCHAR(36)) + N'.trim(js[i].FECHA_IN)+"</td>"
							  +  "	<td class=''taC''>"+' + convert(nvarchar(max),NCHAR(36)) + N'.trim(js[i].FECHA_FIN)+"</td>"
							  +  "	<td class=''taR''>"+parseFloat(js[i].PVP).toFixed(2)+"</td>"
							  +  "	<td class=''taR''>"+parseFloat(js[i].DTO1).toFixed(2)+"</td>"
							  +  "</tr>";
				}
				contenido += "</table></div><br><br>";
			}else{
				contenido = "<div>No se han obtenido ofertas para el cliente "+ClienteCodigo+"!"
				+"<br><br><br><span class=''MIboton esq05'' onclick=''cerrarVelo();''>aceptar</span>"
				+"</div>";
			}
			abrirVelo(contenido);
		}else{ alert("Error pOfertas!\n"+JSON.stringify(ret)); }
	},false);
}

function ofertaArticuloBuscar(articulo){
	' + convert(nvarchar(max),NCHAR(36)) + N'("#inpBuscarArticuloDisponible").val(articulo);
	buscarArticuloDisponible(window.event.keyCode=13);
	cerrarVelo();
}

function verTodosLosTelfs(){
	if(' + convert(nvarchar(max),NCHAR(36)) + N'("#trTelfsCli").is(":visible")){ ' + convert(nvarchar(max),NCHAR(36)) + N'("#trTelfsCli").hide(); return; }
	var parametros = ''{"modo":"verTodosLosTelfs","cliente":"''+ClienteCodigo+''",''+paramStd+''}''; 	
	flexygo.nav.execProcess(''pClienteDatos'','''',null,null,[{''Key'':''parametros'',''Value'':limpiarCadena(parametros)}],''modal640x480'',false,' + convert(nvarchar(max),NCHAR(36)) + N'(this),function(ret){
		if(ret){ 
			var contenido = "<table class=''tbStd''>"
						  + "	<tr>"
						  + "		<th>Persona</th>"
						  + "		<th>Cargo</th>"
						  + "		<th>Teléfono</th>"
						  + "	</tr>";
			var js = JSON.parse(ret.JSCode);
			if(js.length>0){
				for(var i in js){
					contenido +="	<tr>"
							  + "		<td>"+' + convert(nvarchar(max),NCHAR(36)) + N'.trim(js[i].PERSONA)+"</td>"
							  + "		<td>"+' + convert(nvarchar(max),NCHAR(36)) + N'.trim(js[i].CARGO)+"</td>"
							  + "		<td>"+' + convert(nvarchar(max),NCHAR(36)) + N'.trim(js[i].TELEFONO)+"</td>"
							  + "	</tr>";
				}
				contenido     +="</table>"
			}else{ contenido = "No se han obtenido resultados!"; }
			' + convert(nvarchar(max),NCHAR(36)) + N'("#trTelfsCli").html("<td colspan=''4''>"+contenido+"</td>").show();
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
	var parametros = ''{"modo":"''+modo+''","cliente":"''+ClienteCodigo+''","IdTeleVenta":"''+IdTeleVenta+''","nombreTV":"''+NombreTeleVenta+''","FechaTeleVenta":"''+FechaTeleVenta+''","usuariosTV":''+UsuariosTV+'',''+paramStd+''}''; 	
	flexygo.nav.execProcess(''pLlamadas'','''',null,null,[{''key'':''parametros'',''value'':limpiarCadena(parametros)}],''modal640x480'',false,' + convert(nvarchar(max),NCHAR(36)) + N'(this),function(ret){
		if(ret){
			if(ret.JSCode===""){ contenido = "No se han obtenido resultados!"; }				
			else{ 
				contenido = "";
				
				var js = JSON.parse(limpiarCadena(ret.JSCode));
				if(js.length>0){
					contenido += "<div style=''height:370px; overflow:hidden; overflow-y:auto;''>";
					if(modo==="llamadasDelCliente"){						
						contenido += "<table id=''tbLlamadasDelCliente'' class=''tbStdP''>"
									+"	<tr>"
									+"		<th>Fecha</th>"
									+"		<th>Hora</th>"
									+"		<th>Incidencia</th>"
									+"		<th>Pedido</th>"
									+"	</tr>";
					}
					if(modo==="cargarLlamadas"){
						contenido += "<table id=''tbLlamadas'' class=''tbStdP''>"
									+"	<tr>"
									+"		<th>Cliente</th>"
									+"		<th>Nombre</th>"
									+"		<th style=''text-align:center;''>Horario</th>"
									+"		<th style=''text-align:center;''>Estado</th>"
									+"		<th style=''text-align:center;''>Último pedido</th>"
									+"		<th style=''text-align:center;''>Pedido</th>"
									+"	</tr>";
					}
					if(modo==="listaGlobal"){
						contenido += ""
									+"<input type=''text'' id=''inpListadoGlobal'' placeholder=''buscar'' "
									+" onkeyup=''buscarEnTabla(this.id,\"tbLlamadasGlobal\")''>"
									+"<table id=''tbLlamadasGlobal'' class=''tbStdP'' style=''margin-top:4px;''>"
									+"	<tr>"
									+"		<th style=''width:150px;''>Fecha</th>"
									+"		<th class=''rolTeleVentaO''>Usuario</th>"
									+"		<th>Nombre</th>"
									+"		<th style=''text-align:center;''>Clientes</th>"
									+"		<th style=''text-align:center;''>Llamadas</th>"
									+"		<th style=''text-align:center;''>Pedidos</th>"
									+"		<th style=''text-align:center;''>Importe</th>"
									+"		<th style=''text-align:center;''>Total</th>"
									+"	</tr>";
					}
					
					for(var i in js){
						var elPedido = ' + convert(nvarchar(max),NCHAR(36)) + N'.trim(js[i].serie)+" - "+' + convert(nvarchar(max),NCHAR(36)) + N'.trim(js[i].pedido);
						if(' + convert(nvarchar(max),NCHAR(36)) + N'.trim(js[i].serie)===""){ elPedido=' + convert(nvarchar(max),NCHAR(36)) + N'.trim(js[i].pedido); }
						if(modo==="llamadasDelCliente"){
							var laHora = Left(' + convert(nvarchar(max),NCHAR(36)) + N'.trim(js[i].hora),5);
							var laIncidencia = ' + convert(nvarchar(max),NCHAR(36)) + N'.trim(js[i].incidencia)+" - "+' + convert(nvarchar(max),NCHAR(36)) + N'.trim(js[i].ic[0].nIncidencia);	
							var laFecha = ' + convert(nvarchar(max),NCHAR(36)) + N'.trim(js[i].fecha);
							if((laFecha.split("-")[0]).length===4){ laFecha = laFecha.substr(8,2)+"-"+laFecha.substr(5,2)+"-"+laFecha.substr(0,4); }
							if(' + convert(nvarchar(max),NCHAR(36)) + N'.trim(js[i].incidencia)===""){ laIncidencia = ""; }
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
							if(' + convert(nvarchar(max),NCHAR(36)) + N'.trim(js[i].completado)==="1"){ elBG = "style=''background:#FFCFCF;''"; estado="COMPLETADO"; } 							
							contenido += "<tr "+elBG+" onclick=''TV_SelecionarCliente(\""+' + convert(nvarchar(max),NCHAR(36)) + N'.trim(js[i].cliente)+"\")''>"
									  +"	<td>"+' + convert(nvarchar(max),NCHAR(36)) + N'.trim(js[i].cliente)+"</td>"
									  +"	<td>"+' + convert(nvarchar(max),NCHAR(36)) + N'.trim(js[i].cli[0].NOMBRE)+"</td>"
									  +"	<td style=''text-align:center;''>"+' + convert(nvarchar(max),NCHAR(36)) + N'.trim(js[i].horario)+"</td>"
									  +"	<td data-completado=''"+' + convert(nvarchar(max),NCHAR(36)) + N'.trim(js[i].completado)+"'' style=''text-align:center;''>"+estado+"</td>"
									  +"	<td style=''text-align:right;''>"+ultimoPedido+"</td>"
									  +"	<td style=''text-align:right;''>"+elPedido+"</td>"
									  +"</tr>";
						}
						if(modo==="listaGlobal"){
							var elSubTotal = parseFloat(' + convert(nvarchar(max),NCHAR(36)) + N'.trim(js[i].subtotal)).toFixed(2);
							if(isNaN(elSubTotal)){ elSubTotal=""; }else{ elSubTotal += " &euro;"; }
							var elImporte = parseFloat(' + convert(nvarchar(max),NCHAR(36)) + N'.trim(js[i].importe)).toFixed(2);
							if(isNaN(elImporte)){ elImporte=""; }else{ elImporte += " &euro;"; }
							contenido += "<tr onclick=''tbLlamadasGlobal_Sel(\""+' + convert(nvarchar(max),NCHAR(36)) + N'.trim(js[i].id)+"\",\""+' + convert(nvarchar(max),NCHAR(36)) + N'.trim(js[i].fecha)+"\",\""+' + convert(nvarchar(max),NCHAR(36)) + N'.trim(js[i].nombreTV)+"\")''>"
									  +"	<td>"+' + convert(nvarchar(max),NCHAR(36)) + N'.trim(js[i].fecha)+"</td>"
									  +"	<td class=''rolTeleVentaO''>"+' + convert(nvarchar(max),NCHAR(36)) + N'.trim(js[i].usuario)+"</td>"
									  +"	<td>"+' + convert(nvarchar(max),NCHAR(36)) + N'.trim(js[i].nombreTV)+"</td>"
									  +"	<td style=''text-align:right;''>"+' + convert(nvarchar(max),NCHAR(36)) + N'.trim(js[i].clientes)+"</td>"
									  +"	<td style=''text-align:right;''>"+' + convert(nvarchar(max),NCHAR(36)) + N'.trim(js[i].llamadas)+"</td>"
									  +"	<td style=''text-align:right;''>"+' + convert(nvarchar(max),NCHAR(36)) + N'.trim(js[i].pedidos)+"</td>"
									  +"	<td style=''text-align:right;''>"+elSubTotal+"</td>"
									  +"	<td style=''text-align:right;''>"+elImporte+"</td>"
									  +"</tr>";
							elDV = "dvLlamadasTeleVenta";
						}
					}
					contenido += "</table></div>";					
				}else{ contenido = "Sin registros!"; }
			}
			' + convert(nvarchar(max),NCHAR(36)) + N'("#"+elDV).html(contenido);
			if(currentRole==="TeleVenta"){ ' + convert(nvarchar(max),NCHAR(36)) + N'(".rolTeleVentaO").hide(); }
			cerrarVelo();
		}else{ alert("Error SP: pLlamadas!!!"+JSON.stringify(ret)); }
	},false);
}

function tbLlamadasGlobal_Sel(id,fecha,nombre){
	' + convert(nvarchar(max),NCHAR(36)) + N'("#inpFechaTV").val(fecha);
	' + convert(nvarchar(max),NCHAR(36)) + N'("#inpNombreTV").val(nombre);
	IdTeleVenta = id;
	FechaTeleVenta = fecha;
	NombreTeleVenta = nombre;
	cargarTbConfigOperador("cargar");
	configurarTeleVenta();
	' + convert(nvarchar(max),NCHAR(36)) + N'("#dvFechaTV").show();
}

function asignarserieconfig(){
	var serie = ' + convert(nvarchar(max),NCHAR(36)) + N'.trim(' + convert(nvarchar(max),NCHAR(36)) + N'("#inpLLBserieConfig").val()); 
	flexygo.nav.execProcess(''pConfiguracion'','''',null,null,[{''Key'':''modo'',''Value'':''TVSerie''},{''Key'':''valor'',''Value'':serie}],''modal640x480'', false, ' + convert(nvarchar(max),NCHAR(36)) + N'(this), function(ret){if(ret){
		' + convert(nvarchar(max),NCHAR(36)) + N'("#spanAsignacionSerieAviso").fadeIn(); // SERIE = serie;
		setTimeout(function(){ ' + convert(nvarchar(max),NCHAR(36)) + N'("#spanAsignacionSerieAviso").fadeOut(); },2000);
	}else{ alert("Error SP: pConfiguracion!!!\n"+JSON.stringify(ret)); }}, false);
}

function TV_SelecionarCliente(cliente){
	cargarTeleVentaCliente(cliente);
	cargarTeleVentaUltimosPedidos(cliente);
}

function inpDatos_Click(id){
	' + convert(nvarchar(max),NCHAR(36)) + N'(".dvListaDatos").stop().fadeOut();
	var elInp = id.split("LLB")[1];
	var contenido = "";
	var elInpSQL = elInp;
	var asigSerie = "";
	if(elInp==="serieConfig"){ elInpSQL="serie"; asigSerie = "asignarserieconfig();";}
	var elJS = ''{"modo":"''+elInpSQL+''",''+paramStd+''}'';
	' + convert(nvarchar(max),NCHAR(36)) + N'("#dvLLB"+elInp).html(icoCargando16 + " cargando...").stop().slideDown();
	flexygo.nav.execProcess(''pInpDatos'','''',null,null,[{''Key'':''elJS'',''Value'':elJS}], ''modal640x480'', false, ' + convert(nvarchar(max),NCHAR(36)) + N'(this), function(ret){if(ret){
		var js = JSON.parse(limpiarCadena(ret.JSCode));		
		if(js.length>0){
			for(var i in js){ 
				var elClick = js[i].codigo+" - "+js[i].nombre;
				if(id==="inpLLBserie" || id==="inpLLBserieConfig"){ elClick = js[i].codigo; SERIE = js[i].codigo; }
				contenido += "<div class=''dvLista'' "
				+"onclick=''' + convert(nvarchar(max),NCHAR(36)) + N'(\"#"+id+"\").val(\""+elClick+"\"); ' + convert(nvarchar(max),NCHAR(36)) + N'(\"#dvLLB"+elInp+"\").stop().slideUp(); "+asigSerie+"''>"
				+js[i].codigo+" - "+js[i].nombre
				+"</div>"; 
			}
		}else{ contenido="<div style=''color:red;''>Sin resultados!</div>"; }
		' + convert(nvarchar(max),NCHAR(36)) + N'("#dvLLB"+elInp).html(contenido);
	}else{ alert(''Error S.P. pSeries!\n''+JSON.stringify(ret)); } }, false);
}




/*  TV_UltimosPedidos  *********************************************************************************************************** */

function cargarTeleVentaUltimosPedidos(ClienteCodigo){
	var parametros = ''{"cliente":"''+ClienteCodigo+''",''+paramStd+''}'';
	flexygo.nav.execProcess(''pUltimosPedidos'','''',null,null,[{''key'':''parametros'',''value'':limpiarCadena(parametros)}],''modal640x480'',false,' + convert(nvarchar(max),NCHAR(36)) + N'(this),function(ret){
		if(ret){			
			if(ret.JSCode===""){ ret.JSCode="[]"; }
			var contenido = "<table class=''tbStdP''>"
						+   "<tr>"
						+   "	<th style=''width:100px;''>Fecha</th>"
						+   "	<th class=''C'' style=''width:100px;''>Pedido</th>"
						+   "	<th class=''C'' style=''width:100px;''>Entrega</th>"
						+   "	<th class=''C'' style=''width:100px;''>Ruta</th>"
						+   "	<th class=''C'' style=''width:100px;''>Estado</th>"
						+   "	<th class=''L''>Observaciones</th>"
						+   "	<th class=''C'' style=''width:200px;''>Importe</th>"
						+   "	<th class=''C'' style=''width:200px;''>Total</th>"
						+   "</tr>";
			var js = JSON.parse(limpiarCadena(ret.JSCode));
			if(js.length>0){
				for(var i in js){
					contenido += "<tr>"
							  +"	<td>"+' + convert(nvarchar(max),NCHAR(36)) + N'.trim(js[i].FECHA)+"</td>"
							  +"	<td id=''tdPedidoVer_"+i+"'' class=''C'' onmouseenter=''verPedidoDetalle(\""+' + convert(nvarchar(max),NCHAR(36)) + N'.trim(js[i].IDPEDIDO)+"\",\""+' + convert(nvarchar(max),NCHAR(36)) + N'.trim(js[i].LETRA)+"-"+' + convert(nvarchar(max),NCHAR(36)) + N'.trim(js[i].numero)+"\","+i+")'' "
							  +"	onmouseleave=''dentroDelDiv=false; cerrarAVT();'' style=''cursor:pointer; color:#000;''>"+' + convert(nvarchar(max),NCHAR(36)) + N'.trim(js[i].LETRA)+"-"+' + convert(nvarchar(max),NCHAR(36)) + N'.trim(js[i].numero)+"</td>"
							  +"	<td class=''C''>"+' + convert(nvarchar(max),NCHAR(36)) + N'.trim(js[i].ENTREGA)+"</td>"
							  +"	<td class=''C''>"+' + convert(nvarchar(max),NCHAR(36)) + N'.trim(js[i].RUTA)+"</td>"
							  +"	<td class=''C''>"+' + convert(nvarchar(max),NCHAR(36)) + N'.trim(js[i].ESTADO)+"</td>"
							  +"	<td class=''L'' style=''overflow:hidden;''>"+' + convert(nvarchar(max),NCHAR(36)) + N'.trim(js[i].OBSERVACIO)+"</td>"
							  +"	<td class=''R''>"+' + convert(nvarchar(max),NCHAR(36)) + N'.trim(js[i].TOTALPEDformato)+"</td>"
							  +"	<td class=''R''>"+' + convert(nvarchar(max),NCHAR(36)) + N'.trim(js[i].TOTALDOCformato)+"</td>"
							  +"</tr>"
				}
				contenido += "</table>"
			}else{ contenido = "No se han obtenido resultados!"; }
			' + convert(nvarchar(max),NCHAR(36)) + N'("#dvUltimosPedidos").html("<div style=''max-height:200px; overflow:hidden; overflow-y:auto;''>"+contenido+"</div>");
		}else{ alert("Error SP: pUltimosPedidos!\n"+JSON.stringify(ret)); }
	},false);
}

function verPedidoDetalle(idpedido,pedido,i){
	if(ArticuloClienteBuscando){return;}
	ArticuloClienteBuscando=true;
	dentroDelDiv=true;
	var contenido = icoCargando16+" cargando lineas del pedido "+pedido+"..."; 
	abrirAVT(contenido);
	contenido =  "<span style=''font:bold 16px arial; color:#666;''>Datos del pedido "+pedido+"</span>"
				+"<br><br>"
				+"<div style=''max-height:300px; overflow:hidden; overflow-y:auto;''>"
				+"	<table id=''tbPedidosDetalle'' class=''tbStd''>"
				+"		<tr>"
				+"			<th>Artículo</th>"
				+"			<th>Descipción</th>"
				+"			<th class=''C''>Cajas</th>"
				+"			<th class=''C''>Uds.</th>"
				+"			<th class=''C''>Peso</th>"
				+"			<th class=''C''>Precio</th>"
				+"			<th class=''C''>Dto</th>"
				+"			<th class=''C''>Importe</th>"
				+"		</tr>"; 
	var parametros = ''{"idpedido":"''+idpedido+''",''+paramStd+''}'';
	flexygo.nav.execProcess(''pPedidoDetalle'','''',null,null,[{''key'':''parametros'',''value'':limpiarCadena(parametros)}],''modal640x480'',false,' + convert(nvarchar(max),NCHAR(36)) + N'(this),function(ret){
		if(ret){ 
			var js = JSON.parse(limpiarCadena(ret.JSCode));   
			if(js.length>0){
				for(var j in js){ 
					contenido   +="<tr>"
								+"		<td>"+js[j].ARTICULO+"</td>"
								+"		<td>"+js[j].DEFINICION+"</td>"
								+"		<td class=''C''>"+js[j].cajas+"</td>"
								+"		<td class=''C''>"+js[j].UNIDADES+"</td>"
								+"		<td class=''C''>"+js[j].PESO+"</td>"
								+"		<td class=''C''>"+js[j].PRECIO+"</td>"
								+"		<td class=''C''>"+js[j].DTO1+"</td>"
								+"		<td class=''R''>"+js[j].IMPORTEf+"</td>"
								+"	</tr>"; 
				}
				contenido += "</table></div>";
			}else{ contenido = "No se han obtenido resultados! <span class=''flR'' onclick=''cerrarVelo()''>"+icoAspa+"</span>"; }
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
var ContextVars = ''<Row>''
	+''<Property Name="currentReference" Value="''+currentReference+''"/>''
	+''<Property Name="currentSubreference" Value="''+currentSubreference+''"/>''
	+''<Property Name="currentRole" Value="''+currentRole+''"/>''
	+''<Property Name="currentRoleId" Value="''+currentRoleId+''"/>''
	+''<Property Name="currentUserLogin" Value="''+currentUserLogin+''"/>''
	+''<Property Name="currentUserId" Value="''+currentUserId+''"/>''
	+''<Property Name="currentUserFullName" Value="''+currentUserFullName+''"/>''
	+''</Row>'';	
var	RetValues = ''<Property Success="False" SuccessMessage="" WarningMessage="" JSCode="" JSFile="" CloseParamWindow="False" refresh="False"/>'';

cargarIncidencias("art");
cargarIncidencias("cli");

function llamarMasTardeCliente(horaSel){
	abrirIcoCarga();
	var parametros = ''{"modo":"llamarMasTardeCliente","IdTeleVenta":"''+IdTeleVenta+''","cliente":"''+ClienteCodigo+''","horario":"''+horaSel+''"}''; 
	flexygo.nav.execProcess(''pLlamadas'','''',null,null,[{''Key'':''parametros'',''Value'':limpiarCadena(parametros)}],''modal640x480'',false,' + convert(nvarchar(max),NCHAR(36)) + N'(this),function(ret){
		if(ret){ pedidoTV(); recargarTVLlamadas(); }
		else{ alert("Error pLlamadas llamarMasTardeCliente!\n"+JSON.stringify(ret)); }
		cerrarVelo();
	},false);
}

function cargarArticulosDisponibles(modo){console.log("cargarArticulosDisponibles("+modo+")");
	tfArticuloSeleccionado = "";
	' + convert(nvarchar(max),NCHAR(36)) + N'("#spanBotoneraPag , #spResultados, #dvPersEP_Articulos").hide();
	' + convert(nvarchar(max),NCHAR(36)) + N'("#spanPersEPinfo").fadeIn(300,function(){
		var varios = "paginar";
		var celdaValor = "";
		var esconder_spResBtn=false; 
		var registrosTotales = 0;
		var elSP = "pArticulosBuscar";	
		var parametros = ''{"registros":''+paginadorRegistros+'',"buscar":"''+' + convert(nvarchar(max),NCHAR(36)) + N'.trim(' + convert(nvarchar(max),NCHAR(36)) + N'("#inpBuscarArticuloDisponible").val())+''","cliente":"''+ClienteCodigo+''","IdTeleVenta":"''+IdTeleVenta+''","fechaTV":"''+FechaTeleVenta+''","nombreTV":"''+NombreTeleVenta+''",''+paramStd+''}'';
		if(modo){ elSP = "pArticulosCliente"; }
		console.log(elSP + " - parametros:\n"+parametros);
		flexygo.nav.execProcess(elSP,'''',null,null,[{"Key":"parametros","Value":limpiarCadena(parametros)}],''modal640x480'',false,' + convert(nvarchar(max),NCHAR(36)) + N'(this),function(ret){
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
									 + "	<th colspan=''2''></th>"
									 + "	<th colspan=''3'' style=''text-align:center; background:rgb(73, 133, 214);''>Última Venta</th>"
									 + "	<th colspan=''"+elColSpan+"''></th>";
					}
					contenidoCab +="<tr>"
									 + "	<th id=''thCodigo'' style=''width:10%;''>Código</th>"
									 + "	<th>Descripción</th>";
					if(modo){ 
							contenidoCab += "<th style=''width:5%; text-align:center; background:rgb(73, 133, 214);''>Cajas</th>"
									     +  "<th style=''width:5%; text-align:center; background:rgb(73, 133, 214);''>Uds.</th>"
									     +  "<th style=''width:5%; text-align:center; background:rgb(73, 133, 214);''>Peso</th>";
					}	
					contenidoCab += "	<th class=''PedidoMaximo inv'' style=''width:5%; text-align:center;''>Pedido Máximo</th>"
								 +  "	<th style=''width:5%; text-align:center;''>Cajas</th>"
								 +  "	<th style=''width:5%; text-align:center;''>Uds.</th>"
								 +  "	<th style=''width:5%; text-align:center;''>Peso</th>"
								 +  "	<th style=''width:5%; text-align:center;''>Tarifa mín.</th>"
								 +  "	<th style=''width:5%; text-align:center; cursor:pointer; color:#99ffa5;'' onclick=''mostrarTarifaArticulo()''>Precio</th>"
								 +  "	<th style=''width:5%; text-align:center;''>Dto.</th>"
								 +  "	<th style=''width:5%; text-align:center;''>Importe</th>"
								 +  "	<th style=''width:5%; text-align:center;'' class=''inpStockVirtual''>Stock</th>"
								 +  "	<th style=''width:40px; text-align:center; box-sizing:border-box;''></th>"
								 +  "	<th style=''width:40px; text-align:center; box-sizing:border-box;''></th>"
								 +  "</tr>";
					' + convert(nvarchar(max),NCHAR(36)) + N'("#tbPersEP_ArticulosCab").html(contenidoCab);
					
					var valorPeso = "";
					
					for(var i in art){	
						var CajasIO = "";
						var UdsIO = "";
						var PesoIO = "";
						var elPedUniCaja ="0"; 
						var elPeso = ' + convert(nvarchar(max),NCHAR(36)) + N'.trim(art[i].PesoArticulo); if(elPeso==="" || elPeso===null){ elPeso="0"; }	
						var elPedUniCajaValor = elPedUniCaja; if(elPedUniCajaValor==="0"){ elPedUniCajaValor=""; }
						var elPesoValor = elPeso; if(elPesoValor==="0"){ elPesoValor=""; }
						var eOnClick = "";						
						var	stockVirtual = parseInt(art[i].StockVirtual); 
						
						if(modo){ 
							stockVirtual = parseInt(art[i].StockVirtual); if(isNaN(stockVirtual)){stockVirtual="";}							
							elPedUniCaja = ' + convert(nvarchar(max),NCHAR(36)) + N'.trim(art[i].UNICAJA); 
							if(elPedUniCaja==="" || elPedUniCaja===null){ elPedUniCaja="0"; }	
							if(parseFloat(elPedUniCaja)>0){ }else{ CajasIO="readonly disabled"; }
							if(parseFloat(art[i].PESO)>0){ }else{ PesoIO="readonly disabled"; }	
							eOnClick="onmouseenter=''articuloCliente(\"tbArtDispTR"+i+"\",\""+art[i].CODIGO+"\")'' onmouseleave=''dentroDelDiv=false;cerrarAVT();''";
						}else{
							elPedUniCaja = ' + convert(nvarchar(max),NCHAR(36)) + N'.trim(art[i].UNICAJA); 
							if(parseFloat(elPedUniCaja)>0){ }else{ CajasIO="readonly disabled"; }
							elPeso = ' + convert(nvarchar(max),NCHAR(36)) + N'.trim(art[i].peso); if(elPeso==="" || elPeso===null){ elPeso="0"; }	
							if(parseFloat(elPeso)>0){ }else{ PesoIO="readonly disabled"; }	
							valorPeso= " value=''"+parseFloat(elPeso).toFixed(3)+"'' "; 
						}						
						
						contenido 	+= "<tr id=''tbArtDispTR"+i+"'' class=''trBsc'' data-json=''{\"articulo\":\""+art[i].CODIGO+"\"}''"
									+  "data-art=''"+art[i].CODIGO+"'' data-nom=''"+art[i].NOMBRE+"''>"
									+"	<td class=''trBscCod'' style=''width:10%;'' "+eOnClick+" >"+art[i].CODIGO+"</td>"
									+"	<td class=''trBscNom''>"+art[i].NOMBRE+"</td>";
						if(modo){ 
							contenido += "<td class=''C'' style=''width:5%;''>"+ art[i].CAJAS +"</td>"
									  +  "<td class=''C'' style=''width:5%;''>"+ art[i].UDS +"</td>"
									  +  "<td class=''C'' style=''width:5%;''>"+ art[i].PESO +"</td>";
						}						
						contenido += " 	<td class=''C trBscCajas inv'' style=''width:10%;''>"+elPedUniCaja+"</td>"
									+"	<td class=''C'' style=''width:5%;''>"
									+"		<input type=''text'' id=''inp_cajas_"+i+"'' class=''inpCajasSol'' "
									+"		onkeyup=''' + convert(nvarchar(max),NCHAR(36)) + N'(this).css(\"color\",\"#000\"); calcCUP(\"cajas\",\"tbArtDispTR"+i+"\","+elPedUniCaja+","+elPeso+",false);'' "
									+"		onfocus=''celdaValor=this.value'' "
									+"		onfocusout=''if(celdaValor!==this.value){calcCUP(\"cajas\",\"tbArtDispTR"+i+"\","+elPedUniCaja+","+elPeso+",true);}'' "
									+"		onclick=''' + convert(nvarchar(max),NCHAR(36)) + N'(this).select(); cargarPrecio("+i+",this.id); event.stopPropagation();'' "+CajasIO+">"
									+"	</td>"
									+"	<td class=''C'' style=''width:5%;''>"
									+"		<input type=''text'' id=''inp_uds_"+i+"'' class=''inpCantSol'' "
									+"		onkeyup=''' + convert(nvarchar(max),NCHAR(36)) + N'(this).css(\"color\",\"#000\"); calcCUP(\"uds\",\"tbArtDispTR"+i+"\","+elPedUniCaja+","+elPeso+",false);'' "
									+"		onfocus=''celdaValor=this.value'' "
									+"		onfocusout=''if(celdaValor!==this.value){calcCUP(\"uds\",\"tbArtDispTR"+i+"\","+elPedUniCaja+","+elPeso+",true);}'' "
									+"		onclick=''' + convert(nvarchar(max),NCHAR(36)) + N'(this).select(); cargarPrecio("+i+",this.id); event.stopPropagation();'' "+UdsIO+">"
									+"	</td>"
									+"	<td class=''C'' style=''width:5%;''>"
									+"		<input type=''text'' id=''inp_peso_"+i+"'' class=''inpPesoSol C'' "+valorPeso+" "
									+"		onkeyup=''' + convert(nvarchar(max),NCHAR(36)) + N'(this).css(\"color\",\"#000\"); calcCUP(\"peso\",\"tbArtDispTR"+i+"\","+elPedUniCaja+","+elPeso+",false);'' "
									+"		onfocus=''celdaValor=this.value'' "
									+"		onfocusout=''if(celdaValor!==this.value){calcCUP(\"peso\",\"tbArtDispTR"+i+"\","+elPedUniCaja+","+elPeso+",true);}'' "
									+"		onclick=''' + convert(nvarchar(max),NCHAR(36)) + N'(this).select(); cargarPrecio("+i+",this.id); event.stopPropagation();'' "+PesoIO+">"
									+"	</td>";
						if(modo){ contenido +="<td id=''tarifaTD"+i+"'' class=''C'' style=''width:5%;''></td>"; }
						else{ contenido +="<td id=''tarifaTD"+i+"'' class=''C'' style=''width:5%;''>"+(art[i].pvp).toFixed(2)+"</td>"; }
						contenido += "	<td id=''precioTD"+i+"'' class=''C'' style=''width:5%;''>"
							//		+"		<span class=''flx-icon icon-sincronize-1 rotarR'' style=''font-size:12px; color:green;''></span>"
									+"  </td>"
									+"	<td id=''DtoTD"+i+"'' class=''C'' style=''width:5%;''>"
							//		+"		<span class=''flx-icon icon-sincronize-1 rotarR'' style=''font-size:12px; color:orange;''></span>"
									+"  </td>"
									+"	<td class=''inpImporteSol R'' style=''width:5%;''></td>"
									+"	<td class=''inpStockVirtual R'' style=''width:5%;''>"+stockVirtual+"</td>"
									+"	<td id=''inpIncidenciaSol"+i+"'' class=''C'' style=''width:40px; box-sizing:border-box;'' "
									+"	style=''table-layout:fixed;'' "
									+"	onclick=''cargarSubDatos(\"inciArt\",\""+ClienteCodigo+"\",this.id,-1);event.stopPropagation();''>"
									+"		<img id=''inpIncidenciaSolImg"+i+"'' src=''./Merlos/images/inciGris.png'' width=''14''>"
									+"		<input type=''text'' id=''inpIncidenciaSolINP"+i+"'' class='' trInciArt inv''>"
									+"	</td>"
									+"	<td id=''inpObservaSol"+i+"'' class=''C'' style=''width:40px;  box-sizing:border-box;'' "
									+"	onclick=''incidencia(\"obs\",this.id);event.stopPropagation();''>"
									+"		<img id=''inpObservaSolImg"+i+"'' src=''./Merlos/images/ojoGris.png'' width=''14''>"
									+"		<textarea id=''inpObservaSolTA"+i+"'' class=''trObservaArt inv''></textarea>"
									+"	</td>"
									+"</tr>";
					}					
					' + convert(nvarchar(max),NCHAR(36)) + N'("#tbPersEP_Articulos").html(contenido);
					if(ConfMostrarStockVirtual===0){ ' + convert(nvarchar(max),NCHAR(36)) + N'(".inpStockVirtual").hide(); }
					
					//setTimeout(function(){obtenerPreciosYOfertas(modo);},1000);
					
					if(flexygo.context.ConfigArtMaxPedido==="1"){ ' + convert(nvarchar(max),NCHAR(36)) + N'(".PedidoMaximo").removeClass("inv").addClass("vis"); }					
					var pagRD = paginadorRegistros+1;
					var pagRH = paginadorRegistros+100;
					if(pagRH>registrosTotales){ pagRH=registrosTotales; esconder_spResBtn=true; }
					' + convert(nvarchar(max),NCHAR(36)) + N'("#spResultadosT").text("Mostrando registros del "+pagRD+" al "+ pagRH +" de "+registrosTotales+" encontrados."); 
					' + convert(nvarchar(max),NCHAR(36)) + N'("#spanBotoneraPag, #spResultados, #dvPersEP_Articulos, #spBtnAnyCont, #tbPersEP_ArticulosCab").stop().fadeIn(); 
					if(modo){ ' + convert(nvarchar(max),NCHAR(36)) + N'("#spResultados").hide(); }
					if(esconder_spResBtn){' + convert(nvarchar(max),NCHAR(36)) + N'("#spResBtn").hide(); paginadorRegistros=0; }
					if(modo){ 
						' + convert(nvarchar(max),NCHAR(36)) + N'("#thCodigo").css("background","#4985D6"); 
						' + convert(nvarchar(max),NCHAR(36)) + N'(".trBscCod").css("color","#4985D6"); 
					}
					' + convert(nvarchar(max),NCHAR(36)) + N'("#inpBuscarArticuloDisponible").val("");
				}else{ 
					' + convert(nvarchar(max),NCHAR(36)) + N'("#tbPersEP_Articulos").html("No se han obtenido resultados!"); 					
					' + convert(nvarchar(max),NCHAR(36)) + N'("#spBtnAnyCont , #spResultados , #tbPersEP_ArticulosCab").stop().hide();
					' + convert(nvarchar(max),NCHAR(36)) + N'("#spanBotoneraPag, #dvPersEP_Articulos").stop().fadeIn(); 
					paginadorRegistros=0;
				}
				' + convert(nvarchar(max),NCHAR(36)) + N'("#spanPersEPinfo").hide();
			}else{ alert("Error pArticulosBuscar!\n"+JSON.stringify(ret)); }
		 },false);
	});
}

function cargarPrecio(i,inp){
	if(' + convert(nvarchar(max),NCHAR(36)) + N'.trim(' + convert(nvarchar(max),NCHAR(36)) + N'("#precioTD"+i).html())!==""){return;}
	var contenidoTR = ' + convert(nvarchar(max),NCHAR(36)) + N'("#tbArtDispTR"+i).html();
	' + convert(nvarchar(max),NCHAR(36)) + N'("#tbArtDispTR"+i).html("<td colspan=''15'' style=''padding:10px; text-align:center; background:#DEFFDA;''>"+icoCargando16+" cargando precios y ofertas...</td>");
	var elArticulo = ' + convert(nvarchar(max),NCHAR(36)) + N'("#tbArtDispTR"+i).attr("data-art");
	var parametros = ''{''
		+''"modo":"verArticuloPrecio"''
		+'',"empresa":"''+flexygo.context.CodigoEmpresa+''"''
		+'',"cliente":"''+ClienteCodigo+''"''
		+'',"articulo":"''+elArticulo+''"''
		+'',"unidades":"1"''
		+'',"FechaTeleVenta":"''+FechaTeleVenta+''"''
		+'','' + paramStd
	+''}'';
	flexygo.nav.execProcess(''pPreciosTabla'','''',null,null,[{''Key'':''parametros'',''Value'':limpiarCadena(parametros)}],''modal640x480'',false,' + convert(nvarchar(max),NCHAR(36)) + N'(this),function(ret){
	if(ret){
		try{										
			var js = JSON.parse(limpiarCadena(ret.JSCode));
			var PT = js[0].precioTarifa; if(isNaN(PT) || PT===""){ PT=0.00; }
			var PC = js[0].precio; if(isNaN(PC) || PC===""){ PC=0; }
			var DT = js[0].dto;    if(isNaN(DT) || DT===""){ DT=0; }
			' + convert(nvarchar(max),NCHAR(36)) + N'("#tbArtDispTR"+i).html(contenidoTR);
			' + convert(nvarchar(max),NCHAR(36)) + N'("#tarifaTD"+i).html(parseFloat(PT).toFixed(2));
			' + convert(nvarchar(max),NCHAR(36)) + N'("#precioTD"+i).html(
				"<input type=''text'' class=''inpPrecioSol'' onkeyup=''' + convert(nvarchar(max),NCHAR(36)) + N'(this).css(\"color\",\"#000\"); calcularImporte(\"tbArtDispTR"+i+"\")'' "
				+"onclick=''' + convert(nvarchar(max),NCHAR(36)) + N'(this).select(); tfArtSel("+i+")'' "
				+"value=''"+parseFloat(PC).toFixed(2)+"''>"
			);
			' + convert(nvarchar(max),NCHAR(36)) + N'("#DtoTD"+i).html(
				"<input type=''text'' class=''inpDtoSol'' onkeyup=''' + convert(nvarchar(max),NCHAR(36)) + N'(this).css(\"color\",\"#000\");  calcularImporte(\"tbArtDispTR"+i+"\")'' "
				+"onclick=''' + convert(nvarchar(max),NCHAR(36)) + N'(this).select();'' "
				+"value=''"+parseFloat(DT).toFixed(2)+"''>"
			);
			' + convert(nvarchar(max),NCHAR(36)) + N'("#"+inp).focus();
		}catch{ alert("Error JSON pPreciosTabla - verArticuloPrecio!\n"+JSON.stringify(ret)); }									
	}else{ alert("Error RET - pPreciosTabla - verArticuloPrecio!\n"+JSON.stringify(ret)); }
 },false);
}

function tfArtSel(i){ tfArticuloSeleccionadoI=i; tfArticuloSeleccionado=' + convert(nvarchar(max),NCHAR(36)) + N'("#tbArtDispTR"+i).attr("data-art"); }

function mostrarTarifaArticulo(){
	if(tfArticuloSeleccionado===""){ return; }
	abrirVelo(icoCargando16+" buscando el artículo "+tfArticuloSeleccionado+" en las distintas tarifas...");
	var parametros = ''{"modo":"verArticuloTarifas","articulo":"''+tfArticuloSeleccionado+''"}'';
	flexygo.nav.execProcess(''pPreciosTabla'','''',null,null,[{''Key'':''parametros'',''Value'':limpiarCadena(parametros)}],''modal640x480'',false,' + convert(nvarchar(max),NCHAR(36)) + N'(this),function(ret){
		if(ret){ 
			var contenido = "<span style=''font:bold 14px arial; color:#68CDF9;''>Artículo: "+tfArticuloSeleccionado+" - Tarifas</span>"
						  + "<span style=''float:right;'' onclick=''cerrarVelo();''>"+icoAspa+"</span>"
						  + "<br><br>"
						  + "<table id=''tbArticulosTarifas'' class=''tbStd''>"
						  + "	<tr>"
						  +  "		<th>Tarifa</th>"
						  +  "		<th>PVP</th>"
						  +  "	</tr>";
			var js = JSON.parse(limpiarCadena(ret.JSCode));
			if(js.length>0){ 
				for(var i in js){
					var elPVP = parseFloat(js[i].pvp).toFixed(2); if(isNaN(elPVP)){ elPVP = "0.00"; }
					contenido += "<tr onclick=''establecerPvpTarifa("+js[i].pvp+")''>"
							  +  "	<td>"+js[i].tarifa+"</td>"
							  +  "	<td>"+elPVP+"</td>"
							  +  "</tr>";
				}
				contenido += "</table>";
			}else{ contenido = "No se han obtenido registros!<br><br><br><span class=''MIboton esq05'' onclick=''cerrarVelo();''>aceptar</span>"; }
			abrirVelo(contenido);
		}
		else{ alert("Error pPreciosTabla - verArticuloTarifas!\n"+JSON.stringify(ret)); }
	 },false);
}

function establecerPvpTarifa(pvp){ ' + convert(nvarchar(max),NCHAR(36)) + N'("#tbArtDispTR"+tfArticuloSeleccionadoI).find(".inpPrecioSol").val(parseFloat(pvp).toFixed(2)); cerrarVelo(); }

function articuloCliente(trid,articulo){
	if(ArticuloClienteBuscando){ return; }
	ArticuloClienteBuscando = true;
	dentroDelDiv=true;
	abrirAVT(icoCargando16+" buscando el artículo "+articulo+" en los albaranes...");
	var contenido = "<span style=''font:bold 14px arial; color:#68CDF9;''>Artículo: "+articulo+"</span>"
				    +"<br><br>"
				    +"<table class=''tbStd''>"
					+"	<tr>"
					+"		<th class=''C''>Fecha</th>"
					+"		<th class=''C''>Cajas</th>"
					+"		<th class=''C''>Uds.</th>"
					+"		<th class=''C''>Peso</th>"
					+"		<th class=''C''>Precio</th>"
					+"		<th class=''C''>Dto</th>"
					+"		<th class=''C''>Importe</th>"
					+"	</tr>";  
	var parametros = ''{"modo":"UltimasVentasArticulo","registros":''+paginadorRegistros+'',"buscar":"''+' + convert(nvarchar(max),NCHAR(36)) + N'.trim(' + convert(nvarchar(max),NCHAR(36)) + N'("#inpBuscarArticuloDisponible").val())+''","articulo":"''+articulo+''","cliente":"''+ClienteCodigo+''","IdTeleVenta":"''+IdTeleVenta+''","fechaTV":"''+FechaTeleVenta+''","nombreTV":"''+NombreTeleVenta+''",''+paramStd+''}'';
	flexygo.nav.execProcess(''pArticulosCliente'','''',null,null,[{''Key'':''parametros'',''Value'':limpiarCadena(parametros)}],''modal640x480'',false,' + convert(nvarchar(max),NCHAR(36)) + N'(this),function(ret){
		if(ret){ 
			var js = JSON.parse(limpiarCadena(ret.JSCode)); 
			if(js.length>0){ 
				for(var i in js){
					contenido  += "	<tr>"
								+"		<td class=''C''>"+js[i].FECHA+"</td>"
								+"		<td class=''C''>"+js[i].CAJAS+"</td>"
								+"		<td class=''C''>"+js[i].UDS+"</td>"
								+"		<td class=''C''>"+js[i].PESO+"</td>"
								+"		<td class=''C''>"+js[i].PRECIO+"</td>"
								+"		<td class=''C''>"+js[i].DTO1+"</td>"
								+"		<td class=''C''>"+js[i].IMPORTE+"</td>"
								+"	</tr>"; 
				}
				contenido += "</table>";
			}else{ contenido = "No se han obtenido registros!<br><br><br><span class=''MIboton esq05'' onclick=''cerrarAVT();''>aceptar</span>"; }
			abrirAVT(contenido,800);
			ArticuloClienteBuscando=false;
			if(!dentroDelDiv){cerrarAVT();}
		}
		else{ alert("Error pArticulosCliente - UltimasVentasArticulo!\n"+JSON.stringify(ret)); ArticuloClienteBuscando=false; }
	 },false);
}

function calcCUP(modo,i,unicaja,unipeso,uniprecio,elENTER){ 
	var elTR = "#"+i;
	var cajas = ' + convert(nvarchar(max),NCHAR(36)) + N'(elTR).find(".inpCajasSol").val();		if(isNaN(cajas)){ cajas=0; }
	var uds = ' + convert(nvarchar(max),NCHAR(36)) + N'(elTR).find(".inpCantSol").val();		if(isNaN(uds)){ uds=0; }
	var peso = ' + convert(nvarchar(max),NCHAR(36)) + N'(elTR).find(".inpPesoSol").val();		if(isNaN(peso)){ peso=0; }
	var codigo = ' + convert(nvarchar(max),NCHAR(36)) + N'(elTR).find(".inpCodigoSol").val();	
	var linia = ' + convert(nvarchar(max),NCHAR(36)) + N'(elTR).find(".inpLiniaSol").val();	
	
	if(modo==="cajas"){ 
		uds=cajas*unicaja; if(isNaN(uds)){ uds=0; } ' + convert(nvarchar(max),NCHAR(36)) + N'(elTR).find(".inpCantSol").val(uds); 
		if(parseFloat(unipeso)>0) { peso=uds*unipeso; if(isNaN(peso)){ peso=0; } ' + convert(nvarchar(max),NCHAR(36)) + N'(elTR).find(".inpPesoSol").val(peso.toFixed(3)); }
	}
	if(modo==="uds"){ 
		if(parseFloat(unicaja)>0) { cajas=uds/unicaja; if(isNaN(cajas)){ cajas=0; } ' + convert(nvarchar(max),NCHAR(36)) + N'(elTR).find(".inpCajasSol").val(Math.floor(cajas)); }
		if(parseFloat(unipeso)>0) { peso=uds*unipeso; if(isNaN(peso)){ peso=0; } ' + convert(nvarchar(max),NCHAR(36)) + N'(elTR).find(".inpPesoSol").val(peso.toFixed(3)); }
	}
	
	calcularImporte(i);
}

function calcularImporte(i){
	var elTR = "#"+i;
	var uds = ' + convert(nvarchar(max),NCHAR(36)) + N'(elTR).find(".inpCantSol").val();		if(isNaN(uds)){ uds=0; }
	var peso = ' + convert(nvarchar(max),NCHAR(36)) + N'(elTR).find(".inpPesoSol").val();		if(isNaN(peso)){ peso=0; }
	var dto = ' + convert(nvarchar(max),NCHAR(36)) + N'(elTR).find(".inpDtoSol").val();			if(isNaN(dto)){ dto=0; }
	var precio = ' + convert(nvarchar(max),NCHAR(36)) + N'(elTR).find(".inpPrecioSol").val();	if(isNaN(precio)){ precio=0; }
	var importe = parseFloat(precio) * parseFloat(uds);
	if(parseFloat(peso)>0 && parseInt(EWtrabajaPeso)===1){ importe =  parseFloat(precio) * parseFloat(peso); }
	if(parseFloat(dto)>0){ importe = importe - ((importe*dto)/100); }
	if(isNaN(importe)){ importe=0; } 
	' + convert(nvarchar(max),NCHAR(36)) + N'(elTR).find(".inpImporteSol").html(importe.toFixed(2)+"&euro;");
}

function buscarArticuloDisponible(){
	if(ClienteCodigo===""){ alert("No hay un cliente seleccionado!"); return; }
	if(event.keyCode===13){
		var buscarArticulo = ' + convert(nvarchar(max),NCHAR(36)) + N'.trim(' + convert(nvarchar(max),NCHAR(36)) + N'("#inpBuscarArticuloDisponible").val());
		if(buscarArticulo===""){ return; }
		paginadorRegistros=0;
		cargarArticulosDisponibles(false);
		return; 
	}
	var buscar = ' + convert(nvarchar(max),NCHAR(36)) + N'.trim(' + convert(nvarchar(max),NCHAR(36)) + N'("#inpBuscarArticuloDisponible").val()).toUpperCase();
	if(buscar===""){ ' + convert(nvarchar(max),NCHAR(36)) + N'(".trBsc").removeClass("inv"); return; }
	' + convert(nvarchar(max),NCHAR(36)) + N'("#tbPersEP_Articulos").find(".trBsc").each(function(){ 
		 var cod = ' + convert(nvarchar(max),NCHAR(36)) + N'(this).find(".trBscCod").text().toUpperCase();
		 var nom = ' + convert(nvarchar(max),NCHAR(36)) + N'(this).find(".trBscNom").text().toUpperCase();
		 if(cod.indexOf(buscar)>=0 || nom.indexOf(buscar)>=0 ){ ' + convert(nvarchar(max),NCHAR(36)) + N'(this).removeClass("inv"); }else{ ' + convert(nvarchar(max),NCHAR(36)) + N'(this).addClass("inv"); }
	});
	repintarZebra("tbPersEP_Articulos","#fff");
}

function buscarArtDispCli(){ cargarArticulosDisponibles(ClienteCodigo); }

function pedidoAnyadirDetalle(){
	' + convert(nvarchar(max),NCHAR(36)) + N'("#tbPersEP_Articulos").find(".trBsc").each(function(){ 
		 var cod = ' + convert(nvarchar(max),NCHAR(36)) + N'(this).find(".trBscCod").text();
		 var cjs = parseFloat(' + convert(nvarchar(max),NCHAR(36)) + N'(this).find(".inpCajasSol").val());
		 var can = parseFloat(' + convert(nvarchar(max),NCHAR(36)) + N'(this).find(".inpCantSol").val()); 		 
		 var cajas = parseFloat(' + convert(nvarchar(max),NCHAR(36)) + N'(this).find(".trBscCajas").text()); 
		 var StockVirtual = parseFloat(' + convert(nvarchar(max),NCHAR(36)) + N'(this).find(".tdBscStockVirtual").text()); 
		 var maxPed = parseFloat(' + convert(nvarchar(max),NCHAR(36)) + N'(this).find(".tdBscMaxPed").text());		
		 var peso = parseFloat(' + convert(nvarchar(max),NCHAR(36)) + N'(this).find(".inpPesoSol").val());					if(isNaN(peso)){ peso=0; }	
		 var precio = parseFloat(' + convert(nvarchar(max),NCHAR(36)) + N'(this).find(".inpPrecioSol").val());				if(isNaN(precio)){ precio=0; }	
		 var dto = parseFloat(' + convert(nvarchar(max),NCHAR(36)) + N'(this).find(".inpDtoSol").val());					if(isNaN(dto)){ dto=0; }	
		 var importe = parseFloat(' + convert(nvarchar(max),NCHAR(36)) + N'(this).find(".inpImporteSol").text());			if(isNaN(importe)){ importe=0; }	
		 var CosteResiduo = parseFloat(' + convert(nvarchar(max),NCHAR(36)) + N'(this).find(".inpCosteResiduo").text());	if(isNaN(CosteResiduo)){ CosteResiduo=0; }	
		 var incidencia = (' + convert(nvarchar(max),NCHAR(36)) + N'(this).find(".trInciArt").val()).split(" - ")[0];
		 var incidenciaDescrip = (' + convert(nvarchar(max),NCHAR(36)) + N'(this).find(".trInciArt").val()).split(" - ")[1];
		 var observacion = ' + convert(nvarchar(max),NCHAR(36)) + N'(this).find(".trObservaArt").val();

		if(parseFloat(cjs)>0 || parseFloat(can)>0){	
			// comprobar Coste Residuo
			(function(){
				var parametros = ''{"modo":"residuo","articulo":"''+cod+''"}'';
				flexygo.nav.execProcess(''pArticulos'','''',null,null,[{''Key'':''parametros'',''Value'':limpiarCadena(parametros)}],''current'',false,' + convert(nvarchar(max),NCHAR(36)) + N'(this),function(ret){if(ret){
					var residuo = JSON.parse(ret.JSCode);
					var pImporte = parseFloat(residuo[0].P_IMPORTE);
					if(residuo[0].PVERDE && parseInt(residuo[0].P_TAN)===2){
						if(parseFloat(peso)>0){ CosteResiduo = parseFloat(pImporte) * parseFloat(peso); }
						else{ CosteResiduo = parseFloat(pImporte) * parseFloat(can); }
					}
					
					PedidoDetalle.push(''{"codigo":"''+cod+''","unidades":"''+can+''","peso":"''+peso+''","precio":"''+precio+''","dto":"''+dto+''"''
					+'',"importe":"''+importe+''","CosteResiduo":"''+CosteResiduo+''","CosteResiduoArt":"''+cod+''","artUnicaja":"''+cajas+''"''
					+'',"incidencia":"''+incidencia+''","incidenciaDescrip":"''+incidenciaDescrip+''","observacion":"''+observacion+''"}'');
					
					// comprobar Impuesto Bebidas Azucaradas
					var param = ''{"modo":"bebidasAzucaradas","articulo":"''+cod+''"}'';
					(function(){
						flexygo.nav.execProcess(''pArticulos'','''',null,null,[{''key'':''parametros'',''value'':limpiarCadena(param)}],''current'',false,' + convert(nvarchar(max),NCHAR(36)) + N'(this),function(r){if(r){
							var esc = JSON.parse(r.JSCode);
							if(esc.length>0){
								for(var x=0; x<esc.length; x++){
									var escComponente = esc[x].COMPONENTE;
									if(escComponente===null){continue;}
									var escUds = parseFloat(can) * parseFloat(esc[x].UNIDADES);
									var escPrecio = parseFloat(esc[x].PVP)
									var escImporte = escUds * escPrecio;
									var pImporte = parseFloat(esc[x].P_IMPORTE)
									
									PedidoDetalle.push(''{"codigo":"''+escComponente+''","unidades":"''+escUds+''","peso":"''+peso+''"''
									+'',"precio":"''+escPrecio+''","dto":"''+dto+''","importe":"''+escImporte+''"''
									+'',"CosteResiduo":"''+CosteResiduo+''","CosteResiduoArt":"''+cod+''","artUnicaja":"''+cajas+''","incidencia":"''+incidencia+''"''
									+'',"incidenciaDescrip":"''+incidenciaDescrip+''","observacion":"''+observacion+''"}'');	
								}
								pedidoVerDetalle();
							}							
						}else{ alert("Error! - pArticulos - impuestos: "+JSON.stringify(r)); } },false);
					})();
										
					if(PedidoDetalle.length<1){ alert("No se han seleccionado cantidades del listado!"); }
					else{ pedidoVerDetalle(); }
					' + convert(nvarchar(max),NCHAR(36)) + N'(".inpCajasSol,.inpCantSol,.inpPesoSol,.inpP").val("");
					' + convert(nvarchar(max),NCHAR(36)) + N'(".inpImporteSol").html("");
				} else { alert(''Error SP pArticulos - residuos!''+JSON.stringify(ret)); }}, false);
			})();
		}		
	});		
}

function ultimoArticulo_Click(art){/* ' + convert(nvarchar(max),NCHAR(36)) + N'("#inpBuscarArticuloDisponible").val(art); buscarArticuloDisponible(window.event.keyCode=13);*/ }

function pedidoVerDetalle(){
	if(PedidoDetalle.length>0){
		var CosteResiduoArticulos = [];
		var elTotal = 0.00;
		var contenido =  "<br><table id=''tbPedidoDetalle'' class=''tbStd''>"
					  +  "	<tr>"
					  +  "	<th colspan=''8'' style=''vertical-align:middle; background:#CCC;''>Líneas del Pedido</th>"
					  +  "	</tr>"
					  +  "	<tr>"
					  +  "		<th style=''width:50px;''></th>"
					  +  "		<th>código</th>"
					  +  "		<th class=''taC'' style=''width:80px;''>unidades</th>"
					  +  "		<th class=''taC'' style=''width:80px;''>peso</th>"
					  +  "		<th class=''taC'' style=''width:80px;''>precio</th>"
					  +  "		<th class=''taC'' style=''width:80px;''>dto</th>"
					  +  "		<th class=''taC'' style=''width:80px;''>C.Residuo</th>"
					  +  "		<th class=''taC'' style=''width:100px;''>importe</th>"
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
					  +  "		<td class=''taC''>"
					  +  "			<img src=''./Merlos/images/cerrarRed.png'' class=''curP'' width=''20'' "
					  +  "			onclick=''PedidoEliminarLinea(\""+js[i].codigo+"\")''>"
					  +  "		</td>"
					  +  "		<td>"+js[i].codigo+"</td>"
					  +  "		<td class=''taR''>"+lasUds+"</td>"
					  +  "		<td class=''taR''>"+peso+"</td>"
					  +  "		<td class=''taR''>"+precio+" &euro;</td>"
					  +  "		<td class=''taR''>"+dto1+"</td>"
					  +  "		<td class=''taR'' id=''CosteResiduo_"+js[i].codigo+"''>"+parseFloat(CosteResiduo).toFixed(3)+"</td>"
					  +  "		<td class=''taR''>"+importe.toFixed(2)+" &euro;</td>"
					  +  "	</tr>";
		}
		contenido 	  += "<tr><th colspan=''2''></th><th colspan=''5''>TOTAL PEDIDO</th><th class=''taR''>"+elTotal.toFixed(2)+"</th></tr></table>"
		' + convert(nvarchar(max),NCHAR(36)) + N'("#dvPedidoDetalle").html(contenido);
	}else{' + convert(nvarchar(max),NCHAR(36)) + N'("#dvPedidoDetalle").html("<div style=''padding:10px; color:red;''>Sin Lineas para el pedido!</div>");}
}

function PedidoEliminarLinea(cd){
	var js = JSON.parse("["+PedidoDetalle+"]");
	var nuevoP = [];
	for(var i in js){
		if(js[i].codigo!==cd){ nuevoP.push(''{"codigo":"''+js[i].codigo+''","unidades":"''+js[i].unidades+''","peso":"''+js[i].peso+''","precio":"''+js[i].precio+''","dto":"''+js[i].dto+''","importe":"''+js[i].importe+''"}''); }
	}
	PedidoDetalle = nuevoP;
	pedidoVerDetalle();
}


var terminandoLlamada=false;
function terminarLlamada(){
	if(terminandoLlamada){ return; }
	terminandoLlamada=true;
	if(ClienteCodigo===""){ alert("No hay un cliente activo!"); terminandoLlamada=false; return; }
	var contacto = (' + convert(nvarchar(max),NCHAR(36)) + N'.trim(' + convert(nvarchar(max),NCHAR(36)) + N'("#inpDataContacto").val())).split(" - ")[0];
	if(PedidoDetalle.length>0 && PedidoGenerado===""){ 
		var fff = ' + convert(nvarchar(max),NCHAR(36)) + N'.trim(' + convert(nvarchar(max),NCHAR(36)) + N'("#inpFechaEntrega").val());
		if(fff!==""){
			if(!existeFecha(fff)){ alert("Ups! Parece que la fecha no es correcta!"); terminandoLlamada=false; return; }
			if(!validarFechaMayorActual(fff)){ alert("La fecha debe ser posterior a hoy!"); terminandoLlamada=false; return; }
		}
		abrirVelo(icoCargando16 + " generando el pedido..."); 
		var lasLineas = (JSON.stringify(PedidoDetalle)).replace(/{/g,"_openLL_").replace(/}/g,"_closeLL_");
		var Values = ''<Row rowId="elRowDelObjetoPedido" ObjectName="Pedido">''
					+	''<Property Name="MODO" Value="Pedido"/>''
					+	''<Property Name="IdTeleVenta" Value="''+IdTeleVenta+''"/>''
					+	''<Property Name="FechaTV" Value="''+FechaTeleVenta+''"/>''
					+	''<Property Name="NombreTV" Value="''+NombreTeleVenta+''"/>''
					+	''<Property Name="IDPEDIDO" Value="''+PedidoActivo+''"/>''
					+	''<Property Name="EMPRESA" Value="''+flexygo.context.CodigoEmpresa+''"/>''
					+	''<Property Name="CLIENTE" Value="''+ClienteCodigo+''"/>''
					+	''<Property Name="ENV_CLI" Value="''+' + convert(nvarchar(max),NCHAR(36)) + N'("#inpDirEntrega").val()+''"/>''
					+	''<Property Name="SERIE" Value="''+' + convert(nvarchar(max),NCHAR(36)) + N'("#dvSerieTV").text()+''"/>''
					+	''<Property Name="CONTACTO" Value="''+contacto+''"/>''
					+	''<Property Name="INCICLI" Value="''+' + convert(nvarchar(max),NCHAR(36)) + N'.trim((' + convert(nvarchar(max),NCHAR(36)) + N'("#inciCliente").val()).split(" - ")[0])+''"/>''
					+	''<Property Name="INCICLIDescrip" Value="''+' + convert(nvarchar(max),NCHAR(36)) + N'.trim((' + convert(nvarchar(max),NCHAR(36)) + N'("#inciCliente").val()).split(" - ")[1])+''"/>''
					+	''<Property Name="ENTREGA" Value="''+' + convert(nvarchar(max),NCHAR(36)) + N'.trim(' + convert(nvarchar(max),NCHAR(36)) + N'("#inpFechaEntrega").val())+''"/>''
					+	''<Property Name="VENDEDOR" Value="''+elVendedor+''"/>''
					+	"<Property Name=''LINEAS'' Value=''"+lasLineas+"''/>"
					+	"<Property Name=''NoCobrarPortes'' Value=''"+PedidoNoCobrarPortes+"''/>"
					+	"<Property Name=''VerificarPedido'' Value=''"+VerificarPedido+"''/>"
					+	"<Property Name=''OBSERVACIO'' Value=''"+' + convert(nvarchar(max),NCHAR(36)) + N'.trim(' + convert(nvarchar(max),NCHAR(36)) + N'("#taObservacionesDelPedido").val())+"''/>"
					+''</Row>'';
		flexygo.nav.execProcess(''pPedido_Nuevo'',''Pedido'',null,null
		,[{key:''Values'',value:Values}, {key:''ContextVars'',value:ContextVars},{key:''RetValues'',value:RetValues}],''modal640x480'',false,' + convert(nvarchar(max),NCHAR(36)) + N'(this),function(ret){
			if(ret && !ret.JSCode.includes("''Error pedidoNuevo !!!")){
				var js = JSON.parse(limpiarCadena(ret.JSCode));
				cargarTeleVentaUltimosPedidos(ClienteCodigo);
				' + convert(nvarchar(max),NCHAR(36)) + N'("#inpBuscarArticuloDisponible").val("");
				' + convert(nvarchar(max),NCHAR(36)) + N'("#tbPersEP_ArticulosCab, #dvPedidoDetalle").html("");
				' + convert(nvarchar(max),NCHAR(36)) + N'("#dvPersEP_Articulos, #spResultados").slideUp();
				PedidoGenerado = js.Codigo;
				terminarLlamadaDef(PedidoGenerado,true);
			}else{ alert("Error pPedido_Nuevo!\n"+JSON.stringify(ret)); }
		 },false);
	}else{ terminarLlamadaDef(); }
}
function terminarLlamadaDef(pedido,confirmacion){
	var incidenciaCliente = ' + convert(nvarchar(max),NCHAR(36)) + N'.trim(' + convert(nvarchar(max),NCHAR(36)) + N'("#inciCliente").val()).split(" - ")[0];
	var incidenciaClienteDescrip = ' + convert(nvarchar(max),NCHAR(36)) + N'.trim(' + convert(nvarchar(max),NCHAR(36)) + N'("#inciCliente").val()).split(" - ")[1];
	var observaciones = ' + convert(nvarchar(max),NCHAR(36)) + N'.trim(' + convert(nvarchar(max),NCHAR(36)) + N'("#taObservacionesDelPedido").val());
	var elTXT;
	if((incidenciaCliente==="" && observaciones==="") && !confirmacion){
		if(incidenciaCliente==="" && observaciones===""){ elTXT = "No se han indicado observaciones del pedido<br>ni incidencias del cliente!";	}
		if(incidenciaCliente==="" && observaciones!==""){ elTXT = "No se ha indicado incidencia del cliente!";	}
		if(incidenciaCliente!=="" && observaciones===""){ elTXT = "No se han indicado observaciones del cliente!";	}
		abrirVelo(
			  elTXT
			+ "<br><br><br>"
			+ "<span class=''MIbotonGreen'' onclick=''terminarLlamadaDef(\""+pedido+"\",true)''>Terminar la llamada</span>"
			+ "&nbsp;&nbsp;&nbsp;<span class=''MIbotonRed'' onclick=''cerrarVelo()''>cancelar</span>"
		);
		terminandoLlamada=false; return;
	}
	var incidenciasSinPedido = "";
	if(PedidoGenerado==="" && PedidoDetalle.length===0){
		var articulo = "";
		var inciArt  = "";
		var obsArt   = "";
		var elID     =  0;
		' + convert(nvarchar(max),NCHAR(36)) + N'("#tbPersEP_Articulos").find("tr").each(function(){
			articulo = ' + convert(nvarchar(max),NCHAR(36)) + N'(this).attr("data-art");
			inciArt  = ' + convert(nvarchar(max),NCHAR(36)) + N'.trim(' + convert(nvarchar(max),NCHAR(36)) + N'("#inpIncidenciaSolINP"+elID).val());	if(inciArt==undefined){ inciArt=""; }
			obsArt   = ' + convert(nvarchar(max),NCHAR(36)) + N'.trim(' + convert(nvarchar(max),NCHAR(36)) + N'("#inpObservaSolTA"+elID).val());		if(obsArt==undefined){ obsArt=""; }

			if(inciArt!==""  || obsArt!==""){ 
				var iArt = inciArt.split(" - ")[0];
				var iArtDescrip = inciArt.split(" - ")[1]; 
				if(iArt===""){ iArtDescrip="";}
				incidenciasSinPedido += ''{"articulo":"''+articulo+''","incidencia":"''+iArt+''","descrip":"''+iArtDescrip+''","observacion":"''+obsArt+''"}''; 
			}
			elID++;
		});
		incidenciasSinPedido = '',"inciSinPed":[''+incidenciasSinPedido.replace(/}{/g,"},{")+'']'';
	} 
	var parametros = ''{"modo":"terminar","cliente":"''+ClienteCodigo+''","IdTeleVenta":"''+IdTeleVenta+''","FechaTeleVenta":"''+FechaTeleVenta+''","nombreTV":"''+NombreTeleVenta+''"''
					+'',"incidenciaCliente":"''+incidenciaCliente+''","incidenciaClienteDescrip":"''+incidenciaClienteDescrip+''","observaciones":"''+observaciones+''"''
					+'',"pedido":"''+pedido+''","empresa":"''+CodigoEmpresa+''","serie":"''+' + convert(nvarchar(max),NCHAR(36)) + N'("#dvSerieTV").text()+''"''+incidenciasSinPedido+'',''+paramStd+''}'';
	flexygo.nav.execProcess(''pLlamadas'','''',null,null,[{''key'':''parametros'',''value'':limpiarCadena(parametros)}],''modal640x480'',false,' + convert(nvarchar(max),NCHAR(36)) + N'(this),function(ret){
		if(ret){ 
			terminandoLlamada=false;
			if(ctvll==="llamadasDelCliente"){ flexygo.nav.openPage(''list'',''Clientes'',''(BAJA=0)'',null,''current'',false,' + convert(nvarchar(max),NCHAR(36)) + N'(this)); ' + convert(nvarchar(max),NCHAR(36)) + N'("#mainNav").show(); }
			else{ inicioTeleVenta(); }			
		}else{ alert("Error SP: pLlamadas!!!"+JSON.stringify(ret)); }
	},false);
}

function cargarIncidencias(modo){
	abrirVelo(icoCargando16+" obteniendo incidencias...");
	var parametros = ''{"modo":"''+modo+''",''+paramStd+''}'';
	flexygo.nav.execProcess(''pIncidencias'','''',null,null,[{''key'':''parametros'',''value'':limpiarCadena(parametros)}],''modal640x480'',false,' + convert(nvarchar(max),NCHAR(36)) + N'(this),function(ret){
		if(ret){
			var js = JSON.parse(limpiarCadena(ret.JSCode));   
			window["dvIncidencias"+modo.toUpperCase()] = "";
			for(var i in js){ 
				window["dvIncidencias"+modo.toUpperCase()] += "<div class=''indiencia dvSub'' "
							  +  "onclick=''asignarIncidencia(' + convert(nvarchar(max),NCHAR(36)) + N'(this).parent().attr(\"data-id\"),\""+js[i].codigo+" - "+js[i].nombre+"\")''>"
							  +  js[i].codigo+" - "+js[i].nombre
							  +  "</div>";
			}
			cerrarVelo();
		}else{ alert("Error SP: pIncidencias!!!"+JSON.stringify(ret)); }
	},false);
}

function incidencia(modo,id){
	' + convert(nvarchar(max),NCHAR(36)) + N'("#dvIncidenciasTemp").remove();
	if(modo==="obs"){
		var uds = ' + convert(nvarchar(max),NCHAR(36)) + N'.trim(' + convert(nvarchar(max),NCHAR(36)) + N'("#tbArtDispTR"+id.split("inpObservaSol")[1]).find(".inpCantSol").val());
		if(uds==="" || parseInt(uds)===0 || isNaN(uds)){ return; }		
		var pHolder = "placeholder=''Observaciones del producto''";
		var obsArt = ' + convert(nvarchar(max),NCHAR(36)) + N'("#inpObservaSolTA"+id.split("inpObservaSol")[1]).val();
		if(obsArt!==""){ pHolder=""; }
		' + convert(nvarchar(max),NCHAR(36)) + N'("body").prepend(
			 "<div id=''dvIncidenciasTemp'' class=''dvTemp''>"
			+"	<textarea style=''width:100%;height:130px;padding:5px;box-sizing:border-box;'' "+pHolder+">"+obsArt+"</textarea>"
			+"	<div style=''text-align:center;padding:10px;''><span class=''MIbotonGreen'' "
			+"		onclick=''observacionesArticulo(\""+id+"\")''>guardar</span>"
			+"	</div>"
			+"</div>"
		);
	}
	else{ ' + convert(nvarchar(max),NCHAR(36)) + N'("body").prepend("<div id=''dvIncidenciasTemp'' class=''dvTemp'' data-id=''"+id+"''>"+window["dvIncidencias"+modo.toUpperCase()]+"</div>"); }
	var y = (' + convert(nvarchar(max),NCHAR(36)) + N'("#"+id).offset()).top  - (' + convert(nvarchar(max),NCHAR(36)) + N'("#dvIncidenciasTemp").height());
	var x = ((' + convert(nvarchar(max),NCHAR(36)) + N'("#"+id).offset()).left - ' + convert(nvarchar(max),NCHAR(36)) + N'("#dvIncidenciasTemp").width()) + ' + convert(nvarchar(max),NCHAR(36)) + N'("#"+id).width();
	' + convert(nvarchar(max),NCHAR(36)) + N'("#dvIncidenciasTemp").offset({top:y,left:x}).stop().fadeIn();
}

function asignarIncidencia(dis,inci){
	if(dis==="inciCliente"){ ' + convert(nvarchar(max),NCHAR(36)) + N'("#inciCliente").val(inci); }
	else{
		' + convert(nvarchar(max),NCHAR(36)) + N'("#inpIncidenciaSolImg"+dis.split("inpIncidenciaSol")[1]).attr("src","./Merlos/images/inciRed.png");
		' + convert(nvarchar(max),NCHAR(36)) + N'("#inpIncidenciaSolINP"+dis.split("inpIncidenciaSol")[1]).html(inci);
	}
	' + convert(nvarchar(max),NCHAR(36)) + N'("#dvIncidenciasTemp").remove();	
}

function observacionesArticulo(id){
	var ind = id.split("inpObservaSol")[1];
	var ta = ' + convert(nvarchar(max),NCHAR(36)) + N'("#dvIncidenciasTemp textarea").val();
	' + convert(nvarchar(max),NCHAR(36)) + N'("#inpObservaSolImg"+ind).attr("src","./Merlos/images/ojoRed.png");
	' + convert(nvarchar(max),NCHAR(36)) + N'("#inpObservaSolTA"+ind).val(ta);
	' + convert(nvarchar(max),NCHAR(36)) + N'("#dvIncidenciasTemp").remove();
}

/*  TV_LlamadasTV  **************************************************************************************************************** */
function cargarIncidencias(modo){
	var parametros = ''{"modo":"''+modo+''",''+paramStd+''}'';
	flexygo.nav.execProcess(''pIncidencias'','''',null,null,[{''key'':''parametros'',''value'':limpiarCadena(parametros)}],''modal640x480'',false,' + convert(nvarchar(max),NCHAR(36)) + N'(this),function(ret){
		if(ret){
			var js = JSON.parse(limpiarCadena(ret.JSCode));   
			window["dvIncidencias"+modo.toUpperCase()] = "";
			for(var i in js){ 
				window["dvIncidencias"+modo.toUpperCase()] += "<div class=''indiencia dvSub'' "
							  +  "onclick=''asignarIncidencia(' + convert(nvarchar(max),NCHAR(36)) + N'(this).parent().attr(\"data-id\"),\""+js[i].codigo+" - "+js[i].nombre+"\")''>"
							  +  js[i].codigo+" - "+js[i].nombre
							  +  "</div>";
			}
		}else{ alert("Error SP: pIncidencias!!!"+JSON.stringify(ret)); }
	},false);
}




function anyadirCliente(){
	if(new Date(fechaCambiaFormato(FechaTeleVenta)) < new Date(fechaCambiaFormato(fechaCorta()))){ alert("No se pueden asignar clientes a registros de días anteriores!"); return; }
	var contenidoDvLlamadas = ' + convert(nvarchar(max),NCHAR(36)) + N'("#dvLlamadas").html();
	' + convert(nvarchar(max),NCHAR(36)) + N'("#dvLlamadas").html("<div>"
						+ "	<div>Añadir Cliente al listado actual</div>"
						+ "	<input type=''text'' id=''inpAnyadirCli'' placeholder=''buscar...'' onkeyup=''buscarEnCampos(this.id,\"dvAnyadirCli\")''>"
						+ "	<div id=''dvAnyadirCli'' style=''height:250px; overflow:hidden; overflow-y:auto;''><div class=''taC vaM''>"+icoCargando16+" cargando clientes...</div></div>"
						+ "</div>");
	flexygo.nav.execProcess(''pClientesBasic'','''',null,null,[{''key'':''usuario'',''value'':currentReference},{''key'':''rol'',''value'':currentRole}],''modal640x480'',false,' + convert(nvarchar(max),NCHAR(36)) + N'(this),function(ret){
		if(ret){ 
			var contenido = "";
			var js = JSON.parse(limpiarCadena(ret.JSCode));
			if(js.clientes.length>0){
				for(var i in js.clientes){ 
					contenido += "<div class=''dvSub'' data-buscar=''"+js.clientes[i].codigo+" "+js.clientes[i].nombre+" "+js.clientes[i].nComercial+" "+js.clientes[i].CIF+" "+js.clientes[i].TELEFONO+"'' "
							  +  "onclick=''dvAnyadirCli_Click(\""+js.clientes[i].codigo+"\")''>"+js.clientes[i].codigo+" - "+js.clientes[i].nombre+"</div>";
				}
			}else{ contenido = "<div style=''text-align:center; color:red;''>Sin resultados!</div>";}
			' + convert(nvarchar(max),NCHAR(36)) + N'("#dvAnyadirCli").html(contenido)
		}else{ alert("Error SP: pClientesBasic!!!"+JSON.stringify(ret)); }
	},false);
}

function dvAnyadirCli_Click(cliente){
	' + convert(nvarchar(max),NCHAR(36)) + N'("#dvLlamadas").html("<div class=''taC vaM''>"+icoCargando16+" añadiendo el cliente "+cliente+" al listado...</div>");
	var parametros = ''{"modo":"anyadirCliente","IdTeleVenta":"''+IdTeleVenta+''","nombreTV":"''+NombreTeleVenta+''","FechaTeleVenta":"''+FechaTeleVenta+''"''
					+'',"cliente":"''+cliente+''",''+paramStd+''}'';
	flexygo.nav.execProcess(''pLlamadas'','''',null,null,[{''key'':''parametros'',''value'':limpiarCadena(parametros)}],''modal640x480'',false,' + convert(nvarchar(max),NCHAR(36)) + N'(this),function(ret){
		if(ret){
			if(ret.JSCode==="clienteExiste!"){ alert("El cliente ya existe en la lista actual!"); }
			recargarTVLlamadas();
		}else{ alert("Error SP: pLlamadas - dvAnyadirCli_Click!!!"+JSON.stringify(ret)); }
	},false);
}

function verDireccionesDelCliente(){
	if(!' + convert(nvarchar(max),NCHAR(36)) + N'("#thDirEntrega").hasClass("modifDir")){return;}
	' + convert(nvarchar(max),NCHAR(36)) + N'("#dvCliDir").stop().slideDown();
}

function asignarDireccionEntrega(direccion,linea){
	' + convert(nvarchar(max),NCHAR(36)) + N'("#tdDirEntrega").text(direccion);
	' + convert(nvarchar(max),NCHAR(36)) + N'("#inpDirEntrega").val(linea);
	' + convert(nvarchar(max),NCHAR(36)) + N'("#thDirEntrega").removeClass("fadeIO");
	' + convert(nvarchar(max),NCHAR(36)) + N'("#tdDirEntrega").css("background","#C5FFF7");
	' + convert(nvarchar(max),NCHAR(36)) + N'(document).click();
}
',1,NULL,0,0,0,NULL,0,1)
 ,(N'Vendedor',N'generic',NULL,N'webdefault',N'default',N'Vendedor',N'noicon',N'Vendedor',NULL,NULL,0,NULL,0,0,0,NULL,0,1)
) AS Source ([PageName],[TypeId],[ObjectName],[InterfaceName],[LayoutName],[Name],[IconName],[Descrip],[UrlRewrite],[Script],[ScriptActive],[Style],[RefreshInterval],[Sytem],[Generic],[BodyCssClass],[Offline],[OriginId])
ON (Target.[PageName] = Source.[PageName])
WHEN MATCHED AND (
	NULLIF(Source.[TypeId], Target.[TypeId]) IS NOT NULL OR NULLIF(Target.[TypeId], Source.[TypeId]) IS NOT NULL OR 
	NULLIF(Source.[ObjectName], Target.[ObjectName]) IS NOT NULL OR NULLIF(Target.[ObjectName], Source.[ObjectName]) IS NOT NULL OR 
	NULLIF(Source.[InterfaceName], Target.[InterfaceName]) IS NOT NULL OR NULLIF(Target.[InterfaceName], Source.[InterfaceName]) IS NOT NULL OR 
	NULLIF(Source.[LayoutName], Target.[LayoutName]) IS NOT NULL OR NULLIF(Target.[LayoutName], Source.[LayoutName]) IS NOT NULL OR 
	NULLIF(Source.[Name], Target.[Name]) IS NOT NULL OR NULLIF(Target.[Name], Source.[Name]) IS NOT NULL OR 
	NULLIF(Source.[IconName], Target.[IconName]) IS NOT NULL OR NULLIF(Target.[IconName], Source.[IconName]) IS NOT NULL OR 
	NULLIF(Source.[Descrip], Target.[Descrip]) IS NOT NULL OR NULLIF(Target.[Descrip], Source.[Descrip]) IS NOT NULL OR 
	NULLIF(Source.[UrlRewrite], Target.[UrlRewrite]) IS NOT NULL OR NULLIF(Target.[UrlRewrite], Source.[UrlRewrite]) IS NOT NULL OR 
	NULLIF(Source.[Script], Target.[Script]) IS NOT NULL OR NULLIF(Target.[Script], Source.[Script]) IS NOT NULL OR 
	NULLIF(Source.[ScriptActive], Target.[ScriptActive]) IS NOT NULL OR NULLIF(Target.[ScriptActive], Source.[ScriptActive]) IS NOT NULL OR 
	NULLIF(Source.[Style], Target.[Style]) IS NOT NULL OR NULLIF(Target.[Style], Source.[Style]) IS NOT NULL OR 
	NULLIF(Source.[RefreshInterval], Target.[RefreshInterval]) IS NOT NULL OR NULLIF(Target.[RefreshInterval], Source.[RefreshInterval]) IS NOT NULL OR 
	NULLIF(Source.[Sytem], Target.[Sytem]) IS NOT NULL OR NULLIF(Target.[Sytem], Source.[Sytem]) IS NOT NULL OR 
	NULLIF(Source.[Generic], Target.[Generic]) IS NOT NULL OR NULLIF(Target.[Generic], Source.[Generic]) IS NOT NULL OR 
	NULLIF(Source.[BodyCssClass], Target.[BodyCssClass]) IS NOT NULL OR NULLIF(Target.[BodyCssClass], Source.[BodyCssClass]) IS NOT NULL OR 
	NULLIF(Source.[Offline], Target.[Offline]) IS NOT NULL OR NULLIF(Target.[Offline], Source.[Offline]) IS NOT NULL OR 
	NULLIF(Source.[OriginId], Target.[OriginId]) IS NOT NULL OR NULLIF(Target.[OriginId], Source.[OriginId]) IS NOT NULL) THEN
 UPDATE SET
  [TypeId] = Source.[TypeId], 
  [ObjectName] = Source.[ObjectName], 
  [InterfaceName] = Source.[InterfaceName], 
  [LayoutName] = Source.[LayoutName], 
  [Name] = Source.[Name], 
  [IconName] = Source.[IconName], 
  [Descrip] = Source.[Descrip], 
  [UrlRewrite] = Source.[UrlRewrite], 
  [Script] = Source.[Script], 
  [ScriptActive] = Source.[ScriptActive], 
  [Style] = Source.[Style], 
  [RefreshInterval] = Source.[RefreshInterval], 
  [Sytem] = Source.[Sytem], 
  [Generic] = Source.[Generic], 
  [BodyCssClass] = Source.[BodyCssClass], 
  [Offline] = Source.[Offline], 
  [OriginId] = Source.[OriginId]
WHEN NOT MATCHED BY TARGET THEN
 INSERT([PageName],[TypeId],[ObjectName],[InterfaceName],[LayoutName],[Name],[IconName],[Descrip],[UrlRewrite],[Script],[ScriptActive],[Style],[RefreshInterval],[Sytem],[Generic],[BodyCssClass],[Offline],[OriginId])
 VALUES(Source.[PageName],Source.[TypeId],Source.[ObjectName],Source.[InterfaceName],Source.[LayoutName],Source.[Name],Source.[IconName],Source.[Descrip],Source.[UrlRewrite],Source.[Script],Source.[ScriptActive],Source.[Style],Source.[RefreshInterval],Source.[Sytem],Source.[Generic],Source.[BodyCssClass],Source.[Offline],Source.[OriginId])
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





