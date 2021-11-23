<div id="dvOpcionesTV" class="tvTitulo esq1100" style="padding:10px; box-sizing:border-box;">
	<div id="tbOpciones" style="overflow:hidden;">
		<div id="dvFechaTV" class="esq10" style="float:left; background:#FFF; padding:5px 10px; white-space:nowrap; font:bold 32px arial; color:#68CDF9;"></div>
		<div id="dvSerieTV" class="esq10" style="float:left; margin-left:15px; background:#FFF; padding:5px 10px; white-space:nowrap; font:bold 32px arial; color:#68CDF9; vertical-align:middle;"></div>
		<div style="float:right; display:flex; align-items:center; justify-content:flex-end; gap:5px;">
			<div id="btnTerminar" class="MIbotonW FR vaM inv" onclick='terminarLlamada()' style="white-space:nowrap;">Terminar Llamada</div>
			<div id="btnPedido" class="MIbotonW FR vaM inv" onclick='pedidoTV()'>Pedido</div>
			<div id="btnClientes" class="MIbotonW FR vaM inv" onclick='cargarClientes()'>Clientes</div>
			<div id="btnConfiguracion" class="MIbotonW FR vaM inv" onclick='configurarTeleVenta()'>Configuración</div>
		</div>
	</div>
	<div style="margin-top:10px;">
		<div id="dvEstTV" class="vaM" style="padding:0;white-space:nowrap; font:bold 16px arial; color:#FFF;" ></div>
		<div id="dvFiltrosTV" class="vaM" style="padding:0;margin-top:8px;font:14px arial; color:#666;" ></div>
	</div>
</div>

<div id="dvConfiguracionTeleVenta" class="mi-module">
	<table id="tbConfiguracionOperador" class="tbFrm">
		<tr>
			<th colspan="2" class="thO" style="vertical-align:middle; text-align:left;">Nombre registro llamadas</th>
			<td colspan="6" id="inputDatosNombreTV">
				<input type="text" id="inpNombreTV" style="width:100%; text-align:left; color:#333;" onkeyup="autoNombreTV=false;">
			</td>
			<td style="vertical-align:middle; text-align:center;">
				<div class='img30 icoRecarga' onclick="resetFrm('OpcionesTV')"></div>
			</td>
		</tr>
		<tr>			
			<th style="width:11%;">Gestor &nbsp;<span class='img16 icoDownC'></span></th>
			<th style="width:11%;">Ruta &nbsp;<span class='img16 icoDownC'></span></th>
			<th>Vendedor &nbsp;<span class='img16 icoDownC'></span></th>
			<th style="width:11%;">Serie &nbsp;<span class='img16 icoDownC'></span></th>
			<th style="width:11%;">Marca &nbsp;<span class='img16 icoDownC'></span></th>
			<th style="width:11%;">Familia &nbsp;<span class='img16 icoDownC'></span></th>
			<th style="width:11%;">Subfamilia &nbsp;<span class='img16 icoDownC'></span></th>
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
if(FechaTeleVenta!==""){
	$("#inpFechaTV").val(FechaTeleVenta);
	$("#dvFechaTV").html(FechaTeleVenta).show();
}else{ $("#dvFechaTV").hide(); }
$("#dvSerieTV").html(SERIE + '&nbsp;<span id="btnSerieGlobal" class="img20 icoDownC" style="vertical-align:middle;" onclick="seriesTV()"></span>');

$("#tbConfiguracionOperador th").on("click",function(){ inputTbDatos(($(this).text()).split(" ")[0]); event.stopPropagation(); });

