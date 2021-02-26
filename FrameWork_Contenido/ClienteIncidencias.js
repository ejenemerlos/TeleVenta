<div id="dvRegInci"></div>

<script>
cargarIncidenciasCliente();
function cargarIncidenciasCliente(){
	$("#dvRegInci").html(icoCargando16+" <span class='fadeIO' style='color:#1f8eee;'>cargando datos...</span>"); 
	var ClienteCodigo = $.trim($("#spanClienteCodigo").text());
	if(ClienteCodigo===undefined || ClienteCodigo===""){ setTimeout(function(){ cargarIncidenciasCliente(); },100); return; }
	var parametros = '{"modo":"incidenciasDelCliente","cliente":"'+ClienteCodigo+'"}';
	flexygo.nav.execProcess('pLlamadas','',null,null,[{'key':'parametros','value':limpiarCadena(parametros)}],'modal640x480',false,$(this),function(ret){
		if(ret){	/**/ console.log("pLlamadas incidenciasDelCliente re:\n"+limpiarCadena(ret.JSCode));
			var js = JSON.parse(limpiarCadena(ret.JSCode));
			var inciArtNum = js.inciArt.length;
			var inciPedNum = js.inciPed.length;
			
			var inciArtCont = "<table class='tbStd'>"
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
				inciArtCont +="<tr title='"+obs+"'>"
						    + "	<td>"+js.inciArt[a].c[0].fecha+"</td>"
						    + "	<td>"+js.inciArt[a].articulo+" - "+js.inciArt[a].c[0].ia[0].va[0].nArticulo+"</td>"
						    + "	<td>"+inciArtDesc+"</td>"
						    + "	<td>"+inciArtObs+"</td>"
						    + "</tr>"; 
			}
			inciArtCont +="</table><br><br>";
			
			var inciPedCont = "<table class='tbStd'>"
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
			
			var contenido = "<div id='dvIncidenciasCliente'>"
						  + "	<div class='dvSub' onclick='incidenciasIO(\"dvInciArt\",\""+inciArtNum+"\")'>Incidencias de Artículos ("+inciArtNum+")</div>"
						  + "	<div id='dvInciArt' class='dvInci inv' style='max-height:350px;overflow:hidden;overflow-y:auto;'>"+inciArtCont+"</div>"
						  + "	<div class='dvSub' onclick='incidenciasIO(\"dvInciPed\",\""+inciPedNum+"\")'>Incidencias de Pedidos ("+inciPedNum+")</div>"
						  + "	<div id='dvInciPed' class='dvInci inv' style='max-height:350px;overflow:hidden;overflow-y:auto;'>"+inciPedCont+"</div>"
						  + "</div>";
			$("#dvRegInci").html(contenido);
		}else{ alert("Error SP: pLlamadas!!!"+JSON.stringify(ret)); }	
	},false);
}


function incidenciasIO(dv, nm) {
    if (parseInt(nm) > 0) {
        $("#" + dv).stop();
        if ($("#" + dv).is(":visible")) { $("#" + dv).slideUp(); }
        else { $(".dvInci").hide(); $("#" + dv).slideDown(); }
    }
}
</script>