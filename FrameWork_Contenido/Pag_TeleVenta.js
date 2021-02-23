$("#mainNav").hide();

var ClienteCodigo = "";
var ctvll = "";
var PedidoGenerado = ""; 


if((flexygo.history.get($('main')).defaults)!==null){
	var elJSON = JSON.parse(flexygo.history.get($('main')).defaults);
	ClienteCodigo = elJSON.CODIGO;
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
	PedidoDetalle = "";	
	$("#btnPedido").text("Pedido");
	$(".moduloTV, #btnConfiguracion").stop().fadeIn();
	$(".moduloPedido").hide();
	recargarTVLlamadas();
}

function recargarTVLlamadas(){ 
	abrirVelo(icoCargando16 + " recargando datos...");
	tbLlamadasGlobal_Sel(FechaTeleVenta, NombreTeleVenta); 
	setTimeout(function(){ tbLlamadasGlobal_Sel(FechaTeleVenta, NombreTeleVenta); cerrarVelo(); },1000);
}

function configurarTeleVenta(tf){ console.log("configurarTeleVenta()");
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
	var parametros = '{"modo":"estadisticas","FechaTeleVenta":"'+FechaTeleVenta+'","nombreTV":"'+NombreTeleVenta+'",'+paramStd+'}';
	console.log("estTV - parametros:\n"+parametros);
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

function pedidoTV(){ 
	if(new Date(fechaCambiaFormato(FechaTeleVenta)) < new Date(fechaCambiaFormato(fechaCorta()))){ alert("No se pueden crear pedidos de días anteriores!"); return; }

	if(ClienteCodigo===""){ alert("Debes seleccionar un cliente!"); return; }
	if($("#btnPedido").text()==="Pedido"){
		$("#btnPedido").text("TeleVenta");
		$("#dvDatosDelClienteMin").html(datosDelCliente);
		$(".moduloTV, #btnConfiguracion").hide();
		$(".moduloPedido").stop().fadeIn();
		cargarArticulosDisponibles(ClienteCodigo);
	}else{
		$("#btnPedido").text("Pedido");
		$(".moduloTV, #btnConfiguracion").stop().fadeIn();
		$(".moduloPedido").hide();
	}
}

function cargarSubDatos(objeto,cliente,id,pos){ console.log("cargarSubDatos("+objeto+","+cliente+","+id+","+pos+")");
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
			}else{ contenido="<div style='color:red;'>Sin resultados!</div>"; }
			if(objeto==="inciArt"){
				var inciAsig = $("#inpIncidenciaSolINP"+id.split("inpIncidenciaSol")[1]).val();
				if(inciAsig!==""){ contenido = "<div class='dvSubI' onclick='desasignarCliArt(\""+objeto+"\",\""+cliente+"\",\""+id+"\",\""+pos+"\")'>Asignado: "+inciAsig+"</div><br>" + contenido; }
			}
		}else{ contenido="<div style='color:red;'>Sin resultados!</div>"; }
		$("#dvDatosTemp").html(contenido);
	}else{ $("#dvDatosTemp").remove(); alert('Error S.P. pSeries!\n'+JSON.stringify(ret)); } }, false);
}

function asignarObjetoDatos(id,txt){ console.log("asignarObjetoDatos("+id+","+txt+")");
	if(Left(id,16)==="inpIncidenciaSol"){ 
		var idN = id.split("inpIncidenciaSol")[1];
		id="inpIncidenciaSolINP"+idN;
		$("#inpIncidenciaSolImg"+idN).attr("src","./Merlos/images/inciRed.png");
	}
	$("#"+id).val(txt);
	$("#dvDatosTemp").fadeOut(); 
}

function desasignarCliArt(objeto,cliente,id,pos){
	$("#inpIncidenciaSolINP"+id.split("inpIncidenciaSol")[1]).val("");
	$("#inpIncidenciaSolImg"+id.split("inpIncidenciaSol")[1]).attr("src","./Merlos/images/inciGris.png");
	cargarSubDatos(objeto,cliente,id,pos);
}


/*  TV_Cliente  **************************************************************************************************************** */

var elVendedor = "";
var datosDelCliente = "";
	
