<div id="dvRegInci"></div>

<script>
cargarIncidenciasCliente();
function cargarIncidenciasCliente(){
	$("#dvRegInci").html(icoCargando16+" <span class='fadeIO' style='color:#1f8eee;'>cargando datos...</span>"); 
	var ClienteCodigo = $.trim($("#spanClienteCodigo").text());
	if(ClienteCodigo===undefined || ClienteCodigo===""){ setTimeout(function(){ cargarIncidenciasCliente(); },100); return; }
	var parametros = '{"modo":"incidenciasDelCliente","cliente":"'+ClienteCodigo+'"}';
	flexygo.nav.execProcess('pLlamadas','',null,null,[{'key':'parametros','value':limpiarCadena(parametros)}],'modal640x480',false,$(this),function(ret){
		if(ret){	
			var js = JSON.parse(ret.JSCode);
			var inciArtNum = js.inciArt.length;
			var inciPedNum = js.inciPed.length;
			
			var inciArtCont = "<table class='tbStd'>"
							+ "<tr>"
						    + "	<th>Fecha</th>"
						    + "	<th>Artículo</th>"
						    + "	<th>Incidencia</th>"
						    + "</tr>"; 
			for(var a in js.inciArt){ 
				var obs = js.inciArt[a].observaciones; if(obs===null){ obs=""; }
				inciArtCont +="<tr title='"+obs+"'>"
						    + "	<td>"+js.inciArt[a].fecha+"</td>"
						    + "	<td>"+js.inciArt[a].articulo+"</td>"
						    + "	<td>"+js.inciArt[a].incidencia+" - "+js.inciArt[a].descripcion+"</td>"
						    + "</tr>"; 
			}
			inciArtCont +="</table><br><br>";
			
			var inciPedCont = "<table class='tbStd'>"
							+ "<tr>"
						    + "	<th>Fecha</th>"
						    + "	<th>Incidencia</th>"
						    + "</tr>"; 
			for(var b in js.inciPed){ 
				obs = js.inciPed[b].observaciones; if(obs===null){ obs=""; }
				inciPedCont +="<tr title='"+obs+"'>"
						    + "	<td>"+js.inciPed[b].fecha+"</td>"
						    + "	<td>"+js.inciPed[a].incidencia+" - "+js.inciPed[a].descripcion+"</td>"
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