function cargarTbConfigOperador(modo,comprobar){
	var fecha = $.trim($("#inpFechaTV").val()); 
	var nombre = $.trim($("#inpNombreTV").val());	
	
	var elJS = '{"modo":"' + modo + '","IdTeleVenta":"' + IdTeleVenta + '","nombreTV":"' + nombre + '","fecha":"' + fecha + '",' + paramStd + '}';
	
	if(modo==="guardar" || modo==="recargar"){
		var objetos = ["Gestor","Ruta","Vendedor","Serie","Marca","Familia","Subfamilia"];
		for(var o in objetos){
			var tr = "";
			$("#inputDatos"+objetos[o]).find("div").each(function(){
				tr += '{"'+objetos[o]+'":"'+($(this).text()).split(" - ")[0]+'"}'; 
			});
			window["op"+objetos[o]] = '"'+objetos[o]+'":['+tr.replace(/}{/g,"},{")+']';
		}
		
		elJS = '{"modo":"' + modo + '","comprobar":"' + comprobar + '","IdTeleVenta":"' + IdTeleVenta + '","nombreTV":"' + nombre + '","fecha":"' + fecha + '"'
			 + ','+window["opGestor"]+','+window["opRuta"]+','+window["opVendedor"]+','+window["opSerie"]+','+window["opMarca"]+''
			 +','+window["opFamilia"]+','+window["opSubfamilia"]+',' + paramStd + '}';
	}
console.log(elJS);
	// Obtener Vendedor, Serie, Marca, Familia y Subfamilia
	flexygo.nav.execProcess('pOperadorConfig','',null,null,[{'Key':'elJS','Value':limpiarCadena(elJS)}],'modal640x480',false,$(this),function(ret){
		if (ret) {
			if(ret.JSCode==="nombreTV_Existe!"){ alert("El nombre ya existe en la base de datos!"); return; }
			
            var js = JSON.parse(limpiarCadena(ret.JSCode));   
			SERIE = js.serieActiva; 

			var gestores = "";
			for(var i in js.gestor){ gestores += "<div class='dvSub' onclick='inputTbDatosEliminar(\"Gestor\",\""+js.gestor[i].gestor+"\")'>"+js.gestor[i].gestor+"</div>"; }
			$("#inputDatosGestor").html(gestores);
			
			var rutas = "";
			for(var i in js.ruta){ rutas += "<div class='dvSub' onclick='inputTbDatosEliminar(\"Ruta\",\""+js.ruta[i].ruta+"\")'>"+js.ruta[i].ruta+"</div>"; }
			$("#inputDatosRuta").html(rutas);
			
			var vendedores = "";
			for(var i in js.vendedor){ vendedores += "<div class='dvSub' onclick='inputTbDatosEliminar(\"Vendedor\",\""+js.vendedor[i].vendedor+"\")'>"+js.vendedor[i].vendedor+"</div>"; }
			$("#inputDatosVendedor").html(vendedores);

			var series = "";
			for(var i in js.serie){ series += "<div class='dvSub' onclick='inputTbDatosEliminar(\"Serie\",\""+js.serie[i].serie+"\")'>"+js.serie[i].serie+"</div>"; }
			$("#inputDatosSerie").html(series);		

			var marcas = "";
			for(var i in js.marca){ marcas += "<div class='dvSub' onclick='inputTbDatosEliminar(\"Marca\",\""+js.marca[i].marca+"\")'>"+js.marca[i].marca+"</div>"; }
			$("#inputDatosMarca").html(marcas);

			var familias = "";
			for(var i in js.familia){ familias += "<div class='dvSub' onclick='inputTbDatosEliminar(\"Familia\",\""+js.familia[i].familia+"\")'>"+js.familia[i].familia+"</div>"; }
			$("#inputDatosFamilia").html(familias);

			var subfamilias = "";
			for(var i in js.subfamilia){ subfamilias += "<div class='dvSub' onclick='inputTbDatosEliminar(\"Subfamilia\",\""+js.subfamilia[i].subfamilia+"\")'>"+js.subfamilia[i].subfamilia+"</div>"; }
			$("#inputDatosSubfamilia").html(subfamilias);

			if(modo==="guardar"){ 
				cargarTeleVentaLlamadas("listaGlobal"); 
				if(js.llamUserReg==="0"){
					$("#inpNombreTV, #inpFechaTV").val("");
					alert("No se han encontrado llamadas con los parámetros seleccionados!");
				}
			}	
			if(modo==="recargar"){ recargarTVLlamadas(); }
        } else { alert('Error S.P. pOperadorConfig!\n' + JSON.stringify(ret)); }
    }, false);
}

