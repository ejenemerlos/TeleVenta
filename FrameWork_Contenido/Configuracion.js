<style>
	#tbConfigMenu tr th {padding:2px 6px;}
	.separador { width:30px;}

	.tPersP{ font: bold 14px arial; color:#333; }
	.tPersP:hover{ color:#A9C5EB; cursor:pointer; }

	#tbConfigBBDD th, #tbConfigBBDD td {padding:4px;}
	#tbConfigBBDD th {font:14px arial; color:#333; }
	#tbConfigBBDD td input { width:130px; text-align:center; border:1px solid #ccc; }
</style>

<script>
	if(flexygo.context.currentRole!=="Admins"){ flexygo.nav.openPageName('TeleVenta','','',null,'current',false,$(this)); }
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
			<tr>
			<th>Meses de consumo</th>
			<td>
				&nbsp;&nbsp;
				<input type="text" id="inpMesesConsumo" class="C esq05" style="width:30px; font:bold 14px arial;" value="1" readonly>
				&nbsp;&nbsp;
				&nbsp;<div class="icoMenos img20" onclick="masmenos(false,'inpMesesConsumo',1,12)"></div>
				&nbsp;<div class="icoMas img20" onclick="masmenos(true,'inpMesesConsumo',1,12)"></div>
				&nbsp;&nbsp;<span class="MIbotonGreen esq05" onclick="asignarMesesConsumo()">asignar</span>
				<span id="spanAsignacionAviso" class="inv" style="font:bold 14px arial; color:green;">&nbsp;&nbsp; asignación correcta!</span>
			</td>
		</tr>
			<th>Serie Pedidos</th>
			<td>
				&nbsp;&nbsp;
				<input type="text" id="inpSerie" class="C esq05" style="width:80px; font:bold 14px arial;" onclick="inpDatos_Click('Serie'); event.stopPropagation();" readonly>
				<div id="dvSerieListado" class="dvListaDatos"></div>
				<span id="spanAsignacionSerieAviso" class="inv" style="font:bold 14px arial; color:green;">&nbsp;&nbsp; asignación correcta!</span>
			</td>
		</tr>		
		<tr>
			<th>Tarifa mínima</th>
			<td>
				&nbsp;&nbsp;
				<input type="text" id="inpTarifaMinima" class="C esq05" style="width:80px; font:bold 14px arial;" onclick="inpDatos_Click('TarifaMinima'); event.stopPropagation();" readonly>
				<div id="dvTarifaMinimaListado" class="dvListaDatos"></div>
				<span id="spanAsignacionTarifaMinimaAviso" class="inv" style="font:bold 14px arial; color:green;">&nbsp;&nbsp; asignación correcta!</span>
			</td>
		</tr>
		<tr>
			<th></th>
			<td></td>
		</tr>
		<tr>
			<th style="height:20px;"></th>
			<td>
				<img src="./Merlos/images/BtnDesO.png" id="imgNoCobrarPortes" class="OpcionIO"> No Cobrar Portes
				&nbsp;&nbsp;&nbsp;
				<img src="./Merlos/images/BtnDesO.png" id="imgMostrarStockVirtual" class="OpcionIO"> Mostrar Stock Virtual
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
		 '<img src="./Merlos/images/icoCarga.png" class="rotarR" width="30">'
		+'<br><br><span class="info">cargando datos, espera, por favor...</span>';
	abrirVelo(veloContenido,400);
	
	var SeriesCargadas = false;
	var TarifasCargadas = false;
	var elementosDIV = ["dvSerieListado","dvTarifaMinimaListado"];
	
	$(document).on("click",function(e) {
		for(var i in elementosDIV){
			var container = $("#"+elementosDIV[i]);
			if (!container.is(e.target) && container.has(e.target).length === 0) { $("#"+elementosDIV[i]).stop().slideUp(); }
		}
	});
	
	// Comprobar que exista una configuración de BBDD de Datos
	flexygo.nav.execProcess('pConfigPrimeraBBDD','',null,null, [{'Key':'modo','Value':'verificar'}], 'modal640x480', false, $(this), function(ret){ 
		if(ret){
			if(ret.JSCode.trim()!==""){
				$("#mainNav").show();
				cargarConfiguracion();
			}else{
				// -- si no existe mostramos el formulario para entrar los datos
				cerrarVelo(); 
				$("#mainNav").hide();
				$("#dvBBDD").fadeIn();
				cargarComunes();
			}
		}else{ alert('Error S.P. pConfigPrimeraBBDD!!!\n'+JSON.stringify(ret)); } 			
	}, false);
	
	function cargarComunes(){
		var contenido = "<option value=''></option>";
		var elC = "red";
		$("#selComun").html("<option value=''>cargando comunes...</option>").css("color",elC);
		flexygo.nav.execProcess('pComunes','',null,null, 
		[{'Key':'modo','Value':'lista'}]
		, 'modal640x480', false, $(this), function(ret){ if(ret){ 
			var elJS = JSON.parse(limpiarCadena(ret.JSCode));
			if(elJS.comunes.length>0){ 
				for(var i in elJS.comunes){
					contenido += "<option value='"+elJS.comunes[i].nombre+"'>"+elJS.comunes[i].nombre+"</option>";
				}
				elC = "#333";
			}else{ contenido = "<option value=''>Sin resultados!</option>";}
			$("#selComun").html(contenido).css("color",elC);
		} }, false);
	}
	
	function cargarEmpresas(){
		var contenido = "<option value=''></option>";
		var elC = "red";
		var bdComunes = $.trim($("#selComun").val());
		$("#selEmpresas").html("<option value=''>cargando empresas...</option>").css("color",elC);
		flexygo.nav.execProcess('pEmpresas','',null,null, 
		[{'Key':'modo','Value':'lista'},{'Key':'comun','Value':bdComunes}]
		, 'modal640x480', false, $(this), function(ret){ if(ret){ 
			var elJS = JSON.parse(limpiarCadena(ret.JSCode));
			if(elJS.empresas.length>0){ 
				for(var i in elJS.empresas){
					contenido += "<option value='"+elJS.empresas[i].codigo+"'>"+elJS.empresas[i].codigo+" - "+elJS.empresas[i].nombre+"</option>";
				}
				elC = "#333";
			}else{ contenido = "<option value=''>Sin resultados!</option>";}
			$("#selEmpresas").html(contenido).css("color",elC);
		} }, false);
	}	
	
	function configuracionAviso(){ $("#dvBBDD01").fadeIn();	$("#dvConfigBBDD").hide(); }

	function lanzarConfiguracion(paso){	
		var comun    = $.trim($("#selComun").val()); 
		var empresa  = $.trim($("#selEmpresas").val()); 
		var nEmpresa = $.trim($('select[id="selEmpresas"] option:selected').text()); 
		var numEjer  = $.trim($('#selNumEjercicios').val()); 
		if(!paso){ verificarVersionEW(comun); return; }
		
		veloContenido =  "<img src='./Merlos/images/icoCarga.png' class='rotarR' width='30'><br><br>configurando el portal, por favor, espera...";
		abrirVelo(veloContenido,400);
		
		flexygo.nav.execProcess('pConfiguracionLanzar','',null,null
		, [{'Key':'comun','Value':comun},{'Key':'empresa','Value':empresa}]
		, 'modal640x480', false, $(this), function(ret){ 
			if(ret){ 
				var elJS = JSON.parse(limpiarCadena(ret.JSCode));		
				var ejercicio = elJS.ejercicio;
				var letra     = elJS.letra;
				var gestion   = elJS.gestion;
				var comun     = elJS.comun;
				var campos    = elJS.campos;
				flexygo.nav.execProcess('pConfigBBDD','',null,null, 
					[
					 {'Key':'modo','Value':'actualizar'}
					,{'Key':'accion','Value':'todo'}
					,{'Key':'ejercicio','Value':ejercicio}
					,{'Key':'gestion','Value':gestion}
					,{'Key':'letra','Value':letra}
					,{'Key':'comun','Value':comun}
					,{'Key':'campos','Value':campos}
					,{'Key':'empresa','Value':empresa}
					,{'Key':'nEmpresa','Value':nEmpresa}
					,{'Key':'numEjer','Value':numEjer}
					]
					, 'modal640x480', false, $(this), function(ret){
					if(ret){ 
						$(".configSeccion").hide(); $("#dvConfiguracion").fadeIn(); 
						if(ret.JSCode!==""){ alert(ret.JSCode); }
						else{ cerrarVelo(); }
						limpiarLaCache();
						//$("#mainNav").show();
						flexygo.nav.execProcess('GoHome','','',null,null,'current',false,$(this));
					}else{ alert('Error S.P. pConfigBBDD!!!\n'+ret); } }, false);					
			}else{ alert('Error S.P. pConfiguracionLanzar!!!\n'+ret); } 			
		}, false);
	}
	
	function verificarVersionEW(comun){
		/***** */ lanzarConfiguracion(true); return; /****** */
		flexygo.nav.execProcess('pVersiones','',null,null, 
		[
		 {'Key':'modo','Value':'EW'}
		,{'Key':'comun','Value':comun}
		]
		, 'modal640x480', false, $(this), function(ret){
		if(ret){ 
			var version = parseInt(ret.JSCode.split(".")[2]);
			if(parseInt(version)>=7502){ lanzarConfiguracion(true); }
			else{ 
				alert("Esta versión de Eurowin\n"
					 +"no es compatible con este producto!"); 
			}
		}else{ alert('Error S.P. pVersiones!!!\n'+ret); } }, false);
	}		
		
	function tAhora() {	var d = new Date();	var n = d.getTime(); return n; }	
	
	function configurarElPortal_Click(){
		veloContenido =  "El portal se va a configurar"
						+"<br>con los datos seleccionados."
						+"<br><br><br>"
						+"<span class='MIbotonOrange' onclick='lanzarConfiguracion(false)'>configurar</span>"
						+"&nbsp;&nbsp;&nbsp;<span class='MIbotonRed' onclick='cerrarVelo()'>cancelar</span>";
		abrirVelo(veloContenido,400);
	}
	
	function reconfigurar_Click(){
		veloContenido =  "Se eliminará la base de datos actual"
						+"<br>y se pedirán de nuevo los datos"
						+"<br>de configuración."
						+"<br><br><br>"
						+"<span class='MIbotonOrange' onclick='reconfigurarElPortal()'>reconfigurar</span>"
						+"&nbsp;&nbsp;&nbsp;<span class='MIbotonRed' onclick='cerrarVelo()'>cancelar</span>";
		abrirVelo(veloContenido,400);
	}
	
	function inpDatos_Click(inp){
		$(".dvListaDatos").hide();
		$("#dv"+inp+"Listado").stop().slideDown();
	}
	
	function asignarMesesConsumo(){
		MesesConsumo = $("#inpMesesConsumo").val();
		var parametros = '{"modo":"MesesConsumo","valor":"'+$("#inpMesesConsumo").val()+'"}';
		flexygo.nav.execProcess('pConfiguracion','',null,null,[{'Key':'parametros','Value':limpiarCadena(parametros)}],'modal640x480',false,$(this),function(ret){if(ret){ 
			cargarConfiguracion(); 
			$("#spanAsignacionAviso").fadeIn(); setTimeout(function(){ $("#spanAsignacionAviso").fadeOut(); },2000);
		}else{ alert('Error S.P. pConfiguracion - MesesConsumo!!!\n'+ret); } }, false);
	}
	
	function cargarConfiguracion(){
		var parametros = '{"modo":"lista"}';
		flexygo.nav.execProcess('pConfiguracion','',null,null,[{'Key':'parametros','Value':limpiarCadena(parametros)}],'modal640x480',false,$(this),function(ret){if(ret){ 
			var js = JSON.parse(limpiarCadena(ret.JSCode));
			esperarCargaSeries(js.ConfSQL[0].TVSerie);
			esperarCargaTarifas(js.ConfSQL[0].TVTarifa);
			$("#inpMesesConsumo").val(js.ConfSQL[0].MesesConsumo); 
			$("#dvConfiguracion").fadeIn();
			cargarSeries();
			cargarTarifas();
			// Interruptores
			for(var i in js.IO){
				if(parseInt(js.IO[i].valor)===0){window["Conf"+js.IO[i].nombre]=0; $("#img"+js.IO[i].nombre).attr("src",BtnDesO); }
				else{window["Conf"+js.IO[i].nombre]=1; $("#img"+js.IO[i].nombre).attr("src",BtnDesI); }
			}
			if(ConfNoCobrarPortes===1 || window["ConfNoCobrarPortes"]===1){ $("#spNoCobrarPortes").show(); }else{ $("#spNoCobrarPortes").hide(); }
			cerrarVelo();
			limpiarLaCache();
		}else{ alert("Error SP: pConfiguracion - lista!!!\n"+ret); }}, false);
	}
	
	function reconfigurarElPortal(){
		veloContenido =  '<img src="./Merlos/images/icoCarga.png" class="rotarR" width="30">'
						+'<br><br><span class="info">reconfigurando, espera, por favor...</span>';
		abrirVelo(veloContenido,400);
		var parametros = '{"modo":"reconfigurar"}';
		flexygo.nav.execProcess('pConfiguracion','',null,null,[{'Key':'parametros','Value':limpiarCadena(parametros)}],'modal640x480',false,$(this),function(ret){
			if(ret){ location.reload();  }
		}, false);
	}
	
	
	function cargarSeries(){
		var contenido = "";
		flexygo.nav.execProcess('pSeries','',null,null,[{'Key':'modo','Value':'Serie'}], 'modal640x480', false, $(this), function(ret){if(ret){
			var js = JSON.parse(ret.JSCode);
			if(js.length>0){
				for(var i in js){ contenido += "<div class='dvLista' onclick='asignarSerie(\""+js[i].codigo+"\")'>"+js[i].codigo+" - "+js[i].nombre+"</div>"; }
			}else{ contenido="<div style='color:red;'>Sin resultados!</div>"; }
			$("#dvSerieListado").html(contenido);
			SeriesCargadas=true;
		}else{ alert('Error S.P. pSeries!!!\n'+ret); } }, false);
	}
	function esperarCargaSeries(serie){
		if(SeriesCargadas){ $("#inpSerie").val(serie); }
		else{ setTimeout(function(){ esperarCargaSeries(serie); },200); }
	}
	function asignarSerie(serie){
		SERIE = serie;
		var parametros = '{"modo":"TVSerie","valor":"'+serie+'"}';
		flexygo.nav.execProcess('pConfiguracion','',null,null,[{'Key':'parametros','Value':limpiarCadena(parametros)}],'modal640x480',false,$(this),function(ret){if(ret){ 
			$("#inpSerie").val(serie);
			$("#dvSerieListado").stop().slideUp();
			$("#spanAsignacionSerieAviso").fadeIn(); 
			limpiarLaCache();
			setTimeout(function(){ $("#spanAsignacionSerieAviso").fadeOut(); },2000);
		}else{ alert("Error SP: pConfiguracion - TVSerie!!!\n"+ret); }}, false);
	}
	
	function cargarTarifas(){
		var contenido = "";
		flexygo.nav.execProcess('pObjetoDatos','',null,null,[{'Key':'elJS','Value':'{"objeto":"Tarifas"}'}], 'modal640x480', false, $(this), function(ret){if(ret){
			var js = JSON.parse(ret.JSCode);
			if(js.length>0){
				for(var i in js){ contenido += "<div class='dvLista' onclick='asignarTarifa(\""+js[i].CODIGO+"\")'>"+js[i].CODIGO+" - "+js[i].NOMBRE+"</div>"; }
			}else{ contenido="<div style='color:red;'>Sin resultados!</div>"; }
			$("#dvTarifaMinimaListado").html(contenido);
			TarifasCargadas=true;
		}else{ alert('Error S.P. pTarifas!!!\n'+ret); } }, false);
	}
	function esperarCargaTarifas(tarifa){
		if(TarifasCargadas){ $("#inpTarifaMinima").val(tarifa); }
		else{ setTimeout(function(){ esperarCargaTarifas(tarifa); },200); }
	}
	function asignarTarifa(tarifa){
		TARIFA = tarifa;
		var parametros = '{"modo":"TVTarifa","valor":"'+tarifa+'"}';
		flexygo.nav.execProcess('pConfiguracion','',null,null,[{'Key':'parametros','Value':limpiarCadena(parametros)}],'modal640x480',false,$(this),function(ret){if(ret){ 
			$("#inpTarifaMinima").val(tarifa);
			$("#dvTarifaMinimaListado").stop().slideUp();
			$("#spanAsignacionTarifaAviso").fadeIn(); 
			limpiarLaCache();
			setTimeout(function(){ $("#spanAsignacionTarifaAviso").fadeOut(); },2000);
		}else{ alert("Error SP: pConfiguracion - TVTarifa!!!\n"+ret); }}, false);
	}

	
	$(".OpcionIO").off().on("click",function(){
		var v = $(this).attr("id");
		var nombre = v.split("img")[1];
		if(window["Conf"+nombre]===0){window["Conf"+nombre]=1; $("#"+v).attr("src",BtnDesI); }else{window["Conf"+nombre]=0; $("#"+v).attr("src",BtnDesO); }
		ConfiguracionDelPortal('actualizar',nombre,eval(window["Conf"+nombre]));
	});
	
	function ConfiguracionDelPortal(modo,nombre,valor){
		var parametros = '{"modo":"actualizar","nombre":"'+nombre+'","valor":"'+valor+'"}';
		flexygo.nav.execProcess('pConfiguracion','',null,null,[{'Key':'parametros','Value':limpiarCadena(parametros)}],'modal640x480',false,$(this),function(ret){if(ret){
			cargarConfiguracion(); 
		}else{ alert('Error S.P. pConfiguracion -actualizar !!!\n'+ret); } }, false);
	}
</script>