function cargarTeleVentaCliente(CliCod){ console.log("cargarTeleVentaCliente("+CliCod+")");
	ClienteCodigo=CliCod;
	var parametros = '{"cliente":"'+ClienteCodigo+'","FechaTeleVenta":"'+FechaTeleVenta+'"}';
	flexygo.nav.execProcess('pClienteDatos','',null,null,[{'key':'parametros','value':limpiarCadena(parametros)}],'modal640x480',false,$(this),function(ret){
		if(ret){
			if(ret.JSCode===""){ return; }
			var contenido = "";
			datosDelCliente = "";
			var js = JSON.parse(limpiarCadena(ret.JSCode));
			if(js.length>0){
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
					+"  <tr><th colspan='4'>Observaciones</th></tr>"
					+"  <tr><td colspan='4'><textarea style='width:100%; height:50px;' disabled>"+js[0].OBSERVACIO+"</textarea></td></tr>"
					+"</table>";
				
				var btnOfertas = "inv";
				if(js[0].OFERTA==="1" || js[0].OFERTA==="true" || js[0].OFERTA===true){ btnOfertas = ""; }
				
				var fe = $.trim(js[0].FechaEntrega);
				if((fe.split("-")[0]).length===4){ fe = fe.substr(8,2)+"-"+fe.substr(5,2)+"-"+fe.substr(0,4); }
				
				datosDelCliente = "<div style='background:#fff;'>"
								+ "		<table class='tbStdC' style='margin:5px;'>"
								+ "			<tr>"
								+ "				<td style='width:400px;'>"
								+ "					<div class='esq05' style='padding:10px;box-sizing:border-box;background:#323f4b;color:#FFF;'>"
								+ "						("+js[0].CODIGO+") "+js[0].NOMBRE+""
								+ "						<br>"+js[0].RCOMERCIAL+" ("+js[0].POBLACION+")"
								+ "						<br>e-mail: "+js[0].EMAIL+""
								+ "						<br>teléfono: "+js[0].TELEFONO+""
								+ "					</div>"
								+ "				</td>"
								+ "				<td style='width:400px;'>"
								+ "					<table class='tbStdC'>"
								+ "						<tr>"
								+ "							<td class='vaM pl20' style='width:180px;'>Contacto</td>"
								+ "							<td>"
								+ "								<input type='text' id='inpDataContacto' style='text-align:left; color:#333;' "
								+ "								onclick='cargarSubDatos(\"contactos\",\""+ClienteCodigo+"\",this.id,0);event.stopPropagation();'>"
								+ "							</td>"
								+ "						<tr>"
								+ "							<td class='vaM pl20'>Fecha Entrega</td>"
								+ "							<td>"
								+ "								<input type='text' id='inpFechaEntrega' style='text-align:center; color:#333;' "
								+ "								onkeyup='calendarioEJGkeyUp(this.id,this.value)' "
								+ "								onclick='mostrarElCalendarioEJG(this.id,true);event.stopPropagation();' "
								+ "								value='"+fe+"'>"
								+ "							</td>"
								+ "						</tr>"
								+ "						<tr>"
								+ "							<td class='vaM pl20'>Incidencia Cliente</td>"
								+ "							<td>"
								+ "								<input type='text' id='inciCliente'"
								+ "								onclick='cargarSubDatos(\"inciCli\",\""+ClienteCodigo+"\",this.id,0);event.stopPropagation();' >"
								+ "							</td>"
								+ "						</tr>"	
								+ "					</table>"
								+ "				</td>"
								+ "				<td class='vaT pl20'>"
								+ "					Observaciones"
								+ "					<br>"
								+ "					<textarea id='taObservacionesDelPedido' style='width:98%;height:80px;padding:5px;box-sizing:border-box;'></textarea>"
								+ "				</td>"
								+ "				<td id='tdOfertas' class='vaM pl20 taC "+btnOfertas+"' style='width:150px;'>"
								+ "					<span class='MIbtnF' style='padding:20px;' onclick='ofertasDelCliente()'>Ofertas</span>"
								+ "				</td>"
								+ "			</tr>"
								+ "		</table>"
								+ "</div>";				
			}else{ contenido = "No se han obtenido resultados!"; }
			$("#dvDatosDelCliente").html(contenido);
			elVendedor = js[0].VENDEDOR;	
		}else{ alert("Error SP: pClientesADI!"+JSON.stringify(ret)); }
	},false);
}

function verFichaDeCliente(){ 
	if(ClienteCodigo===""){ alert("Ningún cliente seleccionado!"); return; }
	flexygo.nav.openPage('view','Cliente','CODIGO=\''+ClienteCodigo+'\'','{\'CODIGO\':\''+ClienteCodigo+'\'}','current',false,$(this)); 
}

function ofertasDelCliente(){
	var parametros = '{"modo":"ofertasDelCliente","cliente":"'+ClienteCodigo+'",'+paramStd+'}'; 	
	flexygo.nav.execProcess('pOfertas','',null,null,[{'Key':'parametros','Value':limpiarCadena(parametros)}],'modal640x480',false,$(this),function(ret){
		if(ret){ 
			/**/ console.log("pOfertas ret: "+ret.JSCode);
		}
		else{ alert("Error pOfertas!\n"+JSON.stringify(ret)); }
	 },false);
}

