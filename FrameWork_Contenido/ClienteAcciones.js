<div>Registro de Llamadas</div>
<div id="dvRegLlamadas" style='max-height:280px;overflow:hidden;overflow-y:auto;'></div>

<script>
cargarLlamadasCliente();
function cargarLlamadasCliente(){
	$("#dvRegLlamadas").html(icoCargando16+" <span class='fadeIO' style='color:#1f8eee;'>cargando datos...</span>"); 
	var ClienteCodigo = $.trim($("#spanClienteCodigo").text());
	if(ClienteCodigo===undefined || ClienteCodigo===""){ setTimeout(function(){ cargarLlamadasCliente(); },100); return; }
	var parametros = '{"modo":"llamadasDelCliente","cliente":"'+ClienteCodigo+'"}';
	flexygo.nav.execProcess('pLlamadas','',null,null,[{'key':'parametros','value':limpiarCadena(parametros)}],'modal640x480',false,$(this),function(ret){
		if(ret){
			try{
				var js = JSON.parse(ret.JSCode);
				var contenido = "<table class='tbStdP'>"
							  + "	<tr>"
							  + "		<th>Fecha</th>"
							  + "		<th class='C'>Hora</th>"
							  + "		<th>Incidencia</th>"
							  + "	</tr>";
				if(js.length>0){
					for(var i in js){
						var laFecha = $.trim(js[i].fecha);
						if((laFecha.split("-")[0]).length===4){ laFecha = laFecha.substr(8,2)+"-"+laFecha.substr(5,2)+"-"+laFecha.substr(0,4); }
						var inci = js[i].ic[0].nIncidencia; if(inci===undefined){ inci=""; }
						var observa = js[i].ic[0].observa; if(observa===undefined){ observa=""; }
						contenido +="<tr title='"+observa+"'>"
								  + "	<td>"+laFecha+"</td>"
								  + "	<td class='C'>"+Left(js[i].hora,5)+"</td>"
								  + "	<td>"+inci+"</td>"
								  + "</tr>";
					}
					contenido += "</table>";
				}else{ contenido = "<span style='color:#1f8eee;'>Sin registros de llamadas!</span>"; }
			}
			catch{ console.log("pLlamadas - error JSON: "+ret.JSCode); }
			$("#dvRegLlamadas").html(contenido);
		}else{ alert("Error SP: pLlamadas!!!"+JSON.stringify(ret)); }	
	},false);
}


</script>