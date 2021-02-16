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
				var js = JSON.parse(limpiarCadena(ret.JSCode));
				var contenido = "<table class='tbStdP'>"
							  + "	<tr>"
							  + "		<th>Usuario</th>"
							  + "		<th class='C'>Fecha</th>"
							  + "		<th>Pedido</th>"
							  + "		<th>Importe</th>"
							  + "	</tr>";
				if(js.length>0){
					for(var i in js){
						var  laLetra= $.trim(js[i].idpedido).substring(6,8);
						var elImporte = parseFloat($.trim(js[i].ic[0].importe)).toFixed(2);
						var elPedido = $.trim(js[i].pedido);
						if(elPedido==="NO!"){ elPedido="Sin Pedido"; } else { elPedido = laLetra+"-"+elPedido}
						if(isNaN(elImporte)){ elImporte= ""; } else {elImporte = elImporte+" &euro;";}
						contenido +="<tr title='"+$.trim(js[i].observa)+"'>"
								  + "	<td>"+$.trim(js[i].usuario)+"</td>"
								  + "	<td class='C'>"+$.trim(js[i].fecha)+"</td>"
								  + "	<td>"+elPedido+"</td>"
								  + "	<td class='R'>"+elImporte+"</td>"
								  + "</tr>";
					}
					contenido += "</table>";
				}else{ contenido = "<span style='color:#1f8eee;'>Sin registros de llamadas!</span>"; }
			
			$("#dvRegLlamadas").html(contenido);
		}else{ alert("Error SP: pLlamadas - llamadasDelCliente !!!"+JSON.stringify(ret)); }	
	},false);
}


</script>