function verTodosLosTelfs(){ console.log("verTodosLosTelfs("+ClienteCodigo+")");
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
function cargarTeleVentaLlamadas(modo){  console.log("cargarTeleVentaLlamadas("+modo+")");	
	ctvll = modo;
	var elDV = "dvLlamadas";
	var contenido = "";
	var parametros = '{"modo":"'+modo+'","cliente":"'+ClienteCodigo+'","nombreTV":"'+NombreTeleVenta+'","FechaTeleVenta":"'+FechaTeleVenta+'","usuariosTV":'+UsuariosTV+','+paramStd+'}'; 	
	/**/ console.log("cargarTeleVentaLlamadas parametros: \n"+parametros);
	flexygo.nav.execProcess('pLlamadas','',null,null,[{'key':'parametros','value':limpiarCadena(parametros)}],'modal640x480',false,$(this),function(ret){
		if(ret){
			if(ret.JSCode===""){ contenido = "No se han obtenido resultados!"; }				
			else{ 
				contenido = "";
				
				var js = JSON.parse(limpiarCadena(ret.JSCode));
				if(js.length>0){
					contenido += "<div style='height:275px; overflow:hidden; overflow-y:auto;'>";
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
									+"	</tr>";
					}
					
					for(var i in js){
						var elPedido = $.trim(js[i].serie)+" - "+$.trim(js[i].pedido);
						if($.trim(js[i].serie)===""){ elPedido=""; }
						if($.trim(js[i].pedido).indexOf("NO!")!==-1){ elPedido = "INCIDENCIA"; }
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
							if($.trim(js[i].completado)==="1"){ elBG = "style='background:#FFCFCF;'"; } 
							contenido += "<tr "+elBG+" onclick='TV_SelecionarCliente(\""+$.trim(js[i].cliente)+"\")'>"
									  +"	<td>"+$.trim(js[i].cliente)+"</td>"
									  +"	<td>"+$.trim(js[i].NOMBRE)+"</td>"
									  +"	<td style='text-align:center;'>"+$.trim(js[i].horario)+"</td>"
									  +"	<td data-completado='"+$.trim(js[i].completado)+"' style='text-align:center;'>"+$.trim(js[i].nCompletado)+"</td>"
									  +"	<td style='text-align:right;'>"+elPedido+"</td>"
									  +"</tr>";
						}
						if(modo==="listaGlobal"){							
							contenido += "<tr onclick='tbLlamadasGlobal_Sel(\""+$.trim(js[i].fecha)+"\",\""+$.trim(js[i].nombreTV)+"\")'>"
									  +"	<td>"+$.trim(js[i].fecha)+"</td>"
									  +"	<td class='rolTeleVentaO'>"+$.trim(js[i].usuario)+"</td>"
									  +"	<td>"+$.trim(js[i].nombreTV)+"</td>"
									  +"</tr>";
							elDV = "dvLlamadasTeleVenta";
						}
					}
					contenido += "</table></div>";					
				}else{ contenido = "Sin registros!"; }
			}
			$("#"+elDV).html(contenido);
			if(currentRole==="TeleVenta"){ $(".rolTeleVentaO").hide(); }
		}else{ alert("Error SP: pLlamadas!!!"+JSON.stringify(ret)); }
	},false);
}

function tbLlamadasGlobal_Sel(fecha,nombre){ console.log("tbLlamadasGlobal_Sel("+fecha+","+nombre+")");
	$("#inpFechaTV").val(fecha);
	$("#inpNombreTV").val(nombre);
	FechaTeleVenta = fecha;
	NombreTeleVenta = nombre;
	cargarTbConfigOperador("cargar");
	configurarTeleVenta();
}

function asignarserieconfig(){
	var serie = $.trim($("#inpLLBserieConfig").val()); 
	flexygo.nav.execProcess('pConfiguracion','',null,null,[{'Key':'modo','Value':'TVSerie'},{'Key':'valor','Value':serie}],'modal640x480', false, $(this), function(ret){if(ret){
		$("#spanAsignacionSerieAviso").fadeIn(); // SERIE = serie;
		setTimeout(function(){ $("#spanAsignacionSerieAviso").fadeOut(); },2000);
	}else{ alert("Error SP: pConfiguracion!!!\n"+ret); }}, false);
}

function TV_SelecionarCliente(cliente){ console.log("TV_SelecionarCliente("+cliente+")");
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

function cargarTeleVentaUltimosPedidos(ClienteCodigo){ console.log("cargarTeleVentaUltimosPedidos("+ClienteCodigo+")");
	var parametros = '{"cliente":"'+ClienteCodigo+'",'+paramStd+'}';   console.log("pUltimosPedidos parametros:\n("+parametros+")");
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
						+   "</tr>";
			var js = JSON.parse(limpiarCadena(ret.JSCode));
			if(js.length>0){
				for(var i in js){
					contenido += "<tr onclick='ultimoArticulo_Click(\""+$.trim(js[i].ARTICULO)+"\")'>"
							  +"	<td onmouseover='verPedidoDetalle(\""+$.trim(js[i].IDPEDIDO)+"\",\""+$.trim(js[i].LETRA)+"-"+$.trim(js[i].numero)+"\","+i+")'>"+$.trim(js[i].FECHA)+"</td>"
							  +"	<td class='C' onmouseover='verPedidoDetalle(\""+$.trim(js[i].IDPEDIDO)+"\",\""+$.trim(js[i].LETRA)+"-"+$.trim(js[i].numero)+"\","+i+")'>"+$.trim(js[i].LETRA)+"-"+$.trim(js[i].numero)+"</td>"
							  +"	<td class='C' onmouseover='verPedidoDetalle(\""+$.trim(js[i].IDPEDIDO)+"\",\""+$.trim(js[i].LETRA)+"-"+$.trim(js[i].numero)+"\","+i+")'>"+$.trim(js[i].ENTREGA)+"</td>"
							  +"	<td class='C' >"+$.trim(js[i].RUTA)+"</td>"
							  +"	<td class='C' >"+$.trim(js[i].ESTADO)+"</td>"
							  +"	<td class='L' style='overflow:hidden;'>"+$.trim(js[i].OBSERVACIO)+"</td>"
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
	var elTR = "#trID"+i;
	if($(elTR).is(":visible")){ return; }
	$(".VelotrID").remove();
	var y = event.clientY;	
	var contenido = icoCargando16+" cargando lineas del pedido "+pedido+"..."; 
	$("body").prepend("<div id='trID"+i+"' class='VelotrID c_trID inv'>"+contenido+"</div>");
	contenido =  "<span style='font:bold 16px arial; color:#666;'>Datos del pedido "+pedido+"</span>"
			    +"<br>"
			    +"<table id='tbPedidosDetalle' class='tbStd'>"
				+"	<tr>"
				+"		<th>Artículo</th>"
				+"		<th>Descipción</th>"
				+"		<th class='C'>Cajas</th>"
				+"		<th class='C'>Uds.</th>"
				+"		<th class='C'>Peso</th>"
				+"		<th class='C'>Precio</th>"
				+"		<th class='C'>Dto</th>"
				+"		<th class='C'>Importe</th>"
				+"	</tr>"; 
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
				contenido += "</table>";
			}else{ contenido = "No se han obtenido resultados!"; }
			$(elTR).html(contenido).off().on("mouseout",function(){ $(elTR).remove(); });
			var lft = "100"; if($("#mainNav").is(":visible")){ lft="300px"; }
			$(elTR).css("left",lft).css("top",y).fadeIn();
		}else{ alert("Error SP: pPedidoDetalle!!!"+JSON.stringify(ret)); }
	},false);	
}