function inputTbDatos(id){
	if(id==="Fecha" || id==="Nombre" || id===""){ return; }
	$("#dvinputDatosTemp").remove();
	$("body").prepend("<div id='dvinputDatosTemp' class='dvTemp'>"+icoCargando16 + "cargando datos...</div>");
	var y = ($("#inputDatos" + id).offset()).top;
	var x = ($("#inputDatos"+id).offset()).left;
	$("#dvinputDatosTemp").offset({top:y,left:x}).stop().fadeIn();	
	
	var contenido = "";
    var modo = id.toLowerCase().replace(" ", "_").normalize("NFD").replace(/[\u0300-\u036f]/g, "");
    var elJS = '{"modo":"' + modo + '",' + paramStd + '}';
	
    flexygo.nav.execProcess('pInpDatos', '', null, null, [{'Key':'elJS','Value':limpiarCadena(elJS)}], 'modal640x480', false, $(this), function(ret){
        if (ret) {
            var js = JSON.parse(limpiarCadena(ret.JSCode));
            if (js.length > 0) {
                for (var i in js) {
                    contenido += "<div class='dvLista' onclick='inputTbDatosAsignar(\""+id+"\",\""+js[i].codigo+" - "+$.trim(js[i].nombre)+"\")'>"
                        + js[i].codigo + " - " + js[i].nombre
                        + "</div>";
                }
            } else { contenido = "<div style='color:red;'>Sin resultados!</div>"; }
            $("#dvinputDatosTemp").html( contenido);
        } else { alert('Error S.P. pInpDatos!\n' + JSON.stringify(ret)); }
    }, false);
}
function inputTbDatosAsignar(id,valor){
	if(($("#inputDatos"+id).html()).indexOf(valor)===-1){
		var htmlVal = $("#inputDatos"+id).html();
		if(id==="Serie"){ htmlVal=""; }
		$("#inputDatos"+id).html( htmlVal + "<div class='dvSub' onclick='inputTbDatosEliminar(\""+id+"\",\""+valor+"\")'>"+valor+"</div>");
		if($.trim($("#inpNombreTV").val())===""){ autoNombreTV=true; }
		if(autoNombreTV){ 
			$("#inpNombreTV").val( ($("#inpNombreTV").val()).replace("+"+id,"").replace(id,"") +"+"+id);
			var elNom = $("#inpNombreTV").val();
			if(Left(elNom,1)==="+"){ $("#inpNombreTV").val(elNom.replace("+","")); }
		}
	}
	$("#dvinputDatosTemp").fadeOut(300,function(){ $("#dvinputDatosTemp").remove(); });
}
function inputTbDatosEliminar(id,valor){
	var contenido = "";
	$("#inputDatos"+id).find("div").each(function(){
		if($(this).text()!==valor){ 
			contenido += "<div class='dvSub' onclick='inputTbDatosEliminar(\""+id+"\",\""+$(this).text()+"\")'>"+$(this).text()+"</div>"; 
		}
	});
	$("#inputDatos"+id).html(contenido);
	if(autoNombreTV && contenido===""){ $("#inpNombreTV").val( ($("#inpNombreTV").val()).replace("+"+id,"").replace(id,"") ); }
	if(Left($("#inpNombreTV").val(),1)==="+"){ $("#inpNombreTV").val(($("#inpNombreTV").val()).replace("+","")); }
}

function guardarTeleVenta(tf){ 
	var nombre = $.trim($("#inpNombreTV").val());
	var fecha = $.trim($("#inpFechaTV").val());
	if(nombre===""){ alert("El nombre para el registro de llamadas es obligatorio!"); return; }
	if(fecha===""){ alert("La fecha es obligatoria!"); return; }
	FechaTeleVenta=fecha;
	$("#dvFechaTV").html(fecha);
	cargarTbConfigOperador("guardar",tf);
}

function seriesTV(){
	abrirVelo(icoCargando16+" cargando series...");
	var contenido = "";
	flexygo.nav.execProcess('pSeries','',null,null,[{'Key':'modo','Value':'Serie'}], 'modal640x480', false, $(this), function(ret){if(ret){
		var js = JSON.parse(ret.JSCode);
		if(js.length>0){
			for(var i in js){ contenido += "<div class='dvLista' onclick='asignarSerieGlobal(\""+js[i].codigo+"\")'>"+js[i].codigo+" - "+js[i].nombre+"</div>"; }
		}else{ contenido="<div style='color:red;'>Sin resultados!</div>"; }
		abrirVelo(contenido);
	}else{ alert('Error S.P. pSeries!!!\n'+ret); } }, false);
}

function asignarSerieGlobal(laSerie){
	SERIE = laSerie;
	$("#dvSerieTV").html(SERIE + '&nbsp;<span id="btnSerieGlobal" class="img20 icoDownC" style="vertical-align:middle;" onclick="seriesTV()"></span>');
	cerrarVelo();
}

</script>