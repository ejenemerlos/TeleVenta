
comprobarModuloClientePedidos();

function comprobarModuloClientePedidos(){ 
	if($("flx-module[modulename='Cliente_Pedidos']").is(":visible")){
		$("flx-module[modulename='Cliente_Pedidos'] .icon-minus").click();
		$("flx-module[modulename='Cliente_Pedidos'] div.cntBodyHeader, flx-module[modulename='Cliente_Pedidos'] div.cntBodyFooter").hide(); 		
	}else{ setTimeout(function(){ comprobarModuloClientePedidos(); },100); }
}

function verDetallePedidoCliente(idpedido,empresa,letra,numero,i){ 
	var elTR = "#trID";
	if($(elTR).is(":visible")){ return; }
	$(".VelotrID").remove();
	var y = event.clientY;	
	var pedido = letra+"-"+numero.trim();
	var contenido = icoCargando16+" cargando lineas del pedido "+pedido+"..."; 
	$("body").prepend("<div id='trID' class='VelotrID c_trID inv'>"+contenido+"</div>");
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