/*  TV_Pedido  **************************************************************************************************************** */

var PedidoActivo = "";
var PedidoActivoNum = "";
var PedidoModo = "crear";
var PedidoDetalle = "";
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

function cargarArticulosDisponibles(modo){ console.log("cargarArticulosDisponibles("+modo+")");
	$("#spanBotoneraPag , #spResultados, #dvPersEP_Articulos").hide();
	$("#spanPersEPinfo").fadeIn(300,function(){
		var varios = "paginar";
		var celdaValor = "";
		var esconder_spResBtn=false; 
		var registrosTotales = 0;
		var elSP = "pArticulosBuscar";	
		var parametros = '{"registros":'+paginadorRegistros+',"buscar":"'+$.trim($("#inpBuscarArticuloDisponible").val())+'","cliente":"'+ClienteCodigo+'","fechaTV":"'+FechaTeleVenta+'","nombreTV":"'+NombreTeleVenta+'",'+paramStd+'}';
		if(modo){ elSP = "pArticulosCliente"; }

		flexygo.nav.execProcess(elSP,'',null,null,[{"Key":"parametros","Value":limpiarCadena(parametros)}],'modal640x480',false,$(this),function(ret){
			if(ret){
				var respuesta = limpiarCadena(ret.JSCode); if(respuesta===""){ respuesta = "[]";} 
				var contenido="";
				var art = JSON.parse(respuesta);
				if(art.length>0){
					registrosTotales = art[0].registros;
					var contenidoCab = "";
					if(modo){ 
						contenidoCab +="<tr>"
									 + "	<th colspan='2'></th>"
									 + "	<th colspan='3' style='text-align:center; background:rgb(73, 133, 214);'>Última Venta</th>"
									 + "	<th colspan='8'></th>";
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
								 +  "	<th style='width:5%; text-align:center;'>Precio</th>"
								 +  "	<th style='width:5%; text-align:center;'>Dto.</th>"
								 +  "	<th style='width:5%; text-align:center;'>Importe</th>"
								 +  "	<th style='width:40px; text-align:center; box-sizing:border-box;'><img src='./Merlos/images/inci.png' width='20'></th>"
								 +  "	<th style='width:40px; text-align:center; box-sizing:border-box;'><img src='./Merlos/images/ojo.png' width='20'></th>"
								 +  "</tr>";
					$("#tbPersEP_ArticulosCab").html(contenidoCab);
					
					for(var i in art){
						var CajasIO = "";
						var UdsIO = "";
						var PesoIO = "";
						var elPedUniCaja ="0"; 
						var elPeso = $.trim(art[i].peso); if(elPeso==="" || elPeso===null){ elPeso="0"; }				
						var elPedUniCajaValor = elPedUniCaja; if(elPedUniCajaValor==="0"){ elPedUniCajaValor=""; }
						var elPesoValor = elPeso; if(elPesoValor==="0"){ elPesoValor=""; }
						var omHover = "";
						if(modo){ 
							stockVirtual = parseInt(art[i].StockVirtual); 
							elPeso = $.trim(art[i].peso); if(elPeso==="" || elPeso===null){ elPeso="0"; }	
							elPedUniCaja = $.trim(art[i].articulo[0].UNICAJA); 
							if(elPedUniCaja==="" || elPedUniCaja===null){ elPedUniCaja="0"; }	
							if(parseFloat(elPedUniCaja)>0){ }else{ CajasIO="readonly disabled"; }
							if(parseFloat(art[i].articulo[0].peso)>0){ }else{ PesoIO="readonly disabled"; }	
							omHover="onmouseover='articuloCliente(\"tbArtDispTR"+i+"\")'";
						}else{
							elPedUniCaja = $.trim(art[i].UNICAJA); 
							if(parseFloat(elPedUniCaja)>0){ }else{ CajasIO="readonly disabled"; }
							if(parseFloat(elPeso)>0){ }else{ PesoIO="readonly disabled"; }	
						}						
						
						contenido 	+= "<tr id='tbArtDispTR"+i+"' class='trBsc' data-json='{\"articulo\":\""+art[i].CODIGO+"\"}'"
									+  "data-art='"+art[i].CODIGO+"' data-nom='"+art[i].NOMBRE+"'";
						if(modo){ contenido +=   "data-artdata='"+JSON.stringify(art[i].articulo[0].pedidos)+"'"; }
						contenido 	+= ">"
									+"	<td class='trBscCod' style='width:10%;' "+omHover+" >"+art[i].CODIGO+"</td>"
									+"	<td class='trBscNom'>"+art[i].NOMBRE+"</td>";
						if(modo){ 
							contenido += "<td class='C' style='width:5%;'>"+art[i].CajasALB+"</td>"
									  +  "<td class='C' style='width:5%;'>"+art[i].UnidadesALB+"</td>"
									  +  "<td class='C' style='width:5%;'>"+art[i].PesoALB+"</td>";
						}						
						contenido += " 	<td class='C trBscCajas inv' style='width:10%;'>"+elPedUniCaja+"</td>"
									+"	<td class='C' style='width:5%;'>"
									+"		<input type='text' class='inpCajasSol' "
									+"		onkeyup='$(this).css(\"color\",\"#000\"); calcCUP(\"cajas\",\"tbArtDispTR"+i+"\","+elPedUniCaja+","+elPeso+",false);' "
									+"		onfocus='celdaValor=this.value' "
									+"		onfocusout='if(celdaValor!==this.value){calcCUP(\"cajas\",\"tbArtDispTR"+i+"\","+elPedUniCaja+","+elPeso+",true);}' "
									+"		onclick='$(this).select();' "+CajasIO+">"
									+"	</td>"
									+"	<td class='C' style='width:5%;'>"
									+"		<input type='text' class='inpCantSol' "
									+"		onkeyup='$(this).css(\"color\",\"#000\"); calcCUP(\"uds\",\"tbArtDispTR"+i+"\","+elPedUniCaja+","+elPeso+",false);' "
									+"		onfocus='celdaValor=this.value' "
									+"		onfocusout='if(celdaValor!==this.value){calcCUP(\"uds\",\"tbArtDispTR"+i+"\","+elPedUniCaja+","+elPeso+",true);}' "
									+"		onclick='$(this).select();' "+UdsIO+">"
									+"	</td>"
									+"	<td class='C' style='width:5%;'>"
									+"		<input type='text' class='inpPesoSol C' "
									+"		onkeyup='$(this).css(\"color\",\"#000\"); calcCUP(\"peso\",\"tbArtDispTR"+i+"\","+elPedUniCaja+","+elPeso+",false);' "
									+"		onfocus='celdaValor=this.value' "
									+"		onfocusout='if(celdaValor!==this.value){calcCUP(\"peso\",\"tbArtDispTR"+i+"\","+elPedUniCaja+","+elPeso+",true);}' "
									+"		onclick='$(this).select();' "+PesoIO+">"
									+"	</td>"
									+"	<td id='precioTD"+i+"' class='C' style='width:5%;'>"
									+"		<span class='flx-icon icon-sincronize-1 rotarR' style='font-size:12px; color:green;'></span>"
									+"  </td>"
									+"	<td id='DtoTD"+i+"' class='C' style='width:5%;'>"
									+"		<span class='flx-icon icon-sincronize-1 rotarR' style='font-size:12px; color:orange;'></span>"
									+"  </td>"
									+"	<td class='inpImporteSol R' style='width:5%;'></td>"
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
					
					$("#tbPersEP_Articulos").html(contenido).off().on("mouseout",function(){ $("#trID").remove(); });
					
					obtenerPreciosYOfertas(modo);
					
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

function obtenerPreciosYOfertas(modo){
	$("#tbPersEP_Articulos").find("tr").each(function(){
		var i = ($(this).attr("id")).split("tbArtDispTR")[1];
		var dtJS = $(this).attr("data-json");
		var js = JSON.parse(dtJS);
		var articulo = js.articulo;
		// obtener precio del artículo según cliente y cantidad
		(function(i){
			var paramPreciosTabla = '{'
									+'"empresa":"'+flexygo.context.CodigoEmpresa+'"'
									+',"cliente":"'+ClienteCodigo+'"'
									+',"articulo":"'+articulo+'"'
									+',"unidades":"1"'
									+',"FechaTeleVenta":"'+FechaTeleVenta+'"'
									+',' + paramStd
									+'}'; 
			flexygo.nav.execProcess('pPreciosTabla','',null,null,[{'Key':'parametros','Value':limpiarCadena(paramPreciosTabla)}],'modal640x480',false,$(this),function(ret){
				if(ret){
					try{										
						var js = JSON.parse(limpiarCadena(ret.JSCode));
						var PC = js[0].precio; if(isNaN(PC) || PC===""){ PC=0; }
						var DT = js[0].dto;    if(isNaN(DT) || DT===""){ DT=0; }
						$("#precioTD"+i).html(
							"<input type='text' class='inpPrecioSol' onkeyup='$(this).css(\"color\",\"#000\"); calcularImporte(\"tbArtDispTR"+i+"\")' "
							+"onclick='$(this).select();' "
							+"value='"+parseFloat(PC).toFixed(2)+"'>"
						);
						$("#DtoTD"+i).html(
							"<input type='text' class='inpDtoSol' onkeyup='$(this).css(\"color\",\"#000\");  calcularImporte(\"tbArtDispTR"+i+"\")' "
							+"onclick='$(this).select();' "
							+"value='"+parseFloat(DT).toFixed(2)+"'>"
						);
					}
					catch{ console.log("Error JSON pPreciosTabla!\n"+JSON.stringify(ret)); }									
				}
				else{ alert("Error pPreciosTabla!\n"+JSON.stringify(ret)); }
			 },false);
		}(i));

		// obtener ofertas del artículo
		if(modo){ 
			var param = '{"articulo":"'+articulo+'","fecha":"'+FechaTeleVenta+'",'+paramStd+'}';
			(function(i){
				flexygo.nav.execProcess('pOfertas','',null,null,[{'Key':'parametros','Value':limpiarCadena(param)}],'modal640x480',false,$(this),function(ret){
					if(ret){ 
						var jsO = JSON.parse(limpiarCadena(ret.JSCode));
						if(jsO.length>0){ 
							$('#tbArtDispTR'+i).find("td").css("background","#D1FFD9"); 
							if(parseFloat(jsO[0].PVP)>0){ $('#tbArtDispTR'+i).find(".inpPrecioSol").val(parseFloat(jsO[0].PVP).toFixed(2)); }
							if(parseFloat(jsO[0].DTO1)>0){ $('#tbArtDispTR'+i).find(".inpDtoSol").val(parseFloat(jsO[0].DTO1).toFixed(2)); }
						}
					}
					else{ alert("Error pOfertas!\n"+JSON.stringify(ret)); }
				 },false);
			}(i));
		}
	});
}

function articuloCliente(trid){
	$("#trID").remove();
	var y = event.clientY;
	var art = JSON.parse($("#"+trid).attr("data-artdata"));
	var contenido = "<table class='tbStd'>"
					+"	<tr>"
					+"		<th class='C'>Fecha</th>"
					+"		<th>Albarán</th>"
					+"		<th class='C'>Cajas</th>"
					+"		<th class='C'>Uds.</th>"
					+"		<th class='C'>Peso</th>"
					+"		<th class='C'>Precio</th>"
					+"		<th class='C'>Dto</th>"
					+"		<th class='C'>Importe</th>"
					+"	</tr>";  
	for(var i in art[0].d){ 
		var cajas = art[0].d[i].cajas; if(isNaN(cajas) || cajas===0){ cajas="";}
		var peso = art[0].d[i].PESO; if(isNaN(peso) || peso===0){ peso="";}else{ peso = parseFloat(peso).toFixed(2); }
		var dto = art[0].d[i].DTO1; if(isNaN(dto) || dto===0){ dto="";}else{ dto = parseFloat(dto).toFixed(2); }
		var precio = art[0].d[i].precio; if(isNaN(precio) || precio===0){ precio="";}else{ precio = parseFloat(precio).toFixed(2)+" &euro;"; }
		contenido += "<tr>"
					+"	<td class='C'>"+art[0].fecha+"</td>"
					+"	<td>"+$.trim(art[0].d[i].ALBARAN)+"</td>"
					+"	<td class='C'>"+cajas+"</td>"
					+"	<td class='C'>"+art[0].d[i].UNIDADES+"</td>"
					+"	<td class='C'>"+peso+"</td>"
					+"	<td class='C'>"+precio+"</td>"
					+"	<td class='C'>"+dto+"</td>"
					+"	<td class='R'>"+art[0].d[i].IMPORTEf+"</td>"
					+"</tr>";
	}
	$("body").prepend("<div id='trID' class='c_trID'>"
					+" 		<span style='font:bold 16px arial; color:#666;'>"
					+			$("#"+trid).attr("data-art")+" - "+$("#"+trid).attr("data-nom")
					+" 		</span>"
					+" 		<br>"+contenido
					+"	</div>"
					+"</table>");
	var lft = "100px"; if($("#mainNav").is(":visible")){ lft="300px"; }
	$("#trID").css("left",lft).css("top",y);
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

function pedidoAnyadirDetalle(){
	$("#tbPersEP_Articulos").find(".trBsc").each(function(){ 
		 var cod = $(this).find(".trBscCod").text();
		 var cjs = parseFloat($(this).find(".inpCajasSol").val());
		 var can = parseFloat($(this).find(".inpCantSol").val()); 		 
		 var cajas = parseFloat($(this).find(".trBscCajas").text()); 
		 var StockVirtual = parseFloat($(this).find(".tdBscStockVirtual").text()); 
		 var maxPed = parseFloat($(this).find(".tdBscMaxPed").text());		
		 var peso = parseFloat($(this).find(".inpPesoSol").val());			if(isNaN(peso)){ peso=0; }	
		 var precio = parseFloat($(this).find(".inpPrecioSol").val());		if(isNaN(precio)){ precio=0; }	
		 var dto = parseFloat($(this).find(".inpDtoSol").val());			if(isNaN(dto)){ dto=0; }	
		 var importe = parseFloat($(this).find(".inpImporteSol").text());	if(isNaN(importe)){ importe=0; }	
		 var incidencia = ($(this).find(".trInciArt").val()).split(" - ")[0];
		 var incidenciaDescrip = ($(this).find(".trInciArt").val()).split(" - ")[1];
		 var observacion = $(this).find(".trObservaArt").val();

		if(parseFloat(cjs)>0 || parseFloat(can)>0 || parseFloat(peso)>0){	
			// añadimos la linea
			PedidoDetalle += '{"codigo":"'+cod+'","unidades":"'+can+'","peso":"'+peso+'","precio":"'+precio+'","dto":"'+dto+'","importe":"'+importe+'"'
			+',"artUnicaja":"'+cajas+'","incidencia":"'+incidencia+'","incidenciaDescrip":"'+incidenciaDescrip+'","observacion":"'+observacion+'"}';
		}		
	});	
	// tratamos los resultados
	if(PedidoDetalle.length<1){ alert("No se han seleccionado cantidades del listado!"); }
	else{ pedidoVerDetalle(); }
	$(".inpCajasSol,.inpCantSol,.inpPesoSol,.inpP").val("");
	$(".inpImporteSol").html("");
}

function ultimoArticulo_Click(art){/* $("#inpBuscarArticuloDisponible").val(art); buscarArticuloDisponible(window.event.keyCode=13);*/ }

function pedidoVerDetalle(){	
	if(PedidoDetalle.length>0){
		var elTotal = 0.00;
		var contenido =  "<br><table id='tbPedidoDetalle' class='tbStd'>"
					  +  "	<tr>"
					  +  "	<th colspan='7' style='vertical-align:middle; background:#CCC;'>Líneas del Pedido</th>"
					  +  "	</tr>"
					  +  "	<tr>"
					  +  "		<th style='width:50px;'></th>"
					  +  "		<th>código</th>"
					  +  "		<th class='taC' style='width:80px;'>unidades</th>"
					  +  "		<th class='taC' style='width:80px;'>peso</th>"
					  +  "		<th class='taC' style='width:80px;'>precio</th>"
					  +  "		<th class='taC' style='width:80px;'>dto</th>"
					  +  "		<th class='taC' style='width:100px;'>importe</th>"
					  +  "	</tr>";
		var js = JSON.parse("["+PedidoDetalle.replace(/}{/g,"},{")+"]");
		for(var i in js){
			var importe = parseInt(js[i].unidades) * parseFloat(js[i].precio);
			if(parseFloat(js[i].peso)>0){ importe = parseFloat(js[i].peso) * parseFloat(js[i].precio) }
			var dto = (importe * parseFloat(js[i].dto) )/100;
			importe = importe - dto;
			elTotal += importe;
			var peso = parseFloat(js[i].peso).toFixed(2);
			var precio = parseFloat(js[i].precio).toFixed(2);
			var dto1 = parseFloat(js[i].dto).toFixed(2);
			
			contenido += "	<tr>"
					  +  "		<td class='taC'>"
					  +  "			<img src='./Merlos/images/cerrarRed.png' class='curP' width='20' "
					  +  "			onclick='PedidoEliminarLinea(\""+js[i].codigo+"\")'>"
					  +  "		</td>"
					  +  "		<td>"+js[i].codigo+"</td>"
					  +  "		<td class='taR'>"+js[i].unidades+"</td>"
					  +  "		<td class='taR'>"+peso+"</td>"
					  +  "		<td class='taR'>"+precio+" &euro;</td>"
					  +  "		<td class='taR'>"+dto1+"</td>"
					  +  "		<td class='taR'>"+importe.toFixed(2)+" &euro;</td>"
					  +  "	</tr>";
		}
		contenido 	  += "<tr><th colspan='2'></th><th colspan='4'>TOTAL PEDIDO</th><th class='taR'>"+elTotal.toFixed(2)+"</th></tr></table>"
		$("#dvPedidoDetalle").html(contenido);
	}else{$("#dvPedidoDetalle").html("<div style='padding:10px; color:red;'>Sin Lineas para el pedido!</div>");}
}

function PedidoEliminarLinea(cd){
	var js = JSON.parse("["+PedidoDetalle.replace(/}{/g,"},{")+"]");
	var nuevoP = "";
	for(var i in js){
		if(js[i].codigo!==cd){ nuevoP += '{"codigo":"'+js[i].codigo+'","unidades":"'+js[i].unidades+'","peso":"'+js[i].peso+'","precio":"'+js[i].precio+'","dto":"'+js[i].dto+'","importe":"'+js[i].importe+'"}'; }
	}
	PedidoDetalle = nuevoP;
	pedidoVerDetalle();
}

function terminarLlamada(){
	if(ClienteCodigo===""){ alert("No hay un cliente activo!"); return; }
	var contacto = ($.trim($("#inpDataContacto").val())).split(" - ")[0];
	if(PedidoDetalle.length>0 && PedidoGenerado===""){
		var fff = $.trim($("#inpFechaEntrega").val());
		if(fff!==""){
			if(!existeFecha(fff)){ alert("Ups! Parece que la fecha no es correcta!"); return; }
			if(!validarFechaMayorActual(fff)){ alert("La fecha debe ser posterior a hoy!"); return; }
		}
		abrirVelo(icoCargando16 + " generando el pedido..."); 
		var lasLineas = (limpiarCadena(PedidoDetalle)).replace(/}{/g,"},{").replace(/{/g,"_openLL_").replace(/}/g,"_closeLL_");
		var Values = '<Row rowId="elRowDelObjetoPedido" ObjectName="Pedido">'
					+	'<Property Name="MODO" Value="Pedido"/>'
					+	'<Property Name="FechaTV" Value="'+FechaTeleVenta+'"/>'
					+	'<Property Name="NombreTV" Value="'+NombreTeleVenta+'"/>'
					+	'<Property Name="IDPEDIDO" Value="'+PedidoActivo+'"/>'
					+	'<Property Name="EMPRESA" Value="'+flexygo.context.CodigoEmpresa+'"/>'
					+	'<Property Name="CLIENTE" Value="'+ClienteCodigo+'"/>'
					+	'<Property Name="SERIE" Value="'+SERIE+'"/>'
					+	'<Property Name="CONTACTO" Value="'+contacto+'"/>'
					+	'<Property Name="INCICLI" Value="'+$.trim(($("#inciCliente").val()).split(" - ")[0])+'"/>'
					+	'<Property Name="INCICLIDescrip" Value="'+$.trim(($("#inciCliente").val()).split(" - ")[1])+'"/>'
					+	'<Property Name="ENTREGA" Value="'+$.trim($("#inpFechaEntrega").val())+'"/>'
					+	'<Property Name="VENDEDOR" Value="'+elVendedor+'"/>'
					+	"<Property Name='LINEAS' Value='"+lasLineas+"'/>"
					+	"<Property Name='OBSERVACIO' Value='"+limpiarCadena($.trim($("#taObservacionesDelPedido").val()))+"'/>"
					+'</Row>';
					/**/ console.log("pedido detalles:\n"+lasLineas);
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
		return;
	}
	var incidenciasSinPedido = "";
	if(PedidoGenerado==="" && PedidoDetalle===""){
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
	var parametros = '{"modo":"terminar","cliente":"'+ClienteCodigo+'","FechaTeleVenta":"'+FechaTeleVenta+'","nombreTV":"'+NombreTeleVenta+'"'
					+',"incidenciaCliente":"'+incidenciaCliente+'","incidenciaClienteDescrip":"'+incidenciaClienteDescrip+'","observaciones":"'+observaciones+'"'
					+',"pedido":"'+pedido+'","empresa":"'+CodigoEmpresa+'","serie":"'+SERIE+'"'+incidenciasSinPedido+','+paramStd+'}';

	flexygo.nav.execProcess('pLlamadas','',null,null,[{'key':'parametros','value':limpiarCadena(parametros)}],'modal640x480',false,$(this),function(ret){
		if(ret){ 
			if(ctvll==="llamadasDelCliente"){ flexygo.nav.openPage('list','Clientes','(BAJA=0)',null,'current',false,$(this)); $("#mainNav").show(); }
			else{ inicioTeleVenta(); }			
		}else{ alert("Error SP: pLlamadas!!!"+JSON.stringify(ret)); }
	},false);
}

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

function incidencia(modo,id){
	$("#dvIncidenciasTemp").remove();
	if(modo==="obs"){
		var uds = $.trim($("#tbArtDispTR"+id.split("inpObservaSol")[1]).find(".inpCantSol").val());
		if(uds==="" || parseInt(uds)===0 || isNaN(uds)){ return; }
		$("body").prepend(
			 "<div id='dvIncidenciasTemp' class='dvTemp'>"
			+"	<textarea style='width:100%;height:130px;padding:5px;box-sizing:border-box;' placeholder='Observaciones del producto'></textarea>"
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
						+ "	<input type='text' id='inpAnyadirCli' placeholder='buscar...' onkeyup='buscarEn(this.id,\"dvAnyadirCli\")'>"
						+ "	<div id='dvAnyadirCli' style='height:250px; overflow:hidden; overflow-y:auto;'><div class='taC vaM'>"+icoCargando16+" cargando clientes...</div></div>"
						+ "</div>");
	flexygo.nav.execProcess('pClientesBasic','',null,null,[{'key':'usuario','value':currentReference},{'key':'rol','value':currentRole}],'modal640x480',false,$(this),function(ret){
		if(ret){ 
			var contenido = "";
			var js = JSON.parse(limpiarCadena(ret.JSCode));
			if(js.clientes.length>0){
				for(var i in js.clientes){ 
					contenido += "<div class='dvSub' onclick='dvAnyadirCli_Click(\""+js.clientes[i].codigo+"\")'>"+js.clientes[i].codigo+" - "+js.clientes[i].nombre+"</div>";
				}
			}else{ contenido = "<div style='text-align:center; color:red;'>Sin resultados!</div>";}
			$("#dvAnyadirCli").html(contenido)
		}else{ alert("Error SP: pClientesBasic!!!"+JSON.stringify(ret)); }
	},false);
}

function dvAnyadirCli_Click(cliente){
	$("#dvLlamadas").html("<div class='taC vaM'>"+icoCargando16+" añadiendo el cliente "+cliente+" al listado...</div>");
	var parametros = '{"modo":"anyadirCliente","nombreTV":"'+NombreTeleVenta+'","FechaTeleVenta":"'+FechaTeleVenta+'"'
					+',"cliente":"'+cliente+'",'+paramStd+'}';
	flexygo.nav.execProcess('pLlamadas','',null,null,[{'key':'parametros','value':limpiarCadena(parametros)}],'modal640x480',false,$(this),function(ret){
		if(ret){
			if(ret.JSCode==="clienteExiste!"){ alert("El cliente ya existe en la lista actual!"); }
			recargarTVLlamadas();
		}else{ alert("Error SP: pLlamadas - dvAnyadirCli_Click!!!"+JSON.stringify(ret)); }
	},false);
}